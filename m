Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948Ab1DAGlu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 02:41:50 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:50121 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754633Ab1DAGlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 02:41:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=m+/5mrWJ+RA7630j9XtyPiCjqru0ef/Zqy4YwgLEcG9T+FUCMjaJP1aHzOtxnHoyIO
         7FlGn7nmsQUe8UDDkhtkdoohyfpfauArSLk4cNKUgmS7emj9wmS+/ewmel8klV+uLpjQ
         9+WnaFNZOieX/TI8xZr9q03ruT6KsmojVYQ8k=
From: "Cho, Yu-Chen" <acho@novell.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, segooon@gmail.com, huajun.li.lee@gmail.com,
        kkatuev@gmail.com, devel@driverdev.osuosl.org, jlee@novell.com,
        acho@novell.com
Subject: [PATCH 5/5] staging/keucr: transport usb use pr_<level>
Date: Fri,  1 Apr 2011 14:38:43 +0800
Message-Id: <3a544f3da6dc655956c5decf69b6d6e0eac03979.1301638704.git.acho@novell.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1301638704.git.acho@novell.com>
References: <cover.1301638704.git.acho@novell.com>
In-Reply-To: <cover.1301638704.git.acho@novell.com>
References: <cover.1301638704.git.acho@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

transport.c usb.c use pr_<level> for messages

Signed-off-by: Cho, Yu-Chen <acho@novell.com>
---
 drivers/staging/keucr/transport.c |  140 +++++++++++++++++++-----------------
 drivers/staging/keucr/usb.c       |   88 ++++++++++++-----------
 2 files changed, 119 insertions(+), 109 deletions(-)

diff --git a/drivers/staging/keucr/transport.c b/drivers/staging/keucr/transport.c
index a53402f..0114276 100644
--- a/drivers/staging/keucr/transport.c
+++ b/drivers/staging/keucr/transport.c
@@ -1,3 +1,5 @@
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/sched.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
@@ -18,7 +20,7 @@ static void usb_stor_blocking_completion(struct urb *urb)
 {
 	struct completion *urb_done_ptr = urb->context;
 
-	//printk("transport --- usb_stor_blocking_completion\n");
+	/* pr_info("transport --- usb_stor_blocking_completion\n"); */
 	complete(urb_done_ptr);
 }
 
@@ -29,7 +31,7 @@ static int usb_stor_msg_common(struct us_data *us, int timeout)
 	long timeleft;
 	int status;
 
-	//printk("transport --- usb_stor_msg_common\n");
+	/* pr_info("transport --- usb_stor_msg_common\n"); */
 	if (test_bit(US_FLIDX_ABORTING, &us->dflags))
 		return -EIO;
 
@@ -56,7 +58,7 @@ static int usb_stor_msg_common(struct us_data *us, int timeout)
 	{
 		if (test_and_clear_bit(US_FLIDX_URB_ACTIVE, &us->dflags))
 		{
-			//printk("-- cancelling URB\n");
+			/* pr_info("-- cancelling URB\n"); */
 			usb_unlink_urb(us->current_urb);
 		}
 	}
@@ -66,7 +68,8 @@ static int usb_stor_msg_common(struct us_data *us, int timeout)
 
 	if (timeleft <= 0)
 	{
-		//printk("%s -- cancelling URB\n", timeleft == 0 ? "Timeout" : "Signal");
+		/* pr_info("%s -- cancelling URB\n",
+			timeleft == 0 ? "Timeout" : "Signal"); */
 		usb_kill_urb(us->current_urb);
 	}
 
