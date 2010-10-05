Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751559Ab0JEMpY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 08:45:24 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:44796 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab0JEMpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 08:45:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=tyY+yVC7rDvyaKIZv3kV5Hgq8U6AsHejoU1vw1gkoXOsWIRt6AECwOWKz0KWZgSanY
         bkibHBDheOX2dvbCRMDggc+Nu+yoYdZe2rO8ls2gXhdVRb1z6clO1n6I/mEuDSgJV/H+
         FEYOEUrJ/KRq/tlgue0lymMwGDw+flpoS6Jdo=
Date: Tue, 5 Oct 2010 20:45:21 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        Anthony Liguori <anthony@codemonkey.ws>
Subject: [PATCH] kvm: add oom notifier for virtio balloon
Message-ID: <20101005124521.GA2602@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balloon could cause guest memory oom killing and panic.

Add oom notify to leak some memory and retry fill balloon after 5 minutes.

At the same time add a mutex to protect balloon operations
because we need leak balloon in oom notifier and give back freed value. 

Thanks Anthony Liguori for his sugestion about inflate retrying.
Sometimes it will cause endless inflate/oom/delay loop,
so I think next step is to add an option to do noretry-when-oom balloon.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
 drivers/virtio/virtio_balloon.c |   92 ++++++++++++++++++++++++++++++++--------
 1 file changed, 75 insertions(+), 17 deletions(-)

--- linux-2.6.orig/drivers/virtio/virtio_balloon.c	2010-10-02 10:35:44.723333335 +0800
+++ linux-2.6/drivers/virtio/virtio_balloon.c	2010-10-05 10:40:24.740001466 +0800
@@ -2,6 +2,7 @@
  * Tosatti's implementations.
  *
  *  Copyright 2008 Rusty Russell IBM Corporation
+ *  oom notify - Dave Young <hidave.darkstar@gmail.com>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -25,6 +26,14 @@
 #include <linux/freezer.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
+#include <linux/notifier.h>
+#include <linux/param.h>
+#include <linux/timer.h>
+#include <linux/jiffies.h>
+#include <linux/oom.h>
+
+#define BALLOON_OOM_DELAY_MINUTES	5
+#define BALLOON_OOM_PAGES		256
 
 struct virtio_balloon
 {
@@ -54,6 +63,10 @@ struct virtio_balloon
 	/* Memory statistics */
 	int need_stats_update;
 	struct virtio_balloon_stat stats[VIRTIO_BALLOON_S_NR];
+
+	struct mutex mutex;
+	struct timer_list timer;
+	struct notifier_block oom_nb;
 };
 
 static struct virtio_device_id id_table[] = {
@@ -97,34 +110,37 @@ static void tell_host(struct virtio_ball
 	wait_for_completion(&vb->acked);
 }
 
+static void balloon_oom_timeout(unsigned long arg)
+{
+	struct virtio_balloon *v = (struct virtio_balloon *)arg;
+
+	wake_up(&v->config_change);
+}
+
 static void fill_balloon(struct virtio_balloon *vb, size_t num)
 {
 	/* We can only do one array worth at a time. */
 	num = min(num, ARRAY_SIZE(vb->pfns));
 
 	for (vb->num_pfns = 0; vb->num_pfns < num; vb->num_pfns++) {
-		struct page *page = alloc_page(GFP_HIGHUSER | __GFP_NORETRY |
+		struct page *page;
+
+		if (unlikely(timer_pending(&vb->timer)))
+			break;
+
+		page = alloc_page(GFP_HIGHUSER | __GFP_NORETRY |
 					__GFP_NOMEMALLOC | __GFP_NOWARN);
-		if (!page) {
-			if (printk_ratelimit())
-				dev_printk(KERN_INFO, &vb->vdev->dev,
-					   "Out of puff! Can't get %zu pages\n",
-					   num);
-			/* Sleep for at least 1/5 of a second before retry. */
-			msleep(200);
+		if (!page)
 			break;
-		}
+
 		vb->pfns[vb->num_pfns] = page_to_balloon_pfn(page);
 		totalram_pages--;
 		vb->num_pages++;
 		list_add(&page->lru, &vb->pages);
 	}
 
-	/* Didn't get any?  Oh well. */
-	if (vb->num_pfns == 0)
-		return;
-
-	tell_host(vb, vb->inflate_vq);
+	if (vb->num_pfns)
+		tell_host(vb, vb->inflate_vq);
 }
 
 static void release_pages_by_pfn(const u32 pfns[], unsigned int num)
@@ -235,22 +251,53 @@ static void virtballoon_changed(struct v
 
 static inline s64 towards_target(struct virtio_balloon *vb)
 {
-	u32 v;
+	u32 v, ret;
 	vb->vdev->config->get(vb->vdev,
 			      offsetof(struct virtio_balloon_config, num_pages),
 			      &v, sizeof(v));
-	return (s64)v - vb->num_pages;
+	ret = (s64)v - vb->num_pages;
+
+	if (ret > 0 && (unlikely(timer_pending(&vb->timer)))) {
+		printk(KERN_INFO "balloon will delay inflate due to oom ...\n");
+		return 0;
+	}
+
+	return ret;
 }
 
 static void update_balloon_size(struct virtio_balloon *vb)
 {
-	__le32 actual = cpu_to_le32(vb->num_pages);
+	__le32 actual;
 
+	actual = cpu_to_le32(vb->num_pages);
 	vb->vdev->config->set(vb->vdev,
 			      offsetof(struct virtio_balloon_config, actual),
 			      &actual, sizeof(actual));
 }
 
+static int balloon_oom_notify(struct notifier_block *self,
+				unsigned long dummy, void *parm)
+{
+	struct virtio_balloon *vb;
+	unsigned long *freed = (unsigned long *)parm;
+	unsigned int nr;
+
+	vb = container_of(self, struct virtio_balloon, oom_nb);
+
+	mutex_lock(&vb->mutex);
+	nr = min_t(unsigned int, vb->num_pages, BALLOON_OOM_PAGES);
+	if (nr) {
+		printk(KERN_INFO "balloon oom notifier leak %d pages\n", nr);
+		leak_balloon(vb, nr);
+		update_balloon_size(vb);
+	}
+	*freed = nr;
+	mutex_unlock(&vb->mutex);
+	mod_timer(&vb->timer, jiffies + BALLOON_OOM_DELAY_MINUTES * 60 * HZ);
+
+	return NOTIFY_OK;
+}
+
 static int balloon(void *_vballoon)
 {
 	struct virtio_balloon *vb = _vballoon;
@@ -267,11 +314,14 @@ static int balloon(void *_vballoon)
 					 || freezing(current));
 		if (vb->need_stats_update)
 			stats_handle_request(vb);
+
+		mutex_lock(&vb->mutex);
 		if (diff > 0)
 			fill_balloon(vb, diff);
 		else if (diff < 0)
 			leak_balloon(vb, -diff);
 		update_balloon_size(vb);
+		mutex_unlock(&vb->mutex);
 	}
 	return 0;
 }
@@ -325,6 +375,13 @@ static int virtballoon_probe(struct virt
 
 	vb->tell_host_first
 		= virtio_has_feature(vdev, VIRTIO_BALLOON_F_MUST_TELL_HOST);
+	vb->oom_nb.notifier_call = balloon_oom_notify;
+
+	mutex_init(&vb->mutex);
+	err = register_oom_notifier(&vb->oom_nb);
+	if (err < 0)
+		goto out_del_vqs;
+	setup_timer(&vb->timer, balloon_oom_timeout, (unsigned long)vb);
 
 	return 0;
 
@@ -340,6 +397,7 @@ static void __devexit virtballoon_remove
 {
 	struct virtio_balloon *vb = vdev->priv;
 
+	unregister_oom_notifier(&vb->oom_nb);
 	kthread_stop(vb->thread);
 
 	/* There might be pages left in the balloon: free them. */
