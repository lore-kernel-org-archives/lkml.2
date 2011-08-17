Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504Ab1HQNOX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 09:14:23 -0400
Received: from mail.free-electrons.com ([88.190.12.23]:42404 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab1HQNOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 09:14:21 -0400
From: david.wagner@free-electrons.com
To: linux-mtd <linux-mtd@lists.infradead.org>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
        linux-embedded <linux-embedded@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Tim Bird <tim.bird@am.sony.com>,
        David Woodhouse <dwmw2@infradead.org>,
        David Wagner <david.wagner@free-electrons.com>
Subject: [PATCHv3] UBI: new module ubiblk: block layer on top of UBI
Date: Wed, 17 Aug 2011 15:17:21 +0200
Message-Id: <1313587042-30846-1-git-send-email-david.wagner@free-electrons.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1308922482-14967-1-git-send-email-david.wagner@free-electrons.com>
References: <1308922482-14967-1-git-send-email-david.wagner@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Wagner <david.wagner@free-electrons.com>

ubiblk is a read-only block layer on top of UBI.  It presents UBI volumes as
read-only block devices (named ubiblk_X_Y, where X is the UBI device number
and Y the Volume ID).

It is used by putting a block filesystem image on a UBI volume, creating the
corresponding ubiblk device and then mounting it.

It uses the UBI API to register to UBI notifications and to read from the
volumes.  It also creates a ubiblk_ctrl device node that simply receives ioctl
from a userspace tool for creating/removing ubiblk devices.

Some code is taken from mtd_blkdevs and gluebi.  Some code for the ioctl part is
also inspired from ubi's core.

Advantages of ubiblk over gluebi+mtdblock_ro:

 * Simpler architecture

 * The numbering of devices is much easier with ubiblk than with
   gluebi+mtdblock_ro. With gluebi+mtdblock_ro, you get one additional MTD
   device for each UBI volume, so the number of MTD devices grows quite a lot
   and is a bit difficult to understand. For example, mtdblock[0-4] might be
   your real MTD partitions, while mtdblock[5-9] might be your UBI volumes.
   It also means that if a new real MTD partition is added, the number of all
   the MTD devices exposing UBI volumes will be incremented by one, which is a
   bit confusing/annoying.
   As well, if you add an UBI volume, the mtdblock devices that are emulated on
   top of volumes that come after this new one will have their ID incremented.

 * ubiblk devices are created on a 'on-demand' basis, which avoids wasting
   resources.

 * The performance appears to be slightly better with ubiblk than
   gluebi+mtdblock_ro, according to our benchmarks (see
   http://elinux.org/Flash_Filesystem_Benchmarks_2.6.39)

TODO:
 * the modules keeps a table of the devices which length is the maximum number
   of UBI volumes.  There should be a better solution (linked list or, as
   Christoph Hellwig suggests, a radix tree (idr)).

Signed-off-by: David Wagner <david.wagner@free-electrons.com>
---

	Hi Artem,

Here is the v3 of ubiblk implementing ioctls for on-demand creation/removal of
ubiblk device ; is it what you were thinking of ?

I also wrote a minimal (and ugly w.r.t argument parsing) tool in mtd-utils'
git ; I'll send it as a reply to this email.

known issue: attempts to create the same ubiblk device twice aren't catched and,
obviously, make things go wrong (see TODO).

Questions:
==========
I wasn't sure what magic ioctl number to use, so I settled to use the same one
as a part of UBI: 'O', which was so far only used by UBI but on a higher range
and leaving some room for UBI to add ioctls (for nw, it uses 'O'/0x00-0x06 and
ubiblk uses 'O'/0x10-0x11).  Is it ok or should ubiblk use a different
number/range ?


updates from v3:
===============
 - Removed unused parameter "struct ubi_device_info" from ubiblk_create

 - Synchronisation: forgot to release a mutex on the error path of ubiblk_create

 - New header ubiblk-user.h, contains ioctl numbers ; patch
   Documentation/ioctl/ioctl-numbers.txt (use the same magic as UBI but on
   another range, leaving expansion margin for UBI)

 - Add a ioctl handler and make it use the already-existing
   ubiblk_{create,remove} functions (inspired from ubi/cdev.c).

 - Register a miscdevice (inspired from ubi/build.c) that will only receive ioctls

 - Notifications: don't receive a notifications for already-existing volumes
   upon registration ; don't create a ubiblk device when a new UBI volume
   appears

 - Amend commit message and Kconfig according to these previous points

 
TODO:
=====
 - Use a dynamic structure for storing the ubiblk_devs (linked list or idr ?)
 - After this task is done, check that using ubiblkadd can't create an
   already-existing ubiblk device (see warning/todo in the code)


 Documentation/ioctl/ioctl-number.txt |    1 +
 drivers/mtd/ubi/Kconfig              |   15 +
 drivers/mtd/ubi/Makefile             |    1 +
 drivers/mtd/ubi/ubiblk.c             |  653 ++++++++++++++++++++++++++++++++++
 include/mtd/ubiblk-user.h            |   43 +++
 5 files changed, 713 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mtd/ubi/ubiblk.c
 create mode 100644 include/mtd/ubiblk-user.h

diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
index 3a46e36..240cf0f 100644
--- a/Documentation/ioctl/ioctl-number.txt
+++ b/Documentation/ioctl/ioctl-number.txt
@@ -150,6 +150,7 @@ Code  Seq#(hex)	Include File		Comments
 'M'	00-0F	drivers/video/fsl-diu-fb.h	conflict!
 'N'	00-1F	drivers/usb/scanner.h
 'O'     00-06   mtd/ubi-user.h		UBI
+'O'     10-11   mtd/ubiblk-user.h       ubiblk
 'P'	all	linux/soundcard.h	conflict!
 'P'	60-6F	sound/sscape_ioctl.h	conflict!
 'P'	00-0F	drivers/usb/class/usblp.c	conflict!
diff --git a/drivers/mtd/ubi/Kconfig b/drivers/mtd/ubi/Kconfig
index 4dcc752..3eedf9a 100644
--- a/drivers/mtd/ubi/Kconfig
+++ b/drivers/mtd/ubi/Kconfig
@@ -60,4 +60,19 @@ config MTD_UBI_DEBUG
 	help
 	  This option enables UBI debugging.
 
+config MTD_UBI_UBIBLK
+	tristate "Read-only block transition layer on top of UBI"
+	help
+	   Read-only block interface on top of UBI.
+
+	   This option adds ubiblk, which creates a read-ony block device from
+	   UBI volumes.  It makes it possible to use block filesystems on top of
+	   UBI (and thus, on top of MTDs while avoiding bad blocks).
+
+	   ubiblk devices are created by sending appropriate ioctl to the
+	   ubiblk_ctrl device node.
+
+	   The devices are named ubiblkX_Y where X is the UBI number and Y is
+	   the Volume ID.
+
 endif # MTD_UBI
diff --git a/drivers/mtd/ubi/Makefile b/drivers/mtd/ubi/Makefile
index c9302a5..354b2df 100644
--- a/drivers/mtd/ubi/Makefile
+++ b/drivers/mtd/ubi/Makefile
@@ -5,3 +5,4 @@ ubi-y += misc.o
 
 ubi-$(CONFIG_MTD_UBI_DEBUG) += debug.o
 obj-$(CONFIG_MTD_UBI_GLUEBI) += gluebi.o
+obj-$(CONFIG_MTD_UBI_UBIBLK) += ubiblk.o
diff --git a/drivers/mtd/ubi/ubiblk.c b/drivers/mtd/ubi/ubiblk.c
new file mode 100644
index 0000000..20c0896
--- /dev/null
+++ b/drivers/mtd/ubi/ubiblk.c
@@ -0,0 +1,653 @@
+/*
+ * Copyright (c) Free Electrons, 2011
+ * Copyright (c) International Business Machines Corp., 2006
+ * Copyright © 2003-2010 David Woodhouse <dwmw2@infradead.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See
+ * the GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ * Author: David Wagner
+ * Some code taken from gluebi.c (Artem Bityutskiy (Битюцкий Артём),
+ *                                Joern Engel)
+ * Some code taken from cdev.c (Artem Bityutskiy (Битюцкий Артём))
+ * Some code taken from mtd_blkdevs.c (David Woodhouse)
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/vmalloc.h>
+#include <linux/mtd/ubi.h>
+#include <linux/blkdev.h>
+#include <linux/miscdevice.h>
+#include <linux/kthread.h>
+#include <linux/mutex.h>
+#include <mtd/ubiblk-user.h>
+#include "ubi.h"
+
+#define BLK_SIZE 512
+
+#define UBIBLK_MAX_DEVS (UBI_MAX_DEVICES * UBI_MAX_VOLUMES)
+
+/*
+ * Structure representing a ubiblk device, proxying a UBI volume
+ */
+struct ubiblk_dev {
+	struct ubi_volume_desc *vol_desc;
+	struct ubi_volume_info *vol_info;
+	int ubi_num;
+	int vol_id;
+
+	/* Block stuff */
+	struct gendisk *gd;
+	struct request_queue *rq;
+	struct task_struct *thread;
+
+	/* Protects the access to the UBI volume */
+	struct mutex lock;
+
+	/* Avoids concurrent accesses to the request queue */
+	spinlock_t queue_lock;
+};
+
+/*
+ * Contains the pointers to all ubiblk_dev instances
+ * TODO: use a linked list
+ */
+static struct ubiblk_dev *ubiblk_devs[UBIBLK_MAX_DEVS];
+static struct mutex devtable_lock;
+
+static int ubiblk_major;
+static const struct block_device_operations ubiblk_ops;
+
+static struct ubiblk_dev *ubiblk_find_dev(struct ubi_volume_info *vol_info)
+{
+	int i;
+	struct ubiblk_dev *dev;
+
+	mutex_lock(&devtable_lock);
+	for (i = 0; i < UBIBLK_MAX_DEVS; i++) {
+		dev = ubiblk_devs[i];
+		if (dev && dev->ubi_num == vol_info->ubi_num &&
+		    dev->vol_id == vol_info->vol_id)
+			break;
+	}
+	mutex_unlock(&devtable_lock);
+	if (i == UBIBLK_MAX_DEVS)
+		return NULL;
+	return dev;
+}
+
+/*
+ * Read a LEB and fill the request buffer with the requested sector
+ */
+static int do_ubiblk_request(struct request *req, struct ubiblk_dev *dev)
+{
+	unsigned long start, len, read_bytes;
+	int offset;
+	int leb;
+	int ret;
+
+	start = blk_rq_pos(req) << 9;
+	len = blk_rq_cur_bytes(req);
+	read_bytes = 0;
+
+	/* We are always reading. No need to handle writing for now */
+
+	leb = start / dev->vol_info->usable_leb_size;
+	offset = start % dev->vol_info->usable_leb_size;
+
+	do {
+		if (offset + len > dev->vol_info->usable_leb_size)
+			len = dev->vol_info->usable_leb_size - offset;
+
+		if (unlikely(blk_rq_pos(req) + blk_rq_cur_sectors(req) >
+		    get_capacity(req->rq_disk))) {
+			pr_err("UBIBLK: attempting to read too far\n");
+			return -EIO;
+		}
+
+		pr_debug("%s(%s) of sector %llu (LEB %d). offset=%d, len=%lu\n",
+			 __func__, rq_data_dir(req) ? "Write" : "Read",
+			 blk_rq_pos(req), leb, offset, len);
+
+		/* Read (len) bytes of LEB (leb) from (offset) and put the
+		 * result in the buffer given by the request.
+		 * If the request is overlapping on several lebs, (read_bytes)
+		 * will be > 0 and the data will be put in the buffer at
+		 * offset (read_bytes)
+		 */
+		ret = ubi_read(dev->vol_desc, leb, req->buffer + read_bytes,
+			       offset, len);
+
+		if (ret) {
+			pr_err("ubi_read error\n");
+			return ret;
+		}
+
+		read_bytes += len;
+
+		len = blk_rq_cur_bytes(req) - read_bytes;
+		leb++;
+		offset = 0;
+	} while (read_bytes < blk_rq_cur_bytes(req));
+
+	pr_debug("ubi_read done.\n");
+
+	return 0;
+}
+
+static void ubi_ubiblk_request(struct request_queue *rq)
+{
+	struct ubiblk_dev *dev;
+	struct request *req = NULL;
+
+	dev = rq->queuedata;
+
+	if (!dev)
+		while ((req = blk_fetch_request(rq)) != NULL)
+			__blk_end_request_all(req, -ENODEV);
+	else
+		wake_up_process(dev->thread);
+}
+
+/*
+ * Open a UBI volume (get the volume descriptor)
+ */
+static int ubiblk_open(struct block_device *bdev, fmode_t mode)
+{
+	struct ubiblk_dev *dev = bdev->bd_disk->private_data;
+	pr_debug("%s() disk_name=%s, mode=%d\n", __func__,
+		 bdev->bd_disk->disk_name, mode);
+
+	dev->vol_desc = ubi_open_volume(dev->ubi_num, dev->vol_id,
+					UBI_READONLY);
+	if (!dev->vol_desc) {
+		pr_err("open_volume failed");
+		return -EINVAL;
+	}
+
+	dev->vol_info = kzalloc(sizeof(struct ubi_volume_info), GFP_KERNEL);
+	if (!dev->vol_info) {
+		ubi_close_volume(dev->vol_desc);
+		dev->vol_desc = NULL;
+		return -ENOMEM;
+	}
+	ubi_get_volume_info(dev->vol_desc, dev->vol_info);
+
+	return 0;
+}
+
+/*
+ * Close a UBI volume (close the volume descriptor)
+ */
+static int ubiblk_release(struct gendisk *gd, fmode_t mode)
+{
+	struct ubiblk_dev *dev = gd->private_data;
+	pr_debug("%s() disk_name=%s, mode=%d\n", __func__, gd->disk_name, mode);
+
+	kfree(dev->vol_info);
+	dev->vol_info = NULL;
+	if (dev->vol_desc) {
+		ubi_close_volume(dev->vol_desc);
+		dev->vol_desc = NULL;
+	}
+
+	return 0;
+}
+
+/*
+ * Loop on the block request queue and wait for new requests ; run them with
+ * do_ubiblk_request()
+ *
+ * Mostly copied from mtd_blkdevs.c
+ */
+static int ubi_ubiblk_thread(void *arg)
+{
+	struct ubiblk_dev *dev = arg;
+	struct request_queue *rq = dev->rq;
+	struct request *req = NULL;
+
+	spin_lock_irq(rq->queue_lock);
+
+	while (!kthread_should_stop()) {
+		int res;
+
+		if (!req && !(req = blk_fetch_request(rq))) {
+			set_current_state(TASK_INTERRUPTIBLE);
+
+			if (kthread_should_stop())
+				set_current_state(TASK_RUNNING);
+
+			spin_unlock_irq(rq->queue_lock);
+			schedule();
+			spin_lock_irq(rq->queue_lock);
+			continue;
+		}
+
+		spin_unlock_irq(rq->queue_lock);
+
+		mutex_lock(&dev->lock);
+		res = do_ubiblk_request(req, dev);
+		pr_debug("return from request: %d\n", res);
+		mutex_unlock(&dev->lock);
+
+		spin_lock_irq(rq->queue_lock);
+
+		if (!__blk_end_request_cur(req, res))
+			req = NULL;
+	}
+
+	if (req)
+		__blk_end_request_all(req, -EIO);
+
+	spin_unlock_irq(rq->queue_lock);
+
+	return 0;
+}
+
+/*
+ * An UBI volume has been created ; create a corresponding ubiblk device:
+ * Initialize the locks, the structure, the block layer infos and start a
+ * thread.
+ */
+static int ubiblk_create(struct ubi_volume_info *vol_info)
+{
+	struct ubiblk_dev *dev;
+	struct gendisk *gd;
+	int i;
+	int ret = 0;
+
+	mutex_lock(&devtable_lock);
+#warning "TODO: Make sure the ubiblk device doesn't already exist (to be done after introducing the use of a dynamic structure for storing the ubiblk_devs)"
+	for (i = 0; i < UBIBLK_MAX_DEVS; i++)
+		if (!ubiblk_devs[i])
+			break;
+
+	if (i == UBIBLK_MAX_DEVS) {
+		/* Shouldn't happen: UBI can't make more volumes than that */
+		pr_err("no slot left for a new ubiblk device.\n");
+		mutex_unlock(&devtable_lock);
+		return -ENOMEM;
+	}
+
+	dev = kzalloc(sizeof(struct ubiblk_dev), GFP_KERNEL);
+	if (!dev) {
+		pr_err("UBIBLK: ENOMEM when trying to create a new"
+		       "ubiblk dev\n");
+		mutex_unlock(&devtable_lock);
+		return -ENOMEM;
+	}
+	ubiblk_devs[i] = dev;
+	mutex_unlock(&devtable_lock);
+
+	mutex_init(&dev->lock);
+	mutex_lock(&dev->lock);
+
+	dev->ubi_num = vol_info->ubi_num;
+	dev->vol_id = vol_info->vol_id;
+
+	dev->vol_desc = ubi_open_volume(dev->ubi_num, dev->vol_id,
+					UBI_READONLY);
+	if (IS_ERR(dev->vol_desc)) {
+		pr_err("open_volume failed\n");
+		ret = PTR_ERR(dev->vol_desc);
+		goto out_vol;
+	}
+
+	dev->vol_info = kzalloc(sizeof(struct ubi_volume_info), GFP_KERNEL);
+	if (!dev->vol_info) {
+		ret = -ENOMEM;
+		goto out_info;
+	}
+	ubi_get_volume_info(dev->vol_desc, dev->vol_info);
+
+	pr_info("Got volume %s: device %d/volume %d of size %d\n",
+		dev->vol_info->name, dev->ubi_num, dev->vol_id,
+		dev->vol_info->size);
+
+	/* Initialize the gendisk of this ubiblk device */
+	gd = alloc_disk(1);
+	if (!gd) {
+		pr_err("alloc_disk failed\n");
+		ret = -ENODEV;
+		goto out_disk;
+	}
+
+	gd->fops = &ubiblk_ops;
+	gd->major = ubiblk_major;
+	gd->first_minor = dev->ubi_num * UBI_MAX_VOLUMES + dev->vol_id;
+	gd->private_data = dev;
+	sprintf(gd->disk_name, "ubiblk%d_%d", dev->ubi_num, dev->vol_id);
+	pr_debug("creating a gd '%s'\n", gd->disk_name);
+	set_capacity(gd,
+		     (dev->vol_info->size *
+		      dev->vol_info->usable_leb_size) >> 9);
+	set_disk_ro(gd, 1);
+	dev->gd = gd;
+
+	spin_lock_init(&dev->queue_lock);
+	dev->rq = blk_init_queue(ubi_ubiblk_request, &dev->queue_lock);
+	if (!dev->rq) {
+		pr_err("init_queue failed\n");
+		ret = -ENODEV;
+		goto out_queue;
+	}
+	dev->rq->queuedata = dev;
+	blk_queue_logical_block_size(dev->rq, BLK_SIZE);
+	dev->gd->queue = dev->rq;
+
+	/* Stolen from mtd_blkdevs.c */
+	/* Create processing thread
+	 *
+	 * The processing of the request has to be done in process context (it
+	 * might sleep) but blk_run_queue can't block ; so we need to separate
+	 * the event of a request being added to the queue (which triggers the
+	 * callback ubi_ubiblk_request - that is set with blk_init_queue())
+	 * and the processing of that request.
+	 *
+	 * Thus, the sole purpose of ubi_ubiblk_reuqest is to wake the kthread
+	 * up so that it will process the request queue
+	 */
+	dev->thread = kthread_run(ubi_ubiblk_thread, dev, "%s%d_%d",
+				  "kubiblk", dev->ubi_num, dev->vol_id);
+	if (IS_ERR(dev->thread)) {
+		ret = PTR_ERR(dev->thread);
+		goto out_thread;
+	}
+
+	add_disk(dev->gd);
+	kfree(dev->vol_info);
+	dev->vol_info = NULL;
+	ubi_close_volume(dev->vol_desc);
+	dev->vol_desc = NULL;
+	mutex_unlock(&dev->lock);
+
+	return 0;
+
+out_thread:
+	blk_cleanup_queue(dev->rq);
+out_queue:
+	put_disk(dev->gd);
+out_disk:
+	kfree(dev->vol_info);
+	dev->vol_info = NULL;
+out_info:
+	ubi_close_volume(dev->vol_desc);
+	dev->vol_desc = NULL;
+out_vol:
+	mutex_unlock(&dev->lock);
+
+	return ret;
+}
+
+/*
+ * A UBI has been removed ; destroy the corresponding ubiblk device
+ */
+static int ubiblk_remove(struct ubi_volume_info *vol_info)
+{
+	int i;
+	struct ubiblk_dev *dev;
+
+	mutex_lock(&devtable_lock);
+	for (i = 0; i < UBIBLK_MAX_DEVS; i++) {
+		dev = ubiblk_devs[i];
+		if (dev && dev->ubi_num == vol_info->ubi_num &&
+		    dev->vol_id == vol_info->vol_id)
+			break;
+	}
+	if (i == UBIBLK_MAX_DEVS) {
+		mutex_unlock(&devtable_lock);
+		pr_warn("Trying to remove %s, but it isn't handled by ubiblk\n",
+			vol_info->name);
+		return -ENODEV;
+	}
+
+	pr_info("ubiblk: Removing %s\n", vol_info->name);
+
+	if (dev->vol_desc) {
+		ubi_close_volume(dev->vol_desc);
+		dev->vol_desc = NULL;
+	}
+
+	del_gendisk(dev->gd);
+	blk_cleanup_queue(dev->rq);
+	kthread_stop(dev->thread);
+	put_disk(dev->gd);
+
+	kfree(dev->vol_info);
+
+	kfree(ubiblk_devs[i]);
+	ubiblk_devs[i] = NULL;
+
+	mutex_unlock(&devtable_lock);
+	return 0;
+}
+
+static int ubiblk_resized(struct ubi_volume_info *vol_info)
+{
+	struct ubiblk_dev *dev;
+
+	dev = ubiblk_find_dev(vol_info);
+	if (!dev) {
+		pr_warn("Trying to resize %s, which is unknown from ubiblk\n",
+			vol_info->name);
+		return -ENODEV;
+	}
+
+	mutex_lock(&dev->lock);
+	set_capacity(dev->gd,
+		     (vol_info->size * vol_info->usable_leb_size) >> 9);
+	mutex_unlock(&dev->lock);
+	pr_debug("Resized ubiblk%d_%d to %d LEBs\n", vol_info->ubi_num,
+		 vol_info->vol_id, vol_info->size);
+	return 0;
+}
+
+/*
+ * Dispatches the UBI notifications
+ * copied from gluebi.c
+ */
+static int ubiblk_notify(struct notifier_block *nb,
+			 unsigned long notification_type, void *ns_ptr)
+{
+	struct ubi_notification *nt = ns_ptr;
+
+	switch (notification_type) {
+	case UBI_VOLUME_ADDED:
+		break;
+	case UBI_VOLUME_REMOVED:
+		ubiblk_remove(&nt->vi);
+		break;
+	case UBI_VOLUME_RESIZED:
+		ubiblk_resized(&nt->vi);
+		break;
+	case UBI_VOLUME_UPDATED:
+		break;
+	case UBI_VOLUME_RENAMED:
+		break;
+	default:
+		break;
+	}
+	return NOTIFY_OK;
+}
+
+static const struct block_device_operations ubiblk_ops = {
+	.owner = THIS_MODULE,
+	.open = ubiblk_open,
+	.release = ubiblk_release,
+};
+
+static struct notifier_block ubiblk_notifier = {
+	.notifier_call = ubiblk_notify,
+};
+
+
+/*
+ * ioctl handling for managing/unmanaging a UBI volume
+ */
+
+static long ubiblk_ctrl_ioctl(struct file *file, unsigned int cmd,
+			      unsigned long arg)
+{
+	int err = 0;
+	void __user *argp = (void __user *)arg;
+
+	struct ubi_volume_desc *vol_desc;
+	struct ubi_volume_info vol_info;
+	struct ubiblk_ctrl_req req;
+
+	if (!capable(CAP_SYS_RESOURCE))
+		return -EPERM;
+
+	err = copy_from_user(&req, argp, sizeof(struct ubiblk_ctrl_req));
+	if (err)
+		return -EFAULT;
+
+	if (req.ubi_num < 0 || req.vol_id < 0)
+		return -EINVAL;
+
+	vol_desc = ubi_open_volume(req.ubi_num, req.vol_id, UBI_READONLY);
+	if (IS_ERR(vol_desc)) {
+		pr_err("Opening volume %d on device %d failed\n",
+		       req.vol_id, req.ubi_num);
+		return PTR_ERR(vol_desc);
+	}
+
+	ubi_get_volume_info(vol_desc, &vol_info);
+
+	switch (cmd) {
+	case UBIBLK_IOCADD:
+		pr_info("Creating a ubiblk device proxing ubi%d:%d\n",
+			req.ubi_num, req.vol_id);
+		ubiblk_create(&vol_info);
+		break;
+	case UBIBLK_IOCDEL:
+		pr_info("Removing ubiblk from ubi%d:%d\n",
+			req.ubi_num, req.vol_id);
+		ubiblk_remove(&vol_info);
+		break;
+
+	default:
+		err = -ENOTTY;
+		break;
+	}
+
+	return err;
+}
+
+#ifdef CONFIG_COMPAT
+static long ubiblk_ctrl_compat_ioctl(struct file *file, unsigned int cmd,
+				     unsigned long arg)
+{
+	unsigned long translated_arg = (unsigned long)compat_ptr(arg);
+
+	return ubiblk_ctrl_ioctl(file, cmd, translated_arg);
+}
+#endif
+
+/* ubiblk control device (receives ioctls) */
+static const struct file_operations ubiblk_ctrl_ops = {
+	.owner = THIS_MODULE,
+	.unlocked_ioctl = ubiblk_ctrl_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = ubiblk_ctrl_compat_ioctl,
+#endif
+	.llseek = no_llseek,
+};
+static struct miscdevice ubiblk_ctrl_dev = {
+	.minor = MISC_DYNAMIC_MINOR,
+	.name = "ubiblk_ctrl",
+	.fops = &ubiblk_ctrl_ops,
+};
+
+/*
+ * Initialize the module
+ * (Get a major number and register to UBI notifications)
+ */
+static int __init ubi_ubiblk_init(void)
+{
+	int ret = 0;
+
+	pr_info("UBIBLK starting\n");
+
+	ret = register_blkdev(0, "ubiblk");
+	if (ret <= 0) {
+		pr_err("UBIBLK: could not register_blkdev\n");
+		return -ENODEV;
+	}
+	ubiblk_major = ret;
+	pr_info("UBIBLK: device's major: %d\n", ubiblk_major);
+
+	mutex_init(&devtable_lock);
+
+	ret = misc_register(&ubiblk_ctrl_dev);
+	if (ret) {
+		pr_err("Cannot register ubiblk_ctrl\n");
+		goto out_unreg_blk;
+	}
+
+	ret = ubi_register_volume_notifier(&ubiblk_notifier, 1);
+	if (ret < 0)
+		goto out_unreg_ctrl;
+
+	return ret;
+
+out_unreg_ctrl:
+	misc_deregister(&ubiblk_ctrl_dev);
+out_unreg_blk:
+	unregister_blkdev(ubiblk_major, "ubiblk");
+
+	return ret;
+}
+
+/*
+ * End of life
+ * unregister the block device major, unregister from UBI notifications,
+ * stop the threads and free the memory.
+ */
+static void __exit ubi_ubiblk_exit(void)
+{
+	int i;
+
+	pr_info("UBIBLK: going to exit\n");
+
+	ubi_unregister_volume_notifier(&ubiblk_notifier);
+	misc_deregister(&ubiblk_ctrl_dev);
+
+	for (i = 0; i < UBIBLK_MAX_DEVS; i++) {
+		struct ubiblk_dev *dev = ubiblk_devs[i];
+		if (!dev)
+			continue;
+
+		if (dev->vol_desc)
+			ubi_close_volume(dev->vol_desc);
+
+		del_gendisk(dev->gd);
+		blk_cleanup_queue(dev->rq);
+		kthread_stop(dev->thread);
+		put_disk(dev->gd);
+
+		kfree(dev->vol_info);
+		kfree(ubiblk_devs[i]);
+	}
+
+	unregister_blkdev(ubiblk_major, "ubiblk");
+	pr_info("UBIBLK: The End\n");
+}
+
+module_init(ubi_ubiblk_init);
+module_exit(ubi_ubiblk_exit);
+MODULE_DESCRIPTION("Read-only block transition layer on top of UBI");
+MODULE_AUTHOR("David Wagner");
+MODULE_LICENSE("GPL");
diff --git a/include/mtd/ubiblk-user.h b/include/mtd/ubiblk-user.h
new file mode 100644
index 0000000..fa0d007
--- /dev/null
+++ b/include/mtd/ubiblk-user.h
@@ -0,0 +1,43 @@
+/*
+ * Copyright © Free Electrons, 2011
+ * Copyright © International Business Machines Corp., 2006
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See
+ * the GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ * Author: David Wagner
+ * Some code taken from ubi-user.h
+ */
+
+#ifndef __UBIBLK_USER_H__
+#define __UBIBLK_USER_H__
+
+#include <linux/types.h>
+
+/* Structure to be passed to UBIBLK_IOCADD or IOCDEL ioctl */
+struct ubiblk_ctrl_req {
+	__s32 ubi_num;
+	__s32 vol_id;
+};
+
+/* ioctl commands of the UBI control character device */
+
+#define UBIBLK_CTRL_IOC_MAGIC 'O'
+
+/* Create a ubiblk device from a UBI volume */
+#define UBIBLK_IOCADD _IOW(UBIBLK_CTRL_IOC_MAGIC, 0x10, struct ubiblk_ctrl_req)
+/* Delete a ubiblk device */
+#define UBIBLK_IOCDEL _IOW(UBIBLK_CTRL_IOC_MAGIC, 0x11, struct ubiblk_ctrl_req)
+
+#endif
-- 
1.7.0.4

