Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341Ab1DNNg3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 09:36:29 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:26697 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932181Ab1DNNgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 09:36:25 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6315"; a="85777155"
From: Tatyana Brokhman <tlinder@codeaurora.org>
To: gregkh@suse.de
Cc: linux-arm-msm@vger.kernel.org, ablay@codeaurora.org, balbi@ti.com,
        Tatyana Brokhman <tlinder@codeaurora.org>,
        linux-usb@vger.kernel.org (open list:USB GADGET/PERIPH...),
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC/PATCH v3 2/5] uas: MS UAS Gadget driver - Infrastructure
Date: Thu, 14 Apr 2011 16:36:15 +0300
Message-Id: <1302788176-27972-1-git-send-email-tlinder@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements the infrastructure for the UAS gadget driver.
The UAS gadget driver registers as a second configuration of the MS
gadet driver.

A new module parameter was added to the mass_storage module:
bool use_uasp. (default = 0)
If this parameter is set to true, the mass_storage module will register
with the UAS configuration as the devices first configuration and
operate according to the UAS protocol.

The number of buffers used by the mass_storage device was increased
according to the number of supported streams.

It defines the API for COMMAND/TASK MANAGEMENT IU implementation.

Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index a688d04..e79ac84 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -2734,7 +2734,8 @@ static inline void fsg_common_put(struct fsg_common *common)
 
 static struct fsg_common *fsg_common_init(struct fsg_common *common,
 					  struct usb_composite_dev *cdev,
-					  struct fsg_config *cfg)
+					  struct fsg_config *cfg,
+					  int start_thread)
 {
 	struct usb_gadget *gadget = cdev->gadget;
 	struct fsg_buffhd *bh;
@@ -2883,12 +2884,14 @@ buffhds_first_it:
 	kref_init(&common->ref);
 
 	/* Tell the thread to start working */
-	common->thread_task =
-		kthread_create(fsg_main_thread, common,
+	if (start_thread) {
+		common->thread_task =
+			kthread_create(fsg_main_thread, common,
 			       cfg->thread_name ?: "file-storage");
-	if (IS_ERR(common->thread_task)) {
-		rc = PTR_ERR(common->thread_task);
-		goto error_release;
+		if (IS_ERR(common->thread_task)) {
+			rc = PTR_ERR(common->thread_task);
+			goto error_release;
+		}
 	}
 	init_completion(&common->thread_notifier);
 	init_waitqueue_head(&common->fsg_wait);
@@ -2919,10 +2922,11 @@ buffhds_first_it:
 	}
 	kfree(pathbuf);
 
-	DBG(common, "I/O thread pid: %d\n", task_pid_nr(common->thread_task));
-
-	wake_up_process(common->thread_task);
-
+	if (start_thread) {
+		DBG(common, "I/O thread pid: %d\n",
+		    task_pid_nr(common->thread_task));
+		wake_up_process(common->thread_task);
+	}
 	return common;
 
 error_luns:
@@ -3190,6 +3194,6 @@ fsg_common_from_params(struct fsg_common *common,
 {
 	struct fsg_config cfg;
 	fsg_config_from_params(&cfg, params);
-	return fsg_common_init(common, cdev, &cfg);
+	return fsg_common_init(common, cdev, &cfg, 1);
 }
 
diff --git a/drivers/usb/gadget/f_uasp.c b/drivers/usb/gadget/f_uasp.c
new file mode 100644
index 0000000..7b1e2bd
--- /dev/null
+++ b/drivers/usb/gadget/f_uasp.c
@@ -0,0 +1,2399 @@
+/*
+ * f_uasp.c -- Mass Storage USB UASP Composite Function
+ *
+ * Copyright (C) 2003-2005 Alan Stern
+ * Copyright (C) 2011 Code Aurora Forum.
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+/*
+ *  The UASP Function acts as a USB Mass Storage device, appearing to the
+ * host as a disk drive or as a CD-ROM drive. In contrary to
+ * f_mass_storage function that implements the BOT protocol, the UASP
+ * function implements the UAS Protocol.
+ * It's operational both in High and Super connection speeds.
+ * Streaming support depends on the DCD streaming capabilities.
+ *
+ * The Function supports multiple logical units (LUNs).  Backing storage
+ * for each LUN is provided by a regular file or a block device. Access
+ * for each LUN can be limited to read-only.  Moreover, the function can
+ * indicate that LUN is removable and/or CD-ROM.  (The later implies
+ * read-only access.)
+ *
+ * Requirements from the system are:
+ * - 2 bulk-in and 2 bulk-out endpoints are needed.
+ * - The number of buffers used by the Function depends on whether
+ *   streaming is supported by the DCD or not. If streaming is not
+ *   supported then the minimum number of buffers used by the UASP
+ *   function is 4 - one for each endpoint, when the buffer for the
+ *   command endpoint is allocated statically and is dedicated to the
+ *   command endpoint only.
+ *   If streaming is supported then the number of required buffers
+ *   equals num_of_streams * 4.
+ *   The size of each buffer is 16K by default and is configurable
+ *   by a parameter.
+ *
+ * Note that the driver is slightly non-portable in that it assumes that
+ * the same memory/DMA buffer my be used both for bulk-in and bulk-out
+ * endpoints. With most device controllers this isn't an issue, but there
+ * may be some with hardware restrictions that prevent a buffer from being
+ * used by more than one endpoint.
+ *
+ * This function is heavily based on "Mass Storage USB Composite Function" by
+ * Michal Nazarewicz which is based based on "File-backed Storage Gadget" by
+ * Alan Stern which in turn is heavily based on "Gadget Zero" by David
+ * Brownell.  The driver's SCSI command interface was based on the
+ * "Information technology - Small Computer System Interface - 2"
+ * document from X3T9.2 Project 375D, Revision 10L, 7-SEP-93,
+ * available at <http://www.t10.org/ftp/t10/drafts/s2/s2-r10l.pdf>.
+ * The single exception is opcode 0x23 (READ FORMAT CAPACITIES), which
+ * was based on the "Universal Serial Bus Mass Storage Class UFI
+ * Command Specification" document, Revision 1.0, December 14, 1998,
+ * available at
+ * <http://www.usb.org/developers/devclass_docs/usbmass-ufi10.pdf>.
+ */
+
+/*
+ *				Driver Design
+ *
+ * The UASP Function driver registers as a second configuration to the
+ * mass_storage module. In the enumeration if the host wishes to use the
+ * UAS protocol it sends a SET_CONFIGURATION command and chooses the UASP
+ * configuration.
+ * The UASP function driver inherits from the Mass Storage Function
+ * driver and extends it according to UASP requirements.
+ *
+ * All of the control/status transfers in UASP are performed in form of
+ * IUs (Information Units. See section 6.2 of the UASP Spec). The
+ * command/data/status parts of the SCSI protocol are replaced by:
+ * - command IU / task management IU
+ * - data phase
+ * - sense IU / response IU
+ * Each command / task management is handled by the main thread (if not
+ * LUN specific) or by the specific LUN thread, if such LUN exists. Each
+ * of the threads (generic and LUN specific) implements the above
+ * host/device interaction.
+ *
+ * The guiding line through the design was to inherit as much as possible
+ * from already existing f_mass_storage driver since the UASP protocol
+ * extends the already existing BOT protocol. Re-using already
+ * implemented (by the f_mass_storage driver) functions as is wasn't
+ * always possible and a code duplication was forced. In order to clean
+ * this up all the SCSI command handling should be taken out to a
+ * different file both from the UASP driver and from the f_mass_storage
+ * driver, leaving the later two to handle just the UASP/BOT protocols
+ * and not the SCSI protocol. By doing so code duplication will be spared.
+ *
+ * An alternative design would have been to implement the USP driver from
+ * scratch, without the inheritance from f_mass_storage. The pros of this
+ * approach would have been that the existing f_mass_storage driver would
+ * remain as is (without any modifications whatsoever). On the other hand
+ * the cons were:
+ * 1. A separate mechanism would be required to indicate which one of the
+ *    drivers to load when connecting to a host according to the hosts
+ *    capability to support UASP. In the chosen approach this decision is
+ *    left to the host to choose the configuration it wishes to operate
+ *    in.
+ * 2. Code/data structures duplication. As already mentioned, the UASP
+ *    protocol extends the BOT protocol implemented by the f_mass_storage
+ *    driver, thus the two are similar in their data structures and basic
+ *    functionality.
+ * We decided to leave this to a second phase of the development in order
+ * to leave the existing f_mass_storage driver with as less changes as
+ * possible.
+ *
+ * The handling of command IUs and task management IUs was divided into
+ * two separate files that are both included by the f_uasp driver.
+ *
+ * Several kernel threads are created as part of the init sequence:
+ * - UASP main thread
+ * - A thread for each of the existing LUNs
+ * The UASP main thread handles all of the generic commands/task
+ * management requests and routes LUN specific requests to be handled by
+ * the appropriate LUNs task.
+ * The approach of "task per LUN" was chosen due to the UAS protocol
+ * enhancement over the BOT protocol. The main retouch of the UAS
+ * protocol of the BOT protocol is the fact that independent commands can
+ * be performed in parallel. For example a READ command for two different
+ * LUNS. Thus in order to implement this concurrency a separate thread is
+ * needed for each of the existing LUNS.
+ * As long as the LUN threads are alive they keep an open reference to the
+ * backing file. This prevents the unmounting of the backing file's
+ * underlying file system and cause problems during system shutdown.
+ *
+ * In the existing f_mass_storage common data structures a single lock is
+ * used for protecting the state of the driver USB requests handled by it.
+ * Since a separate thread was created for each LUN, allowing it to handle
+ * requests addressed to it, the same protection mechanism was required.
+ * Thus a lock was added to each of the LUNS to protect the LUNs state and
+ * the IUs (USB requests) handled by that LUN.
+ *
+ * Interrupt routines field callbacks from controller driver:
+ * - bulk-in, bulk-out, command and status request notifications
+ * - disconnect events
+ * Completion requests are passed to the appropriate thread by wake up
+ * calls. Most of the ep0 requests are handled at interrupt time except
+ * for the following:
+ * - SetInterface
+ * - SetConfiguration
+ * - Device reset
+ * The above are handled by the main thread and are passed to it in form
+ * of "exceptions" using SIGUSR1 signal (since they should interrupt any
+ * ongoing I/O operations).
+ *
+ * In normal operation the main thread is created during UASP_bind but
+ * started only when the UASP configuration is choosen. This is necessary
+ * since msg main thread is also created during msg_bind but since UASP
+ * Function inherits from the Mass Storage Function, the running thread
+ * (UASP or msg) will be saved in a data structure that is shared by UASP
+ * and msg.
+ * The main thread is stopped during unbind but can also be stopped when
+ * it receives a signal. There is no point in leaving the gadget if the
+ * main thread is dead but this is not implemented yet. Maybe a callback
+ * function is needed.
+ *
+ * To provide maximum throughput the driver uses a circular pipeline of
+ * buffer heads (struct fsg_buffhd in which each of the buffers is linked
+ * in a 1:1 connection to an element of struct uasp_buf). Each buffer head
+ * contains a bulk-in and bulk-out requests and thus can be used both for
+ * IN and OUT transfers.
+ * The usage of the pipe line is similar to it's usage by the Mass Storage
+ * Function.
+ */
+
+#include <linux/device.h>
+#include <linux/fcntl.h>
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/kref.h>
+#include <linux/kthread.h>
+#include <linux/string.h>
+#include <linux/usb/ch9.h>
+#include <linux/usb/gadget.h>
+#include <linux/kernel.h>
+#include <linux/usb/storage.h>
+
+#include "uasp_cmdiu.c"
+#include "uasp_tmiu.c"
+
+/* Descriptors */
+
+/* There is only one interface. */
+static struct usb_interface_descriptor
+uasp_intf_desc = {
+	.bLength =		sizeof uasp_intf_desc,
+	.bDescriptorType =	USB_DT_INTERFACE,
+
+	.bNumEndpoints =	4,
+	.bInterfaceClass =	USB_CLASS_MASS_STORAGE,
+	.bInterfaceSubClass =	USB_SC_SCSI,
+	.bInterfaceProtocol =	USB_PR_UAS,
+	.iInterface =		FSG_STRING_INTERFACE,
+};
+
+/* BULK-in pipe descriptors */
+static struct usb_endpoint_descriptor
+uasp_bulk_in_desc = {
+	.bLength =		USB_DT_ENDPOINT_SIZE,
+	.bDescriptorType =	USB_DT_ENDPOINT,
+	.bEndpointAddress =	USB_DIR_IN,
+	.bmAttributes =		USB_ENDPOINT_XFER_BULK,
+	.wMaxPacketSize =	cpu_to_le16(512),
+};
+
+struct usb_pipe_usage_descriptor
+uasp_bulk_in_pipe_usg_desc = {
+	.bLength =		sizeof uasp_bulk_in_pipe_usg_desc,
+	.bDescriptorType =	USB_DT_PIPE_USAGE,
+	.bPipeID =		PIPE_ID_DATA_IN,
+	.Reserved =		0,
+};
+
+struct usb_endpoint_descriptor
+uasp_ss_bulk_in_desc = {
+	.bLength =		USB_DT_ENDPOINT_SIZE,
+	.bDescriptorType =	USB_DT_ENDPOINT,
+	.bEndpointAddress =	USB_DIR_IN,
+	.bmAttributes =		USB_ENDPOINT_XFER_BULK,
+	.wMaxPacketSize =	cpu_to_le16(0x400),
+};
+
+struct usb_ss_ep_comp_descriptor
+uasp_bulk_in_ep_comp_desc = {
+	.bLength =		sizeof uasp_bulk_in_ep_comp_desc,
+	.bDescriptorType =	USB_DT_SS_ENDPOINT_COMP,
+	.bMaxBurst =		0, /*
+				    * Doesn't support burst. Maybe update later?
+				    * Should it be HW dependent?
+				    */
+	.bmAttributes =		UASP_SS_EP_COMP_NUM_STREAMS,
+	.wBytesPerInterval =	0,
+};
+
+/* BULK-out pipe descriptors */
+struct usb_endpoint_descriptor
+uasp_bulk_out_desc = {
+	.bLength =		USB_DT_ENDPOINT_SIZE,
+	.bDescriptorType =	USB_DT_ENDPOINT,
+	.bEndpointAddress =	USB_DIR_OUT,
+	.bmAttributes =		USB_ENDPOINT_XFER_BULK,
+	.wMaxPacketSize =	cpu_to_le16(512),
+};
+
+struct usb_pipe_usage_descriptor
+uasp_bulk_out_pipe_usg_desc = {
+	.bLength =		sizeof uasp_bulk_out_pipe_usg_desc,
+	.bDescriptorType =	USB_DT_PIPE_USAGE,
+	.bPipeID =		PIPE_ID_DATA_OUT,
+	.Reserved =		0,
+};
+
+struct usb_endpoint_descriptor
+uasp_ss_bulk_out_desc = {
+	.bLength =		USB_DT_ENDPOINT_SIZE,
+	.bDescriptorType =	USB_DT_ENDPOINT,
+	.bEndpointAddress =	USB_DIR_OUT,
+	.bmAttributes =		USB_ENDPOINT_XFER_BULK,
+	.wMaxPacketSize =	cpu_to_le16(0x400),
+};
+
+struct usb_ss_ep_comp_descriptor
+uasp_bulk_out_ep_comp_desc = {
+	.bLength =		sizeof uasp_bulk_out_ep_comp_desc,
+	.bDescriptorType =	USB_DT_SS_ENDPOINT_COMP,
+	.bMaxBurst =		0, /*
+				    * Doesn't support burst. Maybe update later?
+				    * Should it be HW dependent?
+				    */
+	.bmAttributes =		UASP_SS_EP_COMP_NUM_STREAMS,
+	.wBytesPerInterval =	0,
+};
+
+/* Status pipe - descriptors */
+struct usb_endpoint_descriptor
+uasp_status_in_desc = {
+	.bLength =		USB_DT_ENDPOINT_SIZE,
+	.bDescriptorType =	USB_DT_ENDPOINT,
+	.bEndpointAddress =	USB_DIR_IN,
+	.bmAttributes =		USB_ENDPOINT_XFER_BULK,
+	.wMaxPacketSize =	cpu_to_le16(512),
+};
+
+struct usb_pipe_usage_descriptor
+uasp_status_in_pipe_usg_desc = {
+	.bLength =		sizeof uasp_status_in_pipe_usg_desc,
+	.bDescriptorType =	USB_DT_PIPE_USAGE,
+	.bPipeID =		PIPE_ID_STS,
+	.Reserved =		0,
+};
+
+struct usb_endpoint_descriptor
+uasp_ss_status_in_desc = {
+	.bLength =		USB_DT_ENDPOINT_SIZE,
+	.bDescriptorType =	USB_DT_ENDPOINT,
+	.bEndpointAddress =	USB_DIR_IN,
+	.bmAttributes =		USB_ENDPOINT_XFER_BULK,
+	.wMaxPacketSize =	cpu_to_le16(0x400),
+};
+
+struct usb_ss_ep_comp_descriptor
+uasp_status_in_ep_comp_desc = {
+	.bLength =		sizeof uasp_status_in_ep_comp_desc,
+	.bDescriptorType =	USB_DT_SS_ENDPOINT_COMP,
+	.bMaxBurst =		0, /*
+				    * Doesn't support burst. Maybe update later?
+				    * Should it be HW dependent?
+				    */
+	.bmAttributes =		UASP_SS_EP_COMP_NUM_STREAMS,
+	.wBytesPerInterval =	0,
+};
+
+/* Command pipe descriptors */
+struct usb_endpoint_descriptor
+uasp_command_out_desc = {
+	.bLength =		USB_DT_ENDPOINT_SIZE,
+	.bDescriptorType =	USB_DT_ENDPOINT,
+	.bEndpointAddress =	USB_DIR_OUT,
+	.bmAttributes =		USB_ENDPOINT_XFER_BULK,
+	.wMaxPacketSize =	cpu_to_le16(512),
+};
+
+struct usb_pipe_usage_descriptor
+uasp_command_out_pipe_usg_desc = {
+	.bLength =		sizeof uasp_command_out_pipe_usg_desc,
+	.bDescriptorType =	USB_DT_PIPE_USAGE,
+	.bPipeID =		PIPE_ID_CMD,
+	.Reserved =		0,
+};
+
+struct usb_endpoint_descriptor
+uasp_ss_command_out_desc = {
+	.bLength =		USB_DT_ENDPOINT_SIZE,
+	.bDescriptorType =	USB_DT_ENDPOINT,
+	.bEndpointAddress =	USB_DIR_OUT,
+	.bmAttributes =		USB_ENDPOINT_XFER_BULK,
+	.wMaxPacketSize =	cpu_to_le16(0x400),
+};
+
+struct usb_ss_ep_comp_descriptor
+uasp_command_out_ep_comp_desc = {
+	.bLength =		sizeof uasp_command_out_ep_comp_desc,
+	.bDescriptorType =	USB_DT_SS_ENDPOINT_COMP,
+	.bMaxBurst =		0, /*
+				    * Doesn't support burst. Maybe update later?
+				    * Should it be HW dependent?
+				    */
+	.bmAttributes =		0, /* No streams on command endpoint */
+	.wBytesPerInterval =	0,
+};
+
+/* HS configuration function descriptors */
+struct usb_descriptor_header *uasp_hs_function_desc[] = {
+	(struct usb_descriptor_header *) &uasp_intf_desc,
+	(struct usb_descriptor_header *) &uasp_bulk_in_desc,
+	(struct usb_descriptor_header *) &uasp_bulk_in_pipe_usg_desc,
+	(struct usb_descriptor_header *) &uasp_bulk_out_desc,
+	(struct usb_descriptor_header *) &uasp_bulk_out_pipe_usg_desc,
+	(struct usb_descriptor_header *) &uasp_status_in_desc,
+	(struct usb_descriptor_header *) &uasp_status_in_pipe_usg_desc,
+	(struct usb_descriptor_header *) &uasp_command_out_desc,
+	(struct usb_descriptor_header *) &uasp_command_out_pipe_usg_desc,
+	NULL,
+};
+
+/* SS configuration function descriptors */
+struct usb_descriptor_header *uasp_ss_function_desc[] = {
+	(struct usb_descriptor_header *) &uasp_intf_desc,
+	(struct usb_descriptor_header *) &uasp_ss_bulk_in_desc,
+	(struct usb_descriptor_header *) &uasp_bulk_in_ep_comp_desc,
+	(struct usb_descriptor_header *) &uasp_bulk_in_pipe_usg_desc,
+	(struct usb_descriptor_header *) &uasp_ss_bulk_out_desc,
+	(struct usb_descriptor_header *) &uasp_bulk_out_ep_comp_desc,
+	(struct usb_descriptor_header *) &uasp_bulk_out_pipe_usg_desc,
+	(struct usb_descriptor_header *) &uasp_ss_status_in_desc,
+	(struct usb_descriptor_header *) &uasp_status_in_ep_comp_desc,
+	(struct usb_descriptor_header *) &uasp_status_in_pipe_usg_desc,
+	(struct usb_descriptor_header *) &uasp_ss_command_out_desc,
+	(struct usb_descriptor_header *) &uasp_command_out_ep_comp_desc,
+	(struct usb_descriptor_header *) &uasp_command_out_pipe_usg_desc,
+	NULL,
+};
+
+/*--------------------------------------------------------------------------*/
+static inline struct uasp_dev *uaspd_from_func(struct usb_function *f)
+{
+	struct fsg_dev		*fsg_dev = fsg_from_func(f);
+	return container_of(fsg_dev, struct uasp_dev, fsg_dev);
+}
+
+static void uasp_common_release(struct kref *ref)
+{
+	struct uasp_common *ucommon =
+		container_of(ref, struct uasp_common, ref);
+	struct uasp_lun *ulun;
+	int i;
+
+	/* First stop all lun threads */
+	run_lun_threads(ucommon->udev, LUN_STATE_EXIT);
+	for (i = 0; i < ucommon->common->nluns; i++) {
+		ulun = &(ucommon->uluns[i]);
+		if (ulun->lun_state != LUN_STATE_TERMINATED) {
+			wait_for_completion(&ulun->thread_notifier);
+			/* The cleanup routine waits for this completion also */
+			complete(&ulun->thread_notifier);
+		}
+	}
+	fsg_common_release(&(ucommon->common->ref));
+	kfree(ucommon->uluns);
+	kfree(ucommon);
+}
+
+
+static inline void uasp_common_put(struct uasp_common *common)
+{
+	kref_put(&(common->ref), uasp_common_release);
+}
+
+static struct uasp_lun *find_lun_by_id(struct uasp_dev *udev, __u8 *lun_id)
+{
+	int i;
+	struct uasp_lun *curlun;
+
+	DBG(udev->ucommon->common, "%s() - Enter.\n", __func__);
+
+	for (i = 0; i < udev->ucommon->common->nluns; ++i) {
+		curlun = &udev->ucommon->uluns[i];
+
+		if (memcmp(lun_id, curlun->lun_id, 8) == 0) {
+			DBG(udev->ucommon->common, "%s() - LUN found\n",
+			    __func__);
+			return curlun;
+		}
+	}
+	DBG(udev->ucommon->common, "%s() - LUN not found\n", __func__);
+	return 0;
+}
+
+/**
+ * wakeup_lun_thread() - Wakes up the given LUn thread
+ * @lun: the LUN which thread needs wakening
+ *
+ * NOTE: Caller must hold uasp_lun->lock
+ *
+ */
+static void wakeup_lun_thread(struct uasp_lun *lun)
+{
+	/* Tell the lun thread that something has happened */
+	lun->thread_wakeup_needed = 1;
+	if (lun->lun_thread_task)
+		wake_up_process(lun->lun_thread_task);
+}
+
+/**
+ * command_complete() - Callback function for the command endpoint
+ * @ep: pointer to the usb_ep (command endpoint)
+ * @req: usb_request received on this endpoint
+ *
+ * This function is passed to the outreq->complete() of the command endpoint.
+ * If the request completed without errors the function marks the state of the
+ * command buffer as full and wakes up the uasp main thread.
+ */
+static void command_complete(struct usb_ep *ep, struct usb_request *req)
+{
+	struct uasp_dev *udev = (struct uasp_dev *) ep->driver_data;
+	unsigned long flags;
+
+	if (req->actual > 0)
+		dump_msg(udev->ucommon->common, "command", req->buf,
+			 req->actual);
+	DBG(udev->ucommon->common, "%s() - Enter", __func__);
+
+	if (req != udev->cmd_buff.outreq) {
+		ERROR(udev->ucommon->common, "(%s) req(%p) != "
+					     "cmd_buff.outreq(%p), udev=%p,"
+					     " common->state = %d\n",
+		      __func__, req, udev->cmd_buff.outreq, udev,
+		      udev->ucommon->common->state);
+	}
+
+	if (req->status == -ECONNRESET) {
+		spin_lock_irqsave(&(udev->ucommon->common->lock), flags);
+		udev->cmd_buff.state = BUF_STATE_EMPTY;
+		spin_unlock_irqrestore(&(udev->ucommon->common->lock), flags);
+
+		usb_ep_fifo_flush(ep);
+		return;
+	}
+
+	spin_lock_irqsave(&(udev->ucommon->common->lock), flags);
+	udev->cmd_buff.state = BUF_STATE_FULL;
+	wakeup_thread(udev->ucommon->common);
+	spin_unlock_irqrestore(&(udev->ucommon->common->lock), flags);
+}
+
+/**
+ * status_complete() - Callback function for the status endpoint
+ * @ep: pointer to the usb_ep (status endpoint)
+ * @req: usb_request received on this endpoint
+ *
+ * This function is passed to the outreq->complete() of the status endpoint.
+ * If the request completion status isn't ECONNRESET the requests tmiu/cmdiu
+ * state is updated to aborted/completed/failed (according to the completion
+ * status of the usb request). If the tmiu/cmdiu was LUN specific, the
+ * corresponding LUN thread is awaken. If it was general, uasp main thread is
+ * awaken.
+ */
+void status_complete(struct usb_ep *ep, struct usb_request *req)
+{
+	struct uasp_dev *udev = (struct uasp_dev *) ep->driver_data;
+	struct uasp_lun *curlun = NULL;
+	struct tm_iu *tmiu;
+	struct cmd_iu *cmdiu;
+	uint8_t cmd_id = ((uint8_t *)req->context)[0];
+	unsigned long flags;
+
+	DBG(udev->ucommon->common, "%s() - Enter", __func__);
+
+	if (req->status == -ECONNRESET)
+		usb_ep_fifo_flush(ep);
+
+	spin_lock_irqsave(&(udev->ucommon->common->lock), flags);
+	/* If Sense IU is filled for TM FUNCTION IU */
+	if (cmd_id == IU_ID_TASK_MANAGEMENT) {
+		tmiu = (struct tm_iu *)req->context;
+		if (tmiu->state != COMMAND_STATE_FAILED &&
+		    tmiu->state != COMMAND_STATE_ABORTED) {
+			if (req->status == -ERESTART)
+				tmiu->state = COMMAND_STATE_ABORTED;
+			else if (req->status) {
+				DBG(udev->ucommon->common,
+				    "%s() - TMIU FAILED!!! Status = %d",
+				    __func__, req->status);
+				tmiu->state = COMMAND_STATE_FAILED;
+			} else
+				tmiu->state = COMMAND_STATE_COMPLETED;
+		}
+		DBG(udev->ucommon->common,
+		    "%s() - received IU_ID_TASK_MANAGEMENT "
+		    "(Code = %02x tmiu->state = %d)\n",
+		    __func__, tmiu->tm_function, tmiu->state);
+		tmiu->bh->inreq_busy = 0;
+		curlun = find_lun_by_id(udev, tmiu->lun);
+	}
+	/* If Sense IU is filled for COMMAND IU */
+	else if (cmd_id == IU_ID_COMMAND) {
+		cmdiu = (struct cmd_iu *)req->context;
+		if (cmdiu->state != COMMAND_STATE_FAILED &&
+		    cmdiu->state != COMMAND_STATE_ABORTED) {
+			if (req->status == -ERESTART)
+				cmdiu->state = COMMAND_STATE_ABORTED;
+			else if (req->status) {
+				DBG(udev->ucommon->common,
+				    "%s() - CMDIU FAILED!!! Status = %d",
+				    __func__, req->status);
+				cmdiu->state = COMMAND_STATE_FAILED;
+			} else if (cmdiu->state == COMMAND_STATE_STATUS)
+					cmdiu->state = COMMAND_STATE_COMPLETED;
+		}
+		DBG(udev->ucommon->common, "%s() - received IU_ID_COMMAND"
+					" (OpCode = %02x, smdiu->state = %d)\n",
+		    __func__, cmdiu->cdb[0], cmdiu->state);
+		cmdiu->req_sts = CMD_REQ_COMPLETED;
+		cmdiu->bh->inreq_busy = 0;
+
+		curlun = find_lun_by_id(udev, cmdiu->lun);
+	} else {
+		ERROR(udev->ucommon->common,
+		      "%s() - received invalid IU (iu_id = %02x)!\n",
+		      __func__, cmd_id);
+		spin_unlock_irqrestore(&(udev->ucommon->common->lock), flags);
+		return;
+	}
+
+	if (curlun) {
+		spin_unlock_irqrestore(&(udev->ucommon->common->lock),
+				       flags);
+		spin_lock_irqsave(&(curlun->lock), flags);
+		curlun->pending_requests++;
+		curlun->active_requests--;
+		wakeup_lun_thread(curlun);
+		spin_unlock_irqrestore(&(curlun->lock), flags);
+		spin_lock_irqsave(&(udev->ucommon->common->lock),
+				  flags);
+	} else {
+		udev->pending_requests++;
+		udev->active_requests--;
+		wakeup_thread(udev->ucommon->common);
+	}
+	spin_unlock_irqrestore(&(udev->ucommon->common->lock), flags);
+}
+
+/**
+ * uasp_bulk_in_complete() - Callback function for the bulk IN endpoint
+ * @ep: pointer to the usb_ep (bulk IN endpoint)
+ * @req: usb_request received on this endpoint
+ *
+ * This function is passed to the outreq->complete() of the bulk IN endpoint.
+ * The requests cmdiu state is updated according to the completion status of
+ * the usb request. If the cmdiu was LUN specific, the  corresponding LUN
+ * thread is awaken. If it was general, uasp main thread is awaken.
+ */
+void uasp_bulk_in_complete(struct usb_ep *ep, struct usb_request *req)
+{
+	struct uasp_dev *udev = (struct uasp_dev *) ep->driver_data;
+	struct uasp_lun *curlun;
+	struct cmd_iu *cmdiu;
+	unsigned long flags;
+
+	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+
+	if (req->status == -ECONNRESET)
+		usb_ep_fifo_flush(ep);
+
+	cmdiu = (struct cmd_iu *)req->context;
+
+	spin_lock_irqsave(&(udev->ucommon->common->lock), flags);
+	if (cmdiu->state != COMMAND_STATE_ABORTED &&
+	    cmdiu->state != COMMAND_STATE_FAILED) {
+		if (req->status == -ERESTART)
+			cmdiu->state = COMMAND_STATE_ABORTED;
+		else if (req->status != 0)
+			cmdiu->state = COMMAND_STATE_FAILED;
+	}
+
+	cmdiu->req_sts = CMD_REQ_COMPLETED;
+	cmdiu->bh->inreq_busy = 0;
+
+
+	curlun = find_lun_by_id(udev, cmdiu->lun);
+	if (curlun) {
+		spin_unlock_irqrestore(&udev->ucommon->common->lock, flags);
+		spin_lock_irqsave(&curlun->lock, flags);
+		curlun->pending_requests++;
+		curlun->active_requests--;
+		wakeup_lun_thread(curlun);
+		spin_unlock_irqrestore(&curlun->lock, flags);
+		spin_lock_irqsave(&(udev->ucommon->common->lock), flags);
+	} else {
+		udev->pending_requests++;
+		udev->active_requests--;
+		wakeup_thread(udev->ucommon->common);
+	}
+	spin_unlock_irqrestore(&udev->ucommon->common->lock, flags);
+}
+
+
+/**
+ * uasp_bulk_out_complete() - Callback function for the bulk OUT endpoint
+ * @ep: pointer to the usb_ep (bulk OUT endpoint)
+ * @req: usb_request received on this endpoint
+ *
+ * This function is passed to the outreq->complete() of the bulk OUT endpoint.
+ * The requests cmdiu state is updated according to the completion status of
+ * the usb request. If the cmdiu was LUN specific, the  corresponding LUN
+ * thread is awaken. If it was general, uasp main thread is awaken.
+ */
+void uasp_bulk_out_complete(struct usb_ep *ep, struct usb_request *req)
+{
+	struct uasp_dev *udev = (struct uasp_dev *) ep->driver_data;
+	struct uasp_lun *curlun;
+	struct cmd_iu *cmdiu;
+	unsigned long flags;
+
+	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+
+	if (req->status == -ECONNRESET)
+		usb_ep_fifo_flush(ep);
+
+	spin_lock_irqsave(&udev->ucommon->common->lock, flags);
+	cmdiu = (struct cmd_iu *)req->context;
+
+	if (cmdiu->state != COMMAND_STATE_ABORTED &&
+	    cmdiu->state != COMMAND_STATE_FAILED) {
+		if (req->status == -ERESTART)
+			cmdiu->state = COMMAND_STATE_ABORTED;
+		else if (req->status != 0)
+			cmdiu->state = COMMAND_STATE_FAILED;
+	}
+
+	cmdiu->req_sts = CMD_REQ_COMPLETED;
+	cmdiu->bh->outreq_busy = 0;
+
+	curlun = find_lun_by_id(udev, cmdiu->lun);
+	if (curlun) {
+		spin_unlock_irqrestore(&udev->ucommon->common->lock, flags);
+		spin_lock_irqsave(&curlun->lock, flags);
+		curlun->pending_requests++;
+		curlun->active_requests--;
+		wakeup_lun_thread(curlun);
+		spin_unlock_irqrestore(&curlun->lock, flags);
+		spin_lock_irqsave(&udev->ucommon->common->lock, flags);
+	} else {
+		udev->pending_requests++;
+		udev->active_requests--;
+		wakeup_thread(udev->ucommon->common);
+	}
+	spin_unlock_irqrestore(&udev->ucommon->common->lock, flags);
+}
+
+/**
+ * remove_completed_commands() - removes all completed UIs
+ * @udev: Programming view of uasp device
+ * @cmd_queue: pointer to the command IUs queue to go over
+ * @tm_func_queue: pointer to the tm IUs queue to go over
+ *
+ * This function goes over the command IUs queue and TM IUs queue and removes
+ * all completed IUs
+ */
+static void remove_completed_commands(struct uasp_dev *udev,
+				     struct list_head *cmd_queue,
+				     struct list_head *tm_func_queue)
+{
+	struct cmd_iu *cmdiu;
+	struct cmd_iu *tmp_cmdiu;
+	struct tm_iu *tmiu;
+	struct tm_iu *tmp_tmiu;
+
+	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+
+	/* Remove completed, aborted or failed commands from cmd_queue */
+	list_for_each_entry_safe(cmdiu, tmp_cmdiu, cmd_queue, node) {
+		DBG(udev->ucommon->common, "%s() - cmd_queue cycle"
+					   " cmdiu->state=%d "
+					   " cmdiu->req_sts=%d\n",
+		     __func__, cmdiu->state, cmdiu->req_sts);
+
+		/* Do not touch incompleted commands !!! */
+		if (cmdiu->state != COMMAND_STATE_ABORTED &&
+		    cmdiu->state != COMMAND_STATE_COMPLETED &&
+		    cmdiu->state != COMMAND_STATE_FAILED)
+			continue;
+
+		if (cmdiu->state == COMMAND_STATE_ABORTED ||
+		    cmdiu->state == COMMAND_STATE_FAILED) {
+			if (cmdiu->req_sts == CMD_REQ_IN_PROGRESS) {
+				if (cmdiu->bh->inreq_busy &&
+				    usb_ep_dequeue(cmdiu->ep,
+						   cmdiu->bh->inreq)) {
+					cmdiu->req_sts = CMD_REQ_COMPLETED;
+					cmdiu->bh->inreq_busy = 0;
+				}
+				if (cmdiu->bh->outreq_busy &&
+				    usb_ep_dequeue(cmdiu->ep,
+						   cmdiu->bh->outreq)) {
+					cmdiu->req_sts = CMD_REQ_COMPLETED;
+					cmdiu->bh->outreq_busy = 0;
+				}
+			}
+
+			if (cmdiu->req_sts == CMD_REQ_IN_PROGRESS)
+				continue;
+		}
+		DBG(udev->ucommon->common, "%s() - deleted cmdiu: "
+				   "cmdiu[0] = %d, cmdiu->state = %d,"
+				   "cmdiu->tag = %d\n",
+		     __func__, cmdiu->cdb[0], cmdiu->state, cmdiu->tag);
+		list_del(&cmdiu->node);
+		if (cmdiu->bh) {
+			DBG(udev->ucommon->common, "%s() - Freeing the "
+						   "cmdiu->bh\n", __func__);
+			cmdiu->bh->state = BUF_STATE_EMPTY;
+		}
+		kfree(cmdiu);
+	}
+
+	/* Remove completed, aborted or failed commands from tm_func_queue */
+	list_for_each_entry_safe(tmiu, tmp_tmiu, tm_func_queue, node) {
+		/* Do not touch incompleted commands !!! */
+		if (tmiu->state != COMMAND_STATE_ABORTED &&
+		    tmiu->state != COMMAND_STATE_COMPLETED &&
+		    tmiu->state != COMMAND_STATE_FAILED)
+			continue;
+
+		DBG(udev->ucommon->common, "%s() - deleted tmiu\n",  __func__);
+		list_del(&tmiu->node);
+		if (tmiu->bh) {
+			DBG(udev->ucommon->common, "%s() - Freeing the "
+						   "tmiu->bh\n", __func__);
+			tmiu->bh->state = BUF_STATE_EMPTY;
+		}
+		kfree(tmiu);
+	}
+	if (list_empty(cmd_queue) && list_empty(tm_func_queue))
+		DBG(udev->ucommon->common, "%s() - both lists are empty\n",
+		    __func__);
+	DBG(udev->ucommon->common, "%s() - exit\n", __func__);
+}
+
+/**
+ * do_uasp_set_interface() - Enables/disables the UASP FD.
+ * @uaspd: pointer to the uasp device structure
+ * @new_fsg: pointer to fsg_dev for the new configuration
+ *
+ * Returns 0 on success negative error code otherwise.
+ *
+ * Initiates all endpoints and enables them. Allocates buffers and requests.
+ */
+static int do_uasp_set_interface(struct uasp_dev *uaspd,
+				 struct fsg_dev *new_fsg)
+{
+	int rc = 0;
+	int i;
+	struct fsg_dev	*fsgd;
+	struct fsg_common *fcommon;
+	unsigned long flags;
+
+	if (!uaspd || !uaspd->ucommon || !uaspd->ucommon->common)
+		return -EIO;
+
+	DBG(uaspd->ucommon->common, "%s()- Enter\n", __func__);
+
+	fcommon = uaspd->ucommon->common;
+	if (uaspd->ucommon->common->running)
+		DBG(uaspd->ucommon->common, "reset inteface\n");
+
+reset_uasp:
+	/* Deallocate the requests */
+	if (uaspd->ucommon->common->fsg) {
+		fsgd = fcommon->fsg;
+
+		abort_commands(uaspd, &uaspd->cmd_queue, &uaspd->tm_func_queue,
+		       &(uaspd->ucommon->common->lock));
+		remove_completed_commands(uaspd, &uaspd->cmd_queue,
+				   &uaspd->tm_func_queue);
+		uaspd->pending_requests = 0;
+
+		for (i = 0; i < uaspd->ucommon->common->nluns; i++) {
+			struct uasp_lun *ulun = &uaspd->ucommon->uluns[i];
+			abort_commands(uaspd, &ulun->cmd_queue,
+				       &ulun->tm_func_queue, &(ulun->lock));
+			remove_completed_commands(uaspd, &ulun->cmd_queue,
+					   &ulun->tm_func_queue);
+			spin_lock_irqsave(&(ulun->lock), flags);
+			ulun->pending_requests = 0;
+			ulun->lun->prevent_medium_removal = 0;
+			ulun->lun->sense_data = SS_NO_SENSE;
+			ulun->lun->unit_attention_data = SS_NO_SENSE;
+			ulun->lun->sense_data_info = 0;
+			ulun->lun->info_valid = 0;
+			spin_unlock_irq(&(ulun->lock));
+		}
+		/* Clear out the controller's fifos */
+		if (fcommon->fsg->bulk_in_enabled)
+			usb_ep_fifo_flush(fcommon->fsg->bulk_in);
+		if (fcommon->fsg->bulk_out_enabled)
+			usb_ep_fifo_flush(fcommon->fsg->bulk_out);
+		usb_ep_fifo_flush(uaspd->ucommon->udev->status);
+		usb_ep_fifo_flush(uaspd->ucommon->udev->command);
+
+		spin_lock_irq(&fcommon->lock);
+		/* Reset the I/O buffer states and pointers */
+		for (i = 0; i < FSG_NUM_BUFFERS; ++i) {
+			struct fsg_buffhd *bh = &fcommon->buffhds[i];
+			if (bh->inreq) {
+				usb_ep_free_request(fsgd->bulk_in, bh->inreq);
+				bh->inreq = NULL;
+			}
+			if (bh->outreq) {
+				usb_ep_free_request(fsgd->bulk_out, bh->outreq);
+				bh->outreq = NULL;
+			}
+			bh->state = BUF_STATE_EMPTY;
+		}
+
+		/* Deallocate command and status requests */
+		if (uaspd->cmd_buff.inreq) {
+			ERROR(uaspd->ucommon->common,
+			      "%s(): uaspd->cmd_buff.inreq isn't NULL. "
+			      "How can that be???",
+			      __func__);
+			usb_ep_free_request(uaspd->command,
+					    uaspd->cmd_buff.inreq);
+			uaspd->cmd_buff.inreq = NULL;
+		}
+		if (uaspd->cmd_buff.outreq) {
+			usb_ep_free_request(uaspd->command,
+					    uaspd->cmd_buff.outreq);
+			uaspd->cmd_buff.outreq = NULL;
+		}
+		uaspd->cmd_buff.state = BUF_STATE_EMPTY;
+		spin_unlock_irq(&fcommon->lock);
+
+		/* Disable the endpoints */
+		if (fsgd->bulk_in_enabled) {
+			usb_ep_disable(fsgd->bulk_in);
+			fsgd->bulk_in_enabled = 0;
+		}
+		if (fsgd->bulk_out_enabled) {
+			usb_ep_disable(fsgd->bulk_out);
+			fsgd->bulk_out_enabled = 0;
+		}
+		fsgd->bulk_in->desc = NULL;
+		fsgd->bulk_out->desc = NULL;
+
+		if (uaspd->cmd_enabled) {
+			usb_ep_disable(uaspd->command);
+			uaspd->cmd_enabled = 0;
+		}
+		if (uaspd->status_enabled) {
+			usb_ep_disable(uaspd->status);
+			uaspd->status_enabled = 0;
+		}
+		uaspd->command->desc = NULL;
+		uaspd->status->desc = NULL;
+		DBG(uaspd->ucommon->common, "%s()- disabled endpoints\n",
+		    __func__);
+
+		fcommon->fsg = NULL;
+		wake_up(&fcommon->fsg_wait);
+	}
+
+	fcommon->running = 0;
+	if (!new_fsg || rc)
+		return rc;
+
+	fcommon->fsg = new_fsg;
+	fsgd = fcommon->fsg;
+
+	/* Enable the endpoints */
+	config_ep_by_speed(fcommon->gadget, &fsgd->function, fsgd->bulk_in);
+	rc = usb_ep_enable(fsgd->bulk_in);
+	if (rc)
+		goto reset_uasp;
+	fsgd->bulk_in->driver_data = uaspd;
+	fsgd->bulk_in_enabled = 1;
+
+	config_ep_by_speed(fsgd->common->gadget, &fsgd->function,
+			   fsgd->bulk_out);
+	rc = usb_ep_enable(fsgd->bulk_out);
+	if (rc)
+		goto reset_uasp;
+	fsgd->bulk_out->driver_data = uaspd;
+	fsgd->bulk_out_enabled = 1;
+
+	fsgd->common->bulk_out_maxpacket =
+		le16_to_cpu(fsgd->bulk_out->maxpacket);
+	clear_bit(IGNORE_BULK_OUT, &fsgd->atomic_bitflags);
+
+	config_ep_by_speed(fsgd->common->gadget, &fsgd->function,
+			   uaspd->command);
+	rc = usb_ep_enable(uaspd->command);
+	if (rc)
+		goto reset_uasp;
+	uaspd->command->driver_data = uaspd;
+	uaspd->cmd_enabled = 1;
+
+	config_ep_by_speed(fsgd->common->gadget, &fsgd->function,
+			   uaspd->status);
+	rc = usb_ep_enable(uaspd->status);
+	if (rc)
+		goto reset_uasp;
+	uaspd->status->driver_data = uaspd;
+	uaspd->status_enabled = 1;
+
+	/* Allocate the data - requests */
+	for (i = 0; i < FSG_NUM_BUFFERS; ++i) {
+		struct uasp_buff	*buff = &uaspd->ucommon->ubufs[i];
+
+		buff->fsg_buff->inreq = usb_ep_alloc_request(fsgd->bulk_in,
+							     GFP_ATOMIC);
+		if (!buff->fsg_buff->inreq)
+			goto reset_uasp;
+
+		buff->fsg_buff->outreq = usb_ep_alloc_request(fsgd->bulk_out,
+							     GFP_ATOMIC);
+		if (!buff->fsg_buff->outreq)
+			goto reset_uasp;
+
+		buff->fsg_buff->inreq->buf =
+				buff->fsg_buff->outreq->buf =
+				buff->fsg_buff->buf;
+		buff->fsg_buff->inreq->context =
+				buff->fsg_buff->outreq->context =
+				buff->fsg_buff;
+	}
+
+	/* Allocate command ep request */
+	uaspd->cmd_buff.outreq = usb_ep_alloc_request(uaspd->command,
+							     GFP_ATOMIC);
+	if (!uaspd->cmd_buff.outreq) {
+		ERROR(uaspd->ucommon->common, "failed allocating outreq for "
+					     "command buffer\n");
+		goto reset_uasp;
+	}
+
+	DBG(uaspd->ucommon->common, "%s() allocated command request = %p, "
+				    "udev=%p\n", __func__,
+				uaspd->cmd_buff.outreq, uaspd);
+	uaspd->cmd_buff.outreq->buf = &(uaspd->cmd_buff.buf);
+	uaspd->cmd_buff.inreq = NULL;
+	uaspd->cmd_buff.state = BUF_STATE_EMPTY;
+
+	fcommon->running = 1;
+	for (i = 0; i < fsgd->common->nluns; ++i)
+		fsgd->common->luns[i].unit_attention_data = SS_RESET_OCCURRED;
+	return 0;
+}
+
+static void handle_uasp_exception(struct uasp_common *ucommon)
+{
+	siginfo_t		info;
+	int			sig;
+	int			i;
+	struct fsg_buffhd	*bh;
+	enum fsg_state		old_state;
+	int			rc;
+
+	struct fsg_common *fcommon = ucommon->common;
+
+	DBG(ucommon->common, "%s()- Enter\n", __func__);
+
+	/*
+	 * Clear the existing signals.  Anything but SIGUSR1 is converted
+	 * into a high-priority EXIT exception.
+	 */
+	for (;;) {
+		sig = dequeue_signal_lock(current, &current->blocked, &info);
+		if (!sig)
+			break;
+		if (sig != SIGUSR1) {
+			if (fcommon->state < FSG_STATE_EXIT)
+				DBG(fcommon, "Main thread exiting on signal\n");
+			fcommon->state = FSG_STATE_EXIT;
+		}
+	}
+
+	/*
+	 * Reset the I/O buffer states and pointers, the SCSI  state, and the
+	 * exception.  Then invoke the handler.
+	 */
+	spin_lock_irq(&fcommon->lock);
+
+	for (i = 0; i < FSG_NUM_BUFFERS; ++i) {
+		bh = &fcommon->buffhds[i];
+		bh->state = BUF_STATE_EMPTY;
+	}
+	old_state = fcommon->state;
+	fcommon->state = FSG_STATE_IDLE;
+	spin_unlock_irq(&fcommon->lock);
+
+	/* Carry out any extra actions required for the exception */
+	switch (old_state) {
+	case FSG_STATE_ABORT_BULK_OUT:
+	case FSG_STATE_RESET:
+		/* TODO */
+		break;
+
+	case FSG_STATE_CONFIG_CHANGE:
+		if (fcommon->fsg == fcommon->new_fsg) {
+			DBG(fcommon, "nothing to do. same config\n");
+			break;
+		}
+		/* Enable/disable the interface according to the new_config */
+		rc = do_uasp_set_interface(ucommon->udev, fcommon->new_fsg);
+		if (rc != 0)
+			fcommon->fsg = NULL;	/* Reset on errors */
+		break;
+	case FSG_STATE_EXIT:
+	case FSG_STATE_TERMINATED:
+		/* Free resources */
+		(void)do_uasp_set_interface(ucommon->udev, NULL);
+		spin_lock_irq(&fcommon->lock);
+		fcommon->state = FSG_STATE_TERMINATED;	/* Stop the thread*/
+		spin_unlock_irq(&fcommon->lock);
+		break;
+
+	case FSG_STATE_INTERFACE_CHANGE:
+	case FSG_STATE_DISCONNECT:
+	case FSG_STATE_COMMAND_PHASE:
+	case FSG_STATE_DATA_PHASE:
+	case FSG_STATE_STATUS_PHASE:
+	case FSG_STATE_IDLE:
+		break;
+	}
+	DBG(ucommon->common, "%s()- Exit\n", __func__);
+}
+
+/**
+ * uasp_command_check() - Verifies the data received via command endpoint for
+ * accuracy.
+ * @udev: Programming view of uasp device.
+ * @command: Pointer to the received data buffer.
+ *
+ * Return 0 - if no error condition and the command is a
+ *	   COMMAND IU
+ *	  1 - if no error condition and the command is a TASK
+ *	   MANAGEMENT IU
+ *	  negative value on error.
+ *
+ * If the command is valid returns it by reference in command
+ * param. The following steps are implemented in this function:
+ * - Checking that the received data is a TM FUNCTION or COMMAND IU.
+ * - Chekcing that the length of the received data is correct
+ *   (16 bytes for TM FUNCTION IU and 36 bytes for COMMAND IU).
+ * - Checking that there is no overlapped tag.
+ */
+static int uasp_command_check(struct uasp_dev *udev, void **command)
+{
+	int i = 0;
+	int rc = 0;
+	unsigned long flags;
+	__be16 tag;
+	uint8_t cmd_id;
+	struct uasp_lun *curlun;
+	struct cmd_iu *cmdiu, *tmp_cmdiu;
+	struct tm_iu *tmiu, *tmp_tmiu;
+	struct fsg_buffhd *bh;
+	struct usb_request *req;
+
+	bh = &(udev->cmd_buff);
+	bh->state = BUF_STATE_EMPTY;
+	req = udev->cmd_buff.outreq;
+	*command = NULL;
+
+	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+
+	/* Id of the received command (tmiu or cmdiu) */
+	cmd_id = ((uint8_t *)req->buf)[0];
+
+	/* tag of the received command */
+	tag = ((__be16 *)req->buf)[1];
+
+	/* Invalid completion status */
+	if (req->status) {
+		ERROR(udev->ucommon->common,
+		      "%s() - Invalid completion status for command "
+		      "request = -%d\n", __func__, req->status);
+		return -EINVAL;
+	}
+
+	/* Check is the data received via command endpoint is a command */
+	if (cmd_id != IU_ID_TASK_MANAGEMENT && cmd_id != IU_ID_COMMAND) {
+		ERROR(udev->ucommon->common,
+		      "%s() - Invalid data is received\n", __func__);
+		/* TODO: something needs to be done (e.g. halt endpoints) */
+		return -EINVAL;
+	}
+
+	/* Invalid count of bytes received for tmiu */
+	if (cmd_id == IU_ID_TASK_MANAGEMENT && req->actual != 16) {
+		ERROR(udev->ucommon->common,
+		      "%s() - Invalid byte count for tmiu is received = %d\n",
+		       __func__, req->actual);
+		/* TODO: something needs to be done (e.g. halt endpoints) */
+		return -EINVAL;
+	}
+
+	/* Invalid count of bytes received for cmdiu */
+	if (cmd_id == IU_ID_COMMAND && req->actual < 32) {
+		ERROR(udev->ucommon->common,
+		      "%s() - Invalid byte count for cmdiu is received = %d\n",
+		      __func__, req->actual);
+		/* TODO: something needs to be done (e.g. halt endpoints) */
+		return -EINVAL;
+	}
+
+	/* Try to allocate memory for received command */
+	tmiu = NULL;
+	cmdiu = NULL;
+
+	if (cmd_id == IU_ID_TASK_MANAGEMENT) {
+		tmiu = kmalloc(sizeof(struct tm_iu), GFP_KERNEL);
+
+		if (!tmiu) {
+			ERROR(udev->ucommon->common,
+			      "%s() - No memory for tmiu\n", __func__);
+			return -ENOMEM;
+		}
+		*command = tmiu;
+		memcpy(*command, req->buf, 16);
+	} else {
+		cmdiu = kmalloc(sizeof(struct cmd_iu), GFP_KERNEL);
+
+		if (!cmdiu) {
+			ERROR(udev->ucommon->common,
+			      "%s() - No memory for cmdiu\n", __func__);
+			return -ENOMEM;
+		}
+		*command = cmdiu;
+		memcpy(*command, req->buf, req->actual);
+	}
+
+	/* Check for overlapping tag */
+	/* Check for tag overlapping over all cmd an tm_func queues */
+	for (i = 0; i < udev->ucommon->common->nluns; ++i) {
+		curlun = &udev->ucommon->uluns[i];
+		spin_lock_irqsave(&(curlun->lock), flags);
+
+		list_for_each_entry(tmp_cmdiu, &curlun->cmd_queue, node) {
+			if (tmp_cmdiu->state != COMMAND_STATE_IDLE &&
+			    tmp_cmdiu->state != COMMAND_STATE_DATA &&
+			    tmp_cmdiu->state != COMMAND_STATE_STATUS) {
+				continue;
+			}
+			/* Overlapped tag found */
+			if (tmp_cmdiu->tag == tag) {
+				spin_unlock_irqrestore(&(curlun->lock), flags);
+				goto overlapped_tag;
+			}
+		}
+
+		list_for_each_entry(tmp_tmiu, &curlun->tm_func_queue, node) {
+
+			if (tmp_tmiu->state != COMMAND_STATE_IDLE &&
+			    tmp_tmiu->state != COMMAND_STATE_STATUS)
+				continue;
+			/* Overlapped tag found */
+			if (tmp_tmiu->tag == tag)
+				goto overlapped_tag;
+		}
+		spin_unlock_irqrestore(&(curlun->lock), flags);
+	}
+
+	spin_lock_irqsave(&(udev->ucommon->common->lock), flags);
+	list_for_each_entry(tmp_cmdiu, &udev->cmd_queue, node) {
+		if (tmp_cmdiu->state != COMMAND_STATE_IDLE &&
+		    tmp_cmdiu->state != COMMAND_STATE_DATA &&
+		    tmp_cmdiu->state != COMMAND_STATE_STATUS)
+			continue;
+
+		/* Overlapped tag found */
+		if (tmp_cmdiu->tag == tag) {
+			spin_unlock_irqrestore(&(udev->ucommon->common->lock),
+					       flags);
+			goto overlapped_tag;
+		}
+	}
+
+	list_for_each_entry(tmp_tmiu, &udev->tm_func_queue, node) {
+		if (tmp_tmiu->state != COMMAND_STATE_IDLE &&
+		    tmp_tmiu->state != COMMAND_STATE_STATUS)
+			continue;
+
+		/* Overlapped tag found */
+		if (tmp_tmiu->tag == tag) {
+			spin_unlock_irqrestore(&(udev->ucommon->common->lock),
+					       flags);
+			goto overlapped_tag;
+		}
+	}
+	spin_unlock_irqrestore(&(udev->ucommon->common->lock), flags);
+
+	/* No overlapped tag */
+	if (cmd_id == IU_ID_TASK_MANAGEMENT)
+		return 0;
+
+	return 1;
+
+overlapped_tag:
+	ERROR(udev->ucommon->common, "%s() - Overlapped tag found. "
+				     "Aborting all\n", __func__);
+
+	run_lun_threads(udev, LUN_STATE_OVERLAPPED_TAG);
+
+	/* Wait for luns abort completion. Sleep if luns are in processing */
+	while (!all_lun_state_non_processing(udev)) {
+		DBG(udev->ucommon->common,
+		    "%s() - Luns are in process. Going to sleep\n", __func__);
+		rc = sleep_thread(udev->ucommon->common);
+		if (rc) {
+			ERROR(udev->ucommon->common,
+			      "%s() - sleep_thread failed! (%d)", __func__, rc);
+			return -EINVAL;
+		}
+		DBG(udev->ucommon->common, "%s() - Wakes up\n", __func__);
+		rc = 0;
+	}
+
+	/* Abort none-lun commands */
+	abort_commands(udev, &udev->cmd_queue, &udev->tm_func_queue,
+		       &(udev->ucommon->common->lock));
+
+	spin_lock_irqsave(&(udev->ucommon->common->lock), flags);
+	udev->pending_requests = 0;
+	spin_unlock_irqrestore(&(udev->ucommon->common->lock), flags);
+
+	if (cmd_id == IU_ID_TASK_MANAGEMENT) {
+		tmiu = *command;
+
+		spin_lock_irqsave(&(udev->ucommon->common->lock), flags);
+		tmiu->bh = get_buffhd(udev->ucommon->common->buffhds);
+		spin_unlock_irqrestore(&(udev->ucommon->common->lock), flags);
+
+		if (!tmiu->bh) {
+			ERROR(udev->ucommon->common,
+			      "%s(): didnt manage to get buffers for tmiu!\n",
+			       __func__);
+			return -EINVAL;
+		}
+		fill_response_iu(udev, (struct response_iu *)tmiu->bh->buf,
+				 tmiu->tag, 0,
+				 RESPONSE_OVERLAPPED_TAG_ATTEMPTED);
+		fill_usb_request(tmiu->bh->inreq, tmiu->bh->buf,
+				 UASP_SIZEOF_RESPONSE_IU, 0,
+				 (void *)tmiu, 0,
+				 be16_to_cpup(&tmiu->tag), status_complete);
+
+		tmiu->ep = udev->status;
+		tmiu->bh->inreq_busy = 1;
+		if (usb_ep_queue(tmiu->ep, tmiu->bh->inreq, 0))
+			tmiu->state = COMMAND_STATE_FAILED;
+		else
+			tmiu->state = COMMAND_STATE_STATUS;
+		list_add_tail(&tmiu->node, &(udev->tm_func_queue));
+	} else {
+		cmdiu = *command;
+
+		spin_lock_irqsave(&(udev->ucommon->common->lock), flags);
+		cmdiu->bh = get_buffhd(udev->ucommon->common->buffhds);
+		spin_unlock_irqrestore(&(udev->ucommon->common->lock), flags);
+
+		if (!cmdiu->bh) {
+			ERROR(udev->ucommon->common,
+			      "%s(): didnt manage to get buffers for cmdiu!\n",
+			       __func__);
+			return -EINVAL;
+		}
+
+		fill_sense_iu(udev, (struct sense_iu *)cmdiu->bh->buf,
+			  cmdiu->tag, STATUS_CHECK_CONDITION,
+			  SS_OVERLAPPED_COMMANDS_ATTEMPTED);
+		fill_usb_request(cmdiu->bh->inreq, cmdiu->bh->buf,
+				 UASP_SIZEOF_SENSE_IU, 0,
+				 (void *)cmdiu, 0,
+				 be16_to_cpup(&cmdiu->tag), status_complete);
+		cmdiu->ep = udev->status;
+		cmdiu->bh->inreq_busy = 1;
+		if (usb_ep_queue(cmdiu->ep, cmdiu->bh->inreq, 0))
+			cmdiu->state = COMMAND_STATE_FAILED;
+		else
+			cmdiu->state = COMMAND_STATE_STATUS;
+		list_add_tail(&cmdiu->node, &(udev->cmd_queue));
+	}
+	return -EINVAL;
+}
+
+/**
+ * insert_tm_func_to_list() - Insert the tmiu to the appropriate queue
+ * @udev: Programming view of uasp device.
+ * @tmiu: the tmiu to place in the appropriate queue
+ *
+ * This function tries to allocate the LUN corresponding to the LUN id in the
+ * received tmiu. If such LUN is found the tmiu is placed in it's tm_func_queue.
+ * If the LUN wasn't found then the tmiu will be placed in the general
+ * tm_func_queue .
+ *
+ * TODO: Should this be protected by locks?
+ */
+static void insert_tm_func_to_list(struct uasp_dev *udev, struct tm_iu *tmiu)
+{
+	struct tm_iu *tmiu1;
+	struct uasp_lun *curlun;
+
+	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+
+	curlun = find_lun_by_id(udev, tmiu->lun);
+	tmiu->state = COMMAND_STATE_IDLE;
+
+	if (tmiu->tm_function == TM_FUNCTION_IT_NEXUS_RESET) {
+		list_add(&tmiu->node, &udev->tm_func_queue);
+		return;
+	}
+
+	if (!curlun) {
+		list_add_tail(&tmiu->node, &udev->tm_func_queue);
+		return;
+	}
+
+	/* tmiu should be handled by curlun */
+
+	if (tmiu->tm_function == TM_FUNCTION_RESET_LUN) {
+		list_add(&tmiu->node, &curlun->tm_func_queue);
+		return;
+	}
+
+	/*
+	 * Insert tmiu to queue acording to the folowing priority:
+	 * 1.TM_FUNCTION_RESET_LUN
+	 * 2. TM_FUNCTION_ABORT_TASK_SET or TM_FUNCTION_CLEAR_TASK_SET
+	 * 3. TM_FUNCTION_ABORT_TASK
+	 * 4. TM_FUNCTION_QUERY_ASYNC_EVENT
+	 * All other...
+	 */
+	list_for_each_entry(tmiu1, &curlun->tm_func_queue, node) {
+		if (tmiu1->tm_function == TM_FUNCTION_RESET_LUN)
+			continue;
+
+		if (tmiu->tm_function == TM_FUNCTION_ABORT_TASK_SET ||
+		    tmiu->tm_function == TM_FUNCTION_CLEAR_TASK_SET) {
+			list_add(&tmiu->node, &tmiu1->node);
+			return;
+		}
+
+		if (tmiu1->tm_function == TM_FUNCTION_ABORT_TASK_SET ||
+		    tmiu1->tm_function == TM_FUNCTION_CLEAR_TASK_SET)
+			continue;
+
+		if (tmiu->tm_function == TM_FUNCTION_ABORT_TASK) {
+			list_add(&tmiu->node, &tmiu1->node);
+			return;
+		}
+
+		if (tmiu1->tm_function == TM_FUNCTION_ABORT_TASK)
+			continue;
+
+		if (tmiu->tm_function == TM_FUNCTION_QUERY_ASYNC_EVENT) {
+			list_add(&tmiu->node, &tmiu1->node);
+			return;
+		}
+
+		if (tmiu1->tm_function == TM_FUNCTION_QUERY_ASYNC_EVENT)
+			continue;
+
+		list_add_tail(&tmiu->node, &tmiu1->node);
+		return;
+	}
+
+	list_add_tail(&tmiu->node, &tmiu1->node);
+}
+
+/**
+ * insert_cmd_to_list() - Insert the tmiu to the appropriate queue
+ * @udev: Programming view of uasp device.
+ * @cmdiu: the cmdiu to place in the appropriate queue
+ *
+ * This function tries to locate the LUN corresponding to the LUN id in the
+ * received cmdiu. If such LUN is found the cmdiu is placed in it's cmd_queue.
+ * If the LUN wasn't found then the cmdiu will be placed in the general
+ * cmd_queue.
+ *
+ * TODO: Should this be protected by locks?
+ */
+static void insert_cmd_to_list(struct uasp_dev *udev, struct cmd_iu *cmdiu)
+{
+	struct list_head *link;
+	struct cmd_iu *cmdiu1;
+	struct uasp_lun *curlun;
+
+	DBG(udev->ucommon->common, "%s(): cmdiu->lun = %p\n", __func__,
+	    cmdiu->lun);
+
+	DBG(udev->ucommon->common, "%02x %02x %02x %02x %02x %02x %02x %02x\n",
+		cmdiu->lun[0], cmdiu->lun[1], cmdiu->lun[2], cmdiu->lun[3],
+		cmdiu->lun[4], cmdiu->lun[5], cmdiu->lun[6], cmdiu->lun[7]);
+
+	curlun = find_lun_by_id(udev, cmdiu->lun);
+	cmdiu->state = COMMAND_STATE_IDLE;
+
+	if (!curlun)
+		link = &udev->cmd_queue;
+	else
+		link = &curlun->cmd_queue;
+
+	/* Place cmdiu in the queue, in the right place */
+	if (cmdiu->forth_byte.task_attribute == TASK_ATTR_ACA) {
+		list_add(&cmdiu->node, link);
+		return;
+	}
+
+	list_for_each_entry(cmdiu1, link, node) {
+		/* ACA should be in the head of the queue */
+		if (cmdiu1->forth_byte.task_attribute  == TASK_ATTR_ACA)
+			continue;
+
+		/* The new HEAD OF QUEUE should be placed after ACA */
+		if (cmdiu1->forth_byte.task_attribute ==
+				TASK_ATTR_HEAD_OF_QUEUE) {
+			list_add(&cmdiu->node, &cmdiu1->node);
+			return;
+		}
+
+		/* If ORDERED or SIMPLE, place at the end of the queue */
+		list_add_tail(&cmdiu->node, link);
+		return;
+	}
+
+	/* In the case when the queue is empty */
+	list_add_tail(&cmdiu->node, link);
+	DBG(udev->ucommon->common,
+	     "%s() - Cmdiu is added to the tail of the queue\n", __func__);
+}
+
+/**
+ * get_command() - Gets the next command from command emdpoint
+ * @udev: Programming view of uasp device.
+ *
+ * Return 0 if no error condition, negative value otherwise.
+ *
+ * This function is responsible for:
+ * - Utilizing the command endpoint.
+ * - Checking of the received data for accuracy. For more details please see
+ *   the description of the uasp_command_check() function.
+ * - Adding the received TM FUNCTION or COMMAND IU to the appropriate queue.
+ */
+static int get_command(struct uasp_dev *udev)
+{
+	int rc = 0;
+	void *command = 0;
+
+	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+
+queue_cmd_ep:
+	/* If command endpoint is not active, activate */
+	if (udev->cmd_buff.state == BUF_STATE_EMPTY) {
+		udev->cmd_buff.state = BUF_STATE_BUSY;
+		/* Queue a request to read the next command */
+		udev->cmd_buff.outreq->buf = udev->cmd_buff.buf;
+		udev->cmd_buff.outreq->complete = command_complete;
+		udev->cmd_buff.outreq->length =
+			(FSG_BUFLEN < udev->command->maxpacket ? FSG_BUFLEN :
+					udev->command->maxpacket);
+		udev->cmd_buff.outreq->short_not_ok = 1;
+		rc = usb_ep_queue(udev->command, udev->cmd_buff.outreq, 0);
+		if (rc) {
+			ERROR(udev->ucommon->common,
+			      "%s()usb_ep_queue failed = %d\n", __func__, rc);
+			udev->cmd_buff.state = BUF_STATE_EMPTY;
+		}
+		DBG(udev->ucommon->common, "%s() queued command request = %p\n",
+		     __func__, udev->cmd_buff.outreq);
+		return rc;
+	}
+	/* If command endpoint is busy, do nothing */
+	else if (udev->cmd_buff.state == BUF_STATE_BUSY)
+		return rc;
+
+	rc = uasp_command_check(udev, &command);
+
+	if (rc == 0) {
+		DBG(udev->ucommon->common, "%s() - Received a TMC IU\n",
+		    __func__);
+		insert_tm_func_to_list(udev, (struct tm_iu *)command);
+		udev->cmd_buff.state = BUF_STATE_EMPTY;
+		goto queue_cmd_ep;
+	} else if (rc == 1) {
+		DBG(udev->ucommon->common, "%s() -Received a CMD IU\n",
+		    __func__);
+		insert_cmd_to_list(udev, (struct cmd_iu *)command);
+		udev->cmd_buff.state = BUF_STATE_EMPTY;
+		goto queue_cmd_ep;
+	}
+
+	return rc;
+}
+
+/**
+ * all_lun_state_non_processing() - Returns 1, if all luns are in
+ * none-processing state
+ * @udev: Programming view of uasp device
+ *
+ */
+int all_lun_state_non_processing(struct uasp_dev *udev)
+{
+	struct uasp_lun *curlun;
+	int i;
+
+	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+
+	for (i = 0; i < udev->ucommon->common->nluns; ++i) {
+		curlun = &udev->ucommon->uluns[i];
+		if (curlun->lun_state > LUN_STATE_IDLE)
+			return 0;
+	}
+	return 1;
+}
+
+/*
+ * pending_cmd_in_lun() - Checks for pending IUs in all LUNs queues
+ * @data: Programming view of uasp device
+ *
+ * Returns 1 if all luns are in non-processing state and and if are incomplete
+ * or pending commands in one of the luns.
+ */
+static int pending_cmd_in_lun(void *data)
+{
+	struct uasp_dev *udev = (struct uasp_dev *)data;
+	struct uasp_lun *curlun;
+	int i;
+
+	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+	for (i = 0; i < udev->ucommon->common->nluns; ++i) {
+		curlun = &udev->ucommon->uluns[i];
+		if (curlun->pending_requests)
+			return 1;
+	}
+
+	return 0;
+}
+
+static int sleep_lun_thread(struct uasp_lun *lun)
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
+		if (lun->thread_wakeup_needed)
+			break;
+		schedule();
+	}
+	__set_current_state(TASK_RUNNING);
+	lun->thread_wakeup_needed = 0;
+	return rc;
+}
+
+/**
+ * run_lun_threads() - Wakeup all LUN threads with a given state
+ * @udev: Programming view of uasp device
+ * @state: The state to run the LUn in (from enum lun_state)
+ *
+ */
+void run_lun_threads(struct uasp_dev *udev, int state)
+{
+	struct uasp_lun *curlun;
+	int i;
+	unsigned long flags;
+
+	DBG(udev->ucommon->common, "%s() - Enter. State = %d\n",
+	    __func__, state);
+
+	for (i = 0; i < udev->ucommon->common->nluns; ++i) {
+		curlun = &udev->ucommon->uluns[i];
+		spin_lock_irqsave(&(curlun->lock), flags);
+		curlun->lun_state = state;
+		wakeup_lun_thread(curlun);
+		spin_unlock_irqrestore(&(curlun->lock), flags);
+	}
+	DBG(udev->ucommon->common, "%s() - Exit\n", __func__);
+}
+
+/**
+ * abort_commands() - Aborts all IUs on given queues
+ * @udev: Programming view of uasp device
+ * @cmd_queue: pointer to the cmd IUs queue to abort IUs from
+ * @tm_func_queue: pointer to the tm IUs queue to abort IUs from
+ * @lock: pointer to spinlock_t to lock when performing the abort.
+ *	Can be udev->lock if the cmd_queue and the tm_func_queue are general,
+ *	or curlun->lock if they belong to a specific LUN
+ *
+ * TODO: Add wait mechanism using curlun->active_requests or
+ * udev->active_requests
+ */
+void abort_commands(struct uasp_dev *udev,
+			struct list_head *cmd_queue,
+			struct list_head *tm_func_queue,
+			spinlock_t *lock)
+{
+	unsigned long flags;
+	struct cmd_iu *cmdiu, *tmp_cmdiu;
+	struct tm_iu *tmiu, *tmp_tmiu;
+
+	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+
+	if (!cmd_queue)
+		goto tmiu_part;
+
+	spin_lock_irqsave(lock, flags);
+	list_for_each_entry_safe(cmdiu, tmp_cmdiu, cmd_queue, node) {
+		if (cmdiu->state == COMMAND_STATE_DATA) {
+			if (cmdiu->req_sts == CMD_REQ_IN_PROGRESS) {
+				spin_unlock_irqrestore(lock, flags);
+				if (cmdiu->bh->inreq_busy)
+					usb_ep_dequeue(cmdiu->ep,
+						       cmdiu->bh->inreq);
+				if (cmdiu->bh->outreq_busy)
+					usb_ep_dequeue(cmdiu->ep,
+						       cmdiu->bh->outreq);
+				spin_lock_irqsave(lock, flags);
+			}
+		} else if (cmdiu->state == COMMAND_STATE_STATUS) {
+			spin_unlock_irqrestore(lock, flags);
+			usb_ep_dequeue(cmdiu->ep, cmdiu->bh->inreq);
+			spin_lock_irqsave(lock, flags);
+		} else
+			cmdiu->state = COMMAND_STATE_ABORTED;
+	}
+	spin_unlock_irqrestore(lock, flags);
+
+tmiu_part:
+	if (!tm_func_queue)
+		return;
+
+	spin_lock_irqsave(lock, flags);
+	list_for_each_entry_safe(tmiu, tmp_tmiu, tm_func_queue, node) {
+		if (tmiu->state == COMMAND_STATE_STATUS) {
+			spin_unlock_irqrestore(lock, flags);
+			if (tmiu->bh->inreq_busy)
+				usb_ep_dequeue(tmiu->ep, tmiu->bh->inreq);
+			spin_lock_irqsave(lock, flags);
+		} else
+			tmiu->state = COMMAND_STATE_ABORTED;
+	}
+	spin_unlock_irqrestore(lock, flags);
+}
+
+/**
+ * do_uasp() - UASP main routine
+ * @udev: Programming view of uasp device
+ *
+ * This function is responsible for operating based on UASP protocol. It is
+ * responsible for:
+ * - Getting and initial processing of TM FUNCTION IU or COMMAND IU received
+ *   from HOST side via command endpoint. For more details please
+ *   see the description of get_command() function.
+ * - Processing of TM FUNCTION IUs addressed to IT_NEXUS. For more details
+ *   please see the tmiu.c file.
+ * - Processing of COMMAND IUs addressed to IT_NEXUS. For more details
+ *   please see the tmiu.c file.
+ * - Running the threads which are responsible for processing of TM FUNCTION
+ *   and COMMAND IUs addressed to a certain LUN. For more details please see
+ *   the description of fsg_lun_thread(void *_lun) function.
+ */
+void do_uasp(struct uasp_dev *udev)
+{
+	unsigned long		flags;
+	struct fsg_dev		*fsg = &(udev->fsg_dev);
+	struct uasp_common	*ucommon = udev->ucommon;
+	int rc;
+
+	DBG(ucommon->common, "%s() - Enter\n", __func__);
+
+	spin_lock_irqsave(&(fsg->common->lock), flags);
+	if (!exception_in_progress(fsg->common))
+		fsg->common->state = FSG_STATE_COMMAND_PHASE;
+	spin_unlock_irqrestore(&(fsg->common->lock), flags);
+
+	if (exception_in_progress(fsg->common))
+		return;
+
+	if (get_command(udev))
+		return;
+
+	spin_lock_irqsave(&(fsg->common->lock), flags);
+	if (!exception_in_progress(fsg->common))
+		fsg->common->state = FSG_STATE_DATA_PHASE;
+	spin_unlock_irqrestore(&(fsg->common->lock), flags);
+
+	if (exception_in_progress(fsg->common))
+		return;
+
+	spin_lock_irqsave(&(ucommon->common->lock), flags);
+	udev->pending_requests = 0;
+	spin_unlock_irqrestore(&(ucommon->common->lock), flags);
+
+	do_tmiu(udev, NULL);
+	if (exception_in_progress(fsg->common))
+		return;
+
+	do_cmdiu(udev, NULL);
+	if (exception_in_progress(fsg->common))
+		return;
+
+	remove_completed_commands(udev, &udev->cmd_queue, &udev->tm_func_queue);
+
+	spin_lock_irqsave(&(fsg->common->lock), flags);
+	if (!exception_in_progress(fsg->common)) {
+		fsg->common->state = FSG_STATE_IDLE;
+		spin_unlock_irqrestore(&(fsg->common->lock), flags);
+		run_lun_threads(udev, LUN_STATE_PROCESSING);
+	} else
+		spin_unlock_irqrestore(&(fsg->common->lock), flags);
+
+	rc = 0;
+	while (!rc) {
+		/* If exception is in progress */
+		if (exception_in_progress(ucommon->common)) {
+			DBG(ucommon->common,
+			    "%s() - Exception is in progress\n", __func__);
+			return;
+		}
+
+		/* Sleep if luns are in processing */
+		rc = all_lun_state_non_processing(udev);
+		if (!rc) {
+			DBG(ucommon->common,
+			    "%s() - Luns are in process\n", __func__);
+			goto sleep;
+		}
+
+		/* Wake up if command is received */
+		if (udev->cmd_buff.state == BUF_STATE_FULL) {
+			DBG(ucommon->common,
+			    "%s() - Command is received\n", __func__);
+			return;
+		}
+
+		/* Wake up if there are pending requests in luns */
+		if (pending_cmd_in_lun(udev)) {
+			DBG(ucommon->common,
+			    "%s() - Pending requests in LUN\n", __func__);
+			return;
+		}
+
+		/* Wake up if there are pending requests */
+		if (udev->pending_requests) {
+			DBG(ucommon->common,
+			    "%s() - Pending requests in device\n",
+			     __func__);
+			return;
+		}
+sleep:
+		/* Try to sleep */
+		DBG(ucommon->common, "%s() - Going to sleep\n", __func__);
+		rc = sleep_thread(fsg->common);
+		if (rc)
+			return;
+		DBG(ucommon->common, "%s() - Wakes up\n", __func__);
+
+		rc = 0;
+	}
+}
+
+/**
+ * close_lun() - Close the backing file of the given LUN
+ * @ulun: pointer to the LUn to close
+ *
+ * This function should be called when fsg_common->filesem is taken!
+ */
+void close_lun(struct uasp_lun *ulun)
+{
+	struct fsg_lun *fsglun = ulun->lun;
+
+	if (!fsg_lun_is_open(fsglun))
+		return;
+
+	fsg_lun_close(fsglun);
+	fsglun->unit_attention_data = SS_MEDIUM_NOT_PRESENT;
+}
+
+static int lun_exception_in_progress(struct uasp_lun *curlun)
+{
+	if (curlun->lun_state > LUN_STATE_PROCESSING)
+		return 1;
+
+	return 0;
+}
+
+/**
+ * handle_lun_exception() - Abort all TM and CMD IUs for a given LUN
+ * @udev: Programming view of file storage gadget.
+ * @curlun: Pointer to struct uasp_lun structure.
+ *
+ * This function is responsible for aborting the active TM FUNCTION and
+ * COMMAND IUs connected to the curlun, removing all TM FUNCTION and COMMAND
+ * IUs from appropriate queues, and keeping the exception data if there is a
+ * need.
+ */
+static void handle_lun_exception(struct uasp_dev *udev, struct uasp_lun *curlun)
+{
+	unsigned long flags;
+	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+
+	/* Abort all commands and remove them from lists */
+	abort_commands(udev, &curlun->cmd_queue, &curlun->tm_func_queue,
+		       &(curlun->lock));
+	remove_completed_commands(udev, &curlun->cmd_queue,
+				   &curlun->tm_func_queue);
+	curlun->pending_requests = 0;
+
+	spin_lock_irqsave(&(curlun->lock), flags);
+	switch (curlun->lun_state) {
+	case LUN_STATE_RESET:
+		curlun->lun->unit_attention_data = SS_RESET_OCCURRED;
+	case LUN_STATE_OVERLAPPED_TAG:
+		curlun->lun_state = LUN_STATE_PROCESSING;
+		break;
+	case LUN_STATE_EXIT:
+		curlun->lun_state = LUN_STATE_TERMINATED;
+		break;
+	default:
+		break;
+	}
+	spin_unlock_irqrestore(&(curlun->lock), flags);
+	DBG(udev->ucommon->common, "%s() - Exit\n", __func__);
+}
+
+/**
+ * uasp_lun_thread() - UASP LUN main thread
+ * @param: pointer to the uasp LUN structure
+ *
+ * Returns 0 on success -1 otherwise
+ *
+ * This function is UASP LUN main thread. It consist of a while loop that
+ * performs the following as long as the LUN state isn't terminated:
+ * - handles LUN exceptions if such exist
+ * - handles LUN specific cmd IUs
+ * - handles LUN specific tm IUs
+ * - removes completed IUs from cmd and tm queues
+ */
+static int uasp_lun_thread(void *param)
+{
+	struct uasp_lun		*ulun = (struct uasp_lun *)param;
+	struct uasp_dev		*udev;
+	unsigned long		flags;
+
+	if (!ulun)
+		return  -1;
+	udev = ulun->dev;
+	DBG(udev->ucommon->common, "%s() - Enter for lun_id = %d\n", __func__,
+					ulun->lun_id[7]);
+
+	while (ulun->lun_state != LUN_STATE_TERMINATED) {
+		DBG(udev->ucommon->common, "%s() - Wakes up\n", __func__);
+
+		if (lun_exception_in_progress(ulun)) {
+			DBG(udev->ucommon->common,
+			    "%s() - exception_in_progress!"
+			      " ulun->lun_state=%d\n", __func__,
+			    ulun->lun_state);
+			handle_lun_exception(udev, ulun);
+			continue;
+		}
+
+		/*
+		 * If the main thread isn't running, no need to run lun threads
+		 * as well.
+		 */
+		if (!udev->ucommon->common->running) {
+			DBG(udev->ucommon->common,
+			    "%s() - uasp thread main thread not running - "
+			    "going to sleep...\n", __func__);
+			sleep_lun_thread(ulun);
+			continue;
+		}
+
+		spin_lock_irqsave(&(ulun->lock), flags);
+		ulun->pending_requests = 0;
+		spin_unlock_irqrestore(&(ulun->lock), flags);
+
+		do_tmiu(udev, ulun);
+		if (lun_exception_in_progress(ulun))
+			continue;
+
+		do_cmdiu(udev, ulun);
+		if (lun_exception_in_progress(ulun))
+			continue;
+
+		remove_completed_commands(udev, &ulun->cmd_queue,
+					  &ulun->tm_func_queue);
+		if (lun_exception_in_progress(ulun))
+			continue;
+
+		spin_lock_irqsave(&(udev->ucommon->common->lock), flags);
+		if (!lun_exception_in_progress(ulun)) {
+			ulun->lun_state = LUN_STATE_IDLE;
+			wakeup_thread(udev->ucommon->common);
+		}
+		spin_unlock_irqrestore(&(udev->ucommon->common->lock), flags);
+
+		DBG(udev->ucommon->common, "%s() - Going to sleep\n", __func__);
+		sleep_lun_thread(ulun);
+		continue;
+	}
+
+	DBG(udev->ucommon->common, "uasp lun main loop: exiting\n");
+	spin_lock_irqsave(&(udev->ucommon->common->lock), flags);
+	ulun->lun_thread_task = NULL;
+	spin_unlock_irqrestore(&(udev->ucommon->common->lock), flags);
+	/* Let the unbind and cleanup routines know the thread has exited */
+	complete_and_exit(&ulun->thread_notifier, 0);
+	return 0;
+}
+
+/**
+ * uasp_main_thread() - UASP main thread
+ * @param: pointer to the uasp_common structure
+ *
+ * This function is UASP main thread. It consist of a while loop that performs
+ * the following as long as the state isn't terminated:
+ * - handles UASP device exceptions if such exist
+ * - calles do_uasp() (see do_uasp() function for more details)
+ * - when state is terminated closed all LUNS
+ */
+static int uasp_main_thread(void *param)
+{
+	struct uasp_common *ucommon = (struct uasp_common *)param;
+	struct fsg_common  *common = ucommon->common;
+
+	/*
+	 * Allow the thread to be killed by a signal, but set the signal mask
+	 * to block everything but INT, TERM, KILL, and USR1.
+	 */
+	allow_signal(SIGINT);
+	allow_signal(SIGTERM);
+	allow_signal(SIGKILL);
+	allow_signal(SIGUSR1);
+
+	/* Allow the thread to be frozen */
+	set_freezable();
+
+	/*
+	 * Arrange for userspace references to be interpreted as kernel
+	 * pointers.  That way we can pass a kernel pointer to a routine
+	 * that expects a __user pointer and it will work okay.
+	 */
+	set_fs(get_ds());
+
+		/* The main loop */
+	while (common->state != FSG_STATE_TERMINATED) {
+		DBG(common, "uasp main loop: continuing\n");
+		if (exception_in_progress(ucommon->common) ||
+		    signal_pending(current)) {
+			DBG(common, "uasp thread main loop: exception\n");
+			handle_uasp_exception(ucommon);
+			continue;
+		}
+
+		if (!common->running) {
+			DBG(common, "uasp thread main loop: not running\n");
+			sleep_thread(ucommon->common);
+			continue;
+		}
+		do_uasp(ucommon->udev);
+	}
+
+	DBG(common, "uasp main loop: exiting\n");
+
+	spin_lock_irq(&common->lock);
+	common->thread_task = NULL;
+	spin_unlock_irq(&common->lock);
+
+	if (!common->ops || !common->ops->thread_exits ||
+	    common->ops->thread_exits(common) < 0) {
+		struct uasp_lun	*ulun = ucommon->uluns;
+		unsigned i ;
+		down_write(&common->filesem);
+		for (i = 0; i < common->nluns; i++, ulun++)
+			close_lun(ulun);
+		up_write(&common->filesem);
+	}
+
+	/* Let the unbind and cleanup routines know the thread has exited */
+	complete_and_exit(&common->thread_notifier, 0);
+
+	return 0;
+}
+
+/**
+ * uasp_common_init() - Init uasp_common data structure
+ * @common: pointer to inited fsg_common data structure
+ * @cdev: pointer to usb_composite device that the UASP function is a part of
+ * @cfg: pointer to fsg_config data structure
+ *
+ * This function should be called after (struct fsg_common) common was already
+ * initiated by fsg_common_init
+ */
+static struct uasp_common *uasp_common_init(struct fsg_common *common,
+					  struct usb_composite_dev *cdev,
+					    struct fsg_config *cfg)
+{
+	struct fsg_lun *flun;
+	struct uasp_lun *ulun;
+	struct uasp_common	*ucommon;
+	int nluns = common->nluns;
+	int i, rc;
+
+	if (!common || !cdev || !cfg)
+		return NULL;
+
+	DBG(common, "%s() - Enter\n", __func__);
+
+	ucommon = kzalloc(sizeof *ucommon, GFP_KERNEL);
+	if (unlikely(!ucommon))
+		return NULL;
+
+	/* Save reference to fsg_common structure in ucommon */
+	ucommon->common = common;
+
+	/* Allocate the uLUNs and init them according to fsg_common luns */
+	ulun = kzalloc(nluns * sizeof *ulun, GFP_KERNEL);
+	if (!ulun) {
+		kfree(ucommon);
+		return ERR_PTR(-ENOMEM);
+	}
+	ucommon->uluns = ulun;
+
+	/* Create the reference between ulun and fsg_lun */
+	for (i = 0, flun = common->luns; i < nluns;
+				++i, ++flun, ++ulun)
+		ulun->lun = flun;
+
+	/*
+	 * Buffers in ubufs are static -- no need for additional allocation.
+	 * Connect each ubuf to fsg_buff from the buffhds cyclic list
+	 */
+	for (i = 0; i < FSG_NUM_BUFFERS; i++) {
+		ucommon->ubufs[i].fsg_buff = &(common->buffhds[i]);
+		ucommon->ubufs[i].ep = NULL;
+		ucommon->ubufs[i].stream_id = 0;
+	}
+
+	kref_init(&ucommon->ref);
+	/* Tell the thread to start working */
+	common->thread_task =
+		kthread_create(uasp_main_thread, (void *)ucommon,
+			       cfg->thread_name ?: "file-storage-UASP");
+	if (IS_ERR(common->thread_task)) {
+		rc = PTR_ERR(common->thread_task);
+		goto error_release;
+	}
+
+
+	/* Information */
+	INFO(common, UASP_DRIVER_DESC ", version: " UASP_DRIVER_VERSION "\n");
+	DBG(common, "I/O thread pid: %d\n", task_pid_nr(common->thread_task));
+
+	wake_up_process(common->thread_task);
+
+	return ucommon;
+
+error_release:
+	common->state = FSG_STATE_TERMINATED;	/* The thread is dead */
+	/* Call uasp_common_release() directly, ref might be not initialised */
+	uasp_common_release(&common->ref);
+	return ERR_PTR(rc);
+}
+
+/**
+ * finish_lun_init() - Finish the LUN structure inialization
+ * @udev: Programming view of file storage gadget.
+ *
+ * This function is used to init the uasp_lun fileds. It's called from uasp_add
+ * after the uasp_dev was allocated. It creates (and starts) all lun tasks
+ */
+static int finish_lun_init(struct uasp_dev *udev)
+{
+	int i, j, rc = 0;
+	struct uasp_lun *ulun = NULL;
+	char thread_name[20];
+
+	if (!udev)
+		return -EIO;
+
+	for (i = 0, ulun = udev->ucommon->uluns;
+	       i < udev->ucommon->common->nluns; i++, ulun++) {
+		/* TODO: this is a workaround, fix later */
+		memset(ulun->lun_id, 0, 8);
+		ulun->lun_id[0] = i;
+		INIT_LIST_HEAD(&ulun->cmd_queue);
+		INIT_LIST_HEAD(&ulun->tm_func_queue);
+		ulun->lun_state = LUN_STATE_IDLE;
+		ulun->dev = udev;
+		ulun->pending_requests = ulun->active_requests = 0;
+
+		/* Create and start lun threads */
+		sprintf(thread_name, "uasp-lun-thread%d", i);
+		DBG(udev->ucommon->common,
+		    "creating & starting lun thread: thread_name = %s\n",
+		    thread_name);
+
+		ulun->lun_thread_task = kthread_create(uasp_lun_thread,
+						       (void *)ulun,
+						       thread_name);
+		if (IS_ERR(ulun->lun_thread_task)) {
+			rc = PTR_ERR(ulun->lun_thread_task);
+			goto err_lun_init;
+		}
+		init_completion(&ulun->thread_notifier);
+		wake_up_process(ulun->lun_thread_task);
+	}
+	INFO(udev->ucommon->common, "All lun threads are started\n");
+	return rc;
+
+err_lun_init:
+	for (j = 0, ulun = udev->ucommon->uluns ; j < i; j++, ulun++)
+		ulun->lun_state = LUN_STATE_EXIT;
+	return rc;
+}
+
+/*
+ * uasp_bind() - bind function
+ * @c: pointer to the usb configuration
+ * @f: pointer to the usb function
+ *
+ * Return 0 on succeed, error code on failure
+ *
+ * TODO: Add fall back to usb_ep_autoconfig() if usb_ep_autoconfig_ss() fails.
+ *       In that case mark somehow that we can only operate in HS mode
+ */
+static int __init uasp_bind(struct usb_configuration *c, struct usb_function *f)
+{
+	struct uasp_dev		*uaspd = uaspd_from_func(f);
+	struct fsg_dev		*fsgd = &(uaspd->fsg_dev);
+	struct usb_gadget	*gadget = c->cdev->gadget;
+	int			rc;
+	int			i;
+	struct usb_ep		*ep;
+
+	fsgd->common->gadget = gadget;
+
+	/* Allocate new interface */
+	i = usb_interface_id(c, f);
+	if (i < 0)
+		return i;
+	uasp_intf_desc.bInterfaceNumber = i;
+	fsgd->interface_number = i;
+
+	/* Find all the endpoints we will use */
+	ep = usb_ep_autoconfig_ss(gadget, &uasp_ss_bulk_in_desc,
+				  &uasp_bulk_in_ep_comp_desc);
+	if (!ep)
+		goto autoconf_fail;
+	ep->driver_data = uaspd;	/* claim the endpoint */
+	fsgd->bulk_in = ep;
+
+	ep = usb_ep_autoconfig_ss(gadget, &uasp_ss_bulk_out_desc,
+				  &uasp_bulk_out_ep_comp_desc);
+	if (!ep)
+		goto autoconf_fail;
+	ep->driver_data = uaspd;	/* claim the endpoint */
+	fsgd->bulk_out = ep;
+
+	ep = usb_ep_autoconfig_ss(gadget, &uasp_ss_status_in_desc,
+				  &uasp_status_in_ep_comp_desc);
+	if (!ep)
+		goto autoconf_fail;
+	ep->driver_data = uaspd;	/* claim the endpoint */
+	uaspd->status = ep;
+
+	ep = usb_ep_autoconfig_ss(gadget, &uasp_ss_command_out_desc,
+				  &uasp_command_out_ep_comp_desc);
+	if (!ep)
+		goto autoconf_fail;
+	ep->driver_data = uaspd;	/* claim the endpoint */
+	uaspd->command = ep;
+
+	/* Assume endpoint addresses are the same for both speeds */
+	uasp_bulk_in_desc.bEndpointAddress =
+		uasp_ss_bulk_in_desc.bEndpointAddress;
+	uasp_bulk_out_desc.bEndpointAddress =
+		uasp_ss_bulk_out_desc.bEndpointAddress;
+	uasp_status_in_desc.bEndpointAddress =
+		uasp_ss_status_in_desc.bEndpointAddress;
+	uasp_command_out_desc.bEndpointAddress =
+		uasp_ss_command_out_desc.bEndpointAddress;
+	f->ss_descriptors = uasp_ss_function_desc;
+
+	return 0;
+
+autoconf_fail:
+	ERROR(fsgd->common, "unable to autoconfigure all endpoints\n");
+	rc = -ENOTSUPP;
+	return rc;
+}
+
+static void uasp_unbind(struct usb_configuration *c, struct usb_function *f)
+{
+	struct uasp_dev		*uaspd = uaspd_from_func(f);
+
+	DBG(uaspd->fsg_dev.common, "unbind\n");
+	if (uaspd->fsg_dev.common->fsg == &(uaspd->fsg_dev)) {
+		uaspd->fsg_dev.common->new_fsg = NULL;
+		raise_exception(uaspd->fsg_dev.common, FSG_STATE_CONFIG_CHANGE);
+		/* TODO: make interruptible or killable somehow? */
+		wait_event(uaspd->fsg_dev.common->fsg_wait,
+			   !uaspd->ucommon->common->fsg);
+	}
+	uasp_common_put(uaspd->ucommon);
+	kfree(uaspd->cmd_buff.buf);
+	kfree(uaspd);
+}
+
+static int uasp_set_alt(struct usb_function *f, unsigned intf, unsigned alt)
+{
+	struct fsg_dev *fsg = fsg_from_func(f);
+	fsg->common->new_fsg = fsg;
+	raise_exception(fsg->common, FSG_STATE_CONFIG_CHANGE);
+	return 0;
+}
+
+static void uasp_disable(struct usb_function *f)
+{
+	struct uasp_dev *udev = uaspd_from_func(f);
+
+	udev->fsg_dev.common->new_fsg = NULL;
+	raise_exception(udev->fsg_dev.common, FSG_STATE_CONFIG_CHANGE);
+}
+
+/**
+ * uasp_add() - Add the UASP function to the given configuration
+ * @cdev: pointer to the composite device
+ * @c: usb configuration to add the function to
+ * @common: pointer to the fsg_common data structure
+ * @ucommon: pointer to uasp common data structure
+ *
+ * Returns 0 on sucsess error code otherwise
+ *
+ * Initiate the uasp_function and adds it to the given configuration by calling
+ * usb_add_function()
+ */
+static int uasp_add(struct usb_composite_dev *cdev,
+		   struct usb_configuration *c,
+		   struct fsg_common *common,
+		   struct uasp_common *ucommon)
+{
+	struct uasp_dev *uaspd;
+	int rc;
+
+	uaspd = kzalloc(sizeof *uaspd, GFP_KERNEL);
+	if (unlikely(!uaspd))
+		return -ENOMEM;
+
+	uaspd->fsg_dev.function.name		= UASP_DRIVER_DESC;
+	uaspd->fsg_dev.function.strings		= fsg_strings_array;
+	uaspd->fsg_dev.function.descriptors	= uasp_hs_function_desc;
+	uaspd->fsg_dev.function.hs_descriptors	= uasp_hs_function_desc;
+	uaspd->fsg_dev.function.bind		= uasp_bind;
+	uaspd->fsg_dev.function.unbind		= uasp_unbind;
+	uaspd->fsg_dev.function.set_alt		= uasp_set_alt;
+	uaspd->fsg_dev.function.disable		= uasp_disable;
+
+	uaspd->fsg_dev.common			= common;
+
+	uaspd->ucommon = ucommon;
+
+	/* Init the command and status buffers */
+	uaspd->cmd_buff.buf = kmalloc(FSG_BUFLEN, GFP_KERNEL);
+	if (unlikely(!uaspd->cmd_buff.buf)) {
+		rc = -ENOMEM;
+		goto uasp_add_err;
+	}
+
+	ucommon->udev = uaspd;
+	rc = finish_lun_init(uaspd);
+	if (rc)
+		goto uasp_add_err;
+
+	INIT_LIST_HEAD(&uaspd->cmd_queue);
+	INIT_LIST_HEAD(&uaspd->tm_func_queue);
+	/*
+	 * Our caller holds a reference to common structure so we don't have
+	 * to be worry about it being freed until we return from this function.
+	 * So instead of incrementing counter now and decrement in error
+	 * recovery we increment it only when call to usb_add_function() was
+	 * successful.
+	 */
+	rc = usb_add_function(c, &uaspd->fsg_dev.function);
+
+	if (likely(rc == 0))
+		kref_get(&ucommon->ref);
+	else
+		goto uasp_add_err;
+
+	return rc;
+uasp_add_err:
+	kfree(ucommon);
+	kfree(uaspd->cmd_buff.buf);
+	kfree(uaspd);
+	return rc;
+}
+
+/**
+ * fill_usb_request() - fills the usb_request structure with the given values.
+ * @req: pointer to usb_request structure to be filled.
+ * @buf: the buffer to send/receive
+ * @length: length field of the request.
+ * @zero: zero field of the request.
+ * @context: context field of the request.
+ * @short_not_ok: short_not_ok field of the request.
+ * @stream_id: stream_id field of the request.
+ * @complete: complete function to be called on request completion
+ *
+ */
+void fill_usb_request(struct usb_request *req,
+		      void *buf,
+		      unsigned length,
+		      unsigned zero,
+		      void *context,
+		      unsigned short_not_ok,
+		      unsigned stream_id,
+		      usb_request_complete_t complete)
+{
+	req->buf = buf;
+	req->length = length;
+	req->zero = zero;
+	req->context = context;
+	req->short_not_ok = short_not_ok;
+	req->stream_id = stream_id;
+	req->complete = complete;
+}
+
diff --git a/drivers/usb/gadget/f_uasp.h b/drivers/usb/gadget/f_uasp.h
new file mode 100644
index 0000000..42e0d0fa
--- /dev/null
+++ b/drivers/usb/gadget/f_uasp.h
@@ -0,0 +1,436 @@
+/*
+ * f_uasp.h -- Mass Storage USB UASP Composite Function header
+ *
+ * Copyright (C) 2003-2005 Alan Stern
+ * Copyright (C) 2011 Code Aurora Forum.
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#ifndef _F_UASP_H
+#define _F_UASP_H
+
+#include <linux/kernel.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+
+#define UASP_DRIVER_DESC	"Mass Storage UASP Function"
+#define UASP_DRIVER_VERSION	"2010/07/1"
+
+/* Pipe usage descriptor: refer to UAS spec 5.3.3.5 */
+#define USB_DT_PIPE_USAGE	0x24
+
+typedef void (*usb_request_complete_t)(struct usb_ep *ep,
+				      struct usb_request *req);
+
+/* IU identifier summary - see table 10 of the UAS Spec */
+enum iu_id {
+	IU_ID_COMMAND			= 0x01,
+	IU_ID_SENSE			= 0x03,
+	IU_ID_RESPONSE			= 0x04,
+	IU_ID_TASK_MANAGEMENT		= 0x05,
+	IU_ID_READ_READY		= 0x06,
+	IU_ID_WRITE_READY		= 0x07,
+};
+
+/* TASK ATTRIBUTE field - see table 13 of the UAS Spec */
+enum task_attribute_data {
+	TASK_ATTR_SIMPLE		= 0,
+	TASK_ATTR_HEAD_OF_QUEUE		= 1,
+	TASK_ATTR_ORDERED		= 2,
+	TASK_ATTR_ACA			= 4,
+};
+
+/* USB_DT_PIPE_USAGE: Pipe usage descriptor */
+struct usb_pipe_usage_descriptor {
+	__u8  bLength;
+	__u8  bDescriptorType;
+
+	__u8  bPipeID;
+/* Pipe ID defenitions: Table 9 from UAS spec*/
+#define PIPE_ID_CMD		0x01	/* Command pipe */
+#define PIPE_ID_STS		0x02	/* Status pipe */
+#define PIPE_ID_DATA_IN		0x03	/* Data-in piep */
+#define PIPE_ID_DATA_OUT	0x04	/* Data-out pipe */
+	__u8  Reserved;
+} __attribute__((__packed__));
+
+/**
+ * struct uasp_buff - UASP buffer definition.
+ * @fsg_buff: pointer to the fsg_buf that this structure extends
+ * @ep: the ep the buff was allocated for
+ * @stream_id: Same as in struct usb_req
+ *
+ * Extends the struct fsg_buffhd. Each (used) buffer will be assigned to a
+ * specific stream. The stream is the same as the stream_id in the usb_request
+ * the buffer is assigned for.
+ * Note: stream_id has a meaning only when ep != null
+ */
+struct uasp_buff {
+	struct fsg_buffhd	*fsg_buff;
+	struct usb_ep		*ep;
+	unsigned		stream_id:16;
+};
+
+/**
+ * struct uasp_common - Common data shared by all UASP devices
+ * @udev: Programming view of uasp device.
+ * @common: points to fsg_common in fsg_dev
+ * @ubufs: buffers to be used by the uasp device. Each element in
+ *	ubufs[i].fsg_buff points to a fsg_buffhd struct from fsg_common data
+ *	structure
+ * @uluns: luns of the uasp device. Each element in uluns[i].lun points to a
+ *	fsg_lun array element from fsg_common data structure
+ *
+ * Extends the struct fsg_common structure.
+ */
+struct uasp_common {
+	struct uasp_dev		*udev;
+	struct fsg_common	*common;
+	struct uasp_buff	ubufs[FSG_NUM_BUFFERS];
+	struct uasp_lun		*uluns;
+	struct kref		ref;
+};
+
+/**
+ * struct uasp_dev - Programming view of the uasp device
+ * @fsg_dev: pointer to the fsg_dev this struct extends
+ * @ucommon: pointer to the common data of the device
+ * @status: status endpoint
+ * @command: command endpoint
+ * @cmd_buff: buffer used for receiving commannd IUs
+ * @op_mode: operation mode (HS_UASP_MODE/SS_UASP_MODE)
+ * @cmd_enabled: TRUE if command endpoint is enabled
+ * @status_enabled: TRUE if status endpoint is enabled
+ * @cmd_queue: General Command IUs queue
+ * @tm_func_queue: General Task Management IUs queue
+ * @active_requests: counter for currently handled (active) general requests
+ * @pending_requests: counter for pending general requests
+ *
+ * Extends the struct fsg_dev structure.
+ */
+struct uasp_dev {
+	struct fsg_dev		fsg_dev;
+
+	struct uasp_common	*ucommon;
+	struct usb_ep		*status;
+	struct usb_ep		*command;
+	struct fsg_buffhd	cmd_buff;
+
+	unsigned int		cmd_enabled;
+	unsigned int		status_enabled;
+
+	struct list_head	cmd_queue;
+	struct list_head	tm_func_queue;
+	int			active_requests;
+	int			pending_requests;
+};
+
+/* LUN state */
+enum lun_state {
+	LUN_STATE_IDLE			= 0,
+	LUN_STATE_PROCESSING		= 1,
+	LUN_STATE_RESET			= 2,
+	LUN_STATE_OVERLAPPED_TAG	= 3,
+	LUN_STATE_EXIT			= 4,
+	LUN_STATE_TERMINATED		= 5,
+};
+
+/**
+ * struct uasp_lun - Describes the uasp LUN
+ * @lun: pointer to the fsg_lun this struct extends
+ * @lun_id: id of this LUN
+ * @cmd_queue: Command IUs queue
+ * @tm_func_queue: TaskManagement IUs queue
+ * @lun_state: one of the values from enum lun_state
+ * @dev: Programming view of uasp device.
+ * @lock: lock protects for protecting: state, all the req_busy's
+ * @thread_wakeup_needed: TRUE if the LUN thread needs wakening
+ * @lun_thread_task: thread of this LUN. Performs all LUN tasks
+ * @thread_notifier: used for lun_thread_task
+ * @pending_requests: counter for pending requests for this LUN
+ * @active_requests: counter for currently handled (active) requests for
+ *	this LUN
+ *
+ * Extends the struct fsg_lun structure.
+ */
+struct uasp_lun {
+	struct fsg_lun		*lun;
+	__u8			lun_id[8];
+	struct list_head	cmd_queue;
+	struct list_head	tm_func_queue;
+	enum lun_state		lun_state;
+	struct uasp_dev		*dev;
+
+	spinlock_t		lock;
+
+	int			thread_wakeup_needed;
+	struct task_struct	*lun_thread_task;
+	struct completion	thread_notifier;
+
+	int			pending_requests;
+	int			active_requests;
+};
+
+
+/* COMMAND IU related defenitions*/
+/* COMMAND IU state */
+enum command_state {
+	COMMAND_STATE_IDLE		= 0,
+	COMMAND_STATE_RR_WR		= 1,
+	COMMAND_STATE_DATA		= 2,
+	COMMAND_STATE_STATUS		= 3,
+	COMMAND_STATE_ABORTED		= 4,
+	COMMAND_STATE_COMPLETED		= 5,
+	COMMAND_STATE_FAILED		= 6,
+};
+
+/**
+ * struct cmd_iu - COMMAND IU - Section 6.2.2 from UAS Spec
+ * @iu_id: should be set to 01h
+ * @reserved: should be set to 0
+ * @tag: see section 4.2 of the UAS spec
+ * @forth_byte: the forth byte of the COMMAND IU. Holds cmd priority and
+ *	task attribute
+ * @reserved5: should be set to 0
+ * @length: the length of the CDB. Represented by bits 2-7.
+ *	Bits0-1 are reserved
+ * @reserved7: should be set to 0
+ * @lun: LUN ID for this command
+ * @cdb: the SCSI CDB
+ * @add_cdb: Additional byted of the CDB
+ * @bh: buffer used for handling this command
+ * @state: command state. See enum command_state
+ * @ep: Endpoint on which the processing of COMMAND IU currently performs
+ * @req_sts: Status of the struct usb_request item submitted for certain
+ *	COMMAND IU
+ * @file_offset: For READ, WRITE, VERIFY SCSI COMMANDs the current file offset
+ * @xfer_len: For READ, WRITE, VERIFY SCSI COMMANDs the remaining transfer
+ *	length
+ * @node: Link for adding to the queue
+ */
+struct cmd_iu {
+	__u8 iu_id;
+	__u8 reserved;
+	__be16 tag;
+
+	struct {
+		unsigned reserved:1;
+		unsigned command_priority:4;
+		unsigned task_attribute:3;
+	} __attribute__((__packed__)) forth_byte;
+
+	__u8 reserved5;
+	__u8 length;
+	__u8 reserved7;
+	__u8 lun[8];
+	__u8 cdb[16];
+	__u8 *add_cdb;
+
+	struct fsg_buffhd *bh;
+	int state;
+	struct usb_ep *ep;
+
+#define CMD_REQ_NOT_SUBMITTED	0
+#define CMD_REQ_IN_PROGRESS	1
+#define CMD_REQ_COMPLETED	2
+	__u8 req_sts;
+	u32 file_offset;
+	u32 xfer_len;
+	struct list_head node;
+};
+
+
+/* STATUS values of SENSE IU as defined in SAM-4 */
+enum status_code_data {
+	STATUS_GOOD =			0x00,
+	STATUS_CHECK_CONDITION =	0x02,
+	STATUS_CONDITION_MET =		0x04,
+	STATUS_BUSY =			0x08,
+	STATUS_RESERVATION_CONFLICT =	0x18,
+	STATUS_TASK_SET_FULL =		0x28,
+	STATUS_ACA_ACTIVE =		0x30,
+	STATUS_TASK_ABORTED =		0x40,
+};
+
+/* SENSE IU - section 6.2.5 of the UAS spec */
+struct sense_iu {
+	__u8 iu_id;
+	__u8 reserved1;
+	__be16 tag;
+	__be16 status_qual;
+	__u8 status;
+	__u8 rsvd8[6];
+	__be16 len;
+	__u8 sense_data[SCSI_SENSE_BUFFERSIZE];
+};
+#define UASP_SIZEOF_SENSE_IU	(16 + SCSI_SENSE_BUFFERSIZE)
+
+/* TASK MANAGEMENT IU related defenitions */
+/* TM FUNCTION types - see table 20 of the UAS Spec */
+enum tm_function_data {
+	TM_FUNCTION_ABORT_TASK			= 0x01,
+	TM_FUNCTION_ABORT_TASK_SET		= 0x02,
+	TM_FUNCTION_CLEAR_TASK_SET		= 0x04,
+	TM_FUNCTION_RESET_LUN			= 0x08,
+	TM_FUNCTION_IT_NEXUS_RESET		= 0x10,
+	TM_FUNCTION_CLEAR_ACA			= 0x40,
+	TM_FUNCTION_QUERY_TASK			= 0x80,
+	TM_FUNCTION_QUERY_TASK_SET		= 0x81,
+	TM_FUNCTION_QUERY_ASYNC_EVENT	= 0x82,
+};
+
+/**
+ * struct tm_iu - TM FUNCTION IU  - see table 19 of the UAS Spec
+ * @iu_id: Should be set to 05h
+ * @reserved: should be set to 0
+ * @tag: section 4.2 of the UAS spec
+ * @tm_function: valid values defined in struct tm_function_data
+ * @reserved5: should be set to 0
+ * @task_tag: Reserved for all tm_functions but ABORT_TASK and QUERY_TASK
+ * @lun: LUN ID for this command
+ * @bh: buffer used for handling this command
+ * @ep: Endpoint on which the processing of TM FUNCTION IU currently performs
+ * @state: State of the TM FUNCTION IU
+ * @node: Link for adding to the queue
+ */
+struct tm_iu {
+	__u8 iu_id;
+	__u8 reserved1;
+	__be16 tag;
+	__u8 tm_function;
+	__u8 reserved5;
+	__be16 task_tag;
+	__u8 lun[8];
+
+	struct fsg_buffhd *bh;
+	struct usb_ep *ep;
+	int state;
+	struct list_head node;
+};
+
+/* Response code values of RESPONSE IU - see table 18 of the UAS Spec */
+enum response_code_data {
+	RESPONSE_TM_FUNCTION_COMPLETE		= 0x00,
+	RESPONSE_INVALID_IU			= 0x02,
+	RESPONSE_TM_FUNCTION_NOT_SUPPORTED	= 0x04,
+	RESPONSE_TM_FUNCTION_FAILED		= 0x05,
+	RESPONSE_TM_FUNCTION_SUCCEEDED		= 0x08,
+	RESPONSE_INCORRECT_LUN			= 0x09,
+	RESPONSE_OVERLAPPED_TAG_ATTEMPTED	= 0x0A,
+};
+
+/* RESPONSE IU - see table 17 of the UAS Spec */
+struct response_iu {
+	__u8 iu_id;
+	__u8 reserved;
+	__be16 tag;
+	__u8 resp_info[3];
+	__u8 status;
+} __attribute__((__packed__));
+#define UASP_SIZEOF_RESPONSE_IU		8
+
+void fill_usb_request(struct usb_request *req,
+		      void *buf,
+		      unsigned length,
+		      unsigned zero,
+		      void *context,
+		      unsigned short_not_ok,
+		      unsigned stream_id,
+		      usb_request_complete_t complete);
+
+/**
+ * uasp_bulk_in_complete() - Callback function for the bulk IN endpoint
+ * @ep: pointer to the usb_ep (bulk IN endpoint)
+ * @req: usb_request received on this endpoint
+ *
+ * This function is passed to the outreq->complete() of the bulk IN endpoint.
+ * The requests cmdiu state is updated according to the completion status of
+ * the usb request. If the cmdiu was LUN specific, the  corresponding LUN
+ * thread is awaken. If it was general, uasp main thread is awaken. */
+void uasp_bulk_in_complete(struct usb_ep *ep, struct usb_request *req);
+
+/**
+ * uasp_bulk_out_complete() - Callback function for the bulk OUT
+ * endpoint
+ * @ep: pointer to the usb_ep (bulk OUT endpoint)
+ * @req: usb_request received on this endpoint
+ *
+ * This function is passed to the outreq->complete() of the bulk
+ * OUT endpoint. The requests cmdiu state is updated according
+ * to the completion status of the usb request. If the cmdiu was
+ * LUN specific, the  corresponding LUN thread is awaken. If it
+ * was general, uasp main thread is awaken.
+ */
+void uasp_bulk_out_complete(struct usb_ep *ep, struct usb_request *req);
+
+/**
+ * status_complete() - Callback function for the status endpoint
+ * @ep: pointer to the usb_ep (status endpoint)
+ * @req: usb_request received on this endpoint
+ *
+ * This function is passed to the outreq->complete() of the status endpoint.
+ * If the request completion status isn't ECONNRESET the requests tmiu/cmdiu
+ * state is updated to aborted/completed/failed (according to the completion
+ * status of the usb request). If the tmiu/cmdiu was LUN specific, the
+ * corresponding LUN thread is awaken. If it was general, uasp main thread is
+ * awaken.
+ */
+void status_complete(struct usb_ep *ep, struct usb_request *req);
+
+/**
+ * abort_commands() - Aborts all IUs on given queues
+ * @udev: Programming view of uasp device
+ * @cmd_queue: pointer to the cmd IUs queue to abort IUs from
+ * @tm_func_queue: pointer to the tm IUs queue to abort IUs from
+ * @lock: pointer to spinlock_t to lock when performing the abort.
+ *	Can be udev->lock if the cmd_queue and the tm_func_queue are general,
+ *	or curlun->lock if they belong to a specific LUN
+ *
+ * TODO: Add wait mechanism using curlun->active_requests or
+ * udev->active_requests
+ */
+void abort_commands(struct uasp_dev *udev,
+			struct list_head *cmd_queue,
+			struct list_head *tm_func_queue,
+			spinlock_t *lock);
+
+/**
+ * run_lun_threads() - Wakeup all LUN threads with a given state
+ * @udev: Programming view of uasp device
+ * @state: The state to run the LUn in (from enum lun_state)
+ *
+ */
+void run_lun_threads(struct uasp_dev *udev, int state);
+
+/**
+ * all_lun_state_non_processing() - Returns 1, if all luns are in
+ * none-processing state
+ * @udev: Programming view of uasp device
+ *
+ */
+int all_lun_state_non_processing(struct uasp_dev *udev);
+
+/**
+ * close_lun() - Close the backing file of the given LUN
+ * @ulun: pointer to the LUn to close
+ *
+ * This function should be called when fsg_common->filesem is
+ * taken!
+ */
+void close_lun(struct uasp_lun *ulun);
+
+#endif /* _F_UASP_H */
diff --git a/drivers/usb/gadget/mass_storage.c b/drivers/usb/gadget/mass_storage.c
index 0182242..8faa850 100644
--- a/drivers/usb/gadget/mass_storage.c
+++ b/drivers/usb/gadget/mass_storage.c
@@ -62,6 +62,7 @@
 #include "config.c"
 #include "epautoconf.c"
 #include "f_mass_storage.c"
+#include "f_uasp.c"
 
 /*-------------------------------------------------------------------------*/
 
@@ -75,7 +76,7 @@ static struct usb_device_descriptor msg_device_desc = {
 	/* Vendor and product id can be overridden by module parameters.  */
 	.idVendor =		cpu_to_le16(FSG_VENDOR_ID),
 	.idProduct =		cpu_to_le16(FSG_PRODUCT_ID),
-	.bNumConfigurations =	1,
+	.bNumConfigurations =	2,
 };
 
 static struct usb_otg_descriptor otg_descriptor = {
@@ -130,7 +131,8 @@ static int __init msg_do_config(struct usb_configuration *c)
 	fsg_config_from_params(&config, &mod_data);
 	config.ops = &ops;
 
-	retp = fsg_common_init(&common, c->cdev, &config);
+	/* Init fsg_common and start the fsg main thread */
+	retp = fsg_common_init(&common, c->cdev, &config, 1);
 	if (IS_ERR(retp))
 		return PTR_ERR(retp);
 
@@ -145,19 +147,72 @@ static struct usb_configuration msg_config_driver = {
 	.bmAttributes		= USB_CONFIG_ATT_SELFPOWER,
 };
 
+static int __init uasp_do_config(struct usb_configuration *c)
+{
+	static const struct fsg_operations ops = {
+		.thread_exits = msg_thread_exits,
+	};
+
+	struct fsg_common *fcommon;
+	struct uasp_common *ucommon;
+	struct fsg_config config;
+	int ret = 0;
+
+	fsg_config_from_params(&config, &mod_data);
+	config.ops = &ops;
+	fcommon = fsg_common_init(0, c->cdev, &config, 0);
+	if (IS_ERR(fcommon))
+		return PTR_ERR(fcommon);
+
+	ucommon = uasp_common_init(fcommon, c->cdev, &config);
+	if (IS_ERR(ucommon))
+		return PTR_ERR(ucommon);
+	ret = uasp_add(c->cdev, c, fcommon, ucommon);
+	uasp_common_put(ucommon);
+
+	return ret;
+}
+
+static struct usb_configuration uasp_config_driver = {
+	.label			= "Linux UASP File-Backed Storage",
+	.bConfigurationValue	= 2,
+	.bmAttributes		= USB_CONFIG_ATT_SELFPOWER,
+};
+
+
 
 /****************************** Gadget Bind ******************************/
 
+bool use_uasp ;
+module_param(use_uasp, bool, S_IRUGO | S_IWUSR);
 static int __init msg_bind(struct usb_composite_dev *cdev)
 {
 	int status;
 
-	status = usb_add_config(cdev, &msg_config_driver, msg_do_config);
-	if (status < 0)
-		return status;
-
 	dev_info(&cdev->gadget->dev,
 		 DRIVER_DESC ", version: " DRIVER_VERSION "\n");
+
+	if (use_uasp) {
+		/*
+		 * TODO: fix the bellow!
+		 * Right now the host always chooses the first configuration.
+		 * Untill this is fixed, if we want the device to opperate in
+		 * UASP mode we switch the configurations numbers
+		 */
+		msg_config_driver.bConfigurationValue = 2;
+		uasp_config_driver.bConfigurationValue = 1;
+		/* register uasp configuration */
+		status = usb_add_config(cdev, &uasp_config_driver,
+					uasp_do_config);
+		if (status < 0)
+			return status;
+	} else {
+		/* register our second configuration */
+		status = usb_add_config(cdev, &msg_config_driver,
+					msg_do_config);
+		if (status < 0)
+			return status;
+	}
 	set_bit(0, &msg_registered);
 	return 0;
 }
diff --git a/drivers/usb/gadget/storage_common.c b/drivers/usb/gadget/storage_common.c
index b015561..d33d73c 100644
--- a/drivers/usb/gadget/storage_common.c
+++ b/drivers/usb/gadget/storage_common.c
@@ -220,6 +220,7 @@ struct interrupt_data {
 #define SS_UNRECOVERED_READ_ERROR		0x031100
 #define SS_WRITE_ERROR				0x030c02
 #define SS_WRITE_PROTECTED			0x072700
+#define SS_OVERLAPPED_COMMANDS_ATTEMPTED	0x0b4e00
 
 #define SK(x)		((u8) ((x) >> 16))	/* Sense Key byte, etc. */
 #define ASC(x)		((u8) ((x) >> 8))
@@ -262,8 +263,15 @@ static struct fsg_lun *fsg_lun_from_dev(struct device *dev)
 #define EP0_BUFSIZE	256
 #define DELAYED_STATUS	(EP0_BUFSIZE + 999)	/* An impossibly large value */
 
-/* Number of buffers we will use.  2 is enough for double-buffering */
-#define FSG_NUM_BUFFERS	2
+/*
+ * We limit the number of UASP streams by 16 due to memory requirements.
+ * 4 buffer will be allocated for each supported stream.
+ * TODO: Update this value in the future if influences (or not) the performance.
+ */
+#define UASP_SS_EP_COMP_NUM_STREAMS 4
+
+/* Number of buffers we will use. */
+#define FSG_NUM_BUFFERS         (4*(2^UASP_SS_EP_COMP_NUM_STREAMS))
 
 /* Default size of buffer length. */
 #define FSG_BUFLEN	((u32)16384)
@@ -543,7 +551,7 @@ static int fsg_lun_open(struct fsg_lun *curlun, const char *filename)
 	ro = curlun->initially_ro;
 	if (!ro) {
 		filp = filp_open(filename, O_RDWR | O_LARGEFILE, 0);
-		if (PTR_ERR(filp) == -EROFS || PTR_ERR(filp) == -EACCES)
+		if (-EROFS == PTR_ERR(filp))
 			ro = 1;
 	}
 	if (ro)
@@ -558,7 +566,10 @@ static int fsg_lun_open(struct fsg_lun *curlun, const char *filename)
 
 	if (filp->f_path.dentry)
 		inode = filp->f_path.dentry->d_inode;
-	if (!inode || (!S_ISREG(inode->i_mode) && !S_ISBLK(inode->i_mode))) {
+	if (inode && S_ISBLK(inode->i_mode)) {
+		if (bdev_read_only(inode->i_bdev))
+			ro = 1;
+	} else if (!inode || !S_ISREG(inode->i_mode)) {
 		LINFO(curlun, "invalid file type: %s\n", filename);
 		goto out;
 	}
diff --git a/drivers/usb/gadget/uasp_cmdiu.c b/drivers/usb/gadget/uasp_cmdiu.c
new file mode 100644
index 0000000..4b3ed24
--- /dev/null
+++ b/drivers/usb/gadget/uasp_cmdiu.c
@@ -0,0 +1,520 @@
+/*
+ * uasp_cmdiu.c -- Mass Storage UAS Protocol - COMMAND IUs handling
+ *		   implementation
+ *
+ * Copyright (C) 2003-2005 Alan Stern
+ * Copyright (C) 2011 Code Aurora Forum.
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#include <linux/list.h>
+#include "f_uasp.h"
+
+/**
+ * get_buffhd() - returns a buffer fot IU processing
+ * @bh: Array of the buffers in which the search should be done.
+ *
+ * Return pointer to the found buffer if it exists, 0 otherwise.
+ *
+ * This function tries to find a free buffer for COMMAND IU or
+ * TM FUNCTION IU processing.
+ */
+struct fsg_buffhd *get_buffhd(struct fsg_buffhd *bh)
+{
+	int i;
+
+	for (i = 0; i < FSG_NUM_BUFFERS; i++) {
+		if (bh[i].state == BUF_STATE_EMPTY) {
+			bh[i].state = BUF_STATE_BUSY;
+			return &bh[i];
+		}
+	}
+
+	return NULL;
+}
+
+/**
+ * check_cmdiu() - initial verification of the COMMAND IU
+ * @udev: Programming view of UASP device.
+ * @curlun: Pointer to struct lun if the COMMAND IU to be checked is addressed
+ *	to a valid LUN, 0 otherwise.
+ * @cmdiu: COMMAND IU to be checked.
+ * @needs_medium: Specifies, is the medium needed for the COMMAND IU processing.
+ */
+static __u32 check_cmdiu(struct uasp_dev *udev,
+			    struct uasp_lun *curlun,
+			    struct cmd_iu *cmdiu,
+			    __u8 needs_medium)
+{
+	__u32 ua_data = 0;
+
+	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+
+	if (!curlun || !curlun->lun) {
+		if (cmdiu->cdb[0] != INQUIRY &&
+		    cmdiu->cdb[0] != REQUEST_SENSE) {
+			DBG(udev->ucommon->common,
+			      "%s() - Logical unit is not supported\n",
+			      __func__);
+			return SS_LOGICAL_UNIT_NOT_SUPPORTED;
+		}
+	} else {
+		if (curlun->lun->unit_attention_data &&
+		    cmdiu->cdb[0] != INQUIRY &&
+		    cmdiu->cdb[0] != REQUEST_SENSE) {
+			DBG(udev->ucommon->common,
+			    "%s() - There is an unit attention condition\n",
+			    __func__);
+			ua_data = curlun->lun->unit_attention_data;
+			curlun->lun->unit_attention_data = SS_NO_SENSE;
+			return ua_data;
+		}
+	}
+
+	if (curlun && !(curlun->lun->filp) && needs_medium) {
+		DBG(udev->ucommon->common,
+		    "%s() - Medium is not present\n", __func__);
+		return SS_MEDIUM_NOT_PRESENT;
+	}
+
+	return SS_NO_SENSE;
+}
+
+/**
+ * fill_sense_iu() - fills the struct sense_iu with a given values.
+ * @udev: Programming view of UASP device.
+ * @siu: Pointer to structure to be filled.
+ * @tag: tag field of the structure.
+ * @status: status field of the structure.
+ * @sense_data: sense_data field of the structure.
+ */
+void fill_sense_iu(struct uasp_dev *udev,
+	       struct sense_iu *siu,
+	       __be16 tag,
+	       __u8 status,
+	       __u32 sense_data)
+{
+	DBG(udev->ucommon->common, "%s() - Status = %02x\n", __func__, status);
+
+	siu->iu_id = IU_ID_SENSE;
+	siu->reserved1 = 0;
+	siu->tag = tag;
+	siu->status_qual = 0; /* TODO: fix this!!! */
+	siu->status = status;
+	memset(siu->rsvd8, 0, 6);
+	siu->len = cpu_to_be16(5);
+	siu->sense_data[0] = SK(sense_data);
+	siu->sense_data[1] = ASC(sense_data);
+	siu->sense_data[2] = ASCQ(sense_data);
+}
+
+/**
+ * do_uasp_inquiry() - performs INQUIRY SCSI command.
+ * @udev: Programming view of UASP device.
+ * @curlun: Pointer to struct uasp_lun if the COMMAND IU to be
+ *	performed is addressed to a valid LUN, 0 otherwise.
+ * @cmdiu: COMMAND IU to be performed.
+ *
+ * Returns 1 if usb request should be submitted to PCD after cmdiu processing,
+ *         0 otherwise.
+ */
+static int do_uasp_inquiry(struct uasp_dev *udev,
+			struct uasp_lun *curlun,
+			struct cmd_iu *cmdiu)
+{
+	return 0;
+}
+
+
+/**
+ * do_uasp_request_sense() - performs REQUEST SENSE SCSI command.
+ * @udev: Programming view of UASP device.
+ * @curlun: Pointer to struct uasp_lun if the COMMAND IU to be
+ *	   performed is addressed to a valid LUN, 0 otherwise.
+ * @cmdiu: COMMAND IU to be performed.
+ *
+ * Returns 1 if usb request should be submitted to PCD after cmdiu processing,
+ *         0 otherwise.
+ */
+static int do_uasp_request_sense(struct uasp_dev *udev,
+			      struct uasp_lun *curlun,
+			      struct cmd_iu *cmdiu)
+{
+	return 0;
+}
+
+/**
+ * do_uasp_test_unit_ready() - performs TEST UNIT READY SCSI command.
+ * @udev: Programming view of UASP device.
+ * @curlun: Pointer to struct uasp_lun if the COMMAND IU to be
+ *	   performed is addressed to a valid LUN, 0 otherwise.
+ * @cmdiu: COMMAND IU to be performed.
+ *
+ * Returns 1 if usb request should be submitted to PCD after cmdiu processing,
+ *         0 otherwise.
+ */
+static int do_uasp_test_unit_ready(struct uasp_dev *udev,
+				struct uasp_lun *curlun,
+				struct cmd_iu *cmdiu)
+{
+	return 0;
+}
+
+/**
+ * do_uasp_mode_sense() - performs MODE SENSE(6) and MODE SENSE(10)
+ * SCSI commands.
+ * @udev: Programming view of UASP device.
+ * @curlun: Pointer to struct uasp_lun if the COMMAND IU to be
+ *	   performed is addressed to a valid LUN, 0 otherwise.
+ * @cmdiu: COMMAND IU to performed.
+ *
+ * Returns 1 if usb request should be submitted to PCD after cmdiu processing,
+ *	   0 otherwise.
+ */
+static int do_uasp_mode_sense(struct uasp_dev *udev,
+			   struct uasp_lun *curlun,
+			   struct cmd_iu *cmdiu)
+{
+	return 0;
+}
+
+/**
+ * do_uasp_prevent_allow() - performs PREVENT ALLOW MEDIUM REMOVAL SCSI command.
+ * @udev: Programming view of UASP device.
+ * @curlun: Pointer to struct uasp_lun if the COMMAND IU to be
+ *	   performed is addressed to a valid LUN, 0 otherwise.
+ * @cmdiu: COMMAND IU to be performed.
+ *
+ * Returns 1 if usb request should be submitted to PCD after cmdiu processing,
+ *         0 otherwise.
+ */
+static int do_uasp_prevent_allow(struct uasp_dev *udev,
+			      struct uasp_lun *curlun,
+			      struct cmd_iu *cmdiu)
+{
+	return 0;
+}
+
+/**
+ * do_uasp_read() - performs READ(6), READ(10), READ(12) SCSI commands.
+ * @udev: Programming view of UASP device.
+ * @curlun: Pointer to struct uasp_lun if the COMMAND IU to be performed is
+ *	addressed to a valid LUN, 0 otherwise.
+ * @cmdiu: COMMAND IU to be performed.
+ *
+ * Returns non zero if usb request(s) should be submitted to PCD after cmdiu
+ * processing, 0 otherwise.
+ */
+static int do_uasp_read(struct uasp_dev *udev,
+		     struct uasp_lun *curlun,
+		     struct cmd_iu *cmdiu)
+{
+	return 0;
+}
+
+/**
+ * do_uasp_read_capacity() - This function performs READ CAPACITY SCSI command.
+ * @udev: Programming view of UASP device.
+ * @curlun: Pointer to struct uasp_lun if the COMMAND IU to be performed is
+ *	   addressed to a valid LUN, 0 otherwise.
+ * @cmdiu: COMMAND IU to be performed.
+ *
+ * Returns 1 if usb request should be submitted to PCD after cmdiu processing,
+ *	   0 otherwise.
+ *
+ */
+static int do_uasp_read_capacity(struct uasp_dev *udev,
+			 struct uasp_lun *curlun,
+			 struct cmd_iu *cmdiu)
+{
+	return 0;
+}
+
+/**
+ * do_uasp_read_format_capacities() - performs READ FORMAT CAPACITIES
+ * SCSI command.
+ * @udev: Programming view of UASP device.
+ * @curlun: Pointer to struct uasp_lun if the COMMAND IU to be performed is
+ *	   addressed to a valid LUN, 0 otherwise.
+ * @cmdiu: COMMAND IU to be performed.
+ *
+ * Returns 1 if usb request should be submitted to PCD after cmdiu processing,
+ *         0 otherwise.
+ */
+static int do_uasp_read_format_capacities(struct uasp_dev *udev,
+				       struct uasp_lun *curlun,
+				       struct cmd_iu *cmdiu)
+{
+	return 0;
+}
+
+/**
+ * do_uasp_start_stop() - performs START STOP UNIT SCSI command.
+ * @udev: Programming view of UASP device.
+ * @curlun: Pointer to struct uasp_lun if the COMMAND IU to be performed is
+ *	   addressed to a valid LUN, 0 otherwise.
+ * @cmdiu: COMMAND IU to be performed.
+ *
+ * Returns 1 if usb request should be submitted to PCD after cmdiu processing,
+ *	   0 otherwise.
+ *
+ */
+static int do_uasp_start_stop(struct uasp_dev *udev,
+			   struct uasp_lun *curlun,
+			   struct cmd_iu *cmdiu)
+{
+	return 0;
+}
+
+/**
+ * do_uasp_verify() - This function performs VERIFY SCSI command.
+ * @udev: Programming view of UASP device.
+ * @curlun: Pointer to struct uasp_lun if the COMMAND IU to be performed is
+ *	   addressed to a valid LUN, 0 otherwise.
+ * @cmdiu: COMMAND IU to be performed.
+ *
+ * Returns 1 if usb request should be submitted to PCD after
+ *	   cmdiu processing, 0 otherwise.
+ *
+ * Although optional, this command is used by MS-Windows. We support a minimal
+ * version: BytChk must be 0.
+ *
+ */
+static int do_uasp_verify(struct uasp_dev *udev,
+		       struct uasp_lun *curlun,
+		       struct cmd_iu *cmdiu)
+{
+	return 0;
+}
+
+/**
+ * do_uasp_write() - This function performs WRITE(6), WRITE(10), WRITE(12)
+ * SCSI commands.
+ * @udev: Programming view of UASP device.
+ * @curlun: Pointer to struct uasp_lun if the COMMAND IU to be performed is
+ *	   addressed to a valid LUN, 0 otherwise.
+ * @cmdiu: COMMAND IU to be performed.
+ *
+ * Returns: 1 if an IN usb request should be submitted to PCD after processing
+ *	    2 if an OUT usb request should be submitted to PCD after processing
+ *	    0 otherwise.
+ */
+static int do_uasp_write(struct uasp_dev *udev,
+		      struct uasp_lun *curlun,
+		      struct cmd_iu *cmdiu)
+{
+	return 0;
+}
+
+/**
+ * do_uasp_synchronize_cache() - performs SYNCHRONIZE CACHE SCSI command.
+ * @udev: Programming view of UASP device.
+ * @curlun: Pointer to struct uasp_lun if the COMMAND IU to be performed is
+ *	   addressed to a valid LUN, 0 otherwise.
+ * @cmdiu: COMMAND IU to be performed.
+ *
+ * Returns 1 if usb request should be submitted to PCD after cmdiu processing,
+ *	   0 otherwise.
+ *
+ */
+static int do_uasp_synchronize_cache(struct uasp_dev *udev,
+				  struct uasp_lun *curlun,
+				  struct cmd_iu *cmdiu)
+{
+	return 0;
+}
+
+/**
+ * process_cmdiu() - This function performs a given COMMAND IU.
+ * @udev: Programming view of UASP device.
+ * @curlun: Pointer to struct uasp_lun if the COMMAND IU to be performed is
+ *	   addressed to a valid LUN, 0 otherwise.
+ * @cmdiu: COMMAND IU to be performed.
+ */
+static void process_cmdiu(struct uasp_dev *udev,
+			  struct uasp_lun *curlun,
+			  struct cmd_iu *cmdiu)
+{
+	unsigned long flags;
+	struct sense_iu *siu;
+	struct usb_request *req;
+	int rc = 0;
+
+	DBG(udev->ucommon->common, "%s() Enter. (cmdiu->cdb[0]=%04x)\n",
+	    __func__, cmdiu->cdb[0]);
+
+	/* We're using the backing file */
+	down_read(&udev->ucommon->common->filesem);
+	switch (cmdiu->cdb[0]) {
+	case INQUIRY:
+		rc = do_uasp_inquiry(udev, curlun, cmdiu);
+		break;
+	case MODE_SENSE:
+	case MODE_SENSE_10:
+		rc = do_uasp_mode_sense(udev, curlun, cmdiu);
+		break;
+	case ALLOW_MEDIUM_REMOVAL:
+		rc = do_uasp_prevent_allow(udev, curlun, cmdiu);
+		break;
+	case READ_6:
+	case READ_10:
+	case READ_12:
+		rc = do_uasp_read(udev, curlun, cmdiu);
+		break;
+	case READ_CAPACITY:
+		rc = do_uasp_read_capacity(udev, curlun, cmdiu);
+		break;
+	case READ_FORMAT_CAPACITIES:
+		rc = do_uasp_read_format_capacities(udev, curlun, cmdiu);
+		break;
+	case REQUEST_SENSE:
+		rc = do_uasp_request_sense(udev, curlun, cmdiu);
+		break;
+	case START_STOP:
+		rc = do_uasp_start_stop(udev, curlun, cmdiu);
+		break;
+	case SYNCHRONIZE_CACHE:
+		rc = do_uasp_synchronize_cache(udev, curlun, cmdiu);
+		break;
+	case TEST_UNIT_READY:
+		rc = do_uasp_test_unit_ready(udev, curlun, cmdiu);
+		break;
+	case VERIFY:
+		rc = do_uasp_verify(udev, curlun, cmdiu);
+		break;
+	case WRITE_6:
+	case WRITE_10:
+	case WRITE_12:
+		rc = do_uasp_write(udev, curlun, cmdiu);
+		break;
+	case FORMAT_UNIT:
+	case MODE_SELECT:
+	case MODE_SELECT_10:
+	case RELEASE:
+	case RESERVE:
+	case SEND_DIAGNOSTIC:
+	default:
+		ERROR(udev->ucommon->common,
+		      "%s(): Unsupported  command = %x\n",
+		    __func__, cmdiu->cdb[0]);
+		cmdiu->state = COMMAND_STATE_STATUS;
+		siu = (struct sense_iu *)cmdiu->bh->inreq->buf;
+		fill_sense_iu(udev, siu, cmdiu->tag,
+			      STATUS_CHECK_CONDITION,
+			      SS_INVALID_COMMAND);
+		fill_usb_request(cmdiu->bh->inreq, (void *)siu,
+				 UASP_SIZEOF_SENSE_IU, 0,
+				 (void *)cmdiu, 0, be16_to_cpup(&cmdiu->tag),
+				 status_complete);
+		cmdiu->ep = udev->status;
+		rc = 1;
+		break;
+	}
+
+	up_read(&udev->ucommon->common->filesem);
+	if (rc) {
+		if (rc == 1) {
+			req = cmdiu->bh->inreq;
+			cmdiu->bh->inreq_busy = 1;
+		} else {
+			req = cmdiu->bh->outreq;
+			cmdiu->bh->outreq_busy = 1;
+		}
+		if (usb_ep_queue(cmdiu->ep, req, 0)) {
+			ERROR(udev->ucommon->common,
+			      "%s()usb_ep_queue failed\n",  __func__);
+			cmdiu->state = COMMAND_STATE_FAILED;
+		} else {
+			DBG(udev->ucommon->common,
+			    "%s() - process_cmdiu: queued req to ep\n",
+			    __func__);
+			if (curlun) {
+				spin_lock_irqsave(&(curlun->lock), flags);
+				curlun->active_requests++;
+				spin_unlock_irqrestore(&(curlun->lock), flags);
+			} else {
+				spin_lock_irqsave(
+					&(udev->ucommon->common->lock), flags);
+				udev->active_requests++;
+				spin_unlock_irqrestore(
+					&(udev->ucommon->common->lock), flags);
+			}
+		}
+	}
+}
+
+/**
+ * do_cmdiu() - This function performs the COMMAND IUs from a given queue.
+ * @udev: Programming view of UASP device.
+ * @curlun: Pointer to struct uasp_lun if COMMAND IUs from lun::cmd_queue
+ *	should be performed, 0 if COMMAND IUs from uasp_dev::cmd_queue should
+ *	be performed.
+ */
+void do_cmdiu(struct uasp_dev *udev, struct uasp_lun *curlun)
+{
+	struct list_head *link;
+	struct cmd_iu *cmdiu, *tmp;
+	unsigned long flags;
+
+	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+
+	/* Select the cmd_queue from which cmdius should be processed */
+	if (curlun)
+		link = &curlun->cmd_queue;
+	else
+		link = &udev->cmd_queue;
+
+	list_for_each_entry_safe(cmdiu, tmp, link, node) {
+		DBG(udev->ucommon->common, "%s() - Rolling over cmdiu queue\n",
+		     __func__);
+
+		spin_lock_irqsave(&(udev->ucommon->common->lock), flags);
+		if (cmdiu->state == COMMAND_STATE_IDLE) {
+			/* Try to get buffers for cmdiu processing */
+			cmdiu->bh = get_buffhd(udev->ucommon->common->buffhds);
+			spin_unlock_irqrestore(&(udev->ucommon->common->lock),
+					       flags);
+
+			if (!cmdiu->bh) {
+				ERROR(udev->ucommon->common,
+				      "%s() -Didn't manage to get buffers for "
+				      "cmdiu!\n", __func__);
+				continue;
+			}
+		} else if (cmdiu->state == COMMAND_STATE_DATA) {
+			if (cmdiu->req_sts == CMD_REQ_COMPLETED)
+				spin_unlock_irqrestore(
+					&(udev->ucommon->common->lock), flags);
+			else {
+				spin_unlock_irqrestore(
+					&(udev->ucommon->common->lock), flags);
+				continue;
+			}
+		} else {
+			spin_unlock_irqrestore(&(udev->ucommon->common->lock),
+					       flags);
+			continue;
+		}
+
+		process_cmdiu(udev, curlun, cmdiu);
+
+		if (cmdiu->state == COMMAND_STATE_DATA)
+			break;
+	}
+}
+
+
diff --git a/drivers/usb/gadget/uasp_tmiu.c b/drivers/usb/gadget/uasp_tmiu.c
new file mode 100644
index 0000000..c25c293
--- /dev/null
+++ b/drivers/usb/gadget/uasp_tmiu.c
@@ -0,0 +1,283 @@
+/*
+ * uasp_tmiu.c -- Mass Storage UAS Protocol - TASK MANAGEMENT IUs handling
+ *	     implementation
+ *
+ * Copyright (C) 2003-2005 Alan Stern
+ * Copyright (C) 2011 Code Aurora Forum.
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#include <linux/list.h>
+#include "f_uasp.h"
+
+/**
+ * fill_response_iu() - fills the struct response_iu with the given values.
+ * @udev: Programming view of file storage gadget.
+ * @riu: Pointer to structure to be filled.
+ * @tag: tag field of the structure.
+ * @resp_info: resp_info field of the structure.
+ * @status: status field of the structure.
+ */
+void fill_response_iu(struct uasp_dev *udev,
+	       struct response_iu *riu,
+	       __be16 tag,
+	       uint32_t resp_info,
+	       uint8_t status)
+{
+	DBG(udev->ucommon->common, "%s() - Enter. Status = %02x\n", __func__,
+	    status);
+	riu->iu_id = IU_ID_RESPONSE;
+	riu->reserved = 0;
+	riu->tag = tag;
+	riu->resp_info[0] = SK(resp_info);
+	riu->resp_info[1] = ASC(resp_info);
+	riu->resp_info[2] = ASCQ(resp_info);
+	riu->status = status;
+}
+
+/**
+ * reset_lun() - performs RESET LUN TM FUNCTION IU.
+ * @udev: Programming view of UASP device.
+ * @curlun: Pointer to struct uasp_lun if the TM FUNCTION IU to be performed is
+ *	   addressed to a valid LUN, 0 otherwise.
+ * @tmiu: TM FUNCTION IU to be processed.
+ *
+ * This function performs LUN reset. It aborts all of the given LUN pending
+ * commands.
+ */
+static void reset_lun(struct uasp_dev *udev,
+		      struct uasp_lun *curlun,
+		      struct tm_iu *tmiu)
+{
+	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+}
+
+/**
+ * abort_task() - This function performs ABORT TASK TM FUNCTION IU.
+ * @udev: Programming view of UASP device.
+ * @curlun: Pointer to struct uasp_lun if the TM FUNCTION IU to be performed is
+ *	   addressed to a valid LUN, 0 otherwise.
+ * @tmiu: TM FUNCTION IU to be processed.
+ *
+ * This function aborts the command with the same ip_tag as in the
+ * tmiu->task_tag. It's valid only for command that are handled by a specific
+ * LUN .
+ */
+static void abort_task(struct uasp_dev *udev,
+		       struct uasp_lun *curlun,
+		       struct tm_iu *tmiu)
+{
+	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+}
+
+/**
+ * abort_task_set() - This function performs ABORT TASK SET TM FUNCTION IU.
+ * @udev: Programming view of UASP device.
+ * @curlun: Pointer to struct uasp_lun if the TM FUNCTION IU to be performed is
+ *	   addressed to a valid LUN, 0 otherwise.
+ * @tmiu: TM FUNCTION IU to be processed.
+ *
+ * This function aborts all the commands pending for the specified LUN.
+ */
+static void abort_task_set(struct uasp_dev *udev,
+			   struct uasp_lun *curlun,
+			   struct tm_iu *tmiu)
+{
+	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+}
+
+/**
+ * reset_nexus() - This function performs RESET NEXUS TM FUNCTION IU.
+ * @udev: Programming view of UASP device.
+ * @tmiu: TM FUNCTION IU to be processed.
+ */
+static void reset_nexus(struct uasp_dev *udev,
+			struct tm_iu *tmiu)
+{
+	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+}
+
+/**
+ * query_unit_attention() - performs QUERY UNIT ATTENTION TM FUNCTION IU.
+ * @udev: Programming view of UASP device.
+ * @curlun: Pointer to struct uasp_lun if the TM FUNCTION IU to be performed is
+ *	   addressed to a valid LUN, 0 otherwise.
+ * @tmiu: TM FUNCTION IU to be processed.
+ *
+ * This function is used to obtain a unit attention condition or a deferred
+ * error pending, if such exists, for the LUN on which the task management
+ * function was received.
+ */
+static void query_unit_attention(struct uasp_dev *udev,
+				      struct uasp_lun *curlun,
+				      struct tm_iu *tmiu)
+{
+	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+}
+
+
+/**
+ * This function performs QUERY TASK TM FUNCTION IU.
+ * @udev: Programming view of UASP device.
+ * @curlun: Pointer to struct uasp_lun if the TM FUNCTION IU to be performed is
+ *	   addressed to a valid LUN, 0 otherwise.
+ * @tmiu TM FUNCTION IU to be processed.
+ */
+static void query_task(struct uasp_dev *udev,
+			    struct uasp_lun *curlun,
+			    struct tm_iu *tmiu)
+{
+	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+}
+
+/**
+ * This function performs QUERY TASK SET TM FUNCTION IU.
+ * @udev: Programming view of UASP device.
+ * @curlun: Pointer to struct uasp_lun if the TM FUNCTION IU to be performed is
+ *	   addressed to a valid LUN, 0 otherwise.
+ * @tmiu TM FUNCTION IU to be processed.
+ */
+static void query_task_set(struct uasp_dev *udev,
+			   struct uasp_lun *curlun,
+			   struct tm_iu *tmiu)
+{
+	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+}
+
+/**
+ * process_tmiu() - process a given TM FUNCTION IU.
+ * @udev: Programming view of UASP device.
+ * @curlun: Pointer to struct uasp_lun if the COMMAND IU to be performed is
+ *	   addressed to a valid LUN, 0 otherwise.
+ * @miu: TM FUNCTION IU to be processed.
+ */
+static void process_tmiu(struct uasp_dev *udev,
+			 struct uasp_lun *curlun,
+			 struct tm_iu *tmiu)
+{
+	struct response_iu *riu;
+	unsigned long flags;
+
+	switch (tmiu->tm_function) {
+	case TM_FUNCTION_ABORT_TASK:
+		abort_task(udev, curlun, tmiu);
+		break;
+
+	case TM_FUNCTION_ABORT_TASK_SET:
+	case TM_FUNCTION_CLEAR_TASK_SET:
+		abort_task_set(udev, curlun, tmiu);
+		break;
+
+	case TM_FUNCTION_RESET_LUN:
+		reset_lun(udev, curlun, tmiu);
+		break;
+
+	case TM_FUNCTION_IT_NEXUS_RESET:
+		reset_nexus(udev, tmiu);
+		break;
+
+	case TM_FUNCTION_QUERY_TASK:
+		query_task(udev, curlun, tmiu);
+		break;
+
+	case TM_FUNCTION_QUERY_TASK_SET:
+		query_task_set(udev, curlun, tmiu);
+		break;
+
+	case TM_FUNCTION_QUERY_ASYNC_EVENT:
+		query_unit_attention(udev, curlun, tmiu);
+		break;
+
+	default:
+		ERROR(udev->ucommon->common, "%s(): Unsupported  tmiu = %x\n",
+		    __func__, tmiu->tm_function);
+		riu = (struct response_iu *)tmiu->bh->inreq->buf;
+		fill_response_iu(udev, riu, tmiu->tag, 0,
+			  RESPONSE_TM_FUNCTION_NOT_SUPPORTED);
+
+		fill_usb_request(tmiu->bh->inreq, (void *)riu,
+				 UASP_SIZEOF_RESPONSE_IU, 0,
+				 (void *)tmiu, 0, be16_to_cpup(&tmiu->tag),
+				 status_complete);
+		tmiu->ep = udev->status;
+		break;
+	}
+
+	tmiu->state = COMMAND_STATE_STATUS;
+	if (usb_ep_queue(tmiu->ep, tmiu->bh->inreq, 0)) {
+		ERROR(udev->ucommon->common,
+			      "%s()usb_ep_queue failed\n",  __func__);
+		tmiu->state = COMMAND_STATE_FAILED;
+	} else {
+		tmiu->bh->inreq_busy = 1;
+		if (curlun) {
+			spin_lock_irqsave(&(curlun->lock), flags);
+			curlun->active_requests++;
+			spin_unlock_irqrestore(&(curlun->lock), flags);
+		} else {
+			spin_lock_irqsave(&(udev->ucommon->common->lock),
+					  flags);
+			udev->active_requests++;
+			spin_unlock_irqrestore(&(udev->ucommon->common->lock),
+					       flags);
+		}
+	}
+}
+
+/**
+ * do_tmdiu() - processes the TM FUNCTION IUs from a given queue.
+ * @udev: Programming view of file storage gadget.
+ * @curlun: Pointer to struct uasp_lun if TM FUNCTION IUs from
+ *	uasp_lun::tm_func_queue should be processed,
+ *	0 if TM FUNCTION IUs from uasp_dev::tm_func_queue should
+ *	be processed.
+ */
+void do_tmiu(struct uasp_dev *udev, struct uasp_lun *curlun)
+{
+	struct list_head *link;
+	struct tm_iu *tmiu, *tmp;
+	unsigned long flags;
+
+	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+
+	/* Select the tm_func_queue from which tmius should be processed */
+	if (curlun)
+		link = &curlun->tm_func_queue;
+	else
+		link = &udev->tm_func_queue;
+
+	DBG(udev->ucommon->common, "%s() - Rolling over tmiu queue\n",
+	     __func__);
+	list_for_each_entry_safe(tmiu, tmp, link, node) {
+		if (tmiu->state != COMMAND_STATE_IDLE)
+			continue;
+
+		/* Try to get buffer for tmiu provessing */
+		spin_lock_irqsave(&(udev->ucommon->common->lock), flags);
+		tmiu->bh = get_buffhd(udev->ucommon->common->buffhds);
+		spin_unlock_irqrestore(&(udev->ucommon->common->lock), flags);
+
+		if (!tmiu->bh) {
+			ERROR(udev->ucommon->common,
+			      "%s() -Didnt manage to get buffers for tmiu!\n",
+			      __func__);
+			continue;
+		}
+
+		process_tmiu(udev, curlun, tmiu);
+	}
+}
-- 
1.7.3.3

--
Sent by a Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum
