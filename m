Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484Ab0JVXy1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 19:54:27 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60658 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755021Ab0JVXyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 19:54:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=K1gB+SFeWnvyoRwXnx/RNV+nk2RqblGfA3kBU7iYKFNubQvO2RnbRLOhVvJBs6xs4b
         nsFfPPzkrAwFaGhzhpZbn4M/8vahRn5dnHJ+AgnszAvn/P031ZziBPOj7Ofm9oMdA3UN
         V64SuRkdLCY+U0L2xO5UKjHj6/m/FMMNtcNfY=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 09/29] memstick: rework state machines + attribute read function
Date: Sat, 23 Oct 2010 01:53:37 +0200
Message-Id: <1287791637-10329-10-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287791637-10329-1-git-send-email-maximlevitsky@gmail.com>
References: <1287791637-10329-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Code is rewritten to use new style of state machines.
Attribute read function is cleaned up and commented sparsely.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/memstick/core/mspro_block.c |  570 +++++++++++++++++------------------
 drivers/memstick/core/mspro_block.h |   67 +++--
 2 files changed, 319 insertions(+), 318 deletions(-)

diff --git a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/mspro_block.c
index a7f263d..cf98fa8 100644
--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -385,14 +385,9 @@ static int h_mspro_block_req_init(struct memstick_dev *card,
 static int h_mspro_block_default(struct memstick_dev *card,
 				 struct memstick_request **mrq)
 {
-	return mspro_block_complete_req(card, (*mrq)->error);
+	return memstick_exit_state_machine(card, *mrq, (*mrq)->error);
 }
 
-static int h_mspro_block_default_bad(struct memstick_dev *card,
-				     struct memstick_request **mrq)
-{
-	return -ENXIO;
-}
 
 static int h_mspro_block_get_ro(struct memstick_dev *card,
 				struct memstick_request **mrq)
@@ -407,7 +402,7 @@ static int h_mspro_block_get_ro(struct memstick_dev *card,
 			msb->read_only = 0;
 	}
 
-	return mspro_block_complete_req(card, (*mrq)->error);
+	return memstick_exit_state_machine(card, *mrq, (*mrq)->error);
 }
 
 static int h_mspro_block_wait_for_ced(struct memstick_dev *card,
@@ -422,95 +417,146 @@ static int h_mspro_block_wait_for_ced(struct memstick_dev *card,
 			return 0;
 	}
 
-	return mspro_block_complete_req(card, (*mrq)->error);
+	return memstick_exit_state_machine(card, *mrq, (*mrq)->error);
 }
 
 static int h_mspro_block_transfer_data(struct memstick_dev *card,
 				       struct memstick_request **mrq)
 {
 	struct mspro_block_data *msb = memstick_get_drvdata(card);
-	unsigned char t_val = 0;
+	unsigned char intreg = 0, command;
 	struct scatterlist t_sg = { 0 };
+	unsigned long flags;
+	int error;
 	size_t t_offset;
 
-	if ((*mrq)->error)
-		return mspro_block_complete_req(card, (*mrq)->error);
+	memstick_allocate_request(card, mrq);
 
-	switch ((*mrq)->tpc) {
-	case MS_TPC_WRITE_REG:
-		memstick_init_req(*mrq, MS_TPC_SET_CMD, &msb->transfer_cmd, 1);
-		(*mrq)->need_card_int = 1;
-		return 0;
-	case MS_TPC_SET_CMD:
-		t_val = (*mrq)->int_reg;
-		memstick_init_req(*mrq, MS_TPC_GET_INT, NULL, 1);
-		if (msb->caps & MEMSTICK_CAP_AUTO_GET_INT)
-			goto has_int_reg;
-		return 0;
-	case MS_TPC_GET_INT:
-		t_val = (*mrq)->data[0];
-has_int_reg:
-		if (t_val & (MEMSTICK_INT_CMDNAK | MEMSTICK_INT_ERR)) {
-			t_val = MSPRO_CMD_STOP;
-			memstick_init_req(*mrq, MS_TPC_SET_CMD, &t_val, 1);
-			card->next_request = h_mspro_block_default;
+	if ((*mrq)->error) {
+		dbg(card, "IO: error (%d) executing %s", (*mrq)->error,
+			memstick_debug_get_tpc_name((*mrq)->tpc));
+
+		if (!msb->io_error) {
+			msb->io_error = (*mrq)->error;
+			card->state = 6;
+		}
+	}
+again:
+	switch (card->state) {
+
+	case 0: /* send read/write command + args */
+		if (!memstick_write_regs(card,
+			offsetof(struct mspro_register, param),
+			sizeof(struct mspro_param_register),
+			(unsigned char *)&msb->arg, *mrq))
 			return 0;
+		break;
+	case 1:
+		memstick_init_req(*mrq, MS_TPC_SET_CMD,
+					&msb->transfer_cmd, 1);
+		break;
+
+	case 2: /* read the INT register */
+		if (memstick_read_int_reg(card, *mrq, -1))
+			break;
+		card->state++;
+
+	case 3: /* process the int register */
+		intreg = (*mrq)->data[0];
+
+		if (intreg & (MEMSTICK_INT_CMDNAK | MEMSTICK_INT_ERR)) {
+			dbg(card, "IO: card I/O error");
+			card->state = 6;
+			msb->io_error = -EIO;
+			goto again;
 		}
 
-		if (msb->current_page
-		    == (msb->req_sg[msb->current_seg].length
-			/ msb->page_size)) {
-			msb->current_page = 0;
-			msb->current_seg++;
-
-			if (msb->current_seg == msb->seg_count) {
-				if (t_val & MEMSTICK_INT_CED) {
-					return mspro_block_complete_req(card,
-									0);
-				} else {
-					card->next_request
-						= h_mspro_block_wait_for_ced;
-					memstick_init_req(*mrq, MS_TPC_GET_INT,
-							  NULL, 1);
-					return 0;
-				}
+		/* we need CED for last page */
+		if (!msb->current_sg) {
+			if (!(intreg & MEMSTICK_INT_CED)) {
+				card->state--;
+				goto again;
 			}
+
+			memstick_read_int_reg_cleanup(card);
+			card->state = 7;
+			goto again;
 		}
 
-		if (!(t_val & MEMSTICK_INT_BREQ)) {
-			memstick_init_req(*mrq, MS_TPC_GET_INT, NULL, 1);
-			return 0;
+		/* And BREQ for non last... */
+		if (!(intreg & MEMSTICK_INT_BREQ)) {
+			card->state--;
+			goto again;
 		}
 
-		t_offset = msb->req_sg[msb->current_seg].offset;
-		t_offset += msb->current_page * msb->page_size;
+		memstick_read_int_reg_cleanup(card);
+		card->state++;
+
+	case 4: /* init transfer of the data */
+		t_offset = msb->current_sg->offset + msb->current_sg_offset;
 
 		sg_init_table(&t_sg, 1);
-		sg_set_page(&t_sg,
-			    nth_page(sg_page(&(msb->req_sg[msb->current_seg])),
-				     t_offset >> PAGE_SHIFT),
-			    msb->page_size, offset_in_page(t_offset));
-
-		memstick_init_req_sg(*mrq, msb->data_dir == READ
-					   ? MS_TPC_READ_LONG_DATA
-					   : MS_TPC_WRITE_LONG_DATA,
-				     &t_sg);
+		sg_set_page(&t_sg, nth_page(sg_page(msb->current_sg),
+			t_offset >> PAGE_SHIFT), msb->page_size,
+			offset_in_page(t_offset));
+
+		memstick_init_req_sg(*mrq, msb->data_dir == READ ?
+			MS_TPC_READ_LONG_DATA : MS_TPC_WRITE_LONG_DATA, &t_sg);
 		(*mrq)->need_card_int = 1;
-		return 0;
-	case MS_TPC_READ_LONG_DATA:
-	case MS_TPC_WRITE_LONG_DATA:
-		msb->current_page++;
-		if (msb->caps & MEMSTICK_CAP_AUTO_GET_INT) {
-			t_val = (*mrq)->int_reg;
-			goto has_int_reg;
-		} else {
-			memstick_init_req(*mrq, MS_TPC_GET_INT, NULL, 1);
-			return 0;
+		break;
+
+	case 5: /* switch to next page */
+		msb->current_sg_offset += msb->page_size;
+		msb->data_transferred += msb->page_size;
+
+		if (msb->current_sg_offset == msb->current_sg->length) {
+			msb->current_sg_offset = 0;
+			msb->current_sg = sg_next(msb->current_sg);
 		}
 
+		card->state = 2;
+		goto again;
+
+	case 6: /* after a error send STOP command */
+		command = MSPRO_CMD_STOP;
+		memstick_init_req(*mrq, MS_TPC_SET_CMD, &command, 1);
+		break;
+
+	case 7: /* request complete - get next one*/
+		spin_lock_irqsave(&msb->q_lock, flags);
+
+		if (msb->io_error)
+			(*mrq)->error = msb->io_error;
+
+		if (msb->block_req) {
+			mspro_block_complete_req(card, (*mrq)->error);
+			error = mspro_block_issue_req(card, false);
+
+			if (!msb->block_req) {
+				dbg_v(card, "IO: out of requests");
+				error = memstick_exit_state_machine(
+						card, *mrq, (*mrq)->error);
+				spin_unlock_irqrestore(&msb->q_lock, flags);
+				return error;
+			}
+
+			spin_unlock_irqrestore(&msb->q_lock, flags);
+			(*mrq)->error = 0;
+			card->state = 0;
+			goto again;
+
+		} else {
+			error = memstick_exit_state_machine(card,
+							*mrq, (*mrq)->error);
+			spin_unlock_irqrestore(&msb->q_lock, flags);
+			return error;
+		}
 	default:
 		BUG();
 	}
+
+	card->state++;
+	return 0;
 }
 
 /*** Data transfer ***/
@@ -519,64 +565,62 @@ has_int_reg:
  * Start execution of next block request,
  * or continue execution of the current one
  */
-static int mspro_block_issue_req(struct memstick_dev *card, int chunk)
+static int mspro_block_issue_req(struct memstick_dev *card, bool first)
 {
 	struct mspro_block_data *msb = memstick_get_drvdata(card);
-	sector_t t_sec;
-	unsigned int count;
-	struct mspro_param_register param;
-
-try_again:
-	while (chunk) {
-		msb->current_page = 0;
-		msb->current_seg = 0;
-		msb->seg_count = blk_rq_map_sg(msb->block_req->q,
-					       msb->block_req,
-					       msb->req_sg);
-
-		if (!msb->seg_count) {
-			chunk = __blk_end_request_cur(msb->block_req, -ENOMEM);
-			continue;
+	sector_t sec;
+	bool is_read;
+	unsigned int pages;
+again:
+	/* get next request from block core if we don't have one */
+	if (!msb->block_req) {
+		dbg(card, "IO: fetching new request from block queue");
+		msb->block_req = blk_fetch_request(msb->queue);
+		if (!msb->block_req) {
+			dbg(card, "IO: failed, because queue is empty");
+			return -ENXIO;
 		}
+	}
 
-		t_sec = blk_rq_pos(msb->block_req) << 9;
-		sector_div(t_sec, msb->page_size);
+	if (msb->eject) {
+		dbg(card, "IO: Refusing request, because card is removed");
+		__blk_end_request_all(msb->block_req, -ENODEV);
+		msb->block_req = NULL;
+		goto again;
+	}
 
-		count = blk_rq_bytes(msb->block_req);
-		count /= msb->page_size;
+	sec = blk_rq_pos(msb->block_req) << 9;
+	sector_div(sec, msb->page_size);
+	pages = blk_rq_bytes(msb->block_req) / msb->page_size;
 
-		param.system = msb->system;
-		param.data_count = cpu_to_be16(count);
-		param.data_address = cpu_to_be32((uint32_t)t_sec);
-		param.tpc_param = 0;
+	if (!blk_rq_map_sg(msb->block_req->q, msb->block_req, msb->req_sg)) {
+		dbg(card, "IO: out of memory");
+		if (!__blk_end_request_cur(msb->block_req, -ENOMEM))
+			msb->block_req = NULL;
+		goto again;
+	}
 
-		msb->data_dir = rq_data_dir(msb->block_req);
-		msb->transfer_cmd = msb->data_dir == READ
-				    ? MSPRO_CMD_READ_DATA
-				    : MSPRO_CMD_WRITE_DATA;
+	is_read = rq_data_dir(msb->block_req) == READ;
 
-		dev_dbg(&card->dev, "data transfer: cmd %x, "
-			"lba %x, count %x\n", msb->transfer_cmd,
-			be32_to_cpu(param.data_address), count);
+	msb->current_sg_offset = 0;
+	msb->current_sg = msb->req_sg;
+	msb->data_transferred = 0;
+	msb->io_error = 0;
 
-		card->next_request = h_mspro_block_req_init;
-		msb->mrq_handler = h_mspro_block_transfer_data;
-		memstick_init_req(&card->current_mrq, MS_TPC_WRITE_REG,
-				  &param, sizeof(param));
-		memstick_new_req(card->host);
-		return 0;
-	}
+	msb->transfer_cmd = is_read ?
+				MSPRO_CMD_READ_DATA :MSPRO_CMD_WRITE_DATA;
 
-	dev_dbg(&card->dev, "blk_fetch\n");
-	msb->block_req = blk_fetch_request(msb->queue);
-	if (!msb->block_req) {
-		dev_dbg(&card->dev, "issue end\n");
-		return -EAGAIN;
-	}
+	msb->arg.system = msb->system;
+	msb->arg.data_count = cpu_to_be16(pages);
+	msb->arg.data_address = cpu_to_be32(sec);
+	msb->data_dir = rq_data_dir(msb->block_req);
 
-	dev_dbg(&card->dev, "trying again\n");
-	chunk = 1;
-	goto try_again;
+	dbg(card, "IO: %s: lba %x, pages %x", is_read ? "read" : "write",
+					(unsigned int)sec, pages);
+	if (first)
+		memstick_run_state_machine(card,
+			h_mspro_block_transfer_data, false);
+	return 0;
 }
 
 /*
@@ -584,59 +628,23 @@ try_again:
  *  After execution of this function, the msb->block_req might or might not
  *  be NULL. If it is, it means we don't have any more requests to process
  */
-static int mspro_block_complete_req(struct memstick_dev *card, int error)
+static void mspro_block_complete_req(struct memstick_dev *card, int error)
 {
 	struct mspro_block_data *msb = memstick_get_drvdata(card);
-	int chunk, cnt;
-	unsigned int t_len = 0;
-	unsigned long flags;
 
-	spin_lock_irqsave(&msb->q_lock, flags);
-	dev_dbg(&card->dev, "complete %d, %d\n", msb->has_request ? 1 : 0,
-		error);
-
-	if (msb->has_request) {
-		/* Nothing to do - not really an error */
-		if (error == -EAGAIN)
-			error = 0;
-
-		if (error || (card->current_mrq.tpc == MSPRO_CMD_STOP)) {
-			if (msb->data_dir == READ) {
-				for (cnt = 0; cnt < msb->current_seg; cnt++)
-					t_len += msb->req_sg[cnt].length
-						 / msb->page_size;
-
-					if (msb->current_page)
-						t_len += msb->current_page - 1;
-
-					t_len *= msb->page_size;
-			}
-		} else
-			t_len = blk_rq_bytes(msb->block_req);
-
-		dev_dbg(&card->dev, "transferred %x (%d)\n", t_len, error);
+	dbg(card, "IO: transferred %d bytes ", msb->data_transferred);
 
-		if (error && !t_len)
-			t_len = blk_rq_cur_bytes(msb->block_req);
-
-		chunk = __blk_end_request(msb->block_req, error, t_len);
-
-		error = mspro_block_issue_req(card, chunk);
-
-		if (!error)
-			goto out;
-		else
-			msb->has_request = 0;
-	} else {
-		if (!error)
-			error = -EAGAIN;
+	if (msb->data_transferred) {
+		if (!__blk_end_request(msb->block_req, 0,
+						msb->data_transferred))
+			msb->block_req = NULL;
 	}
 
-	card->next_request = h_mspro_block_default_bad;
-	complete_all(&card->mrq_complete);
-out:
-	spin_unlock_irqrestore(&msb->q_lock, flags);
-	return error;
+	if (error && msb->block_req) {
+		dbg(card, "IO: failure (%d) of transfter of one sector", error);
+		if (!__blk_end_request(msb->block_req, 0, msb->page_size))
+			msb->block_req = NULL;
+	}
 }
 
 /*
@@ -651,7 +659,7 @@ static void mspro_block_stop(struct memstick_dev *card)
 
 	while (1) {
 		spin_lock_irqsave(&msb->q_lock, flags);
-		if (!msb->has_request) {
+		if (!msb->block_req) {
 			blk_stop_queue(msb->queue);
 			rc = 1;
 		}
@@ -692,21 +700,18 @@ static void mspro_block_submit_req(struct request_queue *q)
 {
 	struct memstick_dev *card = q->queuedata;
 	struct mspro_block_data *msb = memstick_get_drvdata(card);
-	struct request *req = NULL;
-
-	if (msb->has_request)
-		return;
-
-	if (msb->eject) {
-		while ((req = blk_fetch_request(q)) != NULL)
-			__blk_end_request_all(req, -ENODEV);
+	int error;
 
+	if (msb->block_req) {
+		dbg_v(card,
+			"IO: block layer submits request, while we have one");
 		return;
 	}
 
-	msb->has_request = 1;
-	if (mspro_block_issue_req(card, 0))
-		msb->has_request = 0;
+	dbg(card, "IO: block layer wakes us up for request processing");
+
+	error = mspro_block_issue_req(card, true);
+	WARN_ON(error && msb->block_req != NULL);
 }
 
 /*** Initialization ***/
@@ -820,6 +825,29 @@ try_again:
 	return rc;
 }
 
+/* Read data from attribute space */
+static int mspro_block_read_attribute(struct memstick_dev *card,
+					int offset, void *buffer, int len)
+{
+	struct mspro_block_data *msb = memstick_get_drvdata(card);
+
+	dbg(card, "reading attribute space at offset %08x, size %d",
+								offset, len);
+	sg_init_one(&msb->req_sg[0], buffer, len);
+	msb->current_sg_offset = 0;
+	msb->current_sg = msb->req_sg;
+	msb->data_transferred = 0;
+	msb->io_error = 0;
+	msb->transfer_cmd = MSPRO_CMD_READ_ATRB;
+	msb->arg.system = msb->system;
+	msb->arg.data_count = cpu_to_be16(len / msb->page_size);
+	msb->arg.data_address = cpu_to_be32(offset / msb->page_size);
+	msb->data_dir = READ;
+
+	return memstick_run_state_machine(card,
+					h_mspro_block_transfer_data, true);
+}
+
 /* Memory allocated for attributes by this function should be freed by
  * mspro_block_data_clear, no matter if the initialization process succeded
  * or failed.
@@ -827,85 +855,71 @@ try_again:
 static int mspro_block_read_attributes(struct memstick_dev *card)
 {
 	struct mspro_block_data *msb = memstick_get_drvdata(card);
-	struct mspro_param_register param = {
-		.system = msb->system,
-		.data_count = cpu_to_be16(1),
-		.data_address = 0,
-		.tpc_param = 0
-	};
 	struct mspro_attribute *attr = NULL;
 	struct mspro_sys_attr *s_attr = NULL;
+
 	unsigned char *buffer = NULL;
-	int cnt, rc, attr_count;
-	unsigned int addr;
-	unsigned short page_count;
+	unsigned int buffer_size, new_buffer_size, buffer_address = 0;
+	unsigned int attr_size, attr_addr, attr_page_offset;
 
-	attr = kmalloc(msb->page_size, GFP_KERNEL);
-	if (!attr)
+	int cnt, error, attr_count;
+
+	/* Allocate initial buffer */
+	buffer_size = msb->page_size;
+	buffer_address = 0;
+	buffer = kmalloc(buffer_size, GFP_KERNEL);
+	if (!buffer)
 		return -ENOMEM;
 
-	sg_init_one(&msb->req_sg[0], attr, msb->page_size);
-	msb->seg_count = 1;
-	msb->current_seg = 0;
-	msb->current_page = 0;
-	msb->data_dir = READ;
-	msb->transfer_cmd = MSPRO_CMD_READ_ATRB;
+	/* Read the attribute list */
+	error = mspro_block_read_attribute(card, 0, buffer, buffer_size);
+	if (error)
+		goto out_free_buffer;
+
+	attr = kmalloc(buffer_size, GFP_KERNEL);
+	if (!attr)
+		goto out_free_buffer;
+	memcpy(attr, buffer, buffer_size);
 
-	card->next_request = h_mspro_block_req_init;
-	msb->mrq_handler = h_mspro_block_transfer_data;
-	memstick_init_req(&card->current_mrq, MS_TPC_WRITE_REG, &param,
-			  sizeof(param));
-	memstick_new_req(card->host);
-	wait_for_completion(&card->mrq_complete);
-	if (card->current_mrq.error) {
-		rc = card->current_mrq.error;
-		goto out_free_attr;
-	}
 
+	/* Test it for sanity */
 	if (be16_to_cpu(attr->signature) != MSPRO_BLOCK_SIGNATURE) {
 		printk(KERN_ERR "%s: unrecognized device signature %x\n",
 		       dev_name(&card->dev), be16_to_cpu(attr->signature));
-		rc = -ENODEV;
-		goto out_free_attr;
+		error = -ENODEV;
+		goto out_free_buffer;
 	}
 
-	if (attr->count > MSPRO_BLOCK_MAX_ATTRIBUTES) {
+	if (attr->count > MSPRO_BLOCK_MAX_ATTRIBUTES)
 		printk(KERN_WARNING "%s: way too many attribute entries\n",
 		       dev_name(&card->dev));
-		attr_count = MSPRO_BLOCK_MAX_ATTRIBUTES;
-	} else
-		attr_count = attr->count;
-
-	msb->attr_group.attrs = kzalloc((attr_count + 1)
-					* sizeof(struct attribute),
-					GFP_KERNEL);
-	if (!msb->attr_group.attrs) {
-		rc = -ENOMEM;
-		goto out_free_attr;
-	}
-	msb->attr_group.name = "media_attributes";
 
-	buffer = kmalloc(msb->page_size, GFP_KERNEL);
-	if (!buffer) {
-		rc = -ENOMEM;
-		goto out_free_attr;
-	}
-	memcpy(buffer, (char *)attr, msb->page_size);
-	page_count = 1;
+	attr_count = min((int)attr->count, (int)MSPRO_BLOCK_MAX_ATTRIBUTES);
+
+	/* Allocate attribute group */
+	error = -ENOMEM;
+	msb->attr_group.attrs = kzalloc((attr_count + 1) *
+					sizeof(struct attribute), GFP_KERNEL);
+	if (!msb->attr_group.attrs)
+		goto out_free_buffer;
 
+	msb->attr_group.name = "media_attributes";
+
+	/* Read all other attributes */
 	for (cnt = 0; cnt < attr_count; ++cnt) {
+
+		/* Create new sysfs attribute */
 		s_attr = kzalloc(sizeof(struct mspro_sys_attr), GFP_KERNEL);
-		if (!s_attr) {
-			rc = -ENOMEM;
+		error = -ENOMEM;
+		if (!s_attr)
 			goto out_free_buffer;
-		}
 
-		msb->attr_group.attrs[cnt] = &s_attr->dev_attr.attr;
-		addr = be32_to_cpu(attr->entries[cnt].address);
-		rc = be32_to_cpu(attr->entries[cnt].size);
-		dev_dbg(&card->dev, "adding attribute %d: id %x, address %x, "
-			"size %x\n", cnt, attr->entries[cnt].id, addr, rc);
+		sysfs_attr_init(&s_attr->dev_attr.attr);
+		s_attr->dev_attr.attr.name = s_attr->name;
+		s_attr->dev_attr.attr.mode = S_IRUGO;
 		s_attr->id = attr->entries[cnt].id;
+		s_attr->dev_attr.show = mspro_block_attr_show(s_attr->id);
+
 		if (mspro_block_attr_name(s_attr->id))
 			snprintf(s_attr->name, sizeof(s_attr->name), "%s",
 				 mspro_block_attr_name(attr->entries[cnt].id));
@@ -913,78 +927,62 @@ static int mspro_block_read_attributes(struct memstick_dev *card)
 			snprintf(s_attr->name, sizeof(s_attr->name),
 				 "attr_x%02x", attr->entries[cnt].id);
 
-		sysfs_attr_init(&s_attr->dev_attr.attr);
-		s_attr->dev_attr.attr.name = s_attr->name;
-		s_attr->dev_attr.attr.mode = S_IRUGO;
-		s_attr->dev_attr.show = mspro_block_attr_show(s_attr->id);
+		msb->attr_group.attrs[cnt] = &s_attr->dev_attr.attr;
 
-		if (!rc)
+
+		attr_addr = be32_to_cpu(attr->entries[cnt].address);
+		attr_size = be32_to_cpu(attr->entries[cnt].size);
+		attr_page_offset = attr_addr % msb->page_size;
+
+		if (!attr_size)
 			continue;
 
-		s_attr->size = rc;
-		s_attr->data = kmalloc(rc, GFP_KERNEL);
+		dbg(card, "adding attribute %d: id %x, address %x, size %x",
+			cnt, s_attr->id, attr_addr, attr_size);
+
+		s_attr->size = attr_size;
+		s_attr->data = kmalloc(attr_size, GFP_KERNEL);
 		if (!s_attr->data) {
-			rc = -ENOMEM;
+			error = -ENOMEM;
 			goto out_free_buffer;
 		}
 
-		if (((addr / msb->page_size)
-		     == be32_to_cpu(param.data_address))
-		    && (((addr + rc - 1) / msb->page_size)
-			== be32_to_cpu(param.data_address))) {
-			memcpy(s_attr->data, buffer + addr % msb->page_size,
-			       rc);
+		/* If we already read that attribute as part of last one,
+								use that */
+		if (round_down(attr_addr, msb->page_size) == buffer_address &&
+		    attr_addr + attr_size <= buffer_address + buffer_size) {
+
+			memcpy(s_attr->data, buffer + attr_page_offset,
+								attr_size);
 			continue;
 		}
 
-		if (page_count <= (rc / msb->page_size)) {
+		/* Reallocate buffer if nessesary */
+		new_buffer_size = roundup(attr_page_offset + attr_size,
+								msb->page_size);
+		buffer_address = round_down(attr_addr, msb->page_size);
+
+		if (new_buffer_size > buffer_size) {
 			kfree(buffer);
-			page_count = (rc / msb->page_size) + 1;
-			buffer = kmalloc(page_count * msb->page_size,
-					 GFP_KERNEL);
-			if (!buffer) {
-				rc = -ENOMEM;
-				goto out_free_attr;
-			}
-		}
+			buffer_size = new_buffer_size;
+			buffer = kmalloc(buffer_size, GFP_KERNEL);
+			if (!buffer)
+				goto out_free_buffer;
 
-		param.system = msb->system;
-		param.data_count = cpu_to_be16((rc / msb->page_size) + 1);
-		param.data_address = cpu_to_be32(addr / msb->page_size);
-		param.tpc_param = 0;
-
-		sg_init_one(&msb->req_sg[0], buffer,
-			    be16_to_cpu(param.data_count) * msb->page_size);
-		msb->seg_count = 1;
-		msb->current_seg = 0;
-		msb->current_page = 0;
-		msb->data_dir = READ;
-		msb->transfer_cmd = MSPRO_CMD_READ_ATRB;
-
-		dev_dbg(&card->dev, "reading attribute pages %x, %x\n",
-			be32_to_cpu(param.data_address),
-			be16_to_cpu(param.data_count));
-
-		card->next_request = h_mspro_block_req_init;
-		msb->mrq_handler = h_mspro_block_transfer_data;
-		memstick_init_req(&card->current_mrq, MS_TPC_WRITE_REG,
-				  (char *)&param, sizeof(param));
-		memstick_new_req(card->host);
-		wait_for_completion(&card->mrq_complete);
-		if (card->current_mrq.error) {
-			rc = card->current_mrq.error;
-			goto out_free_buffer;
 		}
 
-		memcpy(s_attr->data, buffer + addr % msb->page_size, rc);
+		/* Finaly read and save the attrubute */
+		error = mspro_block_read_attribute(card,
+			buffer_address,
+			buffer, new_buffer_size);
+		memcpy(s_attr->data, buffer + attr_page_offset, attr_size);
 	}
 
-	rc = 0;
+	error = 0;
 out_free_buffer:
 	kfree(buffer);
-out_free_attr:
 	kfree(attr);
-	return rc;
+	return error;
 }
 
 static int mspro_block_init_card(struct memstick_dev *card)
diff --git a/drivers/memstick/core/mspro_block.h b/drivers/memstick/core/mspro_block.h
index afb29f8..ba9f78c 100644
--- a/drivers/memstick/core/mspro_block.h
+++ b/drivers/memstick/core/mspro_block.h
@@ -126,41 +126,44 @@ struct mspro_devinfo {
 
 
 struct mspro_block_data {
-	struct memstick_dev   *card;
-	unsigned int          usage_count;
-	unsigned int          caps;
-	struct gendisk        *disk;
-	struct request_queue  *queue;
-	struct request        *block_req;
-	spinlock_t            q_lock;
-
-	unsigned short        page_size;
-	unsigned short        cylinders;
-	unsigned short        heads;
-	unsigned short        sectors_per_track;
-
-	unsigned char         system;
-	unsigned char         read_only:1,
-			      eject:1,
-			      has_request:1,
-			      data_dir:1,
-			      active:1;
-	unsigned char         transfer_cmd;
-
-	int                   (*mrq_handler)(struct memstick_dev *card,
-					     struct memstick_request **mrq);
-
-	struct attribute_group attr_group;
-
-	struct scatterlist    req_sg[MSPRO_BLOCK_MAX_SEGS];
-	unsigned int          seg_count;
-	unsigned int          current_seg;
-	unsigned int          current_page;
+	struct memstick_dev              *card;
+	unsigned int                     usage_count;
+	unsigned int                     caps;
+	struct gendisk                   *disk;
+	struct request_queue             *queue;
+	struct request                   *block_req;
+	spinlock_t                       q_lock;
+	struct scatterlist               req_sg[MSPRO_BLOCK_MAX_SEGS];
+
+	int                           (*mrq_handler)(struct memstick_dev *card,
+						struct memstick_request **mrq);
+
+	unsigned char                    read_only:1;
+	unsigned char                    eject:1;
+	unsigned char                    active:1;
+
+	/* Media info */
+	struct attribute_group           attr_group;
+	unsigned short                   page_size;
+	unsigned short                   cylinders;
+	unsigned short                   heads;
+	unsigned short                   sectors_per_track;
+
+	/* Handlers state */
+	unsigned char                    system;
+	unsigned char                    transfer_cmd;
+	struct mspro_param_register      arg;
+
+	struct scatterlist               *current_sg;
+	unsigned int                     current_sg_offset;
+	unsigned int	                 data_transferred;
+	unsigned char                    data_dir:1;
+	int                              io_error;
 };
 
-static int mspro_block_complete_req(struct memstick_dev *card, int error);
+static void mspro_block_complete_req(struct memstick_dev *card, int error);
 static int mspro_block_switch_interface(struct memstick_dev *card);
-static int mspro_block_issue_req(struct memstick_dev *card, int chunk);
+static int mspro_block_issue_req(struct memstick_dev *card, bool first);
 
 #define __dbg(card, level, format, ...) \
 	do { \
-- 
1.7.1

