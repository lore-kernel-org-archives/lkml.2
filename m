Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887Ab1HSTXY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 15:23:24 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46247 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755633Ab1HSTXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 15:23:22 -0400
From: Per Forlin <per.forlin@linaro.org>
To: Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        Michal Nazarewicz <mina86@mina86.com>,
        Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Per Forlin <per.forlin@linaro.org>
Subject: [PATCH v6] usb: gadget: storage: make FSG_NUM_BUFFERS variable size
Date: Fri, 19 Aug 2011 21:21:27 +0200
Message-Id: <1313781687-13955-1-git-send-email-per.forlin@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FSG_NUM_BUFFERS is set to 2 as default.
Usually 2 buffers are enough to establish a good buffering pipeline.
The number may be increased in order to compensate a for bursty VFS
behaviour.

Here follows a description of system that may require more than
2 buffers.
 * CPU ondemand governor active
 * latency cost for wake up and/or frequency change
 * DMA for IO

Use case description.
 * Data transfer from MMC via VFS to USB.
 * DMA shuffles data from MMC and to USB.
 * The CPU wakes up every now and then to pass data in and out from VFS,
   which cause the bursty VFS behaviour.

Test set up
 * Running dd on the host reading from the mass storage device
 * cmdline: dd if=/dev/sdb of=/dev/null bs=4k count=$((256*100))
 * Caches are dropped on the host and on the device before each run

Measurements on a Snowball board with ondemand_governor active.

FSG_NUM_BUFFERS 2
104857600 bytes (105 MB) copied, 5.62173 s, 18.7 MB/s
104857600 bytes (105 MB) copied, 5.61811 s, 18.7 MB/s
104857600 bytes (105 MB) copied, 5.57817 s, 18.8 MB/s

FSG_NUM_BUFFERS 4
104857600 bytes (105 MB) copied, 5.26839 s, 19.9 MB/s
104857600 bytes (105 MB) copied, 5.2691 s, 19.9 MB/s
104857600 bytes (105 MB) copied, 5.2711 s, 19.9 MB/s

There may not be one optimal number for all boards. This is why
the number is added to Kconfig. If selecting USB_GADGET_DEBUG_FILES
this value may be set by a module parameter as well.

Signed-off-by: Per Forlin <per.forlin@linaro.org>
---
Change log.
v2: Update after proofreading comments from Michal Nazarewicz
v3: Clarify the description of this patch based on input from Alan Stern
v4: - Introduce a module_param to set number of pipeline buffers
    if USB_DEBUG is set. In order to add this support fsg_common is
    allocated at runtime. The fsg_buffhd list size is appended to fsg_dev
    and fsg_common at runtime allocation.
    - The previous acks from Michal and Alan on v3 are not applicable
    for this version since it's a new implementation.
v5: - Separate allocation of buffhds in f_mass_storage.c
    - Change FSG_NUM_BUFFERS to fsg_num_buffers to indicate variable value.
    - code clean up and document module param, all thanks to Michal and Alan.
v6: - add missing kfree for buffhds and remove some redundant code.

 drivers/usb/gadget/Kconfig          |   16 ++++++++++++++++
 drivers/usb/gadget/f_mass_storage.c |   29 +++++++++++++++++++++--------
 drivers/usb/gadget/file_storage.c   |   27 +++++++++++++++++----------
 drivers/usb/gadget/storage_common.c |   33 +++++++++++++++++++++++++++++++--
 4 files changed, 85 insertions(+), 20 deletions(-)

diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index 44b6b40..15e1426 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -96,6 +96,22 @@ config USB_GADGET_VBUS_DRAW
 	   This value will be used except for system-specific gadget
 	   drivers that have more specific information.
 
+config USB_GADGET_STORAGE_NUM_BUFFERS
+	int "Number of storage pipeline buffers"
+	range 2 4
+	default 2
+	help
+	   Usually 2 buffers are enough to establish a good buffering
+	   pipeline. The number may be increased in order to compensate
+	   for a bursty VFS behaviour. For instance there may be CPU wake up
+	   latencies that makes the VFS to appear bursty in a system with
+	   an CPU on-demand governor. Especially if DMA is doing IO to
+	   offload the CPU. In this case the CPU will go into power
+	   save often and spin up occasionally to move data within VFS.
+	   If selecting USB_GADGET_DEBUG_FILES this value may be set by
+	   a module parameter as well.
+	   If unsure, say 2.
+
 #
 # USB Peripheral Controller Support
 #
diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index 5b93395..d2e5ee9 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -363,7 +363,7 @@ struct fsg_common {
 
 	struct fsg_buffhd	*next_buffhd_to_fill;
 	struct fsg_buffhd	*next_buffhd_to_drain;
-	struct fsg_buffhd	buffhds[FSG_NUM_BUFFERS];
+	struct fsg_buffhd	*buffhds;
 
 	int			cmnd_size;
 	u8			cmnd[MAX_COMMAND_SIZE];
@@ -2348,7 +2348,7 @@ reset:
 	if (common->fsg) {
 		fsg = common->fsg;
 
-		for (i = 0; i < FSG_NUM_BUFFERS; ++i) {
+		for (i = 0; i < fsg_num_buffers; ++i) {
 			struct fsg_buffhd *bh = &common->buffhds[i];
 
 			if (bh->inreq) {
@@ -2406,7 +2406,7 @@ reset:
 	clear_bit(IGNORE_BULK_OUT, &fsg->atomic_bitflags);
 
 	/* Allocate the requests */
-	for (i = 0; i < FSG_NUM_BUFFERS; ++i) {
+	for (i = 0; i < fsg_num_buffers; ++i) {
 		struct fsg_buffhd	*bh = &common->buffhds[i];
 
 		rc = alloc_request(common, fsg->bulk_in, &bh->inreq);
@@ -2475,7 +2475,7 @@ static void handle_exception(struct fsg_common *common)
 
 	/* Cancel all the pending transfers */
 	if (likely(common->fsg)) {
-		for (i = 0; i < FSG_NUM_BUFFERS; ++i) {
+		for (i = 0; i < fsg_num_buffers; ++i) {
 			bh = &common->buffhds[i];
 			if (bh->inreq_busy)
 				usb_ep_dequeue(common->fsg->bulk_in, bh->inreq);
@@ -2487,7 +2487,7 @@ static void handle_exception(struct fsg_common *common)
 		/* Wait until everything is idle */
 		for (;;) {
 			int num_active = 0;
-			for (i = 0; i < FSG_NUM_BUFFERS; ++i) {
+			for (i = 0; i < fsg_num_buffers; ++i) {
 				bh = &common->buffhds[i];
 				num_active += bh->inreq_busy + bh->outreq_busy;
 			}
@@ -2510,7 +2510,7 @@ static void handle_exception(struct fsg_common *common)
 	 */
 	spin_lock_irq(&common->lock);
 
-	for (i = 0; i < FSG_NUM_BUFFERS; ++i) {
+	for (i = 0; i < fsg_num_buffers; ++i) {
 		bh = &common->buffhds[i];
 		bh->state = BUF_STATE_EMPTY;
 	}
@@ -2719,6 +2719,10 @@ static struct fsg_common *fsg_common_init(struct fsg_common *common,
 	int nluns, i, rc;
 	char *pathbuf;
 
+	rc = fsg_num_buffers_validate();
+	if (rc != 0)
+		return ERR_PTR(rc);
+
 	/* Find out how many LUNs there should be */
 	nluns = cfg->nluns;
 	if (nluns < 1 || nluns > FSG_MAX_LUNS) {
@@ -2737,6 +2741,14 @@ static struct fsg_common *fsg_common_init(struct fsg_common *common,
 		common->free_storage_on_release = 0;
 	}
 
+	common->buffhds = kcalloc(fsg_num_buffers,
+				  sizeof *(common->buffhds), GFP_KERNEL);
+	if (!common->buffhds) {
+		if (common->free_storage_on_release)
+			kfree(common);
+		return ERR_PTR(-ENOMEM);
+	}
+
 	common->ops = cfg->ops;
 	common->private_data = cfg->private_data;
 
@@ -2814,7 +2826,7 @@ static struct fsg_common *fsg_common_init(struct fsg_common *common,
 
 	/* Data buffers cyclic list */
 	bh = common->buffhds;
-	i = FSG_NUM_BUFFERS;
+	i = fsg_num_buffers;
 	goto buffhds_first_it;
 	do {
 		bh->next = bh + 1;
@@ -2940,12 +2952,13 @@ static void fsg_common_release(struct kref *ref)
 
 	{
 		struct fsg_buffhd *bh = common->buffhds;
-		unsigned i = FSG_NUM_BUFFERS;
+		unsigned i = fsg_num_buffers;
 		do {
 			kfree(bh->buf);
 		} while (++bh, --i);
 	}
 
+	kfree(common->buffhds);
 	if (common->free_storage_on_release)
 		kfree(common);
 }
diff --git a/drivers/usb/gadget/file_storage.c b/drivers/usb/gadget/file_storage.c
index 639e14a..ba95ef4 100644
--- a/drivers/usb/gadget/file_storage.c
+++ b/drivers/usb/gadget/file_storage.c
@@ -461,7 +461,6 @@ struct fsg_dev {
 
 	struct fsg_buffhd	*next_buffhd_to_fill;
 	struct fsg_buffhd	*next_buffhd_to_drain;
-	struct fsg_buffhd	buffhds[FSG_NUM_BUFFERS];
 
 	int			thread_wakeup_needed;
 	struct completion	thread_notifier;
@@ -488,6 +487,8 @@ struct fsg_dev {
 	unsigned int		nluns;
 	struct fsg_lun		*luns;
 	struct fsg_lun		*curlun;
+	/* Must be the last entry */
+	struct fsg_buffhd	buffhds[];
 };
 
 typedef void (*fsg_routine_t)(struct fsg_dev *);
@@ -2752,7 +2753,7 @@ static int do_set_interface(struct fsg_dev *fsg, int altsetting)
 
 reset:
 	/* Deallocate the requests */
-	for (i = 0; i < FSG_NUM_BUFFERS; ++i) {
+	for (i = 0; i < fsg_num_buffers; ++i) {
 		struct fsg_buffhd *bh = &fsg->buffhds[i];
 
 		if (bh->inreq) {
@@ -2813,7 +2814,7 @@ reset:
 	}
 
 	/* Allocate the requests */
-	for (i = 0; i < FSG_NUM_BUFFERS; ++i) {
+	for (i = 0; i < fsg_num_buffers; ++i) {
 		struct fsg_buffhd	*bh = &fsg->buffhds[i];
 
 		if ((rc = alloc_request(fsg, fsg->bulk_in, &bh->inreq)) != 0)
@@ -2909,7 +2910,7 @@ static void handle_exception(struct fsg_dev *fsg)
 	/* Cancel all the pending transfers */
 	if (fsg->intreq_busy)
 		usb_ep_dequeue(fsg->intr_in, fsg->intreq);
-	for (i = 0; i < FSG_NUM_BUFFERS; ++i) {
+	for (i = 0; i < fsg_num_buffers; ++i) {
 		bh = &fsg->buffhds[i];
 		if (bh->inreq_busy)
 			usb_ep_dequeue(fsg->bulk_in, bh->inreq);
@@ -2920,7 +2921,7 @@ static void handle_exception(struct fsg_dev *fsg)
 	/* Wait until everything is idle */
 	for (;;) {
 		num_active = fsg->intreq_busy;
-		for (i = 0; i < FSG_NUM_BUFFERS; ++i) {
+		for (i = 0; i < fsg_num_buffers; ++i) {
 			bh = &fsg->buffhds[i];
 			num_active += bh->inreq_busy + bh->outreq_busy;
 		}
@@ -2942,7 +2943,7 @@ static void handle_exception(struct fsg_dev *fsg)
 	 * state, and the exception.  Then invoke the handler. */
 	spin_lock_irq(&fsg->lock);
 
-	for (i = 0; i < FSG_NUM_BUFFERS; ++i) {
+	for (i = 0; i < fsg_num_buffers; ++i) {
 		bh = &fsg->buffhds[i];
 		bh->state = BUF_STATE_EMPTY;
 	}
@@ -3172,7 +3173,7 @@ static void /* __init_or_exit */ fsg_unbind(struct usb_gadget *gadget)
 	}
 
 	/* Free the data buffers */
-	for (i = 0; i < FSG_NUM_BUFFERS; ++i)
+	for (i = 0; i < fsg_num_buffers; ++i)
 		kfree(fsg->buffhds[i].buf);
 
 	/* Free the request and buffer for endpoint 0 */
@@ -3460,7 +3461,7 @@ static int __init fsg_bind(struct usb_gadget *gadget)
 	req->complete = ep0_complete;
 
 	/* Allocate the data buffers */
-	for (i = 0; i < FSG_NUM_BUFFERS; ++i) {
+	for (i = 0; i < fsg_num_buffers; ++i) {
 		struct fsg_buffhd	*bh = &fsg->buffhds[i];
 
 		/* Allocate for the bulk-in endpoint.  We assume that
@@ -3471,7 +3472,7 @@ static int __init fsg_bind(struct usb_gadget *gadget)
 			goto out;
 		bh->next = bh + 1;
 	}
-	fsg->buffhds[FSG_NUM_BUFFERS - 1].next = &fsg->buffhds[0];
+	fsg->buffhds[fsg_num_buffers - 1].next = &fsg->buffhds[0];
 
 	/* This should reflect the actual gadget power source */
 	usb_gadget_set_selfpowered(gadget);
@@ -3587,7 +3588,9 @@ static int __init fsg_alloc(void)
 {
 	struct fsg_dev		*fsg;
 
-	fsg = kzalloc(sizeof *fsg, GFP_KERNEL);
+	fsg = kzalloc(sizeof *fsg +
+		      fsg_num_buffers * sizeof *(fsg->buffhds), GFP_KERNEL);
+
 	if (!fsg)
 		return -ENOMEM;
 	spin_lock_init(&fsg->lock);
@@ -3605,6 +3608,10 @@ static int __init fsg_init(void)
 	int		rc;
 	struct fsg_dev	*fsg;
 
+	rc = fsg_num_buffers_validate();
+	if (rc != 0)
+		return rc;
+
 	if ((rc = fsg_alloc()) != 0)
 		return rc;
 	fsg = the_fsg;
diff --git a/drivers/usb/gadget/storage_common.c b/drivers/usb/gadget/storage_common.c
index d3dd227..fda15fa 100644
--- a/drivers/usb/gadget/storage_common.c
+++ b/drivers/usb/gadget/storage_common.c
@@ -52,6 +52,12 @@
  * characters rather then a pointer to void.
  */
 
+/*
+ * When USB_GADGET_DEBUG_FILES is defined the module param num_buffers
+ * sets the number of pipeline buffers (length of the fsg_buffhd array).
+ * The valid range of num_buffers is: num >= 2 && num <= 4.
+ */
+
 
 #include <linux/usb/storage.h>
 #include <scsi/scsi.h>
@@ -262,8 +268,31 @@ static struct fsg_lun *fsg_lun_from_dev(struct device *dev)
 #define EP0_BUFSIZE	256
 #define DELAYED_STATUS	(EP0_BUFSIZE + 999)	/* An impossibly large value */
 
-/* Number of buffers we will use.  2 is enough for double-buffering */
-#define FSG_NUM_BUFFERS	2
+#ifdef CONFIG_USB_GADGET_DEBUG_FILES
+
+static unsigned int fsg_num_buffers = CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS;
+module_param_named(num_buffers, fsg_num_buffers, uint, S_IRUGO);
+MODULE_PARM_DESC(num_buffers, "Number of pipeline buffers");
+
+#else
+
+/*
+ * Number of buffers we will use.
+ * 2 is usually enough for good buffering pipeline
+ */
+#define fsg_num_buffers	CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS
+
+#endif /* CONFIG_USB_DEBUG */
+
+/* check if fsg_num_buffers is within a valid range */
+static inline int fsg_num_buffers_validate(void)
+{
+	if (fsg_num_buffers >= 2 && fsg_num_buffers <= 4)
+		return 0;
+	pr_err("fsg_num_buffers %u is out of range (%d to %d)\n",
+	       fsg_num_buffers, 2 ,4);
+	return -EINVAL;
+}
 
 /* Default size of buffer length. */
 #define FSG_BUFLEN	((u32)16384)
-- 
1.7.4.1

