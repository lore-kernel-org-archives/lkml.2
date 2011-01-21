Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab1AUHpJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 02:45:09 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:57576 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882Ab1AUHpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 02:45:06 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6232"; a="71349491"
From: Tatyana Brokhman <tlinder@codeaurora.org>
To: gregkh@suse.de
Cc: linux-arm-msm@vger.kernel.org, Tatyana Brokhman <tlinder@codeaurora.org>,
        linux-usb@vger.kernel.org (open list:USB GADGET/PERIPH...),
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC/PATCH 2/4] uasp: COMMAND IU handling infrastructure
Date: Fri, 21 Jan 2011 09:44:52 +0200
Message-Id: <1295595893-23267-1-git-send-email-tlinder@codeaurora.org>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch defines APIs for different COMMAND IUs implementation

Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>
---
 drivers/usb/gadget/uasp_cmdiu.c |  436 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 436 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/gadget/uasp_cmdiu.c b/drivers/usb/gadget/uasp_cmdiu.c
index 8a7b34e..1444d56 100644
--- a/drivers/usb/gadget/uasp_cmdiu.c
+++ b/drivers/usb/gadget/uasp_cmdiu.c
@@ -48,6 +48,53 @@ struct fsg_buffhd *get_buffhd(struct fsg_buffhd *bh)
 }
 
 /**
+ * check_cmdiu() - initial verification of the COMMAND IU
+ * @udev: Programming view of UASP device.
+ * @curlun: Pointer to struct lun if the COMMAND IU to be checked is addressed
+ *	to a valid LUN, 0 otherwise.
+ * @cmdiu: COMMAND IU to be checked.
+ * @needs_medium: Specifies, is the medium needed for the COMMAND IU processing.
+ */
+static uint32_t check_cmdiu(struct uasp_dev *udev,
+			    struct uasp_lun *curlun,
+			    struct cmd_iu *cmdiu,
+			    u8 needs_medium)
+{
+	u32 ua_data = 0;
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
  * fill_sense_iu() - fills the struct sense_iu with a given values.
  * @udev: Programming view of UASP device.
  * @siu: Pointer to structure to be filled.
@@ -77,6 +124,330 @@ void fill_sense_iu(struct uasp_dev *udev,
 }
 
 /**
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
+ * Returns 1 if usb request should be submitted to PCD after cmdiu processing,
+ *         0 otherwise.
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
+ *         0 otherwise.
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
+		fill_sense_iu(udev, siu, IUGETW(cmdiu->ip_tag),
+			      STATUS_CHECK_CONDITION,
+			      SS_INVALID_COMMAND);
+		fill_usb_request(cmdiu->bh->inreq, (void *)siu,
+				 UASP_SIZEOF_SENSE_IU, 0,
+				 (void *)cmdiu, 0, IUGETW(cmdiu->ip_tag),
+				 status_complete);
+		cmdiu->ep = udev->status;
+		rc = 1;
+		break;
+	}
+
+	up_read(&udev->ucommon->common->filesem);
+	if (rc) {
+		req = (rc == 2 ? cmdiu->bh->outreq : cmdiu->bh->inreq);
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
  * do_cmdiu() - This function performs the COMMAND IUs from a given queue.
  * @udev: Programming view of UASP device.
  * @curlun: Pointer to struct uasp_lun if COMMAND IUs from lun::cmd_queue
@@ -85,7 +456,72 @@ void fill_sense_iu(struct uasp_dev *udev,
  */
 void do_cmdiu(struct uasp_dev *udev, struct uasp_lun *curlun)
 {
+	struct list_head *link;
+	struct cmd_iu *cmdiu, *tmp;
+	unsigned long flags;
+	int cmd_is_active = 0;
+
 	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
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
+		/*
+		 * TODO: this is a workaround. It is added for processing
+		 * of only one command in a certain nexus or lun.
+		 * Remove this after initial testing.
+		 */
+		if (cmd_is_active) {
+			DBG(udev->ucommon->common,
+			    "%s() - Cmdiu is on data stage, do not process"
+				 " next cmdiu\n", __func__);
+			break;
+		}
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
+			cmd_is_active = 1;
+			if (cmdiu->req_sts == CMD_REQ_COMPLETED)
+				spin_unlock_irqrestore(
+					&(udev->ucommon->common->lock), flags);
+			else {
+				spin_unlock_irqrestore(
+					&(udev->ucommon->common->lock), flags);
+				continue;
+			}
+			cmd_is_active = 0;
+		} else {
+			spin_unlock_irqrestore(&(udev->ucommon->common->lock),
+					       flags);
+			continue;
+		}
+
+		process_cmdiu(udev, curlun, cmdiu);
+
+		if (cmdiu->state == COMMAND_STATE_DATA) {
+			cmd_is_active = 1;
+			break;
+		}
+	}
 }
 
 
-- 
1.6.3.3
--
Sent by a Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum
