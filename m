Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223Ab0INTyF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 15:54:05 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:62745 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754900Ab0INTxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 15:53:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7/7] block: autoconvert trivial BKL users to private mutex
Date: Tue, 14 Sep 2010 21:53:42 +0200
Message-Id: <1284494022-7346-8-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284494022-7346-1-git-send-email-arnd@arndb.de>
References: <1284494022-7346-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:pU5YhVUAv6yKIHXY/TuzsPysHTsTn2TllUFnePmmJLP
 86Ihdg1W2i0iUNhn8/sACugAqXPKsC/qGdNjO6Juht1E2FNPEr
 isRUNKSqodlfFnKS5CNhh9CClNcM0ZGzQOJQlWLU5zrQpMUCLS
 54xMcl59H/+rNTbuVIqLYKZWxC2q5xYf90sEdc0AfgyJBSmM/4
 Nm2wp3nc3g+JMJhQYSzKw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The block device drivers have all gained new lock_kernel
calls from a recent pushdown, and some of the drivers
were already using the BKL before.

This turns the BKL into a set of per-driver mutexes.
Still need to check whether this is safe to do.

file=$1
name=$2
if grep -q lock_kernel ${file} ; then
    if grep -q 'include.*linux.mutex.h' ${file} ; then
            sed -i '/include.*<linux\/smp_lock.h>/d' ${file}
    else
            sed -i 's/include.*<linux\/smp_lock.h>.*$/include <linux\/mutex.h>/g' ${file}
    fi
    sed -i ${file} \
        -e "/^#include.*linux.mutex.h/,$ {
                1,/^\(static\|int\|long\)/ {
                     /^\(static\|int\|long\)/istatic DEFINE_MUTEX(${name}_mutex);

} }"  \
    -e "s/\(un\)*lock_kernel\>[ ]*()/mutex_\1lock(\&${name}_mutex)/g" \
    -e '/[      ]*cycle_kernel_lock();/d'
else
    sed -i -e '/include.*\<smp_lock.h\>/d' ${file}  \
                -e '/cycle_kernel_lock()/d'
fi

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/bsg.c                         |    3 ---
 drivers/block/DAC960.c              |   11 ++++++-----
 drivers/block/amiflop.c             |   19 ++++++++++---------
 drivers/block/aoe/aoeblk.c          |    9 +++++----
 drivers/block/aoe/aoechr.c          |    9 +++++----
 drivers/block/ataflop.c             |   15 ++++++++-------
 drivers/block/brd.c                 |    7 ++++---
 drivers/block/cciss.c               |   14 +++++++-------
 drivers/block/cpqarray.c            |   15 ++++++++-------
 drivers/block/drbd/drbd_main.c      |   11 ++++++-----
 drivers/block/floppy.c              |   16 ++++++++--------
 drivers/block/loop.c                |   11 ++++++-----
 drivers/block/nbd.c                 |    7 ++++---
 drivers/block/paride/pcd.c          |   15 ++++++++-------
 drivers/block/paride/pd.c           |   15 ++++++++-------
 drivers/block/paride/pf.c           |   17 +++++++++--------
 drivers/block/pktcdvd.c             |   16 ++++++++--------
 drivers/block/swim.c                |   15 ++++++++-------
 drivers/block/swim3.c               |   15 ++++++++-------
 drivers/block/ub.c                  |   15 ++++++++-------
 drivers/block/viodasd.c             |   11 ++++++-----
 drivers/block/virtio_blk.c          |    7 ++++---
 drivers/block/xd.c                  |    7 ++++---
 drivers/block/xen-blkfront.c        |   11 ++++++-----
 drivers/block/xsysace.c             |   11 ++++++-----
 drivers/block/z2ram.c               |   15 ++++++++-------
 drivers/cdrom/gdrom.c               |   15 ++++++++-------
 drivers/cdrom/viocd.c               |   15 ++++++++-------
 drivers/ide/ide-cd.c                |   14 +++++++-------
 drivers/ide/ide-disk_ioctl.c        |    7 ++++---
 drivers/ide/ide-floppy_ioctl.c      |    7 ++++---
 drivers/ide/ide-gd.c                |   10 +++++-----
 drivers/ide/ide-tape.c              |   19 +++++++++----------
 drivers/md/dm.c                     |   10 +++++-----
 drivers/md/md.c                     |   13 +++++++------
 drivers/memstick/core/mspro_block.c |   11 ++++++-----
 drivers/message/i2o/i2o_block.c     |   15 ++++++++-------
 drivers/mmc/card/block.c            |   10 +++++-----
 drivers/mtd/mtd_blkdevs.c           |   14 +++++++-------
 drivers/s390/char/tape_block.c      |   13 +++++++------
 drivers/scsi/sr.c                   |   14 +++++++-------
 drivers/scsi/st.c                   |   12 ++++++------
 drivers/staging/hv/blkvsc_drv.c     |   11 ++++++-----
 drivers/staging/spectra/ffsport.c   |    7 ++++---
 44 files changed, 281 insertions(+), 253 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index 82d5882..ffd79ca 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -20,7 +20,6 @@
 #include <linux/uio.h>
 #include <linux/idr.h>
 #include <linux/bsg.h>
-#include <linux/smp_lock.h>
 #include <linux/slab.h>
 
 #include <scsi/scsi.h>
@@ -843,9 +842,7 @@ static int bsg_open(struct inode *inode, struct file *file)
 {
 	struct bsg_device *bd;
 
-	lock_kernel();
 	bd = bsg_get_device(inode, file);
-	unlock_kernel();
 
 	if (IS_ERR(bd))
 		return PTR_ERR(bd);
diff --git a/drivers/block/DAC960.c b/drivers/block/DAC960.c
index 4e2c367..da0f6dd 100644
--- a/drivers/block/DAC960.c
+++ b/drivers/block/DAC960.c
@@ -36,7 +36,7 @@
 #include <linux/ioport.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/reboot.h>
@@ -54,6 +54,7 @@
 #define DAC960_GAM_MINOR	252
 
 
+static DEFINE_MUTEX(DAC960_mutex);
 static DAC960_Controller_T *DAC960_Controllers[DAC960_MaxControllers];
 static int DAC960_ControllerCount;
 static struct proc_dir_entry *DAC960_ProcDirectoryEntry;
@@ -81,7 +82,7 @@ static int DAC960_open(struct block_device *bdev, fmode_t mode)
 	int drive_nr = (long)disk->private_data;
 	int ret = -ENXIO;
 
-	lock_kernel();
+	mutex_lock(&DAC960_mutex);
 	if (p->FirmwareType == DAC960_V1_Controller) {
 		if (p->V1.LogicalDriveInformation[drive_nr].
 		    LogicalDriveState == DAC960_V1_LogicalDrive_Offline)
@@ -99,7 +100,7 @@ static int DAC960_open(struct block_device *bdev, fmode_t mode)
 		goto out;
 	ret = 0;
 out:
-	unlock_kernel();
+	mutex_unlock(&DAC960_mutex);
 	return ret;
 }
 
@@ -6625,7 +6626,7 @@ static long DAC960_gam_ioctl(struct file *file, unsigned int Request,
   long ErrorCode = 0;
   if (!capable(CAP_SYS_ADMIN)) return -EACCES;
 
-  lock_kernel();
+  mutex_lock(&DAC960_mutex);
   switch (Request)
     {
     case DAC960_IOCTL_GET_CONTROLLER_COUNT:
@@ -7056,7 +7057,7 @@ static long DAC960_gam_ioctl(struct file *file, unsigned int Request,
       default:
 	ErrorCode = -ENOTTY;
     }
-  unlock_kernel();
+  mutex_unlock(&DAC960_mutex);
   return ErrorCode;
 }
 
diff --git a/drivers/block/amiflop.c b/drivers/block/amiflop.c
index 76f114f..4b852c9 100644
--- a/drivers/block/amiflop.c
+++ b/drivers/block/amiflop.c
@@ -60,7 +60,7 @@
 #include <linux/hdreg.h>
 #include <linux/delay.h>
 #include <linux/init.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/amifdreg.h>
 #include <linux/amifd.h>
 #include <linux/buffer_head.h>
@@ -109,6 +109,7 @@
 #define FD_HD_3 	0x55555555  /* high-density 3.5" (1760K) drive */
 #define FD_DD_5 	0xaaaaaaaa  /* double-density 5.25" (440K) drive */
 
+static DEFINE_MUTEX(amiflop_mutex);
 static unsigned long int fd_def_df0 = FD_DD_3;     /* default for df0 if it doesn't identify */
 
 module_param(fd_def_df0, ulong, 0);
@@ -1506,9 +1507,9 @@ static int fd_ioctl(struct block_device *bdev, fmode_t mode,
 {
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&amiflop_mutex);
 	ret = fd_locked_ioctl(bdev, mode, cmd, param);
-	unlock_kernel();
+	mutex_unlock(&amiflop_mutex);
 
 	return ret;
 }
@@ -1555,11 +1556,11 @@ static int floppy_open(struct block_device *bdev, fmode_t mode)
 	int old_dev;
 	unsigned long flags;
 
-	lock_kernel();
+	mutex_lock(&amiflop_mutex);
 	old_dev = fd_device[drive];
 
 	if (fd_ref[drive] && old_dev != system) {
-		unlock_kernel();
+		mutex_unlock(&amiflop_mutex);
 		return -EBUSY;
 	}
 
@@ -1575,7 +1576,7 @@ static int floppy_open(struct block_device *bdev, fmode_t mode)
 			rel_fdc();
 
 			if (wrprot) {
-				unlock_kernel();
+				mutex_unlock(&amiflop_mutex);
 				return -EROFS;
 			}
 		}
@@ -1594,7 +1595,7 @@ static int floppy_open(struct block_device *bdev, fmode_t mode)
 	printk(KERN_INFO "fd%d: accessing %s-disk with %s-layout\n",drive,
 	       unit[drive].type->name, data_types[system].name);
 
-	unlock_kernel();
+	mutex_unlock(&amiflop_mutex);
 	return 0;
 }
 
@@ -1603,7 +1604,7 @@ static int floppy_release(struct gendisk *disk, fmode_t mode)
 	struct amiga_floppy_struct *p = disk->private_data;
 	int drive = p - unit;
 
-	lock_kernel();
+	mutex_lock(&amiflop_mutex);
 	if (unit[drive].dirty == 1) {
 		del_timer (flush_track_timer + drive);
 		non_int_flush_track (drive);
@@ -1617,7 +1618,7 @@ static int floppy_release(struct gendisk *disk, fmode_t mode)
 /* the mod_use counter is handled this way */
 	floppy_off (drive | 0x40000000);
 #endif
-	unlock_kernel();
+	mutex_unlock(&amiflop_mutex);
 	return 0;
 }
 
