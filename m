Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711Ab2DLFhZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 01:37:25 -0400
Received: from ozlabs.org ([203.10.76.45]:52170 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756551Ab2DLFgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 01:36:48 -0400
From: David Gibson <david@gibson.dropbear.id.au>
To: rusty@rustcorp.com.au, mst@redhat.com
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        paulus@samba.org, qemu-devel@nongnu.org,
        David Gibson <david@gibson.dropbear.id.au>
Subject: [PATCH 3/3] virtio_balloon: Bugfixes for PAGE_SIZE != 4k
Date: Thu, 12 Apr 2012 15:36:35 +1000
Message-Id: <1334208995-29985-4-git-send-email-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1334208995-29985-1-git-send-email-david@gibson.dropbear.id.au>
References: <1334208995-29985-1-git-send-email-david@gibson.dropbear.id.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The virtio_balloon device is specced to always operate on 4k pages.  The
virtio_balloon driver has a feeble attempt at reconciling this with a
lerge kernel page size, but it is (a) exactly wrong (it shifts the pfn in
the wrong direction) and (b) insufficient (it doesn't issue multiple 4k
balloon requests for each guest page, or correct other accounting values
for the different in page size).

This patch fixes the various problems.  It has been tested with a powerpc
guest kernel configured for 64kB base page size, running under qemu.

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
---
 drivers/virtio/virtio_balloon.c |   32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 553cc1f..834b7f9 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -60,13 +60,20 @@ static struct virtio_device_id id_table[] = {
 	{ 0 },
 };
 
-static u32 page_to_balloon_pfn(struct page *page)
+#define BALLOON_PAGE_ORDER	(PAGE_SHIFT - VIRTIO_BALLOON_PFN_SHIFT)
+#define PAGES_PER_ARRAY(_a)	(ARRAY_SIZE(_a) >> BALLOON_PAGE_ORDER)
+
+static void page_to_balloon_pfns(u32 pfns[], unsigned int n, struct page *page)
 {
-	unsigned long pfn = page_to_pfn(page);
+	unsigned long bpfn = page_to_pfn(page) << BALLOON_PAGE_ORDER;
+	u32 *p = &pfns[n << BALLOON_PAGE_ORDER];
+	int i;
 
 	BUILD_BUG_ON(PAGE_SHIFT < VIRTIO_BALLOON_PFN_SHIFT);
-	/* Convert pfn from Linux page size to balloon page size. */
-	return pfn >> (PAGE_SHIFT - VIRTIO_BALLOON_PFN_SHIFT);
+
+	/* Enter a balloon pfn for each 4k subpage of the Linux page */
+	for (i = 0; i < (1 << BALLOON_PAGE_ORDER); i++)
+		p[i] = bpfn + i;
 }
 
 static void balloon_ack(struct virtqueue *vq)
@@ -84,7 +91,8 @@ static void tell_host(struct virtio_balloon *vb, struct virtqueue *vq,
 {
 	struct scatterlist sg;
 
-	sg_init_one(&sg, vb->pfns, sizeof(vb->pfns[0]) * n);
+	sg_init_one(&sg, vb->pfns,
+		    sizeof(vb->pfns[0]) * (n << BALLOON_PAGE_ORDER));
 
 	init_completion(&vb->acked);
 
@@ -102,7 +110,7 @@ static void fill_balloon(struct virtio_balloon *vb, size_t num)
 	unsigned int n;
 
 	/* We can only do one array worth at a time. */
-	num = min(num, ARRAY_SIZE(vb->pfns));
+	num = min(num, PAGES_PER_ARRAY(vb->pfns));
 
 	for (n = 0; n < num; n++) {
 		struct page *page = alloc_page(GFP_HIGHUSER | __GFP_NORETRY |
@@ -116,7 +124,7 @@ static void fill_balloon(struct virtio_balloon *vb, size_t num)
 			msleep(200);
 			break;
 		}
-		vb->pfns[n] = page_to_balloon_pfn(page);
+		page_to_balloon_pfns(vb->pfns, n, page);
 		totalram_pages--;
 		vb->num_pages++;
 		list_add(&page->lru, &vb->pages);
@@ -134,7 +142,7 @@ static void release_pages_by_pfn(const u32 pfns[], unsigned int num)
 	unsigned int i;
 
 	for (i = 0; i < num; i++) {
-		__free_page(pfn_to_page(pfns[i]));
+		__free_page(pfn_to_page(pfns[i << BALLOON_PAGE_ORDER]));
 		totalram_pages++;
 	}
 }
@@ -145,12 +153,12 @@ static void leak_balloon(struct virtio_balloon *vb, size_t num)
 	unsigned int n;
 
 	/* We can only do one array worth at a time. */
-	num = min(num, ARRAY_SIZE(vb->pfns));
+	num = min(num, PAGES_PER_ARRAY(vb->pfns));
 
 	for (n = 0; n < num; n++) {
 		page = list_first_entry(&vb->pages, struct page, lru);
 		list_del(&page->lru);
-		vb->pfns[n] = page_to_balloon_pfn(page);
+		page_to_balloon_pfns(vb->pfns, n, page);
 		vb->num_pages--;
 	}
 
@@ -244,13 +252,13 @@ static inline s64 towards_target(struct virtio_balloon *vb)
 	vb->vdev->config->get(vb->vdev,
 			      offsetof(struct virtio_balloon_config, num_pages),
 			      &v, sizeof(v));
-	target = le32_to_cpu(v);
+	target = le32_to_cpu(v) >> BALLOON_PAGE_ORDER;
 	return target - vb->num_pages;
 }
 
 static void update_balloon_size(struct virtio_balloon *vb)
 {
-	__le32 actual = cpu_to_le32(vb->num_pages);
+	__le32 actual = cpu_to_le32(vb->num_pages << BALLOON_PAGE_ORDER);
 
 	vb->vdev->config->set(vb->vdev,
 			      offsetof(struct virtio_balloon_config, actual),
-- 
1.7.9.5

