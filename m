Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab2IIXd2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:33:28 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51180 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755841Ab2IIXQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:16:09 -0400
Message-Id: <20120909224202.102918910@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:43:14 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [ 84/95] virtio_blk: fix config handler race
In-Reply-To: <20120909224150.641491654@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Michael S. Tsirkin" <mst@redhat.com>

commit 4678d6f970c2f7c0cbfefc0cc666432d153b321b upstream.

Fix a theoretical race related to config work
handler: a config interrupt might happen
after we flush config work but before we
reset the device. It will then cause the
config work to run during or after reset.

Two problems with this:
- if this runs after device is gone we will get use after free
- access of config while reset is in progress is racy
(as layout is changing).

As a solution
1. flush after reset when we know there will be no more interrupts
2. add a flag to disable config access before reset

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/block/virtio_blk.c |   22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index a345e40..ba73661 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -4,6 +4,7 @@
 #include <linux/blkdev.h>
 #include <linux/hdreg.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/virtio.h>
 #include <linux/virtio_blk.h>
 #include <linux/scatterlist.h>
@@ -36,6 +37,12 @@ struct virtio_blk
 	/* Process context for config space updates */
 	struct work_struct config_work;
 
+	/* Lock for config space updates */
+	struct mutex config_lock;
+
+	/* enable config space updates */
+	bool config_enable;
+
 	/* What host tells us, plus 2 for header & tailer. */
 	unsigned int sg_elems;
 
@@ -318,6 +325,10 @@ static void virtblk_config_changed_work(struct work_struct *work)
 	char cap_str_2[10], cap_str_10[10];
 	u64 capacity, size;
 
+	mutex_lock(&vblk->config_lock);
+	if (!vblk->config_enable)
+		goto done;
+
 	/* Host must always specify the capacity. */
 	vdev->config->get(vdev, offsetof(struct virtio_blk_config, capacity),
 			  &capacity, sizeof(capacity));
@@ -340,6 +351,8 @@ static void virtblk_config_changed_work(struct work_struct *work)
 		  cap_str_10, cap_str_2);
 
 	set_capacity(vblk->disk, capacity);
+done:
+	mutex_unlock(&vblk->config_lock);
 }
 
 static void virtblk_config_changed(struct virtio_device *vdev)
@@ -388,7 +401,9 @@ static int __devinit virtblk_probe(struct virtio_device *vdev)
 	vblk->vdev = vdev;
 	vblk->sg_elems = sg_elems;
 	sg_init_table(vblk->sg, vblk->sg_elems);
+	mutex_init(&vblk->config_lock);
 	INIT_WORK(&vblk->config_work, virtblk_config_changed_work);
+	vblk->config_enable = true;
 
 	/* We expect one virtqueue, for output. */
 	vblk->vq = virtio_find_single_vq(vdev, blk_done, "requests");
@@ -542,7 +557,10 @@ static void __devexit virtblk_remove(struct virtio_device *vdev)
 	struct virtio_blk *vblk = vdev->priv;
 	int index = vblk->index;
 
-	flush_work(&vblk->config_work);
+	/* Prevent config work handler from accessing the device. */
+	mutex_lock(&vblk->config_lock);
+	vblk->config_enable = false;
+	mutex_unlock(&vblk->config_lock);
 
 	/* Nothing should be pending. */
 	BUG_ON(!list_empty(&vblk->reqs));
@@ -550,6 +568,8 @@ static void __devexit virtblk_remove(struct virtio_device *vdev)
 	/* Stop all the virtqueues. */
 	vdev->config->reset(vdev);
 
+	flush_work(&vblk->config_work);
+
 	del_gendisk(vblk->disk);
 	blk_cleanup_queue(vblk->disk->queue);
 	put_disk(vblk->disk);