diff --git a/drivers/block/aoe/aoeblk.c b/drivers/block/aoe/aoeblk.c
index a946929..f21c237 100644
--- a/drivers/block/aoe/aoeblk.c
+++ b/drivers/block/aoe/aoeblk.c
@@ -12,9 +12,10 @@
 #include <linux/slab.h>
 #include <linux/genhd.h>
 #include <linux/netdevice.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include "aoe.h"
 
+static DEFINE_MUTEX(aoeblk_mutex);
 static struct kmem_cache *buf_pool_cache;
 
 static ssize_t aoedisk_show_state(struct device *dev,
@@ -125,16 +126,16 @@ aoeblk_open(struct block_device *bdev, fmode_t mode)
 	struct aoedev *d = bdev->bd_disk->private_data;
 	ulong flags;
 
-	lock_kernel();
+	mutex_lock(&aoeblk_mutex);
 	spin_lock_irqsave(&d->lock, flags);
 	if (d->flags & DEVFL_UP) {
 		d->nopen++;
 		spin_unlock_irqrestore(&d->lock, flags);
-		unlock_kernel();
+		mutex_unlock(&aoeblk_mutex);
 		return 0;
 	}
 	spin_unlock_irqrestore(&d->lock, flags);
-	unlock_kernel();
+	mutex_unlock(&aoeblk_mutex);
 	return -ENODEV;
 }
 
diff --git a/drivers/block/aoe/aoechr.c b/drivers/block/aoe/aoechr.c
index 4a1b9e7..05d5ef1 100644
--- a/drivers/block/aoe/aoechr.c
+++ b/drivers/block/aoe/aoechr.c
@@ -9,7 +9,7 @@
 #include <linux/completion.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/skbuff.h>
 #include "aoe.h"
 
@@ -37,6 +37,7 @@ struct ErrMsg {
 	char *msg;
 };
 
+static DEFINE_MUTEX(aoechr_mutex);
 static struct ErrMsg emsgs[NMSG];
 static int emsgs_head_idx, emsgs_tail_idx;
 static struct completion emsgs_comp;
@@ -183,16 +184,16 @@ aoechr_open(struct inode *inode, struct file *filp)
 {
 	int n, i;
 
-	lock_kernel();
+	mutex_lock(&aoechr_mutex);
 	n = iminor(inode);
 	filp->private_data = (void *) (unsigned long) n;
 
 	for (i = 0; i < ARRAY_SIZE(chardevs); ++i)
 		if (chardevs[i].minor == n) {
-			unlock_kernel();
+			mutex_unlock(&aoechr_mutex);
 			return 0;
 		}
-	unlock_kernel();
+	mutex_unlock(&aoechr_mutex);
 	return -EINVAL;
 }
 
diff --git a/drivers/block/ataflop.c b/drivers/block/ataflop.c
index aceb964..8c021bb 100644
--- a/drivers/block/ataflop.c
+++ b/drivers/block/ataflop.c
@@ -67,7 +67,7 @@
 #include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/blkdev.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 
 #include <asm/atafd.h>
 #include <asm/atafdreg.h>
@@ -79,6 +79,7 @@
 
 #undef DEBUG
 
+static DEFINE_MUTEX(ataflop_mutex);
 static struct request_queue *floppy_queue;
 static struct request *fd_request;
 
@@ -1671,9 +1672,9 @@ static int fd_ioctl(struct block_device *bdev, fmode_t mode,
 {
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&ataflop_mutex);
 	ret = fd_locked_ioctl(bdev, mode, cmd, arg);
-	unlock_kernel();
+	mutex_unlock(&ataflop_mutex);
 
 	return ret;
 }
@@ -1854,9 +1855,9 @@ static int floppy_unlocked_open(struct block_device *bdev, fmode_t mode)
 {
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&ataflop_mutex);
 	ret = floppy_open(bdev, mode);
-	unlock_kernel();
+	mutex_unlock(&ataflop_mutex);
 
 	return ret;
 }
@@ -1864,14 +1865,14 @@ static int floppy_unlocked_open(struct block_device *bdev, fmode_t mode)
 static int floppy_release(struct gendisk *disk, fmode_t mode)
 {
 	struct atari_floppy_struct *p = disk->private_data;
-	lock_kernel();
+	mutex_lock(&ataflop_mutex);
 	if (p->ref < 0)
 		p->ref = 0;
 	else if (!p->ref--) {
 		printk(KERN_ERR "floppy_release with fd_ref == 0");
 		p->ref = 0;
 	}
-	unlock_kernel();
+	mutex_unlock(&ataflop_mutex);
 	return 0;
 }
 
diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 1c7f637..82bfd5b 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -15,7 +15,7 @@
 #include <linux/blkdev.h>
 #include <linux/bio.h>
 #include <linux/highmem.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/radix-tree.h>
 #include <linux/buffer_head.h> /* invalidate_bh_lrus() */
 #include <linux/slab.h>
@@ -55,6 +55,7 @@ struct brd_device {
 /*
  * Look up and return a brd's page for a given sector.
  */
+static DEFINE_MUTEX(brd_mutex);
 static struct page *brd_lookup_page(struct brd_device *brd, sector_t sector)
 {
 	pgoff_t idx;
@@ -402,7 +403,7 @@ static int brd_ioctl(struct block_device *bdev, fmode_t mode,
 	 * ram device BLKFLSBUF has special semantics, we want to actually
 	 * release and destroy the ramdisk data.
 	 */
-	lock_kernel();
+	mutex_lock(&brd_mutex);
 	mutex_lock(&bdev->bd_mutex);
 	error = -EBUSY;
 	if (bdev->bd_openers <= 1) {
@@ -419,7 +420,7 @@ static int brd_ioctl(struct block_device *bdev, fmode_t mode,
 		error = 0;
 	}
 	mutex_unlock(&bdev->bd_mutex);
-	unlock_kernel();
+	mutex_unlock(&brd_mutex);
 
 	return error;
 }
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 31064df..ac54edd 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -26,7 +26,6 @@
 #include <linux/pci.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/delay.h>
 #include <linux/major.h>
 #include <linux/fs.h>
@@ -66,6 +65,7 @@ MODULE_SUPPORTED_DEVICE("HP Smart Array Controllers");
 MODULE_VERSION("3.6.26");
 MODULE_LICENSE("GPL");
 
+static DEFINE_MUTEX(cciss_mutex);
 static int cciss_allow_hpsa;
 module_param(cciss_allow_hpsa, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(cciss_allow_hpsa,
@@ -1057,9 +1057,9 @@ static int cciss_unlocked_open(struct block_device *bdev, fmode_t mode)
 {
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&cciss_mutex);
 	ret = cciss_open(bdev, mode);
-	unlock_kernel();
+	mutex_unlock(&cciss_mutex);
 
 	return ret;
 }
@@ -1072,13 +1072,13 @@ static int cciss_release(struct gendisk *disk, fmode_t mode)
 	ctlr_info_t *h;
 	drive_info_struct *drv;
 
-	lock_kernel();
+	mutex_lock(&cciss_mutex);
 	h = get_host(disk);
 	drv = get_drv(disk);
 	dev_dbg(&h->pdev->dev, "cciss_release %s\n", disk->disk_name);
 	drv->usage_count--;
 	h->usage_count--;
-	unlock_kernel();
+	mutex_unlock(&cciss_mutex);
 	return 0;
 }
 
@@ -1086,9 +1086,9 @@ static int do_ioctl(struct block_device *bdev, fmode_t mode,
 		    unsigned cmd, unsigned long arg)
 {
 	int ret;
-	lock_kernel();
+	mutex_lock(&cciss_mutex);
 	ret = cciss_ioctl(bdev, mode, cmd, arg);
-	unlock_kernel();
+	mutex_unlock(&cciss_mutex);
 	return ret;
 }
 
diff --git a/drivers/block/cpqarray.c b/drivers/block/cpqarray.c
index d53b029..946dad4 100644
--- a/drivers/block/cpqarray.c
+++ b/drivers/block/cpqarray.c
@@ -35,7 +35,7 @@
 #include <linux/seq_file.h>
 #include <linux/init.h>
 #include <linux/hdreg.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/spinlock.h>
 #include <linux/blkdev.h>
 #include <linux/genhd.h>
@@ -68,6 +68,7 @@ MODULE_LICENSE("GPL");
 
 #define CPQARRAY_DMA_MASK	0xFFFFFFFF	/* 32 bit DMA */
 
+static DEFINE_MUTEX(cpqarray_mutex);
 static int nr_ctlr;
 static ctlr_info_t *hba[MAX_CTLR];
 
@@ -845,9 +846,9 @@ static int ida_unlocked_open(struct block_device *bdev, fmode_t mode)
 {
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&cpqarray_mutex);
 	ret = ida_open(bdev, mode);
-	unlock_kernel();
+	mutex_unlock(&cpqarray_mutex);
 
 	return ret;
 }
@@ -859,10 +860,10 @@ static int ida_release(struct gendisk *disk, fmode_t mode)
 {
 	ctlr_info_t *host;
 
-	lock_kernel();
+	mutex_lock(&cpqarray_mutex);
 	host = get_host(disk);
 	host->usage_count--;
-	unlock_kernel();
+	mutex_unlock(&cpqarray_mutex);
 
 	return 0;
 }
@@ -1217,9 +1218,9 @@ static int ida_ioctl(struct block_device *bdev, fmode_t mode,
 {
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&cpqarray_mutex);
 	ret = ida_locked_ioctl(bdev, mode, cmd, param);
-	unlock_kernel();
+	mutex_unlock(&cpqarray_mutex);
 
 	return ret;
 }
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index fa650dd..e4b5611 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -32,7 +32,7 @@
 #include <asm/types.h>
 #include <net/sock.h>
 #include <linux/ctype.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/fs.h>
 #include <linux/file.h>
 #include <linux/proc_fs.h>
@@ -64,6 +64,7 @@ struct after_state_chg_work {
 	struct completion *done;
 };
 
+static DEFINE_MUTEX(drbd_main_mutex);
 int drbdd_init(struct drbd_thread *);
 int drbd_worker(struct drbd_thread *);
 int drbd_asender(struct drbd_thread *);
@@ -2536,7 +2537,7 @@ static int drbd_open(struct block_device *bdev, fmode_t mode)
 	unsigned long flags;
 	int rv = 0;
 
-	lock_kernel();
+	mutex_lock(&drbd_main_mutex);
 	spin_lock_irqsave(&mdev->req_lock, flags);
 	/* to have a stable mdev->state.role
 	 * and no race with updating open_cnt */
@@ -2551,7 +2552,7 @@ static int drbd_open(struct block_device *bdev, fmode_t mode)
 	if (!rv)
 		mdev->open_cnt++;
 	spin_unlock_irqrestore(&mdev->req_lock, flags);
-	unlock_kernel();
+	mutex_unlock(&drbd_main_mutex);
 
 	return rv;
 }
@@ -2559,9 +2560,9 @@ static int drbd_open(struct block_device *bdev, fmode_t mode)
 static int drbd_release(struct gendisk *gd, fmode_t mode)
 {
 	struct drbd_conf *mdev = gd->private_data;
-	lock_kernel();
+	mutex_lock(&drbd_main_mutex);
 	mdev->open_cnt--;
-	unlock_kernel();
+	mutex_unlock(&drbd_main_mutex);
 	return 0;
 }
 
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index cf04c1b..3b57459 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -178,7 +178,6 @@ static int print_unex = 1;
 #include <linux/slab.h>
 #include <linux/mm.h>
 #include <linux/bio.h>
-#include <linux/smp_lock.h>
 #include <linux/string.h>
 #include <linux/jiffies.h>
 #include <linux/fcntl.h>
@@ -199,6 +198,7 @@ static int print_unex = 1;
  * It's been recommended that take about 1/4 of the default speed
  * in some more extreme cases.
  */
+static DEFINE_MUTEX(floppy_mutex);
 static int slow_floppy;
 
 #include <asm/dma.h>
@@ -3553,9 +3553,9 @@ static int fd_ioctl(struct block_device *bdev, fmode_t mode,
 {
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&floppy_mutex);
 	ret = fd_locked_ioctl(bdev, mode, cmd, param);
-	unlock_kernel();
+	mutex_unlock(&floppy_mutex);
 
 	return ret;
 }
@@ -3616,7 +3616,7 @@ static int floppy_release(struct gendisk *disk, fmode_t mode)
 {
 	int drive = (long)disk->private_data;
 
-	lock_kernel();
+	mutex_lock(&floppy_mutex);
 	mutex_lock(&open_lock);
 	if (UDRS->fd_ref < 0)
 		UDRS->fd_ref = 0;
@@ -3627,7 +3627,7 @@ static int floppy_release(struct gendisk *disk, fmode_t mode)
 	if (!UDRS->fd_ref)
 		opened_bdev[drive] = NULL;
 	mutex_unlock(&open_lock);
-	unlock_kernel();
+	mutex_unlock(&floppy_mutex);
 
 	return 0;
 }
@@ -3645,7 +3645,7 @@ static int floppy_open(struct block_device *bdev, fmode_t mode)
 	int res = -EBUSY;
 	char *tmp;
 
-	lock_kernel();
+	mutex_lock(&floppy_mutex);
 	mutex_lock(&open_lock);
 	old_dev = UDRS->fd_device;
 	if (opened_bdev[drive] && opened_bdev[drive] != bdev)
@@ -3722,7 +3722,7 @@ static int floppy_open(struct block_device *bdev, fmode_t mode)
 			goto out;
 	}
 	mutex_unlock(&open_lock);
-	unlock_kernel();
+	mutex_unlock(&floppy_mutex);
 	return 0;
 out:
 	if (UDRS->fd_ref < 0)
@@ -3733,7 +3733,7 @@ out:
 		opened_bdev[drive] = NULL;
 out2:
 	mutex_unlock(&open_lock);
-	unlock_kernel();
+	mutex_unlock(&floppy_mutex);
 	return res;
 }
 
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index f3c636d..26450f7 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -67,7 +67,7 @@
 #include <linux/compat.h>
 #include <linux/suspend.h>
 #include <linux/freezer.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/writeback.h>
 #include <linux/buffer_head.h>		/* for invalidate_bdev() */
 #include <linux/completion.h>
@@ -77,6 +77,7 @@
 
 #include <asm/uaccess.h>
 
+static DEFINE_MUTEX(loop_mutex);
 static LIST_HEAD(loop_devices);
 static DEFINE_MUTEX(loop_devices_mutex);
 
@@ -1409,11 +1410,11 @@ static int lo_open(struct block_device *bdev, fmode_t mode)
 {
 	struct loop_device *lo = bdev->bd_disk->private_data;
 
-	lock_kernel();
+	mutex_lock(&loop_mutex);
 	mutex_lock(&lo->lo_ctl_mutex);
 	lo->lo_refcnt++;
 	mutex_unlock(&lo->lo_ctl_mutex);
-	unlock_kernel();
+	mutex_unlock(&loop_mutex);
 
 	return 0;
 }
@@ -1423,7 +1424,7 @@ static int lo_release(struct gendisk *disk, fmode_t mode)
 	struct loop_device *lo = disk->private_data;
 	int err;
 
-	lock_kernel();
+	mutex_lock(&loop_mutex);
 	mutex_lock(&lo->lo_ctl_mutex);
 
 	if (--lo->lo_refcnt)
@@ -1448,7 +1449,7 @@ static int lo_release(struct gendisk *disk, fmode_t mode)
 out:
 	mutex_unlock(&lo->lo_ctl_mutex);
 out_unlocked:
-	lock_kernel();
+	mutex_unlock(&loop_mutex);
 	return 0;
 }
 
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 0daa422..a32fb41 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -24,7 +24,7 @@
 #include <linux/errno.h>
 #include <linux/file.h>
 #include <linux/ioctl.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/compiler.h>
 #include <linux/err.h>
 #include <linux/kernel.h>
@@ -53,6 +53,7 @@
 #define DBG_BLKDEV      0x0100
 #define DBG_RX          0x0200
 #define DBG_TX          0x0400
+static DEFINE_MUTEX(nbd_mutex);
 static unsigned int debugflags;
 #endif /* NDEBUG */
 
@@ -717,11 +718,11 @@ static int nbd_ioctl(struct block_device *bdev, fmode_t mode,
 	dprintk(DBG_IOCTL, "%s: nbd_ioctl cmd=%s(0x%x) arg=%lu\n",
 			lo->disk->disk_name, ioctl_cmd_to_ascii(cmd), cmd, arg);
 
-	lock_kernel();
+	mutex_lock(&nbd_mutex);
 	mutex_lock(&lo->tx_lock);
 	error = __nbd_ioctl(bdev, lo, cmd, arg);
 	mutex_unlock(&lo->tx_lock);
-	unlock_kernel();
+	mutex_unlock(&nbd_mutex);
 
 	return error;
 }
diff --git a/drivers/block/paride/pcd.c b/drivers/block/paride/pcd.c
index 76f8565..62cec6a 100644
--- a/drivers/block/paride/pcd.c
+++ b/drivers/block/paride/pcd.c
@@ -138,9 +138,10 @@ enum {D_PRT, D_PRO, D_UNI, D_MOD, D_SLV, D_DLY};
 #include <linux/cdrom.h>
 #include <linux/spinlock.h>
 #include <linux/blkdev.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <asm/uaccess.h>
 
+static DEFINE_MUTEX(pcd_mutex);
 static DEFINE_SPINLOCK(pcd_lock);
 
 module_param(verbose, bool, 0644);
@@ -227,9 +228,9 @@ static int pcd_block_open(struct block_device *bdev, fmode_t mode)
 	struct pcd_unit *cd = bdev->bd_disk->private_data;
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&pcd_mutex);
 	ret = cdrom_open(&cd->info, bdev, mode);
-	unlock_kernel();
+	mutex_unlock(&pcd_mutex);
 
 	return ret;
 }
@@ -237,9 +238,9 @@ static int pcd_block_open(struct block_device *bdev, fmode_t mode)
 static int pcd_block_release(struct gendisk *disk, fmode_t mode)
 {
 	struct pcd_unit *cd = disk->private_data;
-	lock_kernel();
+	mutex_lock(&pcd_mutex);
 	cdrom_release(&cd->info, mode);
-	unlock_kernel();
+	mutex_unlock(&pcd_mutex);
 	return 0;
 }
 
@@ -249,9 +250,9 @@ static int pcd_block_ioctl(struct block_device *bdev, fmode_t mode,
 	struct pcd_unit *cd = bdev->bd_disk->private_data;
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&pcd_mutex);
 	ret = cdrom_ioctl(&cd->info, bdev, mode, cmd, arg);
-	unlock_kernel();
+	mutex_unlock(&pcd_mutex);
 
 	return ret;
 }
diff --git a/drivers/block/paride/pd.c b/drivers/block/paride/pd.c
index 985f0d4..c0ee155 100644
--- a/drivers/block/paride/pd.c
+++ b/drivers/block/paride/pd.c
@@ -153,10 +153,11 @@ enum {D_PRT, D_PRO, D_UNI, D_MOD, D_GEO, D_SBY, D_DLY, D_SLV};
 #include <linux/blkdev.h>
 #include <linux/blkpg.h>
 #include <linux/kernel.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <asm/uaccess.h>
 #include <linux/workqueue.h>
 
+static DEFINE_MUTEX(pd_mutex);
 static DEFINE_SPINLOCK(pd_lock);
 
 module_param(verbose, bool, 0);
@@ -736,14 +737,14 @@ static int pd_open(struct block_device *bdev, fmode_t mode)
 {
 	struct pd_unit *disk = bdev->bd_disk->private_data;
 
-	lock_kernel();
+	mutex_lock(&pd_mutex);
 	disk->access++;
 
 	if (disk->removable) {
 		pd_special_command(disk, pd_media_check);
 		pd_special_command(disk, pd_door_lock);
 	}
-	unlock_kernel();
+	mutex_unlock(&pd_mutex);
 	return 0;
 }
 
@@ -771,10 +772,10 @@ static int pd_ioctl(struct block_device *bdev, fmode_t mode,
 
 	switch (cmd) {
 	case CDROMEJECT:
-		lock_kernel();
+		mutex_lock(&pd_mutex);
 		if (disk->access == 1)
 			pd_special_command(disk, pd_eject);
-		unlock_kernel();
+		mutex_unlock(&pd_mutex);
 		return 0;
 	default:
 		return -EINVAL;
@@ -785,10 +786,10 @@ static int pd_release(struct gendisk *p, fmode_t mode)
 {
 	struct pd_unit *disk = p->private_data;
 
-	lock_kernel();
+	mutex_lock(&pd_mutex);
 	if (!--disk->access && disk->removable)
 		pd_special_command(disk, pd_door_unlock);
-	unlock_kernel();
+	mutex_unlock(&pd_mutex);
 
 	return 0;
 }
diff --git a/drivers/block/paride/pf.c b/drivers/block/paride/pf.c
index 4457b49..635f25d 100644
--- a/drivers/block/paride/pf.c
+++ b/drivers/block/paride/pf.c
@@ -152,9 +152,10 @@ enum {D_PRT, D_PRO, D_UNI, D_MOD, D_SLV, D_LUN, D_DLY};
 #include <linux/spinlock.h>
 #include <linux/blkdev.h>
 #include <linux/blkpg.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <asm/uaccess.h>
 
+static DEFINE_MUTEX(pf_mutex);
 static DEFINE_SPINLOCK(pf_spin_lock);
 
 module_param(verbose, bool, 0644);
@@ -302,7 +303,7 @@ static int pf_open(struct block_device *bdev, fmode_t mode)
 	struct pf_unit *pf = bdev->bd_disk->private_data;
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&pf_mutex);
 	pf_identify(pf);
 
 	ret = -ENODEV;
@@ -318,7 +319,7 @@ static int pf_open(struct block_device *bdev, fmode_t mode)
 	if (pf->removable)
 		pf_lock(pf, 1);
 out:
-	unlock_kernel();
+	mutex_unlock(&pf_mutex);
 	return ret;
 }
 
@@ -349,9 +350,9 @@ static int pf_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd, u
 
 	if (pf->access != 1)
 		return -EBUSY;
-	lock_kernel();
+	mutex_lock(&pf_mutex);
 	pf_eject(pf);
-	unlock_kernel();
+	mutex_unlock(&pf_mutex);
 
 	return 0;
 }
@@ -360,9 +361,9 @@ static int pf_release(struct gendisk *disk, fmode_t mode)
 {
 	struct pf_unit *pf = disk->private_data;
 
-	lock_kernel();
+	mutex_lock(&pf_mutex);
 	if (pf->access <= 0) {
-		unlock_kernel();
+		mutex_unlock(&pf_mutex);
 		return -EINVAL;
 	}
 
@@ -371,7 +372,7 @@ static int pf_release(struct gendisk *disk, fmode_t mode)
 	if (!pf->access && pf->removable)
 		pf_lock(pf, 0);
 
-	unlock_kernel();
+	mutex_unlock(&pf_mutex);
 	return 0;
 
 }
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index b1cbeb5..1e85678 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -57,7 +57,6 @@
 #include <linux/seq_file.h>
 #include <linux/miscdevice.h>
 #include <linux/freezer.h>
-#include <linux/smp_lock.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include <scsi/scsi_cmnd.h>
@@ -86,6 +85,7 @@
 
 #define ZONE(sector, pd) (((sector) + (pd)->offset) & ~((pd)->settings.size - 1))
 
+static DEFINE_MUTEX(pktcdvd_mutex);
 static struct pktcdvd_device *pkt_devs[MAX_WRITERS];
 static struct proc_dir_entry *pkt_proc;
 static int pktdev_major;
@@ -2383,7 +2383,7 @@ static int pkt_open(struct block_device *bdev, fmode_t mode)
 
 	VPRINTK(DRIVER_NAME": entering open\n");
 
-	lock_kernel();
+	mutex_lock(&pktcdvd_mutex);
 	mutex_lock(&ctl_mutex);
 	pd = pkt_find_dev_from_minor(MINOR(bdev->bd_dev));
 	if (!pd) {
@@ -2411,7 +2411,7 @@ static int pkt_open(struct block_device *bdev, fmode_t mode)
 	}
 
 	mutex_unlock(&ctl_mutex);
-	unlock_kernel();
+	mutex_unlock(&pktcdvd_mutex);
 	return 0;
 
 out_dec:
@@ -2419,7 +2419,7 @@ out_dec:
 out:
 	VPRINTK(DRIVER_NAME": failed open (%d)\n", ret);
 	mutex_unlock(&ctl_mutex);
-	unlock_kernel();
+	mutex_unlock(&pktcdvd_mutex);
 	return ret;
 }
 
@@ -2428,7 +2428,7 @@ static int pkt_close(struct gendisk *disk, fmode_t mode)
 	struct pktcdvd_device *pd = disk->private_data;
 	int ret = 0;
 
-	lock_kernel();
+	mutex_lock(&pktcdvd_mutex);
 	mutex_lock(&ctl_mutex);
 	pd->refcnt--;
 	BUG_ON(pd->refcnt < 0);
@@ -2437,7 +2437,7 @@ static int pkt_close(struct gendisk *disk, fmode_t mode)
 		pkt_release_dev(pd, flush);
 	}
 	mutex_unlock(&ctl_mutex);
-	unlock_kernel();
+	mutex_unlock(&pktcdvd_mutex);
 	return ret;
 }
 
@@ -2773,7 +2773,7 @@ static int pkt_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd,
 	VPRINTK("pkt_ioctl: cmd %x, dev %d:%d\n", cmd,
 		MAJOR(bdev->bd_dev), MINOR(bdev->bd_dev));
 
-	lock_kernel();
+	mutex_lock(&pktcdvd_mutex);
 	switch (cmd) {
 	case CDROMEJECT:
 		/*
@@ -2798,7 +2798,7 @@ static int pkt_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd,
 		VPRINTK(DRIVER_NAME": Unknown ioctl for %s (%x)\n", pd->name, cmd);
 		ret = -ENOTTY;
 	}
-	unlock_kernel();
+	mutex_unlock(&pktcdvd_mutex);
 
 	return ret;
 }
diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index 2e46815..75333d0 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -20,7 +20,7 @@
 #include <linux/fd.h>
 #include <linux/slab.h>
 #include <linux/blkdev.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/hdreg.h>
 #include <linux/kernel.h>
 #include <linux/delay.h>
@@ -222,6 +222,7 @@ extern int swim_read_sector_header(struct swim __iomem *base,
 extern int swim_read_sector_data(struct swim __iomem *base,
 				 unsigned char *data);
 
+static DEFINE_MUTEX(swim_mutex);
 static inline void set_swim_mode(struct swim __iomem *base, int enable)
 {
 	struct iwm __iomem *iwm_base;
@@ -666,9 +667,9 @@ static int floppy_unlocked_open(struct block_device *bdev, fmode_t mode)
 {
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&swim_mutex);
 	ret = floppy_open(bdev, mode);
-	unlock_kernel();
+	mutex_unlock(&swim_mutex);
 
 	return ret;
 }
@@ -678,7 +679,7 @@ static int floppy_release(struct gendisk *disk, fmode_t mode)
 	struct floppy_state *fs = disk->private_data;
 	struct swim __iomem *base = fs->swd->base;
 
-	lock_kernel();
+	mutex_lock(&swim_mutex);
 	if (fs->ref_count < 0)
 		fs->ref_count = 0;
 	else if (fs->ref_count > 0)
@@ -686,7 +687,7 @@ static int floppy_release(struct gendisk *disk, fmode_t mode)
 
 	if (fs->ref_count == 0)
 		swim_motor(base, OFF);
-	unlock_kernel();
+	mutex_unlock(&swim_mutex);
 
 	return 0;
 }
@@ -704,9 +705,9 @@ static int floppy_ioctl(struct block_device *bdev, fmode_t mode,
 	case FDEJECT:
 		if (fs->ref_count != 1)
 			return -EBUSY;
-		lock_kernel();
+		mutex_lock(&swim_mutex);
 		err = floppy_eject(fs);
-		unlock_kernel();
+		mutex_unlock(&swim_mutex);
 		return err;
 
 	case FDGETPRM:
diff --git a/drivers/block/swim3.c b/drivers/block/swim3.c
index cc6a386..bf3a5b8 100644
--- a/drivers/block/swim3.c
+++ b/drivers/block/swim3.c
@@ -25,7 +25,7 @@
 #include <linux/ioctl.h>
 #include <linux/blkdev.h>
 #include <linux/interrupt.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/module.h>
 #include <linux/spinlock.h>
 #include <asm/io.h>
@@ -36,6 +36,7 @@
 #include <asm/machdep.h>
 #include <asm/pmac_feature.h>
 
+static DEFINE_MUTEX(swim3_mutex);
 static struct request_queue *swim3_queue;
 static struct gendisk *disks[2];
 static struct request *fd_req;
@@ -873,9 +874,9 @@ static int floppy_ioctl(struct block_device *bdev, fmode_t mode,
 {
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&swim3_mutex);
 	ret = floppy_locked_ioctl(bdev, mode, cmd, param);
-	unlock_kernel();
+	mutex_unlock(&swim3_mutex);
 
 	return ret;
 }
@@ -953,9 +954,9 @@ static int floppy_unlocked_open(struct block_device *bdev, fmode_t mode)
 {
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&swim3_mutex);
 	ret = floppy_open(bdev, mode);
-	unlock_kernel();
+	mutex_unlock(&swim3_mutex);
 
 	return ret;
 }
@@ -964,13 +965,13 @@ static int floppy_release(struct gendisk *disk, fmode_t mode)
 {
 	struct floppy_state *fs = disk->private_data;
 	struct swim3 __iomem *sw = fs->swim3;
-	lock_kernel();
+	mutex_lock(&swim3_mutex);
 	if (fs->ref_count > 0 && --fs->ref_count == 0) {
 		swim3_action(fs, MOTOR_OFF);
 		out_8(&sw->control_bic, 0xff);
 		swim3_select(fs, RELAX);
 	}
-	unlock_kernel();
+	mutex_unlock(&swim3_mutex);
 	return 0;
 }
 
diff --git a/drivers/block/ub.c b/drivers/block/ub.c
index c48e148..b5690a0 100644
--- a/drivers/block/ub.c
+++ b/drivers/block/ub.c
@@ -28,7 +28,7 @@
 #include <linux/timer.h>
 #include <linux/scatterlist.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <scsi/scsi.h>
 
 #define DRV_NAME "ub"
@@ -248,6 +248,7 @@ struct ub_completion {
 	spinlock_t lock;
 };
 
+static DEFINE_MUTEX(ub_mutex);
 static inline void ub_init_completion(struct ub_completion *x)
 {
 	x->done = 0;
@@ -1715,9 +1716,9 @@ static int ub_bd_unlocked_open(struct block_device *bdev, fmode_t mode)
 {
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&ub_mutex);
 	ret = ub_bd_open(bdev, mode);
-	unlock_kernel();
+	mutex_unlock(&ub_mutex);
 
 	return ret;
 }
@@ -1730,9 +1731,9 @@ static int ub_bd_release(struct gendisk *disk, fmode_t mode)
 	struct ub_lun *lun = disk->private_data;
 	struct ub_dev *sc = lun->udev;
 
-	lock_kernel();
+	mutex_lock(&ub_mutex);
 	ub_put(sc);
-	unlock_kernel();
+	mutex_unlock(&ub_mutex);
 
 	return 0;
 }
@@ -1747,9 +1748,9 @@ static int ub_bd_ioctl(struct block_device *bdev, fmode_t mode,
 	void __user *usermem = (void __user *) arg;
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&ub_mutex);
 	ret = scsi_cmd_ioctl(disk->queue, disk, mode, cmd, usermem);
-	unlock_kernel();
+	mutex_unlock(&ub_mutex);
 
 	return ret;
 }
diff --git a/drivers/block/viodasd.c b/drivers/block/viodasd.c
index f651e51..e2ff697 100644
--- a/drivers/block/viodasd.c
+++ b/drivers/block/viodasd.c
@@ -41,7 +41,7 @@
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/string.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/dma-mapping.h>
 #include <linux/completion.h>
 #include <linux/device.h>
@@ -73,6 +73,7 @@ enum {
 	MAX_DISK_NAME = FIELD_SIZEOF(struct gendisk, disk_name)
 };
 
+static DEFINE_MUTEX(viodasd_mutex);
 static DEFINE_SPINLOCK(viodasd_spinlock);
 
 #define VIOMAXREQ		16
@@ -180,9 +181,9 @@ static int viodasd_unlocked_open(struct block_device *bdev, fmode_t mode)
 {
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&viodasd_mutex);
 	ret = viodasd_open(bdev, mode);
-	unlock_kernel();
+	mutex_unlock(&viodasd_mutex);
 
 	return ret;
 }
@@ -196,7 +197,7 @@ static int viodasd_release(struct gendisk *disk, fmode_t mode)
 	struct viodasd_device *d = disk->private_data;
 	HvLpEvent_Rc hvrc;
 
-	lock_kernel();
+	mutex_lock(&viodasd_mutex);
 	/* Send the event to OS/400.  We DON'T expect a response */
 	hvrc = HvCallEvent_signalLpEventFast(viopath_hostLp,
 			HvLpEvent_Type_VirtualIo,
@@ -210,7 +211,7 @@ static int viodasd_release(struct gendisk *disk, fmode_t mode)
 	if (hvrc != 0)
 		pr_warning("HV close call failed %d\n", (int)hvrc);
 
-	unlock_kernel();
+	mutex_unlock(&viodasd_mutex);
 
 	return 0;
 }
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 2aafafc..48a4e4d 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -2,7 +2,7 @@
 #include <linux/spinlock.h>
 #include <linux/slab.h>
 #include <linux/blkdev.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/hdreg.h>
 #include <linux/virtio.h>
 #include <linux/virtio_blk.h>
@@ -10,6 +10,7 @@
 
 #define PART_BITS 4
 
+static DEFINE_MUTEX(virtio_blk_mutex);
 static int major, index;
 
 struct virtio_blk
@@ -239,9 +240,9 @@ static int virtblk_ioctl(struct block_device *bdev, fmode_t mode,
 {
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&virtio_blk_mutex);
 	ret = virtblk_locked_ioctl(bdev, mode, cmd, param);
-	unlock_kernel();
+	mutex_unlock(&virtio_blk_mutex);
 
 	return ret;
 }
diff --git a/drivers/block/xd.c b/drivers/block/xd.c
index d5a3cd7..4abd2bc 100644
--- a/drivers/block/xd.c
+++ b/drivers/block/xd.c
@@ -46,7 +46,7 @@
 #include <linux/init.h>
 #include <linux/wait.h>
 #include <linux/blkdev.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/blkpg.h>
 #include <linux/delay.h>
 #include <linux/io.h>
@@ -58,6 +58,7 @@
 
 #include "xd.h"
 
+static DEFINE_MUTEX(xd_mutex);
 static void __init do_xd_setup (int *integers);
 #ifdef MODULE
 static int xd[5] = { -1,-1,-1,-1, };
@@ -381,9 +382,9 @@ static int xd_ioctl(struct block_device *bdev, fmode_t mode,
 {
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&xd_mutex);
 	ret = xd_locked_ioctl(bdev, mode, cmd, param);
-	unlock_kernel();
+	mutex_unlock(&xd_mutex);
 
 	return ret;
 }
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index ab735a6..3ff06f4 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -41,7 +41,7 @@
 #include <linux/cdrom.h>
 #include <linux/module.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/scatterlist.h>
 
 #include <xen/xen.h>
@@ -69,6 +69,7 @@ struct blk_shadow {
 	unsigned long frame[BLKIF_MAX_SEGMENTS_PER_REQUEST];
 };
 
+static DEFINE_MUTEX(blkfront_mutex);
 static const struct block_device_operations xlvbd_block_fops;
 
 #define BLK_RING_SIZE __RING_SIZE((struct blkif_sring *)0, PAGE_SIZE)
@@ -1201,7 +1202,7 @@ static int blkif_open(struct block_device *bdev, fmode_t mode)
 	struct blkfront_info *info;
 	int err = 0;
 
-	lock_kernel();
+	mutex_lock(&blkfront_mutex);
 
 	info = disk->private_data;
 	if (!info) {
@@ -1219,7 +1220,7 @@ static int blkif_open(struct block_device *bdev, fmode_t mode)
 	mutex_unlock(&info->mutex);
 
 out:
-	unlock_kernel();
+	mutex_unlock(&blkfront_mutex);
 	return err;
 }
 
@@ -1229,7 +1230,7 @@ static int blkif_release(struct gendisk *disk, fmode_t mode)
 	struct block_device *bdev;
 	struct xenbus_device *xbdev;
 
-	lock_kernel();
+	mutex_lock(&blkfront_mutex);
 
 	bdev = bdget_disk(disk, 0);
 	bdput(bdev);
@@ -1263,7 +1264,7 @@ static int blkif_release(struct gendisk *disk, fmode_t mode)
 	}
 
 out:
