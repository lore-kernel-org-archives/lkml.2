Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758358Ab1DNNhN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 09:37:13 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:38236 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757127Ab1DNNhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 09:37:11 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6315"; a="85777216"
From: Tatyana Brokhman <tlinder@codeaurora.org>
To: gregkh@suse.de
Cc: linux-arm-msm@vger.kernel.org, ablay@codeaurora.org, balbi@ti.com,
        Tatyana Brokhman <tlinder@codeaurora.org>,
        linux-usb@vger.kernel.org (open list:USB GADGET/PERIPH...),
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC/PATCH/RESEND v1 4/5] uas: TASK MANAGEMENT IU implementation
Date: Thu, 14 Apr 2011 16:36:59 +0300
Message-Id: <1302788220-28059-1-git-send-email-tlinder@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements the handling of most of the TM IUs defined in
table 20 of the UAS Spec

Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

diff --git a/drivers/usb/gadget/uasp_tmiu.c b/drivers/usb/gadget/uasp_tmiu.c
index c25c293..0b4b417 100644
--- a/drivers/usb/gadget/uasp_tmiu.c
+++ b/drivers/usb/gadget/uasp_tmiu.c
@@ -60,10 +60,38 @@ void fill_response_iu(struct uasp_dev *udev,
  * commands.
  */
 static void reset_lun(struct uasp_dev *udev,
-		      struct uasp_lun *curlun,
-		      struct tm_iu *tmiu)
+			   struct uasp_lun *curlun,
+			   struct tm_iu *tmiu)
 {
+	struct response_iu *riu;
+	uint8_t status;
+	unsigned long flags;
+
 	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+
+	riu = (struct response_iu *)tmiu->bh->buf;
+	if (!curlun) {
+		status = RESPONSE_INCORRECT_LUN;
+		goto res_lun_fill_response;
+	}
+
+	abort_commands(udev, &curlun->cmd_queue, &curlun->tm_func_queue,
+		       &(curlun->lock));
+
+	spin_lock_irqsave(&(curlun->lock), flags);
+	curlun->pending_requests = 0;
+	spin_unlock_irqrestore(&(curlun->lock), flags);
+
+	curlun->lun->unit_attention_data = SS_RESET_OCCURRED;
+	status = RESPONSE_TM_FUNCTION_COMPLETE;
+
+res_lun_fill_response:
+	fill_response_iu(udev, riu, tmiu->tag, 0, status);
+
+	fill_usb_request(tmiu->bh->inreq, (void *)riu, UASP_SIZEOF_RESPONSE_IU,
+			 0, (void *)tmiu, 0, be16_to_cpup(&tmiu->tag),
+			 status_complete);
+	tmiu->ep = udev->status;
 }
 
 /**
@@ -73,15 +101,68 @@ static void reset_lun(struct uasp_dev *udev,
  *	   addressed to a valid LUN, 0 otherwise.
  * @tmiu: TM FUNCTION IU to be processed.
  *
- * This function aborts the command with the same ip_tag as in the
- * tmiu->task_tag. It's valid only for command that are handled by a specific
- * LUN .
+ * This function aborts the command with the same tag as in the
+ * tmiu->task_tag. It's valid only for command that are handled
+ * by a specific LUN .
  */
 static void abort_task(struct uasp_dev *udev,
-		       struct uasp_lun *curlun,
-		       struct tm_iu *tmiu)
+			    struct uasp_lun *curlun,
+			    struct tm_iu *tmiu)
 {
+	struct cmd_iu *cmdiu, *tmp;
+	struct response_iu *riu;
+	unsigned long flags;
+	uint8_t status;
+
 	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+	riu = (struct response_iu *)tmiu->bh->buf;
+	if (!curlun) {
+		status = RESPONSE_INCORRECT_LUN;
+		goto abrt_task_fill_response;
+	}
+
+	/* Try to find the command in curlun */
+	list_for_each_entry_safe(cmdiu, tmp, &curlun->cmd_queue, node)
+		if (cmdiu->tag == tmiu->task_tag)
+			goto found;
+
+	/* Command with specified ipt_tag not found */
+	DBG(udev->ucommon->common, "%s(): cmdiu with tag %04x wasn't found\n",
+	    __func__, tmiu->task_tag);
+	cmdiu = 0;
+
+found:
+	if (cmdiu) {
+		spin_lock_irqsave(&(curlun->lock), flags);
+		if (cmdiu->state == COMMAND_STATE_DATA) {
+			if (cmdiu->req_sts == CMD_REQ_IN_PROGRESS) {
+				spin_unlock_irqrestore(&(curlun->lock), flags);
+				if (cmdiu->bh->inreq_busy)
+					usb_ep_dequeue(cmdiu->ep,
+						       cmdiu->bh->inreq);
+				if (cmdiu->bh->outreq_busy)
+					usb_ep_dequeue(cmdiu->ep,
+						       cmdiu->bh->outreq);
+				spin_lock_irqsave(&(curlun->lock), flags);
+			}
+		} else if (cmdiu->state == COMMAND_STATE_STATUS) {
+			spin_unlock_irqrestore(&(curlun->lock), flags);
+			usb_ep_dequeue(cmdiu->ep, cmdiu->bh->inreq);
+			spin_lock_irqsave(&(curlun->lock), flags);
+		} else
+			cmdiu->state = COMMAND_STATE_ABORTED;
+		spin_unlock_irqrestore(&(curlun->lock), flags);
+	}
+
+	status = RESPONSE_TM_FUNCTION_COMPLETE;
+
+abrt_task_fill_response:
+	fill_response_iu(udev, riu, tmiu->tag, 0, status);
+
+	fill_usb_request(tmiu->bh->inreq, (void *)riu, UASP_SIZEOF_RESPONSE_IU,
+			 0, (void *)tmiu, 0, be16_to_cpup(&tmiu->tag),
+			 status_complete);
+	tmiu->ep = udev->status;
 }
 
 /**
@@ -94,10 +175,36 @@ static void abort_task(struct uasp_dev *udev,
  * This function aborts all the commands pending for the specified LUN.
  */
 static void abort_task_set(struct uasp_dev *udev,
-			   struct uasp_lun *curlun,
-			   struct tm_iu *tmiu)
+				struct uasp_lun *curlun,
+				struct tm_iu *tmiu)
 {
+	struct response_iu *riu;
+	uint8_t status;
+	unsigned long flags;
+
 	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+
+	riu = (struct response_iu *)tmiu->bh->buf;
+	if (!curlun) {
+		status = RESPONSE_INCORRECT_LUN;
+		goto abrt_ts_fill_response;
+	}
+
+	abort_commands(udev, &curlun->cmd_queue, 0, &(curlun->lock));
+
+	spin_lock_irqsave(&(curlun->lock), flags);
+	curlun->pending_requests = 0;
+	spin_unlock_irqrestore(&(curlun->lock), flags);
+
+	status = RESPONSE_TM_FUNCTION_COMPLETE;
+
+abrt_ts_fill_response:
+	fill_response_iu(udev, riu, tmiu->tag, 0, status);
+
+	fill_usb_request(tmiu->bh->inreq, (void *)riu, UASP_SIZEOF_RESPONSE_IU,
+			 0, (void *)tmiu, 0, be16_to_cpup(&tmiu->tag),
+			 status_complete);
+	tmiu->ep = udev->status;
 }
 
 /**
@@ -106,9 +213,54 @@ static void abort_task_set(struct uasp_dev *udev,
  * @tmiu: TM FUNCTION IU to be processed.
  */
 static void reset_nexus(struct uasp_dev *udev,
-			struct tm_iu *tmiu)
+			     struct tm_iu *tmiu)
 {
+	struct response_iu *riu;
+	unsigned long flags;
+	uint8_t status;
+	int rc = 0;
+
 	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+
+	riu = (struct response_iu *)tmiu->bh->buf;
+
+	run_lun_threads(udev, LUN_STATE_RESET);
+
+	/*
+	 * Wait for luns completing the nexus reset.
+	 * Sleep if luns are in processing
+	 */
+	while (!all_lun_state_non_processing(udev)) {
+		DBG(udev->ucommon->common,
+		    "%s() - Luns are in process. Going to sleep\n", __func__);
+		rc = sleep_thread(udev->ucommon->common);
+		if (rc) {
+			ERROR(udev->ucommon->common,
+			      "%s() - sleep_thread failed! (%d)", __func__, rc);
+			status = RESPONSE_TM_FUNCTION_FAILED;
+			goto reset_nexus_fill_response;
+		}
+		DBG(udev->ucommon->common, "%s() - Wakes up\n", __func__);
+		rc = 0;
+	}
+
+	/* Abort general commands and tmius */
+	abort_commands(udev, &udev->cmd_queue, &udev->tm_func_queue,
+		       &(udev->ucommon->common->lock));
+
+	spin_lock_irqsave(&(udev->ucommon->common->lock), flags);
+	udev->pending_requests = 0;
+	spin_unlock_irqrestore(&(udev->ucommon->common->lock), flags);
+
+	status = RESPONSE_TM_FUNCTION_COMPLETE;
+reset_nexus_fill_response:
+	fill_response_iu(udev, riu, tmiu->tag, 0,
+		RESPONSE_TM_FUNCTION_COMPLETE);
+	fill_usb_request(tmiu->bh->inreq, (void *)riu, UASP_SIZEOF_RESPONSE_IU,
+			 0, (void *)tmiu, 0, be16_to_cpup(&tmiu->tag),
+			 status_complete);
+	tmiu->ep = udev->status;
+	DBG(udev->ucommon->common, "%s() - Exit\n", __func__);
 }
 
 /**
@@ -126,7 +278,37 @@ static void query_unit_attention(struct uasp_dev *udev,
 				      struct uasp_lun *curlun,
 				      struct tm_iu *tmiu)
 {
+	struct response_iu *riu;
+	uint8_t status;
+	uint32_t resp_info = 0;
+
 	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+	riu = (struct response_iu *)tmiu->bh->buf;
+	if (!curlun) {
+		status = RESPONSE_INCORRECT_LUN;
+		goto qut_fill_response;
+	}
+
+	status = RESPONSE_TM_FUNCTION_COMPLETE;
+
+	if (curlun->lun->unit_attention_data) {
+		status = RESPONSE_TM_FUNCTION_SUCCEEDED;
+		/*
+		 * We don't keep queue of unit attention conditions,
+		 * and deferred errors also. We only keep unit attention
+		 * condition with higher precedence level.
+		 */
+		resp_info = curlun->lun->unit_attention_data | (1 << 20);
+	}
+
+qut_fill_response:
+	fill_response_iu(udev, riu, tmiu->tag, resp_info, status);
+
+	fill_usb_request(tmiu->bh->inreq, (void *)riu, UASP_SIZEOF_RESPONSE_IU,
+			 0, (void *)tmiu, 0, be16_to_cpup(&tmiu->tag),
+			 status_complete);
+
+	tmiu->ep = udev->status;
 }
 
 
@@ -141,7 +323,39 @@ static void query_task(struct uasp_dev *udev,
 			    struct uasp_lun *curlun,
 			    struct tm_iu *tmiu)
 {
+	struct cmd_iu *cmdiu = 0;
+	struct cmd_iu *tmp_cmdiu;
+	struct response_iu *riu;
+	unsigned long flags;
+	uint8_t status = RESPONSE_TM_FUNCTION_COMPLETE;
+
 	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+	riu = (struct response_iu *)tmiu->bh->buf;
+	if (!curlun) {
+		status = RESPONSE_INCORRECT_LUN;
+		goto q_task_fill_response;
+	}
+
+	/* Try to find in command in curlun */
+	spin_lock_irqsave(&(curlun->lock), flags);
+	list_for_each_entry_safe(cmdiu, tmp_cmdiu, &curlun->cmd_queue, node) {
+		if (cmdiu->tag == tmiu->task_tag) {
+			if (cmdiu->state == COMMAND_STATE_IDLE  ||
+			    cmdiu->state == COMMAND_STATE_DATA  ||
+			    cmdiu->state == COMMAND_STATE_STATUS)
+				status = RESPONSE_TM_FUNCTION_SUCCEEDED;
+			spin_unlock_irqrestore(&(curlun->lock), flags);
+			goto q_task_fill_response;
+		}
+	}
+	spin_unlock_irqrestore(&(curlun->lock), flags);
+
+q_task_fill_response:
+	fill_response_iu(udev, riu, tmiu->tag, 0, status);
+	fill_usb_request(tmiu->bh->inreq, (void *)riu, UASP_SIZEOF_RESPONSE_IU,
+			 0, (void *)tmiu, 0, be16_to_cpup(&tmiu->tag),
+			 status_complete);
+	tmiu->ep = udev->status;
 }
 
 /**
@@ -155,7 +369,42 @@ static void query_task_set(struct uasp_dev *udev,
 			   struct uasp_lun *curlun,
 			   struct tm_iu *tmiu)
 {
+	struct cmd_iu *cmdiu = 0;
+	struct cmd_iu *tmp_cmdiu;
+	struct response_iu *riu;
+	unsigned long flags;
+	uint8_t status;
+
 	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+	riu = (struct response_iu *)tmiu->bh->buf;
+	if (!curlun) {
+		status = RESPONSE_INCORRECT_LUN;
+		goto q_task_set_fill_response;
+	}
+
+	/* Try to find none-completed command in curlun */
+	spin_lock_irqsave(&(curlun->lock), flags);
+	list_for_each_entry_safe(cmdiu, tmp_cmdiu, &curlun->cmd_queue, node) {
+		if (cmdiu->state == COMMAND_STATE_IDLE  ||
+		    cmdiu->state == COMMAND_STATE_RR_WR ||
+		    cmdiu->state == COMMAND_STATE_DATA  ||
+		    cmdiu->state == COMMAND_STATE_STATUS) {
+			status = RESPONSE_TM_FUNCTION_SUCCEEDED;
+			spin_unlock_irqrestore(&(curlun->lock), flags);
+			goto q_task_set_fill_response;
+		}
+	}
+
+	spin_unlock_irqrestore(&(curlun->lock), flags);
+	status = RESPONSE_TM_FUNCTION_COMPLETE;
+
+q_task_set_fill_response:
+	fill_response_iu(udev, riu, tmiu->tag, 0, status);
+	fill_usb_request(tmiu->bh->inreq, (void *)riu, UASP_SIZEOF_RESPONSE_IU,
+			 0, (void *)tmiu, 0, be16_to_cpup(&tmiu->tag),
+			 status_complete);
+	tmiu->ep = udev->status;
+	DBG(udev->ucommon->common, "%s() - Exit\n", __func__);
 }
 
 /**
-- 
1.7.3.3

--
Sent by a Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum
