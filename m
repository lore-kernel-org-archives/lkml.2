Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861Ab0JaNaW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 09:30:22 -0400
Received: from www.tglx.de ([62.245.132.106]:38322 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755682Ab0JaNaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 09:30:19 -0400
Date: Sun, 31 Oct 2010 14:24:37 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [GIT pull] semaphore final cleanups
Message-ID: <alpine.LFD.2.00.1010311422190.2955@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-locking-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-locking-for-linus

The staging cleanup conflicts trivialy with the removal of
drivers/staging/dream/ in your tree.

Thanks,

	tglx

------------------>
Thomas Gleixner (4):
      hpfs: Convert sbi->hpfs_creation_de to mutex
      jbd2: Convert jbd2_slab_create_sem to mutex
      staging: Final semaphore cleanup
      semaphore: Remove mutex emulation


 drivers/staging/ath6kl/os/linux/ar6000_raw_if.c    |    4 ++--
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c     |    4 ++--
 drivers/staging/brcm80211/sys/wl_mac80211.c        |    2 +-
 drivers/staging/comedi/drivers/dt9812.c            |    2 +-
 drivers/staging/comedi/drivers/usbdux.c            |    4 ++--
 drivers/staging/comedi/drivers/usbduxfast.c        |    4 ++--
 drivers/staging/dream/camera/mt9d112.c             |    2 +-
 drivers/staging/dream/camera/mt9p012_fox.c         |    2 +-
 drivers/staging/dream/camera/mt9t013.c             |    2 +-
 drivers/staging/dream/camera/s5k3e2fx.c            |    2 +-
 drivers/staging/msm/msm_fb.c                       |    4 ++--
 drivers/staging/rtl8712/osdep_service.h            |    2 +-
 drivers/staging/smbfs/inode.c                      |    2 +-
 .../westbridge/astoria/block/cyasblkdev_block.c    |    2 +-
 .../westbridge/astoria/block/cyasblkdev_queue.c    |    2 +-
 fs/hpfs/buffer.c                                   |    4 ++--
 fs/hpfs/hpfs_fn.h                                  |    2 +-
 fs/hpfs/super.c                                    |    2 +-
 fs/jbd2/journal.c                                  |    8 ++++----
 include/linux/semaphore.h                          |    6 ------
 scripts/checkpatch.pl                              |    8 ++------
 21 files changed, 30 insertions(+), 40 deletions(-)

diff --git a/drivers/staging/ath6kl/os/linux/ar6000_raw_if.c b/drivers/staging/ath6kl/os/linux/ar6000_raw_if.c
index c196098..6b8eeea 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_raw_if.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_raw_if.c
@@ -198,8 +198,8 @@ int ar6000_htc_raw_open(AR_SOFTC_T *ar)
         
     for (streamID = HTC_RAW_STREAM_0; streamID < HTC_RAW_STREAM_NUM_MAX; streamID++) {
         /* Initialize the data structures */
-        init_MUTEX(&arRaw->raw_htc_read_sem[streamID]);
-        init_MUTEX(&arRaw->raw_htc_write_sem[streamID]);
+	sema_init(&arRaw->raw_htc_read_sem[streamID], 1);
+	sema_init(&arRaw->raw_htc_write_sem[streamID], 1);
         init_waitqueue_head(&arRaw->raw_htc_read_queue[streamID]);
         init_waitqueue_head(&arRaw->raw_htc_write_queue[streamID]);
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index e535787..bbbe7c5 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -1929,7 +1929,7 @@ dhd_pub_t *dhd_attach(osl_t *osh, struct dhd_bus *bus, uint bus_hdrlen)
 		goto fail;
 
 	net->netdev_ops = NULL;
-	init_MUTEX(&dhd->proto_sem);
+	sema_init(&dhd->proto_sem, 1);
 	/* Initialize other structure content */
 	init_waitqueue_head(&dhd->ioctl_resp_wait);
 	init_waitqueue_head(&dhd->ctrl_wait);
@@ -1977,7 +1977,7 @@ dhd_pub_t *dhd_attach(osl_t *osh, struct dhd_bus *bus, uint bus_hdrlen)
 	dhd->timer.function = dhd_watchdog;
 
 	/* Initialize thread based operation and lock */
-	init_MUTEX(&dhd->sdsem);
+	sema_init(&dhd->sdsem, 1);
 	if ((dhd_watchdog_prio >= 0) && (dhd_dpc_prio >= 0))
 		dhd->threads_only = true;
 	else
diff --git a/drivers/staging/brcm80211/sys/wl_mac80211.c b/drivers/staging/brcm80211/sys/wl_mac80211.c
index ad635ee..d060377 100644
--- a/drivers/staging/brcm80211/sys/wl_mac80211.c
+++ b/drivers/staging/brcm80211/sys/wl_mac80211.c
@@ -866,7 +866,7 @@ static wl_info_t *wl_attach(u16 vendor, u16 device, unsigned long regs,
 	spin_lock_init(&wl->rpcq_lock);
 	spin_lock_init(&wl->txq_lock);
 
-	init_MUTEX(&wl->sem);
+	sema_init(&wl->sem, 1);
 #else
 	spin_lock_init(&wl->lock);
 	spin_lock_init(&wl->isr_lock);
diff --git a/drivers/staging/comedi/drivers/dt9812.c b/drivers/staging/comedi/drivers/dt9812.c
index 0560a74..0605985 100644
--- a/drivers/staging/comedi/drivers/dt9812.c
+++ b/drivers/staging/comedi/drivers/dt9812.c
@@ -262,7 +262,7 @@ struct dt9812_usb_cmd {
 
 #define DT9812_NUM_SLOTS	16
 
-static DECLARE_MUTEX(dt9812_mutex);
+static DEFINE_SEMAPHORE(dt9812_mutex);
 
 static const struct usb_device_id dt9812_table[] = {
 	{USB_DEVICE(0x0867, 0x9812)},
diff --git a/drivers/staging/comedi/drivers/usbdux.c b/drivers/staging/comedi/drivers/usbdux.c
index 6131e2d..1f177a6 100644
--- a/drivers/staging/comedi/drivers/usbdux.c
+++ b/drivers/staging/comedi/drivers/usbdux.c
@@ -315,7 +315,7 @@ struct usbduxsub {
  */
 static struct usbduxsub usbduxsub[NUMUSBDUX];
 
-static DECLARE_MUTEX(start_stop_sem);
+static DEFINE_SEMAPHORE(start_stop_sem);
 
 /*
  * Stops the data acquision
@@ -2367,7 +2367,7 @@ static int usbduxsub_probe(struct usb_interface *uinterf,
 	dev_dbg(dev, "comedi_: usbdux: "
 		"usbduxsub[%d] is ready to connect to comedi.\n", index);
 
-	init_MUTEX(&(usbduxsub[index].sem));
+	sema_init(&(usbduxsub[index].sem), 1);
 	/* save a pointer to the usb device */
 	usbduxsub[index].usbdev = udev;
 
diff --git a/drivers/staging/comedi/drivers/usbduxfast.c b/drivers/staging/comedi/drivers/usbduxfast.c
index 0a164a9..5b15e6d 100644
--- a/drivers/staging/comedi/drivers/usbduxfast.c
+++ b/drivers/staging/comedi/drivers/usbduxfast.c
@@ -199,7 +199,7 @@ struct usbduxfastsub_s {
  */
 static struct usbduxfastsub_s usbduxfastsub[NUMUSBDUXFAST];
 
-static DECLARE_MUTEX(start_stop_sem);
+static DEFINE_SEMAPHORE(start_stop_sem);
 
 /*
  * bulk transfers to usbduxfast
@@ -1504,7 +1504,7 @@ static int usbduxfastsub_probe(struct usb_interface *uinterf,
 	       "connect to comedi.\n", index);
 #endif
 
-	init_MUTEX(&(usbduxfastsub[index].sem));
+	sema_init(&(usbduxfastsub[index].sem), 1);
 	/* save a pointer to the usb device */
 	usbduxfastsub[index].usbdev = udev;
 
diff --git a/drivers/staging/dream/camera/mt9d112.c b/drivers/staging/dream/camera/mt9d112.c
index e6f2d51..27c978f 100644
--- a/drivers/staging/dream/camera/mt9d112.c
+++ b/drivers/staging/dream/camera/mt9d112.c
@@ -37,7 +37,7 @@ struct mt9d112_ctrl {
 static struct mt9d112_ctrl *mt9d112_ctrl;
 
 static DECLARE_WAIT_QUEUE_HEAD(mt9d112_wait_queue);
-DECLARE_MUTEX(mt9d112_sem);
+DEFINE_SEMAPHORE(mt9d112_sem);
 
 
 /*=============================================================
diff --git a/drivers/staging/dream/camera/mt9p012_fox.c b/drivers/staging/dream/camera/mt9p012_fox.c
index 791bd6c..544a973 100644
--- a/drivers/staging/dream/camera/mt9p012_fox.c
+++ b/drivers/staging/dream/camera/mt9p012_fox.c
@@ -123,7 +123,7 @@ struct mt9p012_ctrl {
 
 static struct mt9p012_ctrl *mt9p012_ctrl;
 static DECLARE_WAIT_QUEUE_HEAD(mt9p012_wait_queue);
-DECLARE_MUTEX(mt9p012_sem);
+DEFINE_SEMAPHORE(mt9p012_sem);
 
 /*=============================================================
 	EXTERNAL DECLARATIONS
diff --git a/drivers/staging/dream/camera/mt9t013.c b/drivers/staging/dream/camera/mt9t013.c
index 8fd7727..75e78aa 100644
--- a/drivers/staging/dream/camera/mt9t013.c
+++ b/drivers/staging/dream/camera/mt9t013.c
@@ -123,7 +123,7 @@ struct mt9t013_ctrl {
 
 static struct mt9t013_ctrl *mt9t013_ctrl;
 static DECLARE_WAIT_QUEUE_HEAD(mt9t013_wait_queue);
-DECLARE_MUTEX(mt9t013_sem);
+DEFINE_SEMAPHORE(mt9t013_sem);
 
 extern struct mt9t013_reg mt9t013_regs; /* from mt9t013_reg.c */
 
diff --git a/drivers/staging/dream/camera/s5k3e2fx.c b/drivers/staging/dream/camera/s5k3e2fx.c
index 1459903..d66b453 100644
--- a/drivers/staging/dream/camera/s5k3e2fx.c
+++ b/drivers/staging/dream/camera/s5k3e2fx.c
@@ -313,7 +313,7 @@ struct s5k3e2fx_i2c_reg_conf {
 
 static struct s5k3e2fx_ctrl *s5k3e2fx_ctrl;
 static DECLARE_WAIT_QUEUE_HEAD(s5k3e2fx_wait_queue);
-DECLARE_MUTEX(s5k3e2fx_sem);
+DEFINE_SEMAPHORE(s5k3e2fx_sem);
 
 static int s5k3e2fx_i2c_rxdata(unsigned short saddr, unsigned char *rxdata,
 	int length)
diff --git a/drivers/staging/msm/msm_fb.c b/drivers/staging/msm/msm_fb.c
index ea268ed..23fa049 100644
--- a/drivers/staging/msm/msm_fb.c
+++ b/drivers/staging/msm/msm_fb.c
@@ -1158,7 +1158,7 @@ static int msm_fb_release(struct fb_info *info, int user)
 	return ret;
 }
 
-DECLARE_MUTEX(msm_fb_pan_sem);
+DEFINE_SEMAPHORE(msm_fb_pan_sem);
 
 static int msm_fb_pan_display(struct fb_var_screeninfo *var,
 			      struct fb_info *info)
@@ -1962,7 +1962,7 @@ static int msmfb_overlay_play(struct fb_info *info, unsigned long *argp)
 
 #endif
 
-DECLARE_MUTEX(msm_fb_ioctl_ppp_sem);
+DEFINE_SEMAPHORE(msm_fb_ioctl_ppp_sem);
 DEFINE_MUTEX(msm_fb_ioctl_lut_sem);
 DEFINE_MUTEX(msm_fb_ioctl_hist_sem);
 
diff --git a/drivers/staging/rtl8712/osdep_service.h b/drivers/staging/rtl8712/osdep_service.h
index 7fca42c..d1674cd 100644
--- a/drivers/staging/rtl8712/osdep_service.h
+++ b/drivers/staging/rtl8712/osdep_service.h
@@ -161,7 +161,7 @@ static inline u32 _down_sema(struct semaphore *sema)
 
 static inline void _rtl_rwlock_init(struct semaphore *prwlock)
 {
-	init_MUTEX(prwlock);
+	sema_init(prwlock, 1);
 }
 
 static inline void _init_listhead(struct list_head *list)
diff --git a/drivers/staging/smbfs/inode.c b/drivers/staging/smbfs/inode.c
index 552951a..fa42f40 100644
--- a/drivers/staging/smbfs/inode.c
+++ b/drivers/staging/smbfs/inode.c
@@ -537,7 +537,7 @@ static int smb_fill_super(struct super_block *sb, void *raw_data, int silent)
 	server->mnt = NULL;
 	server->sock_file = NULL;
 	init_waitqueue_head(&server->conn_wq);
-	init_MUTEX(&server->sem);
+	sema_init(&server->sem, 1);
 	INIT_LIST_HEAD(&server->entry);
 	INIT_LIST_HEAD(&server->xmitq);
 	INIT_LIST_HEAD(&server->recvq);
diff --git a/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c b/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c
index f428a7a..e1851f0 100644
--- a/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c
+++ b/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c
@@ -157,7 +157,7 @@ struct cyasblkdev_blk_data {
 /* pointer to west bridge block data device superstructure */
 static struct cyasblkdev_blk_data *gl_bd;
 
-static DECLARE_MUTEX(open_lock);
+static DEFINE_SEMAPHORE(open_lock);
 
 /* local forwardd declarationss  */
 static cy_as_device_handle *cyas_dev_handle;
diff --git a/drivers/staging/westbridge/astoria/block/cyasblkdev_queue.c b/drivers/staging/westbridge/astoria/block/cyasblkdev_queue.c
index 24e959e..0bbb8a3 100644
--- a/drivers/staging/westbridge/astoria/block/cyasblkdev_queue.c
+++ b/drivers/staging/westbridge/astoria/block/cyasblkdev_queue.c
@@ -334,7 +334,7 @@ int cyasblkdev_init_queue(struct cyasblkdev_queue *bq, spinlock_t *lock)
 
 	init_completion(&bq->thread_complete);
 	init_waitqueue_head(&bq->thread_wq);
-	init_MUTEX(&bq->thread_sem);
+	sema_init(&bq->thread_sem, 1);
 
 	ret = kernel_thread(cyasblkdev_queue_thread, bq, CLONE_KERNEL);
 	if (ret >= 0) {
diff --git a/fs/hpfs/buffer.c b/fs/hpfs/buffer.c
index eac5f96..793cb9d 100644
--- a/fs/hpfs/buffer.c
+++ b/fs/hpfs/buffer.c
@@ -14,7 +14,7 @@ void hpfs_lock_creation(struct super_block *s)
 #ifdef DEBUG_LOCKS
 	printk("lock creation\n");
 #endif
-	down(&hpfs_sb(s)->hpfs_creation_de);
+	mutex_lock(&hpfs_sb(s)->hpfs_creation_de);
 }
 
 void hpfs_unlock_creation(struct super_block *s)
@@ -22,7 +22,7 @@ void hpfs_unlock_creation(struct super_block *s)
 #ifdef DEBUG_LOCKS
 	printk("unlock creation\n");
 #endif
-	up(&hpfs_sb(s)->hpfs_creation_de);
+	mutex_unlock(&hpfs_sb(s)->hpfs_creation_de);
 }
 
 /* Map a sector into a buffer and return pointers to it and to the buffer. */
diff --git a/fs/hpfs/hpfs_fn.h b/fs/hpfs/hpfs_fn.h
index b59eac0..2fee17d 100644
--- a/fs/hpfs/hpfs_fn.h
+++ b/fs/hpfs/hpfs_fn.h
@@ -87,7 +87,7 @@ struct hpfs_sb_info {
 	unsigned *sb_bmp_dir;		/* main bitmap directory */
 	unsigned sb_c_bitmap;		/* current bitmap */
 	unsigned sb_max_fwd_alloc;	/* max forwad allocation */
-	struct semaphore hpfs_creation_de; /* when creating dirents, nobody else
+	struct mutex hpfs_creation_de;	/* when creating dirents, nobody else
 					   can alloc blocks */
 	/*unsigned sb_mounting : 1;*/
 	int sb_timeshift;
diff --git a/fs/hpfs/super.c b/fs/hpfs/super.c
index c969a1a..18e1d45 100644
--- a/fs/hpfs/super.c
+++ b/fs/hpfs/super.c
@@ -491,7 +491,7 @@ static int hpfs_fill_super(struct super_block *s, void *options, int silent)
 	sbi->sb_bmp_dir = NULL;
 	sbi->sb_cp_table = NULL;
 
-	init_MUTEX(&sbi->hpfs_creation_de);
+	mutex_init(&sbi->hpfs_creation_de);
 
 	uid = current_uid();
 	gid = current_gid();
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 538417c..c590d15 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1838,7 +1838,6 @@ size_t journal_tag_bytes(journal_t *journal)
  */
 #define JBD2_MAX_SLABS 8
 static struct kmem_cache *jbd2_slab[JBD2_MAX_SLABS];
-static DECLARE_MUTEX(jbd2_slab_create_sem);
 
 static const char *jbd2_slab_names[JBD2_MAX_SLABS] = {
 	"jbd2_1k", "jbd2_2k", "jbd2_4k", "jbd2_8k",
@@ -1859,6 +1858,7 @@ static void jbd2_journal_destroy_slabs(void)
 
 static int jbd2_journal_create_slab(size_t size)
 {
+	static DEFINE_MUTEX(jbd2_slab_create_mutex);
 	int i = order_base_2(size) - 10;
 	size_t slab_size;
 
@@ -1870,16 +1870,16 @@ static int jbd2_journal_create_slab(size_t size)
 
 	if (unlikely(i < 0))
 		i = 0;
-	down(&jbd2_slab_create_sem);
+	mutex_lock(&jbd2_slab_create_mutex);
 	if (jbd2_slab[i]) {
-		up(&jbd2_slab_create_sem);
+		mutex_unlock(&jbd2_slab_create_mutex);
 		return 0;	/* Already created */
 	}
 
 	slab_size = 1 << (i+10);
 	jbd2_slab[i] = kmem_cache_create(jbd2_slab_names[i], slab_size,
 					 slab_size, 0, NULL);
-	up(&jbd2_slab_create_sem);
+	mutex_unlock(&jbd2_slab_create_mutex);
 	if (!jbd2_slab[i]) {
 		printk(KERN_EMERG "JBD2: no memory for jbd2_slab cache\n");
 		return -ENOMEM;
diff --git a/include/linux/semaphore.h b/include/linux/semaphore.h
index 5310d27..39fa049 100644
--- a/include/linux/semaphore.h
+++ b/include/linux/semaphore.h
@@ -29,9 +29,6 @@ struct semaphore {
 #define DEFINE_SEMAPHORE(name)	\
 	struct semaphore name = __SEMAPHORE_INITIALIZER(name, 1)
 
-#define DECLARE_MUTEX(name)	\
-	struct semaphore name = __SEMAPHORE_INITIALIZER(name, 1)
-
 static inline void sema_init(struct semaphore *sem, int val)
 {
 	static struct lock_class_key __key;
@@ -39,9 +36,6 @@ static inline void sema_init(struct semaphore *sem, int val)
 	lockdep_init_map(&sem->lock.dep_map, "semaphore->lock", &__key, 0);
 }
 
-#define init_MUTEX(sem)		sema_init(sem, 1)
-#define init_MUTEX_LOCKED(sem)	sema_init(sem, 0)
-
 extern void down(struct semaphore *sem);
 extern int __must_check down_interruptible(struct semaphore *sem);
 extern int __must_check down_killable(struct semaphore *sem);
diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 90b54d4..e3c7fc0 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2794,12 +2794,8 @@ sub process {
 			WARN("__func__ should be used instead of gcc specific __FUNCTION__\n"  . $herecurr);
 		}
 
-# check for semaphores used as mutexes
-		if ($line =~ /^.\s*(DECLARE_MUTEX|init_MUTEX)\s*\(/) {
-			WARN("mutexes are preferred for single holder semaphores\n" . $herecurr);
-		}
-# check for semaphores used as mutexes
-		if ($line =~ /^.\s*init_MUTEX_LOCKED\s*\(/) {
+# check for semaphores initialized locked
+		if ($line =~ /^.\s*sema_init.+,\W?0\W?\)/) {
 			WARN("consider using a completion\n" . $herecurr);
 
 		}
