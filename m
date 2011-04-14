Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758760Ab1DNNhc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 09:37:32 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22806 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757455Ab1DNNha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 09:37:30 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6315"; a="85777252"
From: Tatyana Brokhman <tlinder@codeaurora.org>
To: gregkh@suse.de
Cc: linux-arm-msm@vger.kernel.org, ablay@codeaurora.org, balbi@ti.com,
        Tatyana Brokhman <tlinder@codeaurora.org>,
        linux-usb@vger.kernel.org (open list:USB GADGET/PERIPH...),
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC/PATCH v1 5/5] uas: HS-UAS mode implementation
Date: Thu, 14 Apr 2011 16:37:18 +0300
Message-Id: <1302788239-28099-1-git-send-email-tlinder@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds implementation for UAS protocol over a HS USB bus
connection.

Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

diff --git a/drivers/usb/gadget/f_uasp.c b/drivers/usb/gadget/f_uasp.c
index 7b1e2bd..1323207 100644
--- a/drivers/usb/gadget/f_uasp.c
+++ b/drivers/usb/gadget/f_uasp.c
@@ -928,6 +928,8 @@ reset_uasp:
 
 	fcommon->fsg = new_fsg;
 	fsgd = fcommon->fsg;
+	uaspd->op_mode = (fcommon->gadget->speed == USB_SPEED_SUPER ?
+			  SS_UASP_MODE : HS_UASP_MODE);
 
 	/* Enable the endpoints */
 	config_ep_by_speed(fcommon->gadget, &fsgd->function, fsgd->bulk_in);
@@ -996,9 +998,9 @@ reset_uasp:
 		goto reset_uasp;
 	}
 
-	DBG(uaspd->ucommon->common, "%s() allocated command request = %p, "
-				    "udev=%p\n", __func__,
-				uaspd->cmd_buff.outreq, uaspd);
+	DBG(uaspd->ucommon->common, "%s() Enebled endpoints. "
+				    "Opperation mode = %d\n", __func__,
+				uaspd->op_mode);
 	uaspd->cmd_buff.outreq->buf = &(uaspd->cmd_buff.buf);
 	uaspd->cmd_buff.inreq = NULL;
 	uaspd->cmd_buff.state = BUF_STATE_EMPTY;
@@ -1202,6 +1204,7 @@ static int uasp_command_check(struct uasp_dev *udev, void **command)
 		list_for_each_entry(tmp_cmdiu, &curlun->cmd_queue, node) {
 			if (tmp_cmdiu->state != COMMAND_STATE_IDLE &&
 			    tmp_cmdiu->state != COMMAND_STATE_DATA &&
+			    tmp_cmdiu->state != COMMAND_STATE_RR_WR &&
 			    tmp_cmdiu->state != COMMAND_STATE_STATUS) {
 				continue;
 			}
@@ -1228,6 +1231,7 @@ static int uasp_command_check(struct uasp_dev *udev, void **command)
 	list_for_each_entry(tmp_cmdiu, &udev->cmd_queue, node) {
 		if (tmp_cmdiu->state != COMMAND_STATE_IDLE &&
 		    tmp_cmdiu->state != COMMAND_STATE_DATA &&
+		    tmp_cmdiu->state != COMMAND_STATE_RR_WR &&
 		    tmp_cmdiu->state != COMMAND_STATE_STATUS)
 			continue;
 
@@ -1306,7 +1310,8 @@ overlapped_tag:
 		fill_usb_request(tmiu->bh->inreq, tmiu->bh->buf,
 				 UASP_SIZEOF_RESPONSE_IU, 0,
 				 (void *)tmiu, 0,
-				 be16_to_cpup(&tmiu->tag), status_complete);
+				 be16_to_cpup(&tmiu->tag), status_complete,
+				 udev->op_mode);
 
 		tmiu->ep = udev->status;
 		tmiu->bh->inreq_busy = 1;
@@ -1335,7 +1340,8 @@ overlapped_tag:
 		fill_usb_request(cmdiu->bh->inreq, cmdiu->bh->buf,
 				 UASP_SIZEOF_SENSE_IU, 0,
 				 (void *)cmdiu, 0,
-				 be16_to_cpup(&cmdiu->tag), status_complete);
+				 be16_to_cpup(&cmdiu->tag), status_complete,
+				 udev->op_mode);
 		cmdiu->ep = udev->status;
 		cmdiu->bh->inreq_busy = 1;
 		if (usb_ep_queue(cmdiu->ep, cmdiu->bh->inreq, 0))
@@ -1674,7 +1680,8 @@ void abort_commands(struct uasp_dev *udev,
 
 	spin_lock_irqsave(lock, flags);
 	list_for_each_entry_safe(cmdiu, tmp_cmdiu, cmd_queue, node) {
-		if (cmdiu->state == COMMAND_STATE_DATA) {
+		if (cmdiu->state == COMMAND_STATE_DATA ||
+		    cmdiu->state == COMMAND_STATE_RR_WR) {
 			if (cmdiu->req_sts == CMD_REQ_IN_PROGRESS) {
 				spin_unlock_irqrestore(lock, flags);
 				if (cmdiu->bh->inreq_busy)
@@ -2377,6 +2384,7 @@ uasp_add_err:
  * @short_not_ok: short_not_ok field of the request.
  * @stream_id: stream_id field of the request.
  * @complete: complete function to be called on request completion
+ * @op_mode: operation mode (HS_UASP_MODE/SS_UASP_MODE)
  *
  */
 void fill_usb_request(struct usb_request *req,
@@ -2386,14 +2394,15 @@ void fill_usb_request(struct usb_request *req,
 		      void *context,
 		      unsigned short_not_ok,
 		      unsigned stream_id,
-		      usb_request_complete_t complete)
+		      usb_request_complete_t complete,
+		      uint8_t op_mode)
 {
 	req->buf = buf;
 	req->length = length;
 	req->zero = zero;
 	req->context = context;
 	req->short_not_ok = short_not_ok;
-	req->stream_id = stream_id;
+	req->stream_id = (op_mode == SS_UASP_MODE ? stream_id : 0);
 	req->complete = complete;
 }
 
diff --git a/drivers/usb/gadget/f_uasp.h b/drivers/usb/gadget/f_uasp.h
index 42e0d0fa..651d030 100644
--- a/drivers/usb/gadget/f_uasp.h
+++ b/drivers/usb/gadget/f_uasp.h
@@ -130,6 +130,10 @@ struct uasp_dev {
 	struct usb_ep		*command;
 	struct fsg_buffhd	cmd_buff;
 
+#define HS_UASP_MODE		0
+#define SS_UASP_MODE		1
+	uint8_t			op_mode;
+
 	unsigned int		cmd_enabled;
 	unsigned int		status_enabled;
 
@@ -343,6 +347,28 @@ struct response_iu {
 } __attribute__((__packed__));
 #define UASP_SIZEOF_RESPONSE_IU		8
 
+
+/* READ/WRITE READY IU - see table 14/15 of the UAS Spec */
+struct rw_ready_iu {
+	__u8 iu_id;
+	__u8 reserved;
+	__be16 tag;	/* section 4.2 of the UAS spec */
+} __attribute__((__packed__));
+#define UASP_SIZEOF_RW_READY_IU	4
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
+ * @op_mode: operation mode (HS_UASP_MODE/SS_UASP_MODE)
+ *
+ */
 void fill_usb_request(struct usb_request *req,
 		      void *buf,
 		      unsigned length,
@@ -350,7 +376,8 @@ void fill_usb_request(struct usb_request *req,
 		      void *context,
 		      unsigned short_not_ok,
 		      unsigned stream_id,
-		      usb_request_complete_t complete);
+		      usb_request_complete_t complete,
+		      uint8_t op_mode);
 
 /**
  * uasp_bulk_in_complete() - Callback function for the bulk IN endpoint
diff --git a/drivers/usb/gadget/uasp_cmdiu.c b/drivers/usb/gadget/uasp_cmdiu.c
index c8aaf4d..57fd4e7 100644
--- a/drivers/usb/gadget/uasp_cmdiu.c
+++ b/drivers/usb/gadget/uasp_cmdiu.c
@@ -130,6 +130,22 @@ void fill_sense_iu(struct uasp_dev *udev,
 }
 
 /**
+ * fill_rw_ready_iu() - fills the struct rw_ready_iu with a given values.
+ * @rwr_iu: Pointer to structure to be filled.
+ * @iu_id: can be IU_ID_READ_READY or IU_ID_WRITE_READY only
+ * @tag: tag field of the structure.
+ *
+ * TODO: add verification of iu_id
+ */
+static void fill_rw_ready_iu(struct rw_ready_iu *rwr_iu,
+		      __u8 iu_id,
+		      __be16 tag)
+{
+	rwr_iu->iu_id = iu_id;
+	rwr_iu->tag = tag;
+}
+
+/**
  * do_uasp_inquiry() - performs INQUIRY SCSI command.
  * @udev: Programming view of UASP device.
  * @curlun: Pointer to struct uasp_lun if the COMMAND IU to be
@@ -170,6 +186,29 @@ static int do_uasp_inquiry(struct uasp_dev *udev,
 	}
 
 	switch (cmdiu->state) {
+	case COMMAND_STATE_RR_WR:
+		/* READ READY not sent, create request and submit */
+		if (cmdiu->req_sts == CMD_REQ_NOT_SUBMITTED) {
+			fill_rw_ready_iu((struct rw_ready_iu *)bh->buf,
+					 IU_ID_READ_READY, cmdiu->tag);
+			fill_usb_request(req, bh->buf, UASP_SIZEOF_RW_READY_IU,
+					 0, (void *)cmdiu, 0,
+					 be16_to_cpup(&cmdiu->tag),
+					 status_complete, udev->op_mode);
+
+			cmdiu->ep = udev->status;
+			cmdiu->req_sts = CMD_REQ_IN_PROGRESS;
+			rc = 1;
+			break;
+		}
+		/* Completion of sent READ READY IU is not received yet */
+		else if (cmdiu->req_sts == CMD_REQ_IN_PROGRESS)
+			break;
+		/* Completion of the sent READ READY is done */
+		else {
+			cmdiu->state = COMMAND_STATE_DATA;
+			cmdiu->req_sts = CMD_REQ_NOT_SUBMITTED;
+		}
 	case COMMAND_STATE_DATA:
 		/* Data is not sent, create and submit*/
 		if (cmdiu->req_sts == CMD_REQ_NOT_SUBMITTED) {
@@ -196,7 +235,7 @@ static int do_uasp_inquiry(struct uasp_dev *udev,
 				(int)get_unaligned_be16(&cmdiu->cdb[3])),
 				 0, (void *)cmdiu, 0,
 				 be16_to_cpup(&cmdiu->tag),
-				 uasp_bulk_in_complete);
+				 uasp_bulk_in_complete, udev->op_mode);
 
 			cmdiu->ep = udev->fsg_dev.bulk_in;
 			cmdiu->req_sts = CMD_REQ_IN_PROGRESS;
@@ -213,7 +252,8 @@ static int do_uasp_inquiry(struct uasp_dev *udev,
 
 		fill_usb_request(req, bh->buf, UASP_SIZEOF_SENSE_IU, 0,
 				 (void *)cmdiu, 0,
-				 be16_to_cpup(&cmdiu->tag), status_complete);
+				 be16_to_cpup(&cmdiu->tag), status_complete,
+				 udev->op_mode);
 
 		cmdiu->ep = udev->status;
 		rc = 1;
@@ -269,13 +309,38 @@ static int do_uasp_request_sense(struct uasp_dev *udev,
 		if (sense) {
 			status = STATUS_CHECK_CONDITION;
 			cmdiu->state = COMMAND_STATE_STATUS;
-		} else {
+		} else if (udev->op_mode == HS_UASP_MODE)
+			cmdiu->state = COMMAND_STATE_RR_WR;
+		else
 			cmdiu->state = COMMAND_STATE_DATA;
-			cmdiu->req_sts = CMD_REQ_NOT_SUBMITTED;
-		}
+		cmdiu->req_sts = CMD_REQ_NOT_SUBMITTED;
 	}
 
 	switch (cmdiu->state) {
+	case COMMAND_STATE_RR_WR:
+		/* READ READY not sent, create request and submit */
+		if (cmdiu->req_sts == CMD_REQ_NOT_SUBMITTED) {
+			fill_rw_ready_iu((struct rw_ready_iu *)cmdiu->bh->buf,
+					 IU_ID_READ_READY, cmdiu->tag);
+			fill_usb_request(cmdiu->bh->inreq, cmdiu->bh->buf,
+					 UASP_SIZEOF_RW_READY_IU,
+					 0, (void *)cmdiu, 0,
+					 be16_to_cpup(&cmdiu->tag),
+					 status_complete, udev->op_mode);
+
+			cmdiu->ep = udev->status;
+			cmdiu->req_sts = CMD_REQ_IN_PROGRESS;
+			rc = 1;
+			break;
+		}
+		/* Completion of sent READ READY IU is not received yet */
+		else if (cmdiu->req_sts == CMD_REQ_IN_PROGRESS)
+			break;
+		/* Completion of the sent READ READY is done */
+		else {
+			cmdiu->state = COMMAND_STATE_DATA;
+			cmdiu->req_sts = CMD_REQ_NOT_SUBMITTED;
+		}
 	case COMMAND_STATE_DATA:
 		/* Data is not sent, create and submit */
 		if (cmdiu->req_sts == CMD_REQ_NOT_SUBMITTED) {
@@ -323,7 +388,7 @@ static int do_uasp_request_sense(struct uasp_dev *udev,
 					 min(18, (int)cmdiu->cdb[4]),
 					 0, (void *)cmdiu, 0,
 					 be16_to_cpup(&cmdiu->tag),
-					 uasp_bulk_in_complete);
+					 uasp_bulk_in_complete, udev->op_mode);
 
 			cmdiu->ep = udev->fsg_dev.bulk_in;
 			cmdiu->req_sts = CMD_REQ_IN_PROGRESS;
@@ -341,7 +406,7 @@ static int do_uasp_request_sense(struct uasp_dev *udev,
 		fill_usb_request(cmdiu->bh->inreq, cmdiu->bh->buf,
 				 UASP_SIZEOF_SENSE_IU, 0,
 				 (void *)cmdiu, 0, be16_to_cpup(&cmdiu->tag),
-				 status_complete);
+				 status_complete, udev->op_mode);
 		cmdiu->ep = udev->status;
 		rc = 1;
 		break;
@@ -387,7 +452,8 @@ static int do_uasp_test_unit_ready(struct uasp_dev *udev,
 		  status, sense);
 
 	fill_usb_request(req, bh->buf, UASP_SIZEOF_SENSE_IU, 0, cmdiu, 0,
-			 be16_to_cpup(&cmdiu->tag), status_complete);
+			 be16_to_cpup(&cmdiu->tag), status_complete,
+			 udev->op_mode);
 	cmdiu->ep = udev->status;
 	return 1;
 }
@@ -440,13 +506,39 @@ static int do_uasp_mode_sense(struct uasp_dev *udev,
 			sense = SS_INVALID_FIELD_IN_CDB;
 			status = STATUS_CHECK_CONDITION;
 			cmdiu->state = COMMAND_STATE_STATUS;
-		} else
+		} else if (udev->op_mode == HS_UASP_MODE)
+			cmdiu->state = COMMAND_STATE_RR_WR;
+		else
 			cmdiu->state = COMMAND_STATE_DATA;
 
 		cmdiu->req_sts = CMD_REQ_NOT_SUBMITTED;
 	}
 
 	switch (cmdiu->state) {
+	case COMMAND_STATE_RR_WR:
+		/* READ READY not sent, create request and submit */
+		if (cmdiu->req_sts == CMD_REQ_NOT_SUBMITTED) {
+			fill_rw_ready_iu((struct rw_ready_iu *)bh->buf,
+					 IU_ID_READ_READY, cmdiu->tag);
+			fill_usb_request(req, cmdiu->bh->buf,
+					 UASP_SIZEOF_RW_READY_IU,
+					 0, (void *)cmdiu, 0,
+					 be16_to_cpup(&cmdiu->tag),
+					 status_complete, udev->op_mode);
+
+			cmdiu->ep = udev->status;
+			cmdiu->req_sts = CMD_REQ_IN_PROGRESS;
+			rc = 1;
+			break;
+		}
+		/* Completion of sent READ READY IU is not received yet */
+		else if (cmdiu->req_sts == CMD_REQ_IN_PROGRESS)
+			break;
+		/* Completion of the sent READ READY is done */
+		else {
+			cmdiu->state = COMMAND_STATE_DATA;
+			cmdiu->req_sts = CMD_REQ_NOT_SUBMITTED;
+		}
 	case COMMAND_STATE_DATA:
 		/* Data is not sent, create and submit */
 		if (cmdiu->req_sts == CMD_REQ_NOT_SUBMITTED) {
@@ -512,7 +604,7 @@ static int do_uasp_mode_sense(struct uasp_dev *udev,
 
 			fill_usb_request(req, buf0, len, 0, cmdiu, 0,
 					 be16_to_cpup(&cmdiu->tag),
-					 uasp_bulk_in_complete);
+					 uasp_bulk_in_complete, udev->op_mode);
 			cmdiu->ep = udev->fsg_dev.bulk_in;
 			cmdiu->req_sts = CMD_REQ_IN_PROGRESS;
 			rc = 1;
@@ -528,7 +620,7 @@ static int do_uasp_mode_sense(struct uasp_dev *udev,
 
 		fill_usb_request(req, bh->buf, UASP_SIZEOF_SENSE_IU, 0,
 				 (void *)cmdiu, 0, be16_to_cpup(&cmdiu->tag),
-				 status_complete);
+				 status_complete, udev->op_mode);
 		cmdiu->ep = udev->status;
 		rc = 1;
 		break;
@@ -589,7 +681,8 @@ uasp_prevent_allow_status:
 	fill_sense_iu(udev, (struct sense_iu *)bh->buf,
 			      cmdiu->tag, status, sense);
 	fill_usb_request(req, bh->buf, UASP_SIZEOF_SENSE_IU, 0, cmdiu, 0,
-			 be16_to_cpup(&cmdiu->tag), status_complete);
+			 be16_to_cpup(&cmdiu->tag), status_complete,
+			 udev->op_mode);
 	cmdiu->ep = udev->status;
 	return 1;
 }
@@ -673,7 +766,9 @@ static int do_uasp_read(struct uasp_dev *udev,
 				SS_LOGICAL_BLOCK_ADDRESS_OUT_OF_RANGE;
 			status = STATUS_CHECK_CONDITION;
 			cmdiu->state = COMMAND_STATE_STATUS;
-		} else
+		} else if (udev->op_mode == HS_UASP_MODE)
+			cmdiu->state = COMMAND_STATE_RR_WR;
+		else
 			cmdiu->state = COMMAND_STATE_DATA;
 
 		cmdiu->req_sts = CMD_REQ_NOT_SUBMITTED;
