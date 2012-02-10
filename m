Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759329Ab2BJNkD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 08:40:03 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:54592 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab2BJNj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 08:39:58 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 6/6] sep: reworked crypto layer
To: greg@kroah.com, linux-kernel@vger.kernel.org, mark.a.allyn@intel.com
Date: Fri, 10 Feb 2012 13:53:36 +0000
Message-ID: <20120210135332.12442.74054.stgit@bob.linux.org.uk>
In-Reply-To: <20120210134929.12442.59041.stgit@bob.linux.org.uk>
References: <20120210134929.12442.59041.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark A. Allyn <mark.a.allyn@intel.com>

This gets the SEP crypto layer up and running with things like dmcrypt.
It's a fairly big set of changes because it has to rework the whole context
handling system.

[This is picked out of the differences between the upstream driver and
 the staging driver. I'm resolving the differences as a series of updates -AC]

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/sep/sep_crypto.c | 3058 +++++++++++++++++++++-----------------
 drivers/staging/sep/sep_crypto.h |   77 +
 drivers/staging/sep/sep_dev.h    |    3 
 3 files changed, 1717 insertions(+), 1421 deletions(-)


diff --git a/drivers/staging/sep/sep_crypto.c b/drivers/staging/sep/sep_crypto.c
index a6b0f83..89b6814 100644
--- a/drivers/staging/sep/sep_crypto.c
+++ b/drivers/staging/sep/sep_crypto.c
@@ -88,17 +88,17 @@ static void sep_dequeuer(void *data);
  * This will only print dump if DEBUG is set; it does
  * follow kernel debug print enabling
  */
-static void crypto_sep_dump_message(struct sep_system_ctx *sctx)
+static void crypto_sep_dump_message(struct sep_device *sep, void *msg)
 {
 #if 0
 	u32 *p;
 	u32 *i;
 	int count;
 
-	p = sctx->sep_used->shared_addr;
-	i = (u32 *)sctx->msg;
-	for (count = 0; count < 40 * 4; count += 4)
-		dev_dbg(&sctx->sep_used->pdev->dev,
+	p = sep->shared_addr;
+	i = (u32 *)msg;
+	for (count = 0; count < 10 * 4; count += 4)
+		dev_dbg(&sep->pdev->dev,
 			"[PID%d] Word %d of the message is %x (local)%x\n",
 				current->pid, count/4, *p++, *i++);
 #endif
@@ -534,6 +534,67 @@ static void sep_dump_sg(struct sep_device *sep, char *stg,
 #endif
 }
 
+/* Debug - prints only if DEBUG is defined */
+static void sep_dump_ivs(struct ablkcipher_request *req, char *reason)
+
+	{
+	unsigned char *cptr;
+	struct sep_aes_internal_context *aes_internal;
+	struct sep_des_internal_context *des_internal;
+	int ct1;
+
+	struct this_task_ctx *ta_ctx;
+	struct crypto_ablkcipher *tfm;
+	struct sep_system_ctx *sctx;
+
+	ta_ctx = ablkcipher_request_ctx(req);
+	tfm = crypto_ablkcipher_reqtfm(req);
+	sctx = crypto_ablkcipher_ctx(tfm);
+
+	dev_dbg(&ta_ctx->sep_used->pdev->dev, "IV DUMP - %s\n", reason);
+	if ((ta_ctx->current_request == DES_CBC) &&
+		(ta_ctx->des_opmode == SEP_DES_CBC)) {
+
+		des_internal = (struct sep_des_internal_context *)
+			sctx->des_private_ctx.ctx_buf;
+		/* print vendor */
+		dev_dbg(&ta_ctx->sep_used->pdev->dev,
+			"sep - vendor iv for DES\n");
+		cptr = (unsigned char *)des_internal->iv_context;
+		for (ct1 = 0; ct1 < crypto_ablkcipher_ivsize(tfm); ct1 += 1)
+			dev_dbg(&ta_ctx->sep_used->pdev->dev,
+				"%02x\n", *(cptr + ct1));
+
+		/* print walk */
+		dev_dbg(&ta_ctx->sep_used->pdev->dev,
+			"sep - walk from kernel crypto iv for DES\n");
+		cptr = (unsigned char *)ta_ctx->walk.iv;
+		for (ct1 = 0; ct1 < crypto_ablkcipher_ivsize(tfm); ct1 += 1)
+			dev_dbg(&ta_ctx->sep_used->pdev->dev,
+				"%02x\n", *(cptr + ct1));
+	} else if ((ta_ctx->current_request == AES_CBC) &&
+		(ta_ctx->aes_opmode == SEP_AES_CBC)) {
+
+		aes_internal = (struct sep_aes_internal_context *)
+			sctx->aes_private_ctx.cbuff;
+		/* print vendor */
+		dev_dbg(&ta_ctx->sep_used->pdev->dev,
+			"sep - vendor iv for AES\n");
+		cptr = (unsigned char *)aes_internal->aes_ctx_iv;
+		for (ct1 = 0; ct1 < crypto_ablkcipher_ivsize(tfm); ct1 += 1)
+			dev_dbg(&ta_ctx->sep_used->pdev->dev,
+				"%02x\n", *(cptr + ct1));
+
+		/* print walk */
+		dev_dbg(&ta_ctx->sep_used->pdev->dev,
+			"sep - walk from kernel crypto iv for AES\n");
+		cptr = (unsigned char *)ta_ctx->walk.iv;
+		for (ct1 = 0; ct1 < crypto_ablkcipher_ivsize(tfm); ct1 += 1)
+			dev_dbg(&ta_ctx->sep_used->pdev->dev,
+				"%02x\n", *(cptr + ct1));
+	}
+}
+
 /**
  * RFC2451: Weak key check
  * Returns: 1 (weak), 0 (not weak)
@@ -671,61 +732,61 @@ static u32 sep_sg_nents(struct scatterlist *sg)
 
 /**
  *	sep_start_msg -
- *	@sctx: pointer to struct sep_system_ctx
+ *	@ta_ctx: pointer to struct this_task_ctx
  *	@returns: offset to place for the next word in the message
  *	Set up pointer in message pool for new message
  */
-static u32 sep_start_msg(struct sep_system_ctx *sctx)
+static u32 sep_start_msg(struct this_task_ctx *ta_ctx)
 {
 	u32 *word_ptr;
-	sctx->msg_len_words = 2;
-	sctx->msgptr = sctx->msg;
-	memset(sctx->msg, 0, SEP_DRIVER_MESSAGE_SHARED_AREA_SIZE_IN_BYTES);
-	sctx->msgptr += sizeof(u32) * 2;
-	word_ptr = (u32 *)sctx->msgptr;
+	ta_ctx->msg_len_words = 2;
+	ta_ctx->msgptr = ta_ctx->msg;
+	memset(ta_ctx->msg, 0, SEP_DRIVER_MESSAGE_SHARED_AREA_SIZE_IN_BYTES);
+	ta_ctx->msgptr += sizeof(u32) * 2;
+	word_ptr = (u32 *)ta_ctx->msgptr;
 	*word_ptr = SEP_START_MSG_TOKEN;
 	return sizeof(u32) * 2;
 }
 
 /**
  *	sep_end_msg -
- *	@sctx: pointer to struct sep_system_ctx
+ *	@ta_ctx: pointer to struct this_task_ctx
  *	@messages_offset: current message offset
  *	Returns: 0 for success; <0 otherwise
  *	End message; set length and CRC; and
  *	send interrupt to the SEP
  */
-static void sep_end_msg(struct sep_system_ctx *sctx, u32 msg_offset)
+static void sep_end_msg(struct this_task_ctx *ta_ctx, u32 msg_offset)
 {
 	u32 *word_ptr;
 	/* Msg size goes into msg after token */
-	sctx->msg_len_words = msg_offset / sizeof(u32) + 1;
-	word_ptr = (u32 *)sctx->msgptr;
+	ta_ctx->msg_len_words = msg_offset / sizeof(u32) + 1;
+	word_ptr = (u32 *)ta_ctx->msgptr;
 	word_ptr += 1;
-	*word_ptr = sctx->msg_len_words;
+	*word_ptr = ta_ctx->msg_len_words;
 
 	/* CRC (currently 0) goes at end of msg */
-	word_ptr = (u32 *)(sctx->msgptr + msg_offset);
+	word_ptr = (u32 *)(ta_ctx->msgptr + msg_offset);
 	*word_ptr = 0;
 }
 
 /**
  *	sep_start_inbound_msg -
- *	@sctx: pointer to struct sep_system_ctx
+ *	@ta_ctx: pointer to struct this_task_ctx
  *	@msg_offset: offset to place for the next word in the message
  *	@returns: 0 for success; error value for failure
  *	Set up pointer in message pool for inbound message
  */
-static u32 sep_start_inbound_msg(struct sep_system_ctx *sctx, u32 *msg_offset)
+static u32 sep_start_inbound_msg(struct this_task_ctx *ta_ctx, u32 *msg_offset)
 {
 	u32 *word_ptr;
 	u32 token;
 	u32 error = SEP_OK;
 
 	*msg_offset = sizeof(u32) * 2;
-	word_ptr = (u32 *)sctx->msgptr;
+	word_ptr = (u32 *)ta_ctx->msgptr;
 	token = *word_ptr;
-	sctx->msg_len_words = *(word_ptr + 1);
+	ta_ctx->msg_len_words = *(word_ptr + 1);
 
 	if (token != SEP_START_MSG_TOKEN) {
 		error = SEP_INVALID_START;
@@ -739,7 +800,7 @@ end_function:
 
 /**
  *	sep_write_msg -
- *	@sctx: pointer to struct sep_system_ctx
+ *	@ta_ctx: pointer to struct this_task_ctx
  *	@in_addr: pointer to start of parameter
  *	@size: size of parameter to copy (in bytes)
  *	@max_size: size to move up offset; SEP mesg is in word sizes
@@ -747,12 +808,12 @@ end_function:
  *	@byte_array: flag ti indicate wheter endian must be changed
  *	Copies data into the message area from caller
  */
-static void sep_write_msg(struct sep_system_ctx *sctx, void *in_addr,
+static void sep_write_msg(struct this_task_ctx *ta_ctx, void *in_addr,
 	u32 size, u32 max_size, u32 *msg_offset, u32 byte_array)
 {
 	u32 *word_ptr;
 	void *void_ptr;
-	void_ptr = sctx->msgptr + *msg_offset;
+	void_ptr = ta_ctx->msgptr + *msg_offset;
 	word_ptr = (u32 *)void_ptr;
 	memcpy(void_ptr, in_addr, size);
 	*msg_offset += max_size;
@@ -767,18 +828,18 @@ static void sep_write_msg(struct sep_system_ctx *sctx, void *in_addr,
 
 /**
  *	sep_make_header
- *	@sctx: pointer to struct sep_system_ctx
+ *	@ta_ctx: pointer to struct this_task_ctx
  *	@msg_offset: pointer to current offset (is updated)
  *	@op_code: op code to put into message
  *	Puts op code into message and updates offset
  */
-static void sep_make_header(struct sep_system_ctx *sctx, u32 *msg_offset,
+static void sep_make_header(struct this_task_ctx *ta_ctx, u32 *msg_offset,
 			    u32 op_code)
 {
 	u32 *word_ptr;
 
-	*msg_offset = sep_start_msg(sctx);
-	word_ptr = (u32 *)(sctx->msgptr + *msg_offset);
+	*msg_offset = sep_start_msg(ta_ctx);
+	word_ptr = (u32 *)(ta_ctx->msgptr + *msg_offset);
 	*word_ptr = op_code;
 	*msg_offset += sizeof(u32);
 }
@@ -787,7 +848,7 @@ static void sep_make_header(struct sep_system_ctx *sctx, u32 *msg_offset,
 
 /**
  *	sep_read_msg -
- *	@sctx: pointer to struct sep_system_ctx
+ *	@ta_ctx: pointer to struct this_task_ctx
  *	@in_addr: pointer to start of parameter
  *	@size: size of parameter to copy (in bytes)
  *	@max_size: size to move up offset; SEP mesg is in word sizes
@@ -795,12 +856,12 @@ static void sep_make_header(struct sep_system_ctx *sctx, u32 *msg_offset,
  *	@byte_array: flag ti indicate wheter endian must be changed
  *	Copies data out of the message area to caller
  */
-static void sep_read_msg(struct sep_system_ctx *sctx, void *in_addr,
+static void sep_read_msg(struct this_task_ctx *ta_ctx, void *in_addr,
 	u32 size, u32 max_size, u32 *msg_offset, u32 byte_array)
 {
 	u32 *word_ptr;
 	void *void_ptr;
-	void_ptr = sctx->msgptr + *msg_offset;
+	void_ptr = ta_ctx->msgptr + *msg_offset;
 	word_ptr = (u32 *)void_ptr;
 
 	/* Do we need to manipulate endian? */
@@ -816,28 +877,28 @@ static void sep_read_msg(struct sep_system_ctx *sctx, void *in_addr,
 
 /**
  *	sep_verify_op -
- *      @sctx: pointer to struct sep_system_ctx
+ *	@ta_ctx: pointer to struct this_task_ctx
  *	@op_code: expected op_code
  *      @msg_offset: pointer to current offset (is updated)
  *	@returns: 0 for success; error for failure
  */
-static u32 sep_verify_op(struct sep_system_ctx *sctx, u32 op_code,
+static u32 sep_verify_op(struct this_task_ctx *ta_ctx, u32 op_code,
 			 u32 *msg_offset)
 {
 	u32 error;
 	u32 in_ary[2];
 
-	struct sep_device *sep = sctx->sep_used;
+	struct sep_device *sep = ta_ctx->sep_used;
 
 	dev_dbg(&sep->pdev->dev, "dumping return message\n");
-	error = sep_start_inbound_msg(sctx, msg_offset);
+	error = sep_start_inbound_msg(ta_ctx, msg_offset);
 	if (error) {
 		dev_warn(&sep->pdev->dev,
 			"sep_start_inbound_msg error\n");
 		return error;
 	}
 
-	sep_read_msg(sctx, in_ary, sizeof(u32) * 2, sizeof(u32) * 2,
+	sep_read_msg(ta_ctx, in_ary, sizeof(u32) * 2, sizeof(u32) * 2,
 		msg_offset, 0);
 
 	if (in_ary[0] != op_code) {
@@ -863,7 +924,7 @@ return 0;
 
 /**
  * sep_read_context -
- * @sctx: pointer to struct sep_system_ctx
+ * @ta_ctx: pointer to struct this_task_ctx
  * @msg_offset: point to current place in SEP msg; is updated
  * @dst: pointer to place to put the context
  * @len: size of the context structure (differs for crypro/hash)
@@ -873,16 +934,16 @@ return 0;
  * it skips over some words in the msg area depending on the size
  * of the context
  */
-static void sep_read_context(struct sep_system_ctx *sctx, u32 *msg_offset,
+static void sep_read_context(struct this_task_ctx *ta_ctx, u32 *msg_offset,
 	void *dst, u32 len)
 {
 	u32 max_length = ((len + 3) / sizeof(u32)) * sizeof(u32);
-	sep_read_msg(sctx, dst, len, max_length, msg_offset, 0);
+	sep_read_msg(ta_ctx, dst, len, max_length, msg_offset, 0);
 }
 
 /**
  * sep_write_context -
- * @sctx: pointer to struct sep_system_ctx
+ * @ta_ctx: pointer to struct this_task_ctx
  * @msg_offset: point to current place in SEP msg; is updated
  * @src: pointer to the current context
  * @len: size of the context structure (differs for crypro/hash)
@@ -892,76 +953,77 @@ static void sep_read_context(struct sep_system_ctx *sctx, u32 *msg_offset,
  * it skips over some words in the msg area depending on the size
  * of the context
  */
-static void sep_write_context(struct sep_system_ctx *sctx, u32 *msg_offset,
+static void sep_write_context(struct this_task_ctx *ta_ctx, u32 *msg_offset,
 	void *src, u32 len)
 {
 	u32 max_length = ((len + 3) / sizeof(u32)) * sizeof(u32);
-	sep_write_msg(sctx, src, len, max_length, msg_offset, 0);
+	sep_write_msg(ta_ctx, src, len, max_length, msg_offset, 0);
 }
 
 /**
  * sep_clear_out -
- * @sctx: pointer to struct sep_system_ctx
+ * @ta_ctx: pointer to struct this_task_ctx
  * Clear out crypto related values in sep device structure
  * to enable device to be used by anyone; either kernel
  * crypto or userspace app via middleware
  */
-static void sep_clear_out(struct sep_system_ctx *sctx)
+static void sep_clear_out(struct this_task_ctx *ta_ctx)
 {
-	if (sctx->src_sg_hold) {
-		sep_free_sg_buf(sctx->src_sg_hold);
-		sctx->src_sg_hold = NULL;
+	if (ta_ctx->src_sg_hold) {
+		sep_free_sg_buf(ta_ctx->src_sg_hold);
+		ta_ctx->src_sg_hold = NULL;
 	}
 
-	if (sctx->dst_sg_hold) {
-		sep_free_sg_buf(sctx->dst_sg_hold);
-		sctx->dst_sg_hold = NULL;
+	if (ta_ctx->dst_sg_hold) {
+		sep_free_sg_buf(ta_ctx->dst_sg_hold);
+		ta_ctx->dst_sg_hold = NULL;
 	}
 
-	sctx->src_sg = NULL;
-	sctx->dst_sg = NULL;
+	ta_ctx->src_sg = NULL;
+	ta_ctx->dst_sg = NULL;
 
-	sep_free_dma_table_data_handler(sctx->sep_used, &sctx->dma_ctx);
+	sep_free_dma_table_data_handler(ta_ctx->sep_used, &ta_ctx->dma_ctx);
 
-	if (sctx->i_own_sep) {
+	if (ta_ctx->i_own_sep) {
 		/**
 		 * The following unlocks the sep and makes it available
 		 * to any other application
 		 * First, null out crypto entries in sep before relesing it
 		 */
-		sctx->sep_used->current_hash_req = NULL;
-		sctx->sep_used->current_cypher_req = NULL;
-		sctx->sep_used->current_request = 0;
-		sctx->sep_used->current_hash_stage = 0;
-		sctx->sep_used->sctx = NULL;
-		sctx->sep_used->in_kernel = 0;
+		ta_ctx->sep_used->current_hash_req = NULL;
+		ta_ctx->sep_used->current_cypher_req = NULL;
+		ta_ctx->sep_used->current_request = 0;
+		ta_ctx->sep_used->current_hash_stage = 0;
+		ta_ctx->sep_used->ta_ctx = NULL;
+		ta_ctx->sep_used->in_kernel = 0;
 
-		sctx->call_status.status = 0;
+		ta_ctx->call_status.status = 0;
 
 		/* Remove anything confidentail */
-		memset(sctx->sep_used->shared_addr, 0,
+		memset(ta_ctx->sep_used->shared_addr, 0,
 			SEP_DRIVER_MESSAGE_SHARED_AREA_SIZE_IN_BYTES);
 
-		sep_queue_status_remove(sctx->sep_used, &sctx->queue_elem);
+		sep_queue_status_remove(ta_ctx->sep_used, &ta_ctx->queue_elem);
 
 #ifdef SEP_ENABLE_RUNTIME_PM
-		sctx->sep_used->in_use = 0;
-		pm_runtime_mark_last_busy(&sctx->sep_used->pdev->dev);
-		pm_runtime_put_autosuspend(&sctx->sep_used->pdev->dev);
+		ta_ctx->sep_used->in_use = 0;
+		pm_runtime_mark_last_busy(&ta_ctx->sep_used->pdev->dev);
+		pm_runtime_put_autosuspend(&ta_ctx->sep_used->pdev->dev);
 #endif
 
-		clear_bit(SEP_WORKING_LOCK_BIT, &sctx->sep_used->in_use_flags);
-		sctx->sep_used->pid_doing_transaction = 0;
+		clear_bit(SEP_WORKING_LOCK_BIT,
+			&ta_ctx->sep_used->in_use_flags);
+		ta_ctx->sep_used->pid_doing_transaction = 0;
 
-		dev_dbg(&sctx->sep_used->pdev->dev,
+		dev_dbg(&ta_ctx->sep_used->pdev->dev,
 			"[PID%d] waking up next transaction\n",
 			current->pid);
 
 		clear_bit(SEP_TRANSACTION_STARTED_LOCK_BIT,
-			&sctx->sep_used->in_use_flags);
-		wake_up(&sctx->sep_used->event_transactions);
+			&ta_ctx->sep_used->in_use_flags);
+		wake_up(&ta_ctx->sep_used->event_transactions);
 
-		sctx->i_own_sep = 0;
+		ta_ctx->i_own_sep = 0;
 	}
 }
 
@@ -969,22 +1031,34 @@ static void sep_clear_out(struct sep_system_ctx *sctx)
   * Release crypto infrastructure from EINPROGRESS and
   * clear sep_dev so that SEP is available to anyone
   */
-static void sep_crypto_release(struct sep_system_ctx *sctx, u32 error)
+static void sep_crypto_release(struct sep_system_ctx *sctx,
+	struct this_task_ctx *ta_ctx, u32 error)
 {
-	struct ahash_request *hash_req = sctx->current_hash_req;
+	struct ahash_request *hash_req = ta_ctx->current_hash_req;
 	struct ablkcipher_request *cypher_req =
-		sctx->current_cypher_req;
-	struct sep_device *sep = sctx->sep_used;
+		ta_ctx->current_cypher_req;
+	struct sep_device *sep = ta_ctx->sep_used;
+
+	sep_clear_out(ta_ctx);
 
-	sep_clear_out(sctx);
+	/**
+	 * This may not yet exist depending when we
+	 * chose to bail out. If it does exist, set
+	 * it to 1
+	 */
+	if (ta_ctx->are_we_done_yet != NULL)
+		*ta_ctx->are_we_done_yet = 1;
 
 	if (cypher_req != NULL) {
-		if (cypher_req->base.complete == NULL) {
-			dev_dbg(&sep->pdev->dev,
-				"release is null for cypher!");
-		} else {
-			cypher_req->base.complete(
-				&cypher_req->base, error);
+		if ((sctx->key_sent == 1) ||
+			((error != 0) && (error != -EINPROGRESS))) {
+			if (cypher_req->base.complete == NULL) {
+				dev_dbg(&sep->pdev->dev,
+					"release is null for cypher!");
+			} else {
+				cypher_req->base.complete(
+					&cypher_req->base, error);
+			}
 		}
 	}
 
@@ -1005,20 +1079,20 @@ static void sep_crypto_release(struct sep_system_ctx *sctx, u32 error)
  *	and it will return 0 if sep is now ours; error value if there
  *	were problems
  */
-static int sep_crypto_take_sep(struct sep_system_ctx *sctx)
+static int sep_crypto_take_sep(struct this_task_ctx *ta_ctx)
 {
-	struct sep_device *sep = sctx->sep_used;
+	struct sep_device *sep = ta_ctx->sep_used;
 	int result;
 	struct sep_msgarea_hdr *my_msg_header;
 
-	my_msg_header = (struct sep_msgarea_hdr *)sctx->msg;
+	my_msg_header = (struct sep_msgarea_hdr *)ta_ctx->msg;
 
 	/* add to status queue */
-	sctx->queue_elem = sep_queue_status_add(sep, my_msg_header->opcode,
-		sctx->nbytes, current->pid,
+	ta_ctx->queue_elem = sep_queue_status_add(sep, my_msg_header->opcode,
+		ta_ctx->nbytes, current->pid,
 		current->comm, sizeof(current->comm));
 
-	if (!sctx->queue_elem) {
+	if (!ta_ctx->queue_elem) {
 		dev_dbg(&sep->pdev->dev, "[PID%d] updating queue"
 			" status error\n", current->pid);
 		return -EINVAL;
@@ -1033,48 +1107,61 @@ static int sep_crypto_take_sep(struct sep_system_ctx *sctx)
 		pm_runtime_get_sync(&sep_dev->pdev->dev);
 
 	/* Copy in the message */
-	memcpy(sep->shared_addr, sctx->msg,
+	memcpy(sep->shared_addr, ta_ctx->msg,
 		SEP_DRIVER_MESSAGE_SHARED_AREA_SIZE_IN_BYTES);
 
 	/* Copy in the dcb information if there is any */
-	if (sctx->dcb_region) {
+	if (ta_ctx->dcb_region) {
 		result = sep_activate_dcb_dmatables_context(sep,
-			&sctx->dcb_region, &sctx->dmatables_region,
-			sctx->dma_ctx);
+			&ta_ctx->dcb_region, &ta_ctx->dmatables_region,
+			ta_ctx->dma_ctx);
 		if (result)
 			return result;
 	}
 
 	/* Mark the device so we know how to finish the job in the tasklet */
-	if (sctx->current_hash_req)
-		sep->current_hash_req = sctx->current_hash_req;
+	if (ta_ctx->current_hash_req)
+		sep->current_hash_req = ta_ctx->current_hash_req;
 	else
-		sep->current_cypher_req = sctx->current_cypher_req;
+		sep->current_cypher_req = ta_ctx->current_cypher_req;
 
-	sep->current_request = sctx->current_request;
-	sep->current_hash_stage = sctx->current_hash_stage;
-	sep->sctx = sctx;
+	sep->current_request = ta_ctx->current_request;
+	sep->current_hash_stage = ta_ctx->current_hash_stage;
+	sep->ta_ctx = ta_ctx;
 	sep->in_kernel = 1;
-	sctx->i_own_sep = 1;
+	ta_ctx->i_own_sep = 1;
+
+	/* need to set bit first to avoid race condition with interrupt */
+	set_bit(SEP_LEGACY_SENDMSG_DONE_OFFSET, &ta_ctx->call_status.status);
 
 	result = sep_send_command_handler(sep);
 
 	dev_dbg(&sep->pdev->dev, "[PID%d]: sending command to the sep\n",
 		current->pid);
 
-	if (!result) {
-		set_bit(SEP_LEGACY_SENDMSG_DONE_OFFSET,
-			&sctx->call_status.status);
+	if (!result)
 		dev_dbg(&sep->pdev->dev, "[PID%d]: command sent okay\n",
 			current->pid);
+	else {
+		dev_dbg(&sep->pdev->dev, "[PID%d]: cant send command\n",
+			current->pid);
+		clear_bit(SEP_LEGACY_SENDMSG_DONE_OFFSET,
+			&ta_ctx->call_status.status);
 	}
 
 	return result;
 }
 
-/* This needs to be run as a work queue as it can be put asleep */
-static void sep_crypto_block(void *data)
+/**
+ * This function sets things up for a crypto data block process
+ * This does all preparation, but does not try to grab the
+ * sep
+ * @req: pointer to struct ablkcipher_request
+ * returns: 0 if all went well, non zero if error
+ */
+static int sep_crypto_block_data(struct ablkcipher_request *req)
 {
+
 	int int_error;
 	u32 msg_offset;
 	static u32 msg[10];
@@ -1085,318 +1172,440 @@ static void sep_crypto_block(void *data)
 	ssize_t copy_result;
 	int result;
 
-	u32 max_length;
 	struct scatterlist *new_sg;
-	struct ablkcipher_request *req;
-	struct sep_block_ctx *bctx;
+	struct this_task_ctx *ta_ctx;
 	struct crypto_ablkcipher *tfm;
 	struct sep_system_ctx *sctx;
 
-	req = (struct ablkcipher_request *)data;
-	bctx = ablkcipher_request_ctx(req);
+	struct sep_des_internal_context *des_internal;
+	struct sep_aes_internal_context *aes_internal;
+
+	ta_ctx = ablkcipher_request_ctx(req);
 	tfm = crypto_ablkcipher_reqtfm(req);
 	sctx = crypto_ablkcipher_ctx(tfm);
 
 	/* start the walk on scatterlists */
-	ablkcipher_walk_init(&bctx->walk, req->src, req->dst, req->nbytes);
-	dev_dbg(&sctx->sep_used->pdev->dev, "sep crypto block data size of %x\n",
+	ablkcipher_walk_init(&ta_ctx->walk, req->src, req->dst, req->nbytes);
+	dev_dbg(&ta_ctx->sep_used->pdev->dev, "sep crypto block data size of %x\n",
 		req->nbytes);
 
-	int_error = ablkcipher_walk_phys(req, &bctx->walk);
+	int_error = ablkcipher_walk_phys(req, &ta_ctx->walk);
 	if (int_error) {
-		dev_warn(&sctx->sep_used->pdev->dev, "walk phys error %x\n",
+		dev_warn(&ta_ctx->sep_used->pdev->dev, "walk phys error %x\n",
 			int_error);
-		sep_crypto_release(sctx, -ENOMEM);
-		return;
-	}
-
-	/* check iv */
-	if (bctx->des_opmode == SEP_DES_CBC) {
-		if (!bctx->walk.iv) {
-			dev_warn(&sctx->sep_used->pdev->dev, "no iv found\n");
-			sep_crypto_release(sctx, -EINVAL);
-			return;
-		}
-
-		memcpy(bctx->iv, bctx->walk.iv, SEP_DES_IV_SIZE_BYTES);
-		sep_dump(sctx->sep_used, "iv", bctx->iv, SEP_DES_IV_SIZE_BYTES);
-	}
-
-	if (bctx->aes_opmode == SEP_AES_CBC) {
-		if (!bctx->walk.iv) {
-			dev_warn(&sctx->sep_used->pdev->dev, "no iv found\n");
-			sep_crypto_release(sctx, -EINVAL);
-			return;
-		}
-
-		memcpy(bctx->iv, bctx->walk.iv, SEP_AES_IV_SIZE_BYTES);
-		sep_dump(sctx->sep_used, "iv", bctx->iv, SEP_AES_IV_SIZE_BYTES);
+		return -ENOMEM;
 	}
 
-	dev_dbg(&sctx->sep_used->pdev->dev,
+	dev_dbg(&ta_ctx->sep_used->pdev->dev,
 		"crypto block: src is %lx dst is %lx\n",
 		(unsigned long)req->src, (unsigned long)req->dst);
 
 	/* Make sure all pages are even block */
-	int_error = sep_oddball_pages(sctx->sep_used, req->src,
-		req->nbytes, bctx->walk.blocksize, &new_sg, 1);
+	int_error = sep_oddball_pages(ta_ctx->sep_used, req->src,
+		req->nbytes, ta_ctx->walk.blocksize, &new_sg, 1);
 
 	if (int_error < 0) {
-		dev_warn(&sctx->sep_used->pdev->dev, "oddball page eerror\n");
-		sep_crypto_release(sctx, -ENOMEM);
-		return;
+		dev_warn(&ta_ctx->sep_used->pdev->dev, "oddball page eerror\n");
+		return -ENOMEM;
 	} else if (int_error == 1) {
-		sctx->src_sg = new_sg;
-		sctx->src_sg_hold = new_sg;
+		ta_ctx->src_sg = new_sg;
+		ta_ctx->src_sg_hold = new_sg;
 	} else {
-		sctx->src_sg = req->src;
-		sctx->src_sg_hold = NULL;
+		ta_ctx->src_sg = req->src;
+		ta_ctx->src_sg_hold = NULL;
 	}
 
-	int_error = sep_oddball_pages(sctx->sep_used, req->dst,
-		req->nbytes, bctx->walk.blocksize, &new_sg, 0);
+	int_error = sep_oddball_pages(ta_ctx->sep_used, req->dst,
+		req->nbytes, ta_ctx->walk.blocksize, &new_sg, 0);
 
 	if (int_error < 0) {
-		dev_warn(&sctx->sep_used->pdev->dev, "walk phys error %x\n",
+		dev_warn(&ta_ctx->sep_used->pdev->dev, "walk phys error %x\n",
 			int_error);
-		sep_crypto_release(sctx, -ENOMEM);
-		return;
+		return -ENOMEM;
 	} else if (int_error == 1) {
-		sctx->dst_sg = new_sg;
-		sctx->dst_sg_hold = new_sg;
+		ta_ctx->dst_sg = new_sg;
+		ta_ctx->dst_sg_hold = new_sg;
 	} else {
-		sctx->dst_sg = req->dst;
-		sctx->dst_sg_hold = NULL;
+		ta_ctx->dst_sg = req->dst;
+		ta_ctx->dst_sg_hold = NULL;
 	}
 
-	/* Do we need to perform init; ie; send key to sep? */
-	if (sctx->key_sent == 0) {
+	/* set nbytes for queue status */
+	ta_ctx->nbytes = req->nbytes;
 
-		dev_dbg(&sctx->sep_used->pdev->dev, "sending key\n");
+	/* Key already done; this is for data */
+	dev_dbg(&ta_ctx->sep_used->pdev->dev, "sending data\n");
 
-		/* put together message to SEP */
-		/* Start with op code */
-		sep_make_header(sctx, &msg_offset, bctx->init_opcode);
+	sep_dump_sg(ta_ctx->sep_used,
+		"block sg in", ta_ctx->src_sg);
 
-		/* now deal with IV */
-		if (bctx->init_opcode == SEP_DES_INIT_OPCODE) {
-			if (bctx->des_opmode == SEP_DES_CBC) {
-				sep_write_msg(sctx, bctx->iv,
-					SEP_DES_IV_SIZE_BYTES, sizeof(u32) * 4,
-					&msg_offset, 1);
-				sep_dump(sctx->sep_used, "initial IV",
-					bctx->walk.iv, SEP_DES_IV_SIZE_BYTES);
-			} else {
-				/* Skip if ECB */
-				msg_offset += 4 * sizeof(u32);
-			}
-		} else {
-			max_length = ((SEP_AES_IV_SIZE_BYTES + 3) /
-				sizeof(u32)) * sizeof(u32);
-			if (bctx->aes_opmode == SEP_AES_CBC) {
-				sep_write_msg(sctx, bctx->iv,
-					SEP_AES_IV_SIZE_BYTES, max_length,
-					&msg_offset, 1);
-				sep_dump(sctx->sep_used, "initial IV",
-					bctx->walk.iv, SEP_AES_IV_SIZE_BYTES);
-			} else {
-				/* Skip if ECB */
-				msg_offset += max_length;
-			}
-		}
+	/* check for valid data and proper spacing */
+	src_ptr = sg_virt(ta_ctx->src_sg);
+	dst_ptr = sg_virt(ta_ctx->dst_sg);
 
-		/* load the key */
-		if (bctx->init_opcode == SEP_DES_INIT_OPCODE) {
-			sep_write_msg(sctx, (void *)&sctx->key.des.key1,
-				sizeof(u32) * 8, sizeof(u32) * 8,
-				&msg_offset, 1);
+	if (!src_ptr || !dst_ptr ||
+		(ta_ctx->current_cypher_req->nbytes %
+		crypto_ablkcipher_blocksize(tfm))) {
+
+		dev_warn(&ta_ctx->sep_used->pdev->dev,
+			"cipher block size odd\n");
+		dev_warn(&ta_ctx->sep_used->pdev->dev,
+			"cipher block size is %x\n",
+			crypto_ablkcipher_blocksize(tfm));
+		dev_warn(&ta_ctx->sep_used->pdev->dev,
+			"cipher data size is %x\n",
+			ta_ctx->current_cypher_req->nbytes);
+		return -EINVAL;
+	}
 
-			msg[0] = (u32)sctx->des_nbr_keys;
-			msg[1] = (u32)bctx->des_encmode;
-			msg[2] = (u32)bctx->des_opmode;
+	if (partial_overlap(src_ptr, dst_ptr,
+		ta_ctx->current_cypher_req->nbytes)) {
+		dev_warn(&ta_ctx->sep_used->pdev->dev,
+			"block partial overlap\n");
+		return -EINVAL;
+	}
 
-			sep_write_msg(sctx, (void *)msg,
-				sizeof(u32) * 3, sizeof(u32) * 3,
-				&msg_offset, 0);
-		} else {
-			sep_write_msg(sctx, (void *)&sctx->key.aes,
-				sctx->keylen,
-				SEP_AES_MAX_KEY_SIZE_BYTES,
-				&msg_offset, 1);
+	/* Put together the message */
+	sep_make_header(ta_ctx, &msg_offset, ta_ctx->block_opcode);
+
+	/* If des, and size is 1 block, put directly in msg */
+	if ((ta_ctx->block_opcode == SEP_DES_BLOCK_OPCODE) &&
+		(req->nbytes == crypto_ablkcipher_blocksize(tfm))) {
+
+		dev_dbg(&ta_ctx->sep_used->pdev->dev,
+			"writing out one block des\n");
+
+		copy_result = sg_copy_to_buffer(
+			ta_ctx->src_sg, sep_sg_nents(ta_ctx->src_sg),
+			small_buf, crypto_ablkcipher_blocksize(tfm));
 
-			msg[0] = (u32)sctx->aes_key_size;
-			msg[1] = (u32)bctx->aes_encmode;
-			msg[2] = (u32)bctx->aes_opmode;
-			msg[3] = (u32)0; /* Secret key is not used */
-			sep_write_msg(sctx, (void *)msg,
-				sizeof(u32) * 4, sizeof(u32) * 4,
-				&msg_offset, 0);
+		if (copy_result != crypto_ablkcipher_blocksize(tfm)) {
+			dev_warn(&ta_ctx->sep_used->pdev->dev,
+				"des block copy faild\n");
+			return -ENOMEM;
 		}
 
+		/* Put data into message */
+		sep_write_msg(ta_ctx, small_buf,
+			crypto_ablkcipher_blocksize(tfm),
+			crypto_ablkcipher_blocksize(tfm) * 2,
+			&msg_offset, 1);
+
+		/* Put size into message */
+		sep_write_msg(ta_ctx, &req->nbytes,
+			sizeof(u32), sizeof(u32), &msg_offset, 0);
 	} else {
+		/* Otherwise, fill out dma tables */
+		ta_ctx->dcb_input_data.app_in_address = src_ptr;
+		ta_ctx->dcb_input_data.data_in_size = req->nbytes;
+		ta_ctx->dcb_input_data.app_out_address = dst_ptr;
+		ta_ctx->dcb_input_data.block_size =
+			crypto_ablkcipher_blocksize(tfm);
+		ta_ctx->dcb_input_data.tail_block_size = 0;
+		ta_ctx->dcb_input_data.is_applet = 0;
+		ta_ctx->dcb_input_data.src_sg = ta_ctx->src_sg;
+		ta_ctx->dcb_input_data.dst_sg = ta_ctx->dst_sg;
+
+		result = sep_create_dcb_dmatables_context_kernel(
+			ta_ctx->sep_used,
+			&ta_ctx->dcb_region,
+			&ta_ctx->dmatables_region,
+			&ta_ctx->dma_ctx,
+			&ta_ctx->dcb_input_data,
+			1);
+		if (result) {
+			dev_warn(&ta_ctx->sep_used->pdev->dev,
+				"crypto dma table create failed\n");
+			return -EINVAL;
+		}
+
+		/* Portion of msg is nulled (no data) */
+		msg[0] = (u32)0;
+		msg[1] = (u32)0;
+		msg[2] = (u32)0;
+		msg[3] = (u32)0;
+		msg[4] = (u32)0;
+		sep_write_msg(ta_ctx, (void *)msg, sizeof(u32) * 5,
+			sizeof(u32) * 5, &msg_offset, 0);
+		}
 
-		/* set nbytes for queue status */
-		sctx->nbytes = req->nbytes;
+	/**
+	 * Before we write the message, we need to overwrite the
+	 * vendor's IV with the one from our own ablkcipher walk
+	 * iv because this is needed for dm-crypt
+	 */
+	sep_dump_ivs(req, "sending data block to sep\n");
+	if ((ta_ctx->current_request == DES_CBC) &&
+		(ta_ctx->des_opmode == SEP_DES_CBC)) {
+
+		dev_dbg(&ta_ctx->sep_used->pdev->dev,
+			"overwrite vendor iv on DES\n");
+		des_internal = (struct sep_des_internal_context *)
+			sctx->des_private_ctx.ctx_buf;
+		memcpy((void *)des_internal->iv_context,
+			ta_ctx->walk.iv, crypto_ablkcipher_ivsize(tfm));
+	} else if ((ta_ctx->current_request == AES_CBC) &&
+		(ta_ctx->aes_opmode == SEP_AES_CBC)) {
+
+		dev_dbg(&ta_ctx->sep_used->pdev->dev,
+			"overwrite vendor iv on AES\n");
+		aes_internal = (struct sep_aes_internal_context *)
+			sctx->aes_private_ctx.cbuff;
+		memcpy((void *)aes_internal->aes_ctx_iv,
+			ta_ctx->walk.iv, crypto_ablkcipher_ivsize(tfm));
+	}
+
+	/* Write context into message */
+	if (ta_ctx->block_opcode == SEP_DES_BLOCK_OPCODE) {
+		sep_write_context(ta_ctx, &msg_offset,
+			&sctx->des_private_ctx,
+			sizeof(struct sep_des_private_context));
+		sep_dump(ta_ctx->sep_used, "ctx to block des",
+			&sctx->des_private_ctx, 40);
+	} else {
+		sep_write_context(ta_ctx, &msg_offset,
+			&sctx->aes_private_ctx,
+			sizeof(struct sep_aes_private_context));
+		sep_dump(ta_ctx->sep_used, "ctx to block aes",
+			&sctx->aes_private_ctx, 20);
+	}
 
-		/* Key already done; this is for data */
-		dev_dbg(&sctx->sep_used->pdev->dev, "sending data\n");
+	/* conclude message */
+	sep_end_msg(ta_ctx, msg_offset);
 
-		sep_dump_sg(sctx->sep_used,
-			"block sg in", sctx->src_sg);
+	/* Parent (caller) is now ready to tell the sep to do ahead */
+	return 0;
+}
 
-		/* check for valid data and proper spacing */
-		src_ptr = sg_virt(sctx->src_sg);
-		dst_ptr = sg_virt(sctx->dst_sg);
 
-		if (!src_ptr || !dst_ptr ||
-			(sctx->current_cypher_req->nbytes %
-			crypto_ablkcipher_blocksize(tfm))) {
+/**
+ * This function sets things up for a crypto key submit process
+ * This does all preparation, but does not try to grab the
+ * sep
+ * @req: pointer to struct ablkcipher_request
+ * returns: 0 if all went well, non zero if error
+ */
+static int sep_crypto_send_key(struct ablkcipher_request *req)
+{
 
-			dev_warn(&sctx->sep_used->pdev->dev,
-				"cipher block size odd\n");
-			dev_warn(&sctx->sep_used->pdev->dev,
-				"cipher block size is %x\n",
-				crypto_ablkcipher_blocksize(tfm));
-			dev_warn(&sctx->sep_used->pdev->dev,
-				"cipher data size is %x\n",
-				sctx->current_cypher_req->nbytes);
-			sep_crypto_release(sctx, -EINVAL);
-			return;
-		}
+	int int_error;
+	u32 msg_offset;
+	static u32 msg[10];
 
-		if (partial_overlap(src_ptr, dst_ptr,
-			sctx->current_cypher_req->nbytes)) {
-			dev_warn(&sctx->sep_used->pdev->dev,
-				"block partial overlap\n");
-			sep_crypto_release(sctx, -EINVAL);
-			return;
-		}
+	u32 max_length;
+	struct this_task_ctx *ta_ctx;
+	struct crypto_ablkcipher *tfm;
+	struct sep_system_ctx *sctx;
 
-		/* Put together the message */
-		sep_make_header(sctx, &msg_offset, bctx->block_opcode);
+	ta_ctx = ablkcipher_request_ctx(req);
+	tfm = crypto_ablkcipher_reqtfm(req);
+	sctx = crypto_ablkcipher_ctx(tfm);
 
-		/* If des, and size is 1 block, put directly in msg */
-		if ((bctx->block_opcode == SEP_DES_BLOCK_OPCODE) &&
-			(req->nbytes == crypto_ablkcipher_blocksize(tfm))) {
+	dev_dbg(&ta_ctx->sep_used->pdev->dev, "sending key\n");
 
-			dev_dbg(&sctx->sep_used->pdev->dev,
-				"writing out one block des\n");
+	/* start the walk on scatterlists */
+	ablkcipher_walk_init(&ta_ctx->walk, req->src, req->dst, req->nbytes);
+	dev_dbg(&ta_ctx->sep_used->pdev->dev,
+		"sep crypto block data size of %x\n", req->nbytes);
 
-			copy_result = sg_copy_to_buffer(
-				sctx->src_sg, sep_sg_nents(sctx->src_sg),
-				small_buf, crypto_ablkcipher_blocksize(tfm));
+	int_error = ablkcipher_walk_phys(req, &ta_ctx->walk);
+	if (int_error) {
+		dev_warn(&ta_ctx->sep_used->pdev->dev, "walk phys error %x\n",
+			int_error);
+		return -ENOMEM;
+	}
 
-			if (copy_result != crypto_ablkcipher_blocksize(tfm)) {
-				dev_warn(&sctx->sep_used->pdev->dev,
-					"des block copy faild\n");
-				sep_crypto_release(sctx, -ENOMEM);
-				return;
-			}
+	/* check iv */
+	if ((ta_ctx->current_request == DES_CBC) &&
+		(ta_ctx->des_opmode == SEP_DES_CBC)) {
+		if (!ta_ctx->walk.iv) {
+			dev_warn(&ta_ctx->sep_used->pdev->dev, "no iv found\n");
+			return -EINVAL;
+		}
 
-			/* Put data into message */
-			sep_write_msg(sctx, small_buf,
-				crypto_ablkcipher_blocksize(tfm),
-				crypto_ablkcipher_blocksize(tfm) * 2,
-				&msg_offset, 1);
+		memcpy(ta_ctx->iv, ta_ctx->walk.iv, SEP_DES_IV_SIZE_BYTES);
+		sep_dump(ta_ctx->sep_used, "iv",
+			ta_ctx->iv, SEP_DES_IV_SIZE_BYTES);
+	}
 
-			/* Put size into message */
-			sep_write_msg(sctx, &req->nbytes,
-				sizeof(u32), sizeof(u32), &msg_offset, 0);
+	if ((ta_ctx->current_request == AES_CBC) &&
+		(ta_ctx->aes_opmode == SEP_AES_CBC)) {
+		if (!ta_ctx->walk.iv) {
+			dev_warn(&ta_ctx->sep_used->pdev->dev, "no iv found\n");
+			return -EINVAL;
+		}
+
+		memcpy(ta_ctx->iv, ta_ctx->walk.iv, SEP_AES_IV_SIZE_BYTES);
+		sep_dump(ta_ctx->sep_used, "iv",
+			ta_ctx->iv, SEP_AES_IV_SIZE_BYTES);
+	}
+
+	/* put together message to SEP */
+	/* Start with op code */
+	sep_make_header(ta_ctx, &msg_offset, ta_ctx->init_opcode);
+
+	/* now deal with IV */
+	if (ta_ctx->init_opcode == SEP_DES_INIT_OPCODE) {
+		if (ta_ctx->des_opmode == SEP_DES_CBC) {
+			sep_write_msg(ta_ctx, ta_ctx->iv,
+				SEP_DES_IV_SIZE_BYTES, sizeof(u32) * 4,
+				&msg_offset, 1);
+			sep_dump(ta_ctx->sep_used, "initial IV",
+				ta_ctx->walk.iv, SEP_DES_IV_SIZE_BYTES);
+		} else {
+			/* Skip if ECB */
+			msg_offset += 4 * sizeof(u32);
+		}
+	} else {
+		max_length = ((SEP_AES_IV_SIZE_BYTES + 3) /
+			sizeof(u32)) * sizeof(u32);
+		if (ta_ctx->aes_opmode == SEP_AES_CBC) {
+			sep_write_msg(ta_ctx, ta_ctx->iv,
+				SEP_AES_IV_SIZE_BYTES, max_length,
+				&msg_offset, 1);
+			sep_dump(ta_ctx->sep_used, "initial IV",
+				ta_ctx->walk.iv, SEP_AES_IV_SIZE_BYTES);
 		} else {
-			/* Otherwise, fill out dma tables */
-			sctx->dcb_input_data.app_in_address = src_ptr;
-			sctx->dcb_input_data.data_in_size = req->nbytes;
-			sctx->dcb_input_data.app_out_address = dst_ptr;
-			sctx->dcb_input_data.block_size =
-				crypto_ablkcipher_blocksize(tfm);
-			sctx->dcb_input_data.tail_block_size = 0;
-			sctx->dcb_input_data.is_applet = 0;
-			sctx->dcb_input_data.src_sg = sctx->src_sg;
-			sctx->dcb_input_data.dst_sg = sctx->dst_sg;
-
-			result = sep_create_dcb_dmatables_context_kernel(
-				sctx->sep_used,
-				&sctx->dcb_region,
-				&sctx->dmatables_region,
-				&sctx->dma_ctx,
-				&sctx->dcb_input_data,
-				1);
-			if (result) {
-				dev_warn(&sctx->sep_used->pdev->dev,
-					"crypto dma table create failed\n");
-				sep_crypto_release(sctx, -EINVAL);
-				return;
+				/* Skip if ECB */
+				msg_offset += max_length;
 			}
+		}
+
+	/* load the key */
+	if (ta_ctx->init_opcode == SEP_DES_INIT_OPCODE) {
+		sep_write_msg(ta_ctx, (void *)&sctx->key.des.key1,
+			sizeof(u32) * 8, sizeof(u32) * 8,
+			&msg_offset, 1);
+
+		msg[0] = (u32)sctx->des_nbr_keys;
+		msg[1] = (u32)ta_ctx->des_encmode;
+		msg[2] = (u32)ta_ctx->des_opmode;
 
-			/* Portion of msg is nulled (no data) */
-			msg[0] = (u32)0;
-			msg[1] = (u32)0;
-			msg[2] = (u32)0;
-			msg[3] = (u32)0;
-			msg[4] = (u32)0;
-			sep_write_msg(sctx, (void *)msg,
-				sizeof(u32) * 5,
-				sizeof(u32) * 5,
-				&msg_offset, 0);
+		sep_write_msg(ta_ctx, (void *)msg,
+			sizeof(u32) * 3, sizeof(u32) * 3,
+			&msg_offset, 0);
+	} else {
+		sep_write_msg(ta_ctx, (void *)&sctx->key.aes,
+			sctx->keylen,
+			SEP_AES_MAX_KEY_SIZE_BYTES,
+			&msg_offset, 1);
+
+		msg[0] = (u32)sctx->aes_key_size;
+		msg[1] = (u32)ta_ctx->aes_encmode;
+		msg[2] = (u32)ta_ctx->aes_opmode;
+		msg[3] = (u32)0; /* Secret key is not used */
+		sep_write_msg(ta_ctx, (void *)msg,
+			sizeof(u32) * 4, sizeof(u32) * 4,
+			&msg_offset, 0);
+	}
+
+	/* conclude message */
+	sep_end_msg(ta_ctx, msg_offset);
+
+	/* Parent (caller) is now ready to tell the sep to do ahead */
+	return 0;
+}
+
+
+/* This needs to be run as a work queue as it can be put asleep */
+static void sep_crypto_block(void *data)
+{
+	unsigned long end_time;
+
+	int result;
+
+	struct ablkcipher_request *req;
+	struct this_task_ctx *ta_ctx;
+	struct crypto_ablkcipher *tfm;
+	struct sep_system_ctx *sctx;
+	int are_we_done_yet;
+
+	req = (struct ablkcipher_request *)data;
+	ta_ctx = ablkcipher_request_ctx(req);
+	tfm = crypto_ablkcipher_reqtfm(req);
+	sctx = crypto_ablkcipher_ctx(tfm);
+
+	ta_ctx->are_we_done_yet = &are_we_done_yet;
+
+	pr_debug("sep_crypto_block\n");
+	pr_debug("tfm is %p sctx is %p ta_ctx is %p\n",
+		tfm, sctx, ta_ctx);
+	pr_debug("key_sent is %d\n", sctx->key_sent);
+
+	/* do we need to send the key */
+	if (sctx->key_sent == 0) {
+		are_we_done_yet = 0;
+		result = sep_crypto_send_key(req); /* prep to send key */
+		if (result != 0) {
+			dev_dbg(&ta_ctx->sep_used->pdev->dev,
+				"could not prep key %x\n", result);
+			sep_crypto_release(sctx, ta_ctx, result);
+			return;
 		}
 
-		/* Write context into message */
-		if (bctx->block_opcode == SEP_DES_BLOCK_OPCODE) {
-			sep_write_context(sctx, &msg_offset,
-				&bctx->des_private_ctx,
-				sizeof(struct sep_des_private_context));
-			sep_dump(sctx->sep_used, "ctx to block des",
-				&bctx->des_private_ctx, 40);
-		} else {
-			sep_write_context(sctx, &msg_offset,
-				&bctx->aes_private_ctx,
-				sizeof(struct sep_aes_private_context));
-			sep_dump(sctx->sep_used, "ctx to block aes",
-				&bctx->aes_private_ctx, 20);
+		result = sep_crypto_take_sep(ta_ctx);
+		if (result) {
+			dev_warn(&ta_ctx->sep_used->pdev->dev,
+				"sep_crypto_take_sep for key send failed\n");
+			sep_crypto_release(sctx, ta_ctx, result);
+			return;
+		}
+
+		/* now we sit and wait up to a fixed time for completion */
+		end_time = jiffies + (WAIT_TIME * HZ);
+		while ((time_before(jiffies, end_time)) &&
+			(are_we_done_yet == 0))
+			schedule();
+
+		/* Done waiting; still not done yet? */
+		if (are_we_done_yet == 0) {
+			dev_dbg(&ta_ctx->sep_used->pdev->dev,
+				"Send key job never got done\n");
+			sep_crypto_release(sctx, ta_ctx, -EINVAL);
+			return;
 		}
+
+		/* Set the key sent variable so this can be skipped later */
+		sctx->key_sent = 1;
 	}
 
-	/* conclude message and then tell sep to do its thing */
-	sctx->done_with_transaction = 0;
+	/* Key sent (or maybe not if we did not have to), now send block */
+	are_we_done_yet = 0;
 
-	sep_end_msg(sctx, msg_offset);
-	result = sep_crypto_take_sep(sctx);
-	if (result) {
-		dev_warn(&sctx->sep_used->pdev->dev,
-			"sep_crypto_take_sep failed\n");
-		sep_crypto_release(sctx, -EINVAL);
+	result = sep_crypto_block_data(req);
+
+	if (result != 0) {
+		dev_dbg(&ta_ctx->sep_used->pdev->dev,
+			"could prep not send block %x\n", result);
+		sep_crypto_release(sctx, ta_ctx, result);
 		return;
 	}
 
-	/**
-	 * Sep is now working. Lets wait up to 5 seconds
-	 * for completion. If it does not complete, we will do
-	 * a crypto release with -EINVAL to release the
-	 * kernel crypto infrastructure and let the system
-	 * continue to boot up
-	 * We have to wait this long because some crypto
-	 * operations can take a while
-	 */
-
-	dev_dbg(&sctx->sep_used->pdev->dev,
-		"waiting for done with transaction\n");
+	result = sep_crypto_take_sep(ta_ctx);
+	if (result) {
+		dev_warn(&ta_ctx->sep_used->pdev->dev,
+			"sep_crypto_take_sep for block send failed\n");
+		sep_crypto_release(sctx, ta_ctx, result);
+		return;
+	}
 
-	sctx->end_time = jiffies + (SEP_TRANSACTION_WAIT_TIME * HZ);
-	while ((time_before(jiffies, sctx->end_time)) &&
-		(!sctx->done_with_transaction))
+	/* now we sit and wait up to a fixed time for completion */
+	end_time = jiffies + (WAIT_TIME * HZ);
+	while ((time_before(jiffies, end_time)) && (are_we_done_yet == 0))
 		schedule();
 
-	dev_dbg(&sctx->sep_used->pdev->dev,
-		"done waiting for done with transaction\n");
-
-	/* are we done? */
-	if (!sctx->done_with_transaction) {
-		/* Nope, lets release and tell crypto no */
-		dev_warn(&sctx->sep_used->pdev->dev,
-			"[PID%d] sep_crypto_block never finished\n",
-			current->pid);
-		sep_crypto_release(sctx, -EINVAL);
+	/* Done waiting; still not done yet? */
+	if (are_we_done_yet == 0) {
+		dev_dbg(&ta_ctx->sep_used->pdev->dev,
+			"Send block job never got done\n");
+		sep_crypto_release(sctx, ta_ctx, -EINVAL);
+		return;
 	}
+
+	/* That's it; entire thing done, get out of queue */
+
+	pr_debug("crypto_block leaving\n");
+	pr_debug("tfm is %p sctx is %p ta_ctx is %p\n", tfm, sctx, ta_ctx);
 }
 
 /**
@@ -1405,7 +1614,6 @@ static void sep_crypto_block(void *data)
 static u32 crypto_post_op(struct sep_device *sep)
 {
 	/* HERE */
-	int int_error;
 	u32 u32_error;
 	u32 msg_offset;
 
@@ -1413,169 +1621,185 @@ static u32 crypto_post_op(struct sep_device *sep)
 	static char small_buf[100];
 
 	struct ablkcipher_request *req;
-	struct sep_block_ctx *bctx;
+	struct this_task_ctx *ta_ctx;
 	struct sep_system_ctx *sctx;
 	struct crypto_ablkcipher *tfm;
 
+	struct sep_des_internal_context *des_internal;
+	struct sep_aes_internal_context *aes_internal;
+
 	if (!sep->current_cypher_req)
 		return -EINVAL;
 
 	/* hold req since we need to submit work after clearing sep */
 	req = sep->current_cypher_req;
 
-	bctx = ablkcipher_request_ctx(sep->current_cypher_req);
+	ta_ctx = ablkcipher_request_ctx(sep->current_cypher_req);
 	tfm = crypto_ablkcipher_reqtfm(sep->current_cypher_req);
 	sctx = crypto_ablkcipher_ctx(tfm);
 
-	dev_dbg(&sctx->sep_used->pdev->dev, "crypto post_op\n");
-	dev_dbg(&sctx->sep_used->pdev->dev, "crypto post_op message dump\n");
-	crypto_sep_dump_message(sctx);
+	pr_debug("crypto_post op\n");
+	pr_debug("key_sent is %d tfm is %p sctx is %p ta_ctx is %p\n",
+		sctx->key_sent, tfm, sctx, ta_ctx);
 
-	sctx->done_with_transaction = 1;
+	dev_dbg(&ta_ctx->sep_used->pdev->dev, "crypto post_op\n");
+	dev_dbg(&ta_ctx->sep_used->pdev->dev, "crypto post_op message dump\n");
+	crypto_sep_dump_message(ta_ctx->sep_used, ta_ctx->msg);
 
 	/* first bring msg from shared area to local area */
-	memcpy(sctx->msg, sep->shared_addr,
+	memcpy(ta_ctx->msg, sep->shared_addr,
 		SEP_DRIVER_MESSAGE_SHARED_AREA_SIZE_IN_BYTES);
 
 	/* Is this the result of performing init (key to SEP */
 	if (sctx->key_sent == 0) {
 
 		/* Did SEP do it okay */
-		u32_error = sep_verify_op(sctx, bctx->init_opcode,
+		u32_error = sep_verify_op(ta_ctx, ta_ctx->init_opcode,
 			&msg_offset);
 		if (u32_error) {
-			dev_warn(&sctx->sep_used->pdev->dev,
+			dev_warn(&ta_ctx->sep_used->pdev->dev,
 				"aes init error %x\n", u32_error);
-			sep_crypto_release(sctx, u32_error);
+			sep_crypto_release(sctx, ta_ctx, u32_error);
 			return u32_error;
 			}
 
 		/* Read Context */
-		if (bctx->init_opcode == SEP_DES_INIT_OPCODE) {
-			sep_read_context(sctx, &msg_offset,
-			&bctx->des_private_ctx,
+		if (ta_ctx->init_opcode == SEP_DES_INIT_OPCODE) {
+			sep_read_context(ta_ctx, &msg_offset,
+			&sctx->des_private_ctx,
 			sizeof(struct sep_des_private_context));
 
-			sep_dump(sctx->sep_used, "ctx init des",
-				&bctx->des_private_ctx, 40);
+			sep_dump(ta_ctx->sep_used, "ctx init des",
+				&sctx->des_private_ctx, 40);
 		} else {
-			sep_read_context(sctx, &msg_offset,
-			&bctx->aes_private_ctx,
-			sizeof(struct sep_des_private_context));
-
-			sep_dump(sctx->sep_used, "ctx init aes",
-				&bctx->aes_private_ctx, 20);
-		}
-
-		/* We are done with init. Now send out the data */
-		/* first release the sep */
-		sctx->key_sent = 1;
-		sep_crypto_release(sctx, -EINPROGRESS);
+			sep_read_context(ta_ctx, &msg_offset,
+			&sctx->aes_private_ctx,
+			sizeof(struct sep_aes_private_context));
 
-		spin_lock_irq(&queue_lock);
-		int_error = crypto_enqueue_request(&sep_queue, &req->base);
-		spin_unlock_irq(&queue_lock);
-
-		if ((int_error != 0) && (int_error != -EINPROGRESS)) {
-			dev_warn(&sctx->sep_used->pdev->dev,
-				"spe cypher post op cant queue\n");
-			sep_crypto_release(sctx, int_error);
-			return int_error;
+			sep_dump(ta_ctx->sep_used, "ctx init aes",
+				&sctx->aes_private_ctx, 20);
 		}
 
-		/* schedule the data send */
-		int_error = sep_submit_work(sep->workqueue, sep_dequeuer,
-			(void *)&sep_queue);
+		sep_dump_ivs(req, "after sending key to sep\n");
 
-		if (int_error) {
-			dev_warn(&sep->pdev->dev,
-				"cant submit work sep_crypto_block\n");
-			sep_crypto_release(sctx, -EINVAL);
-			return -EINVAL;
-		}
+		/* key sent went okay; release sep, and set are_we_done_yet */
+		sctx->key_sent = 1;
+		sep_crypto_release(sctx, ta_ctx, -EINPROGRESS);
 
 	} else {
 
 		/**
 		 * This is the result of a block request
 		 */
-		dev_dbg(&sctx->sep_used->pdev->dev,
+		dev_dbg(&ta_ctx->sep_used->pdev->dev,
 			"crypto_post_op block response\n");
 
-		u32_error = sep_verify_op(sctx, bctx->block_opcode,
+		u32_error = sep_verify_op(ta_ctx, ta_ctx->block_opcode,
 			&msg_offset);
 
 		if (u32_error) {
-			dev_warn(&sctx->sep_used->pdev->dev,
+			dev_warn(&ta_ctx->sep_used->pdev->dev,
 				"sep block error %x\n", u32_error);
-			sep_crypto_release(sctx, u32_error);
+			sep_crypto_release(sctx, ta_ctx, u32_error);
 			return -EINVAL;
 			}
 
-		if (bctx->block_opcode == SEP_DES_BLOCK_OPCODE) {
+		if (ta_ctx->block_opcode == SEP_DES_BLOCK_OPCODE) {
 
-			dev_dbg(&sctx->sep_used->pdev->dev,
+			dev_dbg(&ta_ctx->sep_used->pdev->dev,
 				"post op for DES\n");
 
 			/* special case for 1 block des */
 			if (sep->current_cypher_req->nbytes ==
 				crypto_ablkcipher_blocksize(tfm)) {
 
-				sep_read_msg(sctx, small_buf,
+				sep_read_msg(ta_ctx, small_buf,
 					crypto_ablkcipher_blocksize(tfm),
 					crypto_ablkcipher_blocksize(tfm) * 2,
 					&msg_offset, 1);
 
-				dev_dbg(&sctx->sep_used->pdev->dev,
+				dev_dbg(&ta_ctx->sep_used->pdev->dev,
 					"reading in block des\n");
 
 				copy_result = sg_copy_from_buffer(
-					sctx->dst_sg,
-					sep_sg_nents(sctx->dst_sg),
+					ta_ctx->dst_sg,
+					sep_sg_nents(ta_ctx->dst_sg),
 					small_buf,
 					crypto_ablkcipher_blocksize(tfm));
 
 				if (copy_result !=
 					crypto_ablkcipher_blocksize(tfm)) {
 
-					dev_warn(&sctx->sep_used->pdev->dev,
+					dev_warn(&ta_ctx->sep_used->pdev->dev,
 						"des block copy faild\n");
-					sep_crypto_release(sctx, -ENOMEM);
+					sep_crypto_release(sctx, ta_ctx,
+						-ENOMEM);
 					return -ENOMEM;
 				}
 			}
 
 			/* Read Context */
-			sep_read_context(sctx, &msg_offset,
-				&bctx->des_private_ctx,
+			sep_read_context(ta_ctx, &msg_offset,
+				&sctx->des_private_ctx,
 				sizeof(struct sep_des_private_context));
 		} else {
 
-			dev_dbg(&sctx->sep_used->pdev->dev,
+			dev_dbg(&ta_ctx->sep_used->pdev->dev,
 				"post op for AES\n");
 
 			/* Skip the MAC Output */
 			msg_offset += (sizeof(u32) * 4);
 
 			/* Read Context */
-			sep_read_context(sctx, &msg_offset,
-				&bctx->aes_private_ctx,
+			sep_read_context(ta_ctx, &msg_offset,
+				&sctx->aes_private_ctx,
 				sizeof(struct sep_aes_private_context));
 		}
 
-		sep_dump_sg(sctx->sep_used,
-			"block sg out", sctx->dst_sg);
+		sep_dump_sg(ta_ctx->sep_used,
+			"block sg out", ta_ctx->dst_sg);
 
 		/* Copy to correct sg if this block had oddball pages */
-		if (sctx->dst_sg_hold)
-			sep_copy_sg(sctx->sep_used,
-				sctx->dst_sg,
-				sctx->current_cypher_req->dst,
-				sctx->current_cypher_req->nbytes);
+		if (ta_ctx->dst_sg_hold)
+			sep_copy_sg(ta_ctx->sep_used,
+				ta_ctx->dst_sg,
+				ta_ctx->current_cypher_req->dst,
+				ta_ctx->current_cypher_req->nbytes);
+
+		/**
+		 * Copy the iv's back to the walk.iv
+		 * This is required for dm_crypt
+		 */
+		sep_dump_ivs(req, "got data block from sep\n");
+		if ((ta_ctx->current_request == DES_CBC) &&
+			(ta_ctx->des_opmode == SEP_DES_CBC)) {
+
+			dev_dbg(&ta_ctx->sep_used->pdev->dev,
+				"returning result iv to walk on DES\n");
+			des_internal = (struct sep_des_internal_context *)
+				sctx->des_private_ctx.ctx_buf;
+			memcpy(ta_ctx->walk.iv,
+				(void *)des_internal->iv_context,
+				crypto_ablkcipher_ivsize(tfm));
+		} else if ((ta_ctx->current_request == AES_CBC) &&
+			(ta_ctx->aes_opmode == SEP_AES_CBC)) {
+
+			dev_dbg(&ta_ctx->sep_used->pdev->dev,
+				"returning result iv to walk on AES\n");
+			aes_internal = (struct sep_aes_internal_context *)
+				sctx->aes_private_ctx.cbuff;
+			memcpy(ta_ctx->walk.iv,
+				(void *)aes_internal->aes_ctx_iv,
+				crypto_ablkcipher_ivsize(tfm));
+		}
 
 		/* finished, release everything */
-		sep_crypto_release(sctx, 0);
+		sep_crypto_release(sctx, ta_ctx, 0);
 	}
+	pr_debug("crypto_post_op done\n");
+	pr_debug("key_sent is %d tfm is %p sctx is %p ta_ctx is %p\n",
+		sctx->key_sent, tfm, sctx, ta_ctx);
+
 	return 0;
 }
 
@@ -1584,35 +1808,33 @@ static u32 hash_init_post_op(struct sep_device *sep)
 	u32 u32_error;
 	u32 msg_offset;
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(sep->current_hash_req);
-	struct sep_hash_ctx *ctx = ahash_request_ctx(sep->current_hash_req);
+	struct this_task_ctx *ta_ctx = ahash_request_ctx(sep->current_hash_req);
 	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
-	dev_dbg(&sctx->sep_used->pdev->dev,
+	dev_dbg(&ta_ctx->sep_used->pdev->dev,
 		"hash init post op\n");
 
-	sctx->done_with_transaction = 1;
-
 	/* first bring msg from shared area to local area */
-	memcpy(sctx->msg, sep->shared_addr,
+	memcpy(ta_ctx->msg, sep->shared_addr,
 		SEP_DRIVER_MESSAGE_SHARED_AREA_SIZE_IN_BYTES);
 
-	u32_error = sep_verify_op(sctx, SEP_HASH_INIT_OPCODE,
+	u32_error = sep_verify_op(ta_ctx, SEP_HASH_INIT_OPCODE,
 		&msg_offset);
 
 	if (u32_error) {
-		dev_warn(&sctx->sep_used->pdev->dev, "hash init error %x\n",
+		dev_warn(&ta_ctx->sep_used->pdev->dev, "hash init error %x\n",
 			u32_error);
-		sep_crypto_release(sctx, u32_error);
+		sep_crypto_release(sctx, ta_ctx, u32_error);
 		return u32_error;
 		}
 
 	/* Read Context */
-	sep_read_context(sctx, &msg_offset,
-		&ctx->hash_private_ctx,
+	sep_read_context(ta_ctx, &msg_offset,
+		&sctx->hash_private_ctx,
 		sizeof(struct sep_hash_private_context));
 
 	/* Signal to crypto infrastructure and clear out */
-	dev_dbg(&sctx->sep_used->pdev->dev, "hash init post op done\n");
-	sep_crypto_release(sctx, 0);
+	dev_dbg(&ta_ctx->sep_used->pdev->dev, "hash init post op done\n");
+	sep_crypto_release(sctx, ta_ctx, 0);
 	return 0;
 }
 
@@ -1621,33 +1843,69 @@ static u32 hash_update_post_op(struct sep_device *sep)
 	u32 u32_error;
 	u32 msg_offset;
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(sep->current_hash_req);
-	struct sep_hash_ctx *ctx = ahash_request_ctx(sep->current_hash_req);
+	struct this_task_ctx *ta_ctx = ahash_request_ctx(sep->current_hash_req);
 	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
-	dev_dbg(&sctx->sep_used->pdev->dev,
+	dev_dbg(&ta_ctx->sep_used->pdev->dev,
 		"hash update post op\n");
 
-	sctx->done_with_transaction = 1;
-
 	/* first bring msg from shared area to local area */
-	memcpy(sctx->msg, sep->shared_addr,
+	memcpy(ta_ctx->msg, sep->shared_addr,
 		SEP_DRIVER_MESSAGE_SHARED_AREA_SIZE_IN_BYTES);
 
-	u32_error = sep_verify_op(sctx, SEP_HASH_UPDATE_OPCODE,
+	u32_error = sep_verify_op(ta_ctx, SEP_HASH_UPDATE_OPCODE,
 		&msg_offset);
 
 	if (u32_error) {
-		dev_warn(&sctx->sep_used->pdev->dev, "hash init error %x\n",
+		dev_warn(&ta_ctx->sep_used->pdev->dev, "hash init error %x\n",
 			u32_error);
-		sep_crypto_release(sctx, u32_error);
+		sep_crypto_release(sctx, ta_ctx, u32_error);
 		return u32_error;
 		}
 
 	/* Read Context */
-	sep_read_context(sctx, &msg_offset,
-		&ctx->hash_private_ctx,
+	sep_read_context(ta_ctx, &msg_offset,
+		&sctx->hash_private_ctx,
 		sizeof(struct sep_hash_private_context));
 
-	sep_crypto_release(sctx, 0);
+	/**
+	 * Following is only for finup; if we just completd the
+	 * data portion of finup, we now need to kick off the
+	 * finish portion of finup.
+	 */
+
+	if (ta_ctx->sep_used->current_hash_stage == HASH_FINUP_DATA) {
+
+		/* first reset stage to HASH_FINUP_FINISH */
+		ta_ctx->sep_used->current_hash_stage = HASH_FINUP_FINISH;
+
+		/* now enqueue the finish operation */
+		spin_lock_irq(&queue_lock);
+		u32_error = crypto_enqueue_request(&sep_queue,
+			&ta_ctx->sep_used->current_hash_req->base);
+		spin_unlock_irq(&queue_lock);
+
+		if ((u32_error != 0) && (u32_error != -EINPROGRESS)) {
+			dev_warn(&ta_ctx->sep_used->pdev->dev,
+				"spe cypher post op cant queue\n");
+			sep_crypto_release(sctx, ta_ctx, u32_error);
+			return u32_error;
+		}
+
+		/* schedule the data send */
+		u32_error = sep_submit_work(ta_ctx->sep_used->workqueue,
+			sep_dequeuer, (void *)&sep_queue);
+
+		if (u32_error) {
+			dev_warn(&ta_ctx->sep_used->pdev->dev,
+				"cant submit work sep_crypto_block\n");
+			sep_crypto_release(sctx, ta_ctx, -EINVAL);
+			return -EINVAL;
+		}
+	}
+
+	/* Signal to crypto infrastructure and clear out */
+	dev_dbg(&ta_ctx->sep_used->pdev->dev, "hash update post op done\n");
+	sep_crypto_release(sctx, ta_ctx, 0);
 	return 0;
 }
 
@@ -1658,45 +1916,44 @@ static u32 hash_final_post_op(struct sep_device *sep)
 	u32 msg_offset;
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(sep->current_hash_req);
 	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
-	dev_dbg(&sctx->sep_used->pdev->dev,
+	struct this_task_ctx *ta_ctx = ahash_request_ctx(sep->current_hash_req);
+	dev_dbg(&ta_ctx->sep_used->pdev->dev,
 		"hash final post op\n");
 
-	sctx->done_with_transaction = 1;
-
 	/* first bring msg from shared area to local area */
-	memcpy(sctx->msg, sep->shared_addr,
+	memcpy(ta_ctx->msg, sep->shared_addr,
 		SEP_DRIVER_MESSAGE_SHARED_AREA_SIZE_IN_BYTES);
 
-	u32_error = sep_verify_op(sctx, SEP_HASH_FINISH_OPCODE,
+	u32_error = sep_verify_op(ta_ctx, SEP_HASH_FINISH_OPCODE,
 		&msg_offset);
 
 	if (u32_error) {
-		dev_warn(&sctx->sep_used->pdev->dev, "hash finish error %x\n",
+		dev_warn(&ta_ctx->sep_used->pdev->dev, "hash finish error %x\n",
 			u32_error);
-		sep_crypto_release(sctx, u32_error);
+		sep_crypto_release(sctx, ta_ctx, u32_error);
 		return u32_error;
 		}
 
 	/* Grab the result */
-	if (sctx->current_hash_req->result == NULL) {
+	if (ta_ctx->current_hash_req->result == NULL) {
 		/* Oops, null buffer; error out here */
-		dev_warn(&sctx->sep_used->pdev->dev,
+		dev_warn(&ta_ctx->sep_used->pdev->dev,
 			"hash finish null buffer\n");
-		sep_crypto_release(sctx, (u32)-ENOMEM);
+		sep_crypto_release(sctx, ta_ctx, (u32)-ENOMEM);
 		return -ENOMEM;
 		}
 
 	max_length = (((SEP_HASH_RESULT_SIZE_WORDS * sizeof(u32)) + 3) /
 		sizeof(u32)) * sizeof(u32);
 
-	sep_read_msg(sctx,
-		sctx->current_hash_req->result,
+	sep_read_msg(ta_ctx,
+		ta_ctx->current_hash_req->result,
 		crypto_ahash_digestsize(tfm), max_length,
 		&msg_offset, 0);
 
 	/* Signal to crypto infrastructure and clear out */
-	dev_dbg(&sctx->sep_used->pdev->dev, "hash finish post op done\n");
-	sep_crypto_release(sctx, 0);
+	dev_dbg(&ta_ctx->sep_used->pdev->dev, "hash finish post op done\n");
+	sep_crypto_release(sctx, ta_ctx, 0);
 	return 0;
 }
 
@@ -1707,48 +1964,47 @@ static u32 hash_digest_post_op(struct sep_device *sep)
 	u32 msg_offset;
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(sep->current_hash_req);
 	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
-	dev_dbg(&sctx->sep_used->pdev->dev,
+	struct this_task_ctx *ta_ctx = ahash_request_ctx(sep->current_hash_req);
+	dev_dbg(&ta_ctx->sep_used->pdev->dev,
 		"hash digest post op\n");
 
-	sctx->done_with_transaction = 1;
-
 	/* first bring msg from shared area to local area */
-	memcpy(sctx->msg, sep->shared_addr,
+	memcpy(ta_ctx->msg, sep->shared_addr,
 		SEP_DRIVER_MESSAGE_SHARED_AREA_SIZE_IN_BYTES);
 
-	u32_error = sep_verify_op(sctx, SEP_HASH_SINGLE_OPCODE,
+	u32_error = sep_verify_op(ta_ctx, SEP_HASH_SINGLE_OPCODE,
 		&msg_offset);
 
 	if (u32_error) {
-		dev_warn(&sctx->sep_used->pdev->dev,
+		dev_warn(&ta_ctx->sep_used->pdev->dev,
 			"hash digest finish error %x\n", u32_error);
 
-		sep_crypto_release(sctx, u32_error);
+		sep_crypto_release(sctx, ta_ctx, u32_error);
 		return u32_error;
 		}
 
 	/* Grab the result */
-	if (sctx->current_hash_req->result == NULL) {
+	if (ta_ctx->current_hash_req->result == NULL) {
 		/* Oops, null buffer; error out here */
-		dev_warn(&sctx->sep_used->pdev->dev,
+		dev_warn(&ta_ctx->sep_used->pdev->dev,
 			"hash digest finish null buffer\n");
-		sep_crypto_release(sctx, (u32)-ENOMEM);
+		sep_crypto_release(sctx, ta_ctx, (u32)-ENOMEM);
 		return -ENOMEM;
 		}
 
 	max_length = (((SEP_HASH_RESULT_SIZE_WORDS * sizeof(u32)) + 3) /
 		sizeof(u32)) * sizeof(u32);
 
-	sep_read_msg(sctx,
-		sctx->current_hash_req->result,
+	sep_read_msg(ta_ctx,
+		ta_ctx->current_hash_req->result,
 		crypto_ahash_digestsize(tfm), max_length,
 		&msg_offset, 0);
 
 	/* Signal to crypto infrastructure and clear out */
-	dev_dbg(&sctx->sep_used->pdev->dev,
+	dev_dbg(&ta_ctx->sep_used->pdev->dev,
 		"hash digest finish post op done\n");
 
-	sep_crypto_release(sctx, 0);
+	sep_crypto_release(sctx, ta_ctx, 0);
 	return 0;
 }
 
@@ -1759,7 +2015,6 @@ static u32 hash_digest_post_op(struct sep_device *sep)
  */
 static void sep_finish(unsigned long data)
 {
-	unsigned long flags;
 	struct sep_device *sep_dev;
 	int res;
 
@@ -1776,18 +2031,15 @@ static void sep_finish(unsigned long data)
 		return;
 	}
 
-	spin_lock_irqsave(&sep_dev->busy_lock, flags);
 	if (sep_dev->in_kernel == (u32)0) {
-		spin_unlock_irqrestore(&sep_dev->busy_lock, flags);
 		dev_warn(&sep_dev->pdev->dev,
 			"sep_finish; not in kernel operation\n");
 		return;
 	}
-	spin_unlock_irqrestore(&sep_dev->busy_lock, flags);
 
 	/* Did we really do a sep command prior to this? */
 	if (0 == test_bit(SEP_LEGACY_SENDMSG_DONE_OFFSET,
-		&sep_dev->sctx->call_status.status)) {
+		&sep_dev->ta_ctx->call_status.status)) {
 
 		dev_warn(&sep_dev->pdev->dev, "[PID%d] sendmsg not called\n",
 			current->pid);
@@ -1856,8 +2108,10 @@ static void sep_finish(unsigned long data)
 			res = hash_init_post_op(sep_dev);
 			break;
 		case HASH_UPDATE:
+		case HASH_FINUP_DATA:
 			res = hash_update_post_op(sep_dev);
 			break;
+		case HASH_FINUP_FINISH:
 		case HASH_FINISH:
 			res = hash_final_post_op(sep_dev);
 			break;
@@ -1865,43 +2119,31 @@ static void sep_finish(unsigned long data)
 			res = hash_digest_post_op(sep_dev);
 			break;
 		default:
-			dev_warn(&sep_dev->pdev->dev,
-			"invalid stage for hash finish\n");
+			pr_debug("sep - invalid stage for hash finish\n");
 		}
 		break;
 	default:
-		dev_warn(&sep_dev->pdev->dev,
-		"invalid request for finish\n");
+		pr_debug("sep - invalid request for finish\n");
 	}
 
-	if (res) {
-		dev_warn(&sep_dev->pdev->dev,
-		"finish returned error %x\n", res);
-	}
+	if (res)
+		pr_debug("sep - finish returned error %x\n", res);
 }
 
 static int sep_hash_cra_init(struct crypto_tfm *tfm)
 	{
-	struct sep_system_ctx *sctx = crypto_tfm_ctx(tfm);
 	const char *alg_name = crypto_tfm_alg_name(tfm);
 
-	sctx->sep_used = sep_dev;
-
-	dev_dbg(&sctx->sep_used->pdev->dev,
-		"sep_hash_cra_init name is %s\n", alg_name);
+	pr_debug("sep_hash_cra_init name is %s\n", alg_name);
 
 	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
-		sizeof(struct sep_hash_ctx));
+		sizeof(struct this_task_ctx));
 	return 0;
 	}
 
 static void sep_hash_cra_exit(struct crypto_tfm *tfm)
 {
-	struct sep_system_ctx *sctx = crypto_tfm_ctx(tfm);
-
-	dev_dbg(&sctx->sep_used->pdev->dev,
-		"sep_hash_cra_exit\n");
-	sctx->sep_used = NULL;
+	pr_debug("sep_hash_cra_exit\n");
 }
 
 static void sep_hash_init(void *data)
@@ -1910,60 +2152,49 @@ static void sep_hash_init(void *data)
 	int result;
 	struct ahash_request *req;
 	struct crypto_ahash *tfm;
-	struct sep_hash_ctx *ctx;
+	struct this_task_ctx *ta_ctx;
 	struct sep_system_ctx *sctx;
+	unsigned long end_time;
+	int are_we_done_yet;
 
 	req = (struct ahash_request *)data;
 	tfm = crypto_ahash_reqtfm(req);
-	ctx = ahash_request_ctx(req);
 	sctx = crypto_ahash_ctx(tfm);
+	ta_ctx = ahash_request_ctx(req);
+	ta_ctx->sep_used = sep_dev;
+
+	ta_ctx->are_we_done_yet = &are_we_done_yet;
 
-	dev_dbg(&sctx->sep_used->pdev->dev,
+	dev_dbg(&ta_ctx->sep_used->pdev->dev,
 		"sep_hash_init\n");
-	sctx->current_hash_stage = HASH_INIT;
+	ta_ctx->current_hash_stage = HASH_INIT;
 	/* opcode and mode */
-	sep_make_header(sctx, &msg_offset, SEP_HASH_INIT_OPCODE);
-	sep_write_msg(sctx, &ctx->hash_opmode,
+	sep_make_header(ta_ctx, &msg_offset, SEP_HASH_INIT_OPCODE);
+	sep_write_msg(ta_ctx, &ta_ctx->hash_opmode,
 		sizeof(u32), sizeof(u32), &msg_offset, 0);
-	sep_end_msg(sctx, msg_offset);
+	sep_end_msg(ta_ctx, msg_offset);
 
-	sctx->done_with_transaction = 0;
-
-	result = sep_crypto_take_sep(sctx);
+	are_we_done_yet = 0;
+	result = sep_crypto_take_sep(ta_ctx);
 	if (result) {
-		dev_warn(&sctx->sep_used->pdev->dev,
+		dev_warn(&ta_ctx->sep_used->pdev->dev,
 			"sep_hash_init take sep failed\n");
-		sep_crypto_release(sctx, -EINVAL);
+		sep_crypto_release(sctx, ta_ctx, -EINVAL);
 	}
 
-	/**
-	 * Sep is now working. Lets wait up to 5 seconds
-	 * for completion. If it does not complete, we will do
-	 * a crypto release with -EINVAL to release the
-	 * kernel crypto infrastructure and let the system
-	 * continue to boot up
-	 * We have to wait this long because some crypto
-	 * operations can take a while
-	 */
-	dev_dbg(&sctx->sep_used->pdev->dev,
-		"waiting for done with transaction\n");
-
-	sctx->end_time = jiffies + (SEP_TRANSACTION_WAIT_TIME * HZ);
-	while ((time_before(jiffies, sctx->end_time)) &&
-		(!sctx->done_with_transaction))
+	/* now we sit and wait up to a fixed time for completion */
+	end_time = jiffies + (WAIT_TIME * HZ);
+	while ((time_before(jiffies, end_time)) && (are_we_done_yet == 0))
 		schedule();
 
-	dev_dbg(&sctx->sep_used->pdev->dev,
-		"done waiting for done with transaction\n");
-
-	/* are we done? */
-	if (!sctx->done_with_transaction) {
-		/* Nope, lets release and tell crypto no */
-		dev_warn(&sctx->sep_used->pdev->dev,
-			"[PID%d] sep_hash_init never finished\n",
-			current->pid);
-		sep_crypto_release(sctx, -EINVAL);
+	/* Done waiting; still not done yet? */
+	if (are_we_done_yet == 0) {
+		dev_dbg(&ta_ctx->sep_used->pdev->dev,
+			"hash init never got done\n");
+		sep_crypto_release(sctx, ta_ctx, -EINVAL);
+		return;
 	}
+
 }
 
 static void sep_hash_update(void *data)
@@ -1975,6 +2206,8 @@ static void sep_hash_update(void *data)
 	u32 block_size;
 	u32 head_len;
 	u32 tail_len;
+	int are_we_done_yet;
+
 	static u32 msg[10];
 	static char small_buf[100];
 	void *src_ptr;
@@ -1982,184 +2215,174 @@ static void sep_hash_update(void *data)
 	ssize_t copy_result;
 	struct ahash_request *req;
 	struct crypto_ahash *tfm;
-	struct sep_hash_ctx *ctx;
+	struct this_task_ctx *ta_ctx;
 	struct sep_system_ctx *sctx;
+	unsigned long end_time;
 
 	req = (struct ahash_request *)data;
 	tfm = crypto_ahash_reqtfm(req);
-	ctx = ahash_request_ctx(req);
 	sctx = crypto_ahash_ctx(tfm);
+	ta_ctx = ahash_request_ctx(req);
+	ta_ctx->sep_used = sep_dev;
+
+	ta_ctx->are_we_done_yet = &are_we_done_yet;
 
 	/* length for queue status */
-	sctx->nbytes = req->nbytes;
+	ta_ctx->nbytes = req->nbytes;
 
-	dev_dbg(&sctx->sep_used->pdev->dev,
+	dev_dbg(&ta_ctx->sep_used->pdev->dev,
 		"sep_hash_update\n");
-	sctx->current_hash_stage = HASH_UPDATE;
+	ta_ctx->current_hash_stage = HASH_UPDATE;
 	len = req->nbytes;
 
 	block_size = crypto_tfm_alg_blocksize(crypto_ahash_tfm(tfm));
 	tail_len = req->nbytes % block_size;
-	dev_dbg(&sctx->sep_used->pdev->dev, "length is %x\n", len);
-	dev_dbg(&sctx->sep_used->pdev->dev, "block_size is %x\n", block_size);
-	dev_dbg(&sctx->sep_used->pdev->dev, "tail len is %x\n", tail_len);
+	dev_dbg(&ta_ctx->sep_used->pdev->dev, "length is %x\n", len);
+	dev_dbg(&ta_ctx->sep_used->pdev->dev, "block_size is %x\n", block_size);
+	dev_dbg(&ta_ctx->sep_used->pdev->dev, "tail len is %x\n", tail_len);
 
 	/* Compute header/tail sizes */
-	int_ctx = (struct sep_hash_internal_context *)&ctx->
+	int_ctx = (struct sep_hash_internal_context *)&sctx->
 		hash_private_ctx.internal_context;
 	head_len = (block_size - int_ctx->prev_update_bytes) % block_size;
 	tail_len = (req->nbytes - head_len) % block_size;
 
 	/* Make sure all pages are even block */
-	int_error = sep_oddball_pages(sctx->sep_used, req->src,
+	int_error = sep_oddball_pages(ta_ctx->sep_used, req->src,
 		req->nbytes,
 		block_size, &new_sg, 1);
 
 	if (int_error < 0) {
-		dev_warn(&sctx->sep_used->pdev->dev,
+		dev_warn(&ta_ctx->sep_used->pdev->dev,
 			"oddball pages error in crash update\n");
-		sep_crypto_release(sctx, -ENOMEM);
+		sep_crypto_release(sctx, ta_ctx, -ENOMEM);
 		return;
 	} else if (int_error == 1) {
-		sctx->src_sg = new_sg;
-		sctx->src_sg_hold = new_sg;
+		ta_ctx->src_sg = new_sg;
+		ta_ctx->src_sg_hold = new_sg;
 	} else {
-		sctx->src_sg = req->src;
-		sctx->src_sg_hold = NULL;
+		ta_ctx->src_sg = req->src;
+		ta_ctx->src_sg_hold = NULL;
 	}
 
-	src_ptr = sg_virt(sctx->src_sg);
+	src_ptr = sg_virt(ta_ctx->src_sg);
 
-	if ((!req->nbytes) || (!ctx->sg)) {
+	if ((!req->nbytes) || (!ta_ctx->src_sg)) {
 		/* null data */
 		src_ptr = NULL;
 	}
 
-	sep_dump_sg(sctx->sep_used, "hash block sg in", sctx->src_sg);
+	sep_dump_sg(ta_ctx->sep_used, "hash block sg in", ta_ctx->src_sg);
 
-	sctx->dcb_input_data.app_in_address = src_ptr;
-	sctx->dcb_input_data.data_in_size = req->nbytes - (head_len + tail_len);
-	sctx->dcb_input_data.app_out_address = NULL;
-	sctx->dcb_input_data.block_size = block_size;
-	sctx->dcb_input_data.tail_block_size = 0;
-	sctx->dcb_input_data.is_applet = 0;
-	sctx->dcb_input_data.src_sg = sctx->src_sg;
-	sctx->dcb_input_data.dst_sg = NULL;
+	ta_ctx->dcb_input_data.app_in_address = src_ptr;
+	ta_ctx->dcb_input_data.data_in_size =
+		req->nbytes - (head_len + tail_len);
+	ta_ctx->dcb_input_data.app_out_address = NULL;
+	ta_ctx->dcb_input_data.block_size = block_size;
+	ta_ctx->dcb_input_data.tail_block_size = 0;
+	ta_ctx->dcb_input_data.is_applet = 0;
+	ta_ctx->dcb_input_data.src_sg = ta_ctx->src_sg;
+	ta_ctx->dcb_input_data.dst_sg = NULL;
 
 	int_error = sep_create_dcb_dmatables_context_kernel(
-		sctx->sep_used,
-		&sctx->dcb_region,
-		&sctx->dmatables_region,
-		&sctx->dma_ctx,
-		&sctx->dcb_input_data,
+		ta_ctx->sep_used,
+		&ta_ctx->dcb_region,
+		&ta_ctx->dmatables_region,
+		&ta_ctx->dma_ctx,
+		&ta_ctx->dcb_input_data,
 		1);
 	if (int_error) {
-		dev_warn(&sctx->sep_used->pdev->dev,
+		dev_warn(&ta_ctx->sep_used->pdev->dev,
 			"hash update dma table create failed\n");
-		sep_crypto_release(sctx, -EINVAL);
+		sep_crypto_release(sctx, ta_ctx, -EINVAL);
 		return;
 	}
 
 	/* Construct message to SEP */
-	sep_make_header(sctx, &msg_offset, SEP_HASH_UPDATE_OPCODE);
+	sep_make_header(ta_ctx, &msg_offset, SEP_HASH_UPDATE_OPCODE);
 
 	msg[0] = (u32)0;
 	msg[1] = (u32)0;
 	msg[2] = (u32)0;
 
-	sep_write_msg(sctx, msg, sizeof(u32) * 3, sizeof(u32) * 3,
+	sep_write_msg(ta_ctx, msg, sizeof(u32) * 3, sizeof(u32) * 3,
 		&msg_offset, 0);
 
 	/* Handle remainders */
 
 	/* Head */
-	sep_write_msg(sctx, &head_len, sizeof(u32),
+	sep_write_msg(ta_ctx, &head_len, sizeof(u32),
 		sizeof(u32), &msg_offset, 0);
 
 	if (head_len) {
 		copy_result = sg_copy_to_buffer(
 			req->src,
-			sep_sg_nents(sctx->src_sg),
+			sep_sg_nents(ta_ctx->src_sg),
 			small_buf, head_len);
 
 		if (copy_result != head_len) {
-			dev_warn(&sctx->sep_used->pdev->dev,
+			dev_warn(&ta_ctx->sep_used->pdev->dev,
 				"sg head copy failure in hash block\n");
-			sep_crypto_release(sctx, -ENOMEM);
+			sep_crypto_release(sctx, ta_ctx, -ENOMEM);
 			return;
 		}
 
-		sep_write_msg(sctx, small_buf, head_len,
+		sep_write_msg(ta_ctx, small_buf, head_len,
 			sizeof(u32) * 32, &msg_offset, 1);
 	} else {
 		msg_offset += sizeof(u32) * 32;
 	}
 
 	/* Tail */
-	sep_write_msg(sctx, &tail_len, sizeof(u32),
+	sep_write_msg(ta_ctx, &tail_len, sizeof(u32),
 		sizeof(u32), &msg_offset, 0);
 
 	if (tail_len) {
 		copy_result = sep_copy_offset_sg(
-			sctx->sep_used,
-			sctx->src_sg,
+			ta_ctx->sep_used,
+			ta_ctx->src_sg,
 			req->nbytes - tail_len,
 			small_buf, tail_len);
 
 		if (copy_result != tail_len) {
-			dev_warn(&sctx->sep_used->pdev->dev,
+			dev_warn(&ta_ctx->sep_used->pdev->dev,
 				"sg tail copy failure in hash block\n");
-			sep_crypto_release(sctx, -ENOMEM);
+			sep_crypto_release(sctx, ta_ctx, -ENOMEM);
 			return;
 		}
 
-		sep_write_msg(sctx, small_buf, tail_len,
+		sep_write_msg(ta_ctx, small_buf, tail_len,
 			sizeof(u32) * 32, &msg_offset, 1);
 	} else {
 		msg_offset += sizeof(u32) * 32;
 	}
 
 	/* Context */
-	sep_write_context(sctx, &msg_offset, &ctx->hash_private_ctx,
+	sep_write_context(ta_ctx, &msg_offset, &sctx->hash_private_ctx,
 		sizeof(struct sep_hash_private_context));
 
-	sep_end_msg(sctx, msg_offset);
-	sctx->done_with_transaction = 0;
-	int_error = sep_crypto_take_sep(sctx);
+	sep_end_msg(ta_ctx, msg_offset);
+	are_we_done_yet = 0;
+	int_error = sep_crypto_take_sep(ta_ctx);
 	if (int_error) {
-		dev_warn(&sctx->sep_used->pdev->dev,
+		dev_warn(&ta_ctx->sep_used->pdev->dev,
 			"sep_hash_update take sep failed\n");
-		sep_crypto_release(sctx, -EINVAL);
+		sep_crypto_release(sctx, ta_ctx, -EINVAL);
 	}
 
-	/**
-	 * Sep is now working. Lets wait up to 5 seconds
-	 * for completion. If it does not complete, we will do
-	 * a crypto release with -EINVAL to release the
-	 * kernel crypto infrastructure and let the system
-	 * continue to boot up
-	 * We have to wait this long because some crypto
-	 * operations can take a while
-	 */
-	dev_dbg(&sctx->sep_used->pdev->dev,
-		"waiting for done with transaction\n");
-
-	sctx->end_time = jiffies + (SEP_TRANSACTION_WAIT_TIME * HZ);
-	while ((time_before(jiffies, sctx->end_time)) &&
-		(!sctx->done_with_transaction))
+	/* now we sit and wait up to a fixed time for completion */
+	end_time = jiffies + (WAIT_TIME * HZ);
+	while ((time_before(jiffies, end_time)) && (are_we_done_yet == 0))
 		schedule();
 
-	dev_dbg(&sctx->sep_used->pdev->dev,
-		"done waiting for done with transaction\n");
-
-	/* are we done? */
-	if (!sctx->done_with_transaction) {
-		/* Nope, lets release and tell crypto no */
-		dev_warn(&sctx->sep_used->pdev->dev,
-			"[PID%d] sep_hash_update never finished\n",
-			current->pid);
-		sep_crypto_release(sctx, -EINVAL);
+	/* Done waiting; still not done yet? */
+	if (are_we_done_yet == 0) {
+		dev_dbg(&ta_ctx->sep_used->pdev->dev,
+			"hash update never got done\n");
+		sep_crypto_release(sctx, ta_ctx, -EINVAL);
+		return;
 	}
+
 }
 
 static void sep_hash_final(void *data)
@@ -2167,63 +2390,53 @@ static void sep_hash_final(void *data)
 	u32 msg_offset;
 	struct ahash_request *req;
 	struct crypto_ahash *tfm;
-	struct sep_hash_ctx *ctx;
+	struct this_task_ctx *ta_ctx;
 	struct sep_system_ctx *sctx;
 	int result;
+	unsigned long end_time;
+	int are_we_done_yet;
 
 	req = (struct ahash_request *)data;
 	tfm = crypto_ahash_reqtfm(req);
-	ctx = ahash_request_ctx(req);
 	sctx = crypto_ahash_ctx(tfm);
+	ta_ctx = ahash_request_ctx(req);
+	ta_ctx->sep_used = sep_dev;
 
-	dev_dbg(&sctx->sep_used->pdev->dev,
+	dev_dbg(&ta_ctx->sep_used->pdev->dev,
 		"sep_hash_final\n");
-	sctx->current_hash_stage = HASH_FINISH;
+	ta_ctx->current_hash_stage = HASH_FINISH;
+
+	ta_ctx->are_we_done_yet = &are_we_done_yet;
 
 	/* opcode and mode */
-	sep_make_header(sctx, &msg_offset, SEP_HASH_FINISH_OPCODE);
+	sep_make_header(ta_ctx, &msg_offset, SEP_HASH_FINISH_OPCODE);
 
 	/* Context */
-	sep_write_context(sctx, &msg_offset, &ctx->hash_private_ctx,
+	sep_write_context(ta_ctx, &msg_offset, &sctx->hash_private_ctx,
 		sizeof(struct sep_hash_private_context));
 
-	sep_end_msg(sctx, msg_offset);
-	sctx->done_with_transaction = 0;
-	result = sep_crypto_take_sep(sctx);
+	sep_end_msg(ta_ctx, msg_offset);
+	are_we_done_yet = 0;
+	result = sep_crypto_take_sep(ta_ctx);
 	if (result) {
-		dev_warn(&sctx->sep_used->pdev->dev,
+		dev_warn(&ta_ctx->sep_used->pdev->dev,
 			"sep_hash_final take sep failed\n");
-		sep_crypto_release(sctx, -EINVAL);
+		sep_crypto_release(sctx, ta_ctx, -EINVAL);
 	}
 
-	/**
-	 * Sep is now working. Lets wait up to 5 seconds
-	 * for completion. If it does not complete, we will do
-	 * a crypto release with -EINVAL to release the
-	 * kernel crypto infrastructure and let the system
-	 * continue to boot up
-	 * We have to wait this long because some crypto
-	 * operations can take a while
-	 */
-	dev_dbg(&sctx->sep_used->pdev->dev,
-		"waiting for done with transaction\n");
-
-	sctx->end_time = jiffies + (SEP_TRANSACTION_WAIT_TIME * HZ);
-	while ((time_before(jiffies, sctx->end_time)) &&
-		(!sctx->done_with_transaction))
+	/* now we sit and wait up to a fixed time for completion */
+	end_time = jiffies + (WAIT_TIME * HZ);
+	while ((time_before(jiffies, end_time)) && (are_we_done_yet == 0))
 		schedule();
 
-	dev_dbg(&sctx->sep_used->pdev->dev,
-		"done waiting for done with transaction\n");
-
-	/* are we done? */
-	if (!sctx->done_with_transaction) {
-		/* Nope, lets release and tell crypto no */
-		dev_warn(&sctx->sep_used->pdev->dev,
-			"[PID%d] sep_hash_final never finished\n",
-			current->pid);
-		sep_crypto_release(sctx, -EINVAL);
+	/* Done waiting; still not done yet? */
+	if (are_we_done_yet == 0) {
+		dev_dbg(&ta_ctx->sep_used->pdev->dev,
+			"hash final job never got done\n");
+		sep_crypto_release(sctx, ta_ctx, -EINVAL);
+		return;
 	}
+
 }
 
 static void sep_hash_digest(void *data)
@@ -2234,6 +2447,7 @@ static void sep_hash_digest(void *data)
 	u32 msg[10];
 	size_t copy_result;
 	int result;
+	int are_we_done_yet;
 	u32 tail_len;
 	static char small_buf[100];
 	struct scatterlist *new_sg;
@@ -2241,152 +2455,140 @@ static void sep_hash_digest(void *data)
 
 	struct ahash_request *req;
 	struct crypto_ahash *tfm;
-	struct sep_hash_ctx *ctx;
+	struct this_task_ctx *ta_ctx;
 	struct sep_system_ctx *sctx;
+	unsigned long end_time;
 
 	req = (struct ahash_request *)data;
 	tfm = crypto_ahash_reqtfm(req);
-	ctx = ahash_request_ctx(req);
 	sctx = crypto_ahash_ctx(tfm);
+	ta_ctx = ahash_request_ctx(req);
+	ta_ctx->sep_used = sep_dev;
 
-	dev_dbg(&sctx->sep_used->pdev->dev,
+	dev_dbg(&ta_ctx->sep_used->pdev->dev,
 		"sep_hash_digest\n");
-	sctx->current_hash_stage = HASH_DIGEST;
+	ta_ctx->current_hash_stage = HASH_DIGEST;
+
+	ta_ctx->are_we_done_yet = &are_we_done_yet;
 
 	/* length for queue status */
-	sctx->nbytes = req->nbytes;
+	ta_ctx->nbytes = req->nbytes;
 
 	block_size = crypto_tfm_alg_blocksize(crypto_ahash_tfm(tfm));
 	tail_len = req->nbytes % block_size;
-	dev_dbg(&sctx->sep_used->pdev->dev, "length is %x\n", req->nbytes);
-	dev_dbg(&sctx->sep_used->pdev->dev, "block_size is %x\n", block_size);
-	dev_dbg(&sctx->sep_used->pdev->dev, "tail len is %x\n", tail_len);
+	dev_dbg(&ta_ctx->sep_used->pdev->dev, "length is %x\n", req->nbytes);
+	dev_dbg(&ta_ctx->sep_used->pdev->dev, "block_size is %x\n", block_size);
+	dev_dbg(&ta_ctx->sep_used->pdev->dev, "tail len is %x\n", tail_len);
 
 	/* Make sure all pages are even block */
-	int_error = sep_oddball_pages(sctx->sep_used, req->src,
+	int_error = sep_oddball_pages(ta_ctx->sep_used, req->src,
 		req->nbytes,
 		block_size, &new_sg, 1);
 
 	if (int_error < 0) {
-		dev_warn(&sctx->sep_used->pdev->dev,
+		dev_warn(&ta_ctx->sep_used->pdev->dev,
 			"oddball pages error in crash update\n");
-		sep_crypto_release(sctx, -ENOMEM);
+		sep_crypto_release(sctx, ta_ctx, -ENOMEM);
 		return;
 	} else if (int_error == 1) {
-		sctx->src_sg = new_sg;
-		sctx->src_sg_hold = new_sg;
+		ta_ctx->src_sg = new_sg;
+		ta_ctx->src_sg_hold = new_sg;
 	} else {
-		sctx->src_sg = req->src;
-		sctx->src_sg_hold = NULL;
+		ta_ctx->src_sg = req->src;
+		ta_ctx->src_sg_hold = NULL;
 	}
 
-	src_ptr = sg_virt(sctx->src_sg);
+	src_ptr = sg_virt(ta_ctx->src_sg);
 
-	if ((!req->nbytes) || (!ctx->sg)) {
+	if ((!req->nbytes) || (!ta_ctx->src_sg)) {
 		/* null data */
 		src_ptr = NULL;
 	}
 
-	sep_dump_sg(sctx->sep_used, "hash block sg in", sctx->src_sg);
+	sep_dump_sg(ta_ctx->sep_used, "hash block sg in", ta_ctx->src_sg);
 
-	sctx->dcb_input_data.app_in_address = src_ptr;
-	sctx->dcb_input_data.data_in_size = req->nbytes - tail_len;
-	sctx->dcb_input_data.app_out_address = NULL;
-	sctx->dcb_input_data.block_size = block_size;
-	sctx->dcb_input_data.tail_block_size = 0;
-	sctx->dcb_input_data.is_applet = 0;
-	sctx->dcb_input_data.src_sg = sctx->src_sg;
-	sctx->dcb_input_data.dst_sg = NULL;
+	ta_ctx->dcb_input_data.app_in_address = src_ptr;
+	ta_ctx->dcb_input_data.data_in_size = req->nbytes - tail_len;
+	ta_ctx->dcb_input_data.app_out_address = NULL;
+	ta_ctx->dcb_input_data.block_size = block_size;
+	ta_ctx->dcb_input_data.tail_block_size = 0;
+	ta_ctx->dcb_input_data.is_applet = 0;
+	ta_ctx->dcb_input_data.src_sg = ta_ctx->src_sg;
+	ta_ctx->dcb_input_data.dst_sg = NULL;
 
 	int_error = sep_create_dcb_dmatables_context_kernel(
-		sctx->sep_used,
-		&sctx->dcb_region,
-		&sctx->dmatables_region,
-		&sctx->dma_ctx,
-		&sctx->dcb_input_data,
+		ta_ctx->sep_used,
+		&ta_ctx->dcb_region,
+		&ta_ctx->dmatables_region,
+		&ta_ctx->dma_ctx,
+		&ta_ctx->dcb_input_data,
 		1);
 	if (int_error) {
-		dev_warn(&sctx->sep_used->pdev->dev,
+		dev_warn(&ta_ctx->sep_used->pdev->dev,
 			"hash update dma table create failed\n");
-		sep_crypto_release(sctx, -EINVAL);
+		sep_crypto_release(sctx, ta_ctx, -EINVAL);
 		return;
 	}
 
 	/* Construct message to SEP */
-	sep_make_header(sctx, &msg_offset, SEP_HASH_SINGLE_OPCODE);
-	sep_write_msg(sctx, &ctx->hash_opmode,
+	sep_make_header(ta_ctx, &msg_offset, SEP_HASH_SINGLE_OPCODE);
+	sep_write_msg(ta_ctx, &ta_ctx->hash_opmode,
 		sizeof(u32), sizeof(u32), &msg_offset, 0);
 
 	msg[0] = (u32)0;
 	msg[1] = (u32)0;
 	msg[2] = (u32)0;
 
-	sep_write_msg(sctx, msg, sizeof(u32) * 3, sizeof(u32) * 3,
+	sep_write_msg(ta_ctx, msg, sizeof(u32) * 3, sizeof(u32) * 3,
 		&msg_offset, 0);
 
 	/* Tail */
-	sep_write_msg(sctx, &tail_len, sizeof(u32),
+	sep_write_msg(ta_ctx, &tail_len, sizeof(u32),
 		sizeof(u32), &msg_offset, 0);
 
 	if (tail_len) {
 		copy_result = sep_copy_offset_sg(
-			sctx->sep_used,
-			sctx->src_sg,
+			ta_ctx->sep_used,
+			ta_ctx->src_sg,
 			req->nbytes - tail_len,
 			small_buf, tail_len);
 
 		if (copy_result != tail_len) {
-			dev_warn(&sctx->sep_used->pdev->dev,
+			dev_warn(&ta_ctx->sep_used->pdev->dev,
 				"sg tail copy failure in hash block\n");
-			sep_crypto_release(sctx, -ENOMEM);
+			sep_crypto_release(sctx, ta_ctx, -ENOMEM);
 			return;
 		}
 
-		sep_write_msg(sctx, small_buf, tail_len,
+		sep_write_msg(ta_ctx, small_buf, tail_len,
 			sizeof(u32) * 32, &msg_offset, 1);
 	} else {
 		msg_offset += sizeof(u32) * 32;
 	}
 
-	sep_end_msg(sctx, msg_offset);
+	sep_end_msg(ta_ctx, msg_offset);
 
-	sctx->done_with_transaction = 0;
-
-	result = sep_crypto_take_sep(sctx);
+	are_we_done_yet = 0;
+	result = sep_crypto_take_sep(ta_ctx);
 	if (result) {
-		dev_warn(&sctx->sep_used->pdev->dev,
+		dev_warn(&ta_ctx->sep_used->pdev->dev,
 			"sep_hash_digest take sep failed\n");
-		sep_crypto_release(sctx, -EINVAL);
+		sep_crypto_release(sctx, ta_ctx, -EINVAL);
 	}
 
-	/**
-	 * Sep is now working. Lets wait up to 5 seconds
-	 * for completion. If it does not complete, we will do
-	 * a crypto release with -EINVAL to release the
-	 * kernel crypto infrastructure and let the system
-	 * continue to boot up
-	 * We have to wait this long because some crypto
-	 * operations can take a while
-	 */
-	dev_dbg(&sctx->sep_used->pdev->dev,
-		"waiting for done with transaction\n");
-
-	sctx->end_time = jiffies + (SEP_TRANSACTION_WAIT_TIME * HZ);
-	while ((time_before(jiffies, sctx->end_time)) &&
-		(!sctx->done_with_transaction))
+	/* now we sit and wait up to a fixed time for completion */
+	end_time = jiffies + (WAIT_TIME * HZ);
+	while ((time_before(jiffies, end_time)) && (are_we_done_yet == 0))
 		schedule();
 
-	dev_dbg(&sctx->sep_used->pdev->dev,
-		"done waiting for done with transaction\n");
-
-	/* are we done? */
-	if (!sctx->done_with_transaction) {
-		/* Nope, lets release and tell crypto no */
-		dev_warn(&sctx->sep_used->pdev->dev,
-			"[PID%d] sep_hash_digest never finished\n",
-			current->pid);
-		sep_crypto_release(sctx, -EINVAL);
+	/* Done waiting; still not done yet? */
+	if (are_we_done_yet == 0) {
+		dev_dbg(&ta_ctx->sep_used->pdev->dev,
+			"hash digest job never got done\n");
+		sep_crypto_release(sctx, ta_ctx, -EINVAL);
+		return;
 	}
+
 }
 
 /**
@@ -2404,6 +2606,7 @@ static void sep_dequeuer(void *data)
 	struct ahash_request *hash_req;
 	struct sep_system_ctx *sctx;
 	struct crypto_ahash *hash_tfm;
+	struct this_task_ctx *ta_ctx;
 
 
 	this_queue = (struct crypto_queue *)data;
@@ -2481,22 +2684,32 @@ static void sep_dequeuer(void *data)
 			return;
 		}
 
-		if (sctx->current_hash_stage == HASH_INIT) {
+		ta_ctx = ahash_request_ctx(hash_req);
+
+		if (ta_ctx->current_hash_stage == HASH_INIT) {
 			pr_debug("sep crypto queue hash init\n");
 			sep_hash_init((void *)hash_req);
 			return;
-		} else if (sctx->current_hash_stage == HASH_UPDATE) {
+		} else if (ta_ctx->current_hash_stage == HASH_UPDATE) {
 			pr_debug("sep crypto queue hash update\n");
 			sep_hash_update((void *)hash_req);
 			return;
-		} else if (sctx->current_hash_stage == HASH_FINISH) {
+		} else if (ta_ctx->current_hash_stage == HASH_FINISH) {
 			pr_debug("sep crypto queue hash final\n");
 			sep_hash_final((void *)hash_req);
 			return;
-		} else if (sctx->current_hash_stage == HASH_DIGEST) {
+		} else if (ta_ctx->current_hash_stage == HASH_DIGEST) {
 			pr_debug("sep crypto queue hash digest\n");
 			sep_hash_digest((void *)hash_req);
 			return;
+		} else if (ta_ctx->current_hash_stage == HASH_FINUP_DATA) {
+			pr_debug("sep crypto queue hash digest\n");
+			sep_hash_update((void *)hash_req);
+			return;
+		} else if (ta_ctx->current_hash_stage == HASH_FINUP_FINISH) {
+			pr_debug("sep crypto queue hash digest\n");
+			sep_hash_final((void *)hash_req);
+			return;
 		} else {
 			pr_debug("sep crypto queue hash oops nothing\n");
 			return;
@@ -2507,605 +2720,671 @@ static void sep_dequeuer(void *data)
 static int sep_sha1_init(struct ahash_request *req)
 {
 	int error;
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct sep_hash_ctx *ctx = ahash_request_ctx(req);
-	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
+	int error1;
+	struct this_task_ctx *ta_ctx = ahash_request_ctx(req);
+
+	pr_debug("sep - doing sha1 init\n");
 
-	dev_dbg(&sctx->sep_used->pdev->dev, "doing sha1 init\n");
-	sctx->current_request = SHA1;
-	sctx->current_hash_req = req;
-	sctx->current_cypher_req = NULL;
-	ctx->hash_opmode = SEP_HASH_SHA1;
-	sctx->current_hash_stage = HASH_INIT;
+	/* Clear out task context */
+	memset(ta_ctx, 0, sizeof(struct this_task_ctx));
 
+	ta_ctx->sep_used = sep_dev;
+	ta_ctx->current_request = SHA1;
+	ta_ctx->current_hash_req = req;
+	ta_ctx->current_cypher_req = NULL;
+	ta_ctx->hash_opmode = SEP_HASH_SHA1;
+	ta_ctx->current_hash_stage = HASH_INIT;
+
+	/* lock necessary so that only one entity touches the queues */
 	spin_lock_irq(&queue_lock);
 	error = crypto_enqueue_request(&sep_queue, &req->base);
-	spin_unlock_irq(&queue_lock);
-
-	if ((error != 0) && (error != -EINPROGRESS)) {
-		dev_warn(&sctx->sep_used->pdev->dev,
-			"sep sha1 init cant enqueue\n");
-		sep_crypto_release(sctx, error);
-		return error;
-	}
 
-	error = sep_submit_work(sctx->sep_used->workqueue, sep_dequeuer,
-		(void *)&sep_queue);
-	if (error) {
-		dev_warn(&sctx->sep_used->pdev->dev,
-			"sha1 init cannot submit queue\n");
-		sep_crypto_release(sctx, -EINVAL);
-		return -EINVAL;
-	}
-	return -EINPROGRESS;
+	if ((error != 0) && (error != -EINPROGRESS))
+		pr_debug(" sep - crypto enqueue failed: %x\n",
+			error);
+	error1 = sep_submit_work(ta_ctx->sep_used->workqueue,
+		sep_dequeuer, (void *)&sep_queue);
+	if (error1)
+		pr_debug(" sep - workqueue submit failed: %x\n",
+			error1);
+	spin_unlock_irq(&queue_lock);
+	/* We return result of crypto enqueue */
+	return error;
 }
 
 static int sep_sha1_update(struct ahash_request *req)
 {
 	int error;
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct sep_hash_ctx *ctx = ahash_request_ctx(req);
-	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
+	int error1;
+	struct this_task_ctx *ta_ctx = ahash_request_ctx(req);
 
-	dev_dbg(&sctx->sep_used->pdev->dev, "doing sha1 update\n");
-	sctx->current_request = SHA1;
-	sctx->current_hash_req = req;
-	sctx->current_cypher_req = NULL;
-	ctx->hash_opmode = SEP_HASH_SHA1;
-	sctx->current_hash_stage = HASH_INIT;
+	pr_debug("sep - doing sha1 update\n");
 
+	ta_ctx->sep_used = sep_dev;
+	ta_ctx->current_request = SHA1;
+	ta_ctx->current_hash_req = req;
+	ta_ctx->current_cypher_req = NULL;
+	ta_ctx->hash_opmode = SEP_HASH_SHA1;
+	ta_ctx->current_hash_stage = HASH_UPDATE;
+
+	/* lock necessary so that only one entity touches the queues */
 	spin_lock_irq(&queue_lock);
 	error = crypto_enqueue_request(&sep_queue, &req->base);
-	spin_unlock_irq(&queue_lock);
-
-	if ((error != 0) && (error != -EINPROGRESS)) {
-		dev_warn(&sctx->sep_used->pdev->dev,
-			"sep sha1 update cant enqueue\n");
-		sep_crypto_release(sctx, error);
-		return error;
-	}
 
-	error = sep_submit_work(sctx->sep_used->workqueue, sep_dequeuer,
-		(void *)&sep_queue);
-	if (error) {
-		dev_warn(&sctx->sep_used->pdev->dev,
-			"sha1 update cannot submit queue\n");
-		sep_crypto_release(sctx, -EINVAL);
-		return -EINVAL;
-	}
-	return -EINPROGRESS;
+	if ((error != 0) && (error != -EINPROGRESS))
+		pr_debug(" sep - crypto enqueue failed: %x\n",
+			error);
+	error1 = sep_submit_work(ta_ctx->sep_used->workqueue,
+		sep_dequeuer, (void *)&sep_queue);
+	if (error1)
+		pr_debug(" sep - workqueue submit failed: %x\n",
+			error1);
+	spin_unlock_irq(&queue_lock);
+	/* We return result of crypto enqueue */
+	return error;
 }
 
 static int sep_sha1_final(struct ahash_request *req)
 {
 	int error;
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct sep_hash_ctx *ctx = ahash_request_ctx(req);
-	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
-	dev_dbg(&sctx->sep_used->pdev->dev, "doing sha1 final\n");
-
-	sctx->current_request = SHA1;
-	sctx->current_hash_req = req;
-	sctx->current_cypher_req = NULL;
-	ctx->hash_opmode = SEP_HASH_SHA1;
-	sctx->current_hash_stage = HASH_FINISH;
-
+	int error1;
+	struct this_task_ctx *ta_ctx = ahash_request_ctx(req);
+	pr_debug("sep - doing sha1 final\n");
+
+	ta_ctx->sep_used = sep_dev;
+	ta_ctx->current_request = SHA1;
+	ta_ctx->current_hash_req = req;
+	ta_ctx->current_cypher_req = NULL;
+	ta_ctx->hash_opmode = SEP_HASH_SHA1;
+	ta_ctx->current_hash_stage = HASH_FINISH;
+
+	/* lock necessary so that only one entity touches the queues */
 	spin_lock_irq(&queue_lock);
 	error = crypto_enqueue_request(&sep_queue, &req->base);
-	spin_unlock_irq(&queue_lock);
-
-	if ((error != 0) && (error != -EINPROGRESS)) {
-		dev_warn(&sctx->sep_used->pdev->dev,
-			"sep sha1 final cant enqueue\n");
-		sep_crypto_release(sctx, error);
-		return error;
-	}
-
-	error = sep_submit_work(sctx->sep_used->workqueue, sep_dequeuer,
-		(void *)&sep_queue);
-	if (error) {
-		dev_warn(&sctx->sep_used->pdev->dev,
-			"sha1 final cannot submit queue\n");
-		sep_crypto_release(sctx, -EINVAL);
-		return -EINVAL;
-	}
-	return -EINPROGRESS;
 
+	if ((error != 0) && (error != -EINPROGRESS))
+		pr_debug(" sep - crypto enqueue failed: %x\n",
+			error);
+	error1 = sep_submit_work(ta_ctx->sep_used->workqueue,
+		sep_dequeuer, (void *)&sep_queue);
+	if (error1)
+		pr_debug(" sep - workqueue submit failed: %x\n",
+			error1);
+	spin_unlock_irq(&queue_lock);
+	/* We return result of crypto enqueue */
+	return error;
 }
 
 static int sep_sha1_digest(struct ahash_request *req)
 {
 	int error;
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct sep_hash_ctx *ctx = ahash_request_ctx(req);
-	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
-	dev_dbg(&sctx->sep_used->pdev->dev, "doing sha1 digest\n");
+	int error1;
+	struct this_task_ctx *ta_ctx = ahash_request_ctx(req);
+	pr_debug("sep - doing sha1 digest\n");
 
-	sctx->current_request = SHA1;
-	sctx->current_hash_req = req;
-	sctx->current_cypher_req = NULL;
-	ctx->hash_opmode = SEP_HASH_SHA1;
-	sctx->current_hash_stage = HASH_DIGEST;
+	/* Clear out task context */
+	memset(ta_ctx, 0, sizeof(struct this_task_ctx));
 
+	ta_ctx->sep_used = sep_dev;
+	ta_ctx->current_request = SHA1;
+	ta_ctx->current_hash_req = req;
+	ta_ctx->current_cypher_req = NULL;
+	ta_ctx->hash_opmode = SEP_HASH_SHA1;
+	ta_ctx->current_hash_stage = HASH_DIGEST;
+
+	/* lock necessary so that only one entity touches the queues */
 	spin_lock_irq(&queue_lock);
 	error = crypto_enqueue_request(&sep_queue, &req->base);
-	spin_unlock_irq(&queue_lock);
 
-	if ((error != 0) && (error != -EINPROGRESS)) {
-		dev_warn(&sctx->sep_used->pdev->dev,
-			"sep sha1 digest cant enqueue\n");
-		sep_crypto_release(sctx, error);
-		return error;
-	}
+	if ((error != 0) && (error != -EINPROGRESS))
+		pr_debug(" sep - crypto enqueue failed: %x\n",
+			error);
+	error1 = sep_submit_work(ta_ctx->sep_used->workqueue,
+		sep_dequeuer, (void *)&sep_queue);
+	if (error1)
+		pr_debug(" sep - workqueue submit failed: %x\n",
+			error1);
+	spin_unlock_irq(&queue_lock);
+	/* We return result of crypto enqueue */
+	return error;
+}
 
-	error = sep_submit_work(sctx->sep_used->workqueue, sep_dequeuer,
-		(void *)&sep_queue);
-	if (error) {
-		dev_warn(&sctx->sep_used->pdev->dev,
-			"sha1 digest cannot submit queue\n");
-		sep_crypto_release(sctx, -EINVAL);
-		return -EINVAL;
-	}
-	return -EINPROGRESS;
+static int sep_sha1_finup(struct ahash_request *req)
+{
+	int error;
+	int error1;
+	struct this_task_ctx *ta_ctx = ahash_request_ctx(req);
+	pr_debug("sep - doing sha1 finup\n");
+
+	ta_ctx->sep_used = sep_dev;
+	ta_ctx->current_request = SHA1;
+	ta_ctx->current_hash_req = req;
+	ta_ctx->current_cypher_req = NULL;
+	ta_ctx->hash_opmode = SEP_HASH_SHA1;
+	ta_ctx->current_hash_stage = HASH_FINUP_DATA;
+
+	/* lock necessary so that only one entity touches the queues */
+	spin_lock_irq(&queue_lock);
+	error = crypto_enqueue_request(&sep_queue, &req->base);
 
+	if ((error != 0) && (error != -EINPROGRESS))
+		pr_debug(" sep - crypto enqueue failed: %x\n",
+			error);
+	error1 = sep_submit_work(ta_ctx->sep_used->workqueue,
+		sep_dequeuer, (void *)&sep_queue);
+	if (error1)
+		pr_debug(" sep - workqueue submit failed: %x\n",
+			error1);
+	spin_unlock_irq(&queue_lock);
+	/* We return result of crypto enqueue */
+	return error;
 }
 
 static int sep_md5_init(struct ahash_request *req)
 {
 	int error;
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct sep_hash_ctx *ctx = ahash_request_ctx(req);
-	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
-	dev_dbg(&sctx->sep_used->pdev->dev, "doing md5 init\n");
+	int error1;
+	struct this_task_ctx *ta_ctx = ahash_request_ctx(req);
+	pr_debug("sep - doing md5 init\n");
+
+	/* Clear out task context */
+	memset(ta_ctx, 0, sizeof(struct this_task_ctx));
 
-	sctx->current_request = MD5;
-	sctx->current_hash_req = req;
-	sctx->current_cypher_req = NULL;
-	ctx->hash_opmode = SEP_HASH_MD5;
-	sctx->current_hash_stage = HASH_INIT;
+	ta_ctx->sep_used = sep_dev;
+	ta_ctx->current_request = MD5;
+	ta_ctx->current_hash_req = req;
+	ta_ctx->current_cypher_req = NULL;
+	ta_ctx->hash_opmode = SEP_HASH_MD5;
+	ta_ctx->current_hash_stage = HASH_INIT;
 
+	/* lock necessary so that only one entity touches the queues */
 	spin_lock_irq(&queue_lock);
 	error = crypto_enqueue_request(&sep_queue, &req->base);
-	spin_unlock_irq(&queue_lock);
-
-	if ((error != 0) && (error != -EINPROGRESS)) {
-		dev_warn(&sctx->sep_used->pdev->dev,
-			"sep md5 init cant enqueue\n");
-		sep_crypto_release(sctx, error);
-		return error;
-	}
-
-	error = sep_submit_work(sctx->sep_used->workqueue, sep_dequeuer,
-		(void *)&sep_queue);
-	if (error) {
-		dev_warn(&sctx->sep_used->pdev->dev,
-			"md5 init cannot submit queue\n");
-		sep_crypto_release(sctx, -EINVAL);
-		return -EINVAL;
-	}
-	return -EINPROGRESS;
 
+	if ((error != 0) && (error != -EINPROGRESS))
+		pr_debug(" sep - crypto enqueue failed: %x\n",
+			error);
+	error1 = sep_submit_work(ta_ctx->sep_used->workqueue,
+		sep_dequeuer, (void *)&sep_queue);
+	if (error1)
+		pr_debug(" sep - workqueue submit failed: %x\n",
+			error1);
+	spin_unlock_irq(&queue_lock);
+	/* We return result of crypto enqueue */
+	return error;
 }
 
 static int sep_md5_update(struct ahash_request *req)
 {
 	int error;
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct sep_hash_ctx *ctx = ahash_request_ctx(req);
-	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
-	dev_dbg(&sctx->sep_used->pdev->dev, "doing md5 update\n");
-
-	sctx->current_request = MD5;
-	sctx->current_hash_req = req;
-	sctx->current_cypher_req = NULL;
-	ctx->hash_opmode = SEP_HASH_MD5;
-	sctx->current_hash_stage = HASH_UPDATE;
-
+	int error1;
+	struct this_task_ctx *ta_ctx = ahash_request_ctx(req);
+	pr_debug("sep - doing md5 update\n");
+
+	ta_ctx->sep_used = sep_dev;
+	ta_ctx->current_request = MD5;
+	ta_ctx->current_hash_req = req;
+	ta_ctx->current_cypher_req = NULL;
+	ta_ctx->hash_opmode = SEP_HASH_MD5;
+	ta_ctx->current_hash_stage = HASH_UPDATE;
+
+	/* lock necessary so that only one entity touches the queues */
 	spin_lock_irq(&queue_lock);
 	error = crypto_enqueue_request(&sep_queue, &req->base);
-	spin_unlock_irq(&queue_lock);
 
-	if ((error != 0) && (error != -EINPROGRESS)) {
-		dev_warn(&sctx->sep_used->pdev->dev,
-			"md5 update cant enqueue\n");
-		sep_crypto_release(sctx, error);
-		return error;
-	}
-
-	error = sep_submit_work(sctx->sep_used->workqueue, sep_dequeuer,
-		(void *)&sep_queue);
-	if (error) {
-		dev_warn(&sctx->sep_used->pdev->dev,
-			"md5 update cannot submit queue\n");
-		sep_crypto_release(sctx, -EINVAL);
-		return -EINVAL;
-	}
-	return -EINPROGRESS;
+	if ((error != 0) && (error != -EINPROGRESS))
+		pr_debug(" sep - crypto enqueue failed: %x\n",
+			error);
+	error1 = sep_submit_work(ta_ctx->sep_used->workqueue,
+		sep_dequeuer, (void *)&sep_queue);
+	if (error1)
+		pr_debug(" sep - workqueue submit failed: %x\n",
+			error1);
+	spin_unlock_irq(&queue_lock);
+	/* We return result of crypto enqueue */
+	return error;
 }
 
 static int sep_md5_final(struct ahash_request *req)
 {
 	int error;
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct sep_hash_ctx *ctx = ahash_request_ctx(req);
-	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
-	dev_dbg(&sctx->sep_used->pdev->dev, "doing md5 final\n");
-
-	sctx->current_request = MD5;
-	sctx->current_hash_req = req;
-	sctx->current_cypher_req = NULL;
-	ctx->hash_opmode = SEP_HASH_MD5;
-	sctx->current_hash_stage = HASH_FINISH;
-
+	int error1;
+	struct this_task_ctx *ta_ctx = ahash_request_ctx(req);
+	pr_debug("sep - doing md5 final\n");
+
+	ta_ctx->sep_used = sep_dev;
+	ta_ctx->current_request = MD5;
+	ta_ctx->current_hash_req = req;
+	ta_ctx->current_cypher_req = NULL;
+	ta_ctx->hash_opmode = SEP_HASH_MD5;
+	ta_ctx->current_hash_stage = HASH_FINISH;
+
+	/* lock necessary so that only one entity touches the queues */
 	spin_lock_irq(&queue_lock);
 	error = crypto_enqueue_request(&sep_queue, &req->base);
-	spin_unlock_irq(&queue_lock);
-
-	if ((error != 0) && (error != -EINPROGRESS)) {
-		dev_warn(&sctx->sep_used->pdev->dev,
-			"sep md5 final cant enqueue\n");
-		sep_crypto_release(sctx, error);
-		return error;
-	}
-
-	error = sep_submit_work(sctx->sep_used->workqueue, sep_dequeuer,
-		(void *)&sep_queue);
-	if (error) {
-		dev_warn(&sctx->sep_used->pdev->dev,
-			"md5 final cannot submit queue\n");
-		sep_crypto_release(sctx, -EINVAL);
-		return -EINVAL;
-	}
-	return -EINPROGRESS;
 
+	if ((error != 0) && (error != -EINPROGRESS))
+		pr_debug(" sep - crypto enqueue failed: %x\n",
+			error);
+	error1 = sep_submit_work(ta_ctx->sep_used->workqueue,
+		sep_dequeuer, (void *)&sep_queue);
+	if (error1)
+		pr_debug(" sep - workqueue submit failed: %x\n",
+			error1);
+	spin_unlock_irq(&queue_lock);
+	/* We return result of crypto enqueue */
+	return error;
 }
 
 static int sep_md5_digest(struct ahash_request *req)
 {
 	int error;
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct sep_hash_ctx *ctx = ahash_request_ctx(req);
-	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
+	int error1;
+	struct this_task_ctx *ta_ctx = ahash_request_ctx(req);
 
-	dev_dbg(&sctx->sep_used->pdev->dev, "doing md5 digest\n");
-	sctx->current_request = MD5;
-	sctx->current_hash_req = req;
-	sctx->current_cypher_req = NULL;
-	ctx->hash_opmode = SEP_HASH_MD5;
-	sctx->current_hash_stage = HASH_DIGEST;
+	pr_debug("sep - doing md5 digest\n");
 
+	/* Clear out task context */
+	memset(ta_ctx, 0, sizeof(struct this_task_ctx));
+
+	ta_ctx->sep_used = sep_dev;
+	ta_ctx->current_request = MD5;
+	ta_ctx->current_hash_req = req;
+	ta_ctx->current_cypher_req = NULL;
+	ta_ctx->hash_opmode = SEP_HASH_MD5;
+	ta_ctx->current_hash_stage = HASH_DIGEST;
+
+	/* lock necessary so that only one entity touches the queues */
 	spin_lock_irq(&queue_lock);
 	error = crypto_enqueue_request(&sep_queue, &req->base);
-	spin_unlock_irq(&queue_lock);
-
-	if ((error != 0) && (error != -EINPROGRESS)) {
-		dev_warn(&sctx->sep_used->pdev->dev,
-			"sep md5 digest cant enqueue\n");
-		sep_crypto_release(sctx, error);
-		return error;
-	}
 
-	error = sep_submit_work(sctx->sep_used->workqueue, sep_dequeuer,
-		(void *)&sep_queue);
-	if (error) {
-		dev_warn(&sctx->sep_used->pdev->dev,
-			"md5 digest cannot submit queue\n");
-		sep_crypto_release(sctx, -EINVAL);
-		return -EINVAL;
-	}
-	return -EINPROGRESS;
+	if ((error != 0) && (error != -EINPROGRESS))
+		pr_debug(" sep - crypto enqueue failed: %x\n",
+			error);
+	error1 = sep_submit_work(ta_ctx->sep_used->workqueue,
+		sep_dequeuer, (void *)&sep_queue);
+	if (error1)
+		pr_debug(" sep - workqueue submit failed: %x\n",
+			error1);
+	spin_unlock_irq(&queue_lock);
+	/* We return result of crypto enqueue */
+	return error;
 }
 
-static int sep_sha224_init(struct ahash_request *req)
+static int sep_md5_finup(struct ahash_request *req)
 {
 	int error;
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct sep_hash_ctx *ctx = ahash_request_ctx(req);
-	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
-	dev_dbg(&sctx->sep_used->pdev->dev, "doing sha224 init\n");
+	int error1;
+	struct this_task_ctx *ta_ctx = ahash_request_ctx(req);
+
+	pr_debug("sep - doing md5 finup\n");
 
-	sctx->current_request = SHA224;
-	sctx->current_hash_req = req;
-	sctx->current_cypher_req = NULL;
-	ctx->hash_opmode = SEP_HASH_SHA224;
-	sctx->current_hash_stage = HASH_INIT;
+	ta_ctx->sep_used = sep_dev;
+	ta_ctx->current_request = MD5;
+	ta_ctx->current_hash_req = req;
+	ta_ctx->current_cypher_req = NULL;
+	ta_ctx->hash_opmode = SEP_HASH_MD5;
+	ta_ctx->current_hash_stage = HASH_FINUP_DATA;
 
+	/* lock necessary so that only one entity touches the queues */
 	spin_lock_irq(&queue_lock);
 	error = crypto_enqueue_request(&sep_queue, &req->base);
-	spin_unlock_irq(&queue_lock);
-
-	if ((error != 0) && (error != -EINPROGRESS)) {
-		dev_warn(&sctx->sep_used->pdev->dev,
-			"sep sha224 init cant enqueue\n");
-		sep_crypto_release(sctx, error);
-		return error;
-	}
 
-	error = sep_submit_work(sctx->sep_used->workqueue, sep_dequeuer,
-		(void *)&sep_queue);
-	if (error) {
-		dev_warn(&sctx->sep_used->pdev->dev,
-			"sha224 init cannot submit queue\n");
-		sep_crypto_release(sctx, -EINVAL);
-		return -EINVAL;
-	}
-	return -EINPROGRESS;
+	if ((error != 0) && (error != -EINPROGRESS))
+		pr_debug(" sep - crypto enqueue failed: %x\n",
+			error);
+	error1 = sep_submit_work(ta_ctx->sep_used->workqueue,
+		sep_dequeuer, (void *)&sep_queue);
+	if (error1)
+		pr_debug(" sep - workqueue submit failed: %x\n",
+			error1);
+	spin_unlock_irq(&queue_lock);
+	/* We return result of crypto enqueue */
+	return error;
 }
 
-static int sep_sha224_update(struct ahash_request *req)
+static int sep_sha224_init(struct ahash_request *req)
 {
 	int error;
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct sep_hash_ctx *ctx = ahash_request_ctx(req);
-	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
-	dev_dbg(&sctx->sep_used->pdev->dev, "doing sha224 update\n");
+	int error1;
+	struct this_task_ctx *ta_ctx = ahash_request_ctx(req);
+	pr_debug("sep - doing sha224 init\n");
+
+	/* Clear out task context */
+	memset(ta_ctx, 0, sizeof(struct this_task_ctx));
 
-	sctx->current_request = SHA224;
-	sctx->current_hash_req = req;
-	sctx->current_cypher_req = NULL;
-	ctx->hash_opmode = SEP_HASH_SHA224;
-	sctx->current_hash_stage = HASH_UPDATE;
+	ta_ctx->sep_used = sep_dev;
+	ta_ctx->current_request = SHA224;
+	ta_ctx->current_hash_req = req;
+	ta_ctx->current_cypher_req = NULL;
+	ta_ctx->hash_opmode = SEP_HASH_SHA224;
+	ta_ctx->current_hash_stage = HASH_INIT;
 
+	/* lock necessary so that only one entity touches the queues */
 	spin_lock_irq(&queue_lock);
 	error = crypto_enqueue_request(&sep_queue, &req->base);
+
+	if ((error != 0) && (error != -EINPROGRESS))
+		pr_debug(" sep - crypto enqueue failed: %x\n",
+			error);
+	error1 = sep_submit_work(ta_ctx->sep_used->workqueue,
+		sep_dequeuer, (void *)&sep_queue);
+	if (error1)
+		pr_debug(" sep - workqueue submit failed: %x\n",
+			error1);
 	spin_unlock_irq(&queue_lock);
+	/* We return result of crypto enqueue */
+	return error;
+}
 
-	if ((error != 0) && (error != -EINPROGRESS)) {
-		dev_warn(&sctx->sep_used->pdev->dev,
-			"sep sha224 update cant enqueue\n");
-		sep_crypto_release(sctx, error);
-		return error;
-	}
+static int sep_sha224_update(struct ahash_request *req)
+{
+	int error;
+	int error1;
+	struct this_task_ctx *ta_ctx = ahash_request_ctx(req);
+	pr_debug("sep - doing sha224 update\n");
+
+	ta_ctx->sep_used = sep_dev;
+	ta_ctx->current_request = SHA224;
+	ta_ctx->current_hash_req = req;
+	ta_ctx->current_cypher_req = NULL;
+	ta_ctx->hash_opmode = SEP_HASH_SHA224;
+	ta_ctx->current_hash_stage = HASH_UPDATE;
+
+	/* lock necessary so that only one entity touches the queues */
+	spin_lock_irq(&queue_lock);
+	error = crypto_enqueue_request(&sep_queue, &req->base);
 
-	error = sep_submit_work(sctx->sep_used->workqueue, sep_dequeuer,
-		(void *)&sep_queue);
-	if (error) {
-		dev_warn(&sctx->sep_used->pdev->dev,
-			"sha224 update cannot submit queue\n");
-		sep_crypto_release(sctx, -EINVAL);
-		return -EINVAL;
-	}
-	return -EINPROGRESS;
+	if ((error != 0) && (error != -EINPROGRESS))
+		pr_debug(" sep - crypto enqueue failed: %x\n",
+			error);
+	error1 = sep_submit_work(ta_ctx->sep_used->workqueue,
+		sep_dequeuer, (void *)&sep_queue);
+	if (error1)
+		pr_debug(" sep - workqueue submit failed: %x\n",
+			error1);
+	spin_unlock_irq(&queue_lock);
+	/* We return result of crypto enqueue */
+	return error;
 }
 
 static int sep_sha224_final(struct ahash_request *req)
 {
 	int error;
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct sep_hash_ctx *ctx = ahash_request_ctx(req);
-	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
-	dev_dbg(&sctx->sep_used->pdev->dev, "doing sha224 final\n");
-
-	sctx->current_request = SHA224;
-	sctx->current_hash_req = req;
-	sctx->current_cypher_req = NULL;
-	ctx->hash_opmode = SEP_HASH_SHA224;
-	sctx->current_hash_stage = HASH_FINISH;
-
+	int error1;
+	struct this_task_ctx *ta_ctx = ahash_request_ctx(req);
+	pr_debug("sep - doing sha224 final\n");
+
+	ta_ctx->sep_used = sep_dev;
+	ta_ctx->current_request = SHA224;
+	ta_ctx->current_hash_req = req;
+	ta_ctx->current_cypher_req = NULL;
+	ta_ctx->hash_opmode = SEP_HASH_SHA224;
+	ta_ctx->current_hash_stage = HASH_FINISH;
+
+	/* lock necessary so that only one entity touches the queues */
 	spin_lock_irq(&queue_lock);
 	error = crypto_enqueue_request(&sep_queue, &req->base);
-	spin_unlock_irq(&queue_lock);
 
-	if ((error != 0) && (error != -EINPROGRESS)) {
-		dev_warn(&sctx->sep_used->pdev->dev,
-			"sep sha224 final cant enqueue\n");
-		sep_crypto_release(sctx, error);
-		return error;
-	}
-
-	error = sep_submit_work(sctx->sep_used->workqueue, sep_dequeuer,
-		(void *)&sep_queue);
-	if (error) {
-		dev_warn(&sctx->sep_used->pdev->dev,
-			"sha224 final cannot submit queue\n");
-		sep_crypto_release(sctx, -EINVAL);
-		return -EINVAL;
-	}
-	return -EINPROGRESS;
+	if ((error != 0) && (error != -EINPROGRESS))
+		pr_debug(" sep - crypto enqueue failed: %x\n",
+			error);
+	error1 = sep_submit_work(ta_ctx->sep_used->workqueue,
+		sep_dequeuer, (void *)&sep_queue);
+	if (error1)
+		pr_debug(" sep - workqueue submit failed: %x\n",
+			error1);
+	spin_unlock_irq(&queue_lock);
+	/* We return result of crypto enqueue */
+	return error;
 }
 
 static int sep_sha224_digest(struct ahash_request *req)
 {
 	int error;
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct sep_hash_ctx *ctx = ahash_request_ctx(req);
-	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
+	int error1;
+	struct this_task_ctx *ta_ctx = ahash_request_ctx(req);
+
+	pr_debug("sep - doing sha224 digest\n");
 
-	dev_dbg(&sctx->sep_used->pdev->dev, "doing 224 digest\n");
-	sctx->current_request = SHA224;
-	sctx->current_hash_req = req;
-	sctx->current_cypher_req = NULL;
-	ctx->hash_opmode = SEP_HASH_SHA224;
-	sctx->current_hash_stage = HASH_DIGEST;
+	/* Clear out task context */
+	memset(ta_ctx, 0, sizeof(struct this_task_ctx));
 
+	ta_ctx->sep_used = sep_dev;
+	ta_ctx->current_request = SHA224;
+	ta_ctx->current_hash_req = req;
+	ta_ctx->current_cypher_req = NULL;
+	ta_ctx->hash_opmode = SEP_HASH_SHA224;
+	ta_ctx->current_hash_stage = HASH_DIGEST;
+
+	/* lock necessary so that only one entity touches the queues */
 	spin_lock_irq(&queue_lock);
 	error = crypto_enqueue_request(&sep_queue, &req->base);
-	spin_unlock_irq(&queue_lock);
 
-	if ((error != 0) && (error != -EINPROGRESS)) {
-		dev_warn(&sctx->sep_used->pdev->dev,
-			"sep sha224 digest cant enqueue\n");
-		sep_crypto_release(sctx, error);
-		return error;
-	}
-
-	error = sep_submit_work(sctx->sep_used->workqueue, sep_dequeuer,
-		(void *)&sep_queue);
-	if (error) {
-		dev_warn(&sctx->sep_used->pdev->dev,
-			"sha256 digest cannot submit queue\n");
-		sep_crypto_release(sctx, -EINVAL);
-		return -EINVAL;
-	}
-	return -EINPROGRESS;
+	if ((error != 0) && (error != -EINPROGRESS))
+		pr_debug(" sep - crypto enqueue failed: %x\n",
+			error);
+	error1 = sep_submit_work(ta_ctx->sep_used->workqueue,
+		sep_dequeuer, (void *)&sep_queue);
+	if (error1)
+		pr_debug(" sep - workqueue submit failed: %x\n",
+			error1);
+	spin_unlock_irq(&queue_lock);
+	/* We return result of crypto enqueue */
+	return error;
 }
 
-static int sep_sha256_init(struct ahash_request *req)
+static int sep_sha224_finup(struct ahash_request *req)
 {
 	int error;
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct sep_hash_ctx *ctx = ahash_request_ctx(req);
-	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
-	dev_dbg(&sctx->sep_used->pdev->dev, "doing sha256 init\n");
+	int error1;
+	struct this_task_ctx *ta_ctx = ahash_request_ctx(req);
+
+	pr_debug("sep - doing sha224 finup\n");
 
-	sctx->current_request = SHA256;
-	sctx->current_hash_req = req;
-	sctx->current_cypher_req = NULL;
-	ctx->hash_opmode = SEP_HASH_SHA256;
-	sctx->current_hash_stage = HASH_INIT;
+	ta_ctx->sep_used = sep_dev;
+	ta_ctx->current_request = SHA224;
+	ta_ctx->current_hash_req = req;
+	ta_ctx->current_cypher_req = NULL;
+	ta_ctx->hash_opmode = SEP_HASH_SHA224;
+	ta_ctx->current_hash_stage = HASH_FINUP_DATA;
 
+	/* lock necessary so that only one entity touches the queues */
 	spin_lock_irq(&queue_lock);
 	error = crypto_enqueue_request(&sep_queue, &req->base);
-	spin_unlock_irq(&queue_lock);
 
-	if ((error != 0) && (error != -EINPROGRESS)) {
-		dev_warn(&sctx->sep_used->pdev->dev,
-			"sep sha256 init cant enqueue\n");
-		sep_crypto_release(sctx, error);
-		return error;
-	}
-
-	error = sep_submit_work(sctx->sep_used->workqueue, sep_dequeuer,
-		(void *)&sep_queue);
-	if (error) {
-		dev_warn(&sctx->sep_used->pdev->dev,
-			"sha256 init cannot submit queue\n");
-		sep_crypto_release(sctx, -EINVAL);
-		return -EINVAL;
-	}
-	return -EINPROGRESS;
+	if ((error != 0) && (error != -EINPROGRESS))
+		pr_debug(" sep - crypto enqueue failed: %x\n",
+			error);
+	error1 = sep_submit_work(ta_ctx->sep_used->workqueue,
+		sep_dequeuer, (void *)&sep_queue);
+	if (error1)
+		pr_debug(" sep - workqueue submit failed: %x\n",
+			error1);
+	spin_unlock_irq(&queue_lock);
+	/* We return result of crypto enqueue */
+	return error;
 }
 
-static int sep_sha256_update(struct ahash_request *req)
+static int sep_sha256_init(struct ahash_request *req)
 {
 	int error;
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct sep_hash_ctx *ctx = ahash_request_ctx(req);
-	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
-	dev_dbg(&sctx->sep_used->pdev->dev, "doing sha256 update\n");
+	int error1;
+	struct this_task_ctx *ta_ctx = ahash_request_ctx(req);
+	pr_debug("sep - doing sha256 init\n");
+
+	/* Clear out task context */
+	memset(ta_ctx, 0, sizeof(struct this_task_ctx));
 
-	sctx->current_request = SHA256;
-	sctx->current_hash_req = req;
-	sctx->current_cypher_req = NULL;
-	ctx->hash_opmode = SEP_HASH_SHA256;
-	sctx->current_hash_stage = HASH_UPDATE;
+	ta_ctx->sep_used = sep_dev;
+	ta_ctx->current_request = SHA256;
+	ta_ctx->current_hash_req = req;
+	ta_ctx->current_cypher_req = NULL;
+	ta_ctx->hash_opmode = SEP_HASH_SHA256;
+	ta_ctx->current_hash_stage = HASH_INIT;
 
+	/* lock necessary so that only one entity touches the queues */
 	spin_lock_irq(&queue_lock);
 	error = crypto_enqueue_request(&sep_queue, &req->base);
+
+	if ((error != 0) && (error != -EINPROGRESS))
+		pr_debug(" sep - crypto enqueue failed: %x\n",
+			error);
+	error1 = sep_submit_work(ta_ctx->sep_used->workqueue,
+		sep_dequeuer, (void *)&sep_queue);
+	if (error1)
+		pr_debug(" sep - workqueue submit failed: %x\n",
+			error1);
 	spin_unlock_irq(&queue_lock);
+	/* We return result of crypto enqueue */
+	return error;
+}
 
-	if ((error != 0) && (error != -EINPROGRESS)) {
-		dev_warn(&sctx->sep_used->pdev->dev,
-			"sep sha256 update cant enqueue\n");
-		sep_crypto_release(sctx, error);
-		return error;
-	}
+static int sep_sha256_update(struct ahash_request *req)
+{
+	int error;
+	int error1;
+	struct this_task_ctx *ta_ctx = ahash_request_ctx(req);
+	pr_debug("sep - doing sha256 update\n");
+
+	ta_ctx->sep_used = sep_dev;
+	ta_ctx->current_request = SHA256;
+	ta_ctx->current_hash_req = req;
+	ta_ctx->current_cypher_req = NULL;
+	ta_ctx->hash_opmode = SEP_HASH_SHA256;
+	ta_ctx->current_hash_stage = HASH_UPDATE;
+
+	/* lock necessary so that only one entity touches the queues */
+	spin_lock_irq(&queue_lock);
+	error = crypto_enqueue_request(&sep_queue, &req->base);
 
-	error = sep_submit_work(sctx->sep_used->workqueue, sep_dequeuer,
-		(void *)&sep_queue);
-	if (error) {
-		dev_warn(&sctx->sep_used->pdev->dev,
-			"sha256 update cannot submit queue\n");
-		sep_crypto_release(sctx, -EINVAL);
-		return -EINVAL;
-	}
-	return -EINPROGRESS;
+	if ((error != 0) && (error != -EINPROGRESS))
+		pr_debug(" sep - crypto enqueue failed: %x\n",
+			error);
+	error1 = sep_submit_work(ta_ctx->sep_used->workqueue,
+		sep_dequeuer, (void *)&sep_queue);
+	if (error1)
+		pr_debug(" sep - workqueue submit failed: %x\n",
+			error1);
+	spin_unlock_irq(&queue_lock);
+	/* We return result of crypto enqueue */
+	return error;
 }
 
 static int sep_sha256_final(struct ahash_request *req)
 {
 	int error;
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct sep_hash_ctx *ctx = ahash_request_ctx(req);
-	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
-	dev_dbg(&sctx->sep_used->pdev->dev, "doing sha256 final\n");
-
-	sctx->current_request = SHA256;
-	sctx->current_hash_req = req;
-	sctx->current_cypher_req = NULL;
-	ctx->hash_opmode = SEP_HASH_SHA256;
-	sctx->current_hash_stage = HASH_FINISH;
-
+	int error1;
+	struct this_task_ctx *ta_ctx = ahash_request_ctx(req);
+	pr_debug("sep - doing sha256 final\n");
+
+	ta_ctx->sep_used = sep_dev;
+	ta_ctx->current_request = SHA256;
+	ta_ctx->current_hash_req = req;
+	ta_ctx->current_cypher_req = NULL;
+	ta_ctx->hash_opmode = SEP_HASH_SHA256;
+	ta_ctx->current_hash_stage = HASH_FINISH;
+
+	/* lock necessary so that only one entity touches the queues */
 	spin_lock_irq(&queue_lock);
 	error = crypto_enqueue_request(&sep_queue, &req->base);
-	spin_unlock_irq(&queue_lock);
 
-	if ((error != 0) && (error != -EINPROGRESS)) {
-		dev_warn(&sctx->sep_used->pdev->dev,
-			"sep sha256 final cant enqueue\n");
-		sep_crypto_release(sctx, error);
-		return error;
-	}
-
-	error = sep_submit_work(sctx->sep_used->workqueue, sep_dequeuer,
-		(void *)&sep_queue);
-	if (error) {
-		dev_warn(&sctx->sep_used->pdev->dev,
-			"sha256 final cannot submit queue\n");
-		sep_crypto_release(sctx, -EINVAL);
-		return -EINVAL;
-	}
-	return -EINPROGRESS;
+	if ((error != 0) && (error != -EINPROGRESS))
+		pr_debug(" sep - crypto enqueue failed: %x\n",
+			error);
+	error1 = sep_submit_work(ta_ctx->sep_used->workqueue,
+		sep_dequeuer, (void *)&sep_queue);
+	if (error1)
+		pr_debug(" sep - workqueue submit failed: %x\n",
+			error1);
+	spin_unlock_irq(&queue_lock);
+	/* We return result of crypto enqueue */
+	return error;
 }
 
 static int sep_sha256_digest(struct ahash_request *req)
 {
 	int error;
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct sep_hash_ctx *ctx = ahash_request_ctx(req);
-	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
+	int error1;
+	struct this_task_ctx *ta_ctx = ahash_request_ctx(req);
+
+	pr_debug("sep - doing sha256 digest\n");
+
+	/* Clear out task context */
+	memset(ta_ctx, 0, sizeof(struct this_task_ctx));
 
-	dev_dbg(&sctx->sep_used->pdev->dev, "doing sha256 digest\n");
-	sctx->current_request = SHA256;
-	sctx->current_hash_req = req;
-	sctx->current_cypher_req = NULL;
-	ctx->hash_opmode = SEP_HASH_SHA256;
-	sctx->current_hash_stage = HASH_DIGEST;
+	ta_ctx->sep_used = sep_dev;
+	ta_ctx->current_request = SHA256;
+	ta_ctx->current_hash_req = req;
+	ta_ctx->current_cypher_req = NULL;
+	ta_ctx->hash_opmode = SEP_HASH_SHA256;
+	ta_ctx->current_hash_stage = HASH_DIGEST;
 
+	/* lock necessary so that only one entity touches the queues */
 	spin_lock_irq(&queue_lock);
 	error = crypto_enqueue_request(&sep_queue, &req->base);
+
+	if ((error != 0) && (error != -EINPROGRESS))
+		pr_debug(" sep - crypto enqueue failed: %x\n",
+			error);
+	error1 = sep_submit_work(ta_ctx->sep_used->workqueue,
+		sep_dequeuer, (void *)&sep_queue);
+	if (error1)
+		pr_debug(" sep - workqueue submit failed: %x\n",
+			error1);
 	spin_unlock_irq(&queue_lock);
+	/* We return result of crypto enqueue */
+	return error;
+}
 
-	if ((error != 0) && (error != -EINPROGRESS)) {
-		dev_warn(&sctx->sep_used->pdev->dev,
-			"sep sha256 digest cant enqueue\n");
-		sep_crypto_release(sctx, error);
-		return error;
-	}
+static int sep_sha256_finup(struct ahash_request *req)
+{
+	int error;
+	int error1;
+	struct this_task_ctx *ta_ctx = ahash_request_ctx(req);
 
-	error = sep_submit_work(sctx->sep_used->workqueue, sep_dequeuer,
-		(void *)&sep_queue);
-	if (error) {
-		dev_warn(&sctx->sep_used->pdev->dev,
-			"sha256 digest cannot submit queue\n");
-		sep_crypto_release(sctx, -EINVAL);
-		return -EINVAL;
-	}
-	return -EINPROGRESS;
+	pr_debug("sep - doing sha256 finup\n");
+
+	ta_ctx->sep_used = sep_dev;
+	ta_ctx->current_request = SHA256;
+	ta_ctx->current_hash_req = req;
+	ta_ctx->current_cypher_req = NULL;
+	ta_ctx->hash_opmode = SEP_HASH_SHA256;
+	ta_ctx->current_hash_stage = HASH_FINUP_DATA;
+
+	/* lock necessary so that only one entity touches the queues */
+	spin_lock_irq(&queue_lock);
+	error = crypto_enqueue_request(&sep_queue, &req->base);
+
+	if ((error != 0) && (error != -EINPROGRESS))
+		pr_debug(" sep - crypto enqueue failed: %x\n",
+			error);
+	error1 = sep_submit_work(ta_ctx->sep_used->workqueue,
+		sep_dequeuer, (void *)&sep_queue);
+	if (error1)
+		pr_debug(" sep - workqueue submit failed: %x\n",
+			error1);
+	spin_unlock_irq(&queue_lock);
+	/* We return result of crypto enqueue */
+	return error;
 }
 
 static int sep_crypto_init(struct crypto_tfm *tfm)
 {
-	struct sep_system_ctx *sctx = crypto_tfm_ctx(tfm);
 	const char *alg_name = crypto_tfm_alg_name(tfm);
 
-	sctx->sep_used = sep_dev;
-
 	if (alg_name == NULL)
-		dev_dbg(&sctx->sep_used->pdev->dev, "alg is NULL\n");
+		pr_debug("sep_crypto_init alg is NULL\n");
 	else
-		dev_dbg(&sctx->sep_used->pdev->dev, "alg is %s\n", alg_name);
+		pr_debug("sep_crypto_init alg is %s\n", alg_name);
 
-	tfm->crt_ablkcipher.reqsize = sizeof(struct sep_block_ctx);
-	dev_dbg(&sctx->sep_used->pdev->dev, "sep_crypto_init\n");
+	tfm->crt_ablkcipher.reqsize = sizeof(struct this_task_ctx);
 	return 0;
 }
 
 static void sep_crypto_exit(struct crypto_tfm *tfm)
 {
-	struct sep_system_ctx *sctx = crypto_tfm_ctx(tfm);
-	dev_dbg(&sctx->sep_used->pdev->dev, "sep_crypto_exit\n");
-	sctx->sep_used = NULL;
+	pr_debug("sep_crypto_exit\n");
 }
 
 static int sep_aes_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
@@ -3113,8 +3392,9 @@ static int sep_aes_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 {
 	struct sep_system_ctx *sctx = crypto_ablkcipher_ctx(tfm);
 
-	dev_dbg(&sctx->sep_used->pdev->dev, "sep aes setkey\n");
+	pr_debug("sep aes setkey\n");
 
+	pr_debug("tfm is %p sctx is %p\n", tfm, sctx);
 	switch (keylen) {
 	case SEP_AES_KEY_128_SIZE:
 		sctx->aes_key_size = AES_128;
@@ -3129,7 +3409,7 @@ static int sep_aes_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 		sctx->aes_key_size = AES_512;
 		break;
 	default:
-		dev_warn(&sctx->sep_used->pdev->dev, "sep aes key size %x\n",
+		pr_debug("invalid sep aes key size %x\n",
 			keylen);
 		return -EINVAL;
 	}
@@ -3140,7 +3420,6 @@ static int sep_aes_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 	sctx->keylen = keylen;
 	/* Indicate to encrypt/decrypt function to send key to SEP */
 	sctx->key_sent = 0;
-	sctx->last_block = 0;
 
 	return 0;
 }
@@ -3148,153 +3427,159 @@ static int sep_aes_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 static int sep_aes_ecb_encrypt(struct ablkcipher_request *req)
 {
 	int error;
-	struct sep_block_ctx *bctx = ablkcipher_request_ctx(req);
-	struct sep_system_ctx *sctx = crypto_ablkcipher_ctx(
-		crypto_ablkcipher_reqtfm(req));
+	int error1;
+	struct this_task_ctx *ta_ctx = ablkcipher_request_ctx(req);
+
+	pr_debug("sep - doing aes ecb encrypt\n");
 
-	dev_dbg(&sctx->sep_used->pdev->dev, "sep aes ecb encrypt\n");
-	sctx->current_request = AES_ECB;
-	sctx->current_hash_req = NULL;
-	sctx->current_cypher_req = req;
-	bctx->aes_encmode = SEP_AES_ENCRYPT;
-	bctx->aes_opmode = SEP_AES_ECB;
-	bctx->init_opcode = SEP_AES_INIT_OPCODE;
-	bctx->block_opcode = SEP_AES_BLOCK_OPCODE;
+	/* Clear out task context */
+	memset(ta_ctx, 0, sizeof(struct this_task_ctx));
 
+	ta_ctx->sep_used = sep_dev;
+	ta_ctx->current_request = AES_ECB;
+	ta_ctx->current_hash_req = NULL;
+	ta_ctx->current_cypher_req = req;
+	ta_ctx->aes_encmode = SEP_AES_ENCRYPT;
+	ta_ctx->aes_opmode = SEP_AES_ECB;
+	ta_ctx->init_opcode = SEP_AES_INIT_OPCODE;
+	ta_ctx->block_opcode = SEP_AES_BLOCK_OPCODE;
+
+	/* lock necessary so that only one entity touches the queues */
 	spin_lock_irq(&queue_lock);
 	error = crypto_enqueue_request(&sep_queue, &req->base);
-	spin_unlock_irq(&queue_lock);
-
-	if ((error != 0) && (error != -EINPROGRESS)) {
-		dev_warn(&sctx->sep_used->pdev->dev,
-			"sep_aes_ecb_encrypt cant enqueue\n");
-		sep_crypto_release(sctx, error);
-		return error;
-	}
 
-	error = sep_submit_work(sctx->sep_used->workqueue, sep_dequeuer,
-		(void *)&sep_queue);
-	if (error) {
-		dev_warn(&sctx->sep_used->pdev->dev,
-			"sep_aes_ecb_encrypt cannot submit queue\n");
-		sep_crypto_release(sctx, -EINVAL);
-		return -EINVAL;
-	}
-	return -EINPROGRESS;
+	if ((error != 0) && (error != -EINPROGRESS))
+		pr_debug(" sep - crypto enqueue failed: %x\n",
+			error);
+	error1 = sep_submit_work(ta_ctx->sep_used->workqueue,
+		sep_dequeuer, (void *)&sep_queue);
+	if (error1)
+		pr_debug(" sep - workqueue submit failed: %x\n",
+			error1);
+	spin_unlock_irq(&queue_lock);
+	/* We return result of crypto enqueue */
+	return error;
 }
 
 static int sep_aes_ecb_decrypt(struct ablkcipher_request *req)
 {
 	int error;
-	struct sep_block_ctx *bctx = ablkcipher_request_ctx(req);
-	struct sep_system_ctx *sctx = crypto_ablkcipher_ctx(
-		crypto_ablkcipher_reqtfm(req));
+	int error1;
+	struct this_task_ctx *ta_ctx = ablkcipher_request_ctx(req);
+
+	pr_debug("sep - doing aes ecb decrypt\n");
 
-	dev_dbg(&sctx->sep_used->pdev->dev, "sep aes ecb decrypt\n");
-	sctx->current_request = AES_ECB;
-	sctx->current_hash_req = NULL;
-	sctx->current_cypher_req = req;
-	bctx->aes_encmode = SEP_AES_DECRYPT;
-	bctx->aes_opmode = SEP_AES_ECB;
-	bctx->init_opcode = SEP_AES_INIT_OPCODE;
-	bctx->block_opcode = SEP_AES_BLOCK_OPCODE;
+	/* Clear out task context */
+	memset(ta_ctx, 0, sizeof(struct this_task_ctx));
 
+	ta_ctx->sep_used = sep_dev;
+	ta_ctx->current_request = AES_ECB;
+	ta_ctx->current_hash_req = NULL;
+	ta_ctx->current_cypher_req = req;
+	ta_ctx->aes_encmode = SEP_AES_DECRYPT;
+	ta_ctx->aes_opmode = SEP_AES_ECB;
+	ta_ctx->init_opcode = SEP_AES_INIT_OPCODE;
+	ta_ctx->block_opcode = SEP_AES_BLOCK_OPCODE;
+
+	/* lock necessary so that only one entity touches the queues */
 	spin_lock_irq(&queue_lock);
 	error = crypto_enqueue_request(&sep_queue, &req->base);
-	spin_unlock_irq(&queue_lock);
 
-	if ((error != 0) && (error != -EINPROGRESS)) {
-		dev_warn(&sctx->sep_used->pdev->dev,
-			"sep_aes_ecb_decrypt cant enqueue\n");
-		sep_crypto_release(sctx, error);
-		return error;
-	}
-
-	error = sep_submit_work(sctx->sep_used->workqueue, sep_dequeuer,
-		(void *)&sep_queue);
-	if (error) {
-		dev_warn(&sctx->sep_used->pdev->dev,
-			"sep_aes_ecb_decrypt cannot submit queue\n");
-		sep_crypto_release(sctx, -EINVAL);
-		return -EINVAL;
-	}
-	return -EINPROGRESS;
+	if ((error != 0) && (error != -EINPROGRESS))
+		pr_debug(" sep - crypto enqueue failed: %x\n",
+			error);
+	error1 = sep_submit_work(ta_ctx->sep_used->workqueue,
+		sep_dequeuer, (void *)&sep_queue);
+	if (error1)
+		pr_debug(" sep - workqueue submit failed: %x\n",
+			error1);
+	spin_unlock_irq(&queue_lock);
+	/* We return result of crypto enqueue */
+	return error;
 }
 
 static int sep_aes_cbc_encrypt(struct ablkcipher_request *req)
 {
 	int error;
-	struct sep_block_ctx *bctx = ablkcipher_request_ctx(req);
+	int error1;
+	struct this_task_ctx *ta_ctx = ablkcipher_request_ctx(req);
 	struct sep_system_ctx *sctx = crypto_ablkcipher_ctx(
 		crypto_ablkcipher_reqtfm(req));
 
-	dev_dbg(&sctx->sep_used->pdev->dev, "sep aes cbc encrypt\n");
-	sctx->current_request = AES_CBC;
-	sctx->current_hash_req = NULL;
-	sctx->current_cypher_req = req;
-	bctx->aes_encmode = SEP_AES_ENCRYPT;
-	bctx->aes_opmode = SEP_AES_CBC;
-	bctx->init_opcode = SEP_AES_INIT_OPCODE;
-	bctx->block_opcode = SEP_AES_BLOCK_OPCODE;
+	pr_debug("sep - doing aes cbc encrypt\n");
+
+	/* Clear out task context */
+	memset(ta_ctx, 0, sizeof(struct this_task_ctx));
+
+	pr_debug("tfm is %p sctx is %p and ta_ctx is %p\n",
+		crypto_ablkcipher_reqtfm(req), sctx, ta_ctx);
+
+	ta_ctx->sep_used = sep_dev;
+	ta_ctx->current_request = AES_CBC;
+	ta_ctx->current_hash_req = NULL;
+	ta_ctx->current_cypher_req = req;
+	ta_ctx->aes_encmode = SEP_AES_ENCRYPT;
+	ta_ctx->aes_opmode = SEP_AES_CBC;
+	ta_ctx->init_opcode = SEP_AES_INIT_OPCODE;
+	ta_ctx->block_opcode = SEP_AES_BLOCK_OPCODE;
 
+	/* lock necessary so that only one entity touches the queues */
 	spin_lock_irq(&queue_lock);
 	error = crypto_enqueue_request(&sep_queue, &req->base);
-	spin_unlock_irq(&queue_lock);
 
-	if ((error != 0) && (error != -EINPROGRESS)) {
-		dev_warn(&sctx->sep_used->pdev->dev,
-			"sep_aes_cbc_encrypt cant enqueue\n");
-		sep_crypto_release(sctx, error);
-		return error;
-	}
-
-	error = sep_submit_work(sctx->sep_used->workqueue, sep_dequeuer,
-		(void *)&sep_queue);
-	if (error) {
-		dev_warn(&sctx->sep_used->pdev->dev,
-			"sep_aes_cbc_encrypt cannot submit queue\n");
-		sep_crypto_release(sctx, -EINVAL);
-		return -EINVAL;
-	}
-	return -EINPROGRESS;
+	if ((error != 0) && (error != -EINPROGRESS))
+		pr_debug(" sep - crypto enqueue failed: %x\n",
+			error);
+	error1 = sep_submit_work(ta_ctx->sep_used->workqueue,
+		sep_dequeuer, (void *)&sep_queue);
+	if (error1)
+		pr_debug(" sep - workqueue submit failed: %x\n",
+			error1);
+	spin_unlock_irq(&queue_lock);
+	/* We return result of crypto enqueue */
+	return error;
 }
 
 static int sep_aes_cbc_decrypt(struct ablkcipher_request *req)
 {
 	int error;
-	struct sep_block_ctx *bctx = ablkcipher_request_ctx(req);
+	int error1;
+	struct this_task_ctx *ta_ctx = ablkcipher_request_ctx(req);
 	struct sep_system_ctx *sctx = crypto_ablkcipher_ctx(
 		crypto_ablkcipher_reqtfm(req));
 
-	dev_dbg(&sctx->sep_used->pdev->dev, "sep aes cbc decrypt\n");
-	sctx->current_request = AES_CBC;
-	sctx->current_hash_req = NULL;
-	sctx->current_cypher_req = req;
-	bctx->aes_encmode = SEP_AES_DECRYPT;
-	bctx->aes_opmode = SEP_AES_CBC;
-	bctx->init_opcode = SEP_AES_INIT_OPCODE;
-	bctx->block_opcode = SEP_AES_BLOCK_OPCODE;
+	pr_debug("sep - doing aes cbc decrypt\n");
+
+	pr_debug("tfm is %p sctx is %p and ta_ctx is %p\n",
+		crypto_ablkcipher_reqtfm(req), sctx, ta_ctx);
 
+	/* Clear out task context */
+	memset(ta_ctx, 0, sizeof(struct this_task_ctx));
+
+	ta_ctx->sep_used = sep_dev;
+	ta_ctx->current_request = AES_CBC;
+	ta_ctx->current_hash_req = NULL;
+	ta_ctx->current_cypher_req = req;
+	ta_ctx->aes_encmode = SEP_AES_DECRYPT;
+	ta_ctx->aes_opmode = SEP_AES_CBC;
+	ta_ctx->init_opcode = SEP_AES_INIT_OPCODE;
+	ta_ctx->block_opcode = SEP_AES_BLOCK_OPCODE;
+
+	/* lock necessary so that only one entity touches the queues */
 	spin_lock_irq(&queue_lock);
 	error = crypto_enqueue_request(&sep_queue, &req->base);
-	spin_unlock_irq(&queue_lock);
-
-	if ((error != 0) && (error != -EINPROGRESS)) {
-		dev_warn(&sctx->sep_used->pdev->dev,
-			"sep_aes_cbc_decrypt cant enqueue\n");
-		sep_crypto_release(sctx, error);
-		return error;
-	}
 
-	error = sep_submit_work(sctx->sep_used->workqueue, sep_dequeuer,
-		(void *)&sep_queue);
-	if (error) {
-		dev_warn(&sctx->sep_used->pdev->dev,
-			"sep_aes_cbc_decrypt cannot submit queue\n");
-		sep_crypto_release(sctx, -EINVAL);
-		return -EINVAL;
-	}
-	return -EINPROGRESS;
+	if ((error != 0) && (error != -EINPROGRESS))
+		pr_debug(" sep - crypto enqueue failed: %x\n",
+			error);
+	error1 = sep_submit_work(ta_ctx->sep_used->workqueue,
+		sep_dequeuer, (void *)&sep_queue);
+	if (error1)
+		pr_debug(" sep - workqueue submit failed: %x\n",
+			error1);
+	spin_unlock_irq(&queue_lock);
+	/* We return result of crypto enqueue */
+	return error;
 }
 
 static int sep_des_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
@@ -3304,7 +3589,7 @@ static int sep_des_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 	struct crypto_tfm *ctfm = crypto_ablkcipher_tfm(tfm);
 	u32 *flags  = &ctfm->crt_flags;
 
-	dev_dbg(&sctx->sep_used->pdev->dev, "sep des setkey\n");
+	pr_debug("sep des setkey\n");
 
 	switch (keylen) {
 	case DES_KEY_SIZE:
@@ -3317,7 +3602,7 @@ static int sep_des_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 		sctx->des_nbr_keys = DES_KEY_3;
 		break;
 	default:
-		dev_dbg(&sctx->sep_used->pdev->dev, "invalid key size %x\n",
+		pr_debug("invalid key size %x\n",
 			keylen);
 		return -EINVAL;
 	}
@@ -3326,7 +3611,7 @@ static int sep_des_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 		(sep_weak_key(key, keylen))) {
 
 		*flags |= CRYPTO_TFM_RES_WEAK_KEY;
-		dev_warn(&sctx->sep_used->pdev->dev, "weak key\n");
+		pr_debug("weak key\n");
 		return -EINVAL;
 	}
 
@@ -3335,7 +3620,6 @@ static int sep_des_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 	sctx->keylen = keylen;
 	/* Indicate to encrypt/decrypt function to send key to SEP */
 	sctx->key_sent = 0;
-	sctx->last_block = 0;
 
 	return 0;
 }
@@ -3343,153 +3627,149 @@ static int sep_des_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 static int sep_des_ebc_encrypt(struct ablkcipher_request *req)
 {
 	int error;
-	struct sep_block_ctx *bctx = ablkcipher_request_ctx(req);
-	struct sep_system_ctx *sctx = crypto_ablkcipher_ctx(
-		crypto_ablkcipher_reqtfm(req));
+	int error1;
+	struct this_task_ctx *ta_ctx = ablkcipher_request_ctx(req);
+
+	pr_debug("sep - doing des ecb encrypt\n");
 
-	dev_dbg(&sctx->sep_used->pdev->dev, "sep des ecb encrypt\n");
-	sctx->current_request = DES_ECB;
-	sctx->current_hash_req = NULL;
-	sctx->current_cypher_req = req;
-	bctx->des_encmode = SEP_DES_ENCRYPT;
-	bctx->des_opmode = SEP_DES_ECB;
-	bctx->init_opcode = SEP_DES_INIT_OPCODE;
-	bctx->block_opcode = SEP_DES_BLOCK_OPCODE;
+	/* Clear out task context */
+	memset(ta_ctx, 0, sizeof(struct this_task_ctx));
 
+	ta_ctx->sep_used = sep_dev;
+	ta_ctx->current_request = DES_ECB;
+	ta_ctx->current_hash_req = NULL;
+	ta_ctx->current_cypher_req = req;
+	ta_ctx->des_encmode = SEP_DES_ENCRYPT;
+	ta_ctx->des_opmode = SEP_DES_ECB;
+	ta_ctx->init_opcode = SEP_DES_INIT_OPCODE;
+	ta_ctx->block_opcode = SEP_DES_BLOCK_OPCODE;
+
+	/* lock necessary so that only one entity touches the queues */
 	spin_lock_irq(&queue_lock);
 	error = crypto_enqueue_request(&sep_queue, &req->base);
-	spin_unlock_irq(&queue_lock);
 
-	if ((error != 0) && (error != -EINPROGRESS)) {
-		dev_warn(&sctx->sep_used->pdev->dev,
-			"sep_des_ecb_encrypt cant enqueue\n");
-		sep_crypto_release(sctx, error);
-		return error;
-	}
-
-	error = sep_submit_work(sctx->sep_used->workqueue, sep_dequeuer,
-		(void *)&sep_queue);
-	if (error) {
-		dev_warn(&sctx->sep_used->pdev->dev,
-			"sep_des_ecb_encrypt cannot submit queue\n");
-		sep_crypto_release(sctx, -EINVAL);
-		return -EINVAL;
-	}
-	return -EINPROGRESS;
+	if ((error != 0) && (error != -EINPROGRESS))
+		pr_debug(" sep - crypto enqueue failed: %x\n",
+			error);
+	error1 = sep_submit_work(ta_ctx->sep_used->workqueue,
+		sep_dequeuer, (void *)&sep_queue);
+	if (error1)
+		pr_debug(" sep - workqueue submit failed: %x\n",
+			error1);
+	spin_unlock_irq(&queue_lock);
+	/* We return result of crypto enqueue */
+	return error;
 }
 
 static int sep_des_ebc_decrypt(struct ablkcipher_request *req)
 {
 	int error;
-	struct sep_block_ctx *bctx = ablkcipher_request_ctx(req);
-	struct sep_system_ctx *sctx = crypto_ablkcipher_ctx(
-		crypto_ablkcipher_reqtfm(req));
+	int error1;
+	struct this_task_ctx *ta_ctx = ablkcipher_request_ctx(req);
+
+	pr_debug("sep - doing des ecb decrypt\n");
 
-	dev_dbg(&sctx->sep_used->pdev->dev, "sep des ecb decrypt\n");
-	sctx->current_request = DES_ECB;
-	sctx->current_hash_req = NULL;
-	sctx->current_cypher_req = req;
-	bctx->des_encmode = SEP_DES_DECRYPT;
-	bctx->des_opmode = SEP_DES_ECB;
-	bctx->init_opcode = SEP_DES_INIT_OPCODE;
-	bctx->block_opcode = SEP_DES_BLOCK_OPCODE;
+	/* Clear out task context */
+	memset(ta_ctx, 0, sizeof(struct this_task_ctx));
 
+	ta_ctx->sep_used = sep_dev;
+	ta_ctx->current_request = DES_ECB;
+	ta_ctx->current_hash_req = NULL;
+	ta_ctx->current_cypher_req = req;
+	ta_ctx->des_encmode = SEP_DES_DECRYPT;
+	ta_ctx->des_opmode = SEP_DES_ECB;
+	ta_ctx->init_opcode = SEP_DES_INIT_OPCODE;
+	ta_ctx->block_opcode = SEP_DES_BLOCK_OPCODE;
+
+	/* lock necessary so that only one entity touches the queues */
 	spin_lock_irq(&queue_lock);
 	error = crypto_enqueue_request(&sep_queue, &req->base);
-	spin_unlock_irq(&queue_lock);
-
-	if ((error != 0) && (error != -EINPROGRESS)) {
-		dev_warn(&sctx->sep_used->pdev->dev,
-			"sep_des_ecb_decrypt cant enqueue\n");
-		sep_crypto_release(sctx, error);
-		return error;
-	}
 
-	error = sep_submit_work(sctx->sep_used->workqueue, sep_dequeuer,
-		(void *)&sep_queue);
-	if (error) {
-		dev_warn(&sctx->sep_used->pdev->dev,
-			"sep_des_ecb_decrypt cannot submit queue\n");
-		sep_crypto_release(sctx, -EINVAL);
-		return -EINVAL;
-	}
-	return -EINPROGRESS;
+	if ((error != 0) && (error != -EINPROGRESS))
+		pr_debug(" sep - crypto enqueue failed: %x\n",
+			error);
+	error1 = sep_submit_work(ta_ctx->sep_used->workqueue,
+		sep_dequeuer, (void *)&sep_queue);
+	if (error1)
+		pr_debug(" sep - workqueue submit failed: %x\n",
+			error1);
+	spin_unlock_irq(&queue_lock);
+	/* We return result of crypto enqueue */
+	return error;
 }
 
 static int sep_des_cbc_encrypt(struct ablkcipher_request *req)
 {
 	int error;
-	struct sep_block_ctx *bctx = ablkcipher_request_ctx(req);
-	struct sep_system_ctx *sctx = crypto_ablkcipher_ctx(
-		crypto_ablkcipher_reqtfm(req));
+	int error1;
+	struct this_task_ctx *ta_ctx = ablkcipher_request_ctx(req);
+
+	pr_debug("sep - doing des cbc encrypt\n");
 
-	dev_dbg(&sctx->sep_used->pdev->dev, "sep des cbc encrypt\n");
-	sctx->current_request = DES_CBC;
-	sctx->current_hash_req = NULL;
-	sctx->current_cypher_req = req;
-	bctx->des_encmode = SEP_DES_ENCRYPT;
-	bctx->des_opmode = SEP_DES_CBC;
-	bctx->init_opcode = SEP_DES_INIT_OPCODE;
-	bctx->block_opcode = SEP_DES_BLOCK_OPCODE;
+	/* Clear out task context */
+	memset(ta_ctx, 0, sizeof(struct this_task_ctx));
 
+	ta_ctx->sep_used = sep_dev;
+	ta_ctx->current_request = DES_CBC;
+	ta_ctx->current_hash_req = NULL;
+	ta_ctx->current_cypher_req = req;
+	ta_ctx->des_encmode = SEP_DES_ENCRYPT;
+	ta_ctx->des_opmode = SEP_DES_CBC;
+	ta_ctx->init_opcode = SEP_DES_INIT_OPCODE;
+	ta_ctx->block_opcode = SEP_DES_BLOCK_OPCODE;
+
+	/* lock necessary so that only one entity touches the queues */
 	spin_lock_irq(&queue_lock);
 	error = crypto_enqueue_request(&sep_queue, &req->base);
-	spin_unlock_irq(&queue_lock);
 
-	if ((error != 0) && (error != -EINPROGRESS)) {
-		dev_warn(&sctx->sep_used->pdev->dev,
-			"sep_des_cbc_encrypt cant enqueue\n");
-		sep_crypto_release(sctx, error);
-		return error;
-	}
-
-	error = sep_submit_work(sctx->sep_used->workqueue, sep_dequeuer,
-		(void *)&sep_queue);
-	if (error) {
-		dev_warn(&sctx->sep_used->pdev->dev,
-			"sep_des_cbc_encrypt cannot submit queue\n");
-		sep_crypto_release(sctx, -EINVAL);
-		return -EINVAL;
-	}
-	return -EINPROGRESS;
+	if ((error != 0) && (error != -EINPROGRESS))
+		pr_debug(" sep - crypto enqueue failed: %x\n",
+			error);
+	error1 = sep_submit_work(ta_ctx->sep_used->workqueue,
+		sep_dequeuer, (void *)&sep_queue);
+	if (error1)
+		pr_debug(" sep - workqueue submit failed: %x\n",
+			error1);
+	spin_unlock_irq(&queue_lock);
+	/* We return result of crypto enqueue */
+	return error;
 }
 
 static int sep_des_cbc_decrypt(struct ablkcipher_request *req)
 {
 	int error;
-	struct sep_block_ctx *bctx = ablkcipher_request_ctx(req);
-	struct sep_system_ctx *sctx = crypto_ablkcipher_ctx(
-		crypto_ablkcipher_reqtfm(req));
+	int error1;
+	struct this_task_ctx *ta_ctx = ablkcipher_request_ctx(req);
+
+	pr_debug("sep - doing des ecb decrypt\n");
 
-	dev_dbg(&sctx->sep_used->pdev->dev, "sep des cbc decrypt\n");
-	sctx->current_request = DES_CBC;
-	sctx->current_hash_req = NULL;
-	sctx->current_cypher_req = req;
-	bctx->des_encmode = SEP_DES_DECRYPT;
-	bctx->des_opmode = SEP_DES_CBC;
-	bctx->init_opcode = SEP_DES_INIT_OPCODE;
-	bctx->block_opcode = SEP_DES_BLOCK_OPCODE;
+	/* Clear out task context */
+	memset(ta_ctx, 0, sizeof(struct this_task_ctx));
 
+	ta_ctx->sep_used = sep_dev;
+	ta_ctx->current_request = DES_CBC;
+	ta_ctx->current_hash_req = NULL;
+	ta_ctx->current_cypher_req = req;
+	ta_ctx->des_encmode = SEP_DES_DECRYPT;
+	ta_ctx->des_opmode = SEP_DES_CBC;
+	ta_ctx->init_opcode = SEP_DES_INIT_OPCODE;
+	ta_ctx->block_opcode = SEP_DES_BLOCK_OPCODE;
+
+	/* lock necessary so that only one entity touches the queues */
 	spin_lock_irq(&queue_lock);
 	error = crypto_enqueue_request(&sep_queue, &req->base);
-	spin_unlock_irq(&queue_lock);
-
-	if ((error != 0) && (error != -EINPROGRESS)) {
-		dev_warn(&sctx->sep_used->pdev->dev,
-			"sep_des_cbc_decrypt cant enqueue\n");
-		sep_crypto_release(sctx, error);
-		return error;
-	}
 
-	error = sep_submit_work(sctx->sep_used->workqueue, sep_dequeuer,
-		(void *)&sep_queue);
-	if (error) {
-		dev_warn(&sctx->sep_used->pdev->dev,
-			"sep_des_cbc_decrypt cannot submit queue\n");
-		sep_crypto_release(sctx, -EINVAL);
-		return -EINVAL;
-	}
-	return -EINPROGRESS;
+	if ((error != 0) && (error != -EINPROGRESS))
+		pr_debug(" sep - crypto enqueue failed: %x\n",
+			error);
+	error1 = sep_submit_work(ta_ctx->sep_used->workqueue,
+		sep_dequeuer, (void *)&sep_queue);
+	if (error1)
+		pr_debug(" sep - workqueue submit failed: %x\n",
+			error1);
+	spin_unlock_irq(&queue_lock);
+	/* We return result of crypto enqueue */
+	return error;
 }
 
 static struct ahash_alg hash_algs[] = {
@@ -3498,6 +3778,7 @@ static struct ahash_alg hash_algs[] = {
 	.update		= sep_sha1_update,
 	.final		= sep_sha1_final,
 	.digest		= sep_sha1_digest,
+	.finup		= sep_sha1_finup,
 	.halg		= {
 		.digestsize	= SHA1_DIGEST_SIZE,
 		.base	= {
@@ -3520,6 +3801,7 @@ static struct ahash_alg hash_algs[] = {
 	.update		= sep_md5_update,
 	.final		= sep_md5_final,
 	.digest		= sep_md5_digest,
+	.finup		= sep_md5_finup,
 	.halg		= {
 		.digestsize	= MD5_DIGEST_SIZE,
 		.base	= {
@@ -3542,6 +3824,7 @@ static struct ahash_alg hash_algs[] = {
 	.update		= sep_sha224_update,
 	.final		= sep_sha224_final,
 	.digest		= sep_sha224_digest,
+	.finup		= sep_sha224_finup,
 	.halg		= {
 		.digestsize	= SHA224_DIGEST_SIZE,
 		.base	= {
@@ -3564,6 +3847,7 @@ static struct ahash_alg hash_algs[] = {
 	.update		= sep_sha256_update,
 	.final		= sep_sha256_final,
 	.digest		= sep_sha256_digest,
+	.finup		= sep_sha256_finup,
 	.halg		= {
 		.digestsize	= SHA256_DIGEST_SIZE,
 		.base	= {
@@ -3621,6 +3905,7 @@ static struct crypto_alg crypto_algs[] = {
 		.max_keysize	= AES_MAX_KEY_SIZE,
 		.setkey		= sep_aes_setkey,
 		.encrypt	= sep_aes_cbc_encrypt,
+		.ivsize		= AES_BLOCK_SIZE,
 		.decrypt	= sep_aes_cbc_decrypt,
 	}
 },
@@ -3661,6 +3946,7 @@ static struct crypto_alg crypto_algs[] = {
 		.max_keysize	= DES_KEY_SIZE,
 		.setkey		= sep_des_setkey,
 		.encrypt	= sep_des_cbc_encrypt,
+		.ivsize		= DES_BLOCK_SIZE,
 		.decrypt	= sep_des_cbc_decrypt,
 	}
 },
@@ -3714,7 +4000,8 @@ int sep_crypto_setup(void)
 
 	crypto_init_queue(&sep_queue, SEP_QUEUE_LENGTH);
 
-	sep_dev->workqueue = create_workqueue("sep_crypto_workqueue");
+	sep_dev->workqueue = create_singlethread_workqueue(
+		"sep_crypto_workqueue");
 	if (!sep_dev->workqueue) {
 		dev_warn(&sep_dev->pdev->dev, "cant create workqueue\n");
 		return -ENOMEM;
@@ -3723,7 +4010,6 @@ int sep_crypto_setup(void)
 	i = 0;
 	j = 0;
 
-	spin_lock_init(&sep_dev->busy_lock);
 	spin_lock_init(&queue_lock);
 
 	err = 0;
diff --git a/drivers/staging/sep/sep_crypto.h b/drivers/staging/sep/sep_crypto.h
index 52c58c4..155c3c9 100644
--- a/drivers/staging/sep/sep_crypto.h
+++ b/drivers/staging/sep/sep_crypto.h
@@ -117,7 +117,7 @@
 
 #define SEP_TRANSACTION_WAIT_TIME 5
 
-#define SEP_QUEUE_LENGTH	10
+#define SEP_QUEUE_LENGTH	2
 /* Macros */
 #ifndef __LITTLE_ENDIAN
 #define CHG_ENDIAN(val) \
@@ -270,9 +270,26 @@ struct sep_hash_private_context {
 	u8 internal_context[sizeof(struct sep_hash_internal_context)];
 };
 
+union key_t {
+	struct sep_des_key des;
+	u32 aes[SEP_AES_MAX_KEY_SIZE_WORDS];
+};
+
 /* Context structures for crypto API */
-struct sep_block_ctx {
-	struct sep_device *sep;
+/**
+ * Structure for this current task context
+ * This same structure is used for both hash
+ * and crypt in order to reduce duplicate code
+ * for stuff that is done for both hash operations
+ * and crypto operations. We cannot trust that the
+ * system context is not pulled out from under
+ * us during operation to operation, so all
+ * critical stuff such as data pointers must
+ * be in in a context that is exclusive for this
+ * particular task at hand.
+ */
+struct this_task_ctx {
+	struct sep_device *sep_used;
 	u32 done;
 	unsigned char iv[100];
 	enum des_enc_mode des_encmode;
@@ -284,36 +301,7 @@ struct sep_block_ctx {
 	size_t data_length;
 	size_t ivlen;
 	struct ablkcipher_walk walk;
-	struct sep_des_private_context des_private_ctx;
-	struct sep_aes_private_context aes_private_ctx;
-	};
-
-struct sep_hash_ctx {
-	u32 done;
-	unsigned char *buf;
-	size_t buflen;
-	unsigned char *dgst;
-	int digest_size_words;
-	int digest_size_bytes;
-	int block_size_words;
-	int block_size_bytes;
-	struct scatterlist *sg;
-	enum hash_op_mode hash_opmode;
-	struct sep_hash_private_context hash_private_ctx;
-	};
-
-struct sep_system_ctx {
-	struct sep_device *sep_used;
-	union key_t {
-		struct sep_des_key des;
-		u32 aes[SEP_AES_MAX_KEY_SIZE_WORDS];
-	} key;
 	int i_own_sep; /* Do I have custody of the sep? */
-	size_t keylen;
-	enum des_numkey des_nbr_keys;
-	enum aes_keysize aes_key_size;
-	u32 key_sent; /* Indicate if key is sent to sep */
-	u32 last_block; /* Indicate that this is the final block */
 	struct sep_call_status call_status;
 	struct build_dcb_struct_kernel dcb_input_data;
 	struct sep_dma_context *dma_ctx;
@@ -331,9 +319,32 @@ struct sep_system_ctx {
 	struct ahash_request *current_hash_req;
 	struct ablkcipher_request *current_cypher_req;
 	enum type_of_request current_request;
+	int digest_size_words;
+	int digest_size_bytes;
+	int block_size_words;
+	int block_size_bytes;
+	enum hash_op_mode hash_opmode;
 	enum hash_stage current_hash_stage;
-	int done_with_transaction;
+	/**
+	 * Not that this is a pointer. The are_we_done_yet variable is
+	 * allocated by the task function. This way, even if the kernel
+	 * crypto infrastructure has grabbed the task structure out from
+	 * under us, the task function can still see this variable.
+	 */
+	int *are_we_done_yet;
+	unsigned long end_time;
+	};
+
+struct sep_system_ctx {
+	union key_t key;
+	size_t keylen;
+	int key_sent;
+	enum des_numkey des_nbr_keys;
+	enum aes_keysize aes_key_size;
 	unsigned long end_time;
+	struct sep_des_private_context des_private_ctx;
+	struct sep_aes_private_context aes_private_ctx;
+	struct sep_hash_private_context hash_private_ctx;
 	};
 
 /* work queue structures */
diff --git a/drivers/staging/sep/sep_dev.h b/drivers/staging/sep/sep_dev.h
index 66d8e95..5f6a07f 100644
--- a/drivers/staging/sep/sep_dev.h
+++ b/drivers/staging/sep/sep_dev.h
@@ -93,8 +93,7 @@ struct sep_device {
 	enum hash_stage	current_hash_stage;
 	struct ahash_request	*current_hash_req;
 	struct ablkcipher_request *current_cypher_req;
-	struct sep_system_ctx *sctx;
-	spinlock_t		busy_lock;
+	struct this_task_ctx *ta_ctx;
 	struct workqueue_struct	*workqueue;
 };
 

