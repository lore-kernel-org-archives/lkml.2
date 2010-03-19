Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262Ab0CSUqt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 16:46:49 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:33929 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751957Ab0CSUqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 16:46:47 -0400
From: Dmitry Torokhov <dtor@vmware.com>
Subject: [PATCH 1/4] virtio-balloon: allow hypervisor refuse locking some pages
To: linux-kernel@vger.kernel.org
Cc: pv-drivers@vmware.com, Alok Kataria <akataria@vmware.com>,
       Saileshkumar Jain <sajain@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 19 Mar 2010 13:46:47 -0700
Message-ID: <20100319204647.4418.23072.stgit@localhost.localdomain>
In-Reply-To: <20100319204628.4418.84674.stgit@localhost.localdomain>
References: <20100319204628.4418.84674.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some hypervisors may refuse our request to lock pages in certain
circumstances. For example, VMware may decide that the target balloon
size decreased since it was last communicated to the guest and thus
current page should not be locked.

Reviewed-by: Alok Kataria <akataria@vmware.com>
Reviewed-by: Shaileshkumar Jain <sajain@vmware.com>
Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
---

 drivers/virtio/virtio_balloon.c |   68 +++++++++++++++++++++++++++++++++++----
 include/linux/virtio_balloon.h  |    8 +++--
 2 files changed, 67 insertions(+), 9 deletions(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 369f2ee..444c929 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -25,6 +25,8 @@
 #include <linux/freezer.h>
 #include <linux/delay.h>
 
+#define VIRTIO_BALLOON_CHUNK_SIZE	256
+
 struct virtio_balloon
 {
 	struct virtio_device *vdev;
@@ -46,9 +48,13 @@ struct virtio_balloon
 	unsigned int num_pages;
 	struct list_head pages;
 
+	/* Pages that host refused to lock for one reason or another. */
+	struct list_head refused_pages;
+
 	/* The array of pfns we tell the Host about. */
 	unsigned int num_pfns;
-	u32 pfns[256];
+	u32 pfns[VIRTIO_BALLOON_CHUNK_SIZE];
+	u8 pfns_status[VIRTIO_BALLOON_CHUNK_SIZE];
 
 	/* Memory statistics */
 	int need_stats_update;
@@ -81,14 +87,21 @@ static void balloon_ack(struct virtqueue *vq)
 
 static void tell_host(struct virtio_balloon *vb, struct virtqueue *vq)
 {
-	struct scatterlist sg;
+	struct scatterlist sg[2];
+	int n_out = 0;
 
-	sg_init_one(&sg, vb->pfns, sizeof(vb->pfns[0]) * vb->num_pfns);
+	sg_init_table(sg, 2);
+	sg_set_buf(&sg[0], vb->pfns, sizeof(vb->pfns[0]) * vb->num_pfns);
+	sg_set_buf(&sg[1], vb->pfns_status,
+			sizeof(vb->pfns_status[0]) * vb->num_pfns);
 
 	init_completion(&vb->acked);
 
+	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_HOST_MAY_REFUSE))
+		n_out = 1;
+
 	/* We should always be able to add one buffer to an empty queue. */
-	if (vq->vq_ops->add_buf(vq, &sg, 1, 0, vb) < 0)
+	if (vq->vq_ops->add_buf(vq, sg, 1, n_out, vb) < 0)
 		BUG();
 	vq->vq_ops->kick(vq);
 
@@ -98,6 +111,8 @@ static void tell_host(struct virtio_balloon *vb, struct virtqueue *vq)
 
 static void fill_balloon(struct virtio_balloon *vb, size_t num)
 {
+	int i;
+
 	/* We can only do one array worth at a time. */
 	num = min(num, ARRAY_SIZE(vb->pfns));
 
@@ -113,9 +128,7 @@ static void fill_balloon(struct virtio_balloon *vb, size_t num)
 			break;
 		}
 		vb->pfns[vb->num_pfns] = page_to_balloon_pfn(page);
-		totalram_pages--;
-		vb->num_pages++;
-		list_add(&page->lru, &vb->pages);
+		vb->pfns_status[vb->num_pfns] = VIRTIO_BALLOON_PFN_OK;
 	}
 
 	/* Didn't get any?  Oh well. */
