Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab1DZFSb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 01:18:31 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:64806 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538Ab1DZFS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 01:18:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=J5AGvZrtH9KYLf1p5T6iZXFbdgAdz84mhWVoyLiAcmP0p8EdCBZUZ+2BMKCOkcUdVR
         GbxYXi8FXaa9hG1U3M+JkMWqtRYFzTPxY6GeZvQUqzCZNdrFhhkYBQf7TCvsh5vz4u2V
         ukybk71jOEDHAQZwE8r39RF1Zbu5GxhXFju44=
Date: Tue, 26 Apr 2011 13:29:16 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] virtio_balloon: disable oom killer when fill balloon
Message-ID: <20110426052916.GA11933@darkstar>
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

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
 drivers/virtio/virtio_balloon.c |    3 +++
 1 file changed, 3 insertions(+)

--- linux-2.6.orig/drivers/virtio/virtio_balloon.c	2010-10-13 10:14:38.000000000 +0800
+++ linux-2.6/drivers/virtio/virtio_balloon.c	2011-04-26 11:38:43.979785141 +0800
@@ -25,6 +25,7 @@
 #include <linux/freezer.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
+#include <linux/oom.h>
 
 struct virtio_balloon
 {
@@ -102,6 +103,7 @@ static void fill_balloon(struct virtio_b
 	/* We can only do one array worth at a time. */
 	num = min(num, ARRAY_SIZE(vb->pfns));
 
+	oom_killer_disable();
 	for (vb->num_pfns = 0; vb->num_pfns < num; vb->num_pfns++) {
 		struct page *page = alloc_page(GFP_HIGHUSER | __GFP_NORETRY |
 					__GFP_NOMEMALLOC | __GFP_NOWARN);
@@ -119,6 +121,7 @@ static void fill_balloon(struct virtio_b
 		vb->num_pages++;
 		list_add(&page->lru, &vb->pages);
 	}
+	oom_killer_enable();
 
 	/* Didn't get any?  Oh well. */
 	if (vb->num_pfns == 0)
