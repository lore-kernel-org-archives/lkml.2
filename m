Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369Ab1DZItK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 04:49:10 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48353 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081Ab1DZItJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 04:49:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=RvGy6zHOv75bOYfLW2FRst0+l1KK0YkPADn9qg/VyyQ8ATSnviM6byvJPs4kx/xBiI
         doHD4ySq4DE+PYhRmTdITfO92hpnOeP6v+bxgi5OUtLkyJb0kEK709T77TvEbHFSUhwy
         XpHZJ5EWqWaYuiLsq+zslC9WFt3preRcRCKFA=
Date: Tue, 26 Apr 2011 16:59:53 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kosaki.motohiro@jp.fujitsu.com
Subject: [PATCH v2] virtio_balloon: disable oom killer when fill balloon
Message-ID: <20110426085953.GA12389@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When memory pressure is high, virtio ballooning will probably cause oom killing.
Even if alloc_page with GFP_NORETRY itself does not directly trigger oom it
will make memory becoming low then memory alloc of other processes will trigger
oom killing. It is not desired behaviour.

Here disable oom killer in fill_balloon to address this issue.
Add code comment as KOSAKI Motohiro's suggestion.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
 drivers/virtio/virtio_balloon.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- linux-2.6.orig/drivers/virtio/virtio_balloon.c	2011-04-26 11:39:14.053118406 +0800
+++ linux-2.6/drivers/virtio/virtio_balloon.c	2011-04-26 16:54:56.419741542 +0800
@@ -25,6 +25,7 @@
 #include <linux/freezer.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
+#include <linux/oom.h>
 
 struct virtio_balloon
 {
@@ -102,6 +103,12 @@ static void fill_balloon(struct virtio_b
 	/* We can only do one array worth at a time. */
 	num = min(num, ARRAY_SIZE(vb->pfns));
 
+	/* Disable oom killer for indirect oom due to our memory consuming
+	 * Currently only hibernation code use oom_killer_disable,
+	 * hibernation will freeze us before disable oom killer, so
+	 * It's safe here without locks.
+	 */
+	oom_killer_disable();
 	for (vb->num_pfns = 0; vb->num_pfns < num; vb->num_pfns++) {
 		struct page *page = alloc_page(GFP_HIGHUSER | __GFP_NORETRY |
 					__GFP_NOMEMALLOC | __GFP_NOWARN);
@@ -119,6 +126,7 @@ static void fill_balloon(struct virtio_b
 		vb->num_pages++;
 		list_add(&page->lru, &vb->pages);
 	}
+	oom_killer_enable();
 
 	/* Didn't get any?  Oh well. */
 	if (vb->num_pfns == 0)