@@ -123,6 +136,32 @@ static void fill_balloon(struct virtio_balloon *vb, size_t num)
 		return;
 
 	tell_host(vb, vb->inflate_vq);
+
+	for (i = 0; i < vb->num_pfns; i++) {
+		struct page *page = pfn_to_page(vb->pfns[i]);
+		if (vb->pfns_status[i] == VIRTIO_BALLOON_PFN_OK) {
+			list_add(&page->lru, &vb->pages);
+			vb->num_pages++;
+			totalram_pages--;
+		} else {
+			dev_dbg(&vb->vdev->dev,
+				"adding page %p (pfn %x) to refused pages list\n",
+				page, vb->pfns[i]);
+			list_add(&page->lru, &vb->refused_pages);
+		}
+	}
+}
+
+static void release_refused_pages(struct virtio_balloon *vb)
+{
+	struct page *page, *next;
+
+	list_for_each_entry_safe(page, next, &vb->refused_pages, lru) {
+		dev_dbg(&vb->vdev->dev,
+			"releasing previously refused page %p", page);
+		list_del(&page->lru);
+		__free_page(page);
+	}
 }
 
 static void release_pages_by_pfn(const u32 pfns[], unsigned int num)
@@ -263,13 +302,26 @@ static int balloon(void *_vballoon)
 					 || vb->need_stats_update
 					 || kthread_should_stop()
 					 || freezing(current));
+
 		if (vb->need_stats_update)
 			stats_handle_request(vb);
+
 		if (diff > 0)
 			fill_balloon(vb, diff);
 		else if (diff < 0)
 			leak_balloon(vb, -diff);
+
 		update_balloon_size(vb);
+
+		if (diff > 0 &&
+		    !list_empty(&vb->refused_pages) &&
+		    towards_target(vb) <= 0) {
+			/*
+			 * We reached our goal so we now can release
+			 * pages that host refused to lock for us.
+			 */
+			release_refused_pages(vb);
+		}
 	}
 	return 0;
 }
@@ -289,6 +341,7 @@ static int virtballoon_probe(struct virtio_device *vdev)
 	}
 
 	INIT_LIST_HEAD(&vb->pages);
+	INIT_LIST_HEAD(&vb->refused_pages);
 	vb->num_pages = 0;
 	init_waitqueue_head(&vb->config_change);
 	vb->vdev = vdev;
@@ -357,6 +410,7 @@ static void __devexit virtballoon_remove(struct virtio_device *vdev)
 static unsigned int features[] = {
 	VIRTIO_BALLOON_F_MUST_TELL_HOST,
 	VIRTIO_BALLOON_F_STATS_VQ,
+	VIRTIO_BALLOON_F_HOST_MAY_REFUSE,
 };
 
 static struct virtio_driver virtio_balloon_driver = {
diff --git a/include/linux/virtio_balloon.h b/include/linux/virtio_balloon.h
index a50ecd1..4baad1c 100644
--- a/include/linux/virtio_balloon.h
+++ b/include/linux/virtio_balloon.h
@@ -6,12 +6,16 @@
 #include <linux/virtio_config.h>
 
 /* The feature bitmap for virtio balloon */
-#define VIRTIO_BALLOON_F_MUST_TELL_HOST	0 /* Tell before reclaiming pages */
-#define VIRTIO_BALLOON_F_STATS_VQ	1 /* Memory Stats virtqueue */
+#define VIRTIO_BALLOON_F_MUST_TELL_HOST		0 /* Tell before reclaiming pages */
+#define VIRTIO_BALLOON_F_STATS_VQ		1 /* Memory Stats virtqueue */
+#define VIRTIO_BALLOON_F_HOST_MAY_REFUSE	2 /* Host may refuse some pages */
 
 /* Size of a PFN in the balloon interface. */
 #define VIRTIO_BALLOON_PFN_SHIFT 12
 
+#define VIRTIO_BALLOON_PFN_OK		0
+#define VIRTIO_BALLOON_PFN_FAIL		1
+
 struct virtio_balloon_config
 {
 	/* Number of pages host wants Guest to give up. */

