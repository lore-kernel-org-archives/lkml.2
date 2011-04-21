Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000Ab1DUTAj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 15:00:39 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35071 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829Ab1DUTAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 15:00:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=K/S/YqGhZ39ErCx9iaS58mZ0+r5xpvHEmAKOxV7fMlbkc0JdJWjf43J7at33jDBphs
         LD5j8c1cUlTe0RzFfboSqZjrvtcK/FnXre3xtWKe2DTsQ60nDdScPkByfsaSd+JOf9oe
         /szg8hs1HSjUL331lCGmfTxZk5C9o6y2e/HSE=
Date: Thu, 21 Apr 2011 21:00:31 +0200
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] block: unexport DISK_EVENT_MEDIA_CHANGE for legacy/fringe
 drivers
Message-ID: <20110421190031.GJ15988@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In-kernel disk event polling doesn't matter for legacy/fringe drivers
and may lead to infinite event loop if ->check_events() implementation
generates events on level condition instead of edge.

Now that block layer supports suppressing exporting unlisted events,
simply leaving disk->events cleared allows these drivers to keep the
internal revalidation behavior intact while avoiding weird
interactions with userland event handler.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/block/DAC960.c          |    1 -
 drivers/block/amiflop.c         |    1 -
 drivers/block/ataflop.c         |    1 -
 drivers/block/floppy.c          |    1 -
 drivers/block/paride/pcd.c      |    1 -
 drivers/block/paride/pd.c       |    1 -
 drivers/block/paride/pf.c       |    1 -
 drivers/block/swim.c            |    1 -
 drivers/block/swim3.c           |    1 -
 drivers/block/ub.c              |    1 -
 drivers/block/xsysace.c         |    1 -
 drivers/cdrom/gdrom.c           |    1 -
 drivers/cdrom/viocd.c           |    1 -
 drivers/message/i2o/i2o_block.c |    1 -
 drivers/s390/char/tape_block.c  |    1 -
 15 files changed, 15 deletions(-)

diff --git a/drivers/block/DAC960.c b/drivers/block/DAC960.c
index 8066d08..e086fbb 100644
--- a/drivers/block/DAC960.c
+++ b/drivers/block/DAC960.c
@@ -2547,7 +2547,6 @@ static bool DAC960_RegisterBlockDevice(DAC960_Controller_T *Controller)
 	disk->major = MajorNumber;
 	disk->first_minor = n << DAC960_MaxPartitionsBits;
 	disk->fops = &DAC960_BlockDeviceOperations;
-	disk->events = DISK_EVENT_MEDIA_CHANGE;
    }
   /*
     Indicate the Block Device Registration completed successfully,
diff --git a/drivers/block/amiflop.c b/drivers/block/amiflop.c
index 456c0cc..8eba86b 100644
--- a/drivers/block/amiflop.c
+++ b/drivers/block/amiflop.c
@@ -1736,7 +1736,6 @@ static int __init fd_probe_drives(void)
 		disk->major = FLOPPY_MAJOR;
 		disk->first_minor = drive;
 		disk->fops = &floppy_fops;
-		disk->events = DISK_EVENT_MEDIA_CHANGE;
 		sprintf(disk->disk_name, "fd%d", drive);
 		disk->private_data = &unit[drive];
 		set_capacity(disk, 880*2);
diff --git a/drivers/block/ataflop.c b/drivers/block/ataflop.c
index c871eae..ede16c6 100644
--- a/drivers/block/ataflop.c
+++ b/drivers/block/ataflop.c
@@ -1964,7 +1964,6 @@ static int __init atari_floppy_init (void)
 		unit[i].disk->first_minor = i;
 		sprintf(unit[i].disk->disk_name, "fd%d", i);
 		unit[i].disk->fops = &floppy_fops;
-		unit[i].disk->events = DISK_EVENT_MEDIA_CHANGE;
 		unit[i].disk->private_data = &unit[i];
 		unit[i].disk->queue = blk_init_queue(do_fd_request,
 					&ataflop_lock);
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 301d7a9..db8f885 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4205,7 +4205,6 @@ static int __init floppy_init(void)
 		disks[dr]->major = FLOPPY_MAJOR;
 		disks[dr]->first_minor = TOMINOR(dr);
 		disks[dr]->fops = &floppy_fops;
-		disks[dr]->events = DISK_EVENT_MEDIA_CHANGE;
 		sprintf(disks[dr]->disk_name, "fd%d", dr);
 
 		init_timer(&motor_off_timer[dr]);
diff --git a/drivers/block/paride/pcd.c b/drivers/block/paride/pcd.c
index 2f2ccf6..8690e31 100644
--- a/drivers/block/paride/pcd.c
+++ b/drivers/block/paride/pcd.c
@@ -320,7 +320,6 @@ static void pcd_init_units(void)
 		disk->first_minor = unit;
 		strcpy(disk->disk_name, cd->name);	/* umm... */
 		disk->fops = &pcd_bdops;
-		disk->events = DISK_EVENT_MEDIA_CHANGE;
 	}
 }
 
diff --git a/drivers/block/paride/pd.c b/drivers/block/paride/pd.c
index 21dfdb7..869e767 100644
--- a/drivers/block/paride/pd.c
+++ b/drivers/block/paride/pd.c
@@ -837,7 +837,6 @@ static void pd_probe_drive(struct pd_unit *disk)
 	p->fops = &pd_fops;
 	p->major = major;
 	p->first_minor = (disk - pd) << PD_BITS;
-	p->events = DISK_EVENT_MEDIA_CHANGE;
 	disk->gd = p;
 	p->private_data = disk;
 	p->queue = pd_queue;
