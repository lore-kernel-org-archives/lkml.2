Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757021Ab0JVX6h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 19:58:37 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60658 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755557Ab0JVXyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 19:54:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=xqZux8DP9sSH9Iwt8KgQ/xUFx5MFrOFc1S+kNtHJ1EBATVPXQ2IVhUjZpNJH0+sRNd
         X/ehosADoUlMCW3VPWSbaXBh0BgdL6iPoenvpgWQFpFXTlYhEuIt8v2PLPzRuySEAIR0
         Iqm8qVHGlx4i3s7h5T92MXmguwyQaV8eBxoKk=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 13/29] memstick: core: stop passing pointer to card->current_mrq
Date: Sat, 23 Oct 2010 01:53:41 +0200
Message-Id: <1287791637-10329-14-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287791637-10329-1-git-send-email-maximlevitsky@gmail.com>
References: <1287791637-10329-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This cleans up a lot of code and makes the assumption
(*mrq == &card->current_mrq) official.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/memstick/core/memstick.c    |  135 +++++++++++++++--------------------
 drivers/memstick/core/mspro_block.c |  102 ++++++++++++--------------
 include/linux/memstick.h            |   26 ++-----
 3 files changed, 114 insertions(+), 149 deletions(-)

diff --git a/drivers/memstick/core/memstick.c b/drivers/memstick/core/memstick.c
index 5eea1b2..9de64eb 100644
--- a/drivers/memstick/core/memstick.c
+++ b/drivers/memstick/core/memstick.c
@@ -202,7 +202,6 @@ static int memstick_dummy_check(struct memstick_dev *card)
 	return 0;
 }
 
-
 /*
  * Functions prefixed with "h_" are protocol callbacks. They can be called from
  * interrupt context. Return value of 0 means that request processing is still
@@ -210,60 +209,57 @@ static int memstick_dummy_check(struct memstick_dev *card)
  * finished (and request processor should come back some time later).
  */
 
-static int h_memstick_read_dev_id(struct memstick_dev *card,
-						struct memstick_request **mrq)
+static int h_memstick_read_dev_id(struct memstick_dev *card)
 {
 	struct ms_id_register id_reg;
+	struct memstick_request *mrq = &card->current_mrq;
 
-	memstick_allocate_request(card, mrq);
-	if ((*mrq)->error)
-		return memstick_exit_state_machine(card, *mrq, (*mrq)->error);
+	if (mrq->error)
+		return memstick_exit_state_machine(card, mrq->error);
 
 	switch (card->state) {
 	case 0:
 		if (!memstick_read_regs(card,
 			offsetof(struct ms_register, id),
-			sizeof(struct ms_id_register), *mrq))
+			sizeof(struct ms_id_register)))
 			return 0;
 		break;
 	case 1:
-		memcpy(&id_reg, (*mrq)->data, sizeof(id_reg));
+		memcpy(&id_reg, mrq->data, sizeof(id_reg));
 		card->id.match_flags = MEMSTICK_MATCH_ALL;
 		card->id.type = id_reg.type;
 		card->id.category = id_reg.category;
 		card->id.class = id_reg.class;
 		dev_dbg(&card->dev, "if_mode = %02x\n", id_reg.if_mode);
-		return memstick_exit_state_machine(card, *mrq, 0);
+		return memstick_exit_state_machine(card, 0);
 	}
 
 	card->state++;
 	return 0;
 }
 
-static int h_memstick_set_rw_addr(struct memstick_dev *card,
-				  struct memstick_request **mrq)
+static int h_memstick_set_rw_addr(struct memstick_dev *card)
 {
-	memstick_allocate_request(card, mrq);
-	if ((*mrq)->error)
-		return memstick_exit_state_machine(card, *mrq, (*mrq)->error);
+	struct memstick_request *mrq = &card->current_mrq;
+
+	if (mrq->error)
+		return memstick_exit_state_machine(card, mrq->error);
 
 	switch (card->state) {
 	case 0:
-		memstick_init_req(*mrq, MS_TPC_SET_RW_REG_ADRS,
+		memstick_init_req(card, MS_TPC_SET_RW_REG_ADRS,
 				  (char *)&card->reg_addr,
 				  sizeof(card->reg_addr));
 		break;
 	case 1:
-		return memstick_exit_state_machine(card, *mrq, 0);
+		return memstick_exit_state_machine(card, 0);
 	}
 
 	card->state++;
 	return 0;
 }
 
-
-static int h_memstick_default_bad(struct memstick_dev *card,
-				     struct memstick_request **mrq)
+static int h_memstick_default_bad(struct memstick_dev *card)
 {
 	return -ENXIO;
 }
@@ -273,7 +269,6 @@ static void memstick_invalidate_reg_window(struct memstick_dev *card)
 	memset(&card->reg_addr, 0, sizeof(card->reg_addr));
 }
 
-
 static struct memstick_dev *memstick_alloc_card(struct memstick_host *host)
 {
 	struct memstick_dev *card = kzalloc(sizeof(struct memstick_dev),
@@ -436,8 +431,7 @@ EXPORT_SYMBOL(memstick_set_rw_addr);
  * memstick_exit_state_machine
  */
 int memstick_run_state_machine(struct memstick_dev *card,
-	int   (*state_func)(struct memstick_dev *card,
-			struct memstick_request **mrq), bool sync)
+	int   (*state_func)(struct memstick_dev *card), bool sync)
 {
 	WARN_ON(card->state != -1);
 
@@ -472,9 +466,10 @@ EXPORT_SYMBOL(memstick_run_state_machine);
  *
  * State machines call this to signal quit
  */
-int memstick_exit_state_machine(struct memstick_dev *card,
-			struct memstick_request *req, int error)
+int memstick_exit_state_machine(struct memstick_dev *card, int error)
 {
+	WARN_ON(card->state == -1);
+
 	card->state = -1;
 	card->exit_error = error;
 	card->next_request = h_memstick_default_bad;
@@ -488,24 +483,7 @@ int memstick_exit_state_machine(struct memstick_dev *card,
 }
 EXPORT_SYMBOL(memstick_exit_state_machine);
 
-/**
- * memstick_allocate_request - create new request for use in request handler
- * @card - card to use
- * @mrq - request to initialize
- */
-void memstick_allocate_request(struct memstick_dev *card,
-					struct memstick_request **mrq)
-{
-	if (*mrq == NULL) {
-		*mrq = &card->current_mrq;
-		(*mrq)->error = 0;
-		(*mrq)->need_card_int = 0;
-		card->int_polling = false;
-		card->state = 0;
-	}
-}
-EXPORT_SYMBOL(memstick_allocate_request);
-
+/*** functions to be called by state machines ***/
 
 /**
  * memstick_init_req_sg - set request fields needed for bulk data transfer
@@ -513,9 +491,12 @@ EXPORT_SYMBOL(memstick_allocate_request);
  * @tpc - memstick Transport Protocol Command
  * @sg - TPC argument
  */
-void memstick_init_req_sg(struct memstick_request *mrq, unsigned char tpc,
+void memstick_init_req_sg(struct memstick_dev *card, unsigned char tpc,
 			  const struct scatterlist *sg)
 {
+	struct memstick_request *mrq = &card->current_mrq;
+	WARN_ON(card->state == -1);
+
 	mrq->tpc = tpc;
 	if (tpc & 8)
 		mrq->data_dir = WRITE;
@@ -529,6 +510,10 @@ void memstick_init_req_sg(struct memstick_request *mrq, unsigned char tpc,
 		mrq->need_card_int = 1;
 	else
 		mrq->need_card_int = 0;
+
+	if (tpc != MS_TPC_GET_INT)
+		card->int_polling = false;
+
 }
 EXPORT_SYMBOL(memstick_init_req_sg);
 
@@ -543,9 +528,12 @@ EXPORT_SYMBOL(memstick_init_req_sg);
  * in size) allows us to just copy the value between request structure and
  * user supplied buffer.
  */
-void memstick_init_req(struct memstick_request *mrq, unsigned char tpc,
+void memstick_init_req(struct memstick_dev *card, unsigned char tpc,
 		       const void *buf, size_t length)
 {
+	struct memstick_request *mrq = &card->current_mrq;
+	WARN_ON(card->state == -1);
+
 	mrq->tpc = tpc;
 	if (tpc & 8)
 		mrq->data_dir = WRITE;
@@ -562,6 +550,10 @@ void memstick_init_req(struct memstick_request *mrq, unsigned char tpc,
 		mrq->need_card_int = 1;
 	else
 		mrq->need_card_int = 0;
+
+	if (tpc != MS_TPC_GET_INT)
+		card->int_polling = false;
+
 }
 EXPORT_SYMBOL(memstick_init_req);
 
@@ -575,27 +567,28 @@ EXPORT_SYMBOL(memstick_init_req);
  * @card - card to use
  * @timeout - the timeout. if -1, then uses default
  */
-int memstick_read_int_reg(struct memstick_dev *card,
-				struct memstick_request *req, long timeout)
+
+int memstick_read_int_reg(struct memstick_dev *card, long timeout)
 {
+	struct memstick_request *mrq = &card->current_mrq;
+	WARN_ON(card->state == -1);
 
 	if (!card->int_polling) {
 		card->int_timeout = jiffies +
 			msecs_to_jiffies(timeout == -1 ? 500 : timeout);
 		card->int_polling = true;
 	} else if (time_after(jiffies, card->int_timeout)) {
-		req->data[0] = MEMSTICK_INT_CMDNAK;
+		mrq->data[0] = MEMSTICK_INT_CMDNAK;
 		return 0;
 	}
 
 	if (((card->caps | card->host->caps) & MEMSTICK_CAP_AUTO_GET_INT) &&
-							req->need_card_int) {
-		BUG_ON(req->error);
-		req->data[0] = req->int_reg;
-		req->need_card_int = 0;
+				mrq->need_card_int && !mrq->error) {
+		mrq->data[0] = mrq->int_reg;
+		mrq->need_card_int = false;
 		return 0;
 	} else {
-		memstick_init_req(req, MS_TPC_GET_INT, NULL, 1);
+		memstick_init_req(card, MS_TPC_GET_INT, NULL, 1);
 		return 1;
 	}
 }
@@ -603,19 +596,6 @@ EXPORT_SYMBOL(memstick_read_int_reg);
 
 
 /**
- * memstick_read_int_reg_cleanup - cleanup after series of calls to
- * memstick_read_int_reg. Used to cancel timeout.
- * Use this if you use memstick_read_int_reg
- * @card - card to use
- */
-void memstick_read_int_reg_cleanup(struct memstick_dev *card)
-{
-	card->int_polling = false;
-}
-EXPORT_SYMBOL(memstick_read_int_reg_cleanup);
-
-
-/**
  * memstick_read_regs - read the ms registers
  * If there is need to change the R/W window,
  * it will create the MS_TPC_SET_RW_REG_ADRS request and return 0,
@@ -626,9 +606,10 @@ EXPORT_SYMBOL(memstick_read_int_reg_cleanup);
  * @req - request to use
  */
 
-int memstick_read_regs(struct memstick_dev *card, int offset, int len,
-	struct memstick_request *req)
+int memstick_read_regs(struct memstick_dev *card, int offset, int len)
 {
+	WARN_ON(card->state == -1);
+
 	if (card->reg_addr.r_offset != offset ||
 					card->reg_addr.r_length != len) {
 		card->reg_addr.r_offset = offset;
@@ -642,12 +623,12 @@ int memstick_read_regs(struct memstick_dev *card, int offset, int len,
 			card->reg_addr.w_length = sizeof(struct ms_id_register);
 		}
 
-		memstick_init_req(req, MS_TPC_SET_RW_REG_ADRS, &card->reg_addr,
+		memstick_init_req(card, MS_TPC_SET_RW_REG_ADRS, &card->reg_addr,
 			sizeof(card->reg_addr));
 		return 0;
 	}
 
-	memstick_init_req(req, MS_TPC_READ_REG, NULL, len);
+	memstick_init_req(card, MS_TPC_READ_REG, NULL, len);
 	return 1;
 }
 EXPORT_SYMBOL(memstick_read_regs);
@@ -664,8 +645,10 @@ EXPORT_SYMBOL(memstick_read_regs);
  * @req - request to use
  */
 int memstick_write_regs(struct memstick_dev *card, int offset, int len,
-	char *buf, struct memstick_request *req)
+	char *buf)
 {
+	WARN_ON(card->state == -1);
+
 	if (card->reg_addr.w_offset != offset ||
 					card->reg_addr.w_length != len) {
 		card->reg_addr.w_offset = offset;
@@ -676,16 +659,15 @@ int memstick_write_regs(struct memstick_dev *card, int offset, int len,
 		if (!card->reg_addr.r_length) {
 			card->reg_addr.r_offset =
 					offsetof(struct ms_register, id);
-
 			card->reg_addr.r_length = sizeof(struct ms_id_register);
 		}
 
-		memstick_init_req(req, MS_TPC_SET_RW_REG_ADRS, &card->reg_addr,
+		memstick_init_req(card, MS_TPC_SET_RW_REG_ADRS, &card->reg_addr,
 			sizeof(card->reg_addr));
 		return 0;
 	}
 
-	memstick_init_req(req, MS_TPC_WRITE_REG, buf, len);
+	memstick_init_req(card, MS_TPC_WRITE_REG, buf, len);
 	return 1;
 }
 EXPORT_SYMBOL(memstick_write_regs);
@@ -885,11 +867,12 @@ int memstick_next_req(struct memstick_host *host, struct memstick_request **mrq)
 	}
 
 	if (host->card && host->card->next_request)
-		rc = host->card->next_request(host->card, mrq);
+		rc = host->card->next_request(host->card);
 
-	if (!rc)
+	if (!rc) {
+		*mrq = &host->card->current_mrq;
 		host->retries = cmd_retries > 1 ? cmd_retries - 1 : 1;
-	else
+	} else
 		*mrq = NULL;
 
 	return rc;
diff --git a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/mspro_block.c
index 85018ce..34c9334 100644
--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -372,24 +372,24 @@ static sysfs_show_t mspro_block_attr_show(unsigned char tag)
  * finished (and request processor should come back some time later).
  */
 
-static int h_mspro_block_transfer_data(struct memstick_dev *card,
-				       struct memstick_request **mrq)
+/* State machine that handles the IO. Heart of the driver */
+static int h_mspro_block_transfer_data(struct memstick_dev *card)
 {
 	struct mspro_block_data *msb = memstick_get_drvdata(card);
+	struct memstick_request *mrq = &card->current_mrq;
+
 	unsigned char intreg = 0, command;
 	struct scatterlist t_sg = { 0 };
 	unsigned long flags;
 	int error;
 	size_t t_offset;
 
-	memstick_allocate_request(card, mrq);
-
-	if ((*mrq)->error) {
-		dbg(card, "IO: error (%d) executing %s", (*mrq)->error,
-			memstick_debug_get_tpc_name((*mrq)->tpc));
+	if (mrq->error) {
+		dbg(card, "IO: error (%d) executing %s", mrq->error,
+			memstick_debug_get_tpc_name(mrq->tpc));
 
 		if (!msb->io_error) {
-			msb->io_error = (*mrq)->error;
+			msb->io_error = mrq->error;
 			card->state = 5;
 		}
 	}
@@ -397,17 +397,17 @@ again:
 	switch (card->state) {
 
 	case 0: /* send read/write command + args */
-		memstick_init_req(*mrq, MS_TPC_EX_SET_CMD,
+		memstick_init_req(card, MS_TPC_EX_SET_CMD,
 					&msb->arg, sizeof(msb->arg));
 		break;
 
 	case 1: /* read the INT register */
-		if (memstick_read_int_reg(card, *mrq, -1))
+		if (memstick_read_int_reg(card, -1))
 			break;
 		card->state++;
 
 	case 2: /* process the int register */
-		intreg = (*mrq)->data[0];
+		intreg = mrq->data[0];
 
 		if (intreg & (MEMSTICK_INT_CMDNAK | MEMSTICK_INT_ERR)) {
 			dbg(card, "IO: card I/O error");
@@ -423,7 +423,6 @@ again:
 				goto again;
 			}
 
-			memstick_read_int_reg_cleanup(card);
 			card->state = 6;
 			goto again;
 		}
@@ -434,7 +433,6 @@ again:
 			goto again;
 		}
 
-		memstick_read_int_reg_cleanup(card);
 		card->state++;
 
 	case 3: /* init transfer of the data */
@@ -445,9 +443,9 @@ again:
 			t_offset >> PAGE_SHIFT), msb->page_size,
 			offset_in_page(t_offset));
 
-		memstick_init_req_sg(*mrq, msb->data_dir == READ ?
+		memstick_init_req_sg(card, msb->data_dir == READ ?
 			MS_TPC_READ_LONG_DATA : MS_TPC_WRITE_LONG_DATA, &t_sg);
-		(*mrq)->need_card_int = 1;
+		mrq->need_card_int = 1;
 		break;
 
 	case 4: /* switch to next page */
@@ -464,35 +462,36 @@ again:
 
 	case 5: /* after a error send STOP command */
 		command = MSPRO_CMD_STOP;
-		memstick_init_req(*mrq, MS_TPC_SET_CMD, &command, 1);
+		memstick_init_req(card, MS_TPC_SET_CMD, &command, 1);
 		break;
 
 	case 6: /* request complete - get next one*/
 		spin_lock_irqsave(&msb->q_lock, flags);
 
 		if (msb->io_error)
-			(*mrq)->error = msb->io_error;
+			mrq->error = msb->io_error;
 
 		if (msb->block_req) {
-			mspro_block_complete_req(card, (*mrq)->error);
+			mspro_block_complete_req(card, mrq->error);
 			error = mspro_block_issue_req(card, false);
 
-			if (!msb->block_req) {
+			if (error) {
+				WARN_ON(msb->block_req);
+
 				dbg_v(card, "IO: out of requests");
 				error = memstick_exit_state_machine(
-						card, *mrq, (*mrq)->error);
+							card, mrq->error);
 				spin_unlock_irqrestore(&msb->q_lock, flags);
 				return error;
 			}
 
 			spin_unlock_irqrestore(&msb->q_lock, flags);
-			(*mrq)->error = 0;
+			mrq->error = 0;
 			card->state = 0;
 			goto again;
 
 		} else {
-			error = memstick_exit_state_machine(card,
-							*mrq, (*mrq)->error);
+			error = memstick_exit_state_machine(card, mrq->error);
 			spin_unlock_irqrestore(&msb->q_lock, flags);
 			return error;
 		}
@@ -504,40 +503,37 @@ again:
 	return 0;
 }
 
-
-static int h_mspro_block_reset(struct memstick_dev *card,
-					struct memstick_request **mrq)
+static int h_mspro_block_reset(struct memstick_dev *card)
 {
 	struct mspro_block_data *msb = memstick_get_drvdata(card);
 	struct ms_status_register *status;
-	u8 intreg;
+	struct memstick_request *mrq = &card->current_mrq;
 
-	memstick_allocate_request(card, mrq);
-	if ((*mrq)->error)
-		return memstick_exit_state_machine(card, *mrq, (*mrq)->error);
+	u8 intreg;
 
+	if (mrq->error)
+		return memstick_exit_state_machine(card, mrq->error);
 again:
 	switch (card->state) {
 
 	case 0: /* send request for INT reg */
-		if (memstick_read_int_reg(card, *mrq, 10000))
+		if (memstick_read_int_reg(card, 10000))
 			break;
 		card->state++;
 
 	case 1: /* process the INT reg and loop if nessesary */
-		intreg = (*mrq)->data[0];
+		intreg = mrq->data[0];
 
 		if (intreg & MEMSTICK_INT_ERR) {
 			if ((intreg & MEMSTICK_INT_CMDNAK)) {
 				msb->read_only = true;
-				return memstick_exit_state_machine(card,
-								*mrq, 0);
+				return memstick_exit_state_machine(card, 0);
 			}
-			return memstick_exit_state_machine(card, *mrq, -EIO);
+			return memstick_exit_state_machine(card, -EIO);
 		}
 
 		if (intreg & MEMSTICK_INT_CMDNAK)
-			return memstick_exit_state_machine(card, *mrq, -EIO);
+			return memstick_exit_state_machine(card, -EIO);
 
 
 		if (!(intreg & MEMSTICK_INT_CED)) {
@@ -545,22 +541,20 @@ again:
 			goto again;
 		}
 
-		memstick_read_int_reg_cleanup(card);
 		card->state++;
 
 	case 2: /* read the R/O status */
 
 		if (!memstick_read_regs(card,
 			offsetof(struct mspro_register, status),
-			sizeof(struct ms_status_register),
-			*mrq))
+			sizeof(struct ms_status_register)))
 			return 0;
 		break;
 
 	case 3: /* process the result & done */
-		status = (struct ms_status_register *)(*mrq)->data;
+		status = (struct ms_status_register *)mrq->data;
 		msb->read_only = status->status0 & MEMSTICK_STATUS0_WP;
-		return memstick_exit_state_machine(card, *mrq, 0);
+		return memstick_exit_state_machine(card, 0);
 	}
 
 	card->state++;
@@ -568,14 +562,14 @@ again:
 
 }
 
-static int h_mspro_block_switch_interface(struct memstick_dev *card,
-					struct memstick_request **mrq)
+static int h_mspro_block_switch_interface(struct memstick_dev *card)
 {
 	struct mspro_block_data *msb = memstick_get_drvdata(card);
+	struct memstick_request *mrq = &card->current_mrq;
+
 	int error;
-	memstick_allocate_request(card, mrq);
-	if ((*mrq)->error)
-		return memstick_exit_state_machine(card, *mrq, (*mrq)->error);
+	if (mrq->error)
+		return memstick_exit_state_machine(card, mrq->error);
 
 	switch (card->state) {
 
@@ -583,8 +577,7 @@ static int h_mspro_block_switch_interface(struct memstick_dev *card,
 		if (!memstick_write_regs(card,
 			offsetof(struct mspro_register, param),
 			1,
-			&msb->system,
-			*mrq))
+			&msb->system))
 			return 0;
 		break;
 
@@ -593,13 +586,13 @@ static int h_mspro_block_switch_interface(struct memstick_dev *card,
 		error = card->host->set_param(card->host,
 				MEMSTICK_INTERFACE, msb->target_interface);
 		if (error)
-			return memstick_exit_state_machine(card, *mrq, -EFAULT);
+			return memstick_exit_state_machine(card, -EFAULT);
 
-		memstick_init_req(*mrq, MS_TPC_GET_INT, NULL, 1);
+		memstick_init_req(card, MS_TPC_GET_INT, NULL, 1);
 		break;
 
 	case 2: /* done */
-		return memstick_exit_state_machine(card, *mrq, 0);
+		return memstick_exit_state_machine(card, 0);
 
 	}
 
@@ -673,16 +666,15 @@ again:
 
 	dbg(card, "IO: %s: lba %x, pages %x", is_read ? "read" : "write",
 					(unsigned int)sec, pages);
+
 	if (first)
 		memstick_run_state_machine(card,
-			h_mspro_block_transfer_data, false);
+					h_mspro_block_transfer_data, false);
 	return 0;
 }
 
 /*
- * Completes execution of current block request.
- *  After execution of this function, the msb->block_req might or might not
- *  be NULL. If it is, it means we don't have any more requests to process
+ * Completes execution of current block request
  */
 static void mspro_block_complete_req(struct memstick_dev *card, int error)
 {
diff --git a/include/linux/memstick.h b/include/linux/memstick.h
index 4700543..5fd4beb 100644
--- a/include/linux/memstick.h
+++ b/include/linux/memstick.h
@@ -288,8 +288,7 @@ struct memstick_dev {
 	/* Check that media driver is still willing to operate the device. */
 	int                      (*check)(struct memstick_dev *card);
 	/* Get next request from the media driver.                         */
-	int                      (*next_request)(struct memstick_dev *card,
-						 struct memstick_request **mrq);
+	int                      (*next_request)(struct memstick_dev *card);
 	/* Tell the media driver to stop doing things                      */
 	void                     (*stop)(struct memstick_dev *card);
 	/* Allow the media driver to continue                              */
@@ -357,30 +356,21 @@ void memstick_unregister_driver(struct memstick_driver *drv);
 int memstick_set_rw_addr(struct memstick_dev *card);
 
 int memstick_run_state_machine(struct memstick_dev *card,
-	int   (*state_func)(struct memstick_dev *card,
-			struct memstick_request **mrq), bool sync);
+	int   (*state_func)(struct memstick_dev *card), bool sync);
 
-int memstick_exit_state_machine(struct memstick_dev *card,
-			struct memstick_request *req, int error);
+int memstick_exit_state_machine(struct memstick_dev *card, int error);
 
-void memstick_allocate_request(struct memstick_dev *card,
-					struct memstick_request **mrq);
-
-void memstick_init_req_sg(struct memstick_request *mrq, unsigned char tpc,
+void memstick_init_req_sg(struct memstick_dev *card, unsigned char tpc,
 			  const struct scatterlist *sg);
-void memstick_init_req(struct memstick_request *mrq, unsigned char tpc,
+void memstick_init_req(struct memstick_dev *card, unsigned char tpc,
 		       const void *buf, size_t length);
 
-int memstick_read_int_reg(struct memstick_dev *card,
-				struct memstick_request *req, long timeout);
-
-void memstick_read_int_reg_cleanup(struct memstick_dev *card);
+int memstick_read_int_reg(struct memstick_dev *card, long timeout);
 
-int memstick_read_regs(struct memstick_dev *card, int offset, int len,
-	struct memstick_request *req);
+int memstick_read_regs(struct memstick_dev *card, int offset, int len);
 
 int memstick_write_regs(struct memstick_dev *card, int offset, int len,
-	char *buf, struct memstick_request *req);
+	char *buf);
 
 const char *memstick_debug_get_tpc_name(int tpc);
 
-- 
1.7.1

