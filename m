Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207Ab0IGOe7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 10:34:59 -0400
Received: from www.tglx.de ([62.245.132.106]:43970 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932275Ab0IGOeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 10:34:10 -0400
Message-Id: <20100907125057.278833764@linutronix.de>
User-Agent: quilt/0.47-1
Date: Tue, 07 Sep 2010 14:33:47 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 27/30] staging: Bulk convert the semaphore mess
References: <20100907124636.880953480@linutronix.de>
Content-Disposition: inline; filename=drivers-staging-bulk-sema-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

init_MUTEX(_LOCKED) and DECLARE_MUTEX are going away. Bulk convert
staging users.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/comedi/drivers/dt9812.c     |    2 +-
 drivers/staging/comedi/drivers/usbdux.c     |    4 ++--
 drivers/staging/comedi/drivers/usbduxfast.c |    4 ++--
 drivers/staging/cxt1e1/functions.c          |    4 ++--
 drivers/staging/dream/pmem.c                |    2 +-
 drivers/staging/msm/mddihost.c              |    2 +-
 drivers/staging/msm/mdp.c                   |   10 +++++-----
 drivers/staging/msm/msm_fb.c                |    2 +-
 drivers/staging/otus/wwrap.c                |    2 +-
 drivers/staging/rt2860/common/rtmp_init.c   |    2 +-
 drivers/staging/solo6x10/solo6010-i2c.c     |    2 +-
 drivers/staging/solo6x10/solo6010-p2m.c     |    2 +-
 drivers/staging/vme/devices/vme_user.c      |    2 +-
 13 files changed, 20 insertions(+), 20 deletions(-)

Index: linux-2.6/drivers/staging/comedi/drivers/dt9812.c
===================================================================
--- linux-2.6.orig/drivers/staging/comedi/drivers/dt9812.c
+++ linux-2.6/drivers/staging/comedi/drivers/dt9812.c
@@ -1128,7 +1128,7 @@ static int __init usb_dt9812_init(void)
 
 	/* Initialize all driver slots */
 	for (i = 0; i < DT9812_NUM_SLOTS; i++) {
-		init_MUTEX(&dt9812[i].mutex);
+		sema_init(&dt9812[i].mutex, 1);
 		dt9812[i].serial = 0;
 		dt9812[i].usb = NULL;
 		dt9812[i].comedi = NULL;
Index: linux-2.6/drivers/staging/comedi/drivers/usbdux.c
===================================================================
--- linux-2.6.orig/drivers/staging/comedi/drivers/usbdux.c
+++ linux-2.6/drivers/staging/comedi/drivers/usbdux.c
@@ -315,7 +315,7 @@ struct usbduxsub {
  */
 static struct usbduxsub usbduxsub[NUMUSBDUX];
 
-static DECLARE_MUTEX(start_stop_sem);
+static DEFINE_SEMAPHORE(start_stop_sem);
 
 /*
  * Stops the data acquision
@@ -2367,7 +2367,7 @@ static int usbduxsub_probe(struct usb_in
 	dev_dbg(dev, "comedi_: usbdux: "
 		"usbduxsub[%d] is ready to connect to comedi.\n", index);
 
-	init_MUTEX(&(usbduxsub[index].sem));
+	sema_init(&(usbduxsub[index].sem), 1);
 	/* save a pointer to the usb device */
 	usbduxsub[index].usbdev = udev;
 
Index: linux-2.6/drivers/staging/comedi/drivers/usbduxfast.c
===================================================================
--- linux-2.6.orig/drivers/staging/comedi/drivers/usbduxfast.c
+++ linux-2.6/drivers/staging/comedi/drivers/usbduxfast.c
@@ -199,7 +199,7 @@ struct usbduxfastsub_s {
  */
 static struct usbduxfastsub_s usbduxfastsub[NUMUSBDUXFAST];
 
-static DECLARE_MUTEX(start_stop_sem);
+static DEFINE_SEMAPHORE(start_stop_sem);
 
 /*
  * bulk transfers to usbduxfast
@@ -1504,7 +1504,7 @@ static int usbduxfastsub_probe(struct us
 	       "connect to comedi.\n", index);
 #endif
 
-	init_MUTEX(&(usbduxfastsub[index].sem));
+	sema_init(&(usbduxfastsub[index].sem), 1);
 	/* save a pointer to the usb device */
 	usbduxfastsub[index].usbdev = udev;
 
Index: linux-2.6/drivers/staging/cxt1e1/functions.c
===================================================================
--- linux-2.6.orig/drivers/staging/cxt1e1/functions.c
+++ linux-2.6/drivers/staging/cxt1e1/functions.c
@@ -184,10 +184,10 @@ OS_sem_init (void *sem, int state)
     switch (state)
     {
         case SEM_TAKEN:
-        init_MUTEX_LOCKED ((struct semaphore *) sem);
+		sema_init((struct semaphore *) sem, 0);
         break;
     case SEM_AVAILABLE:
-        init_MUTEX ((struct semaphore *) sem);
+	    sema_init((struct semaphore *) sem, 1);
         break;
     default:                        /* otherwise, set sem.count to state's
                                      * value */
Index: linux-2.6/drivers/staging/dream/pmem.c
===================================================================
--- linux-2.6.orig/drivers/staging/dream/pmem.c
+++ linux-2.6/drivers/staging/dream/pmem.c
@@ -1231,7 +1231,7 @@ int pmem_setup(struct android_pmem_platf
 	pmem[id].ioctl = ioctl;
 	pmem[id].release = release;
 	init_rwsem(&pmem[id].bitmap_sem);
-	init_MUTEX(&pmem[id].data_list_sem);
+	sema_init(&pmem[id].data_list_sem, 1);
 	INIT_LIST_HEAD(&pmem[id].data_list);
 	pmem[id].dev.name = pdata->name;
 	pmem[id].dev.minor = id;
Index: linux-2.6/drivers/staging/msm/mddihost.c
===================================================================
--- linux-2.6.orig/drivers/staging/msm/mddihost.c
+++ linux-2.6/drivers/staging/msm/mddihost.c
@@ -67,7 +67,7 @@ void mddi_init(void)
 
 	mddi_host_initialized = TRUE;
 
-	init_MUTEX(&mddi_host_mutex);
+	sema_init(&mddi_host_mutex, 1);
 
 	if (!mddi_host_powered) {
 		down(&mddi_host_mutex);
Index: linux-2.6/drivers/staging/msm/mdp.c
===================================================================
--- linux-2.6.orig/drivers/staging/msm/mdp.c
+++ linux-2.6/drivers/staging/msm/mdp.c
@@ -669,24 +669,24 @@ static void mdp_drv_init(void)
 
 	/* initialize semaphore */
 	init_completion(&mdp_ppp_comp);
-	init_MUTEX(&mdp_ppp_mutex);
-	init_MUTEX(&mdp_pipe_ctrl_mutex);
+	sema_init(&mdp_ppp_mutex, 1);
+	sema_init(&mdp_pipe_ctrl_mutex, 1);
 
 	dma2_data.busy = FALSE;
 	dma2_data.waiting = FALSE;
 	init_completion(&dma2_data.comp);
-	init_MUTEX(&dma2_data.mutex);
+	sema_init(&dma2_data.mutex, 1);
 	mutex_init(&dma2_data.ov_mutex);
 
 	dma3_data.busy = FALSE;
 	dma3_data.waiting = FALSE;
 	init_completion(&dma3_data.comp);
-	init_MUTEX(&dma3_data.mutex);
+	sema_init(&dma3_data.mutex, 1);
 
 	dma_s_data.busy = FALSE;
 	dma_s_data.waiting = FALSE;
 	init_completion(&dma_s_data.comp);
-	init_MUTEX(&dma_s_data.mutex);
+	sema_init(&dma_s_data.mutex, 1);
 
 	dma_e_data.busy = FALSE;
 	dma_e_data.waiting = FALSE;
Index: linux-2.6/drivers/staging/msm/msm_fb.c
===================================================================
--- linux-2.6.orig/drivers/staging/msm/msm_fb.c
+++ linux-2.6/drivers/staging/msm/msm_fb.c
@@ -915,7 +915,7 @@ static int msm_fb_register(struct msm_fb
 	mfd->pan_waiting = FALSE;
 	init_completion(&mfd->pan_comp);
 	init_completion(&mfd->refresher_comp);
-	init_MUTEX(&mfd->sem);
+	sema_init(&mfd->sem, 1);
 
 	fbram_offset = PAGE_ALIGN((int)fbram)-(int)fbram;
 	fbram += fbram_offset;
Index: linux-2.6/drivers/staging/otus/wwrap.c
===================================================================
--- linux-2.6.orig/drivers/staging/otus/wwrap.c
+++ linux-2.6/drivers/staging/otus/wwrap.c
@@ -985,7 +985,7 @@ u8_t zfLnxCreateThread(zdev_t *dev)
 
     /* Create Mutex and keventd */
     INIT_WORK(&macp->kevent, kevent);
-    init_MUTEX(&macp->ioctl_sem);
+    sema_init(&macp->ioctl_sem, 1);
 
     return 0;
 }
Index: linux-2.6/drivers/staging/rt2860/common/rtmp_init.c
===================================================================
--- linux-2.6.orig/drivers/staging/rt2860/common/rtmp_init.c
+++ linux-2.6/drivers/staging/rt2860/common/rtmp_init.c
@@ -3509,7 +3509,7 @@ int RtmpRaDevCtrlInit(struct rt_rtmp_ada
 		 ("STA Driver version-%s\n", STA_DRIVER_VERSION));
 
 #ifdef RTMP_MAC_USB
-	init_MUTEX(&(pAd->UsbVendorReq_semaphore));
+	sema_init(&(pAd->UsbVendorReq_semaphore), 1);
 	os_alloc_mem(pAd, (u8 **) & pAd->UsbVendorReqBuf,
 		     MAX_PARAM_BUFFER_SIZE - 1);
 	if (pAd->UsbVendorReqBuf == NULL) {
Index: linux-2.6/drivers/staging/solo6x10/solo6010-i2c.c
===================================================================
--- linux-2.6.orig/drivers/staging/solo6x10/solo6010-i2c.c
+++ linux-2.6/drivers/staging/solo6x10/solo6010-i2c.c
@@ -284,7 +284,7 @@ int solo_i2c_init(struct solo6010_dev *s
 	solo_dev->i2c_id = -1;
 	solo_dev->i2c_state = IIC_STATE_IDLE;
 	init_waitqueue_head(&solo_dev->i2c_wait);
-	init_MUTEX(&solo_dev->i2c_sem);
+	sema_init(&solo_dev->i2c_sem, 1);
 
 	for (i = 0; i < SOLO_I2C_ADAPTERS; i++) {
 		struct i2c_adapter *adap = &solo_dev->i2c_adap[i];
Index: linux-2.6/drivers/staging/solo6x10/solo6010-p2m.c
===================================================================
--- linux-2.6.orig/drivers/staging/solo6x10/solo6010-p2m.c
+++ linux-2.6/drivers/staging/solo6x10/solo6010-p2m.c
@@ -188,7 +188,7 @@ int solo_p2m_init(struct solo6010_dev *s
 	for (i = 0; i < SOLO_NR_P2M; i++) {
 		p2m_dev = &solo_dev->p2m_dev[i];
 
-		init_MUTEX(&p2m_dev->sem);
+		sema_init(&p2m_dev->sem, 1);
 		init_completion(&p2m_dev->completion);
 
 		solo_reg_write(solo_dev, SOLO_P2M_DES_ADR(i),
Index: linux-2.6/drivers/staging/vme/devices/vme_user.c
===================================================================
--- linux-2.6.orig/drivers/staging/vme/devices/vme_user.c
+++ linux-2.6/drivers/staging/vme/devices/vme_user.c
@@ -683,7 +683,7 @@ static int __init vme_user_probe(struct 
 	for (i = 0; i < VME_DEVS; i++) {
 		image[i].kern_buf = NULL;
 		image[i].pci_buf = 0;
-		init_MUTEX(&(image[i].sem));
+		sema_init(&(image[i].sem), 1);
 		image[i].device = NULL;
 		image[i].resource = NULL;
 		image[i].users = 0;