-	unlock_kernel();
+	mutex_unlock(&blkfront_mutex);
 	return 0;
 }
 
diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
index 057413b..6e968cd 100644
--- a/drivers/block/xsysace.c
+++ b/drivers/block/xsysace.c
@@ -89,7 +89,7 @@
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/blkdev.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/ata.h>
 #include <linux/hdreg.h>
 #include <linux/platform_device.h>
@@ -214,6 +214,7 @@ struct ace_device {
 	u16 cf_id[ATA_ID_WORDS];
 };
 
+static DEFINE_MUTEX(xsysace_mutex);
 static int ace_major;
 
 /* ---------------------------------------------------------------------
@@ -903,13 +904,13 @@ static int ace_open(struct block_device *bdev, fmode_t mode)
 
 	dev_dbg(ace->dev, "ace_open() users=%i\n", ace->users + 1);
 
-	lock_kernel();
+	mutex_lock(&xsysace_mutex);
 	spin_lock_irqsave(&ace->lock, flags);
 	ace->users++;
 	spin_unlock_irqrestore(&ace->lock, flags);
 
 	check_disk_change(bdev);
-	unlock_kernel();
+	mutex_unlock(&xsysace_mutex);
 
 	return 0;
 }
@@ -922,7 +923,7 @@ static int ace_release(struct gendisk *disk, fmode_t mode)
 
 	dev_dbg(ace->dev, "ace_release() users=%i\n", ace->users - 1);
 
-	lock_kernel();
+	mutex_lock(&xsysace_mutex);
 	spin_lock_irqsave(&ace->lock, flags);
 	ace->users--;
 	if (ace->users == 0) {
@@ -930,7 +931,7 @@ static int ace_release(struct gendisk *disk, fmode_t mode)
 		ace_out(ace, ACE_CTRL, val & ~ACE_CTRL_LOCKREQ);
 	}
 	spin_unlock_irqrestore(&ace->lock, flags);
-	unlock_kernel();
+	mutex_unlock(&xsysace_mutex);
 	return 0;
 }
 
diff --git a/drivers/block/z2ram.c b/drivers/block/z2ram.c
index d75b2bb..dcd4cfc 100644
--- a/drivers/block/z2ram.c
+++ b/drivers/block/z2ram.c
@@ -33,7 +33,7 @@
 #include <linux/module.h>
 #include <linux/blkdev.h>
 #include <linux/bitops.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/slab.h>
 
 #include <asm/setup.h>
@@ -57,6 +57,7 @@ extern struct mem_info m68k_memory[NUM_MEMINFO];
 
 #define Z2RAM_CHUNK1024       ( Z2RAM_CHUNKSIZE >> 10 )
 
+static DEFINE_MUTEX(z2ram_mutex);
 static u_long *z2ram_map    = NULL;
 static u_long z2ram_size    = 0;
 static int z2_count         = 0;
@@ -154,7 +155,7 @@ static int z2_open(struct block_device *bdev, fmode_t mode)
 
     device = MINOR(bdev->bd_dev);
 
-    lock_kernel();
+    mutex_lock(&z2ram_mutex);
     if ( current_device != -1 && current_device != device )
     {
 	rc = -EBUSY;
@@ -296,25 +297,25 @@ static int z2_open(struct block_device *bdev, fmode_t mode)
 	set_capacity(z2ram_gendisk, z2ram_size >> 9);
     }
 
-    unlock_kernel();
+    mutex_unlock(&z2ram_mutex);
     return 0;
 
 err_out_kfree:
     kfree(z2ram_map);
 err_out:
-    unlock_kernel();
+    mutex_unlock(&z2ram_mutex);
     return rc;
 }
 
 static int
 z2_release(struct gendisk *disk, fmode_t mode)
 {
-    lock_kernel();
+    mutex_lock(&z2ram_mutex);
     if ( current_device == -1 ) {
-    	unlock_kernel();
+    	mutex_unlock(&z2ram_mutex);
     	return 0;
     }
-    unlock_kernel();
+    mutex_unlock(&z2ram_mutex);
     /*
      * FIXME: unmap memory
      */
diff --git a/drivers/cdrom/gdrom.c b/drivers/cdrom/gdrom.c
index 261107d..3af6516 100644
--- a/drivers/cdrom/gdrom.c
+++ b/drivers/cdrom/gdrom.c
@@ -34,7 +34,7 @@
 #include <linux/blkdev.h>
 #include <linux/interrupt.h>
 #include <linux/device.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/wait.h>
 #include <linux/workqueue.h>
 #include <linux/platform_device.h>
@@ -81,6 +81,7 @@
 
 #define GDROM_DEFAULT_TIMEOUT	(HZ * 7)
 
+static DEFINE_MUTEX(gdrom_mutex);
 static const struct {
 	int sense_key;
 	const char * const text;
@@ -494,17 +495,17 @@ static struct cdrom_device_ops gdrom_ops = {
 static int gdrom_bdops_open(struct block_device *bdev, fmode_t mode)
 {
 	int ret;
-	lock_kernel();
+	mutex_lock(&gdrom_mutex);
 	ret = cdrom_open(gd.cd_info, bdev, mode);
-	unlock_kernel();
+	mutex_unlock(&gdrom_mutex);
 	return ret;
 }
 
 static int gdrom_bdops_release(struct gendisk *disk, fmode_t mode)
 {
-	lock_kernel();
+	mutex_lock(&gdrom_mutex);
 	cdrom_release(gd.cd_info, mode);
-	unlock_kernel();
+	mutex_unlock(&gdrom_mutex);
 	return 0;
 }
 
@@ -518,9 +519,9 @@ static int gdrom_bdops_ioctl(struct block_device *bdev, fmode_t mode,
 {
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&gdrom_mutex);
 	ret = cdrom_ioctl(gd.cd_info, bdev, mode, cmd, arg);
-	unlock_kernel();
+	mutex_unlock(&gdrom_mutex);
 
 	return ret;
 }
diff --git a/drivers/cdrom/viocd.c b/drivers/cdrom/viocd.c
index 56bf9f4..be73a9b 100644
--- a/drivers/cdrom/viocd.c
+++ b/drivers/cdrom/viocd.c
@@ -42,7 +42,7 @@
 #include <linux/module.h>
 #include <linux/completion.h>
 #include <linux/proc_fs.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/seq_file.h>
 #include <linux/scatterlist.h>
 
@@ -61,6 +61,7 @@
  */
 #define VIOCD_MAX_CD	HVMAXARCHITECTEDVIRTUALCDROMS
 
+static DEFINE_MUTEX(viocd_mutex);
 static const struct vio_error_entry viocd_err_table[] = {
 	{0x0201, EINVAL, "Invalid Range"},
 	{0x0202, EINVAL, "Invalid Token"},
@@ -156,9 +157,9 @@ static int viocd_blk_open(struct block_device *bdev, fmode_t mode)
 	struct disk_info *di = bdev->bd_disk->private_data;
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&viocd_mutex);
 	ret = cdrom_open(&di->viocd_info, bdev, mode);
-	unlock_kernel();
+	mutex_unlock(&viocd_mutex);
 
 	return ret;
 }
@@ -166,9 +167,9 @@ static int viocd_blk_open(struct block_device *bdev, fmode_t mode)
 static int viocd_blk_release(struct gendisk *disk, fmode_t mode)
 {
 	struct disk_info *di = disk->private_data;
-	lock_kernel();
+	mutex_lock(&viocd_mutex);
 	cdrom_release(&di->viocd_info, mode);
-	unlock_kernel();
+	mutex_unlock(&viocd_mutex);
 	return 0;
 }
 
@@ -178,9 +179,9 @@ static int viocd_blk_ioctl(struct block_device *bdev, fmode_t mode,
 	struct disk_info *di = bdev->bd_disk->private_data;
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&viocd_mutex);
 	ret = cdrom_ioctl(&di->viocd_info, bdev, mode, cmd, arg);
-	unlock_kernel();
+	mutex_unlock(&viocd_mutex);
 
 	return ret;
 }
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 31fc769..0c73fe3 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -31,7 +31,6 @@
 #include <linux/delay.h>
 #include <linux/timer.h>
 #include <linux/seq_file.h>
-#include <linux/smp_lock.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 #include <linux/errno.h>
@@ -52,6 +51,7 @@
 
 #include "ide-cd.h"
 
+static DEFINE_MUTEX(ide_cd_mutex);
 static DEFINE_MUTEX(idecd_ref_mutex);
 
 static void ide_cd_release(struct device *);
@@ -1602,7 +1602,7 @@ static int idecd_open(struct block_device *bdev, fmode_t mode)
 	struct cdrom_info *info;
 	int rc = -ENXIO;
 
-	lock_kernel();
+	mutex_lock(&ide_cd_mutex);
 	info = ide_cd_get(bdev->bd_disk);
 	if (!info)
 		goto out;
@@ -1611,7 +1611,7 @@ static int idecd_open(struct block_device *bdev, fmode_t mode)
 	if (rc < 0)
 		ide_cd_put(info);
 out:
-	unlock_kernel();
+	mutex_unlock(&ide_cd_mutex);
 	return rc;
 }
 
@@ -1619,11 +1619,11 @@ static int idecd_release(struct gendisk *disk, fmode_t mode)
 {
 	struct cdrom_info *info = ide_drv_g(disk, cdrom_info);
 
-	lock_kernel();
+	mutex_lock(&ide_cd_mutex);
 	cdrom_release(&info->devinfo, mode);
 
 	ide_cd_put(info);
-	unlock_kernel();
+	mutex_unlock(&ide_cd_mutex);
 
 	return 0;
 }
@@ -1694,9 +1694,9 @@ static int idecd_ioctl(struct block_device *bdev, fmode_t mode,
 {
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&ide_cd_mutex);
 	ret = idecd_locked_ioctl(bdev, mode, cmd, arg);
-	unlock_kernel();
+	mutex_unlock(&ide_cd_mutex);
 
 	return ret;
 }
diff --git a/drivers/ide/ide-disk_ioctl.c b/drivers/ide/ide-disk_ioctl.c
index ec94c66..da36f72 100644
--- a/drivers/ide/ide-disk_ioctl.c
+++ b/drivers/ide/ide-disk_ioctl.c
@@ -1,10 +1,11 @@
 #include <linux/kernel.h>
 #include <linux/ide.h>
 #include <linux/hdreg.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 
 #include "ide-disk.h"
 
+static DEFINE_MUTEX(ide_disk_ioctl_mutex);
 static const struct ide_ioctl_devset ide_disk_ioctl_settings[] = {
 { HDIO_GET_ADDRESS,	HDIO_SET_ADDRESS,   &ide_devset_address   },
 { HDIO_GET_MULTCOUNT,	HDIO_SET_MULTCOUNT, &ide_devset_multcount },
@@ -19,13 +20,13 @@ int ide_disk_ioctl(ide_drive_t *drive, struct block_device *bdev, fmode_t mode,
 {
 	int err;
 
-	lock_kernel();
+	mutex_lock(&ide_disk_ioctl_mutex);
 	err = ide_setting_ioctl(drive, bdev, cmd, arg, ide_disk_ioctl_settings);
 	if (err != -EOPNOTSUPP)
 		goto out;
 
 	err = generic_ide_ioctl(drive, bdev, cmd, arg);
 out:
-	unlock_kernel();
+	mutex_unlock(&ide_disk_ioctl_mutex);
 	return err;
 }
diff --git a/drivers/ide/ide-floppy_ioctl.c b/drivers/ide/ide-floppy_ioctl.c
index fd3d05a..d267b7a 100644
--- a/drivers/ide/ide-floppy_ioctl.c
+++ b/drivers/ide/ide-floppy_ioctl.c
@@ -5,7 +5,7 @@
 #include <linux/kernel.h>
 #include <linux/ide.h>
 #include <linux/cdrom.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 
 #include <asm/unaligned.h>
 
@@ -32,6 +32,7 @@
  * On exit we set nformats to the number of records we've actually initialized.
  */
 
+static DEFINE_MUTEX(ide_floppy_ioctl_mutex);
 static int ide_floppy_get_format_capacities(ide_drive_t *drive,
 					    struct ide_atapi_pc *pc,
 					    int __user *arg)
@@ -276,7 +277,7 @@ int ide_floppy_ioctl(ide_drive_t *drive, struct block_device *bdev,
 	void __user *argp = (void __user *)arg;
 	int err;
 
-	lock_kernel();
+	mutex_lock(&ide_floppy_ioctl_mutex);
 	if (cmd == CDROMEJECT || cmd == CDROM_LOCKDOOR) {
 		err = ide_floppy_lockdoor(drive, &pc, arg, cmd);
 		goto out;
@@ -298,6 +299,6 @@ int ide_floppy_ioctl(ide_drive_t *drive, struct block_device *bdev,
 		err = generic_ide_ioctl(drive, bdev, cmd, arg);
 
 out:
-	unlock_kernel();
+	mutex_unlock(&ide_floppy_ioctl_mutex);
 	return err;
 }
diff --git a/drivers/ide/ide-gd.c b/drivers/ide/ide-gd.c
index 70aeeb1..35c4b43 100644
--- a/drivers/ide/ide-gd.c
+++ b/drivers/ide/ide-gd.c
@@ -1,4 +1,3 @@
-#include <linux/smp_lock.h>
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/string.h>
@@ -23,6 +22,7 @@
 #define IDE_GD_VERSION	"1.18"
 
 /* module parameters */
+static DEFINE_MUTEX(ide_gd_mutex);
 static unsigned long debug_mask;
 module_param(debug_mask, ulong, 0644);
 
@@ -242,9 +242,9 @@ static int ide_gd_unlocked_open(struct block_device *bdev, fmode_t mode)
 {
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&ide_gd_mutex);
 	ret = ide_gd_open(bdev, mode);
-	unlock_kernel();
+	mutex_unlock(&ide_gd_mutex);
 
 	return ret;
 }
@@ -257,7 +257,7 @@ static int ide_gd_release(struct gendisk *disk, fmode_t mode)
 
 	ide_debug_log(IDE_DBG_FUNC, "enter");
 
-	lock_kernel();
+	mutex_lock(&ide_gd_mutex);
 	if (idkp->openers == 1)
 		drive->disk_ops->flush(drive);
 
@@ -269,7 +269,7 @@ static int ide_gd_release(struct gendisk *disk, fmode_t mode)
 	idkp->openers--;
 
 	ide_disk_put(idkp);
-	unlock_kernel();
+	mutex_unlock(&ide_gd_mutex);
 
 	return 0;
 }
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 6d622cb..65f0bcf 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -32,11 +32,9 @@
 #include <linux/errno.h>
 #include <linux/genhd.h>
 #include <linux/seq_file.h>
-#include <linux/smp_lock.h>
 #include <linux/slab.h>
 #include <linux/pci.h>
 #include <linux/ide.h>
-#include <linux/smp_lock.h>
 #include <linux/completion.h>
 #include <linux/bitops.h>
 #include <linux/mutex.h>
@@ -220,6 +218,7 @@ typedef struct ide_tape_obj {
 	char write_prot;
 } idetape_tape_t;
 
+static DEFINE_MUTEX(ide_tape_mutex);
 static DEFINE_MUTEX(idetape_ref_mutex);
 
 static DEFINE_MUTEX(idetape_chrdev_mutex);
@@ -1426,9 +1425,9 @@ static long idetape_chrdev_ioctl(struct file *file,
 				unsigned int cmd, unsigned long arg)
 {
 	long ret;
-	lock_kernel();
+	mutex_lock(&ide_tape_mutex);
 	ret = do_idetape_chrdev_ioctl(file, cmd, arg);
-	unlock_kernel();
+	mutex_unlock(&ide_tape_mutex);
 	return ret;
 }
 
@@ -1909,9 +1908,9 @@ static int idetape_open(struct block_device *bdev, fmode_t mode)
 {
 	struct ide_tape_obj *tape;
 
-	lock_kernel();
+	mutex_lock(&ide_tape_mutex);
 	tape = ide_tape_get(bdev->bd_disk, false, 0);
-	unlock_kernel();
+	mutex_unlock(&ide_tape_mutex);
 
 	if (!tape)
 		return -ENXIO;
@@ -1923,9 +1922,9 @@ static int idetape_release(struct gendisk *disk, fmode_t mode)
 {
 	struct ide_tape_obj *tape = ide_drv_g(disk, ide_tape_obj);
 
-	lock_kernel();
+	mutex_lock(&ide_tape_mutex);
 	ide_tape_put(tape);
-	unlock_kernel();
+	mutex_unlock(&ide_tape_mutex);
 
 	return 0;
 }
@@ -1937,11 +1936,11 @@ static int idetape_ioctl(struct block_device *bdev, fmode_t mode,
 	ide_drive_t *drive = tape->drive;
 	int err;
 
-	lock_kernel();
+	mutex_lock(&ide_tape_mutex);
 	err = generic_ide_ioctl(drive, bdev, cmd, arg);
 	if (err == -EINVAL)
 		err = idetape_blkdev_ioctl(drive, cmd, arg);
-	unlock_kernel();
+	mutex_unlock(&ide_tape_mutex);
 
 	return err;
 }
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index ac384b2..7967eca 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -15,7 +15,6 @@
 #include <linux/blkpg.h>
 #include <linux/bio.h>
 #include <linux/buffer_head.h>
-#include <linux/smp_lock.h>
 #include <linux/mempool.h>
 #include <linux/slab.h>
 #include <linux/idr.h>
@@ -33,6 +32,7 @@
 #define DM_COOKIE_ENV_VAR_NAME "DM_COOKIE"
 #define DM_COOKIE_LENGTH 24
 
+static DEFINE_MUTEX(dm_mutex);
 static const char *_name = DM_NAME;
 
 static unsigned int major = 0;
@@ -344,7 +344,7 @@ static int dm_blk_open(struct block_device *bdev, fmode_t mode)
 {
 	struct mapped_device *md;
 
-	lock_kernel();
+	mutex_lock(&dm_mutex);
 	spin_lock(&_minor_lock);
 
 	md = bdev->bd_disk->private_data;
@@ -362,7 +362,7 @@ static int dm_blk_open(struct block_device *bdev, fmode_t mode)
 
 out:
 	spin_unlock(&_minor_lock);
-	unlock_kernel();
+	mutex_unlock(&dm_mutex);
 
 	return md ? 0 : -ENXIO;
 }
@@ -371,10 +371,10 @@ static int dm_blk_close(struct gendisk *disk, fmode_t mode)
 {
 	struct mapped_device *md = disk->private_data;
 
-	lock_kernel();
+	mutex_lock(&dm_mutex);
 	atomic_dec(&md->open_count);
 	dm_put(md);
-	unlock_kernel();
+	mutex_unlock(&dm_mutex);
 
 	return 0;
 }
diff --git a/drivers/md/md.c b/drivers/md/md.c
index c148b63..561f16a 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -36,7 +36,7 @@
 #include <linux/blkdev.h>
 #include <linux/sysctl.h>
 #include <linux/seq_file.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/buffer_head.h> /* for invalidate_bdev */
 #include <linux/poll.h>
 #include <linux/ctype.h>
@@ -57,6 +57,7 @@
 #define DEBUG 0
 #define dprintk(x...) ((void)(DEBUG && printk(x)))
 
+static DEFINE_MUTEX(md_mutex);
 
 #ifndef MODULE
 static void autostart_arrays(int part);
@@ -5953,7 +5954,7 @@ static int md_open(struct block_device *bdev, fmode_t mode)
 	mddev_t *mddev = mddev_find(bdev->bd_dev);
 	int err;
 
-	lock_kernel();
+	mutex_lock(&md_mutex);
 	if (mddev->gendisk != bdev->bd_disk) {
 		/* we are racing with mddev_put which is discarding this
 		 * bd_disk.
@@ -5962,7 +5963,7 @@ static int md_open(struct block_device *bdev, fmode_t mode)
 		/* Wait until bdev->bd_disk is definitely gone */
 		flush_scheduled_work();
 		/* Then retry the open from the top */
-		unlock_kernel();
+		mutex_unlock(&md_mutex);
 		return -ERESTARTSYS;
 	}
 	BUG_ON(mddev != bdev->bd_disk->private_data);
@@ -5976,7 +5977,7 @@ static int md_open(struct block_device *bdev, fmode_t mode)
 
 	check_disk_size_change(mddev->gendisk, bdev);
  out:
-	unlock_kernel();
+	mutex_unlock(&md_mutex);
 	return err;
 }
 
@@ -5985,10 +5986,10 @@ static int md_release(struct gendisk *disk, fmode_t mode)
  	mddev_t *mddev = disk->private_data;
 
 	BUG_ON(!mddev);
-	lock_kernel();
+	mutex_lock(&md_mutex);
 	atomic_dec(&mddev->openers);
 	mddev_put(mddev);
-	unlock_kernel();
+	mutex_unlock(&md_mutex);
 
 	return 0;
 }
diff --git a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/mspro_block.c
index d3f1a08..02362ec 100644
--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -18,11 +18,12 @@
 #include <linux/kthread.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/memstick.h>
 
 #define DRIVER_NAME "mspro_block"
 
+static DEFINE_MUTEX(mspro_block_mutex);
 static int major;
 module_param(major, int, 0644);
 
@@ -180,7 +181,7 @@ static int mspro_block_bd_open(struct block_device *bdev, fmode_t mode)
 	struct mspro_block_data *msb = disk->private_data;
 	int rc = -ENXIO;
 
-	lock_kernel();
+	mutex_lock(&mspro_block_mutex);
 	mutex_lock(&mspro_block_disk_lock);
 
 	if (msb && msb->card) {
@@ -192,7 +193,7 @@ static int mspro_block_bd_open(struct block_device *bdev, fmode_t mode)
 	}
 
 	mutex_unlock(&mspro_block_disk_lock);
-	unlock_kernel();
+	mutex_unlock(&mspro_block_mutex);
 
 	return rc;
 }
@@ -225,9 +226,9 @@ static int mspro_block_disk_release(struct gendisk *disk)
 static int mspro_block_bd_release(struct gendisk *disk, fmode_t mode)
 {
 	int ret;
-	lock_kernel();
+	mutex_lock(&mspro_block_mutex);
 	ret = mspro_block_disk_release(disk);
-	unlock_kernel();
+	mutex_unlock(&mspro_block_mutex);
 	return ret;
 }
 
diff --git a/drivers/message/i2o/i2o_block.c b/drivers/message/i2o/i2o_block.c
index f0f1e66..f87a9d4 100644
--- a/drivers/message/i2o/i2o_block.c
+++ b/drivers/message/i2o/i2o_block.c
@@ -53,7 +53,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/i2o.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 
 #include <linux/mempool.h>
 
@@ -69,6 +69,7 @@
 #define OSM_VERSION	"1.325"
 #define OSM_DESCRIPTION	"I2O Block Device OSM"
 
+static DEFINE_MUTEX(i2o_block_mutex);
 static struct i2o_driver i2o_block_driver;
 
 /* global Block OSM request mempool */
@@ -578,7 +579,7 @@ static int i2o_block_open(struct block_device *bdev, fmode_t mode)
 	if (!dev->i2o_dev)
 		return -ENODEV;
 
-	lock_kernel();
+	mutex_lock(&i2o_block_mutex);
 	if (dev->power > 0x1f)
 		i2o_block_device_power(dev, 0x02);
 
@@ -587,7 +588,7 @@ static int i2o_block_open(struct block_device *bdev, fmode_t mode)
 	i2o_block_device_lock(dev->i2o_dev, -1);
 
 	osm_debug("Ready.\n");
-	unlock_kernel();
+	mutex_unlock(&i2o_block_mutex);
 
 	return 0;
 };
@@ -618,7 +619,7 @@ static int i2o_block_release(struct gendisk *disk, fmode_t mode)
 	if (!dev->i2o_dev)
 		return 0;
 
-	lock_kernel();
+	mutex_lock(&i2o_block_mutex);
 	i2o_block_device_flush(dev->i2o_dev);
 
 	i2o_block_device_unlock(dev->i2o_dev, -1);
@@ -629,7 +630,7 @@ static int i2o_block_release(struct gendisk *disk, fmode_t mode)
 		operation = 0x24;
 
 	i2o_block_device_power(dev, operation);
-	unlock_kernel();
+	mutex_unlock(&i2o_block_mutex);
 
 	return 0;
 }
@@ -664,7 +665,7 @@ static int i2o_block_ioctl(struct block_device *bdev, fmode_t mode,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	lock_kernel();
+	mutex_lock(&i2o_block_mutex);
 	switch (cmd) {
 	case BLKI2OGRSTRAT:
 		ret = put_user(dev->rcache, (int __user *)arg);
@@ -688,7 +689,7 @@ static int i2o_block_ioctl(struct block_device *bdev, fmode_t mode,
 		ret = 0;
 		break;
 	}
-	unlock_kernel();
+	mutex_unlock(&i2o_block_mutex);
 
 	return ret;
 };
diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index d545f79..00073b7 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -29,7 +29,6 @@
 #include <linux/kdev_t.h>
 #include <linux/blkdev.h>
 #include <linux/mutex.h>
-#include <linux/smp_lock.h>
 #include <linux/scatterlist.h>
 #include <linux/string_helpers.h>
 
@@ -51,6 +50,7 @@ MODULE_ALIAS("mmc:block");
 #define MMC_SHIFT	3
 #define MMC_NUM_MINORS	(256 >> MMC_SHIFT)
 
+static DEFINE_MUTEX(block_mutex);
 static DECLARE_BITMAP(dev_use, MMC_NUM_MINORS);
 
 /*
@@ -108,7 +108,7 @@ static int mmc_blk_open(struct block_device *bdev, fmode_t mode)
 	struct mmc_blk_data *md = mmc_blk_get(bdev->bd_disk);
 	int ret = -ENXIO;
 
-	lock_kernel();
+	mutex_lock(&block_mutex);
 	if (md) {
 		if (md->usage == 2)
 			check_disk_change(bdev);
@@ -119,7 +119,7 @@ static int mmc_blk_open(struct block_device *bdev, fmode_t mode)
 			ret = -EROFS;
 		}
 	}
-	unlock_kernel();
+	mutex_unlock(&block_mutex);
 
 	return ret;
 }
@@ -128,9 +128,9 @@ static int mmc_blk_release(struct gendisk *disk, fmode_t mode)
 {
 	struct mmc_blk_data *md = disk->private_data;
 
-	lock_kernel();
+	mutex_lock(&block_mutex);
 	mmc_blk_put(md);
-	unlock_kernel();
+	mutex_unlock(&block_mutex);
 	return 0;
 }
 
diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index 62e6870..50ab431 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -29,7 +29,6 @@
 #include <linux/blkdev.h>
 #include <linux/blkpg.h>
 #include <linux/spinlock.h>
-#include <linux/smp_lock.h>
 #include <linux/hdreg.h>
 #include <linux/init.h>
 #include <linux/mutex.h>
@@ -38,6 +37,7 @@
 
 #include "mtdcore.h"
 
+static DEFINE_MUTEX(mtd_blkdevs_mutex);
 static LIST_HEAD(blktrans_majors);
 static DEFINE_MUTEX(blktrans_ref_mutex);
 
@@ -181,7 +181,7 @@ static int blktrans_open(struct block_device *bdev, fmode_t mode)
 	if (!dev)
 		return -ERESTARTSYS; /* FIXME: busy loop! -arnd*/
 
-	lock_kernel();
+	mutex_lock(&mtd_blkdevs_mutex);
 	mutex_lock(&dev->lock);
 
 	if (!dev->mtd) {
@@ -198,7 +198,7 @@ static int blktrans_open(struct block_device *bdev, fmode_t mode)
 unlock:
 	mutex_unlock(&dev->lock);
 	blktrans_dev_put(dev);
-	unlock_kernel();
+	mutex_unlock(&mtd_blkdevs_mutex);
 	return ret;
 }
 
@@ -210,7 +210,7 @@ static int blktrans_release(struct gendisk *disk, fmode_t mode)
 	if (!dev)
 		return ret;
 
-	lock_kernel();
+	mutex_lock(&mtd_blkdevs_mutex);
 	mutex_lock(&dev->lock);
 
 	/* Release one reference, we sure its not the last one here*/
@@ -223,7 +223,7 @@ static int blktrans_release(struct gendisk *disk, fmode_t mode)
 unlock:
 	mutex_unlock(&dev->lock);
 	blktrans_dev_put(dev);
-	unlock_kernel();
+	mutex_unlock(&mtd_blkdevs_mutex);
 	return ret;
 }
 
@@ -256,7 +256,7 @@ static int blktrans_ioctl(struct block_device *bdev, fmode_t mode,
 	if (!dev)
 		return ret;
 
-	lock_kernel();
+	mutex_lock(&mtd_blkdevs_mutex);
 	mutex_lock(&dev->lock);
 
 	if (!dev->mtd)
@@ -271,7 +271,7 @@ static int blktrans_ioctl(struct block_device *bdev, fmode_t mode,
 	}
 unlock:
 	mutex_unlock(&dev->lock);
-	unlock_kernel();
+	mutex_unlock(&mtd_blkdevs_mutex);
 	blktrans_dev_put(dev);
 	return ret;
 }
diff --git a/drivers/s390/char/tape_block.c b/drivers/s390/char/tape_block.c
index b7de025..4952611 100644
--- a/drivers/s390/char/tape_block.c
+++ b/drivers/s390/char/tape_block.c
@@ -16,7 +16,7 @@
 #include <linux/fs.h>
 #include <linux/module.h>
 #include <linux/blkdev.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/interrupt.h>
 #include <linux/buffer_head.h>
 #include <linux/kernel.h>
@@ -45,6 +45,7 @@
 /*
  * file operation structure for tape block frontend
  */
+static DEFINE_MUTEX(tape_block_mutex);
 static int tapeblock_open(struct block_device *, fmode_t);
 static int tapeblock_release(struct gendisk *, fmode_t);
 static int tapeblock_medium_changed(struct gendisk *);
@@ -362,7 +363,7 @@ tapeblock_open(struct block_device *bdev, fmode_t mode)
 	struct tape_device *	device;
 	int			rc;
 
-	lock_kernel();
+	mutex_lock(&tape_block_mutex);
 	device = tape_get_device(disk->private_data);
 
 	if (device->required_tapemarks) {
@@ -386,14 +387,14 @@ tapeblock_open(struct block_device *bdev, fmode_t mode)
 	 *       is called.
 	 */
 	tape_state_set(device, TS_BLKUSE);
-	unlock_kernel();
+	mutex_unlock(&tape_block_mutex);
 	return 0;
 
 release:
 	tape_release(device);
  put_device:
 	tape_put_device(device);
-	unlock_kernel();
+	mutex_unlock(&tape_block_mutex);
 	return rc;
 }
 
@@ -408,11 +409,11 @@ tapeblock_release(struct gendisk *disk, fmode_t mode)
 {
 	struct tape_device *device = disk->private_data;
  
-	lock_kernel();
+	mutex_lock(&tape_block_mutex);
 	tape_state_set(device, TS_IN_USE);
 	tape_release(device);
 	tape_put_device(device);
-	unlock_kernel();
+	mutex_unlock(&tape_block_mutex);
 
 	return 0;
 }
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index ba9c3e0..e148341 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -44,7 +44,6 @@
 #include <linux/init.h>
 #include <linux/blkdev.h>
 #include <linux/mutex.h>
-#include <linux/smp_lock.h>
 #include <linux/slab.h>
 #include <asm/uaccess.h>
 
@@ -76,6 +75,7 @@ MODULE_ALIAS_SCSI_DEVICE(TYPE_WORM);
 	 CDC_CD_R|CDC_CD_RW|CDC_DVD|CDC_DVD_R|CDC_DVD_RAM|CDC_GENERIC_PACKET| \
 	 CDC_MRW|CDC_MRW_W|CDC_RAM)
 
+static DEFINE_MUTEX(sr_mutex);
 static int sr_probe(struct device *);
 static int sr_remove(struct device *);
 static int sr_done(struct scsi_cmnd *);
@@ -470,24 +470,24 @@ static int sr_block_open(struct block_device *bdev, fmode_t mode)
 	struct scsi_cd *cd;
 	int ret = -ENXIO;
 
-	lock_kernel();
+	mutex_lock(&sr_mutex);
 	cd = scsi_cd_get(bdev->bd_disk);
 	if (cd) {
 		ret = cdrom_open(&cd->cdi, bdev, mode);
 		if (ret)
 			scsi_cd_put(cd);
 	}
-	unlock_kernel();
+	mutex_unlock(&sr_mutex);
 	return ret;
 }
 
 static int sr_block_release(struct gendisk *disk, fmode_t mode)
 {
 	struct scsi_cd *cd = scsi_cd(disk);
-	lock_kernel();
+	mutex_lock(&sr_mutex);
 	cdrom_release(&cd->cdi, mode);
 	scsi_cd_put(cd);
-	unlock_kernel();
+	mutex_unlock(&sr_mutex);
 	return 0;
 }
 
@@ -499,7 +499,7 @@ static int sr_block_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 	void __user *argp = (void __user *)arg;
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&sr_mutex);
 
 	/*
 	 * Send SCSI addressing ioctls directly to mid level, send other
@@ -529,7 +529,7 @@ static int sr_block_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 	ret = scsi_ioctl(sdev, cmd, argp);
 
 out:
-	unlock_kernel();
+	mutex_unlock(&sr_mutex);
 	return ret;
 }
 
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 24211d0..afdc3f5 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -39,7 +39,6 @@ static const char *verstr = "20081215";
 #include <linux/cdev.h>
 #include <linux/delay.h>
 #include <linux/mutex.h>
-#include <linux/smp_lock.h>
 
 #include <asm/uaccess.h>
 #include <asm/dma.h>
@@ -76,6 +75,7 @@ static const char *verstr = "20081215";
 #include "st_options.h"
 #include "st.h"
 
+static DEFINE_MUTEX(st_mutex);
 static int buffer_kbs;
 static int max_sg_segs;
 static int try_direct_io = TRY_DIRECT_IO;
@@ -1180,7 +1180,7 @@ static int st_open(struct inode *inode, struct file *filp)
 	int dev = TAPE_NR(inode);
 	char *name;
 
-	lock_kernel();
+	mutex_lock(&st_mutex);
 	/*
 	 * We really want to do nonseekable_open(inode, filp); here, but some
 	 * versions of tar incorrectly call lseek on tapes and bail out if that
@@ -1189,7 +1189,7 @@ static int st_open(struct inode *inode, struct file *filp)
 	filp->f_mode &= ~(FMODE_PREAD | FMODE_PWRITE);
 
 	if (!(STp = scsi_tape_get(dev))) {
-		unlock_kernel();
+		mutex_unlock(&st_mutex);
 		return -ENXIO;
 	}
 
@@ -1200,7 +1200,7 @@ static int st_open(struct inode *inode, struct file *filp)
 	if (STp->in_use) {
 		write_unlock(&st_dev_arr_lock);
 		scsi_tape_put(STp);
-		unlock_kernel();
+		mutex_unlock(&st_mutex);
 		DEB( printk(ST_DEB_MSG "%s: Device already in use.\n", name); )
 		return (-EBUSY);
 	}
@@ -1249,14 +1249,14 @@ static int st_open(struct inode *inode, struct file *filp)
 			retval = (-EIO);
 		goto err_out;
 	}
-	unlock_kernel();
+	mutex_unlock(&st_mutex);
 	return 0;
 
  err_out:
 	normalize_buffer(STp->buffer);
 	STp->in_use = 0;
 	scsi_tape_put(STp);
-	unlock_kernel();
+	mutex_unlock(&st_mutex);
 	return retval;
 
 }
diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index ff1d247..8284297 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -25,7 +25,7 @@
 #include <linux/major.h>
 #include <linux/delay.h>
 #include <linux/hdreg.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/slab.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -124,6 +124,7 @@ struct blkvsc_driver_context {
 };
 
 /* Static decl */
+static DEFINE_MUTEX(blkvsc_mutex);
 static int blkvsc_probe(struct device *dev);
 static int blkvsc_remove(struct device *device);
 static void blkvsc_shutdown(struct device *device);
@@ -1309,7 +1310,7 @@ static int blkvsc_open(struct block_device *bdev, fmode_t mode)
 	DPRINT_DBG(BLKVSC_DRV, "- users %d disk %s\n", blkdev->users,
 		   blkdev->gd->disk_name);
 
-	lock_kernel();
+	mutex_lock(&blkvsc_mutex);
 	spin_lock(&blkdev->lock);
 
 	if (!blkdev->users && blkdev->device_type == DVD_TYPE) {
@@ -1321,7 +1322,7 @@ static int blkvsc_open(struct block_device *bdev, fmode_t mode)
 	blkdev->users++;
 
 	spin_unlock(&blkdev->lock);
-	unlock_kernel();
+	mutex_unlock(&blkvsc_mutex);
 	return 0;
 }
 
@@ -1332,7 +1333,7 @@ static int blkvsc_release(struct gendisk *disk, fmode_t mode)
 	DPRINT_DBG(BLKVSC_DRV, "- users %d disk %s\n", blkdev->users,
 		   blkdev->gd->disk_name);
 
-	lock_kernel();
+	mutex_lock(&blkvsc_mutex);
 	spin_lock(&blkdev->lock);
 	if (blkdev->users == 1) {
 		spin_unlock(&blkdev->lock);
@@ -1343,7 +1344,7 @@ static int blkvsc_release(struct gendisk *disk, fmode_t mode)
 	blkdev->users--;
 
 	spin_unlock(&blkdev->lock);
-	unlock_kernel();
+	mutex_unlock(&blkvsc_mutex);
 	return 0;
 }
 
diff --git a/drivers/staging/spectra/ffsport.c b/drivers/staging/spectra/ffsport.c
index 44a7fbe..905a67c 100644
--- a/drivers/staging/spectra/ffsport.c
+++ b/drivers/staging/spectra/ffsport.c
@@ -27,7 +27,6 @@
 #include <linux/kthread.h>
 #include <linux/log2.h>
 #include <linux/init.h>
-#include <linux/smp_lock.h>
 
 /**** Helper functions used for Div, Remainder operation on u64 ****/
 
@@ -589,14 +588,16 @@ int GLOB_SBD_ioctl(struct block_device *bdev, fmode_t mode,
 	return -ENOTTY;
 }
 
+static DEFINE_MUTEX(ffsport_mutex);
+
 int GLOB_SBD_unlocked_ioctl(struct block_device *bdev, fmode_t mode,
 		unsigned int cmd, unsigned long arg)
 {
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&ffsport_mutex);
 	ret = GLOB_SBD_ioctl(bdev, mode, cmd, arg);
-	unlock_kernel();
+	mutex_unlock(&ffsport_mutex);
 
 	return ret;
 }
-- 
1.7.1

