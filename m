Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599Ab1BATWM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 14:22:12 -0500
Received: from verein.lst.de ([213.95.11.210]:40892 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752Ab1BATWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 14:22:11 -0500
Date: Tue, 1 Feb 2011 20:21:56 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Rusty Russell <rusty@rustcorp.com.au>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio_blk: allow re-reading config space at runtime
Message-ID: <20110201192156.GA20197@lst.de>
References: <20110114160137.GA18721@lst.de> <201101181138.50421.rusty@rustcorp.com.au> <20110118122751.GA27997@lst.de> <201101190956.10137.rusty@rustcorp.com.au> <20110118235401.GA16219@lst.de> <20110127152926.GA4898@redhat.com> <20110201173234.GC16883@lst.de> <20110201183827.GB24924@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110201183827.GB24924@redhat.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 08:38:27PM +0200, Michael S. Tsirkin wrote:
> Should not be hard to solve.
> If it's running, it is ok to requeue.  I don't remember offhand if it's
> ok to requeue if it's queued but not running, if not we could have a
> flag that signals that's the case.

Looks like the workqueue infrastructure does indeed handle requing
an pending work_struct, and we're free to reuse it from the point
just before the callback is called.

Does the version below look okay?

---
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2] virtio_blk: allow re-reading config space at runtime

Wire up the virtio_driver config_changed method to get notified about
config changes raised by the host.  For now we just re-read the device
size to support online resizing of devices, but once we add more
attributes that might be changeable they could be added as well.

Note that the config_changed method is called from irq context, so
we'll have to use the workqueue infrastructure to provide us a proper
user context for our changes.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/block/virtio_blk.c
===================================================================
--- linux-2.6.orig/drivers/block/virtio_blk.c	2010-12-01 09:30:59.647253809 -0700
+++ linux-2.6/drivers/block/virtio_blk.c	2011-02-01 12:10:02.803164641 -0700
@@ -6,10 +6,12 @@
 #include <linux/virtio.h>
 #include <linux/virtio_blk.h>
 #include <linux/scatterlist.h>
+#include <linux/string_helpers.h>
 
 #define PART_BITS 4
 
 static int major, index;
+struct workqueue_struct *virtblk_wq;
 
 struct virtio_blk
 {
@@ -26,6 +28,9 @@ struct virtio_blk
 
 	mempool_t *pool;
 
+	/* Process context for config space updates */
+	struct work_struct config_work;
+
 	/* What host tells us, plus 2 for header & tailer. */
 	unsigned int sg_elems;
 
@@ -291,6 +296,47 @@ static ssize_t virtblk_serial_show(struc
 }
 DEVICE_ATTR(serial, S_IRUGO, virtblk_serial_show, NULL);
 
+static void virtblk_config_changed_work(struct work_struct *work)
+{
+	struct virtio_blk *vblk =
+		container_of(work, struct virtio_blk, config_work);
+	struct virtio_device *vdev = vblk->vdev;
+	struct request_queue *q = vblk->disk->queue;
+	char cap_str_2[10], cap_str_10[10];
+	u64 capacity, size;
+
+	/* Host must always specify the capacity. */
+	vdev->config->get(vdev, offsetof(struct virtio_blk_config, capacity),
+			  &capacity, sizeof(capacity));
+
+	/* If capacity is too big, truncate with warning. */
+	if ((sector_t)capacity != capacity) {
+		dev_warn(&vdev->dev, "Capacity %llu too large: truncating\n",
+			 (unsigned long long)capacity);
+		capacity = (sector_t)-1;
+	}
+
+	size = capacity * queue_logical_block_size(q);
+	string_get_size(size, STRING_UNITS_2, cap_str_2, sizeof(cap_str_2));
+	string_get_size(size, STRING_UNITS_10, cap_str_10, sizeof(cap_str_10));
+
+	dev_notice(&vdev->dev,
+		  "new size: %llu %d-byte logical blocks (%s/%s)\n",
+		  (unsigned long long)capacity,
+		  queue_logical_block_size(q),
+		  cap_str_10, cap_str_2);
+
+	set_capacity(vblk->disk, capacity);
+
+}
+
+static void virtblk_config_changed(struct virtio_device *vdev)
+{
+	struct virtio_blk *vblk = vdev->priv;
+
+	queue_work(virtblk_wq, &vblk->config_work);
+}
+
 static int __devinit virtblk_probe(struct virtio_device *vdev)
 {
 	struct virtio_blk *vblk;
@@ -327,6 +373,7 @@ static int __devinit virtblk_probe(struc
 	vblk->vdev = vdev;
 	vblk->sg_elems = sg_elems;
 	sg_init_table(vblk->sg, vblk->sg_elems);
+	INIT_WORK(&vblk->config_work, virtblk_config_changed_work);
 
 	/* We expect one virtqueue, for output. */
 	vblk->vq = virtio_find_single_vq(vdev, blk_done, "requests");
@@ -477,6 +524,8 @@ static void __devexit virtblk_remove(str
 {
 	struct virtio_blk *vblk = vdev->priv;
 
+	flush_work(&vblk->config_work);
+
 	/* Nothing should be pending. */
 	BUG_ON(!list_empty(&vblk->reqs));
 
@@ -508,27 +557,47 @@ static unsigned int features[] = {
  * Use __refdata to avoid this warning.
  */
 static struct virtio_driver __refdata virtio_blk = {
-	.feature_table = features,
-	.feature_table_size = ARRAY_SIZE(features),
-	.driver.name =	KBUILD_MODNAME,
-	.driver.owner =	THIS_MODULE,
-	.id_table =	id_table,
-	.probe =	virtblk_probe,
-	.remove =	__devexit_p(virtblk_remove),
+	.feature_table		= features,
+	.feature_table_size	= ARRAY_SIZE(features),
+	.driver.name		= KBUILD_MODNAME,
+	.driver.owner		= THIS_MODULE,
+	.id_table		= id_table,
+	.probe			= virtblk_probe,
+	.remove			= __devexit_p(virtblk_remove),
+	.config_changed		= virtblk_config_changed,
 };
 
 static int __init init(void)
 {
+	int error;
+
+	virtblk_wq = alloc_workqueue("md_misc", 0, 0);
+	if (!virtblk_wq)
+		return -ENOMEM;
+
 	major = register_blkdev(0, "virtblk");
-	if (major < 0)
-		return major;
-	return register_virtio_driver(&virtio_blk);
+	if (major < 0) {
+		error = major;
+		goto out_destroy_workqueue;
+	}
+
+	error = register_virtio_driver(&virtio_blk);
+	if (error)
+		goto out_unregister_blkdev;
+	return 0;
+
+out_unregister_blkdev:
+	unregister_blkdev(major, "virtblk");
+out_destroy_workqueue:
+	destroy_workqueue(virtblk_wq);
+	return error;
 }
 
 static void __exit fini(void)
 {
 	unregister_blkdev(major, "virtblk");
 	unregister_virtio_driver(&virtio_blk);
+	destroy_workqueue(virtblk_wq);
 }
 module_init(init);
 module_exit(fini);