diff --git a/drivers/block/paride/pf.c b/drivers/block/paride/pf.c
index 7adeb1e..f21b520 100644
--- a/drivers/block/paride/pf.c
+++ b/drivers/block/paride/pf.c
@@ -294,7 +294,6 @@ static void __init pf_init_units(void)
 		disk->first_minor = unit;
 		strcpy(disk->disk_name, pf->name);
 		disk->fops = &pf_fops;
-		disk->events = DISK_EVENT_MEDIA_CHANGE;
 		if (!(*drives[unit])[D_PRT])
 			pf_drive_count++;
 	}
diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index 24a482f..fd5adcd 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -858,7 +858,6 @@ static int __devinit swim_floppy_init(struct swim_priv *swd)
 		swd->unit[drive].disk->first_minor = drive;
 		sprintf(swd->unit[drive].disk->disk_name, "fd%d", drive);
 		swd->unit[drive].disk->fops = &floppy_fops;
-		swd->unit[drive].disk->events = DISK_EVENT_MEDIA_CHANGE;
 		swd->unit[drive].disk->private_data = &swd->unit[drive];
 		swd->unit[drive].disk->queue = swd->queue;
 		set_capacity(swd->unit[drive].disk, 2880);
diff --git a/drivers/block/swim3.c b/drivers/block/swim3.c
index 4c10f56..773bfa7 100644
--- a/drivers/block/swim3.c
+++ b/drivers/block/swim3.c
@@ -1163,7 +1163,6 @@ static int __devinit swim3_attach(struct macio_dev *mdev, const struct of_device
 	disk->major = FLOPPY_MAJOR;
 	disk->first_minor = i;
 	disk->fops = &floppy_fops;
-	disk->events = DISK_EVENT_MEDIA_CHANGE;
 	disk->private_data = &floppy_states[i];
 	disk->queue = swim3_queue;
 	disk->flags |= GENHD_FL_REMOVABLE;
diff --git a/drivers/block/ub.c b/drivers/block/ub.c
index 68b9430..0e376d4 100644
--- a/drivers/block/ub.c
+++ b/drivers/block/ub.c
@@ -2334,7 +2334,6 @@ static int ub_probe_lun(struct ub_dev *sc, int lnum)
 	disk->major = UB_MAJOR;
 	disk->first_minor = lun->id * UB_PARTS_PER_LUN;
 	disk->fops = &ub_bd_fops;
-	disk->events = DISK_EVENT_MEDIA_CHANGE;
 	disk->private_data = lun;
 	disk->driverfs_dev = &sc->intf->dev;
 
diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
index 645ff76..6c7fd7d 100644
--- a/drivers/block/xsysace.c
+++ b/drivers/block/xsysace.c
@@ -1005,7 +1005,6 @@ static int __devinit ace_setup(struct ace_device *ace)
 	ace->gd->major = ace_major;
 	ace->gd->first_minor = ace->id * ACE_NUM_MINORS;
 	ace->gd->fops = &ace_fops;
-	ace->gd->events = DISK_EVENT_MEDIA_CHANGE;
 	ace->gd->queue = ace->queue;
 	ace->gd->private_data = ace;
 	snprintf(ace->gd->disk_name, 32, "xs%c", ace->id + 'a');
diff --git a/drivers/cdrom/gdrom.c b/drivers/cdrom/gdrom.c
index b2b034f..3ceaf00 100644
--- a/drivers/cdrom/gdrom.c
+++ b/drivers/cdrom/gdrom.c
@@ -803,7 +803,6 @@ static int __devinit probe_gdrom(struct platform_device *devptr)
 		goto probe_fail_cdrom_register;
 	}
 	gd.disk->fops = &gdrom_bdops;
-	gd.disk->events = DISK_EVENT_MEDIA_CHANGE;
 	/* latch on to the interrupt */
 	err = gdrom_set_interrupt_handlers();
 	if (err)
diff --git a/drivers/cdrom/viocd.c b/drivers/cdrom/viocd.c
index 4e874c5..e427fbe 100644
--- a/drivers/cdrom/viocd.c
+++ b/drivers/cdrom/viocd.c
@@ -626,7 +626,6 @@ static int viocd_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	gendisk->queue = q;
 	gendisk->fops = &viocd_fops;
 	gendisk->flags = GENHD_FL_CD|GENHD_FL_REMOVABLE;
-	gendisk->events = DISK_EVENT_MEDIA_CHANGE;
 	set_capacity(gendisk, 0);
 	gendisk->private_data = d;
 	d->viocd_disk = gendisk;
diff --git a/drivers/message/i2o/i2o_block.c b/drivers/message/i2o/i2o_block.c
index 643ad52..4796bbf 100644
--- a/drivers/message/i2o/i2o_block.c
+++ b/drivers/message/i2o/i2o_block.c
@@ -1000,7 +1000,6 @@ static struct i2o_block_device *i2o_block_device_alloc(void)
 	gd->major = I2O_MAJOR;
 	gd->queue = queue;
 	gd->fops = &i2o_block_fops;
-	gd->events = DISK_EVENT_MEDIA_CHANGE;
 	gd->private_data = dev;
 
 	dev->gd = gd;
diff --git a/drivers/s390/char/tape_block.c b/drivers/s390/char/tape_block.c
index 83cea9a..1b3924c 100644
--- a/drivers/s390/char/tape_block.c
+++ b/drivers/s390/char/tape_block.c
@@ -236,7 +236,6 @@ tapeblock_setup_device(struct tape_device * device)
 	disk->major = tapeblock_major;
 	disk->first_minor = device->first_minor;
 	disk->fops = &tapeblock_fops;
-	disk->events = DISK_EVENT_MEDIA_CHANGE;
 	disk->private_data = tape_get_device(device);
 	disk->queue = blkdat->request_queue;
 	set_capacity(disk, 0);