@@ -80,7 +83,7 @@ int usb_stor_control_msg(struct us_data *us, unsigned int pipe,
 {
 	int status;
 
-	//printk("transport --- usb_stor_control_msg\n");
+	/* pr_info("transport --- usb_stor_control_msg\n"); */
 
 	/* fill in the devrequest structure */
 	us->cr->bRequestType = requesttype;
@@ -107,7 +110,7 @@ int usb_stor_clear_halt(struct us_data *us, unsigned int pipe)
 	int result;
 	int endp = usb_pipeendpoint(pipe);
 
-	//printk("transport --- usb_stor_clear_halt\n");
+	/* pr_info("transport --- usb_stor_clear_halt\n"); */
 	if (usb_pipein (pipe))
 		endp |= USB_DIR_IN;
 
@@ -128,41 +131,41 @@ int usb_stor_clear_halt(struct us_data *us, unsigned int pipe)
 static int interpret_urb_result(struct us_data *us, unsigned int pipe,
 		unsigned int length, int result, unsigned int partial)
 {
-	//printk("transport --- interpret_urb_result\n");
+	/* pr_info("transport --- interpret_urb_result\n"); */
 	switch (result) {
 	/* no error code; did we send all the data? */
 	case 0:
 		if (partial != length)
 		{
-			//printk("-- short transfer\n");
+			/* pr_info("-- short transfer\n"); */
 			return USB_STOR_XFER_SHORT;
 		}
-		//printk("-- transfer complete\n");
+		/* pr_info("-- transfer complete\n"); */
 		return USB_STOR_XFER_GOOD;
 	case -EPIPE:
 		if (usb_pipecontrol(pipe))
 		{
-			//printk("-- stall on control pipe\n");
+			/* pr_info("-- stall on control pipe\n"); */
 			return USB_STOR_XFER_STALLED;
 		}
-		//printk("clearing endpoint halt for pipe 0x%x\n", pipe);
+		/* pr_info("clearing endpoint halt for pipe 0x%x\n", pipe); */
 		if (usb_stor_clear_halt(us, pipe) < 0)
 			return USB_STOR_XFER_ERROR;
 		return USB_STOR_XFER_STALLED;
 	case -EOVERFLOW:
-		//printk("-- babble\n");
+		/* pr_info("-- babble\n"); */
 		return USB_STOR_XFER_LONG;
 	case -ECONNRESET:
-		//printk("-- transfer cancelled\n");
+		/* pr_info("-- transfer cancelled\n"); */
 		return USB_STOR_XFER_ERROR;
 	case -EREMOTEIO:
-		//printk("-- short read transfer\n");
+		/* pr_info("-- short read transfer\n"); */
 		return USB_STOR_XFER_SHORT;
 	case -EIO:
-		//printk("-- abort or disconnect in progress\n");
+		/* pr_info("-- abort or disconnect in progress\n"); */
 		return USB_STOR_XFER_ERROR;
 	default:
-		//printk("-- unknown error\n");
+		/* pr_info("-- unknown error\n"); */
 		return USB_STOR_XFER_ERROR;
 	}
 }
@@ -173,7 +176,7 @@ int usb_stor_bulk_transfer_buf(struct us_data *us, unsigned int pipe,
 {
 	int result;
 
-	//printk("transport --- usb_stor_bulk_transfer_buf\n");
+	/* pr_info("transport --- usb_stor_bulk_transfer_buf\n"); */
 
 	/* fill and submit the URB */
 	usb_fill_bulk_urb(us->current_urb, us->pusb_dev, pipe, buf, length, usb_stor_blocking_completion, NULL);
@@ -193,7 +196,7 @@ static int usb_stor_bulk_transfer_sglist(struct us_data *us, unsigned int pipe,
 {
 	int result;
 
-	//printk("transport --- usb_stor_bulk_transfer_sglist\n");
+	/* pr_info("transport --- usb_stor_bulk_transfer_sglist\n"); */
 	if (test_bit(US_FLIDX_ABORTING, &us->dflags))
 		return USB_STOR_XFER_ERROR;
 
@@ -201,7 +204,7 @@ static int usb_stor_bulk_transfer_sglist(struct us_data *us, unsigned int pipe,
 	result = usb_sg_init(&us->current_sg, us->pusb_dev, pipe, 0, sg, num_sg, length, GFP_NOIO);
 	if (result)
 	{
-		//printk("usb_sg_init returned %d\n", result);
+		/* pr_info("usb_sg_init returned %d\n", result); */
 		return USB_STOR_XFER_ERROR;
 	}
 
@@ -214,7 +217,7 @@ static int usb_stor_bulk_transfer_sglist(struct us_data *us, unsigned int pipe,
 		/* cancel the request, if it hasn't been cancelled already */
 		if (test_and_clear_bit(US_FLIDX_SG_ACTIVE, &us->dflags))
 		{
-			//printk("-- cancelling sg request\n");
+			/* pr_info("-- cancelling sg request\n"); */
 			usb_sg_cancel(&us->current_sg);
 		}
 	}
@@ -249,7 +252,7 @@ int usb_stor_bulk_transfer_sg(struct us_data* us, unsigned int pipe,
 	int result;
 	unsigned int partial;
 
-	//printk("transport --- usb_stor_bulk_transfer_sg\n");
+	/* pr_info("transport --- usb_stor_bulk_transfer_sg\n"); */
 	/* are we scatter-gathering? */
 	if (use_sg)
 	{
@@ -281,7 +284,7 @@ void usb_stor_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 	int need_auto_sense;
 	int result;
 
-	//printk("transport --- usb_stor_invoke_transport\n");
+	/* pr_info("transport --- usb_stor_invoke_transport\n"); */
 	usb_stor_print_cmd(srb);
 	/* send the command to the transport layer */
 	scsi_set_resid(srb, 0);
@@ -290,7 +293,7 @@ void usb_stor_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 	/* if the command gets aborted by the higher layers, we need to short-circuit all other processing */
 	if (test_bit(US_FLIDX_TIMED_OUT, &us->dflags))
 	{
-		//printk("-- command was aborted\n");
+		/* pr_info("-- command was aborted\n"); */
 		srb->result = DID_ABORT << 16;
 		goto Handle_Errors;
 	}
@@ -298,7 +301,7 @@ void usb_stor_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 	/* if there is a transport error, reset and don't auto-sense */
 	if (result == USB_STOR_TRANSPORT_ERROR)
 	{
-		//printk("-- transport indicates error, resetting\n");
+		/* pr_info("-- transport indicates error, resetting\n"); */
 		srb->result = DID_ERROR << 16;
 		goto Handle_Errors;
 	}
@@ -317,13 +320,13 @@ void usb_stor_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 
 	if ((us->protocol == USB_PR_CB || us->protocol == USB_PR_DPCM_USB) && srb->sc_data_direction != DMA_FROM_DEVICE)
 	{
-		//printk("-- CB transport device requiring auto-sense\n");
+		/* pr_info("-- CB transport device requiring auto-sense\n"); */
 		need_auto_sense = 1;
 	}
 
 	if (result == USB_STOR_TRANSPORT_FAILED)
 	{
-		//printk("-- transport indicates command failure\n");
+		/* pr_info("-- transport indicates command failure\n"); */
 		need_auto_sense = 1;
 	}
 
@@ -333,7 +336,7 @@ void usb_stor_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 		int temp_result;
 		struct scsi_eh_save ses;
 
-		printk("Issuing auto-REQUEST_SENSE\n");
+		pr_info("Issuing auto-REQUEST_SENSE\n");
 
 		scsi_eh_prep_cmnd(srb, &ses, NULL, 0, US_SENSE_SIZE);
 
@@ -352,13 +355,13 @@ void usb_stor_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 
 		if (test_bit(US_FLIDX_TIMED_OUT, &us->dflags))
 		{
-			//printk("-- auto-sense aborted\n");
+			/* pr_info("-- auto-sense aborted\n"); */
 			srb->result = DID_ABORT << 16;
 			goto Handle_Errors;
 		}
 		if (temp_result != USB_STOR_TRANSPORT_GOOD)
 		{
-			//printk("-- auto-sense failure\n");
+			/* pr_info("-- auto-sense failure\n"); */
 			srb->result = DID_ERROR << 16;
 			if (!(us->fflags & US_FL_SCM_MULT_TARG))
 				goto Handle_Errors;
@@ -409,7 +412,7 @@ void ENE_stor_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 {
 	int result=0;
 
-	//printk("transport --- ENE_stor_invoke_transport\n");
+	/* pr_info("transport --- ENE_stor_invoke_transport\n"); */
 	usb_stor_print_cmd(srb);
 	/* send the command to the transport layer */
 	scsi_set_resid(srb, 0);
@@ -427,7 +430,7 @@ void ENE_stor_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 	/* if the command gets aborted by the higher layers, we need to short-circuit all other processing */
 	if (test_bit(US_FLIDX_TIMED_OUT, &us->dflags))
 	{
-		//printk("-- command was aborted\n");
+		/* pr_info("-- command was aborted\n"); */
 		srb->result = DID_ABORT << 16;
 		goto Handle_Errors;
 	}
@@ -435,7 +438,7 @@ void ENE_stor_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 	/* if there is a transport error, reset and don't auto-sense */
 	if (result == USB_STOR_TRANSPORT_ERROR)
 	{
-		//printk("-- transport indicates error, resetting\n");
+		/* pr_info("-- transport indicates error, resetting\n"); */
 		srb->result = DID_ERROR << 16;
 		goto Handle_Errors;
 	}
@@ -450,7 +453,7 @@ void ENE_stor_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 	srb->result = SAM_STAT_GOOD;
 	if (result == USB_STOR_TRANSPORT_FAILED)
 	{
-		//printk("-- transport indicates command failure\n");
+		/* pr_info("-- transport indicates command failure\n"); */
 		//need_auto_sense = 1;
 		BuildSenseBuffer(srb, us->SrbStatus);
 		srb->result = SAM_STAT_CHECK_CONDITION;
@@ -488,7 +491,7 @@ void BuildSenseBuffer(struct scsi_cmnd *srb, int SrbStatus)
     BYTE    *buf = srb->sense_buffer;
     BYTE    asc;
 
-    printk("transport --- BuildSenseBuffer\n");
+	pr_info("transport --- BuildSenseBuffer\n");
     switch (SrbStatus)
     {
         case SS_NOT_READY:        asc = 0x3a;    break;  // sense key = 0x02
@@ -507,17 +510,17 @@ void BuildSenseBuffer(struct scsi_cmnd *srb, int SrbStatus)
 //----- usb_stor_stop_transport() ---------------------
 void usb_stor_stop_transport(struct us_data *us)
 {
-	//printk("transport --- usb_stor_stop_transport\n");
+	/* pr_info("transport --- usb_stor_stop_transport\n"); */
 
 	if (test_and_clear_bit(US_FLIDX_URB_ACTIVE, &us->dflags))
 	{
-		//printk("-- cancelling URB\n");
+		/* pr_info("-- cancelling URB\n"); */
 		usb_unlink_urb(us->current_urb);
 	}
 
 	if (test_and_clear_bit(US_FLIDX_SG_ACTIVE, &us->dflags))
 	{
-		//printk("-- cancelling sg request\n");
+		/* pr_info("-- cancelling sg request\n"); */
 		usb_sg_cancel(&us->current_sg);
 	}
 }
@@ -527,7 +530,7 @@ int usb_stor_Bulk_max_lun(struct us_data *us)
 {
 	int result;
 
-	//printk("transport --- usb_stor_Bulk_max_lun\n");
+	/* pr_info("transport --- usb_stor_Bulk_max_lun\n"); */
 	/* issue the command */
 	us->iobuf[0] = 0;
 	result = usb_stor_control_msg(us, us->recv_ctrl_pipe,
@@ -536,7 +539,8 @@ int usb_stor_Bulk_max_lun(struct us_data *us)
 				 USB_RECIP_INTERFACE,
 				 0, us->ifnum, us->iobuf, 1, HZ);
 
-	//printk("GetMaxLUN command result is %d, data is %d\n", result, us->iobuf[0]);
+	/* pr_info("GetMaxLUN command result is %d, data is %d\n",
+						result, us->iobuf[0]); */
 
 	/* if we have a successful request, return the result */
 	if (result > 0)
@@ -557,7 +561,7 @@ int usb_stor_Bulk_transport(struct scsi_cmnd *srb, struct us_data *us)
 	unsigned int cswlen;
 	unsigned int cbwlen = US_BULK_CB_WRAP_LEN;
 
-	//printk("transport --- usb_stor_Bulk_transport\n");
+	/* pr_info("transport --- usb_stor_Bulk_transport\n"); */
 	/* Take care of BULK32 devices; set extra byte to 0 */
 	if (unlikely(us->fflags & US_FL_BULK32))
 	{
@@ -581,13 +585,13 @@ int usb_stor_Bulk_transport(struct scsi_cmnd *srb, struct us_data *us)
 
 	// send command
 	/* send it to out endpoint */
-	/*printk("Bulk Command S 0x%x T 0x%x L %d F %d Trg %d LUN %d CL %d\n",
+	/* pr_info("Bulk Command S 0x%x T 0x%x L %d F %d Trg %d LUN %d CL %d\n",
 			le32_to_cpu(bcb->Signature), bcb->Tag,
 			le32_to_cpu(bcb->DataTransferLength), bcb->Flags,
 			(bcb->Lun >> 4), (bcb->Lun & 0x0F),
-			bcb->Length);*/
+			bcb->Length); */
 	result = usb_stor_bulk_transfer_buf(us, us->send_bulk_pipe, bcb, cbwlen, NULL);
-	//printk("Bulk command transfer result=%d\n", result);
+	/* pr_info("Bulk command transfer result=%d\n", result); */
 	if (result != USB_STOR_XFER_GOOD)
 		return USB_STOR_TRANSPORT_ERROR;
 
@@ -599,7 +603,7 @@ int usb_stor_Bulk_transport(struct scsi_cmnd *srb, struct us_data *us)
 	{
 		unsigned int pipe = srb->sc_data_direction == DMA_FROM_DEVICE ? us->recv_bulk_pipe : us->send_bulk_pipe;
 		result = usb_stor_bulk_srb(us, pipe, srb);
-		//printk("Bulk data transfer result 0x%x\n", result);
+		/* pr_info("Bulk data transfer result 0x%x\n", result); */
 		if (result == USB_STOR_XFER_ERROR)
 			return USB_STOR_TRANSPORT_ERROR;
 
@@ -608,12 +612,12 @@ int usb_stor_Bulk_transport(struct scsi_cmnd *srb, struct us_data *us)
 	}
 
 	/* get CSW for device status */
-	//printk("Attempting to get CSW...\n");
+	/* pr_info("Attempting to get CSW...\n"); */
 	result = usb_stor_bulk_transfer_buf(us, us->recv_bulk_pipe, bcs, US_BULK_CS_WRAP_LEN, &cswlen);
 
 	if (result == USB_STOR_XFER_SHORT && cswlen == 0)
 	{
-		//printk("Received 0-length CSW; retrying...\n");
+		/* pr_info("Received 0-length CSW; retrying...\n"); */
 		result = usb_stor_bulk_transfer_buf(us, us->recv_bulk_pipe, bcs, US_BULK_CS_WRAP_LEN, &cswlen);
 	}
 
@@ -621,21 +625,23 @@ int usb_stor_Bulk_transport(struct scsi_cmnd *srb, struct us_data *us)
 	if (result == USB_STOR_XFER_STALLED)
 	{
 		/* get the status again */
-		//printk("Attempting to get CSW (2nd try)...\n");
+		/* pr_info("Attempting to get CSW (2nd try)...\n"); */
 		result = usb_stor_bulk_transfer_buf(us, us->recv_bulk_pipe, bcs, US_BULK_CS_WRAP_LEN, NULL);
 	}
 
 	/* if we still have a failure at this point, we're in trouble */
-	//printk("Bulk status result = %d\n", result);
+	/* pr_info("Bulk status result = %d\n", result); */
 	if (result != USB_STOR_XFER_GOOD)
 		return USB_STOR_TRANSPORT_ERROR;
 
 	/* check bulk status */
 	residue = le32_to_cpu(bcs->Residue);
-	//printk("Bulk Status S 0x%x T 0x%x R %u Stat 0x%x\n", le32_to_cpu(bcs->Signature), bcs->Tag, residue, bcs->Status);
+	/* pr_info("Bulk Status S 0x%x T 0x%x R %u Stat 0x%x\n",
+				le32_to_cpu(bcs->Signature),
+				bcs->Tag, residue, bcs->Status); */
 	if (!(bcs->Tag == us->tag || (us->fflags & US_FL_BULK_IGNORE_TAG)) || bcs->Status > US_BULK_STAT_PHASE)
 	{
-		//printk("Bulk logical error\n");
+		/* pr_info("Bulk logical error\n"); */
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
@@ -643,13 +649,14 @@ int usb_stor_Bulk_transport(struct scsi_cmnd *srb, struct us_data *us)
 	{
 		us->bcs_signature = bcs->Signature;
 		//if (us->bcs_signature != cpu_to_le32(US_BULK_CS_SIGN))
-		//	printk("Learnt BCS signature 0x%08X\n", le32_to_cpu(us->bcs_signature));
+		/* pr_info("Learnt BCS signature 0x%08X\n",
+				le32_to_cpu(us->bcs_signature)); */
 	}
 	else if (bcs->Signature != us->bcs_signature)
 	{
-		/*printk("Signature mismatch: got %08X, expecting %08X\n",
+		/* pr_info("Signature mismatch: got %08X, expecting %08X\n",
 			  le32_to_cpu(bcs->Signature),
-			  le32_to_cpu(us->bcs_signature));*/
+			  le32_to_cpu(us->bcs_signature)); */
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
@@ -710,47 +717,47 @@ static int usb_stor_reset_common(struct us_data *us,
 	int result;
 	int result2;
 
-	//printk("transport --- usb_stor_reset_common\n");
+	/* pr_info("transport --- usb_stor_reset_common\n"); */
 	if (test_bit(US_FLIDX_DISCONNECTING, &us->dflags))
 	{
-		//printk("No reset during disconnect\n");
+		/* pr_info("No reset during disconnect\n"); */
 		return -EIO;
 	}
 
 	result = usb_stor_control_msg(us, us->send_ctrl_pipe, request, requesttype, value, index, data, size,	5*HZ);
 	if (result < 0)
 	{
-		//printk("Soft reset failed: %d\n", result);
+		/* pr_info("Soft reset failed: %d\n", result); */
 		return result;
 	}
 
 	wait_event_interruptible_timeout(us->delay_wait, test_bit(US_FLIDX_DISCONNECTING, &us->dflags),	HZ*6);
 	if (test_bit(US_FLIDX_DISCONNECTING, &us->dflags))
 	{
-		//printk("Reset interrupted by disconnect\n");
+		/* pr_info("Reset interrupted by disconnect\n"); */
 		return -EIO;
 	}
 
-	//printk("Soft reset: clearing bulk-in endpoint halt\n");
+	/* pr_info("Soft reset: clearing bulk-in endpoint halt\n"); */
 	result = usb_stor_clear_halt(us, us->recv_bulk_pipe);
 
-	//printk("Soft reset: clearing bulk-out endpoint halt\n");
+	/* pr_info("Soft reset: clearing bulk-out endpoint halt\n"); */
 	result2 = usb_stor_clear_halt(us, us->send_bulk_pipe);
 
 	/* return a result code based on the result of the clear-halts */
 	if (result >= 0)
 		result = result2;
 	//if (result < 0)
-	//	printk("Soft reset failed\n");
+		/* pr_info("Soft reset failed\n"); */
 	//else
-	//	printk("Soft reset done\n");
+		/* pr_info("Soft reset done\n"); */
 	return result;
 }
 
 //----- usb_stor_Bulk_reset() ---------------------
 int usb_stor_Bulk_reset(struct us_data *us)
 {
-	//printk("transport --- usb_stor_Bulk_reset\n");
+	/* pr_info("transport --- usb_stor_Bulk_reset\n"); */
 	return usb_stor_reset_common(us, US_BULK_RESET_REQUEST,
 				 USB_TYPE_CLASS | USB_RECIP_INTERFACE,
 				 0, us->ifnum, NULL, 0);
@@ -761,18 +768,19 @@ int usb_stor_port_reset(struct us_data *us)
 {
 	int result;
 
-	//printk("transport --- usb_stor_port_reset\n");
+	/* pr_info("transport --- usb_stor_port_reset\n"); */
 	result = usb_lock_device_for_reset(us->pusb_dev, us->pusb_intf);
 	if (result < 0)
-		printk("unable to lock device for reset: %d\n", result);
+		pr_info("unable to lock device for reset: %d\n", result);
 	else {
 		/* Were we disconnected while waiting for the lock? */
 		if (test_bit(US_FLIDX_DISCONNECTING, &us->dflags)) {
 			result = -EIO;
-			//printk("No reset during disconnect\n");
+			/* pr_info("No reset during disconnect\n"); */
 		} else {
 			result = usb_reset_device(us->pusb_dev);
-			//printk("usb_reset_composite_device returns %d\n", result);
+			/* pr_info("usb_reset_composite_device returns %d\n",
+								result); */
 		}
 		usb_unlock_device(us->pusb_dev);
 	}
diff --git a/drivers/staging/keucr/usb.c b/drivers/staging/keucr/usb.c
index 8c2332e..b0d1670 100644
--- a/drivers/staging/keucr/usb.c
+++ b/drivers/staging/keucr/usb.c
@@ -37,7 +37,7 @@ MODULE_DEVICE_TABLE (usb, eucr_usb_ids);
 int eucr_suspend(struct usb_interface *iface, pm_message_t message)
 {
 	struct us_data *us = usb_get_intfdata(iface);
-	printk("--- eucr_suspend ---\n");
+	pr_info("--- eucr_suspend ---\n");
 	/* Wait until no command is running */
 	mutex_lock(&us->dev_mutex);
 
@@ -60,7 +60,7 @@ int eucr_resume(struct usb_interface *iface)
 	BYTE    tmp = 0;
 
 	struct us_data *us = usb_get_intfdata(iface);
-	printk("--- eucr_resume---\n");
+	pr_info("--- eucr_resume---\n");
 	mutex_lock(&us->dev_mutex);
 
 	//US_DEBUGP("%s\n", __func__);
@@ -85,7 +85,7 @@ int eucr_reset_resume(struct usb_interface *iface)
 	BYTE    tmp = 0;
 	struct us_data *us = usb_get_intfdata(iface);
 
-	printk("--- eucr_reset_resume---\n");
+	pr_info("--- eucr_reset_resume---\n");
 	//US_DEBUGP("%s\n", __func__);
 
 	/* Report the reset to the SCSI core */
@@ -116,7 +116,7 @@ static int eucr_pre_reset(struct usb_interface *iface)
 {
 	struct us_data *us = usb_get_intfdata(iface);
 
-      printk("usb --- eucr_pre_reset\n");
+	pr_info("usb --- eucr_pre_reset\n");
 
 	/* Make sure no command runs during the reset */
 	mutex_lock(&us->dev_mutex);
@@ -128,7 +128,7 @@ static int eucr_post_reset(struct usb_interface *iface)
 {
 	struct us_data *us = usb_get_intfdata(iface);
 
-      printk("usb --- eucr_post_reset\n");
+	pr_info("usb --- eucr_post_reset\n");
 
 	/* Report the reset to the SCSI core */
 	usb_stor_report_bus_reset(us);
@@ -140,7 +140,7 @@ static int eucr_post_reset(struct usb_interface *iface)
 //----- fill_inquiry_response() ---------------------
 void fill_inquiry_response(struct us_data *us, unsigned char *data, unsigned int data_len)
 {
-      printk("usb --- fill_inquiry_response\n");
+	pr_info("usb --- fill_inquiry_response\n");
 	if (data_len<36) // You lose.
 		return;
 
@@ -171,7 +171,7 @@ static int usb_stor_control_thread(void * __us)
 	struct us_data *us = (struct us_data *)__us;
 	struct Scsi_Host *host = us_to_host(us);
 
-      printk("usb --- usb_stor_control_thread\n");
+	pr_info("usb --- usb_stor_control_thread\n");
 	for(;;)
 	{
 		if (wait_for_completion_interruptible(&us->cmnd_ready))
@@ -242,7 +242,7 @@ static int usb_stor_control_thread(void * __us)
 		else
 		{
 SkipForAbort:
-			printk("scsi command aborted\n");
+			pr_info("scsi command aborted\n");
 		}
 
 		if (test_bit(US_FLIDX_TIMED_OUT, &us->dflags))
@@ -277,7 +277,7 @@ SkipForAbort:
 //----- associate_dev() ---------------------
 static int associate_dev(struct us_data *us, struct usb_interface *intf)
 {
-      printk("usb --- associate_dev\n");
+	pr_info("usb --- associate_dev\n");
 
 	/* Fill in the device-related fields */
 	us->pusb_dev = interface_to_usbdev(intf);
@@ -291,21 +291,21 @@ static int associate_dev(struct us_data *us, struct usb_interface *intf)
 	us->cr = usb_alloc_coherent(us->pusb_dev, sizeof(*us->cr), GFP_KERNEL, &us->cr_dma);
 	if (!us->cr)
 	{
-		printk("usb_ctrlrequest allocation failed\n");
+		pr_info("usb_ctrlrequest allocation failed\n");
 		return -ENOMEM;
 	}
 
 	us->iobuf = usb_alloc_coherent(us->pusb_dev, US_IOBUF_SIZE, GFP_KERNEL, &us->iobuf_dma);
 	if (!us->iobuf)
 	{
-		printk("I/O buffer allocation failed\n");
+		pr_info("I/O buffer allocation failed\n");
 		return -ENOMEM;
 	}
 
 	us->sensebuf = kmalloc(US_SENSE_SIZE, GFP_KERNEL);
 	if (!us->sensebuf)
 	{
-		printk("Sense buffer allocation failed\n");
+		pr_info("Sense buffer allocation failed\n");
 		return -ENOMEM;
 	}
 	return 0;
@@ -317,7 +317,7 @@ static int get_device_info(struct us_data *us, const struct usb_device_id *id)
 	struct usb_device *dev = us->pusb_dev;
 	struct usb_interface_descriptor *idesc = &us->pusb_intf->cur_altsetting->desc;
 
-      printk("usb --- get_device_info\n");
+	pr_info("usb --- get_device_info\n");
 
 	us->subclass = idesc->bInterfaceSubClass;
 	us->protocol = idesc->bInterfaceProtocol;
@@ -326,7 +326,7 @@ static int get_device_info(struct us_data *us, const struct usb_device_id *id)
 
 	if (us->fflags & US_FL_IGNORE_DEVICE)
 	{
-		printk("device ignored\n");
+		pr_info("device ignored\n");
 		return -ENODEV;
 	}
 
@@ -339,7 +339,7 @@ static int get_device_info(struct us_data *us, const struct usb_device_id *id)
 //----- get_transport() ---------------------
 static int get_transport(struct us_data *us)
 {
-      printk("usb --- get_transport\n");
+	pr_info("usb --- get_transport\n");
 	switch (us->protocol) {
 	case USB_PR_BULK:
 		us->transport_name = "Bulk";
@@ -350,7 +350,7 @@ static int get_transport(struct us_data *us)
 	default:
 		return -EIO;
 	}
-	//printk("Transport: %s\n", us->transport_name);
+	/* pr_info("Transport: %s\n", us->transport_name); */
 
 	/* fix for single-lun devices */
 	if (us->fflags & US_FL_SINGLE_LUN)
@@ -361,9 +361,11 @@ static int get_transport(struct us_data *us)
 //----- get_protocol() ---------------------
 static int get_protocol(struct us_data *us)
 {
-      printk("usb --- get_protocol\n");
-	printk("us->pusb_dev->descriptor.idVendor = %x\n", us->pusb_dev->descriptor.idVendor);
-	printk("us->pusb_dev->descriptor.idProduct = %x\n", us->pusb_dev->descriptor.idProduct);
+	pr_info("usb --- get_protocol\n");
+	pr_info("us->pusb_dev->descriptor.idVendor = %x\n",
+			us->pusb_dev->descriptor.idVendor);
+	pr_info("us->pusb_dev->descriptor.idProduct = %x\n",
+			us->pusb_dev->descriptor.idProduct);
 	switch (us->subclass) {
 	case USB_SC_SCSI:
 		us->protocol_name = "Transparent SCSI";
@@ -376,7 +378,7 @@ static int get_protocol(struct us_data *us)
 	default:
 		return -EIO;
 	}
-	//printk("Protocol: %s\n", us->protocol_name);
+	/* pr_info("Protocol: %s\n", us->protocol_name); */
 	return 0;
 }
 
@@ -390,7 +392,7 @@ static int get_pipes(struct us_data *us)
 	struct usb_endpoint_descriptor *ep_out = NULL;
 	struct usb_endpoint_descriptor *ep_int = NULL;
 
-      printk("usb --- get_pipes\n");
+	pr_info("usb --- get_pipes\n");
 
 	for (i = 0; i < altsetting->desc.bNumEndpoints; i++)
 	{
@@ -418,7 +420,7 @@ static int get_pipes(struct us_data *us)
 
 	if (!ep_in || !ep_out || (us->protocol == USB_PR_CBI && !ep_int))
 	{
-		printk("Endpoint sanity check failed! Rejecting dev.\n");
+		pr_info("Endpoint sanity check failed! Rejecting dev.\n");
 		return -EIO;
 	}
 
@@ -440,11 +442,11 @@ static int usb_stor_acquire_resources(struct us_data *us)
 {
 	struct task_struct *th;
 
-      printk("usb --- usb_stor_acquire_resources\n");
+	pr_info("usb --- usb_stor_acquire_resources\n");
 	us->current_urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (!us->current_urb)
 	{
-		printk("URB allocation failed\n");
+		pr_info("URB allocation failed\n");
 		return -ENOMEM;
 	}
 
@@ -452,7 +454,7 @@ static int usb_stor_acquire_resources(struct us_data *us)
 	th = kthread_run(usb_stor_control_thread, us, "eucr-storage");
 	if (IS_ERR(th))
 	{
-		printk("Unable to start control thread\n");
+		pr_info("Unable to start control thread\n");
 		return PTR_ERR(th);
 	}
 	us->ctl_thread = th;
@@ -463,7 +465,7 @@ static int usb_stor_acquire_resources(struct us_data *us)
 //----- usb_stor_release_resources() ---------------------
 static void usb_stor_release_resources(struct us_data *us)
 {
-	printk("usb --- usb_stor_release_resources\n");
+	pr_info("usb --- usb_stor_release_resources\n");
 
 	SM_FreeMem();
 
@@ -474,7 +476,7 @@ static void usb_stor_release_resources(struct us_data *us)
 	/* Call the destructor routine, if it exists */
 	if (us->extra_destructor)
 	{
-		printk("-- calling extra_destructor()\n");
+		pr_info("-- calling extra_destructor()\n");
 		us->extra_destructor(us->extra);
 	}
 
@@ -486,7 +488,7 @@ static void usb_stor_release_resources(struct us_data *us)
 //----- dissociate_dev() ---------------------
 static void dissociate_dev(struct us_data *us)
 {
-      printk("usb --- dissociate_dev\n");
+	pr_info("usb --- dissociate_dev\n");
 
 	kfree(us->sensebuf);
 
@@ -505,7 +507,7 @@ static void quiesce_and_remove_host(struct us_data *us)
 {
 	struct Scsi_Host *host = us_to_host(us);
 
-      printk("usb --- quiesce_and_remove_host\n");
+	pr_info("usb --- quiesce_and_remove_host\n");
 
 	/* If the device is really gone, cut short reset delays */
 	if (us->pusb_dev->state == USB_STATE_NOTATTACHED)
@@ -535,7 +537,7 @@ static void quiesce_and_remove_host(struct us_data *us)
 //----- release_everything() ---------------------
 static void release_everything(struct us_data *us)
 {
-      printk("usb --- release_everything\n");
+	pr_info("usb --- release_everything\n");
 
 	usb_stor_release_resources(us);
 	dissociate_dev(us);
@@ -547,8 +549,8 @@ static int usb_stor_scan_thread(void * __us)
 {
 	struct us_data *us = (struct us_data *)__us;
 
-      printk("usb --- usb_stor_scan_thread\n");
-	printk("EUCR : device found at %d\n", us->pusb_dev->devnum);
+	pr_info("usb --- usb_stor_scan_thread\n");
+	pr_info("EUCR : device found at %d\n", us->pusb_dev->devnum);
 
 	set_freezable();
 	/* Wait for the timeout to expire or for a disconnect */
@@ -569,7 +571,7 @@ static int usb_stor_scan_thread(void * __us)
 			mutex_unlock(&us->dev_mutex);
 		}
 		scsi_scan_host(us_to_host(us));
-		printk("EUCR : device scan complete\n");
+		pr_info("EUCR : device scan complete\n");
 	}
 	complete_and_exit(&us->scanning_done, 0);
 }
@@ -583,12 +585,12 @@ static int eucr_probe(struct usb_interface *intf, const struct usb_device_id *id
 	BYTE	MiscReg03 = 0;
 	struct task_struct *th;
 
-      printk("usb --- eucr_probe\n");
+	pr_info("usb --- eucr_probe\n");
 
       host = scsi_host_alloc(&usb_stor_host_template, sizeof(*us));
 	if (!host)
 	{
-		printk("Unable to allocate the scsi host\n");
+		pr_info("Unable to allocate the scsi host\n");
 		return -ENOMEM;
 	}
 
@@ -631,7 +633,7 @@ static int eucr_probe(struct usb_interface *intf, const struct usb_device_id *id
 	result = scsi_add_host(host, &intf->dev);
 	if (result)
 	{
-		printk("Unable to add the scsi host\n");
+		pr_info("Unable to add the scsi host\n");
 		goto BadDevice;
 	}
 
@@ -639,7 +641,7 @@ static int eucr_probe(struct usb_interface *intf, const struct usb_device_id *id
 	th = kthread_create(usb_stor_scan_thread, us, "eucr-stor-scan");
 	if (IS_ERR(th))
 	{
-		printk("Unable to start the device-scanning thread\n");
+		pr_info("Unable to start the device-scanning thread\n");
 		complete(&us->scanning_done);
 		quiesce_and_remove_host(us);
 		result = PTR_ERR(th);
@@ -658,7 +660,7 @@ static int eucr_probe(struct usb_interface *intf, const struct usb_device_id *id
 	if (!(MiscReg03 & 0x02)) {
 		result = -ENODEV;
 		quiesce_and_remove_host(us);
-		printk(KERN_NOTICE "keucr: The driver only supports SM/MS card.\
+		pr_info("keucr: The driver only supports SM/MS card.\
 			To use SD card, \
 			please build driver/usb/storage/ums-eneub6250.ko\n");
 		goto BadDevice;
@@ -668,7 +670,7 @@ static int eucr_probe(struct usb_interface *intf, const struct usb_device_id *id
 
 	/* We come here if there are any problems */
 BadDevice:
-      printk("usb --- eucr_probe failed\n");
+	pr_info("usb --- eucr_probe failed\n");
 	release_everything(us);
 	return result;
 }
@@ -678,7 +680,7 @@ static void eucr_disconnect(struct usb_interface *intf)
 {
 	struct us_data *us = usb_get_intfdata(intf);
 
-      printk("usb --- eucr_disconnect\n");
+	pr_info("usb --- eucr_disconnect\n");
 	quiesce_and_remove_host(us);
 	release_everything(us);
 }
@@ -705,11 +707,11 @@ static struct usb_driver usb_storage_driver = {
 static int __init usb_stor_init(void)
 {
 	int retval;
-      printk("usb --- usb_stor_init start\n");
+	pr_info("usb --- usb_stor_init start\n");
 
 	retval = usb_register(&usb_storage_driver);
 	if (retval == 0)
-            printk("ENE USB Mass Storage support registered.\n");
+		pr_info("ENE USB Mass Storage support registered.\n");
 
 	return retval;
 }
@@ -717,7 +719,7 @@ static int __init usb_stor_init(void)
 //----- usb_stor_exit() ---------------------
 static void __exit usb_stor_exit(void)
 {
-      printk("usb --- usb_stor_exit\n");
+	pr_info("usb --- usb_stor_exit\n");
 
 	usb_deregister(&usb_storage_driver) ;
 }
-- 
1.7.1

