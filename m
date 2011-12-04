Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600Ab1LDUNb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 15:13:31 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:6403 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755434Ab1LDUNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 15:13:18 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6550"; a="143581303"
From: Shimrit Malichi <smalichi@codeaurora.org>
To: greg@kroah.com
Cc: linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org, balbi@ti.com,
        ablay@codeaurora.org, Shimrit Malichi <smalichi@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC/PATCH v4 3/3] uas: Supporting UAS and BOT configuration.
Date: Sun,  4 Dec 2011 22:12:31 +0200
Message-Id: <1323029552-15324-3-git-send-email-smalichi@codeaurora.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1323029552-15324-1-git-send-email-smalichi@codeaurora.org>
References: <1323029552-15324-1-git-send-email-smalichi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two configuration were added to the mass storage gadget: BOT (the first one),
and UAS. The linux host can switch between the configurations by changing
the value of bConfigValue in /sys/bus/usb/devices/<your_usb_device>/

Also, a fallback to HS in case SS configuration fails was added.

Signed-off-by: Shimrit Malichi <smalichi@codeaurora.org>
---
 drivers/usb/gadget/f_mass_storage.c |   92 +---
 drivers/usb/gadget/f_uasp.c         | 1063 ++++++++++++++++++++---------------
 drivers/usb/gadget/f_uasp.h         |  106 +++-
 drivers/usb/gadget/mass_storage.c   |   88 ++--
 drivers/usb/gadget/storage_common.c |   66 +++-
 drivers/usb/gadget/uasp_cmdiu.c     |  176 +++---
 drivers/usb/gadget/uasp_tmiu.c      |   60 +-
 7 files changed, 955 insertions(+), 696 deletions(-)

diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index b777d72..96da3f6 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -317,39 +317,16 @@ static const char fsg_string_interface[] = "Mass Storage";
 struct fsg_dev;
 struct fsg_common;
 
-/* FSF callback functions */
-struct fsg_operations {
-	/*
-	 * Callback function to call when thread exits.  If no
-	 * callback is set or it returns value lower then zero MSF
-	 * will force eject all LUNs it operates on (including those
-	 * marked as non-removable or with prevent_medium_removal flag
-	 * set).
-	 */
-	int (*thread_exits)(struct fsg_common *common);
-
-	/*
-	 * Called prior to ejection.  Negative return means error,
-	 * zero means to continue with ejection, positive means not to
-	 * eject.
-	 */
-	int (*pre_eject)(struct fsg_common *common,
-			 struct fsg_lun *lun, int num);
-	/*
-	 * Called after ejection.  Negative return means error, zero
-	 * or positive is just a success.
-	 */
-	int (*post_eject)(struct fsg_common *common,
-			  struct fsg_lun *lun, int num);
-};
-
 /* Data shared by all the FSG instances. */
 struct fsg_common {
 	struct usb_gadget	*gadget;
 	struct usb_composite_dev *cdev;
+	struct msg_common_data	*msg_common;
 	struct fsg_dev		*fsg, *new_fsg;
 	wait_queue_head_t	fsg_wait;
 
+	struct mutex		*config_mutex;
+
 	/* filesem protects: backing files in use */
 	struct rw_semaphore	filesem;
 
@@ -408,31 +385,6 @@ struct fsg_common {
 	struct kref		ref;
 };
 
-struct fsg_config {
-	unsigned nluns;
-	struct fsg_lun_config {
-		const char *filename;
-		char ro;
-		char removable;
-		char cdrom;
-		char nofua;
-	} luns[FSG_MAX_LUNS];
-
-	const char		*lun_name_format;
-	const char		*thread_name;
-
-	/* Callback functions. */
-	const struct fsg_operations	*ops;
-	/* Gadget's private data. */
-	void			*private_data;
-
-	const char *vendor_name;		/*  8 characters or less */
-	const char *product_name;		/* 16 characters or less */
-	u16 release;
-
-	char			can_stall;
-};
-
 struct fsg_dev {
 	struct usb_function	function;
 	struct usb_gadget	*gadget;	/* Copy of cdev->gadget */
@@ -2364,7 +2316,10 @@ reset:
 			usb_ep_disable(fsg->bulk_out);
 			fsg->bulk_out_enabled = 0;
 		}
-
+		DBG(common,
+		    "%s()- disabled endpoints, releasing config mutex\n",
+		    __func__);
+		mutex_unlock(common->config_mutex);
 		common->fsg = NULL;
 		wake_up(&common->fsg_wait);
 	}
@@ -2373,6 +2328,9 @@ reset:
 	if (!new_fsg || rc)
 		return rc;
 
+	DBG(common, "%s()- Enabling endpoints, taking config mutex\n",
+	    __func__);
+	mutex_lock(common->config_mutex);
 	common->fsg = new_fsg;
 	fsg = common->fsg;
 
@@ -2703,8 +2661,7 @@ static inline void fsg_common_put(struct fsg_common *common)
 
 static struct fsg_common *fsg_common_init(struct fsg_common *common,
 					  struct usb_composite_dev *cdev,
-					  struct fsg_config *cfg,
-					  int start_thread)
+					  struct fsg_config *cfg)
 {
 	struct usb_gadget *gadget = cdev->gadget;
 	struct fsg_buffhd *bh;
@@ -2750,6 +2707,7 @@ static struct fsg_common *fsg_common_init(struct fsg_common *common,
 	common->ep0 = gadget->ep0;
 	common->ep0req = cdev->req;
 	common->cdev = cdev;
+	common->config_mutex = &(cfg->config_mutex);
 
 	/* Maybe allocate device-global string IDs, and patch descriptors */
 	if (fsg_strings[FSG_STRING_INTERFACE].id == 0) {
@@ -2866,15 +2824,12 @@ buffhds_first_it:
 	spin_lock_init(&common->lock);
 	kref_init(&common->ref);
 
-	/* Tell the thread to start working */
-	if (start_thread) {
-		common->thread_task =
-			kthread_create(fsg_main_thread, common,
-			       cfg->thread_name ?: "file-storage");
-		if (IS_ERR(common->thread_task)) {
-			rc = PTR_ERR(common->thread_task);
-			goto error_release;
-		}
+	common->thread_task =
+		kthread_create(fsg_main_thread, common,
+		       cfg->thread_name ?: "file-storage");
+	if (IS_ERR(common->thread_task)) {
+		rc = PTR_ERR(common->thread_task);
+		goto error_release;
 	}
 	init_completion(&common->thread_notifier);
 	init_waitqueue_head(&common->fsg_wait);
@@ -2905,11 +2860,10 @@ buffhds_first_it:
 	}
 	kfree(pathbuf);
 
-	if (start_thread) {
-		DBG(common, "I/O thread pid: %d\n",
-		    task_pid_nr(common->thread_task));
-		wake_up_process(common->thread_task);
-	}
+	DBG(common, "I/O thread pid: %d\n", task_pid_nr(common->thread_task));
+
+	wake_up_process(common->thread_task);
+
 	return common;
 
 error_luns:
@@ -3200,6 +3154,6 @@ fsg_common_from_params(struct fsg_common *common,
 {
 	struct fsg_config cfg;
 	fsg_config_from_params(&cfg, params);
-	return fsg_common_init(common, cdev, &cfg, 1);
+	return fsg_common_init(common, cdev, &cfg);
 }
 
diff --git a/drivers/usb/gadget/f_uasp.c b/drivers/usb/gadget/f_uasp.c
index 3db5a11..f3d1efa 100644
--- a/drivers/usb/gadget/f_uasp.c
+++ b/drivers/usb/gadget/f_uasp.c
@@ -176,11 +176,9 @@
 #include <linux/kref.h>
 #include <linux/kthread.h>
 #include <linux/string.h>
-#include <linux/usb/ch9.h>
-#include <linux/usb/gadget.h>
-#include <linux/kernel.h>
 #include <linux/usb/storage.h>
 
+#include "f_uasp.h"
 #include "uasp_cmdiu.c"
 #include "uasp_tmiu.c"
 
@@ -201,20 +199,21 @@ uasp_intf_desc = {
 
 /* BULK-in pipe descriptors */
 static struct usb_endpoint_descriptor
-uasp_bulk_in_desc = {
+uasp_fs_bulk_in_desc = {
 	.bLength =		USB_DT_ENDPOINT_SIZE,
 	.bDescriptorType =	USB_DT_ENDPOINT,
 	.bEndpointAddress =	USB_DIR_IN,
 	.bmAttributes =		USB_ENDPOINT_XFER_BULK,
-	.wMaxPacketSize =	cpu_to_le16(512),
+	.wMaxPacketSize =	cpu_to_le16(64),
 };
 
-struct usb_pipe_usage_descriptor
-uasp_bulk_in_pipe_usg_desc = {
-	.bLength =		sizeof uasp_bulk_in_pipe_usg_desc,
-	.bDescriptorType =	USB_DT_PIPE_USAGE,
-	.bPipeID =		PIPE_ID_DATA_IN,
-	.Reserved =		0,
+static struct usb_endpoint_descriptor
+uasp_hs_bulk_in_desc = {
+	.bLength =		USB_DT_ENDPOINT_SIZE,
+	.bDescriptorType =	USB_DT_ENDPOINT,
+	.bEndpointAddress =	USB_DIR_IN,
+	.bmAttributes =		USB_ENDPOINT_XFER_BULK,
+	.wMaxPacketSize =	cpu_to_le16(512),
 };
 
 struct usb_endpoint_descriptor
@@ -238,22 +237,31 @@ uasp_bulk_in_ep_comp_desc = {
 	.wBytesPerInterval =	0,
 };
 
+struct usb_pipe_usage_descriptor
+uasp_bulk_in_pipe_usg_desc = {
+	.bLength =		sizeof uasp_bulk_in_pipe_usg_desc,
+	.bDescriptorType =	USB_DT_PIPE_USAGE,
+	.bPipeID =		PIPE_ID_DATA_IN,
+	.Reserved =		0,
+};
+
 /* BULK-out pipe descriptors */
 struct usb_endpoint_descriptor
-uasp_bulk_out_desc = {
+uasp_fs_bulk_out_desc = {
 	.bLength =		USB_DT_ENDPOINT_SIZE,
 	.bDescriptorType =	USB_DT_ENDPOINT,
 	.bEndpointAddress =	USB_DIR_OUT,
 	.bmAttributes =		USB_ENDPOINT_XFER_BULK,
-	.wMaxPacketSize =	cpu_to_le16(512),
+	.wMaxPacketSize =	cpu_to_le16(64),
 };
 
-struct usb_pipe_usage_descriptor
-uasp_bulk_out_pipe_usg_desc = {
-	.bLength =		sizeof uasp_bulk_out_pipe_usg_desc,
-	.bDescriptorType =	USB_DT_PIPE_USAGE,
-	.bPipeID =		PIPE_ID_DATA_OUT,
-	.Reserved =		0,
+struct usb_endpoint_descriptor
+uasp_hs_bulk_out_desc = {
+	.bLength =		USB_DT_ENDPOINT_SIZE,
+	.bDescriptorType =	USB_DT_ENDPOINT,
+	.bEndpointAddress =	USB_DIR_OUT,
+	.bmAttributes =		USB_ENDPOINT_XFER_BULK,
+	.wMaxPacketSize =	cpu_to_le16(512),
 };
 
 struct usb_endpoint_descriptor
@@ -277,22 +285,31 @@ uasp_bulk_out_ep_comp_desc = {
 	.wBytesPerInterval =	0,
 };
 
+struct usb_pipe_usage_descriptor
+uasp_bulk_out_pipe_usg_desc = {
+	.bLength =		sizeof uasp_bulk_out_pipe_usg_desc,
+	.bDescriptorType =	USB_DT_PIPE_USAGE,
+	.bPipeID =		PIPE_ID_DATA_OUT,
+	.Reserved =		0,
+};
+
 /* Status pipe - descriptors */
 struct usb_endpoint_descriptor
-uasp_status_in_desc = {
+uasp_fs_status_in_desc = {
 	.bLength =		USB_DT_ENDPOINT_SIZE,
 	.bDescriptorType =	USB_DT_ENDPOINT,
 	.bEndpointAddress =	USB_DIR_IN,
 	.bmAttributes =		USB_ENDPOINT_XFER_BULK,
-	.wMaxPacketSize =	cpu_to_le16(512),
+	.wMaxPacketSize =	cpu_to_le16(64),
 };
 
-struct usb_pipe_usage_descriptor
-uasp_status_in_pipe_usg_desc = {
-	.bLength =		sizeof uasp_status_in_pipe_usg_desc,
-	.bDescriptorType =	USB_DT_PIPE_USAGE,
-	.bPipeID =		PIPE_ID_STS,
-	.Reserved =		0,
+struct usb_endpoint_descriptor
+uasp_hs_status_in_desc = {
+	.bLength =		USB_DT_ENDPOINT_SIZE,
+	.bDescriptorType =	USB_DT_ENDPOINT,
+	.bEndpointAddress =	USB_DIR_IN,
+	.bmAttributes =		USB_ENDPOINT_XFER_BULK,
+	.wMaxPacketSize =	cpu_to_le16(512),
 };
 
 struct usb_endpoint_descriptor
@@ -316,22 +333,32 @@ uasp_status_in_ep_comp_desc = {
 	.wBytesPerInterval =	0,
 };
 
+
+struct usb_pipe_usage_descriptor
+uasp_status_in_pipe_usg_desc = {
+	.bLength =		sizeof uasp_status_in_pipe_usg_desc,
+	.bDescriptorType =	USB_DT_PIPE_USAGE,
+	.bPipeID =		PIPE_ID_STS,
+	.Reserved =		0,
+};
+
 /* Command pipe descriptors */
 struct usb_endpoint_descriptor
-uasp_command_out_desc = {
+uasp_fs_command_out_desc = {
 	.bLength =		USB_DT_ENDPOINT_SIZE,
 	.bDescriptorType =	USB_DT_ENDPOINT,
 	.bEndpointAddress =	USB_DIR_OUT,
 	.bmAttributes =		USB_ENDPOINT_XFER_BULK,
-	.wMaxPacketSize =	cpu_to_le16(512),
+	.wMaxPacketSize =	cpu_to_le16(64),
 };
 
-struct usb_pipe_usage_descriptor
-uasp_command_out_pipe_usg_desc = {
-	.bLength =		sizeof uasp_command_out_pipe_usg_desc,
-	.bDescriptorType =	USB_DT_PIPE_USAGE,
-	.bPipeID =		PIPE_ID_CMD,
-	.Reserved =		0,
+struct usb_endpoint_descriptor
+uasp_hs_command_out_desc = {
+	.bLength =		USB_DT_ENDPOINT_SIZE,
+	.bDescriptorType =	USB_DT_ENDPOINT,
+	.bEndpointAddress =	USB_DIR_OUT,
+	.bmAttributes =		USB_ENDPOINT_XFER_BULK,
+	.wMaxPacketSize =	cpu_to_le16(512),
 };
 
 struct usb_endpoint_descriptor
@@ -355,16 +382,38 @@ uasp_command_out_ep_comp_desc = {
 	.wBytesPerInterval =	0,
 };
 
+struct usb_pipe_usage_descriptor
+uasp_command_out_pipe_usg_desc = {
+	.bLength =		sizeof uasp_command_out_pipe_usg_desc,
+	.bDescriptorType =	USB_DT_PIPE_USAGE,
+	.bPipeID =		PIPE_ID_CMD,
+	.Reserved =		0,
+};
+
+/* FS configuration function descriptors */
+struct usb_descriptor_header *uasp_fs_function_desc[] = {
+	(struct usb_descriptor_header *) &uasp_intf_desc,
+	(struct usb_descriptor_header *) &uasp_fs_bulk_in_desc,
+	(struct usb_descriptor_header *) &uasp_bulk_in_pipe_usg_desc,
+	(struct usb_descriptor_header *) &uasp_fs_bulk_out_desc,
+	(struct usb_descriptor_header *) &uasp_bulk_out_pipe_usg_desc,
+	(struct usb_descriptor_header *) &uasp_fs_status_in_desc,
+	(struct usb_descriptor_header *) &uasp_status_in_pipe_usg_desc,
+	(struct usb_descriptor_header *) &uasp_fs_command_out_desc,
+	(struct usb_descriptor_header *) &uasp_command_out_pipe_usg_desc,
+	NULL,
+};
+
 /* HS configuration function descriptors */
 struct usb_descriptor_header *uasp_hs_function_desc[] = {
 	(struct usb_descriptor_header *) &uasp_intf_desc,
-	(struct usb_descriptor_header *) &uasp_bulk_in_desc,
+	(struct usb_descriptor_header *) &uasp_hs_bulk_in_desc,
 	(struct usb_descriptor_header *) &uasp_bulk_in_pipe_usg_desc,
-	(struct usb_descriptor_header *) &uasp_bulk_out_desc,
+	(struct usb_descriptor_header *) &uasp_hs_bulk_out_desc,
 	(struct usb_descriptor_header *) &uasp_bulk_out_pipe_usg_desc,
-	(struct usb_descriptor_header *) &uasp_status_in_desc,
+	(struct usb_descriptor_header *) &uasp_hs_status_in_desc,
 	(struct usb_descriptor_header *) &uasp_status_in_pipe_usg_desc,
-	(struct usb_descriptor_header *) &uasp_command_out_desc,
+	(struct usb_descriptor_header *) &uasp_hs_command_out_desc,
 	(struct usb_descriptor_header *) &uasp_command_out_pipe_usg_desc,
 	NULL,
 };
@@ -388,35 +437,61 @@ struct usb_descriptor_header *uasp_ss_function_desc[] = {
 };
 
 /*--------------------------------------------------------------------------*/
+static int uasp_exception_in_progress(struct uasp_common *common)
+{
+	return common->state > UASP_STATE_IDLE;
+}
+
+/* Caller must hold udev->lock */
+static void uasp_wakeup_thread(struct uasp_common *common)
+{
+	/* Tell the main thread that something has happened */
+	common->thread_wakeup_needed = 1;
+	if (common->thread_task)
+		wake_up_process(common->thread_task);
+}
+
 static inline struct uasp_dev *uaspd_from_func(struct usb_function *f)
 {
-	struct fsg_dev		*fsg_dev = fsg_from_func(f);
-	return container_of(fsg_dev, struct uasp_dev, fsg_dev);
+	return container_of(f, struct uasp_dev, function);
+}
+
+static void uasp_raise_exception(struct uasp_common *common,
+				 enum fsg_state new_state)
+{
+	unsigned long		flags;
+
+	/*
+	 * Do nothing if a higher-priority exception is already in progress.
+	 * If a lower-or-equal priority exception is in progress, preempt it
+	 * and notify the main thread by sending it a signal.
+	 */
+	spin_lock_irqsave(&common->lock, flags);
+	if (common->state <= new_state) {
+		common->state = new_state;
+		if (common->thread_task)
+			send_sig_info(SIGUSR1, SEND_SIG_FORCED,
+				      common->thread_task);
+	}
+	spin_unlock_irqrestore(&common->lock, flags);
 }
 
 static void uasp_common_release(struct kref *ref)
 {
 	struct uasp_common *ucommon =
 		container_of(ref, struct uasp_common, ref);
-	struct uasp_lun *ulun;
-	int i;
 
-	/* First stop all lun threads */
-	run_lun_threads(ucommon->udev, LUN_STATE_EXIT);
-	for (i = 0; i < ucommon->common->nluns; i++) {
-		ulun = &(ucommon->uluns[i]);
-		if (ulun->lun_state != LUN_STATE_TERMINATED) {
-			wait_for_completion(&ulun->thread_notifier);
-			/* The cleanup routine waits for this completion also */
-			complete(&ulun->thread_notifier);
-		}
+	/* If the thread isn't already dead, tell it to exit now */
+	if (ucommon->state != UASP_STATE_TERMINATED) {
+		uasp_raise_exception(ucommon, FSG_STATE_EXIT);
+		wait_for_completion(&ucommon->thread_notifier);
 	}
-	fsg_common_release(&(ucommon->common->ref));
+
 	kfree(ucommon->uluns);
+	kfree(ucommon->ubufs);
 	kfree(ucommon);
 }
 
-
 static inline void uasp_common_put(struct uasp_common *common)
 {
 	kref_put(&(common->ref), uasp_common_release);
@@ -427,23 +502,48 @@ static struct uasp_lun *find_lun_by_id(struct uasp_dev *udev, __u8 *lun_id)
 	int i;
 	struct uasp_lun *curlun;
 
-	DBG(udev->ucommon->common, "%s() - Enter.\n", __func__);
+	DBG(udev->ucommon, "%s() - Enter.\n", __func__);
 
-	for (i = 0; i < udev->ucommon->common->nluns; ++i) {
+	for (i = 0; i < udev->ucommon->nluns; ++i) {
 		curlun = &udev->ucommon->uluns[i];
 
 		if (memcmp(lun_id, curlun->lun_id, 8) == 0) {
-			DBG(udev->ucommon->common, "%s() - LUN found\n",
+			DBG(udev->ucommon, "%s() - LUN found\n",
 			    __func__);
 			return curlun;
 		}
 	}
-	DBG(udev->ucommon->common, "%s() - LUN not found\n", __func__);
+	DBG(udev->ucommon, "%s() - LUN not found\n", __func__);
 	return 0;
 }
 
 /**
- * wakeup_lun_thread() - Wakes up the given LUn thread
+ * uasp_sleep_thread() - sleep UASP main thread
+ * @common: pointer to uasp common data structure
+ */
+int uasp_sleep_thread(struct uasp_common *common)
+{
+	int	rc = 0;
+
+	/* Wait until a signal arrives or we are woken up */
+	for (;;) {
+		try_to_freeze();
+		set_current_state(TASK_INTERRUPTIBLE);
+		if (signal_pending(current)) {
+			rc = -EINTR;
+			break;
+		}
+		if (common->thread_wakeup_needed)
+			break;
+		schedule();
+	}
+	__set_current_state(TASK_RUNNING);
+	common->thread_wakeup_needed = 0;
+	return rc;
+}
+
+/**
+ * wakeup_lun_thread() - Wakes up the given LUN thread
  * @lun: the LUN which thread needs wakening
  *
  * NOTE: Caller must hold uasp_lun->lock
@@ -472,31 +572,31 @@ static void command_complete(struct usb_ep *ep, struct usb_request *req)
 	unsigned long flags;
 
 	if (req->actual > 0)
-		dump_msg(udev->ucommon->common, "command", req->buf,
+		dump_msg(udev->ucommon, "command", req->buf,
 			 req->actual);
-	DBG(udev->ucommon->common, "%s() - Enter", __func__);
+	DBG(udev->ucommon, "%s() - Enter", __func__);
 
 	if (req != udev->cmd_buff.outreq) {
-		ERROR(udev->ucommon->common, "(%s) req(%p) != "
+		ERROR(udev->ucommon, "(%s) req(%p) != "
 					     "cmd_buff.outreq(%p), udev=%p,"
 					     " common->state = %d\n",
 		      __func__, req, udev->cmd_buff.outreq, udev,
-		      udev->ucommon->common->state);
+		      udev->ucommon->state);
 	}
 
 	if (req->status == -ECONNRESET) {
-		spin_lock_irqsave(&(udev->ucommon->common->lock), flags);
+		spin_lock_irqsave(&(udev->ucommon->lock), flags);
 		udev->cmd_buff.state = BUF_STATE_EMPTY;
-		spin_unlock_irqrestore(&(udev->ucommon->common->lock), flags);
+		spin_unlock_irqrestore(&(udev->ucommon->lock), flags);
 
 		usb_ep_fifo_flush(ep);
 		return;
 	}
 
-	spin_lock_irqsave(&(udev->ucommon->common->lock), flags);
+	spin_lock_irqsave(&(udev->ucommon->lock), flags);
 	udev->cmd_buff.state = BUF_STATE_FULL;
-	wakeup_thread(udev->ucommon->common);
-	spin_unlock_irqrestore(&(udev->ucommon->common->lock), flags);
+	uasp_wakeup_thread(udev->ucommon);
+	spin_unlock_irqrestore(&(udev->ucommon->lock), flags);
 }
 
 /**
@@ -520,12 +620,12 @@ void status_complete(struct usb_ep *ep, struct usb_request *req)
 	uint8_t cmd_id = ((uint8_t *)req->context)[0];
 	unsigned long flags;
 
-	DBG(udev->ucommon->common, "%s() - Enter", __func__);
+	DBG(udev->ucommon, "%s() - Enter", __func__);
 
 	if (req->status == -ECONNRESET)
 		usb_ep_fifo_flush(ep);
 
-	spin_lock_irqsave(&(udev->ucommon->common->lock), flags);
+	spin_lock_irqsave(&(udev->ucommon->lock), flags);
 	/* If Sense IU is filled for TM FUNCTION IU */
 	if (cmd_id == IU_ID_TASK_MANAGEMENT) {
 		tmiu = (struct tm_iu *)req->context;
@@ -534,14 +634,14 @@ void status_complete(struct usb_ep *ep, struct usb_request *req)
 			if (req->status == -ERESTART)
 				tmiu->state = COMMAND_STATE_ABORTED;
 			else if (req->status) {
-				DBG(udev->ucommon->common,
+				DBG(udev->ucommon,
 				    "%s() - TMIU FAILED!!! Status = %d",
 				    __func__, req->status);
 				tmiu->state = COMMAND_STATE_FAILED;
 			} else
 				tmiu->state = COMMAND_STATE_COMPLETED;
 		}
-		DBG(udev->ucommon->common,
+		DBG(udev->ucommon,
 		    "%s() - received IU_ID_TASK_MANAGEMENT "
 		    "(Code = %02x tmiu->state = %d)\n",
 		    __func__, tmiu->tm_function, tmiu->state);
@@ -556,14 +656,14 @@ void status_complete(struct usb_ep *ep, struct usb_request *req)
 			if (req->status == -ERESTART)
 				cmdiu->state = COMMAND_STATE_ABORTED;
 			else if (req->status) {
-				DBG(udev->ucommon->common,
+				DBG(udev->ucommon,
 				    "%s() - CMDIU FAILED!!! Status = %d",
 				    __func__, req->status);
 				cmdiu->state = COMMAND_STATE_FAILED;
 			} else if (cmdiu->state == COMMAND_STATE_STATUS)
 					cmdiu->state = COMMAND_STATE_COMPLETED;
 		}
-		DBG(udev->ucommon->common, "%s() - received IU_ID_COMMAND"
+		DBG(udev->ucommon, "%s() - received IU_ID_COMMAND"
 					" (OpCode = %02x, smdiu->state = %d)\n",
 		    __func__, cmdiu->cdb[0], cmdiu->state);
 		cmdiu->req_sts = CMD_REQ_COMPLETED;
@@ -571,29 +671,29 @@ void status_complete(struct usb_ep *ep, struct usb_request *req)
 
 		curlun = find_lun_by_id(udev, cmdiu->lun);
 	} else {
-		ERROR(udev->ucommon->common,
+		ERROR(udev->ucommon,
 		      "%s() - received invalid IU (iu_id = %02x)!\n",
 		      __func__, cmd_id);
-		spin_unlock_irqrestore(&(udev->ucommon->common->lock), flags);
+		spin_unlock_irqrestore(&(udev->ucommon->lock), flags);
 		return;
 	}
 
 	if (curlun) {
-		spin_unlock_irqrestore(&(udev->ucommon->common->lock),
+		spin_unlock_irqrestore(&(udev->ucommon->lock),
 				       flags);
 		spin_lock_irqsave(&(curlun->lock), flags);
 		curlun->pending_requests++;
 		curlun->active_requests--;
 		wakeup_lun_thread(curlun);
 		spin_unlock_irqrestore(&(curlun->lock), flags);
-		spin_lock_irqsave(&(udev->ucommon->common->lock),
+		spin_lock_irqsave(&(udev->ucommon->lock),
 				  flags);
 	} else {
 		udev->pending_requests++;
 		udev->active_requests--;
-		wakeup_thread(udev->ucommon->common);
+		uasp_wakeup_thread(udev->ucommon);
 	}
-	spin_unlock_irqrestore(&(udev->ucommon->common->lock), flags);
+	spin_unlock_irqrestore(&(udev->ucommon->lock), flags);
 }
 
 /**
@@ -613,14 +713,14 @@ void uasp_bulk_in_complete(struct usb_ep *ep, struct usb_request *req)
 	struct cmd_iu *cmdiu;
 	unsigned long flags;
 
-	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+	DBG(udev->ucommon, "%s() - Enter\n", __func__);
 
 	if (req->status == -ECONNRESET)
 		usb_ep_fifo_flush(ep);
 
 	cmdiu = (struct cmd_iu *)req->context;
 
-	spin_lock_irqsave(&(udev->ucommon->common->lock), flags);
+	spin_lock_irqsave(&(udev->ucommon->lock), flags);
 	if (cmdiu->state != COMMAND_STATE_ABORTED &&
 	    cmdiu->state != COMMAND_STATE_FAILED) {
 		if (req->status == -ERESTART)
@@ -635,19 +735,19 @@ void uasp_bulk_in_complete(struct usb_ep *ep, struct usb_request *req)
 
 	curlun = find_lun_by_id(udev, cmdiu->lun);
 	if (curlun) {
-		spin_unlock_irqrestore(&udev->ucommon->common->lock, flags);
+		spin_unlock_irqrestore(&udev->ucommon->lock, flags);
 		spin_lock_irqsave(&curlun->lock, flags);
 		curlun->pending_requests++;
 		curlun->active_requests--;
 		wakeup_lun_thread(curlun);
 		spin_unlock_irqrestore(&curlun->lock, flags);
-		spin_lock_irqsave(&(udev->ucommon->common->lock), flags);
+		spin_lock_irqsave(&(udev->ucommon->lock), flags);
 	} else {
 		udev->pending_requests++;
 		udev->active_requests--;
-		wakeup_thread(udev->ucommon->common);
+		uasp_wakeup_thread(udev->ucommon);
 	}
-	spin_unlock_irqrestore(&udev->ucommon->common->lock, flags);
+	spin_unlock_irqrestore(&udev->ucommon->lock, flags);
 }
 
 
@@ -668,12 +768,12 @@ void uasp_bulk_out_complete(struct usb_ep *ep, struct usb_request *req)
 	struct cmd_iu *cmdiu;
 	unsigned long flags;
 
-	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+	DBG(udev->ucommon, "%s() - Enter\n", __func__);
 
 	if (req->status == -ECONNRESET)
 		usb_ep_fifo_flush(ep);
 
-	spin_lock_irqsave(&udev->ucommon->common->lock, flags);
+	spin_lock_irqsave(&udev->ucommon->lock, flags);
 	cmdiu = (struct cmd_iu *)req->context;
 
 	if (cmdiu->state != COMMAND_STATE_ABORTED &&
@@ -689,19 +789,19 @@ void uasp_bulk_out_complete(struct usb_ep *ep, struct usb_request *req)
 
 	curlun = find_lun_by_id(udev, cmdiu->lun);
 	if (curlun) {
-		spin_unlock_irqrestore(&udev->ucommon->common->lock, flags);
+		spin_unlock_irqrestore(&udev->ucommon->lock, flags);
 		spin_lock_irqsave(&curlun->lock, flags);
 		curlun->pending_requests++;
 		curlun->active_requests--;
 		wakeup_lun_thread(curlun);
 		spin_unlock_irqrestore(&curlun->lock, flags);
-		spin_lock_irqsave(&udev->ucommon->common->lock, flags);
+		spin_lock_irqsave(&udev->ucommon->lock, flags);
 	} else {
 		udev->pending_requests++;
 		udev->active_requests--;
-		wakeup_thread(udev->ucommon->common);
+		uasp_wakeup_thread(udev->ucommon);
 	}
-	spin_unlock_irqrestore(&udev->ucommon->common->lock, flags);
+	spin_unlock_irqrestore(&udev->ucommon->lock, flags);
 }
 
 /**
@@ -722,11 +822,11 @@ static void remove_completed_commands(struct uasp_dev *udev,
 	struct tm_iu *tmiu;
 	struct tm_iu *tmp_tmiu;
 
-	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+	DBG(udev->ucommon, "%s() - Enter\n", __func__);
 
 	/* Remove completed, aborted or failed commands from cmd_queue */
 	list_for_each_entry_safe(cmdiu, tmp_cmdiu, cmd_queue, node) {
-		DBG(udev->ucommon->common, "%s() - cmd_queue cycle"
+		DBG(udev->ucommon, "%s() - cmd_queue cycle"
 					   " cmdiu->state=%d "
 					   " cmdiu->req_sts=%d\n",
 		     __func__, cmdiu->state, cmdiu->req_sts);
@@ -757,13 +857,13 @@ static void remove_completed_commands(struct uasp_dev *udev,
 			if (cmdiu->req_sts == CMD_REQ_IN_PROGRESS)
 				continue;
 		}
-		DBG(udev->ucommon->common, "%s() - deleted cmdiu: "
+		DBG(udev->ucommon, "%s() - deleted cmdiu: "
 				   "cmdiu[0] = %d, cmdiu->state = %d,"
 				   "cmdiu->tag = %d\n",
 		     __func__, cmdiu->cdb[0], cmdiu->state, cmdiu->tag);
 		list_del(&cmdiu->node);
 		if (cmdiu->bh) {
-			DBG(udev->ucommon->common, "%s() - Freeing the "
+			DBG(udev->ucommon, "%s() - Freeing the "
 						   "cmdiu->bh\n", __func__);
 			cmdiu->bh->state = BUF_STATE_EMPTY;
 		}
@@ -778,19 +878,19 @@ static void remove_completed_commands(struct uasp_dev *udev,
 		    tmiu->state != COMMAND_STATE_FAILED)
 			continue;
 
-		DBG(udev->ucommon->common, "%s() - deleted tmiu\n",  __func__);
+		DBG(udev->ucommon, "%s() - deleted tmiu\n",  __func__);
 		list_del(&tmiu->node);
 		if (tmiu->bh) {
-			DBG(udev->ucommon->common, "%s() - Freeing the "
+			DBG(udev->ucommon, "%s() - Freeing the "
 						   "tmiu->bh\n", __func__);
 			tmiu->bh->state = BUF_STATE_EMPTY;
 		}
 		kfree(tmiu);
 	}
 	if (list_empty(cmd_queue) && list_empty(tm_func_queue))
-		DBG(udev->ucommon->common, "%s() - both lists are empty\n",
+		DBG(udev->ucommon, "%s() - both lists are empty\n",
 		    __func__);
-	DBG(udev->ucommon->common, "%s() - exit\n", __func__);
+	DBG(udev->ucommon, "%s() - exit\n", __func__);
 }
 
 /**
@@ -802,40 +902,36 @@ static void remove_completed_commands(struct uasp_dev *udev,
  *
  * Initiates all endpoints and enables them. Allocates buffers and requests.
  */
-static int do_uasp_set_interface(struct uasp_dev *uaspd,
-				 struct fsg_dev *new_fsg)
+static int do_uasp_set_interface(struct uasp_common *ucommon,
+				 struct uasp_dev *new_uaspd)
 {
 	int rc = 0;
 	int i;
-	struct fsg_dev	*fsgd;
-	struct fsg_common *fcommon;
 	unsigned long flags;
+	struct uasp_dev *udev = ucommon->udev;
 
-	if (!uaspd || !uaspd->ucommon || !uaspd->ucommon->common)
+	if (!ucommon)
 		return -EIO;
 
-	DBG(uaspd->ucommon->common, "%s()- Enter\n", __func__);
+	DBG(ucommon, "%s()- Enter\n", __func__);
 
-	fcommon = uaspd->ucommon->common;
-	if (uaspd->ucommon->common->running)
-		DBG(uaspd->ucommon->common, "reset inteface\n");
+	if (ucommon->running)
+		DBG(ucommon, "reset inteface\n");
 
 reset_uasp:
 	/* Deallocate the requests */
-	if (uaspd->ucommon->common->fsg) {
-		fsgd = fcommon->fsg;
-
-		abort_commands(uaspd, &uaspd->cmd_queue, &uaspd->tm_func_queue,
-		       &(uaspd->ucommon->common->lock));
-		remove_completed_commands(uaspd, &uaspd->cmd_queue,
-				   &uaspd->tm_func_queue);
-		uaspd->pending_requests = 0;
-
-		for (i = 0; i < uaspd->ucommon->common->nluns; i++) {
-			struct uasp_lun *ulun = &uaspd->ucommon->uluns[i];
-			abort_commands(uaspd, &ulun->cmd_queue,
+	if (ucommon->udev) {
+		abort_commands(udev, &udev->cmd_queue,
+			       &udev->tm_func_queue, &(udev->ucommon->lock));
+		remove_completed_commands(udev, &udev->cmd_queue,
+					  &udev->tm_func_queue);
+		udev->pending_requests = 0;
+
+		for (i = 0; i < ucommon->nluns; i++) {
+			struct uasp_lun *ulun = &ucommon->uluns[i];
+			abort_commands(udev, &ulun->cmd_queue,
 				       &ulun->tm_func_queue, &(ulun->lock));
-			remove_completed_commands(uaspd, &ulun->cmd_queue,
+			remove_completed_commands(udev, &ulun->cmd_queue,
 					   &ulun->tm_func_queue);
 			spin_lock_irqsave(&(ulun->lock), flags);
 			ulun->pending_requests = 0;
@@ -847,130 +943,142 @@ reset_uasp:
 			spin_unlock_irq(&(ulun->lock));
 		}
 		/* Clear out the controller's fifos */
-		if (fcommon->fsg->bulk_in_enabled)
-			usb_ep_fifo_flush(fcommon->fsg->bulk_in);
-		if (fcommon->fsg->bulk_out_enabled)
-			usb_ep_fifo_flush(fcommon->fsg->bulk_out);
-		usb_ep_fifo_flush(uaspd->ucommon->udev->status);
-		usb_ep_fifo_flush(uaspd->ucommon->udev->command);
-
-		spin_lock_irq(&fcommon->lock);
+		if (udev->bulk_in_enabled)
+			usb_ep_fifo_flush(udev->bulk_in);
+		if (udev->bulk_out_enabled)
+			usb_ep_fifo_flush(udev->bulk_out);
+		usb_ep_fifo_flush(udev->status);
+		usb_ep_fifo_flush(udev->command);
+
+		spin_lock_irq(&ucommon->lock);
 		/* Reset the I/O buffer states and pointers */
 		for (i = 0; i < fsg_num_buffers; ++i) {
-			struct fsg_buffhd *bh = &fcommon->buffhds[i];
+			struct fsg_buffhd *bh =
+				ucommon->ubufs[i].fsg_buff;
 			if (bh->inreq) {
-				usb_ep_free_request(fsgd->bulk_in, bh->inreq);
+				usb_ep_free_request(udev->bulk_in, bh->inreq);
 				bh->inreq = NULL;
 			}
 			if (bh->outreq) {
-				usb_ep_free_request(fsgd->bulk_out, bh->outreq);
+				usb_ep_free_request(udev->bulk_out, bh->outreq);
 				bh->outreq = NULL;
 			}
 			bh->state = BUF_STATE_EMPTY;
 		}
-
+		spin_unlock_irq(&ucommon->lock);
 		/* Deallocate command and status requests */
-		if (uaspd->cmd_buff.inreq) {
-			ERROR(uaspd->ucommon->common,
+		if (udev->cmd_buff.inreq) {
+			ERROR(ucommon,
 			      "%s(): uaspd->cmd_buff.inreq isn't NULL. "
 			      "How can that be???",
 			      __func__);
-			usb_ep_free_request(uaspd->command,
-					    uaspd->cmd_buff.inreq);
-			uaspd->cmd_buff.inreq = NULL;
+			usb_ep_free_request(udev->command,
+					    udev->cmd_buff.inreq);
+			udev->cmd_buff.inreq = NULL;
 		}
-		if (uaspd->cmd_buff.outreq) {
-			usb_ep_free_request(uaspd->command,
-					    uaspd->cmd_buff.outreq);
-			uaspd->cmd_buff.outreq = NULL;
+		if (udev->cmd_buff.outreq) {
+			(void)usb_ep_dequeue(udev->command,
+					     udev->cmd_buff.outreq);
+			usb_ep_free_request(udev->command,
+					    udev->cmd_buff.outreq);
+			udev->cmd_buff.outreq = NULL;
 		}
-		uaspd->cmd_buff.state = BUF_STATE_EMPTY;
-		spin_unlock_irq(&fcommon->lock);
+		udev->cmd_buff.state = BUF_STATE_EMPTY;
 
 		/* Disable the endpoints */
-		if (fsgd->bulk_in_enabled) {
-			usb_ep_disable(fsgd->bulk_in);
-			fsgd->bulk_in_enabled = 0;
+		if (udev->bulk_in_enabled) {
+			usb_ep_disable(udev->bulk_in);
+			udev->bulk_in_enabled = 0;
 		}
-		if (fsgd->bulk_out_enabled) {
-			usb_ep_disable(fsgd->bulk_out);
-			fsgd->bulk_out_enabled = 0;
+		if (udev->bulk_out_enabled) {
+			usb_ep_disable(udev->bulk_out);
+			udev->bulk_out_enabled = 0;
 		}
-		fsgd->bulk_in->desc = NULL;
-		fsgd->bulk_out->desc = NULL;
+		udev->bulk_in->desc = NULL;
+		udev->bulk_out->desc = NULL;
 
-		if (uaspd->cmd_enabled) {
-			usb_ep_disable(uaspd->command);
-			uaspd->cmd_enabled = 0;
+		if (udev->cmd_enabled) {
+			usb_ep_disable(udev->command);
+			udev->cmd_enabled = 0;
 		}
-		if (uaspd->status_enabled) {
-			usb_ep_disable(uaspd->status);
-			uaspd->status_enabled = 0;
+		if (udev->status_enabled) {
+			usb_ep_disable(udev->status);
+			udev->status_enabled = 0;
 		}
-		uaspd->command->desc = NULL;
-		uaspd->status->desc = NULL;
-		DBG(uaspd->ucommon->common, "%s()- disabled endpoints\n",
+		udev->command->desc = NULL;
+		udev->status->desc = NULL;
+		DBG(ucommon,
+		    "%s()- disabled endpoints, releasing config mutex\n",
 		    __func__);
-
-		fcommon->fsg = NULL;
-		wake_up(&fcommon->fsg_wait);
+		mutex_unlock(ucommon->config_mutex);
+		ucommon->udev = NULL;
+		wake_up(&ucommon->uasp_wait);
 	}
 
-	fcommon->running = 0;
-	if (!new_fsg || rc)
+	ucommon->running = 0;
+	if (!new_uaspd || rc) {
+		udev->op_mode = UASP_MODE_UNSET;
 		return rc;
+	}
+	DBG(ucommon, "%s()- Enabling endpoints, taking config mutex\n",
+	    __func__);
+	mutex_lock(ucommon->config_mutex);
+	ucommon->udev = new_uaspd;
+	udev = ucommon->udev;
+	if (!udev->op_mode) {
+		if (udev->forced_hs_mode)
+			udev->op_mode = HS_UASP_MODE;
+		else
+			udev->op_mode =
+				(ucommon->gadget->speed == USB_SPEED_SUPER ?
+				 SS_UASP_MODE : HS_UASP_MODE);
+	}
 
-	fcommon->fsg = new_fsg;
-	fsgd = fcommon->fsg;
-	uaspd->op_mode = (fcommon->gadget->speed == USB_SPEED_SUPER ?
-			  SS_UASP_MODE : HS_UASP_MODE);
-
-	/* Enable the endpoints */
-	config_ep_by_speed(fcommon->gadget, &fsgd->function, fsgd->bulk_in);
-	rc = usb_ep_enable(fsgd->bulk_in);
+	config_ep_by_speed(ucommon->gadget, &udev->function, udev->bulk_in);
+	rc = usb_ep_enable(udev->bulk_in);
 	if (rc)
 		goto reset_uasp;
-	fsgd->bulk_in->driver_data = uaspd;
-	fsgd->bulk_in_enabled = 1;
+	udev->bulk_in->driver_data = udev;
+	udev->bulk_in_enabled = 1;
 
-	config_ep_by_speed(fsgd->common->gadget, &fsgd->function,
-			   fsgd->bulk_out);
-	rc = usb_ep_enable(fsgd->bulk_out);
+	config_ep_by_speed(ucommon->gadget, &udev->function,
+			   udev->bulk_out);
+	rc = usb_ep_enable(udev->bulk_out);
 	if (rc)
 		goto reset_uasp;
-	fsgd->bulk_out->driver_data = uaspd;
-	fsgd->bulk_out_enabled = 1;
+	udev->bulk_out->driver_data = udev;
+	udev->bulk_out_enabled = 1;
 
-	fsgd->common->bulk_out_maxpacket =
-		le16_to_cpu(fsgd->bulk_out->maxpacket);
-	clear_bit(IGNORE_BULK_OUT, &fsgd->atomic_bitflags);
+	/*ucommon->bulk_out_maxpacket =
+		le16_to_cpu(udev->bulk_out->maxpacket);
+	clear_bit(IGNORE_BULK_OUT, &fsgd->atomic_bitflags);*/
 
-	config_ep_by_speed(fsgd->common->gadget, &fsgd->function,
-			   uaspd->command);
-	rc = usb_ep_enable(uaspd->command);
+	config_ep_by_speed(ucommon->gadget, &udev->function,
+			   udev->command);
+	rc = usb_ep_enable(udev->command);
 	if (rc)
 		goto reset_uasp;
-	uaspd->command->driver_data = uaspd;
-	uaspd->cmd_enabled = 1;
+	udev->command->driver_data = udev;
+	udev->cmd_enabled = 1;
 
-	config_ep_by_speed(fsgd->common->gadget, &fsgd->function,
-			   uaspd->status);
-	rc = usb_ep_enable(uaspd->status);
+	config_ep_by_speed(ucommon->gadget, &udev->function,
+			   udev->status);
+	rc = usb_ep_enable(udev->status);
 	if (rc)
 		goto reset_uasp;
-	uaspd->status->driver_data = uaspd;
-	uaspd->status_enabled = 1;
+	udev->status->driver_data = udev;
+	udev->status_enabled = 1;
 
 	/* Allocate the data - requests */
 	for (i = 0; i < fsg_num_buffers; ++i) {
-		struct uasp_buff	*buff = &uaspd->ucommon->ubufs[i];
+		struct uasp_buff	*buff = &ucommon->ubufs[i];
 
-		buff->fsg_buff->inreq = usb_ep_alloc_request(fsgd->bulk_in,
+		buff->fsg_buff->inreq = usb_ep_alloc_request(udev->bulk_in,
 							     GFP_ATOMIC);
 		if (!buff->fsg_buff->inreq)
 			goto reset_uasp;
 
-		buff->fsg_buff->outreq = usb_ep_alloc_request(fsgd->bulk_out,
+		buff->fsg_buff->outreq = usb_ep_alloc_request(udev->bulk_out,
 							     GFP_ATOMIC);
 		if (!buff->fsg_buff->outreq)
 			goto reset_uasp;
@@ -984,24 +1092,24 @@ reset_uasp:
 	}
 
 	/* Allocate command ep request */
-	uaspd->cmd_buff.outreq = usb_ep_alloc_request(uaspd->command,
+	udev->cmd_buff.outreq = usb_ep_alloc_request(udev->command,
 							     GFP_ATOMIC);
-	if (!uaspd->cmd_buff.outreq) {
-		ERROR(uaspd->ucommon->common, "failed allocating outreq for "
+	if (!udev->cmd_buff.outreq) {
+		ERROR(ucommon, "failed allocating outreq for "
 					     "command buffer\n");
 		goto reset_uasp;
 	}
 
-	DBG(uaspd->ucommon->common, "%s() Enebled endpoints. "
+	DBG(ucommon, "%s() Enebled endpoints. "
 				    "Opperation mode = %d\n", __func__,
-				uaspd->op_mode);
-	uaspd->cmd_buff.outreq->buf = &(uaspd->cmd_buff.buf);
-	uaspd->cmd_buff.inreq = NULL;
-	uaspd->cmd_buff.state = BUF_STATE_EMPTY;
-
-	fcommon->running = 1;
-	for (i = 0; i < fsgd->common->nluns; ++i)
-		fsgd->common->luns[i].unit_attention_data = SS_RESET_OCCURRED;
+				udev->op_mode);
+	udev->cmd_buff.outreq->buf = &(udev->cmd_buff.buf);
+	udev->cmd_buff.inreq = NULL;
+	udev->cmd_buff.state = BUF_STATE_EMPTY;
+
+	ucommon->running = 1;
+	for (i = 0; i < ucommon->nluns; ++i)
+		ucommon->uluns[i].lun->unit_attention_data = SS_RESET_OCCURRED;
 	return 0;
 }
 
@@ -1011,12 +1119,10 @@ static void handle_uasp_exception(struct uasp_common *ucommon)
 	int			sig;
 	int			i;
 	struct fsg_buffhd	*bh;
-	enum fsg_state		old_state;
+	enum uasp_state		old_state;
 	int			rc;
 
-	struct fsg_common *fcommon = ucommon->common;
-
-	DBG(ucommon->common, "%s()- Enter\n", __func__);
+	DBG(ucommon, "%s()- Enter\n", __func__);
 
 	/*
 	 * Clear the existing signals.  Anything but SIGUSR1 is converted
@@ -1027,9 +1133,9 @@ static void handle_uasp_exception(struct uasp_common *ucommon)
 		if (!sig)
 			break;
 		if (sig != SIGUSR1) {
-			if (fcommon->state < FSG_STATE_EXIT)
-				DBG(fcommon, "Main thread exiting on signal\n");
-			fcommon->state = FSG_STATE_EXIT;
+			if (ucommon->state < UASP_STATE_EXIT)
+				DBG(ucommon, "Main thread exiting on signal\n");
+			ucommon->state = UASP_STATE_EXIT;
 		}
 	}
 
@@ -1037,51 +1143,42 @@ static void handle_uasp_exception(struct uasp_common *ucommon)
 	 * Reset the I/O buffer states and pointers, the SCSI  state, and the
 	 * exception.  Then invoke the handler.
 	 */
-	spin_lock_irq(&fcommon->lock);
+	spin_lock_irq(&ucommon->lock);
 
 	for (i = 0; i < fsg_num_buffers; ++i) {
-		bh = &fcommon->buffhds[i];
+		bh = ucommon->ubufs[i].fsg_buff;
 		bh->state = BUF_STATE_EMPTY;
 	}
-	old_state = fcommon->state;
-	fcommon->state = FSG_STATE_IDLE;
-	spin_unlock_irq(&fcommon->lock);
+	old_state = ucommon->state;
+	ucommon->state = UASP_STATE_IDLE;
+	spin_unlock_irq(&ucommon->lock);
 
 	/* Carry out any extra actions required for the exception */
 	switch (old_state) {
-	case FSG_STATE_ABORT_BULK_OUT:
-	case FSG_STATE_RESET:
-		/* TODO */
-		break;
-
-	case FSG_STATE_CONFIG_CHANGE:
-		if (fcommon->fsg == fcommon->new_fsg) {
-			DBG(fcommon, "nothing to do. same config\n");
-			break;
-		}
+	case UASP_STATE_CONFIG_CHANGE:
 		/* Enable/disable the interface according to the new_config */
-		rc = do_uasp_set_interface(ucommon->udev, fcommon->new_fsg);
+		rc = do_uasp_set_interface(ucommon, ucommon->new_udev);
 		if (rc != 0)
-			fcommon->fsg = NULL;	/* Reset on errors */
+			ucommon->udev = NULL;	/* Reset on errors */
+		if (ucommon->new_udev)
+			usb_composite_setup_continue(ucommon->cdev);
 		break;
-	case FSG_STATE_EXIT:
-	case FSG_STATE_TERMINATED:
+	case UASP_STATE_EXIT:
+	case UASP_STATE_TERMINATED:
 		/* Free resources */
-		(void)do_uasp_set_interface(ucommon->udev, NULL);
-		spin_lock_irq(&fcommon->lock);
-		fcommon->state = FSG_STATE_TERMINATED;	/* Stop the thread*/
-		spin_unlock_irq(&fcommon->lock);
+		(void)do_uasp_set_interface(ucommon, NULL);
+		spin_lock_irq(&ucommon->lock);
+		ucommon->state = UASP_STATE_TERMINATED;	/* Stop the thread*/
+		spin_unlock_irq(&ucommon->lock);
 		break;
 
-	case FSG_STATE_INTERFACE_CHANGE:
-	case FSG_STATE_DISCONNECT:
-	case FSG_STATE_COMMAND_PHASE:
-	case FSG_STATE_DATA_PHASE:
-	case FSG_STATE_STATUS_PHASE:
-	case FSG_STATE_IDLE:
+	case UASP_STATE_INTERFACE_CHANGE:
+	case UASP_STATE_DISCONNECT:
+	case UASP_STATE_RESET:
+	case UASP_STATE_IDLE:
 		break;
 	}
-	DBG(ucommon->common, "%s()- Exit\n", __func__);
+	DBG(ucommon, "%s()- Exit\n", __func__);
 }
 
 /**
@@ -1121,7 +1218,7 @@ static int uasp_command_check(struct uasp_dev *udev, void **command)
 	req = udev->cmd_buff.outreq;
 	*command = NULL;
 
-	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+	DBG(udev->ucommon, "%s() - Enter\n", __func__);
 
 	/* Id of the received command (tmiu or cmdiu) */
 	cmd_id = ((uint8_t *)req->buf)[0];
@@ -1131,7 +1228,7 @@ static int uasp_command_check(struct uasp_dev *udev, void **command)
 
 	/* Invalid completion status */
 	if (req->status) {
-		ERROR(udev->ucommon->common,
+		ERROR(udev->ucommon,
 		      "%s() - Invalid completion status for command "
 		      "request = -%d\n", __func__, req->status);
 		return -EINVAL;
@@ -1139,7 +1236,7 @@ static int uasp_command_check(struct uasp_dev *udev, void **command)
 
 	/* Check is the data received via command endpoint is a command */
 	if (cmd_id != IU_ID_TASK_MANAGEMENT && cmd_id != IU_ID_COMMAND) {
-		ERROR(udev->ucommon->common,
+		ERROR(udev->ucommon,
 		      "%s() - Invalid data is received\n", __func__);
 		/* TODO: something needs to be done (e.g. halt endpoints) */
 		return -EINVAL;
@@ -1147,7 +1244,7 @@ static int uasp_command_check(struct uasp_dev *udev, void **command)
 
 	/* Invalid count of bytes received for tmiu */
 	if (cmd_id == IU_ID_TASK_MANAGEMENT && req->actual != 16) {
-		ERROR(udev->ucommon->common,
+		ERROR(udev->ucommon,
 		      "%s() - Invalid byte count for tmiu is received = %d\n",
 		       __func__, req->actual);
 		/* TODO: something needs to be done (e.g. halt endpoints) */
@@ -1156,7 +1253,7 @@ static int uasp_command_check(struct uasp_dev *udev, void **command)
 
 	/* Invalid count of bytes received for cmdiu */
 	if (cmd_id == IU_ID_COMMAND && req->actual < 32) {
-		ERROR(udev->ucommon->common,
+		ERROR(udev->ucommon,
 		      "%s() - Invalid byte count for cmdiu is received = %d\n",
 		      __func__, req->actual);
 		/* TODO: something needs to be done (e.g. halt endpoints) */
@@ -1171,7 +1268,7 @@ static int uasp_command_check(struct uasp_dev *udev, void **command)
 		tmiu = kmalloc(sizeof(struct tm_iu), GFP_KERNEL);
 
 		if (!tmiu) {
-			ERROR(udev->ucommon->common,
+			ERROR(udev->ucommon,
 			      "%s() - No memory for tmiu\n", __func__);
 			return -ENOMEM;
 		}
@@ -1181,7 +1278,7 @@ static int uasp_command_check(struct uasp_dev *udev, void **command)
 		cmdiu = kmalloc(sizeof(struct cmd_iu), GFP_KERNEL);
 
 		if (!cmdiu) {
-			ERROR(udev->ucommon->common,
+			ERROR(udev->ucommon,
 			      "%s() - No memory for cmdiu\n", __func__);
 			return -ENOMEM;
 		}
@@ -1191,7 +1288,7 @@ static int uasp_command_check(struct uasp_dev *udev, void **command)
 
 	/* Check for overlapping tag */
 	/* Check for tag overlapping over all cmd an tm_func queues */
-	for (i = 0; i < udev->ucommon->common->nluns; ++i) {
+	for (i = 0; i < udev->ucommon->nluns; ++i) {
 		curlun = &udev->ucommon->uluns[i];
 		spin_lock_irqsave(&(curlun->lock), flags);
 
@@ -1221,7 +1318,7 @@ static int uasp_command_check(struct uasp_dev *udev, void **command)
 		spin_unlock_irqrestore(&(curlun->lock), flags);
 	}
 
-	spin_lock_irqsave(&(udev->ucommon->common->lock), flags);
+	spin_lock_irqsave(&(udev->ucommon->lock), flags);
 	list_for_each_entry(tmp_cmdiu, &udev->cmd_queue, node) {
 		if (tmp_cmdiu->state != COMMAND_STATE_IDLE &&
 		    tmp_cmdiu->state != COMMAND_STATE_DATA &&
@@ -1231,7 +1328,7 @@ static int uasp_command_check(struct uasp_dev *udev, void **command)
 
 		/* Overlapped tag found */
 		if (tmp_cmdiu->tag == tag) {
-			spin_unlock_irqrestore(&(udev->ucommon->common->lock),
+			spin_unlock_irqrestore(&(udev->ucommon->lock),
 					       flags);
 			goto overlapped_tag;
 		}
@@ -1244,12 +1341,12 @@ static int uasp_command_check(struct uasp_dev *udev, void **command)
 
 		/* Overlapped tag found */
 		if (tmp_tmiu->tag == tag) {
-			spin_unlock_irqrestore(&(udev->ucommon->common->lock),
+			spin_unlock_irqrestore(&(udev->ucommon->lock),
 					       flags);
 			goto overlapped_tag;
 		}
 	}
-	spin_unlock_irqrestore(&(udev->ucommon->common->lock), flags);
+	spin_unlock_irqrestore(&(udev->ucommon->lock), flags);
 
 	/* No overlapped tag */
 	if (cmd_id == IU_ID_TASK_MANAGEMENT)
@@ -1258,42 +1355,43 @@ static int uasp_command_check(struct uasp_dev *udev, void **command)
 	return 1;
 
 overlapped_tag:
-	ERROR(udev->ucommon->common, "%s() - Overlapped tag found. "
+	ERROR(udev->ucommon, "%s() - Overlapped tag found. "
 				     "Aborting all\n", __func__);
 
 	run_lun_threads(udev, LUN_STATE_OVERLAPPED_TAG);
 
 	/* Wait for luns abort completion. Sleep if luns are in processing */
 	while (!all_lun_state_non_processing(udev)) {
-		DBG(udev->ucommon->common,
+		DBG(udev->ucommon,
 		    "%s() - Luns are in process. Going to sleep\n", __func__);
-		rc = sleep_thread(udev->ucommon->common);
+		rc = uasp_sleep_thread(udev->ucommon);
 		if (rc) {
-			ERROR(udev->ucommon->common,
-			      "%s() - sleep_thread failed! (%d)", __func__, rc);
+			ERROR(udev->ucommon,
+			      "%s() - uasp_sleep_thread failed! (%d)",
+			      __func__, rc);
 			return -EINVAL;
 		}
-		DBG(udev->ucommon->common, "%s() - Wakes up\n", __func__);
+		DBG(udev->ucommon, "%s() - Wakes up\n", __func__);
 		rc = 0;
 	}
 
 	/* Abort none-lun commands */
 	abort_commands(udev, &udev->cmd_queue, &udev->tm_func_queue,
-		       &(udev->ucommon->common->lock));
+		       &(udev->ucommon->lock));
 
-	spin_lock_irqsave(&(udev->ucommon->common->lock), flags);
+	spin_lock_irqsave(&(udev->ucommon->lock), flags);
 	udev->pending_requests = 0;
-	spin_unlock_irqrestore(&(udev->ucommon->common->lock), flags);
+	spin_unlock_irqrestore(&(udev->ucommon->lock), flags);
 
 	if (cmd_id == IU_ID_TASK_MANAGEMENT) {
 		tmiu = *command;
 
-		spin_lock_irqsave(&(udev->ucommon->common->lock), flags);
-		tmiu->bh = get_buffhd(udev->ucommon->common->buffhds);
-		spin_unlock_irqrestore(&(udev->ucommon->common->lock), flags);
+		spin_lock_irqsave(&(udev->ucommon->lock), flags);
+		tmiu->bh = get_buffhd(udev->ucommon->ubufs);
+		spin_unlock_irqrestore(&(udev->ucommon->lock), flags);
 
 		if (!tmiu->bh) {
-			ERROR(udev->ucommon->common,
+			ERROR(udev->ucommon,
 			      "%s(): didnt manage to get buffers for tmiu!\n",
 			       __func__);
 			return -EINVAL;
@@ -1317,12 +1415,12 @@ overlapped_tag:
 	} else {
 		cmdiu = *command;
 
-		spin_lock_irqsave(&(udev->ucommon->common->lock), flags);
-		cmdiu->bh = get_buffhd(udev->ucommon->common->buffhds);
-		spin_unlock_irqrestore(&(udev->ucommon->common->lock), flags);
+		spin_lock_irqsave(&(udev->ucommon->lock), flags);
+		cmdiu->bh = get_buffhd(udev->ucommon->ubufs);
+		spin_unlock_irqrestore(&(udev->ucommon->lock), flags);
 
 		if (!cmdiu->bh) {
-			ERROR(udev->ucommon->common,
+			ERROR(udev->ucommon,
 			      "%s(): didnt manage to get buffers for cmdiu!\n",
 			       __func__);
 			return -EINVAL;
@@ -1364,7 +1462,7 @@ static void insert_tm_func_to_list(struct uasp_dev *udev, struct tm_iu *tmiu)
 	struct tm_iu *tmiu1;
 	struct uasp_lun *curlun;
 
-	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+	DBG(udev->ucommon, "%s() - Enter\n", __func__);
 
 	curlun = find_lun_by_id(udev, tmiu->lun);
 	tmiu->state = COMMAND_STATE_IDLE;
@@ -1449,10 +1547,10 @@ static void insert_cmd_to_list(struct uasp_dev *udev, struct cmd_iu *cmdiu)
 	struct cmd_iu *cmdiu1;
 	struct uasp_lun *curlun;
 
-	DBG(udev->ucommon->common, "%s(): cmdiu->lun = %p\n", __func__,
+	DBG(udev->ucommon, "%s(): cmdiu->lun = %p\n", __func__,
 	    cmdiu->lun);
 
-	DBG(udev->ucommon->common, "%02x %02x %02x %02x %02x %02x %02x %02x\n",
+	DBG(udev->ucommon, "%02x %02x %02x %02x %02x %02x %02x %02x\n",
 		cmdiu->lun[0], cmdiu->lun[1], cmdiu->lun[2], cmdiu->lun[3],
 		cmdiu->lun[4], cmdiu->lun[5], cmdiu->lun[6], cmdiu->lun[7]);
 
@@ -1489,7 +1587,7 @@ static void insert_cmd_to_list(struct uasp_dev *udev, struct cmd_iu *cmdiu)
 
 	/* In the case when the queue is empty */
 	list_add_tail(&cmdiu->node, link);
-	DBG(udev->ucommon->common,
+	DBG(udev->ucommon,
 	     "%s() - Cmdiu is added to the tail of the queue\n", __func__);
 }
 
@@ -1510,7 +1608,7 @@ static int get_command(struct uasp_dev *udev)
 	int rc = 0;
 	void *command = 0;
 
-	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+	DBG(udev->ucommon, "%s() - Enter\n", __func__);
 
 queue_cmd_ep:
 	/* If command endpoint is not active, activate */
@@ -1525,11 +1623,11 @@ queue_cmd_ep:
 		udev->cmd_buff.outreq->short_not_ok = 1;
 		rc = usb_ep_queue(udev->command, udev->cmd_buff.outreq, 0);
 		if (rc) {
-			ERROR(udev->ucommon->common,
+			ERROR(udev->ucommon,
 			      "%s()usb_ep_queue failed = %d\n", __func__, rc);
 			udev->cmd_buff.state = BUF_STATE_EMPTY;
 		}
-		DBG(udev->ucommon->common, "%s() queued command request = %p\n",
+		DBG(udev->ucommon, "%s() queued command request = %p\n",
 		     __func__, udev->cmd_buff.outreq);
 		return rc;
 	}
@@ -1540,13 +1638,13 @@ queue_cmd_ep:
 	rc = uasp_command_check(udev, &command);
 
 	if (rc == 0) {
-		DBG(udev->ucommon->common, "%s() - Received a TMC IU\n",
+		DBG(udev->ucommon, "%s() - Received a TMC IU\n",
 		    __func__);
 		insert_tm_func_to_list(udev, (struct tm_iu *)command);
 		udev->cmd_buff.state = BUF_STATE_EMPTY;
 		goto queue_cmd_ep;
 	} else if (rc == 1) {
-		DBG(udev->ucommon->common, "%s() -Received a CMD IU\n",
+		DBG(udev->ucommon, "%s() -Received a CMD IU\n",
 		    __func__);
 		insert_cmd_to_list(udev, (struct cmd_iu *)command);
 		udev->cmd_buff.state = BUF_STATE_EMPTY;
@@ -1567,9 +1665,9 @@ int all_lun_state_non_processing(struct uasp_dev *udev)
 	struct uasp_lun *curlun;
 	int i;
 
-	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+	DBG(udev->ucommon, "%s() - Enter\n", __func__);
 
-	for (i = 0; i < udev->ucommon->common->nluns; ++i) {
+	for (i = 0; i < udev->ucommon->nluns; ++i) {
 		curlun = &udev->ucommon->uluns[i];
 		if (curlun->lun_state > LUN_STATE_IDLE)
 			return 0;
@@ -1590,8 +1688,8 @@ static int pending_cmd_in_lun(void *data)
 	struct uasp_lun *curlun;
 	int i;
 
-	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
-	for (i = 0; i < udev->ucommon->common->nluns; ++i) {
+	DBG(udev->ucommon, "%s() - Enter\n", __func__);
+	for (i = 0; i < udev->ucommon->nluns; ++i) {
 		curlun = &udev->ucommon->uluns[i];
 		if (curlun->pending_requests)
 			return 1;
@@ -1633,17 +1731,17 @@ void run_lun_threads(struct uasp_dev *udev, int state)
 	int i;
 	unsigned long flags;
 
-	DBG(udev->ucommon->common, "%s() - Enter. State = %d\n",
+	DBG(udev->ucommon, "%s() - Enter. State = %d\n",
 	    __func__, state);
 
-	for (i = 0; i < udev->ucommon->common->nluns; ++i) {
+	for (i = 0; i < udev->ucommon->nluns; ++i) {
 		curlun = &udev->ucommon->uluns[i];
 		spin_lock_irqsave(&(curlun->lock), flags);
 		curlun->lun_state = state;
 		wakeup_lun_thread(curlun);
 		spin_unlock_irqrestore(&(curlun->lock), flags);
 	}
-	DBG(udev->ucommon->common, "%s() - Exit\n", __func__);
+	DBG(udev->ucommon, "%s() - Exit\n", __func__);
 }
 
 /**
@@ -1667,7 +1765,7 @@ void abort_commands(struct uasp_dev *udev,
 	struct cmd_iu *cmdiu, *tmp_cmdiu;
 	struct tm_iu *tmiu, *tmp_tmiu;
 
-	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+	DBG(udev->ucommon, "%s() - Enter\n", __func__);
 
 	if (!cmd_queue)
 		goto tmiu_part;
@@ -1732,58 +1830,47 @@ tmiu_part:
 void do_uasp(struct uasp_dev *udev)
 {
 	unsigned long		flags;
-	struct fsg_dev		*fsg = &(udev->fsg_dev);
 	struct uasp_common	*ucommon = udev->ucommon;
 	int rc;
 
-	DBG(ucommon->common, "%s() - Enter\n", __func__);
-
-	spin_lock_irqsave(&(fsg->common->lock), flags);
-	if (!exception_in_progress(fsg->common))
-		fsg->common->state = FSG_STATE_COMMAND_PHASE;
-	spin_unlock_irqrestore(&(fsg->common->lock), flags);
+	DBG(ucommon, "%s() - Enter\n", __func__);
 
-	if (exception_in_progress(fsg->common))
+	if (uasp_exception_in_progress(ucommon))
 		return;
 
 	if (get_command(udev))
 		return;
 
-	spin_lock_irqsave(&(fsg->common->lock), flags);
-	if (!exception_in_progress(fsg->common))
-		fsg->common->state = FSG_STATE_DATA_PHASE;
-	spin_unlock_irqrestore(&(fsg->common->lock), flags);
-
-	if (exception_in_progress(fsg->common))
+	if (uasp_exception_in_progress(ucommon))
 		return;
 
-	spin_lock_irqsave(&(ucommon->common->lock), flags);
+	spin_lock_irqsave(&(ucommon->lock), flags);
 	udev->pending_requests = 0;
-	spin_unlock_irqrestore(&(ucommon->common->lock), flags);
+	spin_unlock_irqrestore(&(ucommon->lock), flags);
 
 	do_tmiu(udev, NULL);
-	if (exception_in_progress(fsg->common))
+	if (uasp_exception_in_progress(ucommon))
 		return;
 
 	do_cmdiu(udev, NULL);
-	if (exception_in_progress(fsg->common))
+	if (uasp_exception_in_progress(ucommon))
 		return;
 
 	remove_completed_commands(udev, &udev->cmd_queue, &udev->tm_func_queue);
 
-	spin_lock_irqsave(&(fsg->common->lock), flags);
-	if (!exception_in_progress(fsg->common)) {
-		fsg->common->state = FSG_STATE_IDLE;
-		spin_unlock_irqrestore(&(fsg->common->lock), flags);
+	spin_lock_irqsave(&(ucommon->lock), flags);
+	if (!uasp_exception_in_progress(ucommon)) {
+		ucommon->state = UASP_STATE_IDLE;
+		spin_unlock_irqrestore(&(ucommon->lock), flags);
 		run_lun_threads(udev, LUN_STATE_PROCESSING);
 	} else
-		spin_unlock_irqrestore(&(fsg->common->lock), flags);
+		spin_unlock_irqrestore(&(ucommon->lock), flags);
 
 	rc = 0;
 	while (!rc) {
 		/* If exception is in progress */
-		if (exception_in_progress(ucommon->common)) {
-			DBG(ucommon->common,
+		if (uasp_exception_in_progress(ucommon)) {
+			DBG(ucommon,
 			    "%s() - Exception is in progress\n", __func__);
 			return;
 		}
@@ -1791,39 +1878,39 @@ void do_uasp(struct uasp_dev *udev)
 		/* Sleep if luns are in processing */
 		rc = all_lun_state_non_processing(udev);
 		if (!rc) {
-			DBG(ucommon->common,
+			DBG(ucommon,
 			    "%s() - Luns are in process\n", __func__);
 			goto sleep;
 		}
 
 		/* Wake up if command is received */
 		if (udev->cmd_buff.state == BUF_STATE_FULL) {
-			DBG(ucommon->common,
+			DBG(ucommon,
 			    "%s() - Command is received\n", __func__);
 			return;
 		}
 
 		/* Wake up if there are pending requests in luns */
 		if (pending_cmd_in_lun(udev)) {
-			DBG(ucommon->common,
+			DBG(ucommon,
 			    "%s() - Pending requests in LUN\n", __func__);
 			return;
 		}
 
 		/* Wake up if there are pending requests */
 		if (udev->pending_requests) {
-			DBG(ucommon->common,
+			DBG(ucommon,
 			    "%s() - Pending requests in device\n",
 			     __func__);
 			return;
 		}
 sleep:
 		/* Try to sleep */
-		DBG(ucommon->common, "%s() - Going to sleep\n", __func__);
-		rc = sleep_thread(fsg->common);
+		DBG(ucommon, "%s() - Going to sleep\n", __func__);
+		rc = uasp_sleep_thread(ucommon);
 		if (rc)
 			return;
-		DBG(ucommon->common, "%s() - Wakes up\n", __func__);
+		DBG(ucommon, "%s() - Wakes up\n", __func__);
 
 		rc = 0;
 	}
@@ -1867,7 +1954,7 @@ static int lun_exception_in_progress(struct uasp_lun *curlun)
 static void handle_lun_exception(struct uasp_dev *udev, struct uasp_lun *curlun)
 {
 	unsigned long flags;
-	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+	DBG(udev->ucommon, "%s() - Enter\n", __func__);
 
 	/* Abort all commands and remove them from lists */
 	abort_commands(udev, &curlun->cmd_queue, &curlun->tm_func_queue,
@@ -1890,7 +1977,7 @@ static void handle_lun_exception(struct uasp_dev *udev, struct uasp_lun *curlun)
 		break;
 	}
 	spin_unlock_irqrestore(&(curlun->lock), flags);
-	DBG(udev->ucommon->common, "%s() - Exit\n", __func__);
+	DBG(udev->ucommon, "%s() - Exit\n", __func__);
 }
 
 /**
@@ -1915,15 +2002,15 @@ static int uasp_lun_thread(void *param)
 	if (!ulun)
 		return  -1;
 	udev = ulun->dev;
-	DBG(udev->ucommon->common, "%s() - Enter for lun_id = %d\n", __func__,
+	DBG(udev->ucommon, "%s() - Enter for lun_id = %d\n", __func__,
 					ulun->lun_id[7]);
 
 	while (ulun->lun_state != LUN_STATE_TERMINATED) {
-		DBG(udev->ucommon->common, "%s() - Wakes up\n", __func__);
+		DBG(udev->ucommon, "%s() - Wakes up\n", __func__);
 
 		if (lun_exception_in_progress(ulun)) {
-			DBG(udev->ucommon->common,
-			    "%s() - exception_in_progress!"
+			DBG(udev->ucommon,
+			    "%s() - uasp_exception_in_progress!"
 			      " ulun->lun_state=%d\n", __func__,
 			    ulun->lun_state);
 			handle_lun_exception(udev, ulun);
@@ -1934,8 +2021,8 @@ static int uasp_lun_thread(void *param)
 		 * If the main thread isn't running, no need to run lun threads
 		 * as well.
 		 */
-		if (!udev->ucommon->common->running) {
-			DBG(udev->ucommon->common,
+		if (!udev->ucommon->running) {
+			DBG(udev->ucommon,
 			    "%s() - uasp thread main thread not running - "
 			    "going to sleep...\n", __func__);
 			sleep_lun_thread(ulun);
@@ -1959,22 +2046,22 @@ static int uasp_lun_thread(void *param)
 		if (lun_exception_in_progress(ulun))
 			continue;
 
-		spin_lock_irqsave(&(udev->ucommon->common->lock), flags);
+		spin_lock_irqsave(&(udev->ucommon->lock), flags);
 		if (!lun_exception_in_progress(ulun)) {
 			ulun->lun_state = LUN_STATE_IDLE;
-			wakeup_thread(udev->ucommon->common);
+			uasp_wakeup_thread(udev->ucommon);
 		}
-		spin_unlock_irqrestore(&(udev->ucommon->common->lock), flags);
+		spin_unlock_irqrestore(&(udev->ucommon->lock), flags);
 
-		DBG(udev->ucommon->common, "%s() - Going to sleep\n", __func__);
+		DBG(udev->ucommon, "%s() - Going to sleep\n", __func__);
 		sleep_lun_thread(ulun);
 		continue;
 	}
 
-	DBG(udev->ucommon->common, "uasp lun main loop: exiting\n");
-	spin_lock_irqsave(&(udev->ucommon->common->lock), flags);
+	DBG(udev->ucommon, "uasp lun main loop: exiting\n");
+	spin_lock_irqsave(&(udev->ucommon->lock), flags);
 	ulun->lun_thread_task = NULL;
-	spin_unlock_irqrestore(&(udev->ucommon->common->lock), flags);
+	spin_unlock_irqrestore(&(udev->ucommon->lock), flags);
 	/* Let the unbind and cleanup routines know the thread has exited */
 	complete_and_exit(&ulun->thread_notifier, 0);
 	return 0;
@@ -1993,8 +2080,6 @@ static int uasp_lun_thread(void *param)
 static int uasp_main_thread(void *param)
 {
 	struct uasp_common *ucommon = (struct uasp_common *)param;
-	struct fsg_common  *common = ucommon->common;
-
 	/*
 	 * Allow the thread to be killed by a signal, but set the signal mask
 	 * to block everything but INT, TERM, KILL, and USR1.
@@ -2015,41 +2100,41 @@ static int uasp_main_thread(void *param)
 	set_fs(get_ds());
 
 		/* The main loop */
-	while (common->state != FSG_STATE_TERMINATED) {
-		DBG(common, "uasp main loop: continuing\n");
-		if (exception_in_progress(ucommon->common) ||
+	while (ucommon->state != UASP_STATE_TERMINATED) {
+		DBG(ucommon, "uasp main loop: continuing\n");
+		if (uasp_exception_in_progress(ucommon) ||
 		    signal_pending(current)) {
-			DBG(common, "uasp thread main loop: exception\n");
+			DBG(ucommon, "uasp thread main loop: exception\n");
 			handle_uasp_exception(ucommon);
 			continue;
 		}
 
-		if (!common->running) {
-			DBG(common, "uasp thread main loop: not running\n");
-			sleep_thread(ucommon->common);
+		if (!ucommon->running) {
+			DBG(ucommon, "uasp thread main loop: not running\n");
+			uasp_sleep_thread(ucommon);
 			continue;
 		}
 		do_uasp(ucommon->udev);
 	}
 
-	DBG(common, "uasp main loop: exiting\n");
+	DBG(ucommon, "uasp main loop: exiting\n");
 
-	spin_lock_irq(&common->lock);
-	common->thread_task = NULL;
-	spin_unlock_irq(&common->lock);
+	spin_lock_irq(&ucommon->lock);
+	ucommon->thread_task = NULL;
+	spin_unlock_irq(&ucommon->lock);
 
-	if (!common->ops || !common->ops->thread_exits ||
-	    common->ops->thread_exits(common) < 0) {
+	if (!ucommon->ops || !ucommon->ops->thread_exits ||
+	    ucommon->ops->thread_exits(ucommon) < 0) {
 		struct uasp_lun	*ulun = ucommon->uluns;
 		unsigned i ;
-		down_write(&common->filesem);
-		for (i = 0; i < common->nluns; i++, ulun++)
+		down_write(&ucommon->filesem);
+		for (i = 0; i < ucommon->nluns; i++, ulun++)
 			close_lun(ulun);
-		up_write(&common->filesem);
+		up_write(&ucommon->filesem);
 	}
 
 	/* Let the unbind and cleanup routines know the thread has exited */
-	complete_and_exit(&common->thread_notifier, 0);
+	complete_and_exit(&ucommon->thread_notifier, 0);
 
 	return 0;
 }
@@ -2063,74 +2148,107 @@ static int uasp_main_thread(void *param)
  * This function should be called after (struct fsg_common) common was already
  * initiated by fsg_common_init
  */
-static struct uasp_common *uasp_common_init(struct fsg_common *common,
-					  struct usb_composite_dev *cdev,
-					    struct fsg_config *cfg)
+static struct uasp_common *uasp_common_init(struct msg_common_data *common,
+					  struct usb_composite_dev *cdev)
 {
 	struct fsg_lun *flun;
 	struct uasp_lun *ulun;
 	struct uasp_common	*ucommon;
-	int nluns = common->nluns;
-	int i, rc;
+	int i, rc = 0;
 
-	if (!common || !cdev || !cfg)
+	if (!common || !cdev)
 		return NULL;
 
-	DBG(common, "%s() - Enter\n", __func__);
+	DBG(cdev, "%s() - Enter\n", __func__);
 
 	ucommon = kzalloc(sizeof *ucommon, GFP_KERNEL);
 	if (unlikely(!ucommon))
 		return NULL;
 
-	/* Save reference to fsg_common structure in ucommon */
-	ucommon->common = common;
-
-	/* Allocate the uLUNs and init them according to fsg_common luns */
-	ulun = kzalloc(nluns * sizeof *ulun, GFP_KERNEL);
+	ucommon->msg_common = common;
+	/*Allocate the uLUNs and init them according to fsg_common luns */
+	ulun = kzalloc(common->config.nluns * sizeof *ulun, GFP_KERNEL);
 	if (!ulun) {
 		kfree(ucommon);
 		return ERR_PTR(-ENOMEM);
 	}
 	ucommon->uluns = ulun;
+	ucommon->nluns = common->config.nluns;
 
 	/* Create the reference between ulun and fsg_lun */
-	for (i = 0, flun = common->luns; i < nluns;
+	for (i = 0, flun = common->fcommon->luns; i < common->config.nluns;
 				++i, ++flun, ++ulun)
 		ulun->lun = flun;
 
+	ucommon->ops = common->config.uasp_ops;
+	ucommon->gadget = cdev->gadget;
+	ucommon->cdev = cdev;
+	ucommon->config_mutex = &(common->config.config_mutex);
+
 	/*
-	 * Buffers in ubufs are static -- no need for additional allocation.
-	 * Connect each ubuf to fsg_buff from the buffhds cyclic list
+	 * Allocate the buffers in ubufs and connect each ubuf to fsg_buff
+	 * from the buffhds cyclic list
 	 */
+	ucommon->ubufs = kzalloc(sizeof(struct uasp_buff)*fsg_num_buffers,
+				 GFP_KERNEL);
+	if (!ucommon->ubufs)
+		goto error_release;
+
 	for (i = 0; i < fsg_num_buffers; i++) {
-		ucommon->ubufs[i].fsg_buff = &(common->buffhds[i]);
+		ucommon->ubufs[i].fsg_buff = &(common->fcommon->buffhds[i]);
 		ucommon->ubufs[i].ep = NULL;
 		ucommon->ubufs[i].stream_id = 0;
 	}
 
-	kref_init(&ucommon->ref);
+	/* Prepare inquiryString */
+	if (common->config.release != 0xffff) {
+		i = common->config.release;
+	} else {
+		i = usb_gadget_controller_number(cdev->gadget);
+		if (i >= 0) {
+			i = 0x0300 + i;
+		} else {
+			WARNING(ucommon, "controller '%s' not recognized\n",
+				cdev->gadget->name);
+			i = 0x0399;
+		}
+	}
+	snprintf(ucommon->inquiry_string, sizeof ucommon->inquiry_string,
+		 "%-8s%-16s%04x", common->config.vendor_name ?: "Linux",
+		 /* Assume product name dependent on the first LUN */
+		 common->config.product_name ?: (common->fcommon->luns->cdrom
+				     ? "File-Stor UAS-Gadget"
+				     : "File-CD UAS-Gadget"),
+		 i);
+
 	/* Tell the thread to start working */
-	common->thread_task =
+	ucommon->thread_task =
 		kthread_create(uasp_main_thread, (void *)ucommon,
-			       cfg->thread_name ?: "file-storage-UASP");
-	if (IS_ERR(common->thread_task)) {
-		rc = PTR_ERR(common->thread_task);
+			       common->config.thread_name ?:
+			       "file-storage-UASP");
+	if (IS_ERR(ucommon->thread_task)) {
+		rc = PTR_ERR(ucommon->thread_task);
 		goto error_release;
 	}
 
 
 	/* Information */
-	INFO(common, UASP_DRIVER_DESC ", version: " UASP_DRIVER_VERSION "\n");
-	DBG(common, "I/O thread pid: %d\n", task_pid_nr(common->thread_task));
+	INFO(ucommon, UASP_DRIVER_DESC ", version: " UASP_DRIVER_VERSION "\n");
+	DBG(ucommon, "I/O thread pid: %d created for UASP Gdaget\n",
+	    task_pid_nr(ucommon->thread_task));
+
+	kref_init(&ucommon->ref);
+	init_waitqueue_head(&ucommon->uasp_wait);
+	init_completion(&ucommon->thread_notifier);
 
-	wake_up_process(common->thread_task);
+	wake_up_process(ucommon->thread_task);
 
 	return ucommon;
 
 error_release:
-	common->state = FSG_STATE_TERMINATED;	/* The thread is dead */
+	ucommon->state = UASP_STATE_TERMINATED;	/* The thread is dead */
 	/* Call uasp_common_release() directly, ref might be not initialised */
-	uasp_common_release(&common->ref);
+	uasp_common_release(&ucommon->ref);
 	return ERR_PTR(rc);
 }
 
@@ -2151,7 +2269,7 @@ static int finish_lun_init(struct uasp_dev *udev)
 		return -EIO;
 
 	for (i = 0, ulun = udev->ucommon->uluns;
-	       i < udev->ucommon->common->nluns; i++, ulun++) {
+	       i < udev->ucommon->nluns; i++, ulun++) {
 		/* TODO: this is a workaround, fix later */
 		memset(ulun->lun_id, 0, 8);
 		ulun->lun_id[0] = i;
@@ -2163,8 +2281,8 @@ static int finish_lun_init(struct uasp_dev *udev)
 
 		/* Create and start lun threads */
 		sprintf(thread_name, "uasp-lun-thread%d", i);
-		DBG(udev->ucommon->common,
-		    "creating & starting lun thread: thread_name = %s\n",
+		DBG(udev->ucommon,
+		    "creating lun thread: thread_name = %s\n",
 		    thread_name);
 
 		ulun->lun_thread_task = kthread_create(uasp_lun_thread,
@@ -2177,7 +2295,6 @@ static int finish_lun_init(struct uasp_dev *udev)
 		init_completion(&ulun->thread_notifier);
 		wake_up_process(ulun->lun_thread_task);
 	}
-	INFO(udev->ucommon->common, "All lun threads are started\n");
 	return rc;
 
 err_lun_init:
@@ -2193,71 +2310,110 @@ err_lun_init:
  *
  * Return 0 on succeed, error code on failure
  *
- * TODO: Add fall back to usb_ep_autoconfig() if usb_ep_autoconfig_ss() fails.
- *       In that case mark somehow that we can only operate in HS mode
  */
 static int __init uasp_bind(struct usb_configuration *c, struct usb_function *f)
 {
 	struct uasp_dev		*uaspd = uaspd_from_func(f);
-	struct fsg_dev		*fsgd = &(uaspd->fsg_dev);
 	struct usb_gadget	*gadget = c->cdev->gadget;
 	int			rc;
 	int			i;
+	int			hs_mode = 0;
 	struct usb_ep		*ep;
 
-	fsgd->common->gadget = gadget;
+	uaspd->ucommon->gadget = gadget;
 
 	/* Allocate new interface */
 	i = usb_interface_id(c, f);
 	if (i < 0)
 		return i;
 	uasp_intf_desc.bInterfaceNumber = i;
-	fsgd->interface_number = i;
 
-	/* Find all the endpoints we will use */
-	ep = usb_ep_autoconfig_ss(gadget, &uasp_ss_bulk_in_desc,
-				  &uasp_bulk_in_ep_comp_desc);
-	if (!ep)
-		goto autoconf_fail;
+	if (gadget_is_superspeed(c->cdev->gadget)) {
+		ep = usb_ep_autoconfig_ss(gadget, &uasp_ss_bulk_in_desc,
+					  &uasp_bulk_in_ep_comp_desc);
+		if (!ep) {
+			ERROR(uaspd->ucommon,
+			      "%s(): Unable to autoconfigure endpoints"
+			      " in SS mode. Falling back to HS mode...\n",
+			      __func__);
+			goto fall_back_to_hs;
+		}
+	} else {
+fall_back_to_hs:
+		hs_mode = 1;
+		uaspd->op_mode = HS_UASP_MODE;
+		uaspd->forced_hs_mode = 1;
+		ep = usb_ep_autoconfig(gadget, &uasp_fs_bulk_in_desc);
+		if (!ep)
+			goto autoconf_fail;
+	}
 	ep->driver_data = uaspd;	/* claim the endpoint */
-	fsgd->bulk_in = ep;
+	uaspd->bulk_in = ep;
 
-	ep = usb_ep_autoconfig_ss(gadget, &uasp_ss_bulk_out_desc,
+	if (hs_mode)
+		ep = usb_ep_autoconfig(gadget, &uasp_fs_bulk_out_desc);
+	else
+		ep = usb_ep_autoconfig_ss(gadget, &uasp_ss_bulk_out_desc,
 				  &uasp_bulk_out_ep_comp_desc);
 	if (!ep)
 		goto autoconf_fail;
 	ep->driver_data = uaspd;	/* claim the endpoint */
-	fsgd->bulk_out = ep;
+	uaspd->bulk_out = ep;
 
-	ep = usb_ep_autoconfig_ss(gadget, &uasp_ss_status_in_desc,
+	if (hs_mode)
+		ep = usb_ep_autoconfig(gadget, &uasp_fs_status_in_desc);
+	else
+		ep = usb_ep_autoconfig_ss(gadget, &uasp_ss_status_in_desc,
 				  &uasp_status_in_ep_comp_desc);
 	if (!ep)
 		goto autoconf_fail;
 	ep->driver_data = uaspd;	/* claim the endpoint */
 	uaspd->status = ep;
 
-	ep = usb_ep_autoconfig_ss(gadget, &uasp_ss_command_out_desc,
+	if (hs_mode)
+		ep = usb_ep_autoconfig(gadget, &uasp_fs_command_out_desc);
+	else
+		ep = usb_ep_autoconfig_ss(gadget, &uasp_ss_command_out_desc,
 				  &uasp_command_out_ep_comp_desc);
 	if (!ep)
 		goto autoconf_fail;
 	ep->driver_data = uaspd;	/* claim the endpoint */
 	uaspd->command = ep;
 
-	/* Assume endpoint addresses are the same for both speeds */
-	uasp_bulk_in_desc.bEndpointAddress =
-		uasp_ss_bulk_in_desc.bEndpointAddress;
-	uasp_bulk_out_desc.bEndpointAddress =
-		uasp_ss_bulk_out_desc.bEndpointAddress;
-	uasp_status_in_desc.bEndpointAddress =
-		uasp_ss_status_in_desc.bEndpointAddress;
-	uasp_command_out_desc.bEndpointAddress =
-		uasp_ss_command_out_desc.bEndpointAddress;
-	f->ss_descriptors = uasp_ss_function_desc;
+	if (hs_mode) {
+		if (gadget_is_dualspeed(c->cdev->gadget)) {
+			uasp_hs_bulk_in_desc.bEndpointAddress =
+				uasp_fs_bulk_in_desc.bEndpointAddress;
+			uasp_hs_bulk_out_desc.bEndpointAddress =
+				uasp_fs_bulk_out_desc.bEndpointAddress;
+			uasp_hs_status_in_desc.bEndpointAddress =
+				uasp_fs_status_in_desc.bEndpointAddress;
+			uasp_hs_command_out_desc.bEndpointAddress =
+				uasp_fs_command_out_desc.bEndpointAddress;
+		}
+	} else { /* SuperSpeed configuration sucseeded */
+		uasp_fs_bulk_in_desc.bEndpointAddress =
+			uasp_ss_bulk_in_desc.bEndpointAddress;
+		uasp_hs_bulk_in_desc.bEndpointAddress =
+			uasp_ss_bulk_in_desc.bEndpointAddress;
+		uasp_fs_bulk_out_desc.bEndpointAddress =
+			uasp_ss_bulk_out_desc.bEndpointAddress;
+		uasp_hs_bulk_out_desc.bEndpointAddress =
+			uasp_ss_bulk_out_desc.bEndpointAddress;
+		uasp_fs_status_in_desc.bEndpointAddress =
+			uasp_ss_status_in_desc.bEndpointAddress;
+		uasp_hs_status_in_desc.bEndpointAddress =
+			uasp_ss_status_in_desc.bEndpointAddress;
+		uasp_fs_command_out_desc.bEndpointAddress =
+			uasp_ss_command_out_desc.bEndpointAddress;
+		uasp_hs_command_out_desc.bEndpointAddress =
+			uasp_ss_command_out_desc.bEndpointAddress;
+	}
 
 	return 0;
 
 autoconf_fail:
-	ERROR(fsgd->common, "unable to autoconfigure all endpoints\n");
+	ERROR(uaspd->ucommon, "unable to autoconfigure all endpoints\n");
 	rc = -ENOTSUPP;
 	return rc;
 }
@@ -2265,14 +2421,28 @@ autoconf_fail:
 static void uasp_unbind(struct usb_configuration *c, struct usb_function *f)
 {
 	struct uasp_dev		*uaspd = uaspd_from_func(f);
+	struct uasp_lun *ulun;
+	int i;
+
+	DBG(uaspd->ucommon, "%s() - Enter\n", __func__);
 
-	DBG(uaspd->fsg_dev.common, "unbind\n");
-	if (uaspd->fsg_dev.common->fsg == &(uaspd->fsg_dev)) {
-		uaspd->fsg_dev.common->new_fsg = NULL;
-		raise_exception(uaspd->fsg_dev.common, FSG_STATE_CONFIG_CHANGE);
+	/* First stop all lun threads */
+	run_lun_threads(uaspd, LUN_STATE_EXIT);
+	for (i = 0; i < uaspd->ucommon->nluns; i++) {
+		ulun = &(uaspd->ucommon->uluns[i]);
+		if (ulun->lun_state != LUN_STATE_TERMINATED) {
+			wait_for_completion(&ulun->thread_notifier);
+			/* The cleanup routine waits for this completion also */
+			complete(&ulun->thread_notifier);
+		}
+	}
+
+	DBG(uaspd->ucommon, "%s(): Stoped all LUN threads\n", __func__);
+	if (uaspd->ucommon->udev) {
+		uaspd->ucommon->new_udev = NULL;
+		uasp_raise_exception(uaspd->ucommon, UASP_STATE_CONFIG_CHANGE);
 		/* TODO: make interruptible or killable somehow? */
-		wait_event(uaspd->fsg_dev.common->fsg_wait,
-			   !uaspd->ucommon->common->fsg);
+		wait_event(uaspd->ucommon->uasp_wait, !uaspd->ucommon->udev);
 	}
 	uasp_common_put(uaspd->ucommon);
 	kfree(uaspd->cmd_buff.buf);
@@ -2281,18 +2451,32 @@ static void uasp_unbind(struct usb_configuration *c, struct usb_function *f)
 
 static int uasp_set_alt(struct usb_function *f, unsigned intf, unsigned alt)
 {
-	struct fsg_dev *fsg = fsg_from_func(f);
-	fsg->common->new_fsg = fsg;
-	raise_exception(fsg->common, FSG_STATE_CONFIG_CHANGE);
-	return 0;
+	struct uasp_dev *udev = uaspd_from_func(f);
+	int i;
+
+	if (!udev->ucommon->udev) {
+		struct uasp_lun *ulun;
+		DBG(udev->ucommon,
+		    "%s() - Waking up UASP main thread\n", __func__);
+		wake_up_process(udev->ucommon->thread_task);
+
+		/* Wakeup LUN threads */
+		for (i = 0, ulun = udev->ucommon->uluns;
+			       i < udev->ucommon->nluns; i++, ulun++)
+			wake_up_process(ulun->lun_thread_task);
+		INFO(udev->ucommon, "All lun threads are started\n");
+	}
+	udev->ucommon->new_udev = udev;
+	uasp_raise_exception(udev->ucommon, UASP_STATE_CONFIG_CHANGE);
+	return USB_GADGET_DELAYED_STATUS;
 }
 
 static void uasp_disable(struct usb_function *f)
 {
 	struct uasp_dev *udev = uaspd_from_func(f);
 
-	udev->fsg_dev.common->new_fsg = NULL;
-	raise_exception(udev->fsg_dev.common, FSG_STATE_CONFIG_CHANGE);
+	udev->ucommon->new_udev = NULL;
+	uasp_raise_exception(udev->ucommon, UASP_STATE_CONFIG_CHANGE);
 }
 
 /**
@@ -2309,7 +2493,6 @@ static void uasp_disable(struct usb_function *f)
  */
 static int uasp_add(struct usb_composite_dev *cdev,
 		   struct usb_configuration *c,
-		   struct fsg_common *common,
 		   struct uasp_common *ucommon)
 {
 	struct uasp_dev *uaspd;
@@ -2319,18 +2502,17 @@ static int uasp_add(struct usb_composite_dev *cdev,
 	if (unlikely(!uaspd))
 		return -ENOMEM;
 
-	uaspd->fsg_dev.function.name		= UASP_DRIVER_DESC;
-	uaspd->fsg_dev.function.strings		= fsg_strings_array;
-	uaspd->fsg_dev.function.descriptors	= uasp_hs_function_desc;
-	uaspd->fsg_dev.function.hs_descriptors	= uasp_hs_function_desc;
-	uaspd->fsg_dev.function.bind		= uasp_bind;
-	uaspd->fsg_dev.function.unbind		= uasp_unbind;
-	uaspd->fsg_dev.function.set_alt		= uasp_set_alt;
-	uaspd->fsg_dev.function.disable		= uasp_disable;
-
-	uaspd->fsg_dev.common			= common;
+	uaspd->function.name		= UASP_DRIVER_DESC;
+	uaspd->function.strings		= fsg_strings_array;
+	uaspd->function.descriptors	= uasp_fs_function_desc;
+	uaspd->function.hs_descriptors	= uasp_hs_function_desc;
+	uaspd->function.ss_descriptors	= uasp_ss_function_desc;
+	uaspd->function.bind		= uasp_bind;
+	uaspd->function.unbind		= uasp_unbind;
+	uaspd->function.set_alt		= uasp_set_alt;
+	uaspd->function.disable		= uasp_disable;
 
-	uaspd->ucommon = ucommon;
+	uaspd->ucommon			= ucommon;
 
 	/* Init the command and status buffers */
 	uaspd->cmd_buff.buf = kmalloc(FSG_BUFLEN, GFP_KERNEL);
@@ -2339,7 +2521,6 @@ static int uasp_add(struct usb_composite_dev *cdev,
 		goto uasp_add_err;
 	}
 
-	ucommon->udev = uaspd;
 	rc = finish_lun_init(uaspd);
 	if (rc)
 		goto uasp_add_err;
@@ -2353,7 +2534,7 @@ static int uasp_add(struct usb_composite_dev *cdev,
 	 * recovery we increment it only when call to usb_add_function() was
 	 * successful.
 	 */
-	rc = usb_add_function(c, &uaspd->fsg_dev.function);
+	rc = usb_add_function(c, &uaspd->function);
 
 	if (likely(rc == 0))
 		kref_get(&ucommon->ref);
diff --git a/drivers/usb/gadget/f_uasp.h b/drivers/usb/gadget/f_uasp.h
index 63ade00..3f1e042 100644
--- a/drivers/usb/gadget/f_uasp.h
+++ b/drivers/usb/gadget/f_uasp.h
@@ -18,6 +18,15 @@
 #define _F_UASP_H
 
 #include <linux/kernel.h>
+#include <linux/usb/ch9.h>
+#include <linux/usb/gadget.h>
+#include <linux/completion.h>
+#include <linux/kref.h>
+#include <linux/kthread.h>
+#include <linux/rwsem.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 
@@ -79,30 +88,80 @@ struct uasp_buff {
 	unsigned		stream_id:16;
 };
 
+struct uasp_common;
+struct uasp_lun;
+struct uasp_dev;
+
+enum uasp_state {
+	UASP_STATE_IDLE = 0,
+	UASP_STATE_RESET,
+	UASP_STATE_INTERFACE_CHANGE,
+	UASP_STATE_CONFIG_CHANGE,
+	UASP_STATE_DISCONNECT,
+	UASP_STATE_EXIT,
+	UASP_STATE_TERMINATED
+};
+
 /**
  * struct uasp_common - Common data shared by all UASP devices
+ * @gadget: pointer to the gadget driver
  * @udev: Programming view of uasp device.
- * @common: points to fsg_common in fsg_dev
- * @ubufs: buffers to be used by the uasp device. Each element in
- *	ubufs[i].fsg_buff points to a fsg_buffhd struct from fsg_common data
- *	structure
- * @uluns: luns of the uasp device. Each element in uluns[i].lun points to a
- *	fsg_lun array element from fsg_common data structure
- *
- * Extends the struct fsg_common structure.
+ * @new_udev: Programming view of new uasp device. Used in configuration switch
+ * @uasp_wait: wait queue
+ * @filesem: filesem protects: backing files in use
+ * @lock: lock protects: state, all the req_busy's
+ * @ubufs: buffers to be used by the uasp device.
+ * @uluns: luns of the uasp device.
+ * @nluns: number of luns
+ * @state: For exception handling
+ * @running: set to 1 if the UASP interface is active
+ * @ops: Callback functions.
+ * @private_data: Gadget's private data.
+ * @inquiry_string: Vendor (8 chars), product (16 chars), release (4 hexadecimal
+ *  digits) and NULL byte
+ * @ref:
  */
 struct uasp_common {
-	struct uasp_dev		*udev;
-	struct fsg_common	*common;
-	struct uasp_buff	ubufs[fsg_num_buffers];
+	struct usb_gadget	*gadget;
+	struct usb_composite_dev *cdev;
+	struct msg_common_data	*msg_common;
+	struct uasp_dev		*udev, *new_udev;
+	wait_queue_head_t	uasp_wait;
+
+	struct mutex		*config_mutex;
+
+	struct rw_semaphore	filesem;
+	spinlock_t		lock;
+
+	struct uasp_buff	*ubufs;
 	struct uasp_lun		*uluns;
+
+	unsigned int		nluns;
+	enum uasp_state		state;
+	unsigned int		running:1;
+
+	int			thread_wakeup_needed;
+	struct completion	thread_notifier;
+	struct task_struct	*thread_task;
+
+	const struct fsg_operations	*ops;
+
+	char inquiry_string[8 + 16 + 4 + 1];
+
 	struct kref		ref;
 };
 
 /**
  * struct uasp_dev - Programming view of the uasp device
- * @fsg_dev: pointer to the fsg_dev this struct extends
+ * @function: usb function
+ * @gadget: Copy of cdev->gadget
  * @ucommon: pointer to the common data of the device
+ * @bulk_in_enabled: set to 1 when BULK IN ep is enabled
+ * @bulk_out_enabled: set to 1 when BULK OUT ep is enabled
+ * @cmd_enabled: set to 1 when COMMAND ep is enabled
+ * @status_enabled: set to 1 when STATUS ep is enabled
+ * @bulk_in: BULK IN endpoint
+ * @bulk_out: BULK OUT endpoint
  * @status: status endpoint
  * @command: command endpoint
  * @cmd_buff: buffer used for receiving commannd IUs
@@ -117,19 +176,27 @@ struct uasp_common {
  * Extends the struct fsg_dev structure.
  */
 struct uasp_dev {
-	struct fsg_dev		fsg_dev;
-
+	struct usb_function	function;
+	struct usb_gadget	*gadget;
 	struct uasp_common	*ucommon;
+
+	unsigned int		bulk_in_enabled:1;
+	unsigned int		bulk_out_enabled:1;
+	unsigned int		cmd_enabled:1;
+	unsigned int		status_enabled:1;
+
+	struct usb_ep		*bulk_in;
+	struct usb_ep		*bulk_out;
 	struct usb_ep		*status;
 	struct usb_ep		*command;
+
 	struct fsg_buffhd	cmd_buff;
 
-#define HS_UASP_MODE		0
-#define SS_UASP_MODE		1
+#define UASP_MODE_UNSET		0
+#define HS_UASP_MODE		1
+#define SS_UASP_MODE		2
 	uint8_t			op_mode;
-
-	unsigned int		cmd_enabled;
-	unsigned int		status_enabled;
+	unsigned int		forced_hs_mode;
 
 	struct list_head	cmd_queue;
 	struct list_head	tm_func_queue;
@@ -453,4 +520,5 @@ int all_lun_state_non_processing(struct uasp_dev *udev);
  */
 void close_lun(struct uasp_lun *ulun);
 
+int uasp_sleep_thread(struct uasp_common *common);
 #endif /* _F_UASP_H */
diff --git a/drivers/usb/gadget/mass_storage.c b/drivers/usb/gadget/mass_storage.c
index b7d9e7e..5e4c3d2 100644
--- a/drivers/usb/gadget/mass_storage.c
+++ b/drivers/usb/gadget/mass_storage.c
@@ -28,9 +28,7 @@
  */
 
 
-#include <linux/kernel.h>
 #include <linux/utsname.h>
-#include <linux/usb/ch9.h>
 
 
 /*-------------------------------------------------------------------------*/
@@ -95,9 +93,11 @@ static struct fsg_module_parameters mod_data = {
 FSG_MODULE_PARAMETERS(/* no prefix */, mod_data);
 
 static unsigned long msg_registered;
+static struct msg_common_data msg_common;
+
 static void msg_cleanup(void);
 
-static int msg_thread_exits(struct fsg_common *common)
+static int msg_thread_exits(void *common)
 {
 	msg_cleanup();
 	return 0;
@@ -105,13 +105,9 @@ static int msg_thread_exits(struct fsg_common *common)
 
 static int __init msg_do_config(struct usb_configuration *c)
 {
-	static const struct fsg_operations ops = {
-		.thread_exits = msg_thread_exits,
-	};
 	static struct fsg_common common;
 
 	struct fsg_common *retp;
-	struct fsg_config config;
 	int ret;
 
 	if (gadget_is_otg(c->cdev->gadget)) {
@@ -119,14 +115,11 @@ static int __init msg_do_config(struct usb_configuration *c)
 		c->bmAttributes |= USB_CONFIG_ATT_WAKEUP;
 	}
 
-	fsg_config_from_params(&config, &mod_data);
-	config.ops = &ops;
-
 	/* Init fsg_common and start the fsg main thread */
-	retp = fsg_common_init(&common, c->cdev, &config, 1);
+	retp = fsg_common_init(&common, c->cdev, &msg_common.config);
 	if (IS_ERR(retp))
 		return PTR_ERR(retp);
-
+	common.msg_common = &msg_common;
 	ret = fsg_bind_config(c->cdev, c, &common);
 	fsg_common_put(&common);
 	return ret;
@@ -140,25 +133,14 @@ static struct usb_configuration msg_config_driver = {
 
 static int __init uasp_do_config(struct usb_configuration *c)
 {
-	static const struct fsg_operations ops = {
-		.thread_exits = msg_thread_exits,
-	};
-
-	struct fsg_common *fcommon;
 	struct uasp_common *ucommon;
-	struct fsg_config config;
 	int ret = 0;
 
-	fsg_config_from_params(&config, &mod_data);
-	config.ops = &ops;
-	fcommon = fsg_common_init(0, c->cdev, &config, 0);
-	if (IS_ERR(fcommon))
-		return PTR_ERR(fcommon);
-
-	ucommon = uasp_common_init(fcommon, c->cdev, &config);
+	ucommon = uasp_common_init(&msg_common, c->cdev);
 	if (IS_ERR(ucommon))
 		return PTR_ERR(ucommon);
-	ret = uasp_add(c->cdev, c, fcommon, ucommon);
+	msg_common.ucommon = ucommon;
+	ret = uasp_add(c->cdev, c, ucommon);
 	uasp_common_put(ucommon);
 
 	return ret;
@@ -174,36 +156,38 @@ static struct usb_configuration uasp_config_driver = {
 
 /****************************** Gadget Bind ******************************/
 
-bool use_uasp ;
-module_param(use_uasp, bool, S_IRUGO | S_IWUSR);
 static int __init msg_bind(struct usb_composite_dev *cdev)
 {
 	int status;
-
+	struct usb_function		*fsg_func;
+	static const struct fsg_operations ops = {
+		.thread_exits = msg_thread_exits,
+	};
 	dev_info(&cdev->gadget->dev,
 		 DRIVER_DESC ", version: " DRIVER_VERSION "\n");
 
-	if (use_uasp) {
-		/*
-		 * TODO: fix the bellow!
-		 * Right now the host always chooses the first configuration.
-		 * Untill this is fixed, if we want the device to opperate in
-		 * UASP mode we switch the configurations numbers
-		 */
-		msg_config_driver.bConfigurationValue = 2;
-		uasp_config_driver.bConfigurationValue = 1;
-		/* register uasp configuration */
-		status = usb_add_config(cdev, &uasp_config_driver,
-					uasp_do_config);
-		if (status < 0)
-			return status;
-	} else {
-		/* register our second configuration */
-		status = usb_add_config(cdev, &msg_config_driver,
-					msg_do_config);
-		if (status < 0)
-			return status;
-	}
+	fsg_config_from_params(&msg_common.config, &mod_data);
+	msg_common.config.ops = &ops;
+	msg_common.config.uasp_ops = &ops;
+	mutex_init(&msg_common.config.config_mutex);
+
+	/* register MS-BOT configuration */
+	status = usb_add_config(cdev, &msg_config_driver,
+				msg_do_config);
+	if (status < 0)
+		return status;
+
+	fsg_func = list_first_entry(&msg_config_driver.functions,
+						    struct usb_function,
+						    list);
+	msg_common.fcommon = (fsg_from_func(fsg_func))->common;
+
+	/* Register MS-UAS configuration */
+	status = usb_add_config(cdev, &uasp_config_driver, uasp_do_config);
+	if (status < 0)
+		return status;
+
+
 	set_bit(0, &msg_registered);
 	return 0;
 }
@@ -233,5 +217,9 @@ static void msg_cleanup(void)
 {
 	if (test_and_clear_bit(0, &msg_registered))
 		usb_composite_unregister(&msg_driver);
+	memset(&msg_common.config, 0, sizeof(struct fsg_config));
+
+	msg_common.fcommon = NULL;
+	msg_common.ucommon = NULL;
 }
 module_exit(msg_cleanup);
diff --git a/drivers/usb/gadget/storage_common.c b/drivers/usb/gadget/storage_common.c
index 4937ad6..6e84b27 100644
--- a/drivers/usb/gadget/storage_common.c
+++ b/drivers/usb/gadget/storage_common.c
@@ -46,7 +46,7 @@
 /*
  * When USB_GADGET_DEBUG_FILES is defined the module param num_buffers
  * sets the number of pipeline buffers (length of the fsg_buffhd array).
- * The valid range of num_buffers is: num >= 2 && num <= 4.
+ * The valid range of num_buffers is: num >= 256 && num <= 1024.
  */
 
 
@@ -252,6 +252,70 @@ struct fsg_lun {
 
 #define fsg_lun_is_open(curlun)	((curlun)->filp != NULL)
 
+/* FSF callback functions */
+struct fsg_operations {
+	/*
+	 * Callback function to call when thread exits.  If no
+	 * callback is set or it returns value lower then zero MSF
+	 * will force eject all LUNs it operates on (including those
+	 * marked as non-removable or with prevent_medium_removal flag
+	 * set).
+	 */
+	int (*thread_exits)(void *common);
+
+	/*
+	 * Called prior to ejection.  Negative return means error,
+	 * zero means to continue with ejection, positive means not to
+	 * eject.
+	 */
+	int (*pre_eject)(void *common,
+			 struct fsg_lun *lun, int num);
+	/*
+	 * Called after ejection.  Negative return means error, zero
+	 * or positive is just a success.
+	 */
+	int (*post_eject)(void *common,
+			  struct fsg_lun *lun, int num);
+};
+
+/* Maximal number of LUNs supported in mass storage function */
+#define FSG_MAX_LUNS	8
+
+struct fsg_config {
+	unsigned nluns;
+	struct fsg_lun_config {
+		const char *filename;
+		char ro;
+		char removable;
+		char cdrom;
+		char nofua;
+	} luns[FSG_MAX_LUNS];
+
+	const char			*lun_name_format;
+	const char			*thread_name;
+
+	/* Callback functions. */
+	const struct fsg_operations	*ops;
+	/* UAS Callback functions. */
+	const struct fsg_operations	*uasp_ops;
+	/* Gadget's private data. */
+	void				*private_data;
+	struct mutex			config_mutex;
+
+	const char *vendor_name;		/*  8 characters or less */
+	const char *product_name;		/* 16 characters or less */
+	u16 release;
+
+	char				can_stall;
+};
+
+struct msg_common_data {
+	struct fsg_config	config;
+	struct fsg_common	*fcommon;
+	struct uasp_common	*ucommon;
+};
+
+
 static struct fsg_lun *fsg_lun_from_dev(struct device *dev)
 {
 	return container_of(dev, struct fsg_lun, dev);
diff --git a/drivers/usb/gadget/uasp_cmdiu.c b/drivers/usb/gadget/uasp_cmdiu.c
index 8836945..61902e4 100644
--- a/drivers/usb/gadget/uasp_cmdiu.c
+++ b/drivers/usb/gadget/uasp_cmdiu.c
@@ -27,14 +27,14 @@
  * This function tries to find a free buffer for COMMAND IU or
  * TM FUNCTION IU processing.
  */
-struct fsg_buffhd *get_buffhd(struct fsg_buffhd *bh)
+struct fsg_buffhd *get_buffhd(struct uasp_buff *bh)
 {
 	int i;
 
 	for (i = 0; i < fsg_num_buffers; i++) {
-		if (bh[i].state == BUF_STATE_EMPTY) {
-			bh[i].state = BUF_STATE_BUSY;
-			return &bh[i];
+		if (bh[i].fsg_buff->state == BUF_STATE_EMPTY) {
+			bh[i].fsg_buff->state = BUF_STATE_BUSY;
+			return bh[i].fsg_buff;
 		}
 	}
 
@@ -56,12 +56,12 @@ static __u32 check_cmdiu(struct uasp_dev *udev,
 {
 	__u32 ua_data = 0;
 
-	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+	DBG(udev->ucommon, "%s() - Enter\n", __func__);
 
 	if (!curlun || !curlun->lun) {
 		if (cmdiu->cdb[0] != INQUIRY &&
 		    cmdiu->cdb[0] != REQUEST_SENSE) {
-			DBG(udev->ucommon->common,
+			DBG(udev->ucommon,
 			      "%s() - Logical unit is not supported\n",
 			      __func__);
 			return SS_LOGICAL_UNIT_NOT_SUPPORTED;
@@ -70,18 +70,24 @@ static __u32 check_cmdiu(struct uasp_dev *udev,
 		if (curlun->lun->unit_attention_data &&
 		    cmdiu->cdb[0] != INQUIRY &&
 		    cmdiu->cdb[0] != REQUEST_SENSE) {
-			DBG(udev->ucommon->common,
+			DBG(udev->ucommon,
 			    "%s() - There is an unit attention condition\n",
 			    __func__);
 			ua_data = curlun->lun->unit_attention_data;
 			curlun->lun->unit_attention_data = SS_NO_SENSE;
 			return ua_data;
 		}
+			/* HACK!!! REMOVE!!! */
+		if (curlun->lun->unit_attention_data == SS_RESET_OCCURRED &&
+			cmdiu->cdb[0] == INQUIRY) {
+			curlun->lun->unit_attention_data = SS_NO_SENSE;
+			DBG(udev->ucommon, "check_cmdiu() - "
+			       "HACK!!! RESETTING  unit attention condition\n");
+		}
 	}
 
 	if (curlun && !(curlun->lun->filp) && needs_medium) {
-		DBG(udev->ucommon->common,
-		    "%s() - Medium is not present\n", __func__);
+		DBG(udev->ucommon, "%s() - Medium is not present\n", __func__);
 		return SS_MEDIUM_NOT_PRESENT;
 	}
 
@@ -102,7 +108,7 @@ void fill_sense_iu(struct uasp_dev *udev,
 	       __u8 status,
 	       __u32 sense_data)
 {
-	DBG(udev->ucommon->common, "%s() - Status = %02x\n", __func__, status);
+	DBG(udev->ucommon, "%s() - Status = %02x\n", __func__, status);
 
 	siu->iu_id = IU_ID_SENSE;
 	siu->reserved1 = 0;
@@ -147,14 +153,14 @@ static int do_uasp_inquiry(struct uasp_dev *udev,
 			struct cmd_iu *cmdiu)
 {
 	struct fsg_buffhd *bh = cmdiu->bh;
-	struct fsg_common *common = udev->ucommon->common;
+	struct uasp_common *ucommon = udev->ucommon;
 	struct usb_request *req = bh->inreq;
 	__u8 *buf = (__u8 *)bh->buf;
 	__u32 sense = SS_NO_SENSE;
 	__u8 status = STATUS_GOOD;
 	int rc = 0;
 
-	DBG(common, "%s() - Enter\n", __func__);
+	DBG(ucommon, "%s() - Enter\n", __func__);
 
 	if (cmdiu->state == COMMAND_STATE_IDLE) {
 		/* Check is cmdiu is filled correctly */
@@ -162,7 +168,7 @@ static int do_uasp_inquiry(struct uasp_dev *udev,
 
 		/* If error sent status with sense data */
 		if (sense) {
-			ERROR(common, "%s() - Error condition\n", __func__);
+			ERROR(ucommon, "%s() - Error condition\n", __func__);
 			status = STATUS_CHECK_CONDITION;
 			cmdiu->state = COMMAND_STATE_STATUS;
 		} else if (udev->op_mode == HS_UASP_MODE)
@@ -213,8 +219,8 @@ static int do_uasp_inquiry(struct uasp_dev *udev,
 				buf[5] = 0;	/* No special options */
 				buf[6] = 0;
 				buf[7] = 0;
-				memcpy(buf + 8, common->inquiry_string,
-				       sizeof(common->inquiry_string));
+				memcpy(buf + 8, ucommon->inquiry_string,
+				       sizeof(ucommon->inquiry_string));
 			}
 
 			fill_usb_request(req, bh->buf,
@@ -224,7 +230,7 @@ static int do_uasp_inquiry(struct uasp_dev *udev,
 				 be16_to_cpup(&cmdiu->tag),
 				 uasp_bulk_in_complete, udev->op_mode);
 
-			cmdiu->ep = udev->fsg_dev.bulk_in;
+			cmdiu->ep = udev->bulk_in;
 			cmdiu->req_sts = CMD_REQ_IN_PROGRESS;
 			rc = 1;
 			break;
@@ -286,7 +292,7 @@ static int do_uasp_request_sense(struct uasp_dev *udev,
 	__u32 sense = SS_NO_SENSE;
 	__u8 status = STATUS_GOOD;
 
-	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+	DBG(udev->ucommon, "%s() - Enter\n", __func__);
 
 	if (cmdiu->state == COMMAND_STATE_IDLE) {
 		/* Check is cmdiu is filled correctly */
@@ -377,7 +383,7 @@ static int do_uasp_request_sense(struct uasp_dev *udev,
 					 be16_to_cpup(&cmdiu->tag),
 					 uasp_bulk_in_complete, udev->op_mode);
 
-			cmdiu->ep = udev->fsg_dev.bulk_in;
+			cmdiu->ep = udev->bulk_in;
 			cmdiu->req_sts = CMD_REQ_IN_PROGRESS;
 			rc = 1;
 			break;
@@ -401,7 +407,7 @@ static int do_uasp_request_sense(struct uasp_dev *udev,
 		break;
 	}
 
-	DBG(udev->ucommon->common, "%s() - Exit\n", __func__);
+	DBG(udev->ucommon, "%s() - Exit\n", __func__);
 	return rc;
 }
 
@@ -424,7 +430,7 @@ static int do_uasp_test_unit_ready(struct uasp_dev *udev,
 	__u32 sense = SS_NO_SENSE;
 	__u8 status = STATUS_GOOD;
 
-	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+	DBG(udev->ucommon, "%s() - Enter\n", __func__);
 
 	/* Check is cmdiu is filled correctly */
 	sense = check_cmdiu(udev, curlun, cmdiu, 0);
@@ -472,7 +478,7 @@ static int do_uasp_mode_sense(struct uasp_dev *udev,
 	__u32 sense = SS_NO_SENSE;
 	__u8 status = STATUS_GOOD;
 
-	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+	DBG(udev->ucommon, "%s() - Enter\n", __func__);
 
 	if (cmdiu->state == COMMAND_STATE_IDLE) {
 		sense = check_cmdiu(udev, curlun, cmdiu, 0);
@@ -592,7 +598,7 @@ static int do_uasp_mode_sense(struct uasp_dev *udev,
 			fill_usb_request(req, buf0, len, 0, cmdiu, 0,
 					 be16_to_cpup(&cmdiu->tag),
 					 uasp_bulk_in_complete, udev->op_mode);
-			cmdiu->ep = udev->fsg_dev.bulk_in;
+			cmdiu->ep = udev->bulk_in;
 			cmdiu->req_sts = CMD_REQ_IN_PROGRESS;
 			rc = 1;
 			break;
@@ -637,7 +643,7 @@ static int do_uasp_prevent_allow(struct uasp_dev *udev,
 	__u32 sense = SS_NO_SENSE;
 	__u8 status = STATUS_GOOD;
 
-	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+	DBG(udev->ucommon, "%s() - Enter\n", __func__);
 
 	/* Check is cmdiu is filled correctly */
 	sense = check_cmdiu(udev, curlun, cmdiu, 0);
@@ -699,11 +705,11 @@ static int do_uasp_read(struct uasp_dev *udev,
 	__u8 status = STATUS_GOOD;
 	int rc = 0;
 
-	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+	DBG(udev->ucommon, "%s() - Enter\n", __func__);
 
 	if (cmdiu->state == COMMAND_STATE_IDLE) {
 		if (!curlun) {
-			ERROR(udev->ucommon->common,
+			ERROR(udev->ucommon,
 			       "%s() - Error condition - curlun = NULL\n",
 			       __func__);
 			sense = SS_LOGICAL_UNIT_NOT_SUPPORTED;
@@ -759,7 +765,7 @@ static int do_uasp_read(struct uasp_dev *udev,
 			cmdiu->state = COMMAND_STATE_DATA;
 
 		cmdiu->req_sts = CMD_REQ_NOT_SUBMITTED;
-		DBG(udev->ucommon->common, "%s() lba = %d, file_offset = %d,"
+		DBG(udev->ucommon, "%s() lba = %d, file_offset = %d,"
 					   " xfer_len = %d\n",
 		__func__, lba, cmdiu->file_offset, cmdiu->xfer_len);
 	}
@@ -867,19 +873,19 @@ send_more_data:		/*
 			fill_usb_request(req, bh->buf, nread, 0,
 					 cmdiu, 0, be16_to_cpup(&cmdiu->tag),
 					 uasp_bulk_in_complete, udev->op_mode);
-			cmdiu->ep = udev->fsg_dev.bulk_in;
+			cmdiu->ep = udev->bulk_in;
 			cmdiu->req_sts = CMD_REQ_IN_PROGRESS;
 			rc = 1;
 			break;
 		} else if (cmdiu->req_sts == CMD_REQ_IN_PROGRESS) {
 			/* Completion of sent data is not received yet */
-			DBG(udev->ucommon->common,
+			DBG(udev->ucommon,
 			    "%s() - completion for bh is not received",
 			     __func__);
 			break;
 		} else {
 			/* Completion of the sent data is done */
-			DBG(udev->ucommon->common,
+			DBG(udev->ucommon,
 			    "%s() - COMMAND_STATE_DATA for bh\n", __func__);
 			if (cmdiu->xfer_len == 0)
 				goto send_status;
@@ -926,7 +932,7 @@ static int do_uasp_read_capacity(struct uasp_dev *udev,
 	__u32 sense = SS_NO_SENSE;
 	__u8 status = STATUS_GOOD;
 
-	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+	DBG(udev->ucommon, "%s() - Enter\n", __func__);
 
 	if (cmdiu->state == COMMAND_STATE_IDLE) {
 		/* Check is cmdiu is filled correctly */
@@ -987,7 +993,7 @@ static int do_uasp_read_capacity(struct uasp_dev *udev,
 					 cmdiu, 0, be16_to_cpup(&cmdiu->tag),
 					 uasp_bulk_in_complete, udev->op_mode);
 
-			cmdiu->ep = udev->fsg_dev.bulk_in;
+			cmdiu->ep = udev->bulk_in;
 			cmdiu->req_sts = CMD_REQ_IN_PROGRESS;
 			rc = 1;
 			break;
@@ -1034,7 +1040,7 @@ static int do_uasp_read_format_capacities(struct uasp_dev *udev,
 	__u8 status = STATUS_GOOD;
 	int rc = 0;
 
-	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+	DBG(udev->ucommon, "%s() - Enter\n", __func__);
 
 	if (cmdiu->state == COMMAND_STATE_IDLE) {
 		/* Check is cmdiu is filled correctly */
@@ -1096,7 +1102,7 @@ static int do_uasp_read_format_capacities(struct uasp_dev *udev,
 					 cmdiu, 0, be16_to_cpup(&cmdiu->tag),
 					 uasp_bulk_in_complete, udev->op_mode);
 
-			cmdiu->ep = udev->fsg_dev.bulk_in;
+			cmdiu->ep = udev->bulk_in;
 			cmdiu->req_sts = CMD_REQ_IN_PROGRESS;
 			rc = 1;
 			break;
@@ -1118,7 +1124,7 @@ static int do_uasp_read_format_capacities(struct uasp_dev *udev,
 		break;
 	}
 
-	DBG(udev->ucommon->common, "%s() - Exit\n", __func__);
+	DBG(udev->ucommon, "%s() - Exit\n", __func__);
 	return rc;
 }
 
@@ -1143,7 +1149,7 @@ static int do_uasp_start_stop(struct uasp_dev *udev,
 	__u8 status = STATUS_GOOD;
 	int start, loej;
 
-	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+	DBG(udev->ucommon, "%s() - Enter\n", __func__);
 
 	start = cmdiu->cdb[4] & 0x01;
 	loej = cmdiu->cdb[4] & 0x02;
@@ -1190,7 +1196,7 @@ static int do_uasp_start_stop(struct uasp_dev *udev,
 		} else {
 			/* Are we allowed to unload the media? */
 			if (curlun->lun->prevent_medium_removal) {
-				DBG(udev->ucommon->common,
+				DBG(udev->ucommon,
 				    "%s(): unload attempt prevented\n",
 				    __func__);
 				sense = SS_MEDIUM_REMOVAL_PREVENTED;
@@ -1199,10 +1205,10 @@ static int do_uasp_start_stop(struct uasp_dev *udev,
 			}
 
 			/* Simulate an unload/eject */
-			if (udev->ucommon->common->ops &&
-			    udev->ucommon->common->ops->pre_eject) {
-				int r = udev->ucommon->common->ops->pre_eject(
-					udev->ucommon->common, curlun->lun,
+			if (udev->ucommon->ops &&
+			    udev->ucommon->ops->pre_eject) {
+				int r = udev->ucommon->ops->pre_eject(
+					udev->ucommon, curlun->lun,
 					curlun - udev->ucommon->uluns);
 				if (unlikely(r < 0))
 					status = STATUS_CHECK_CONDITION;
@@ -1210,18 +1216,17 @@ static int do_uasp_start_stop(struct uasp_dev *udev,
 					goto do_uasp_start_stop_done;
 			}
 
-			up_read(&(udev->ucommon->common->filesem));
-			down_write(&(udev->ucommon->common->filesem));
+			up_read(&(udev->ucommon->filesem));
+			down_write(&(udev->ucommon->filesem));
 			close_lun(curlun);
-			up_write(&(udev->ucommon->common->filesem));
-			down_read(&(udev->ucommon->common->filesem));
-
-			if (udev->ucommon->common->ops &&
-			    udev->ucommon->common->ops->post_eject) {
-				if (udev->ucommon->common->ops->
-				    post_eject(udev->ucommon->common,
-					       curlun->lun,
-					       curlun - udev->ucommon->uluns)
+			up_write(&(udev->ucommon->filesem));
+			down_read(&(udev->ucommon->filesem));
+
+			if (udev->ucommon->ops &&
+			    udev->ucommon->ops->post_eject) {
+				if (udev->ucommon->ops->
+				    post_eject(udev->ucommon, curlun->lun,
+					curlun - udev->ucommon->uluns)
 				    < 0)
 					status = STATUS_CHECK_CONDITION;
 			}
@@ -1237,7 +1242,7 @@ do_uasp_start_stop_done:
 			 udev->op_mode);
 	cmdiu->ep = udev->status;
 
-	DBG(udev->ucommon->common, "%s() - Exit\n", __func__);
+	DBG(udev->ucommon, "%s() - Exit\n", __func__);
 	return 1;
 }
 
@@ -1267,7 +1272,7 @@ static int do_uasp_verify(struct uasp_dev *udev,
 	__u32 sense = SS_NO_SENSE;
 	__u8 status = STATUS_GOOD;
 
-	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+	DBG(udev->ucommon, "%s() - Enter\n", __func__);
 
 	file_offset = (get_unaligned_be32(&cmdiu->cdb[2]) << 9);
 	ver_len = (get_unaligned_be32(&cmdiu->cdb[7]) << 9);
@@ -1354,7 +1359,7 @@ static int do_uasp_verify(struct uasp_dev *udev,
 			 be16_to_cpup(&cmdiu->tag), status_complete,
 			 udev->op_mode);
 	cmdiu->ep = udev->status;
-	DBG(udev->ucommon->common, "%s() - Exit\n", __func__);
+	DBG(udev->ucommon, "%s() - Exit\n", __func__);
 	return 1;
 }
 
@@ -1386,10 +1391,10 @@ static int do_uasp_write(struct uasp_dev *udev,
 	__u8 status = STATUS_GOOD;
 	int rc = 0;
 
-	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+	DBG(udev->ucommon, "%s() - Enter\n", __func__);
 
 	if (!curlun) {
-		ERROR(udev->ucommon->common,
+		ERROR(udev->ucommon,
 		       "%s() - Error condition - curlun = NULL\n",
 		       __func__);
 		sense = SS_LOGICAL_UNIT_NOT_SUPPORTED;
@@ -1474,7 +1479,7 @@ static int do_uasp_write(struct uasp_dev *udev,
 		else
 			cmdiu->state = COMMAND_STATE_DATA;
 		cmdiu->req_sts = CMD_REQ_NOT_SUBMITTED;
-		DBG(udev->ucommon->common, "%s() lba = %d, file_offset = %d,"
+		DBG(udev->ucommon, "%s() lba = %d, file_offset = %d,"
 					   " xfer_len = %d\n",
 		__func__, lba, cmdiu->file_offset, cmdiu->xfer_len);
 	}
@@ -1549,11 +1554,11 @@ get_more_data:	if (cmdiu->req_sts == CMD_REQ_NOT_SUBMITTED) {
 			fill_usb_request(req, bh->buf, amount, 0,
 					 cmdiu, 0, be16_to_cpup(&cmdiu->tag),
 					 uasp_bulk_out_complete, udev->op_mode);
-			DBG(udev->ucommon->common, "%s() fill_usb_request for"
+			DBG(udev->ucommon, "%s() fill_usb_request for"
 						   " out endpoint, amout = %d",
 				__func__, amount);
 
-			cmdiu->ep = udev->fsg_dev.bulk_out;
+			cmdiu->ep = udev->bulk_out;
 			cmdiu->req_sts = CMD_REQ_IN_PROGRESS;
 			rc = 2;
 			break;
@@ -1577,7 +1582,7 @@ get_more_data:	if (cmdiu->req_sts == CMD_REQ_NOT_SUBMITTED) {
 				 * request for this command, we should abort
 				 * all submitted requests for this command
 				 */
-				DBG(udev->ucommon->common,
+				DBG(udev->ucommon,
 				    "%s() - Host aborted the command\n",
 				    __func__);
 				goto send_status;
@@ -1586,7 +1591,7 @@ get_more_data:	if (cmdiu->req_sts == CMD_REQ_NOT_SUBMITTED) {
 			amount = req->actual;
 			if (curlun->lun->file_length - cmdiu->file_offset <
 				amount) {
-				ERROR(udev->ucommon->common,
+				ERROR(udev->ucommon,
 				      "%s(): write %u @ %llu beyond end %llu\n",
 				      __func__, amount,
 				      (unsigned long long)cmdiu->file_offset,
@@ -1601,18 +1606,18 @@ get_more_data:	if (cmdiu->req_sts == CMD_REQ_NOT_SUBMITTED) {
 			nwritten = vfs_write(curlun->lun->filp,
 					(char __user *) bh->buf,
 					amount, &file_offset_tmp);
-			DBG(udev->ucommon->common,
+			DBG(udev->ucommon,
 			    "%s(): file write %u @ %llu -> %d\n", __func__,
 			    amount, (unsigned long long)cmdiu->file_offset,
 					(int)nwritten);
 
 			if (nwritten < 0) {
-				ERROR(udev->ucommon->common,
+				ERROR(udev->ucommon,
 				      "%s(): error in file write: %d\n",
 				      __func__, (int)nwritten);
 				nwritten = 0;
 			} else if (nwritten < amount) {
-				DBG(udev->ucommon->common,
+				DBG(udev->ucommon,
 				      "%s(): partial file write: %d/%u\n",
 				    __func__, (int)nwritten, amount);
 				nwritten -= (nwritten & 511);
@@ -1633,7 +1638,7 @@ get_more_data:	if (cmdiu->req_sts == CMD_REQ_NOT_SUBMITTED) {
 			}
 
 			if (cmdiu->xfer_len == 0) {
-				DBG(udev->ucommon->common,
+				DBG(udev->ucommon,
 				      "%s() - cmdiu->xferlen = 0, "
 				      "send status\n", __func__);
 				goto send_status;
@@ -1657,7 +1662,7 @@ send_status:
 		break;
 	}
 
-	DBG(udev->ucommon->common, "%s() - Exit\n", __func__);
+	DBG(udev->ucommon, "%s() - Exit\n", __func__);
 	return rc;
 }
 
@@ -1682,7 +1687,7 @@ static int do_uasp_synchronize_cache(struct uasp_dev *udev,
 	uint8_t status = STATUS_GOOD;
 	int rc;
 
-	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+	DBG(udev->ucommon, "%s() - Enter\n", __func__);
 
 	/* Check is cmdiu is filled correctly */
 	sense = check_cmdiu(udev, curlun, cmdiu, 0);
@@ -1707,7 +1712,7 @@ static int do_uasp_synchronize_cache(struct uasp_dev *udev,
 		 udev->op_mode);
 	cmdiu->ep = udev->status;
 
-	DBG(udev->ucommon->common, "%s() - Exit\n", __func__);
+	DBG(udev->ucommon, "%s() - Exit\n", __func__);
 	return 1;
 }
 
@@ -1727,11 +1732,11 @@ static void process_cmdiu(struct uasp_dev *udev,
 	struct usb_request *req;
 	int rc = 0;
 
-	DBG(udev->ucommon->common, "%s() Enter. (cmdiu->cdb[0]=%04x)\n",
+	DBG(udev->ucommon, "%s() Enter. (cmdiu->cdb[0]=%04x)\n",
 	    __func__, cmdiu->cdb[0]);
 
 	/* We're using the backing file */
-	down_read(&udev->ucommon->common->filesem);
+	down_read(&udev->ucommon->filesem);
 	switch (cmdiu->cdb[0]) {
 	case INQUIRY:
 		rc = do_uasp_inquiry(udev, curlun, cmdiu);
@@ -1781,7 +1786,7 @@ static void process_cmdiu(struct uasp_dev *udev,
 	case RESERVE:
 	case SEND_DIAGNOSTIC:
 	default:
-		ERROR(udev->ucommon->common,
+		ERROR(udev->ucommon,
 		      "%s(): Unsupported  command = %x\n",
 		    __func__, cmdiu->cdb[0]);
 		cmdiu->state = COMMAND_STATE_STATUS;
@@ -1798,7 +1803,7 @@ static void process_cmdiu(struct uasp_dev *udev,
 		break;
 	}
 
-	up_read(&udev->ucommon->common->filesem);
+	up_read(&udev->ucommon->filesem);
 	if (rc) {
 		if (rc == 1) {
 			req = cmdiu->bh->inreq;
@@ -1808,11 +1813,11 @@ static void process_cmdiu(struct uasp_dev *udev,
 			cmdiu->bh->outreq_busy = 1;
 		}
 		if (usb_ep_queue(cmdiu->ep, req, 0)) {
-			ERROR(udev->ucommon->common,
+			ERROR(udev->ucommon,
 			      "%s()usb_ep_queue failed\n",  __func__);
 			cmdiu->state = COMMAND_STATE_FAILED;
 		} else {
-			DBG(udev->ucommon->common,
+			DBG(udev->ucommon,
 			    "%s() - process_cmdiu: queued req to ep\n",
 			    __func__);
 			if (curlun) {
@@ -1821,10 +1826,10 @@ static void process_cmdiu(struct uasp_dev *udev,
 				spin_unlock_irqrestore(&(curlun->lock), flags);
 			} else {
 				spin_lock_irqsave(
-					&(udev->ucommon->common->lock), flags);
+					&(udev->ucommon->lock), flags);
 				udev->active_requests++;
 				spin_unlock_irqrestore(
-					&(udev->ucommon->common->lock), flags);
+					&(udev->ucommon->lock), flags);
 			}
 		}
 	}
@@ -1843,7 +1848,7 @@ void do_cmdiu(struct uasp_dev *udev, struct uasp_lun *curlun)
 	struct cmd_iu *cmdiu, *tmp;
 	unsigned long flags;
 
-	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+	DBG(udev->ucommon, "%s() - Enter\n", __func__);
 
 	/* Select the cmd_queue from which cmdius should be processed */
 	if (curlun)
@@ -1852,18 +1857,18 @@ void do_cmdiu(struct uasp_dev *udev, struct uasp_lun *curlun)
 		link = &udev->cmd_queue;
 
 	list_for_each_entry_safe(cmdiu, tmp, link, node) {
-		DBG(udev->ucommon->common, "%s() - Rolling over cmdiu queue\n",
+		DBG(udev->ucommon, "%s() - Rolling over cmdiu queue\n",
 		     __func__);
 
-		spin_lock_irqsave(&(udev->ucommon->common->lock), flags);
+		spin_lock_irqsave(&(udev->ucommon->lock), flags);
 		if (cmdiu->state == COMMAND_STATE_IDLE) {
 			/* Try to get buffers for cmdiu processing */
-			cmdiu->bh = get_buffhd(udev->ucommon->common->buffhds);
-			spin_unlock_irqrestore(&(udev->ucommon->common->lock),
+			cmdiu->bh = get_buffhd(udev->ucommon->ubufs);
+			spin_unlock_irqrestore(&(udev->ucommon->lock),
 					       flags);
 
 			if (!cmdiu->bh) {
-				ERROR(udev->ucommon->common,
+				ERROR(udev->ucommon,
 				      "%s() -Didn't manage to get buffers for "
 				      "cmdiu!\n", __func__);
 				continue;
@@ -1872,15 +1877,14 @@ void do_cmdiu(struct uasp_dev *udev, struct uasp_lun *curlun)
 			   cmdiu->state == COMMAND_STATE_RR_WR) {
 			if (cmdiu->req_sts == CMD_REQ_COMPLETED)
 				spin_unlock_irqrestore(
-					&(udev->ucommon->common->lock), flags);
+					&(udev->ucommon->lock), flags);
 			else {
 				spin_unlock_irqrestore(
-					&(udev->ucommon->common->lock), flags);
+					&(udev->ucommon->lock), flags);
 				continue;
 			}
 		} else {
-			spin_unlock_irqrestore(&(udev->ucommon->common->lock),
-					       flags);
+			spin_unlock_irqrestore(&(udev->ucommon->lock), flags);
 			continue;
 		}
 
diff --git a/drivers/usb/gadget/uasp_tmiu.c b/drivers/usb/gadget/uasp_tmiu.c
index 5f70424..8f8fd86 100644
--- a/drivers/usb/gadget/uasp_tmiu.c
+++ b/drivers/usb/gadget/uasp_tmiu.c
@@ -32,7 +32,7 @@ void fill_response_iu(struct uasp_dev *udev,
 	       uint32_t resp_info,
 	       uint8_t status)
 {
-	DBG(udev->ucommon->common, "%s() - Enter. Status = %02x\n", __func__,
+	DBG(udev->ucommon, "%s() - Enter. Status = %02x\n", __func__,
 	    status);
 	riu->iu_id = IU_ID_RESPONSE;
 	riu->reserved = 0;
@@ -61,7 +61,7 @@ static void reset_lun(struct uasp_dev *udev,
 	uint8_t status;
 	unsigned long flags;
 
-	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+	DBG(udev->ucommon, "%s() - Enter\n", __func__);
 
 	riu = (struct response_iu *)tmiu->bh->buf;
 	if (!curlun) {
@@ -108,7 +108,7 @@ static void abort_task(struct uasp_dev *udev,
 	unsigned long flags;
 	uint8_t status;
 
-	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+	DBG(udev->ucommon, "%s() - Enter\n", __func__);
 	riu = (struct response_iu *)tmiu->bh->buf;
 	if (!curlun) {
 		status = RESPONSE_INCORRECT_LUN;
@@ -121,7 +121,7 @@ static void abort_task(struct uasp_dev *udev,
 			goto found;
 
 	/* Command with specified ipt_tag not found */
-	DBG(udev->ucommon->common, "%s(): cmdiu with tag %04x wasn't found\n",
+	DBG(udev->ucommon, "%s(): cmdiu with tag %04x wasn't found\n",
 	    __func__, tmiu->task_tag);
 	cmdiu = 0;
 
@@ -177,7 +177,7 @@ static void abort_task_set(struct uasp_dev *udev,
 	uint8_t status;
 	unsigned long flags;
 
-	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+	DBG(udev->ucommon, "%s() - Enter\n", __func__);
 
 	riu = (struct response_iu *)tmiu->bh->buf;
 	if (!curlun) {
@@ -215,7 +215,7 @@ static void reset_nexus(struct uasp_dev *udev,
 	uint8_t status;
 	int rc = 0;
 
-	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+	DBG(udev->ucommon, "%s() - Enter\n", __func__);
 
 	riu = (struct response_iu *)tmiu->bh->buf;
 
@@ -226,26 +226,27 @@ static void reset_nexus(struct uasp_dev *udev,
 	 * Sleep if luns are in processing
 	 */
 	while (!all_lun_state_non_processing(udev)) {
-		DBG(udev->ucommon->common,
+		DBG(udev->ucommon,
 		    "%s() - Luns are in process. Going to sleep\n", __func__);
-		rc = sleep_thread(udev->ucommon->common);
+		rc = uasp_sleep_thread(udev->ucommon);
 		if (rc) {
-			ERROR(udev->ucommon->common,
-			      "%s() - sleep_thread failed! (%d)", __func__, rc);
+			ERROR(udev->ucommon,
+			      "%s() - uasp_sleep_thread failed! (%d)",
+			      __func__, rc);
 			status = RESPONSE_TM_FUNCTION_FAILED;
 			goto reset_nexus_fill_response;
 		}
-		DBG(udev->ucommon->common, "%s() - Wakes up\n", __func__);
+		DBG(udev->ucommon, "%s() - Wakes up\n", __func__);
 		rc = 0;
 	}
 
 	/* Abort general commands and tmius */
 	abort_commands(udev, &udev->cmd_queue, &udev->tm_func_queue,
-		       &(udev->ucommon->common->lock));
+		       &(udev->ucommon->lock));
 
-	spin_lock_irqsave(&(udev->ucommon->common->lock), flags);
+	spin_lock_irqsave(&(udev->ucommon->lock), flags);
 	udev->pending_requests = 0;
-	spin_unlock_irqrestore(&(udev->ucommon->common->lock), flags);
+	spin_unlock_irqrestore(&(udev->ucommon->lock), flags);
 
 	status = RESPONSE_TM_FUNCTION_COMPLETE;
 reset_nexus_fill_response:
@@ -255,7 +256,7 @@ reset_nexus_fill_response:
 			 0, (void *)tmiu, 0, be16_to_cpup(&tmiu->tag),
 			 status_complete, udev->op_mode);
 	tmiu->ep = udev->status;
-	DBG(udev->ucommon->common, "%s() - Exit\n", __func__);
+	DBG(udev->ucommon, "%s() - Exit\n", __func__);
 }
 
 /**
@@ -277,7 +278,7 @@ static void query_unit_attention(struct uasp_dev *udev,
 	uint8_t status;
 	uint32_t resp_info = 0;
 
-	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+	DBG(udev->ucommon, "%s() - Enter\n", __func__);
 	riu = (struct response_iu *)tmiu->bh->buf;
 	if (!curlun) {
 		status = RESPONSE_INCORRECT_LUN;
@@ -324,7 +325,7 @@ static void query_task(struct uasp_dev *udev,
 	unsigned long flags;
 	uint8_t status = RESPONSE_TM_FUNCTION_COMPLETE;
 
-	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+	DBG(udev->ucommon, "%s() - Enter\n", __func__);
 	riu = (struct response_iu *)tmiu->bh->buf;
 	if (!curlun) {
 		status = RESPONSE_INCORRECT_LUN;
@@ -371,7 +372,7 @@ static void query_task_set(struct uasp_dev *udev,
 	unsigned long flags;
 	uint8_t status;
 
-	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+	DBG(udev->ucommon, "%s() - Enter\n", __func__);
 	riu = (struct response_iu *)tmiu->bh->buf;
 	if (!curlun) {
 		status = RESPONSE_INCORRECT_LUN;
@@ -400,7 +401,7 @@ q_task_set_fill_response:
 			 0, (void *)tmiu, 0, be16_to_cpup(&tmiu->tag),
 			 status_complete, udev->op_mode);
 	tmiu->ep = udev->status;
-	DBG(udev->ucommon->common, "%s() - Exit\n", __func__);
+	DBG(udev->ucommon, "%s() - Exit\n", __func__);
 }
 
 /**
@@ -448,7 +449,7 @@ static void process_tmiu(struct uasp_dev *udev,
 		break;
 
 	default:
-		ERROR(udev->ucommon->common, "%s(): Unsupported  tmiu = %x\n",
+		ERROR(udev->ucommon, "%s(): Unsupported  tmiu = %x\n",
 		    __func__, tmiu->tm_function);
 		riu = (struct response_iu *)tmiu->bh->inreq->buf;
 		fill_response_iu(udev, riu, tmiu->tag, 0,
@@ -464,8 +465,7 @@ static void process_tmiu(struct uasp_dev *udev,
 
 	tmiu->state = COMMAND_STATE_STATUS;
 	if (usb_ep_queue(tmiu->ep, tmiu->bh->inreq, 0)) {
-		ERROR(udev->ucommon->common,
-			      "%s()usb_ep_queue failed\n",  __func__);
+		ERROR(udev->ucommon, "%s()usb_ep_queue failed\n",  __func__);
 		tmiu->state = COMMAND_STATE_FAILED;
 	} else {
 		tmiu->bh->inreq_busy = 1;
@@ -474,10 +474,10 @@ static void process_tmiu(struct uasp_dev *udev,
 			curlun->active_requests++;
 			spin_unlock_irqrestore(&(curlun->lock), flags);
 		} else {
-			spin_lock_irqsave(&(udev->ucommon->common->lock),
+			spin_lock_irqsave(&(udev->ucommon->lock),
 					  flags);
 			udev->active_requests++;
-			spin_unlock_irqrestore(&(udev->ucommon->common->lock),
+			spin_unlock_irqrestore(&(udev->ucommon->lock),
 					       flags);
 		}
 	}
@@ -497,7 +497,7 @@ void do_tmiu(struct uasp_dev *udev, struct uasp_lun *curlun)
 	struct tm_iu *tmiu, *tmp;
 	unsigned long flags;
 
-	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+	DBG(udev->ucommon, "%s() - Enter\n", __func__);
 
 	/* Select the tm_func_queue from which tmius should be processed */
 	if (curlun)
@@ -505,19 +505,19 @@ void do_tmiu(struct uasp_dev *udev, struct uasp_lun *curlun)
 	else
 		link = &udev->tm_func_queue;
 
-	DBG(udev->ucommon->common, "%s() - Rolling over tmiu queue\n",
+	DBG(udev->ucommon, "%s() - Rolling over tmiu queue\n",
 	     __func__);
 	list_for_each_entry_safe(tmiu, tmp, link, node) {
 		if (tmiu->state != COMMAND_STATE_IDLE)
 			continue;
 
 		/* Try to get buffer for tmiu provessing */
-		spin_lock_irqsave(&(udev->ucommon->common->lock), flags);
-		tmiu->bh = get_buffhd(udev->ucommon->common->buffhds);
-		spin_unlock_irqrestore(&(udev->ucommon->common->lock), flags);
+		spin_lock_irqsave(&(udev->ucommon->lock), flags);
+		tmiu->bh = get_buffhd(udev->ucommon->ubufs);
+		spin_unlock_irqrestore(&(udev->ucommon->lock), flags);
 
 		if (!tmiu->bh) {
-			ERROR(udev->ucommon->common,
+			ERROR(udev->ucommon,
 			      "%s() -Didnt manage to get buffers for tmiu!\n",
 			      __func__);
 			continue;
-- 
1.7.6

--
Sent by a Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum
