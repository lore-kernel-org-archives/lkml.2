Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946Ab2DMDMU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 23:12:20 -0400
Received: from ozlabs.org ([203.10.76.45]:59791 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755824Ab2DMDMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 23:12:19 -0400
Date: Fri, 13 Apr 2012 13:12:11 +1000
From: David Gibson <david@gibson.dropbear.id.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: rusty@rustcorp.com.au, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, paulus@samba.org, qemu-devel@nongnu.org
Subject: Re: [PATCH 3/3] virtio_balloon: Bugfixes for PAGE_SIZE != 4k
Message-ID: <20120413031211.GG5829@truffala.fritz.box>
Mail-Followup-To: "Michael S. Tsirkin" <mst@redhat.com>,
	rusty@rustcorp.com.au, virtualization@lists.linux-foundation.org,
	linux-kernel@vger.kernel.org, paulus@samba.org,
	qemu-devel@nongnu.org
References: <1334208995-29985-1-git-send-email-david@gibson.dropbear.id.au>
 <1334208995-29985-4-git-send-email-david@gibson.dropbear.id.au>
 <20120412101157.GA13172@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120412101157.GA13172@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 01:14:06PM +0300, Michael S. Tsirkin wrote:
> On Thu, Apr 12, 2012 at 03:36:35PM +1000, David Gibson wrote:
[snip]
> Good catch!
> 
> Unfortunately I find the approach a bit convoluted.
> It also looks like when host asks for 5 balloon pages
> you interpret this as 0 where 16 is probably saner
> on a 64K system.

Hm, true.  Although qemu at least actuall operates in units of
megabytes on the balloon, so I doubt it matters much in practice.

> I think it's easier if we just keep doing math in
> balloon pages. I also get confused by shift operations,
> IMO / and * are clearer where they are applicable.
> Something like the below would make more sense I think.

Sure.  I thught working in local pages was clearer, but I don't really
care.


> I also wrote up a detailed commit log, so we have
> the bugs and the expected consequences listed explicitly.
> 
> I'm out of time for this week - so completely untested, sorry.
> Maybe you could try this out? That would be great.
> Thanks!

Your patch has numerous syntax errors, but once those are fixed seems
to work fine with a 64k ppc64 kernel.  Fixed version below.  I did add
one comment, to note that with this change the num_pages field in the
vb is no longer the same as the number of elements in the pages list.
Nothing in the code relies on that, but it would probably be the first
assumption of someone looking at the structure definition.

Please apply.

>From cf62f576ae1b26426d9325da08826e39db7031a1 Mon Sep 17 00:00:00 2001
From: David Gibson <david@gibson.dropbear.id.au>
Date: Fri, 13 Apr 2012 12:57:40 +1000
Subject: [PATCH] virtio_balloon: fix handling of PAGE_SIZE != 4k

As reported by David Gibson, current code handles PAGE_SIZE != 4k
completely wrong which can lead to guest memory corruption errors.

- page_to_balloon_pfn is wrong: e.g. on system with 64K page size
 it gives the same pfn value for 16 different pages.

- we also need to convert back to linux pfns when we free.

- for each linux page we need to tell host about multiple balloon
  pages, but code only adds one pfn to the array.

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
---
 drivers/virtio/virtio_balloon.c |   44 +++++++++++++++++++++++++++++++--------
 1 file changed, 35 insertions(+), 9 deletions(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 9e95ca6..0c0c1c3 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -43,6 +43,9 @@ struct virtio_balloon
 	struct completion acked;
 
 	/* The pages we've told the Host we're not using. */
+	/* Note that num_pages is measured in 4k balloon pages, so if
+	 * PAGE_SIZE != 4k, it will be a multiple of the actual number
+	 * of elements in the pages list */
 	unsigned int num_pages;
 	struct list_head pages;
 
@@ -60,13 +63,23 @@ static struct virtio_device_id id_table[] = {
 	{ 0 },
 };
 
+/* Balloon device works in 4K page units. So each page is
+ * pointed to by multiple balloon pages. */
+#define VIRTIO_BALLOON_PAGES_PER_PAGE (PAGE_SIZE >> VIRTIO_BALLOON_PFN_SHIFT)
+
 static u32 page_to_balloon_pfn(struct page *page)
 {
 	unsigned long pfn = page_to_pfn(page);
 
 	BUILD_BUG_ON(PAGE_SHIFT < VIRTIO_BALLOON_PFN_SHIFT);
 	/* Convert pfn from Linux page size to balloon page size. */
-	return pfn >> (PAGE_SHIFT - VIRTIO_BALLOON_PFN_SHIFT);
+	return pfn * VIRTIO_BALLOON_PAGES_PER_PAGE;
+}
+
+static struct page *balloon_pfn_to_page(u32 pfn)
+{
+	BUG_ON(pfn % VIRTIO_BALLOON_PAGES_PER_PAGE);
+	return pfn_to_page(pfn / VIRTIO_BALLOON_PAGES_PER_PAGE);
 }
 
 static void balloon_ack(struct virtqueue *vq)
@@ -96,12 +109,23 @@ static void tell_host(struct virtio_balloon *vb, struct virtqueue *vq)
 	wait_for_completion(&vb->acked);
 }
 
+static void set_page_pfns(u32 pfns[], struct page *page)
+{
+	unsigned int i;
+
+	/* Set balloon pfns pointing at this page.
+	 * Note that the first pfn points at start of the page. */
+	for (i = 0; i < VIRTIO_BALLOON_PAGES_PER_PAGE; i++)
+		pfns[i] = page_to_balloon_pfn(page) + i;
+}
+
 static void fill_balloon(struct virtio_balloon *vb, size_t num)
 {
 	/* We can only do one array worth at a time. */
 	num = min(num, ARRAY_SIZE(vb->pfns));
 
-	for (vb->num_pfns = 0; vb->num_pfns < num; vb->num_pfns++) {
+	for (vb->num_pfns = 0; vb->num_pfns < num;
+	     vb->num_pfns += VIRTIO_BALLOON_PAGES_PER_PAGE) {
 		struct page *page = alloc_page(GFP_HIGHUSER | __GFP_NORETRY |
 					__GFP_NOMEMALLOC | __GFP_NOWARN);
 		if (!page) {
@@ -113,9 +137,9 @@ static void fill_balloon(struct virtio_balloon *vb, size_t num)
 			msleep(200);
 			break;
 		}
-		vb->pfns[vb->num_pfns] = page_to_balloon_pfn(page);
+		set_page_pfns(vb->pfns + vb->num_pfns, page);
+		vb->num_pages += VIRTIO_BALLOON_PAGES_PER_PAGE;
 		totalram_pages--;
-		vb->num_pages++;
 		list_add(&page->lru, &vb->pages);
 	}
 
@@ -130,8 +154,9 @@ static void release_pages_by_pfn(const u32 pfns[], unsigned int num)
 {
 	unsigned int i;
 
-	for (i = 0; i < num; i++) {
-		__free_page(pfn_to_page(pfns[i]));
+	/* Find pfns pointing at start of each page, get pages and free them. */
+	for (i = 0; i < num; i += VIRTIO_BALLOON_PAGES_PER_PAGE) {
+		__free_page(balloon_pfn_to_page(pfns[i]));
 		totalram_pages++;
 	}
 }
@@ -143,11 +168,12 @@ static void leak_balloon(struct virtio_balloon *vb, size_t num)
 	/* We can only do one array worth at a time. */
 	num = min(num, ARRAY_SIZE(vb->pfns));
 
-	for (vb->num_pfns = 0; vb->num_pfns < num; vb->num_pfns++) {
+	for (vb->num_pfns = 0; vb->num_pfns < num;
+	     vb->num_pfns += VIRTIO_BALLOON_PAGES_PER_PAGE) {
 		page = list_first_entry(&vb->pages, struct page, lru);
 		list_del(&page->lru);
-		vb->pfns[vb->num_pfns] = page_to_balloon_pfn(page);
-		vb->num_pages--;
+		set_page_pfns(vb->pfns + vb->num_pfns, page);
+		vb->num_pages -= VIRTIO_BALLOON_PAGES_PER_PAGE;
 	}
 
 	/*
-- 
1.7.9.5



-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