@@ -684,6 +779,30 @@ static int do_uasp_read(struct uasp_dev *udev,
 
 switch_cmdiu_state:
 	switch (cmdiu->state) {
+	case COMMAND_STATE_RR_WR:
+		/* READ READY not sent, create request and submit */
+		if (cmdiu->req_sts == CMD_REQ_NOT_SUBMITTED) {
+			fill_rw_ready_iu((struct rw_ready_iu *)bh->buf,
+					 IU_ID_READ_READY, cmdiu->tag);
+			fill_usb_request(req, cmdiu->bh->buf,
+					 UASP_SIZEOF_RW_READY_IU,
+					 0, (void *)cmdiu, 0,
+					 be16_to_cpup(&cmdiu->tag),
+					 status_complete, udev->op_mode);
+
+			cmdiu->ep = udev->status;
+			cmdiu->req_sts = CMD_REQ_IN_PROGRESS;
+			rc = 1;
+			break;
+		}
+		/* Completion of sent READ READY IU is not received yet */
+		else if (cmdiu->req_sts == CMD_REQ_IN_PROGRESS)
+			break;
+		/* Completion of the sent READ READY is done */
+		else {
+			cmdiu->state = COMMAND_STATE_DATA;
+			cmdiu->req_sts = CMD_REQ_NOT_SUBMITTED;
+		}
 	case COMMAND_STATE_DATA:
 		/* Data is not sent, create and submit*/
 		if (cmdiu->req_sts == CMD_REQ_NOT_SUBMITTED) {
@@ -760,7 +879,7 @@ send_more_data:		/*
 
 			fill_usb_request(req, bh->buf, nread, 0,
 					 cmdiu, 0, be16_to_cpup(&cmdiu->tag),
-					 uasp_bulk_in_complete);
+					 uasp_bulk_in_complete, udev->op_mode);
 			cmdiu->ep = udev->fsg_dev.bulk_in;
 			cmdiu->req_sts = CMD_REQ_IN_PROGRESS;
 			rc = 1;
@@ -786,7 +905,8 @@ send_status:
 		fill_sense_iu(udev, bh->buf, cmdiu->tag, status, sense);
 		fill_usb_request(req, bh->buf, UASP_SIZEOF_SENSE_IU, 0,
 				 (void *)cmdiu, 0,
-				 be16_to_cpup(&cmdiu->tag), status_complete);
+				 be16_to_cpup(&cmdiu->tag), status_complete,
+				 udev->op_mode);
 		cmdiu->ep = udev->status;
 		rc = 1;
 		break;
@@ -835,13 +955,39 @@ static int do_uasp_read_capacity(struct uasp_dev *udev,
 			sense = SS_INVALID_FIELD_IN_CDB;
 			status = STATUS_CHECK_CONDITION;
 			cmdiu->state = COMMAND_STATE_STATUS;
-		} else
+		} else if (udev->op_mode == HS_UASP_MODE)
+			cmdiu->state = COMMAND_STATE_RR_WR;
+		else
 			cmdiu->state = COMMAND_STATE_DATA;
 
 		cmdiu->req_sts = CMD_REQ_NOT_SUBMITTED;
 	}
 
 	switch (cmdiu->state) {
+	case COMMAND_STATE_RR_WR:
+		/* READ READY not sent, create request and submit */
+		if (cmdiu->req_sts == CMD_REQ_NOT_SUBMITTED) {
+			fill_rw_ready_iu((struct rw_ready_iu *)bh->buf,
+					 IU_ID_READ_READY, cmdiu->tag);
+			fill_usb_request(req, cmdiu->bh->buf,
+					 UASP_SIZEOF_RW_READY_IU,
+					 0, (void *)cmdiu, 0,
+					 be16_to_cpup(&cmdiu->tag),
+					 status_complete, udev->op_mode);
+
+			cmdiu->ep = udev->status;
+			cmdiu->req_sts = CMD_REQ_IN_PROGRESS;
+			rc = 1;
+			break;
+		}
+		/* Completion of sent READ READY IU is not received yet */
+		else if (cmdiu->req_sts == CMD_REQ_IN_PROGRESS)
+			break;
+		/* Completion of the sent READ READY is done */
+		else {
+			cmdiu->state = COMMAND_STATE_DATA;
+			cmdiu->req_sts = CMD_REQ_NOT_SUBMITTED;
+		}
 	case COMMAND_STATE_DATA:
 		/* Data is not sent, create and submit */
 		if (cmdiu->req_sts == CMD_REQ_NOT_SUBMITTED) {
@@ -852,7 +998,7 @@ static int do_uasp_read_capacity(struct uasp_dev *udev,
 
 			fill_usb_request(req, bh->buf, 8, 0,
 					 cmdiu, 0, be16_to_cpup(&cmdiu->tag),
-					 uasp_bulk_in_complete);
+					 uasp_bulk_in_complete, udev->op_mode);
 
 			cmdiu->ep = udev->fsg_dev.bulk_in;
 			cmdiu->req_sts = CMD_REQ_IN_PROGRESS;
@@ -867,7 +1013,8 @@ static int do_uasp_read_capacity(struct uasp_dev *udev,
 		fill_sense_iu(udev, bh->buf, cmdiu->tag, status, sense);
 		fill_usb_request(req, bh->buf, UASP_SIZEOF_SENSE_IU, 0,
 				 (void *)cmdiu, 0,
-				 be16_to_cpup(&cmdiu->tag), status_complete);
+				 be16_to_cpup(&cmdiu->tag), status_complete,
+				 udev->op_mode);
 		cmdiu->ep = udev->status;
 		rc = 1;
 		break;
@@ -910,13 +1057,39 @@ static int do_uasp_read_format_capacities(struct uasp_dev *udev,
 		if (sense) {
 			status = STATUS_CHECK_CONDITION;
 			cmdiu->state = COMMAND_STATE_STATUS;
-		} else
+		} else if (udev->op_mode == HS_UASP_MODE)
+			cmdiu->state = COMMAND_STATE_RR_WR;
+		else
 			cmdiu->state = COMMAND_STATE_DATA;
 
 		cmdiu->req_sts = CMD_REQ_NOT_SUBMITTED;
 	}
 
 	switch (cmdiu->state) {
+	case COMMAND_STATE_RR_WR:
+		/* READ READY not sent, create request and submit */
+		if (cmdiu->req_sts == CMD_REQ_NOT_SUBMITTED) {
+			fill_rw_ready_iu((struct rw_ready_iu *)bh->buf,
+					 IU_ID_READ_READY, cmdiu->tag);
+			fill_usb_request(req, cmdiu->bh->buf,
+					 UASP_SIZEOF_RW_READY_IU,
+					 0, (void *)cmdiu, 0,
+					 be16_to_cpup(&cmdiu->tag),
+					 status_complete, udev->op_mode);
+
+			cmdiu->ep = udev->status;
+			cmdiu->req_sts = CMD_REQ_IN_PROGRESS;
+			rc = 1;
+			break;
+		}
+		/* Completion of sent READ READY IU is not received yet */
+		else if (cmdiu->req_sts == CMD_REQ_IN_PROGRESS)
+			break;
+		/* Completion of the sent READ READY is done */
+		else {
+			cmdiu->state = COMMAND_STATE_DATA;
+			cmdiu->req_sts = CMD_REQ_NOT_SUBMITTED;
+		}
 	case COMMAND_STATE_DATA:
 		/* Data is not sent, create and submit*/
 		if (cmdiu->req_sts == CMD_REQ_NOT_SUBMITTED) {
@@ -934,7 +1107,7 @@ static int do_uasp_read_format_capacities(struct uasp_dev *udev,
 
 			fill_usb_request(req, bh->buf, 12, 0,
 					 cmdiu, 0, be16_to_cpup(&cmdiu->tag),
-					 uasp_bulk_in_complete);
+					 uasp_bulk_in_complete, udev->op_mode);
 
 			cmdiu->ep = udev->fsg_dev.bulk_in;
 			cmdiu->req_sts = CMD_REQ_IN_PROGRESS;
@@ -949,7 +1122,8 @@ static int do_uasp_read_format_capacities(struct uasp_dev *udev,
 		fill_sense_iu(udev, bh->buf, cmdiu->tag, status, sense);
 		fill_usb_request(req, bh->buf, UASP_SIZEOF_SENSE_IU, 0,
 				 (void *)cmdiu, 0,
-				 be16_to_cpup(&cmdiu->tag), status_complete);
+				 be16_to_cpup(&cmdiu->tag), status_complete,
+				 udev->op_mode);
 		cmdiu->ep = udev->status;
 		rc = 1;
 		break;
@@ -1072,7 +1246,8 @@ do_uasp_start_stop_done:
 	fill_sense_iu(udev, bh->buf, cmdiu->tag, status, sense);
 	fill_usb_request(req, bh->buf, UASP_SIZEOF_SENSE_IU, 0,
 			 (void *)cmdiu, 0,
-			 be16_to_cpup(&cmdiu->tag), status_complete);
+			 be16_to_cpup(&cmdiu->tag), status_complete,
+			 udev->op_mode);
 	cmdiu->ep = udev->status;
 
 	DBG(udev->ucommon->common, "%s() - Exit\n", __func__);
@@ -1189,7 +1364,8 @@ static int do_uasp_verify(struct uasp_dev *udev,
 	fill_sense_iu(udev, bh->buf, cmdiu->tag, status, sense);
 	fill_usb_request(req, bh->buf, UASP_SIZEOF_SENSE_IU, 0,
 			 (void *)cmdiu, 0,
-			 be16_to_cpup(&cmdiu->tag), status_complete);
+			 be16_to_cpup(&cmdiu->tag), status_complete,
+			 udev->op_mode);
 	cmdiu->ep = udev->status;
 	DBG(udev->ucommon->common, "%s() - Exit\n", __func__);
 	return 1;
@@ -1306,7 +1482,10 @@ static int do_uasp_write(struct uasp_dev *udev,
 		}
 
 		cmdiu->file_offset = usb_offset = ((loff_t) lba) << 9;
-		cmdiu->state = COMMAND_STATE_DATA;
+		if (udev->op_mode == HS_UASP_MODE)
+			cmdiu->state = COMMAND_STATE_RR_WR;
+		else
+			cmdiu->state = COMMAND_STATE_DATA;
 		cmdiu->req_sts = CMD_REQ_NOT_SUBMITTED;
 		DBG(udev->ucommon->common, "%s() lba = %d, file_offset = %d,"
 					   " xfer_len = %d\n",
@@ -1314,6 +1493,30 @@ static int do_uasp_write(struct uasp_dev *udev,
 	}
 
 	switch (cmdiu->state) {
+	case COMMAND_STATE_RR_WR:
+		/* READ READY not sent, create request and submit */
+		if (cmdiu->req_sts == CMD_REQ_NOT_SUBMITTED) {
+			fill_rw_ready_iu((struct rw_ready_iu *)bh->buf,
+					 IU_ID_WRITE_READY, cmdiu->tag);
+			fill_usb_request(bh->inreq, cmdiu->bh->buf,
+					 UASP_SIZEOF_RW_READY_IU,
+					 0, (void *)cmdiu, 0,
+					 be16_to_cpup(&cmdiu->tag),
+					 status_complete, udev->op_mode);
+
+			cmdiu->ep = udev->status;
+			cmdiu->req_sts = CMD_REQ_IN_PROGRESS;
+			rc = 1;
+			break;
+		}
+		/* Completion of sent READ READY IU is not received yet */
+		else if (cmdiu->req_sts == CMD_REQ_IN_PROGRESS)
+			break;
+		/* Completion of the sent READ READY is done */
+		else {
+			cmdiu->state = COMMAND_STATE_DATA;
+			cmdiu->req_sts = CMD_REQ_NOT_SUBMITTED;
+		}
 	case COMMAND_STATE_DATA:
 		/* Queue a request for more data from the host */
 get_more_data:	if (cmdiu->req_sts == CMD_REQ_NOT_SUBMITTED) {
@@ -1358,7 +1561,7 @@ get_more_data:	if (cmdiu->req_sts == CMD_REQ_NOT_SUBMITTED) {
 
 			fill_usb_request(req, bh->buf, amount, 0,
 					 cmdiu, 0, be16_to_cpup(&cmdiu->tag),
-					 uasp_bulk_out_complete);
+					 uasp_bulk_out_complete, udev->op_mode);
 			DBG(udev->ucommon->common, "%s() fill_usb_request for"
 						   " out endpoint, amout = %d",
 				__func__, amount);
@@ -1458,7 +1661,8 @@ send_status:
 		fill_sense_iu(udev, bh->buf, cmdiu->tag, status, sense);
 		fill_usb_request(bh->inreq, bh->buf, UASP_SIZEOF_SENSE_IU, 0,
 			 (void *)cmdiu, 0,
-			 be16_to_cpup(&cmdiu->tag), status_complete);
+			 be16_to_cpup(&cmdiu->tag), status_complete,
+			 udev->op_mode);
 		cmdiu->ep = udev->status;
 		rc = 1;
 		break;
@@ -1512,7 +1716,8 @@ static int do_uasp_synchronize_cache(struct uasp_dev *udev,
 	cmdiu->state = COMMAND_STATE_STATUS;
 	fill_sense_iu(udev, bh->buf, cmdiu->tag, status, sense);
 	fill_usb_request(req, bh->buf, UASP_SIZEOF_SENSE_IU, 0,
-		 (void *)cmdiu, 0, be16_to_cpup(&cmdiu->tag), status_complete);
+		 (void *)cmdiu, 0, be16_to_cpup(&cmdiu->tag), status_complete,
+		 udev->op_mode);
 	cmdiu->ep = udev->status;
 
 	DBG(udev->ucommon->common, "%s() - Exit\n", __func__);
@@ -1600,7 +1805,7 @@ static void process_cmdiu(struct uasp_dev *udev,
 		fill_usb_request(cmdiu->bh->inreq, (void *)siu,
 				 UASP_SIZEOF_SENSE_IU, 0,
 				 (void *)cmdiu, 0, be16_to_cpup(&cmdiu->tag),
-				 status_complete);
+				 status_complete, udev->op_mode);
 		cmdiu->ep = udev->status;
 		rc = 1;
 		break;
@@ -1676,7 +1881,8 @@ void do_cmdiu(struct uasp_dev *udev, struct uasp_lun *curlun)
 				      "cmdiu!\n", __func__);
 				continue;
 			}
-		} else if (cmdiu->state == COMMAND_STATE_DATA) {
+		} else if (cmdiu->state == COMMAND_STATE_DATA ||
+			   cmdiu->state == COMMAND_STATE_RR_WR) {
 			if (cmdiu->req_sts == CMD_REQ_COMPLETED)
 				spin_unlock_irqrestore(
 					&(udev->ucommon->common->lock), flags);
diff --git a/drivers/usb/gadget/uasp_tmiu.c b/drivers/usb/gadget/uasp_tmiu.c
index 0b4b417..37d8d39 100644
--- a/drivers/usb/gadget/uasp_tmiu.c
+++ b/drivers/usb/gadget/uasp_tmiu.c
@@ -90,7 +90,7 @@ res_lun_fill_response:
 
 	fill_usb_request(tmiu->bh->inreq, (void *)riu, UASP_SIZEOF_RESPONSE_IU,
 			 0, (void *)tmiu, 0, be16_to_cpup(&tmiu->tag),
-			 status_complete);
+			 status_complete, udev->op_mode);
 	tmiu->ep = udev->status;
 }
 
@@ -134,7 +134,8 @@ static void abort_task(struct uasp_dev *udev,
 found:
 	if (cmdiu) {
 		spin_lock_irqsave(&(curlun->lock), flags);
-		if (cmdiu->state == COMMAND_STATE_DATA) {
+		if (cmdiu->state == COMMAND_STATE_DATA ||
+		    cmdiu->state == COMMAND_STATE_RR_WR) {
 			if (cmdiu->req_sts == CMD_REQ_IN_PROGRESS) {
 				spin_unlock_irqrestore(&(curlun->lock), flags);
 				if (cmdiu->bh->inreq_busy)
@@ -161,7 +162,7 @@ abrt_task_fill_response:
 
 	fill_usb_request(tmiu->bh->inreq, (void *)riu, UASP_SIZEOF_RESPONSE_IU,
 			 0, (void *)tmiu, 0, be16_to_cpup(&tmiu->tag),
-			 status_complete);
+			 status_complete, udev->op_mode);
 	tmiu->ep = udev->status;
 }
 
@@ -203,7 +204,7 @@ abrt_ts_fill_response:
 
 	fill_usb_request(tmiu->bh->inreq, (void *)riu, UASP_SIZEOF_RESPONSE_IU,
 			 0, (void *)tmiu, 0, be16_to_cpup(&tmiu->tag),
-			 status_complete);
+			 status_complete, udev->op_mode);
 	tmiu->ep = udev->status;
 }
 
@@ -258,7 +259,7 @@ reset_nexus_fill_response:
 		RESPONSE_TM_FUNCTION_COMPLETE);
 	fill_usb_request(tmiu->bh->inreq, (void *)riu, UASP_SIZEOF_RESPONSE_IU,
 			 0, (void *)tmiu, 0, be16_to_cpup(&tmiu->tag),
-			 status_complete);
+			 status_complete, udev->op_mode);
 	tmiu->ep = udev->status;
 	DBG(udev->ucommon->common, "%s() - Exit\n", __func__);
 }
@@ -306,7 +307,7 @@ qut_fill_response:
 
 	fill_usb_request(tmiu->bh->inreq, (void *)riu, UASP_SIZEOF_RESPONSE_IU,
 			 0, (void *)tmiu, 0, be16_to_cpup(&tmiu->tag),
-			 status_complete);
+			 status_complete, udev->op_mode);
 
 	tmiu->ep = udev->status;
 }
@@ -342,6 +343,7 @@ static void query_task(struct uasp_dev *udev,
 		if (cmdiu->tag == tmiu->task_tag) {
 			if (cmdiu->state == COMMAND_STATE_IDLE  ||
 			    cmdiu->state == COMMAND_STATE_DATA  ||
+			    cmdiu->state == COMMAND_STATE_RR_WR ||
 			    cmdiu->state == COMMAND_STATE_STATUS)
 				status = RESPONSE_TM_FUNCTION_SUCCEEDED;
 			spin_unlock_irqrestore(&(curlun->lock), flags);
@@ -354,7 +356,7 @@ q_task_fill_response:
 	fill_response_iu(udev, riu, tmiu->tag, 0, status);
 	fill_usb_request(tmiu->bh->inreq, (void *)riu, UASP_SIZEOF_RESPONSE_IU,
 			 0, (void *)tmiu, 0, be16_to_cpup(&tmiu->tag),
-			 status_complete);
+			 status_complete, udev->op_mode);
 	tmiu->ep = udev->status;
 }
 
@@ -402,7 +404,7 @@ q_task_set_fill_response:
 	fill_response_iu(udev, riu, tmiu->tag, 0, status);
 	fill_usb_request(tmiu->bh->inreq, (void *)riu, UASP_SIZEOF_RESPONSE_IU,
 			 0, (void *)tmiu, 0, be16_to_cpup(&tmiu->tag),
-			 status_complete);
+			 status_complete, udev->op_mode);
 	tmiu->ep = udev->status;
 	DBG(udev->ucommon->common, "%s() - Exit\n", __func__);
 }
@@ -461,7 +463,7 @@ static void process_tmiu(struct uasp_dev *udev,
 		fill_usb_request(tmiu->bh->inreq, (void *)riu,
 				 UASP_SIZEOF_RESPONSE_IU, 0,
 				 (void *)tmiu, 0, be16_to_cpup(&tmiu->tag),
-				 status_complete);
+				 status_complete, udev->op_mode);
 		tmiu->ep = udev->status;
 		break;
 	}
-- 
1.7.3.3

--
Sent by a Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum
