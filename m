Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932320Ab1DNNgw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 09:36:52 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:19008 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757455Ab1DNNgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 09:36:50 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6315"; a="85579228"
From: Tatyana Brokhman <tlinder@codeaurora.org>
To: gregkh@suse.de
Cc: linux-arm-msm@vger.kernel.org, ablay@codeaurora.org, balbi@ti.com,
        Tatyana Brokhman <tlinder@codeaurora.org>,
        linux-usb@vger.kernel.org (open list:USB GADGET/PERIPH...),
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC/PATCH v3 3/5] uas: COMMAND IU implementation
Date: Thu, 14 Apr 2011 16:36:38 +0300
Message-Id: <1302788199-28012-1-git-send-email-tlinder@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements the handling of different SCSI commands received
in a COMMAND IU packets

Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

diff --git a/drivers/usb/gadget/uasp_cmdiu.c b/drivers/usb/gadget/uasp_cmdiu.c
index 4b3ed24..4d4d193 100644
--- a/drivers/usb/gadget/uasp_cmdiu.c
+++ b/drivers/usb/gadget/uasp_cmdiu.c
@@ -136,7 +136,85 @@ static int do_uasp_inquiry(struct uasp_dev *udev,
 			struct uasp_lun *curlun,
 			struct cmd_iu *cmdiu)
 {
-	return 0;
+	struct fsg_buffhd *bh = cmdiu->bh;
+	struct fsg_common *common = udev->ucommon->common;
+	struct usb_request *req = bh->inreq;
+	__u8 *buf = (__u8 *)bh->buf;
+	__u32 sense = SS_NO_SENSE;
+	__u8 status = STATUS_GOOD;
+	int rc = 0;
+
+	DBG(common, "%s() - Enter\n", __func__);
+
+	if (cmdiu->state == COMMAND_STATE_IDLE) {
+		/* Check is cmdiu is filled correctly */
+		sense = check_cmdiu(udev, curlun, cmdiu, 0);
+
+		/* If error sent status with sense data */
+		if (sense) {
+			ERROR(common, "%s() - Error condition\n", __func__);
+			status = STATUS_CHECK_CONDITION;
+			cmdiu->state = COMMAND_STATE_STATUS;
+		} else if (udev->op_mode == HS_UASP_MODE)
+			cmdiu->state = COMMAND_STATE_RR_WR;
+		else
+			cmdiu->state = COMMAND_STATE_DATA;
+		cmdiu->req_sts = CMD_REQ_NOT_SUBMITTED;
+	}
+
+	switch (cmdiu->state) {
+	case COMMAND_STATE_DATA:
+		/* Data is not sent, create and submit*/
+		if (cmdiu->req_sts == CMD_REQ_NOT_SUBMITTED) {
+			memset(buf, 0, FSG_BUFLEN);
+			if (!curlun) {
+				buf[0] = 0x7f; /* Unsupported, no device-type */
+				buf[4] = 31;   /* Additional length */
+			} else {
+				buf[0] = curlun->lun->cdrom ?
+					TYPE_ROM : TYPE_DISK;
+				buf[1] = curlun->lun->removable ? 0x80 : 0;
+				buf[2] = 2;	/* ANSI SCSI level 2 */
+				buf[3] = 2;	/* SCSI-2 INQUIRY data format */
+				buf[4] = 31;	/* Additional length */
+				buf[5] = 0;	/* No special options */
+				buf[6] = 0;
+				buf[7] = 0;
+				memcpy(buf + 8, common->inquiry_string,
+				       sizeof(common->inquiry_string));
+			}
+
+			fill_usb_request(req, bh->buf,
+				 min(36,
+				(int)get_unaligned_be16(&cmdiu->cdb[3])),
+				 0, (void *)cmdiu, 0,
+				 be16_to_cpup(&cmdiu->tag),
+				 uasp_bulk_in_complete);
+
+			cmdiu->ep = udev->fsg_dev.bulk_in;
+			cmdiu->req_sts = CMD_REQ_IN_PROGRESS;
+			rc = 1;
+			break;
+		} else if (cmdiu->req_sts == CMD_REQ_IN_PROGRESS)
+			/* Completion of sent data is not received yet */
+			break;
+		else /* Completion of the sent data is done */
+			cmdiu->state = COMMAND_STATE_STATUS;
+	case COMMAND_STATE_STATUS:
+		fill_sense_iu(udev, (struct sense_iu *)bh->buf,
+			      cmdiu->tag, status, sense);
+
+		fill_usb_request(req, bh->buf, UASP_SIZEOF_SENSE_IU, 0,
+				 (void *)cmdiu, 0,
+				 be16_to_cpup(&cmdiu->tag), status_complete);
+
+		cmdiu->ep = udev->status;
+		rc = 1;
+		break;
+	default:
+		break;
+	}
+	return rc;
 }
 
 
@@ -149,12 +227,123 @@ static int do_uasp_inquiry(struct uasp_dev *udev,
  *
  * Returns 1 if usb request should be submitted to PCD after cmdiu processing,
  *         0 otherwise.
+ *
+ * From the SCSI-2 spec., section 7.9 (Unit attention condition):
+ * If a REQUEST SENSE command is received from an initiator with a pending unit
+ * attention condition (before the target generates the contingent allegiance
+ * condition), then the target shall either:
+ *   a) report any pending sense data and preserve the unit
+ *	attention condition on the logical unit, or,
+ *   b) report the unit attention condition, may discard any
+ *	pending sense data, and clear the unit attention
+ *	condition on the logical unit for that initiator.
+ *
+ * We implement option a).
+ *
  */
 static int do_uasp_request_sense(struct uasp_dev *udev,
 			      struct uasp_lun *curlun,
 			      struct cmd_iu *cmdiu)
 {
-	return 0;
+	__u8 *buf = (__u8 *)cmdiu->bh->buf;
+	__u32 sdinfo;
+	__u32 sd;
+	int valid, rc = 0;
+	__u32 sense = SS_NO_SENSE;
+	__u8 status = STATUS_GOOD;
+
+	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+
+	if (cmdiu->state == COMMAND_STATE_IDLE) {
+		/* Check is cmdiu is filled correctly */
+		sense = check_cmdiu(udev, curlun, cmdiu, 0);
+
+		/* If error sent status with sense data */
+		if (sense) {
+			status = STATUS_CHECK_CONDITION;
+			cmdiu->state = COMMAND_STATE_STATUS;
+		} else {
+			cmdiu->state = COMMAND_STATE_DATA;
+			cmdiu->req_sts = CMD_REQ_NOT_SUBMITTED;
+		}
+	}
+
+	switch (cmdiu->state) {
+	case COMMAND_STATE_DATA:
+		/* Data is not sent, create and submit */
+		if (cmdiu->req_sts == CMD_REQ_NOT_SUBMITTED) {
+			if (!curlun) {
+				sd = SS_LOGICAL_UNIT_NOT_SUPPORTED;
+				sdinfo = 0;
+				valid = 0;
+			} else {
+				sd = curlun->lun->sense_data;
+				sdinfo = curlun->lun->sense_data_info;
+				valid = curlun->lun->info_valid << 7;
+
+				/*
+				 * If sense data exists, send it and preserve
+				 * unit attention data, then clear sent sense
+				 * data.
+				 */
+				if (sd) {
+					curlun->lun->sense_data = SS_NO_SENSE;
+					curlun->lun->sense_data_info = 0;
+					curlun->lun->info_valid = 0;
+				/*
+				 * If no sense data, sent unit attention data
+				 * then clear the sent unit attention data.
+				 */
+				} else {
+					sd = curlun->lun->unit_attention_data;
+					sdinfo = 0;
+					valid = 0;
+					curlun->lun->unit_attention_data =
+						SS_NO_SENSE;
+				}
+			}
+
+			memset(buf, 0, 18);
+			buf[0] = valid | 0x70;	/* Valid, current error */
+			buf[2] = SK(sd);
+			/* Sense information */
+			put_unaligned_be32(sdinfo, &buf[3]);
+			buf[7] = 18 - 8;	/* Additional sense length */
+			buf[12] = ASC(sd);
+			buf[13] = ASCQ(sd);
+
+			fill_usb_request(cmdiu->bh->inreq, cmdiu->bh->buf,
+					 min(18, (int)cmdiu->cdb[4]),
+					 0, (void *)cmdiu, 0,
+					 be16_to_cpup(&cmdiu->tag),
+					 uasp_bulk_in_complete);
+
+			cmdiu->ep = udev->fsg_dev.bulk_in;
+			cmdiu->req_sts = CMD_REQ_IN_PROGRESS;
+			rc = 1;
+			break;
+		} else if (cmdiu->req_sts == CMD_REQ_IN_PROGRESS)
+			/* Completion of sent data is not received yet */
+			break;
+		else /* Completion of the sent data is done */
+			cmdiu->state = COMMAND_STATE_STATUS;
+	case COMMAND_STATE_STATUS:
+		fill_sense_iu(udev, (struct sense_iu *)cmdiu->bh->buf,
+			  cmdiu->tag, status, sense);
+
+		fill_usb_request(cmdiu->bh->inreq, cmdiu->bh->buf,
+				 UASP_SIZEOF_SENSE_IU, 0,
+				 (void *)cmdiu, 0, be16_to_cpup(&cmdiu->tag),
+				 status_complete);
+		cmdiu->ep = udev->status;
+		rc = 1;
+		break;
+	default:
+		break;
+	}
+
+	DBG(udev->ucommon->common, "%s() - Exit\n", __func__);
+	return rc;
 }
 
 /**
@@ -171,7 +360,29 @@ static int do_uasp_test_unit_ready(struct uasp_dev *udev,
 				struct uasp_lun *curlun,
 				struct cmd_iu *cmdiu)
 {
-	return 0;
+	struct fsg_buffhd *bh = cmdiu->bh;
+	struct usb_request *req = bh->inreq;
+	__u32 sense = SS_NO_SENSE;
+	__u8 status = STATUS_GOOD;
+
+	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+
+	/* Check is cmdiu is filled correctly */
+	sense = check_cmdiu(udev, curlun, cmdiu, 0);
+
+	/* If error sent status with sense data */
+	if (sense)
+		status = STATUS_CHECK_CONDITION;
+
+	cmdiu->state = COMMAND_STATE_STATUS;
+
+	fill_sense_iu(udev, (struct sense_iu *)bh->buf, cmdiu->tag,
+		  status, sense);
+
+	fill_usb_request(req, bh->buf, UASP_SIZEOF_SENSE_IU, 0, cmdiu, 0,
+			 be16_to_cpup(&cmdiu->tag), status_complete);
+	cmdiu->ep = udev->status;
+	return 1;
 }
 
 /**
@@ -189,7 +400,135 @@ static int do_uasp_mode_sense(struct uasp_dev *udev,
 			   struct uasp_lun *curlun,
 			   struct cmd_iu *cmdiu)
 {
-	return 0;
+	struct fsg_buffhd *bh = cmdiu->bh;
+	struct usb_request *req = bh->inreq;
+	__u8 *buf = (__u8 *)bh->buf;
+	__u8 *buf0 = buf;
+	int pc, page_code;
+	int changeable_values, all_pages;
+	int valid_page = 0;
+	int len, limit, rc = 0;
+	int mscmnd = cmdiu->cdb[0];
+	__u32 sense = SS_NO_SENSE;
+	__u8 status = STATUS_GOOD;
+
+	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+
+	if (cmdiu->state == COMMAND_STATE_IDLE) {
+		sense = check_cmdiu(udev, curlun, cmdiu, 0);
+		page_code = cmdiu->cdb[2] & 0x3f;
+
+		if (sense) {
+			status = STATUS_CHECK_CONDITION;
+			cmdiu->state = COMMAND_STATE_STATUS;
+		} else if ((cmdiu->cdb[1] & ~0x08) != 0) {
+			sense = SS_INVALID_FIELD_IN_CDB;
+			status = STATUS_CHECK_CONDITION;
+			cmdiu->state = COMMAND_STATE_STATUS;
+		} else if ((cmdiu->cdb[2] >> 6) == 3) {
+			sense = SS_SAVING_PARAMETERS_NOT_SUPPORTED;
+			status = STATUS_CHECK_CONDITION;
+			cmdiu->state = COMMAND_STATE_STATUS;
+		} else if (page_code != 0x08 && page_code != 0x3f) {
+			sense = SS_INVALID_FIELD_IN_CDB;
+			status = STATUS_CHECK_CONDITION;
+			cmdiu->state = COMMAND_STATE_STATUS;
+		} else
+			cmdiu->state = COMMAND_STATE_DATA;
+
+		cmdiu->req_sts = CMD_REQ_NOT_SUBMITTED;
+	}
+
+	switch (cmdiu->state) {
+	case COMMAND_STATE_DATA:
+		/* Data is not sent, create and submit */
+		if (cmdiu->req_sts == CMD_REQ_NOT_SUBMITTED) {
+			pc = cmdiu->cdb[2] >> 6;
+			page_code = cmdiu->cdb[2] & 0x3f;
+			changeable_values = (pc == 1);
+			all_pages = (page_code == 0x3f);
+			memset(buf, 0, 8);
+
+			if (mscmnd == MODE_SENSE) {
+				buf[2] = (curlun->lun->ro ? 0x80 : 0x00);
+				buf += 4;
+				limit = 255;
+			} else { /* SC_MODE_SENSE_10 */
+				buf[3] = (curlun->lun->ro ? 0x80 : 0x00);
+				buf += 8;
+				limit = FSG_BUFLEN;
+			}
+			/*
+			 * The mode pages, in numerical order.
+			 * The only page we support is the Caching page.
+			 */
+			if (page_code == 0x08 || all_pages) {
+				valid_page = 1;
+				buf[0] = 0x08;	/* Page code */
+				buf[1] = 10;   /* Page length */
+				memset(buf+2, 0, 10);
+					/* None of the fields are changeable */
+
+				if (!changeable_values) {
+					buf[2] = 0x04; /* Write cache enable, */
+					/* Read cache not disabled */
+					/* No cache retention priorities */
+					put_unaligned_be16(0xffff, &buf[4]);
+					/* Don't disable prefetch */
+					/* Minimum prefetch = 0 */
+					put_unaligned_be16(0xffff, &buf[8]);
+					/* Maximum prefetch */
+					put_unaligned_be16(0xffff, &buf[10]);
+					/* Maximum prefetch ceiling */
+				}
+				buf += 12;
+			}
+
+			/*
+			 * Check that a valid page was requested and the mode
+			 * data length isn't too long.
+			 */
+			len = buf - buf0;
+			if (!valid_page || len > limit) {
+				sense = SS_INVALID_FIELD_IN_CDB;
+				status = STATUS_CHECK_CONDITION;
+				cmdiu->state = COMMAND_STATE_STATUS;
+			}
+
+			len = min(len, (int)cmdiu->cdb[4]) ;
+
+			if (mscmnd == MODE_SENSE)
+				/* Store the mode data length */
+				buf0[0] = len - 1;
+			else
+				put_unaligned_be16(len - 2, buf0);
+
+			fill_usb_request(req, buf0, len, 0, cmdiu, 0,
+					 be16_to_cpup(&cmdiu->tag),
+					 uasp_bulk_in_complete);
+			cmdiu->ep = udev->fsg_dev.bulk_in;
+			cmdiu->req_sts = CMD_REQ_IN_PROGRESS;
+			rc = 1;
+			break;
+		} else if (cmdiu->req_sts == CMD_REQ_IN_PROGRESS)
+			/* Completion of sent data is not received yet */
+			break;
+		else  /* Completion of the sent data is done */
+			cmdiu->state = COMMAND_STATE_STATUS;
+	case COMMAND_STATE_STATUS:
+		fill_sense_iu(udev, (struct sense_iu *)bh->buf,
+			  cmdiu->tag, status, sense);
+
+		fill_usb_request(req, bh->buf, UASP_SIZEOF_SENSE_IU, 0,
+				 (void *)cmdiu, 0, be16_to_cpup(&cmdiu->tag),
+				 status_complete);
+		cmdiu->ep = udev->status;
+		rc = 1;
+		break;
+	default:
+		break;
+	}
+	return rc;
 }
 
 /**
@@ -206,7 +545,46 @@ static int do_uasp_prevent_allow(struct uasp_dev *udev,
 			      struct uasp_lun *curlun,
 			      struct cmd_iu *cmdiu)
 {
-	return 0;
+	struct fsg_buffhd *bh = cmdiu->bh;
+	struct usb_request *req = bh->inreq;
+	int prevent;
+	__u32 sense = SS_NO_SENSE;
+	__u8 status = STATUS_GOOD;
+
+	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+
+	/* Check is cmdiu is filled correctly */
+	sense = check_cmdiu(udev, curlun, cmdiu, 0);
+
+	prevent = cmdiu->cdb[4] & 0x01;
+
+	if (sense)
+		status = STATUS_CHECK_CONDITION;
+	else if (!curlun->lun->removable) {
+		status = STATUS_CHECK_CONDITION;
+		sense = SS_INVALID_COMMAND;
+	} else if ((cmdiu->cdb[4] & ~0x01) != 0) { /* Mask away Prevent */
+		status = STATUS_CHECK_CONDITION;
+		sense = SS_INVALID_FIELD_IN_CDB;
+	} else {
+		if (curlun->lun->prevent_medium_removal && !prevent)
+			if (fsg_lun_fsync_sub(curlun->lun)) {
+				status = STATUS_CHECK_CONDITION;
+				sense = SS_COMMUNICATION_FAILURE;
+				goto uasp_prevent_allow_status;
+			}
+		curlun->lun->prevent_medium_removal = prevent;
+	}
+
+uasp_prevent_allow_status:
+	cmdiu->state = COMMAND_STATE_STATUS;
+
+	fill_sense_iu(udev, (struct sense_iu *)bh->buf,
+			      cmdiu->tag, status, sense);
+	fill_usb_request(req, bh->buf, UASP_SIZEOF_SENSE_IU, 0, cmdiu, 0,
+			 be16_to_cpup(&cmdiu->tag), status_complete);
+	cmdiu->ep = udev->status;
+	return 1;
 }
 
 /**
@@ -223,7 +601,192 @@ static int do_uasp_read(struct uasp_dev *udev,
 		     struct uasp_lun *curlun,
 		     struct cmd_iu *cmdiu)
 {
-	return 0;
+	struct fsg_buffhd *bh = cmdiu->bh;
+	struct usb_request *req = bh->inreq;
+	__u8 mscmnd = cmdiu->cdb[0];
+	loff_t file_offset_tmp;
+	__u32 amount, lba;
+	ssize_t nread;
+	unsigned int partial_page;
+	__u32 sense = SS_NO_SENSE;
+	__u8 status = STATUS_GOOD;
+	int rc = 0;
+
+	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+
+	if (cmdiu->state == COMMAND_STATE_IDLE) {
+		if (!curlun) {
+			ERROR(udev->ucommon->common,
+			       "%s() - Error condition - curlun = NULL\n",
+			       __func__);
+			sense = SS_LOGICAL_UNIT_NOT_SUPPORTED;
+			status = STATUS_CHECK_CONDITION;
+			cmdiu->state = COMMAND_STATE_STATUS;
+			goto switch_cmdiu_state;
+		}
+
+		/*
+		 * Get the starting Logical Block Address and check that it's
+		 * not too big
+		 */
+		if (mscmnd == READ_6) {
+			lba = get_unaligned_be24(&cmdiu->cdb[1]);
+			cmdiu->xfer_len =
+			     ((cmdiu->cdb[4] == 0 ? 256 : cmdiu->cdb[4]) << 9);
+		} else {
+			lba = get_unaligned_be32(&cmdiu->cdb[2]);
+			/*
+			 * We allow DPO (Disable Page Out = don't save data in
+			 * the cache) and FUA (Force Unit Access = don't read
+			 * from the cache), but we don't implement them.
+			 */
+			if ((cmdiu->cdb[1] & ~0x18) != 0) {
+				sense = SS_INVALID_FIELD_IN_CDB;
+				status = STATUS_CHECK_CONDITION;
+				cmdiu->state = COMMAND_STATE_STATUS;
+				goto switch_cmdiu_state;
+			}
+
+			if (mscmnd == READ_10)
+				cmdiu->xfer_len =
+				      (get_unaligned_be16(&cmdiu->cdb[7]) << 9);
+			else
+				cmdiu->xfer_len =
+				      (get_unaligned_be32(&cmdiu->cdb[6]) << 9);
+		}
+		cmdiu->file_offset = ((loff_t) lba) << 9;
+		sense = check_cmdiu(udev, curlun, cmdiu, 1);
+
+		if (sense) {
+			status = STATUS_CHECK_CONDITION;
+			cmdiu->state = COMMAND_STATE_STATUS;
+		} else if (lba >= curlun->lun->num_sectors) {
+			sense = SS_INVALID_FIELD_IN_CDB;
+			curlun->lun->sense_data =
+				SS_LOGICAL_BLOCK_ADDRESS_OUT_OF_RANGE;
+			status = STATUS_CHECK_CONDITION;
+			cmdiu->state = COMMAND_STATE_STATUS;
+		} else
+			cmdiu->state = COMMAND_STATE_DATA;
+
+		cmdiu->req_sts = CMD_REQ_NOT_SUBMITTED;
+		DBG(udev->ucommon->common, "%s() lba = %d, file_offset = %d,"
+					   " xfer_len = %d\n",
+		__func__, lba, cmdiu->file_offset, cmdiu->xfer_len);
+	}
+
+switch_cmdiu_state:
+	switch (cmdiu->state) {
+	case COMMAND_STATE_DATA:
+		/* Data is not sent, create and submit*/
+		if (cmdiu->req_sts == CMD_REQ_NOT_SUBMITTED) {
+send_more_data:		/*
+			 * Figure out how much we need to read:
+			 * Try to read the remaining amount.
+			 * But don't read more than the buffer size.
+			 * And don't try to read past the end of the file.
+			 * Finally, if we're not at a page boundary, don't read
+			 * past the next page.
+			 * If this means reading 0 then we were asked to read
+			 * past the end of file.
+			 */
+			amount = min((unsigned int)cmdiu->xfer_len, FSG_BUFLEN);
+			amount = min((loff_t) amount,
+				curlun->lun->file_length - cmdiu->file_offset);
+			partial_page = cmdiu->file_offset &
+						(PAGE_CACHE_SIZE - 1);
+			if (partial_page > 0)
+				amount = min(amount,
+					     (unsigned int) PAGE_CACHE_SIZE -
+						partial_page);
+
+			/*
+			 * If we were asked to read past the end of file,
+			 * end with an empty buffer.
+			 */
+			if (amount == 0) {
+				curlun->lun->sense_data =
+					SS_LOGICAL_BLOCK_ADDRESS_OUT_OF_RANGE;
+				curlun->lun->sense_data_info =
+					cmdiu->file_offset >> 9;
+				curlun->lun->info_valid = 1;
+				cmdiu->xfer_len = 0;
+				nread = 0;
+			} else {
+				/* Perform the read */
+				file_offset_tmp = cmdiu->file_offset;
+				nread = vfs_read(curlun->lun->filp,
+						(char __user *) bh->buf,
+						amount, &file_offset_tmp);
+
+				if (nread < 0) {
+					LDBG(curlun->lun,
+					     "error in file read: %d\n",
+					     (int) nread);
+					nread = 0;
+				} else if (nread < amount) {
+					LDBG(curlun->lun,
+					     "partial file read: %d/%u\n",
+					     (int) nread, amount);
+					nread -= (nread & 511);
+						/* Round down to a block */
+				}
+
+				cmdiu->file_offset += nread;
+				cmdiu->xfer_len -= nread;
+
+				/*
+				 * If an error occurred, report it and
+				 * its position
+				 */
+				if (nread < amount) {
+					curlun->lun->sense_data = sense =
+						SS_UNRECOVERED_READ_ERROR;
+					curlun->lun->sense_data_info =
+						cmdiu->file_offset >> 9;
+					curlun->lun->info_valid = 1;
+					status = STATUS_CHECK_CONDITION;
+					cmdiu->state = COMMAND_STATE_STATUS;
+					goto send_status;
+				}
+			}
+
+			fill_usb_request(req, bh->buf, nread, 0,
+					 cmdiu, 0, be16_to_cpup(&cmdiu->tag),
+					 uasp_bulk_in_complete);
+			cmdiu->ep = udev->fsg_dev.bulk_in;
+			cmdiu->req_sts = CMD_REQ_IN_PROGRESS;
+			rc = 1;
+			break;
+		} else if (cmdiu->req_sts == CMD_REQ_IN_PROGRESS) {
+			/* Completion of sent data is not received yet */
+			DBG(udev->ucommon->common,
+			    "%s() - completion for bh is not received",
+			     __func__);
+			break;
+		} else {
+			/* Completion of the sent data is done */
+			DBG(udev->ucommon->common,
+			    "%s() - COMMAND_STATE_DATA for bh\n", __func__);
+			if (cmdiu->xfer_len == 0)
+				goto send_status;
+			else
+				goto send_more_data;
+		}
+send_status:
+		cmdiu->state = COMMAND_STATE_STATUS;
+	case COMMAND_STATE_STATUS:
+		fill_sense_iu(udev, bh->buf, cmdiu->tag, status, sense);
+		fill_usb_request(req, bh->buf, UASP_SIZEOF_SENSE_IU, 0,
+				 (void *)cmdiu, 0,
+				 be16_to_cpup(&cmdiu->tag), status_complete);
+		cmdiu->ep = udev->status;
+		rc = 1;
+		break;
+	default:
+		break;
+	}
+	return rc;
 }
 
 /**
@@ -241,7 +804,71 @@ static int do_uasp_read_capacity(struct uasp_dev *udev,
 			 struct uasp_lun *curlun,
 			 struct cmd_iu *cmdiu)
 {
-	return 0;
+	struct fsg_buffhd *bh = cmdiu->bh;
+	struct usb_request *req = bh->inreq;
+	__u8 *buf = (__u8 *)bh->buf;
+	__u32 lba;
+	int pmi, rc = 0;
+	__u32 sense = SS_NO_SENSE;
+	__u8 status = STATUS_GOOD;
+
+	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+
+	if (cmdiu->state == COMMAND_STATE_IDLE) {
+		/* Check is cmdiu is filled correctly */
+		sense = check_cmdiu(udev, curlun, cmdiu, 0);
+
+		lba = get_unaligned_be32(&cmdiu->cdb[2]);
+		pmi = cmdiu->cdb[8];
+
+		if (sense) {
+			status = STATUS_CHECK_CONDITION;
+			cmdiu->state = COMMAND_STATE_STATUS;
+		} else if (pmi > 1 || (pmi == 0 && lba != 0)) {
+			sense = SS_INVALID_FIELD_IN_CDB;
+			status = STATUS_CHECK_CONDITION;
+			cmdiu->state = COMMAND_STATE_STATUS;
+		} else
+			cmdiu->state = COMMAND_STATE_DATA;
+
+		cmdiu->req_sts = CMD_REQ_NOT_SUBMITTED;
+	}
+
+	switch (cmdiu->state) {
+	case COMMAND_STATE_DATA:
+		/* Data is not sent, create and submit */
+		if (cmdiu->req_sts == CMD_REQ_NOT_SUBMITTED) {
+			put_unaligned_be32(curlun->lun->num_sectors - 1,
+					   &buf[0]);
+							/* Max logical block */
+			put_unaligned_be32(512, &buf[4]); /* Block length */
+
+			fill_usb_request(req, bh->buf, 8, 0,
+					 cmdiu, 0, be16_to_cpup(&cmdiu->tag),
+					 uasp_bulk_in_complete);
+
+			cmdiu->ep = udev->fsg_dev.bulk_in;
+			cmdiu->req_sts = CMD_REQ_IN_PROGRESS;
+			rc = 1;
+			break;
+		} else if (cmdiu->req_sts == CMD_REQ_IN_PROGRESS)
+			/* Completion of sent data is not received yet */
+			break;
+		else /* Completion of the sent data is done */
+			cmdiu->state = COMMAND_STATE_STATUS;
+	case COMMAND_STATE_STATUS:
+		fill_sense_iu(udev, bh->buf, cmdiu->tag, status, sense);
+		fill_usb_request(req, bh->buf, UASP_SIZEOF_SENSE_IU, 0,
+				 (void *)cmdiu, 0,
+				 be16_to_cpup(&cmdiu->tag), status_complete);
+		cmdiu->ep = udev->status;
+		rc = 1;
+		break;
+	default:
+		break;
+	}
+
+	return rc;
 }
 
 /**
@@ -259,7 +886,72 @@ static int do_uasp_read_format_capacities(struct uasp_dev *udev,
 				       struct uasp_lun *curlun,
 				       struct cmd_iu *cmdiu)
 {
-	return 0;
+	struct fsg_buffhd *bh = cmdiu->bh;
+	struct usb_request *req = bh->inreq;
+	__u8 *buf = (__u8 *)bh->buf;
+	__u32 sense = SS_NO_SENSE;
+	__u8 status = STATUS_GOOD;
+	int rc = 0;
+
+	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+
+	if (cmdiu->state == COMMAND_STATE_IDLE) {
+		/* Check is cmdiu is filled correctly */
+		sense = check_cmdiu(udev, curlun, cmdiu, 0);
+
+		/* If error sent status with sense data */
+		if (sense) {
+			status = STATUS_CHECK_CONDITION;
+			cmdiu->state = COMMAND_STATE_STATUS;
+		} else
+			cmdiu->state = COMMAND_STATE_DATA;
+
+		cmdiu->req_sts = CMD_REQ_NOT_SUBMITTED;
+	}
+
+	switch (cmdiu->state) {
+	case COMMAND_STATE_DATA:
+		/* Data is not sent, create and submit*/
+		if (cmdiu->req_sts == CMD_REQ_NOT_SUBMITTED) {
+			buf[0] = buf[1] = buf[2] = 0;
+			buf[3] = 8;	/*
+					 * Only the Current/Maximum
+					 * Capacity Descriptor
+					*/
+			buf += 4;
+
+			put_unaligned_be32(curlun->lun->num_sectors, &buf[0]);
+						/* Number of blocks */
+			put_unaligned_be32(512, &buf[4]);  /* Block length */
+			buf[4] = 0x02;		/* Current capacity */
+
+			fill_usb_request(req, bh->buf, 12, 0,
+					 cmdiu, 0, be16_to_cpup(&cmdiu->tag),
+					 uasp_bulk_in_complete);
+
+			cmdiu->ep = udev->fsg_dev.bulk_in;
+			cmdiu->req_sts = CMD_REQ_IN_PROGRESS;
+			rc = 1;
+			break;
+		} else if (cmdiu->req_sts == CMD_REQ_IN_PROGRESS)
+			/* Completion of sent data is not received yet */
+			break;
+		else	/* Completion of the sent data is done */
+			cmdiu->state = COMMAND_STATE_STATUS;
+	case COMMAND_STATE_STATUS:
+		fill_sense_iu(udev, bh->buf, cmdiu->tag, status, sense);
+		fill_usb_request(req, bh->buf, UASP_SIZEOF_SENSE_IU, 0,
+				 (void *)cmdiu, 0,
+				 be16_to_cpup(&cmdiu->tag), status_complete);
+		cmdiu->ep = udev->status;
+		rc = 1;
+		break;
+	default:
+		break;
+	}
+
+	DBG(udev->ucommon->common, "%s() - Exit\n", __func__);
+	return rc;
 }
 
 /**
@@ -277,7 +969,107 @@ static int do_uasp_start_stop(struct uasp_dev *udev,
 			   struct uasp_lun *curlun,
 			   struct cmd_iu *cmdiu)
 {
-	return 0;
+	struct fsg_buffhd *bh = cmdiu->bh;
+	struct usb_request *req = bh->inreq;
+	__u32 sense = SS_NO_SENSE;
+	__u8 status = STATUS_GOOD;
+	int start, loej;
+
+	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+
+	start = cmdiu->cdb[4] & 0x01;
+	loej = cmdiu->cdb[4] & 0x02;
+
+	sense = check_cmdiu(udev, curlun, cmdiu, 0);
+
+	if (sense)
+		status = STATUS_CHECK_CONDITION;
+	else if (!curlun->lun->removable) {
+		sense = SS_INVALID_COMMAND;
+		status = STATUS_CHECK_CONDITION;
+	} else if ((cmdiu->cdb[1] & ~0x01) != 0 || /* Mask away Immed */
+		   (cmdiu->cdb[4] & ~0x03) != 0) { /* Mask LoEj, Start */
+		sense = SS_INVALID_FIELD_IN_CDB;
+		status = STATUS_CHECK_CONDITION;
+	}
+
+	if (status)
+		goto do_uasp_start_stop_done;
+
+	if (!loej) {
+		/*
+		 * No action should be taken regarding loading or ejecting of
+		 * the medium
+		 */
+		/*
+		 * Our emulation doesn't support mounting; the medium is
+		 * available for use as soon as it is loaded.
+		 */
+		if (start && !fsg_lun_is_open(curlun->lun)) {
+			sense = SS_MEDIUM_NOT_PRESENT;
+			status = STATUS_CHECK_CONDITION;
+		}
+	} else {
+		/*
+		 * LOEJ = 1 & START = 0 -> requests that the medium
+		 *			   shall be unloaded
+		 */
+		if (start) {
+			if (!fsg_lun_is_open(curlun->lun)) {
+				sense = SS_MEDIUM_NOT_PRESENT;
+				status = STATUS_CHECK_CONDITION;
+			}
+		} else {
+			/* Are we allowed to unload the media? */
+			if (curlun->lun->prevent_medium_removal) {
+				DBG(udev->ucommon->common,
+				    "%s(): unload attempt prevented\n",
+				    __func__);
+				sense = SS_MEDIUM_REMOVAL_PREVENTED;
+				status = STATUS_CHECK_CONDITION;
+				goto do_uasp_start_stop_done;
+			}
+
+			/* Simulate an unload/eject */
+			if (udev->ucommon->common->ops &&
+			    udev->ucommon->common->ops->pre_eject) {
+				int r = udev->ucommon->common->ops->pre_eject(
+					udev->ucommon->common, curlun->lun,
+					curlun - udev->ucommon->uluns);
+				if (unlikely(r < 0))
+					status = STATUS_CHECK_CONDITION;
+				else if (r) /* r > 0 means don't aject */
+					goto do_uasp_start_stop_done;
+			}
+
+			up_read(&(udev->ucommon->common->filesem));
+			down_write(&(udev->ucommon->common->filesem));
+			close_lun(curlun);
+			up_write(&(udev->ucommon->common->filesem));
+			down_read(&(udev->ucommon->common->filesem));
+
+			if (udev->ucommon->common->ops
+			    && udev->ucommon->common->ops->post_eject) {
+				 if (udev->ucommon->common->ops->
+				     post_eject(udev->ucommon->common,
+						curlun->lun,
+						curlun - udev->ucommon->uluns)
+				     < 0)
+					 status = STATUS_CHECK_CONDITION;
+			}
+		}
+	}
+
+do_uasp_start_stop_done:
+	cmdiu->state = COMMAND_STATE_STATUS;
+	fill_sense_iu(udev, bh->buf, cmdiu->tag, status, sense);
+	fill_usb_request(req, bh->buf, UASP_SIZEOF_SENSE_IU, 0,
+			 (void *)cmdiu, 0,
+			 be16_to_cpup(&cmdiu->tag), status_complete);
+	cmdiu->ep = udev->status;
+
+	DBG(udev->ucommon->common, "%s() - Exit\n", __func__);
+	return 1;
 }
 
 /**
@@ -298,7 +1090,102 @@ static int do_uasp_verify(struct uasp_dev *udev,
 		       struct uasp_lun *curlun,
 		       struct cmd_iu *cmdiu)
 {
-	return 0;
+	struct fsg_buffhd *bh = cmdiu->bh;
+	struct usb_request *req = bh->inreq;
+	loff_t file_offset_tmp, file_offset;
+	__u32 ver_len, amount;
+	ssize_t nread;
+	__u32 sense = SS_NO_SENSE;
+	__u8 status = STATUS_GOOD;
+
+	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+
+	file_offset = (get_unaligned_be32(&cmdiu->cdb[2]) << 9);
+	ver_len = (get_unaligned_be32(&cmdiu->cdb[7]) << 9);
+
+	sense = check_cmdiu(udev, curlun, cmdiu, 1);
+
+	if (sense)
+		status = STATUS_CHECK_CONDITION;
+	else if (file_offset + ver_len > curlun->lun->file_length) {
+		sense = SS_LOGICAL_BLOCK_ADDRESS_OUT_OF_RANGE;
+		status = STATUS_CHECK_CONDITION;
+	} else if ((cmdiu->cdb[1] & ~0x10) != 0) {
+		/*
+		 * We allow DPO (Disable Page Out = don't save data in the
+		 * cache) but we don't implement it.
+		 */
+		sense = SS_INVALID_FIELD_IN_CDB;
+		status = STATUS_CHECK_CONDITION;
+	} else {
+		if (ver_len == 0)
+			/* Verify all the remaining blocks */
+			ver_len = curlun->lun->file_length - file_offset;
+
+		/* Write out all the dirty buffers before invalidating them */
+		fsg_lun_fsync_sub(curlun->lun);
+		invalidate_sub(curlun->lun);
+
+		/* Just try to read the requested blocks */
+		while (ver_len > 0) {
+			/*
+			 * Figure out how much we need to read:
+			 * Try to read the remaining amount, but not more than
+			 * the buffer size.
+			 * And don't try to read past the end of the file.
+			 * If this means reading 0 then we were asked to read
+			 * past the end of file.
+			 */
+			amount = min((unsigned int) ver_len, FSG_BUFLEN);
+			amount = min((loff_t) amount,
+				curlun->lun->file_length - file_offset);
+			if (amount == 0) {
+				sense = SS_LOGICAL_BLOCK_ADDRESS_OUT_OF_RANGE;
+				status = STATUS_CHECK_CONDITION;
+				break;
+			}
+
+			/* Perform the read */
+			file_offset_tmp = file_offset;
+			nread = vfs_read(curlun->lun->filp,
+					(char __user *) bh->buf,
+					amount, &file_offset_tmp);
+			VLDBG(curlun->lun, "file read %u @ %llu -> %d\n",
+			      amount, (unsigned long long) file_offset,
+				(int)nread);
+
+			if (nread < 0) {
+				LDBG(curlun->lun, "error in file verify: %d\n",
+					(int) nread);
+				nread = 0;
+			} else if (nread < amount) {
+				LDBG(curlun->lun,
+				     "partial file verify: %d/%u\n",
+					(int) nread, amount);
+				/* Round down to a sector */
+				nread -= (nread & 511);
+			}
+
+			if (nread == 0) {
+				sense = SS_UNRECOVERED_READ_ERROR;
+				status = STATUS_CHECK_CONDITION;
+				break;
+			}
+
+			file_offset += nread;
+			ver_len -= nread;
+		}
+	}
+
+	cmdiu->state = COMMAND_STATE_STATUS;
+
+	fill_sense_iu(udev, bh->buf, cmdiu->tag, status, sense);
+	fill_usb_request(req, bh->buf, UASP_SIZEOF_SENSE_IU, 0,
+			 (void *)cmdiu, 0,
+			 be16_to_cpup(&cmdiu->tag), status_complete);
+	cmdiu->ep = udev->status;
+	DBG(udev->ucommon->common, "%s() - Exit\n", __func__);
+	return 1;
 }
 
 /**
@@ -317,7 +1204,263 @@ static int do_uasp_write(struct uasp_dev *udev,
 		      struct uasp_lun *curlun,
 		      struct cmd_iu *cmdiu)
 {
-	return 0;
+	struct fsg_buffhd *bh = cmdiu->bh;
+	struct usb_request *req = bh->outreq;
+	loff_t			usb_offset = 0;
+	loff_t			file_offset_tmp = 0;
+	unsigned int		partial_page;
+	__u32			amount = 0;
+	ssize_t			nwritten = 0;
+	u32 sense = SS_NO_SENSE;
+	__u32		lba;
+	__u8 status = STATUS_GOOD;
+	int rc = 0;
+
+	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+
+	if (!curlun) {
+		ERROR(udev->ucommon->common,
+		       "%s() - Error condition - curlun = NULL\n",
+		       __func__);
+		sense = SS_LOGICAL_UNIT_NOT_SUPPORTED;
+		status = STATUS_CHECK_CONDITION;
+		cmdiu->state = COMMAND_STATE_STATUS;
+		goto send_status;
+	}
+
+	if (curlun->lun->ro) {
+		sense = SS_WRITE_PROTECTED;
+		status = STATUS_CHECK_CONDITION;
+		goto send_status;
+	}
+
+	if (cmdiu->state == COMMAND_STATE_IDLE) {
+		spin_lock(&curlun->lun->filp->f_lock);
+			/* Default is not to wait */
+		curlun->lun->filp->f_flags &= ~O_SYNC;
+		spin_unlock(&curlun->lun->filp->f_lock);
+		/*
+		 * Get the starting Logical Block Address and check that it's
+		 * not too big
+		 */
+		switch (cmdiu->cdb[0]) {
+		case WRITE_6:
+			lba = get_unaligned_be24(&cmdiu->cdb[1]);
+			cmdiu->xfer_len =
+				(cmdiu->cdb[4] == 0 ? 256 : cmdiu->cdb[4]) << 9;
+			break;
+		case WRITE_10:
+			lba = get_unaligned_be32(&cmdiu->cdb[2]);
+			cmdiu->xfer_len =
+				get_unaligned_be16(&cmdiu->cdb[7]) << 9;
+			break;
+		case WRITE_12:
+			lba = get_unaligned_be32(&cmdiu->cdb[2]);
+			cmdiu->xfer_len =
+				get_unaligned_be32(&cmdiu->cdb[6]) << 9;
+			break;
+		default:
+			sense = SS_INVALID_COMMAND;
+			status = STATUS_CHECK_CONDITION;
+			goto send_status;
+		}
+
+		sense = check_cmdiu(udev, curlun, cmdiu, 1);
+		/* If error sent status with sense data */
+		if (sense) {
+			status = STATUS_CHECK_CONDITION;
+			goto send_status;
+		}
+
+		if (cmdiu->cdb[0] != WRITE_6) {
+			/*
+			 * We allow DPO (Disable Page Out = don't save data in
+			 * the cache) and FUA (Force Unit Access = write
+			 * directly to the medium).  We don't implement DPO; we
+			 * implement FUA by performing synchronous output.
+			 */
+			if (cmdiu->cdb[1] & ~0x18) {
+				sense = SS_INVALID_FIELD_IN_CDB;
+				status = STATUS_CHECK_CONDITION;
+				goto send_status;
+			}
+			if (!curlun->lun->nofua && (cmdiu->cdb[1] & 0x08)) {
+				/* FUA */
+				spin_lock(&curlun->lun->filp->f_lock);
+				curlun->lun->filp->f_flags |= O_SYNC;
+				spin_unlock(&curlun->lun->filp->f_lock);
+			}
+		}
+
+		if (lba >= curlun->lun->num_sectors) {
+			sense = SS_LOGICAL_BLOCK_ADDRESS_OUT_OF_RANGE;
+			status = STATUS_CHECK_CONDITION;
+			goto send_status;
+		}
+
+		cmdiu->file_offset = usb_offset = ((loff_t) lba) << 9;
+		cmdiu->state = COMMAND_STATE_DATA;
+		cmdiu->req_sts = CMD_REQ_NOT_SUBMITTED;
+		DBG(udev->ucommon->common, "%s() lba = %d, file_offset = %d,"
+					   " xfer_len = %d\n",
+		__func__, lba, cmdiu->file_offset, cmdiu->xfer_len);
+	}
+
+	switch (cmdiu->state) {
+	case COMMAND_STATE_DATA:
+		/* Queue a request for more data from the host */
+get_more_data:	if (cmdiu->req_sts == CMD_REQ_NOT_SUBMITTED) {
+			/*
+			 * Figure out how much we want to get:
+			 * Try to get the remaining amount.
+			 * But don't get more than the buffer size.
+			 * And don't try to go past the end of the file.
+			 * If we're not at a page boundary, don't go past the
+			 * next page.
+			 * If this means getting 0, then we were asked to write
+			 * past the end of file.
+			 * Finally, round down to a block boundary.
+			 */
+			amount = min(cmdiu->xfer_len, FSG_BUFLEN);
+			amount = min((loff_t) amount,
+				     curlun->lun->file_length - usb_offset);
+			partial_page = usb_offset & (PAGE_CACHE_SIZE - 1);
+			if (partial_page > 0)
+				amount = min(amount,
+					(unsigned int)PAGE_CACHE_SIZE -
+					     partial_page);
+
+			if (amount == 0) {
+				sense = SS_LOGICAL_BLOCK_ADDRESS_OUT_OF_RANGE;
+				curlun->lun->sense_data_info = usb_offset >> 9;
+				curlun->lun->info_valid = 1;
+				status = STATUS_CHECK_CONDITION;
+				goto send_status;
+			}
+
+			amount -= (amount & 511);
+			if (amount == 0)
+				/*
+				 * Why were we were asked to transfer a
+				 * partial block?
+				 */
+				goto send_status;
+
+			/* Get the next buffer */
+			usb_offset += amount;
+
+			fill_usb_request(req, bh->buf, amount, 0,
+					 cmdiu, 0, be16_to_cpup(&cmdiu->tag),
+					 uasp_bulk_out_complete);
+			DBG(udev->ucommon->common, "%s() fill_usb_request for"
+						   " out endpoint, amout = %d",
+				__func__, amount);
+
+			cmdiu->ep = udev->fsg_dev.bulk_out;
+			cmdiu->req_sts = CMD_REQ_IN_PROGRESS;
+			rc = 2;
+			break;
+		} else if (cmdiu->req_sts == CMD_REQ_IN_PROGRESS)
+			/* Completion of sent data is not received yet */
+			break;
+		else { /* Completion of the sent data is done */
+			/* Did something go wrong with the transfer? */
+			if (bh->outreq->status != 0) {
+				sense = SS_COMMUNICATION_FAILURE;
+				curlun->lun->sense_data_info =
+					cmdiu->file_offset >> 9;
+				curlun->lun->info_valid = 1;
+				status = STATUS_CHECK_CONDITION;
+				goto send_status;
+			}
+			if (req->actual != req->length) {
+				/*
+				 * Host decide abort the command
+				 * Note: if we going to submit more than one
+				 * request for this command, we should abort
+				 * all submitted requests for this command
+				 */
+				DBG(udev->ucommon->common,
+				    "%s() - Host aborted the command\n",
+				    __func__);
+				goto send_status;
+			}
+
+			amount = req->actual;
+			if (curlun->lun->file_length - cmdiu->file_offset <
+				amount) {
+				ERROR(udev->ucommon->common,
+				      "%s(): write %u @ %llu beyond end %llu\n",
+				      __func__, amount,
+				      (unsigned long long)cmdiu->file_offset,
+				      (unsigned long long)
+						curlun->lun->file_length);
+				amount = curlun->lun->file_length -
+					cmdiu->file_offset;
+			}
+
+			/* Perform the write */
+			file_offset_tmp = cmdiu->file_offset;
+			nwritten = vfs_write(curlun->lun->filp,
+					(char __user *) bh->buf,
+					amount, &file_offset_tmp);
+			DBG(udev->ucommon->common,
+			    "%s(): file write %u @ %llu -> %d\n", __func__,
+			    amount, (unsigned long long)cmdiu->file_offset,
+					(int)nwritten);
+
+			if (nwritten < 0) {
+				ERROR(udev->ucommon->common,
+				      "%s(): error in file write: %d\n",
+				      __func__, (int)nwritten);
+				nwritten = 0;
+			} else if (nwritten < amount) {
+				DBG(udev->ucommon->common,
+				      "%s(): partial file write: %d/%u\n",
+				    __func__, (int)nwritten, amount);
+				nwritten -= (nwritten & 511);
+				/* Round down to a block */
+			}
+
+			cmdiu->file_offset += nwritten;
+			cmdiu->xfer_len -= nwritten;
+
+			/* If an error occurred, report it and its position */
+			if (nwritten < amount) {
+				sense = SS_WRITE_ERROR;
+				curlun->lun->sense_data_info =
+					cmdiu->file_offset >> 9;
+				curlun->lun->info_valid = 1;
+				status = STATUS_CHECK_CONDITION;
+				goto send_status;
+			}
+
+			if (cmdiu->xfer_len == 0) {
+				DBG(udev->ucommon->common,
+				      "%s() - cmdiu->xferlen = 0, "
+				      "send status\n", __func__);
+				goto send_status;
+			}
+			cmdiu->req_sts = CMD_REQ_NOT_SUBMITTED;
+			goto get_more_data;
+
+send_status:
+			cmdiu->state = COMMAND_STATE_STATUS;
+		}
+	case COMMAND_STATE_STATUS:
+		fill_sense_iu(udev, bh->buf, cmdiu->tag, status, sense);
+		fill_usb_request(bh->inreq, bh->buf, UASP_SIZEOF_SENSE_IU, 0,
+			 (void *)cmdiu, 0,
+			 be16_to_cpup(&cmdiu->tag), status_complete);
+		cmdiu->ep = udev->status;
+		rc = 1;
+		break;
+	default:
+		break;
+	}
+
+	DBG(udev->ucommon->common, "%s() - Exit\n", __func__);
+	return rc;
 }
 
 /**
@@ -335,7 +1478,38 @@ static int do_uasp_synchronize_cache(struct uasp_dev *udev,
 				  struct uasp_lun *curlun,
 				  struct cmd_iu *cmdiu)
 {
-	return 0;
+	struct fsg_buffhd *bh = cmdiu->bh;
+	struct usb_request *req = bh->inreq;
+	uint32_t sense = SS_NO_SENSE;
+	uint8_t status = STATUS_GOOD;
+	int rc;
+
+	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+
+	/* Check is cmdiu is filled correctly */
+	sense = check_cmdiu(udev, curlun, cmdiu, 0);
+
+	/*
+	 * We ignore the requested LBA and write out all file's
+	 * dirty data buffers.
+	 */
+	rc = fsg_lun_fsync_sub(curlun->lun);
+
+	if (sense)
+		status = STATUS_CHECK_CONDITION;
+	else if (rc) {
+		sense = SS_WRITE_ERROR;
+		status = STATUS_CHECK_CONDITION;
+	}
+
+	cmdiu->state = COMMAND_STATE_STATUS;
+	fill_sense_iu(udev, bh->buf, cmdiu->tag, status, sense);
+	fill_usb_request(req, bh->buf, UASP_SIZEOF_SENSE_IU, 0,
+		 (void *)cmdiu, 0, be16_to_cpup(&cmdiu->tag), status_complete);
+	cmdiu->ep = udev->status;
+
+	DBG(udev->ucommon->common, "%s() - Exit\n", __func__);
+	return 1;
 }
 
 /**
-- 
1.7.3.3

--
Sent by a Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum
