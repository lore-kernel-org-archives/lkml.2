Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab0JNAqV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 20:46:21 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53303 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074Ab0JNAqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 20:46:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=nLgldNBr8zjIQMSxRWgp0MMHqy/RHfaG4BvMAEGp4oo9KSGweXU7+4nEScF29IQYDM
         yO7WlXd4158rCsnIcwGfTRCZJ7wlSrxbNr5efVvTg5aBoqJMrlTpv3btMeF98lxkWrot
         GcYf+0KieJtgcAT/ogsuZK9EGrsyeZo+rSXao=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 6/6] memstick: stop passing useless pointer to card->current_mrq + refactoring
Date: Thu, 14 Oct 2010 02:40:05 +0200
Message-Id: <1287016805-5175-7-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287016805-5175-1-git-send-email-maximlevitsky@gmail.com>
References: <1287016805-5175-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that both card drivers use new support code that can be safely done.
In addition to that few handlers in memstick.c are converted to new style.
register window is now completely dynamic, and nobody but register read/write
functions send the MS_TPC_SET_RW_REG_ADRS.

In addition to that, I did more cosmetic refactoring, and few fixes
there and there.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/memstick/core/memstick.c    |  609 +++++++++++++++++------------------
 drivers/memstick/core/ms_block.c    |  166 +++++-----
 drivers/memstick/core/mspro_block.c |  188 +++++------
 drivers/memstick/core/mspro_block.h |    2 +-
 include/linux/memstick.h            |   53 ++--
 5 files changed, 480 insertions(+), 538 deletions(-)

diff --git a/drivers/memstick/core/memstick.c b/drivers/memstick/core/memstick.c
index 4c457ae..2c7b9f5 100644
--- a/drivers/memstick/core/memstick.c
+++ b/drivers/memstick/core/memstick.c
@@ -202,61 +202,207 @@ static int memstick_dummy_check(struct memstick_dev *card)
 	return 0;
 }
 
-/**
- * memstick_detect_change - schedule media detection on memstick host
- * @host - host to use
+/*
+ * Functions prefixed with "h_" are protocol callbacks. They can be called from
+ * interrupt context. Return value of 0 means that request processing is still
+ * ongoing, while special error value of -EAGAIN means that current request is
+ * finished (and request processor should come back some time later).
  */
-void memstick_detect_change(struct memstick_host *host)
+
+static int h_memstick_read_dev_id(struct memstick_dev *card)
 {
-	queue_work(workqueue, &host->media_checker);
+	struct ms_id_register id_reg;
+	struct memstick_request *mrq = &card->current_mrq;
+
+	if (mrq->error)
+		return memstick_state_machine_exit(card, -EIO);
+
+	switch (card->state) {
+	case 0:
+		if (!memstick_read_regs(card,
+			offsetof(struct ms_register, id),
+			sizeof(struct ms_id_register)))
+			return 0;
+		break;
+	case 1:
+		memcpy(&id_reg, mrq->data, sizeof(id_reg));
+		card->id.match_flags = MEMSTICK_MATCH_ALL;
+		card->id.type = id_reg.type;
+		card->id.category = id_reg.category;
+		card->id.class = id_reg.class;
+		dev_dbg(&card->dev, "if_mode = %02x\n", id_reg.if_mode);
+		return memstick_state_machine_exit(card, 0);
+	}
+
+	card->state++;
+	return 0;
 }
-EXPORT_SYMBOL(memstick_detect_change);
 
-/**
- * memstick_next_req - called by host driver to obtain next request to process
- * @host - host to use
- * @mrq - pointer to stick the request to
- *
- * Host calls this function from idle state (*mrq == NULL) or after finishing
- * previous request (*mrq should point to it). If previous request was
- * unsuccessful, it is retried for predetermined number of times. Return value
- * of 0 means that new request was assigned to the host.
- */
-int memstick_next_req(struct memstick_host *host, struct memstick_request **mrq)
+static int h_memstick_default_bad(struct memstick_dev *card)
 {
-	int rc = -ENXIO;
+	return -ENXIO;
+}
 
-	if ((*mrq) && (*mrq)->error && host->retries) {
-		(*mrq)->error = rc;
-		host->retries--;
-		return 0;
+static void memstick_invalidate_reg_window(struct memstick_dev *card)
+{
+	memset(&card->reg_addr, 0, sizeof(card->reg_addr));
+}
+
+static struct memstick_dev *memstick_alloc_card(struct memstick_host *host)
+{
+	struct memstick_dev *card = kzalloc(sizeof(struct memstick_dev),
+					    GFP_KERNEL);
+	struct memstick_dev *old_card = host->card;
+
+	if (card) {
+		card->host = host;
+		dev_set_name(&card->dev, "%s", dev_name(&host->dev));
+		card->dev.parent = &host->dev;
+		card->dev.bus = &memstick_bus_type;
+		card->dev.release = memstick_free_card;
+		card->check = memstick_dummy_check;
+		card->next_request = h_memstick_default_bad;
+		init_completion(&card->mrq_complete);
+		host->card = card;
+
+		if (memstick_run_state_machine(card,
+						h_memstick_read_dev_id, true))
+			goto err_out;
 	}
+	host->card = old_card;
+	return card;
+err_out:
+	host->card = old_card;
+	kfree(card);
+	return NULL;
+}
 
-	if (host->card && host->card->next_request)
-		rc = host->card->next_request(host->card, mrq);
+static int memstick_power_on(struct memstick_host *host)
+{
+	int rc = host->set_param(host, MEMSTICK_POWER, MEMSTICK_POWER_ON);
 
 	if (!rc)
-		host->retries = cmd_retries > 1 ? cmd_retries - 1 : 1;
-	else
-		*mrq = NULL;
+		rc = host->set_param(host, MEMSTICK_INTERFACE, MEMSTICK_SERIAL);
 
 	return rc;
 }
-EXPORT_SYMBOL(memstick_next_req);
+
+static void memstick_check(struct work_struct *work)
+{
+	struct memstick_host *host = container_of(work, struct memstick_host,
+						  media_checker);
+	struct memstick_dev *card;
+
+	dev_dbg(&host->dev, "memstick_check started\n");
+	mutex_lock(&host->lock);
+	if (!host->card) {
+		if (memstick_power_on(host))
+			goto out_power_off;
+	} else if (host->card->stop) {
+		host->card->stop(host->card);
+		memstick_invalidate_reg_window(host->card);
+	}
+
+	card = memstick_alloc_card(host);
+
+	if (!card) {
+		if (host->card) {
+			device_unregister(&host->card->dev);
+			host->card = NULL;
+		}
+	} else {
+		dev_dbg(&host->dev, "new card %02x, %02x, %02x\n",
+			card->id.type, card->id.category, card->id.class);
+		if (host->card) {
+			if (!memstick_dev_match(host->card, &card->id)
+			    || !(host->card->check(host->card))) {
+				device_unregister(&host->card->dev);
+				host->card = NULL;
+			} else if (host->card->start)
+				host->card->start(host->card);
+		}
+
+		if (!host->card) {
+			host->card = card;
+			if (device_register(&card->dev)) {
+				kfree(host->card);
+				host->card = NULL;
+			}
+		} else
+			kfree(card);
+	}
+
+out_power_off:
+	if (!host->card)
+		host->set_param(host, MEMSTICK_POWER, MEMSTICK_POWER_OFF);
+
+	mutex_unlock(&host->lock);
+	dev_dbg(&host->dev, "memstick_check finished\n");
+}
+
+
+/*** card driver interface ***/
 
 /**
- * memstick_new_req - notify the host that some requests are pending
- * @host - host to use
+ * memstick_register_driver - register new card driver
+ * @drv - the driver info structure
  */
-void memstick_new_req(struct memstick_host *host)
+int memstick_register_driver(struct memstick_driver *drv)
 {
-	if (host->card) {
-		host->retries = cmd_retries;
-		INIT_COMPLETION(host->card->mrq_complete);
-		host->request(host);
-	}
+	drv->driver.bus = &memstick_bus_type;
+
+	return driver_register(&drv->driver);
+}
+EXPORT_SYMBOL(memstick_register_driver);
+
+/**
+ * memstick_unregister_driver - unregister a card driver
+ * usually called on card driver unload
+ * @drv - the driver info structure
+ */
+void memstick_unregister_driver(struct memstick_driver *drv)
+{
+	driver_unregister(&drv->driver);
+}
+EXPORT_SYMBOL(memstick_unregister_driver);
+
+/**
+ * memstick_run_state_machine - runs IO state machine
+ * DON'T call from state machine code!
+ * Usefull for blocking IO in the card drivers.
+ * @card - card to use
+ * @state_func - the state machine
+ * @sync - if true, will wait till state machine exits using
+ * memstick_state_machine_exit
+ */
+int memstick_run_state_machine(struct memstick_dev *card,
+	int   (*state_func)(struct memstick_dev *card), bool sync)
+{
+
+	memset(&card->current_mrq, sizeof(card->current_mrq), 0);
+	card->int_polling = false;
+	card->state = 0;
+
+	WARN_ON(card->state_machine_running);
+	WARN_ON(card->next_request != h_memstick_default_bad);
+
+	card->next_request = state_func;
+	card->state_machine_running = true;
+
+	card->host->retries = cmd_retries;
+	INIT_COMPLETION(card->mrq_complete);
+	card->host->request(card->host);
+
+	if (!sync)
+		return 0;
+
+	wait_for_completion(&card->mrq_complete);
+	return card->current_mrq.error;
 }
-EXPORT_SYMBOL(memstick_new_req);
+EXPORT_SYMBOL(memstick_run_state_machine);
+
+
+/*** functions to be called by state machines ***/
 
 /**
  * memstick_init_req_sg - set request fields needed for bulk data transfer
@@ -264,9 +410,12 @@ EXPORT_SYMBOL(memstick_new_req);
  * @tpc - memstick Transport Protocol Command
  * @sg - TPC argument
  */
-void memstick_init_req_sg(struct memstick_request *mrq, unsigned char tpc,
+void memstick_init_req_sg(struct memstick_dev *card, unsigned char tpc,
 			  const struct scatterlist *sg)
 {
+	struct memstick_request *mrq = &card->current_mrq;
+	WARN_ON(!card->state_machine_running);
+
 	mrq->tpc = tpc;
 	if (tpc & 8)
 		mrq->data_dir = WRITE;
@@ -280,6 +429,9 @@ void memstick_init_req_sg(struct memstick_request *mrq, unsigned char tpc,
 		mrq->need_card_int = 1;
 	else
 		mrq->need_card_int = 0;
+
+	if (tpc != MS_TPC_GET_INT)
+		card->int_polling = false;
 }
 EXPORT_SYMBOL(memstick_init_req_sg);
 
@@ -294,9 +446,12 @@ EXPORT_SYMBOL(memstick_init_req_sg);
  * in size) allows us to just copy the value between request structure and
  * user supplied buffer.
  */
-void memstick_init_req(struct memstick_request *mrq, unsigned char tpc,
+void memstick_init_req(struct memstick_dev *card, unsigned char tpc,
 		       const void *buf, size_t length)
 {
+	struct memstick_request *mrq = &card->current_mrq;
+	WARN_ON(!card->state_machine_running);
+
 	mrq->tpc = tpc;
 	if (tpc & 8)
 		mrq->data_dir = WRITE;
@@ -316,152 +471,39 @@ void memstick_init_req(struct memstick_request *mrq, unsigned char tpc,
 }
 EXPORT_SYMBOL(memstick_init_req);
 
-/*
- * Functions prefixed with "h_" are protocol callbacks. They can be called from
- * interrupt context. Return value of 0 means that request processing is still
- * ongoing, while special error value of -EAGAIN means that current request is
- * finished (and request processor should come back some time later).
- */
-
-static int h_memstick_read_dev_id(struct memstick_dev *card,
-				  struct memstick_request **mrq)
-{
-	struct ms_id_register id_reg;
-
-	if (!(*mrq)) {
-		memstick_init_req(&card->current_mrq, MS_TPC_READ_REG, NULL,
-				  sizeof(struct ms_id_register));
-		*mrq = &card->current_mrq;
-		return 0;
-	} else {
-		if (!(*mrq)->error) {
-			memcpy(&id_reg, (*mrq)->data, sizeof(id_reg));
-			card->id.match_flags = MEMSTICK_MATCH_ALL;
-			card->id.type = id_reg.type;
-			card->id.category = id_reg.category;
-			card->id.class = id_reg.class;
-			dev_dbg(&card->dev, "if_mode = %02x\n", id_reg.if_mode);
-		}
-		complete(&card->mrq_complete);
-		return -EAGAIN;
-	}
-}
-
-static int h_memstick_set_rw_addr(struct memstick_dev *card,
-				  struct memstick_request **mrq)
-{
-	if (!(*mrq)) {
-		memstick_init_req(&card->current_mrq, MS_TPC_SET_RW_REG_ADRS,
-				  (char *)&card->reg_addr,
-				  sizeof(card->reg_addr));
-		*mrq = &card->current_mrq;
-		return 0;
-	} else {
-		complete(&card->mrq_complete);
-		return -EAGAIN;
-	}
-}
-
-
-static int h_memstick_default_bad(struct memstick_dev *card,
-				     struct memstick_request **mrq)
-{
-	return -ENXIO;
-}
-
-/**
- * memstick_set_rw_addr - issue SET_RW_REG_ADDR request and wait for it to
- *                        complete
- * @card - media device to use
- */
-int memstick_set_rw_addr(struct memstick_dev *card)
-{
-	card->next_request = h_memstick_set_rw_addr;
-	memstick_new_req(card->host);
-	wait_for_completion(&card->mrq_complete);
-
-	return card->current_mrq.error;
-}
-EXPORT_SYMBOL(memstick_set_rw_addr);
-
-
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
-/**
- * memstick_complete_req - signal that request is completed
- * @card - card to use
- * @mrq - request to use
- * @error - result of the request
- *
- * Card drivers can use that function to signal end of request
- */
-int memstick_complete_request(struct memstick_dev *card,
-			struct memstick_request *req, int error)
-{
-	if (error)
-		req->error = error;
-
-	card->state = -1;
-	card->int_polling = false;
-	card->next_request = h_memstick_default_bad;
-
-	/* Invalidate reg window on errors */
-	if (req->error)
-		memstick_invalidate_reg_window(card);
-
-	complete(&card->mrq_complete);
-	return -EAGAIN;
-}
-EXPORT_SYMBOL(memstick_complete_request);
-
 /**
  * memstick_read_int_reg - read INT status from the card
  * if last request already contains the int flags, will return 0
  * returns 1 if new request was initialized
- * Will artifictially return MEMSTICK_INT_CMDNAK if this function was
- * called more that once in 300 msecs without memstick_finish_int_request
- * in between
+ * Will artifictially return MEMSTICK_INT_CMDNAK if more that 'timeout' msecs
+ * passed after last MS_TPC_GET_INT request (and no requests in between)
+ * if timeout == -1, then it is set to default value of 300 msec
  * @card - card to use
- * @req - request to use
+ * @timeout - the timeout. if -1, then uses default
  */
 
-int memstick_read_int_reg(struct memstick_dev *card,
-				struct memstick_request *req, long timeout)
+int memstick_read_int_reg(struct memstick_dev *card, long timeout)
 {
+	struct memstick_request *mrq = &card->current_mrq;
+	WARN_ON(!card->state_machine_running);
 
 	if (!card->int_polling) {
 		card->int_timeout = jiffies +
 			msecs_to_jiffies(timeout == -1 ? 300 : timeout);
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
+							mrq->need_card_int) {
+		BUG_ON(mrq->error);
+		mrq->data[0] = mrq->int_reg;
+		mrq->need_card_int = false;
 		return 0;
 	} else {
-		memstick_init_req(req, MS_TPC_GET_INT, NULL, 1);
+		memstick_init_req(card, MS_TPC_GET_INT, NULL, 1);
 		return 1;
 	}
 }
@@ -469,19 +511,6 @@ EXPORT_SYMBOL(memstick_read_int_reg);
 
 
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
@@ -492,9 +521,10 @@ EXPORT_SYMBOL(memstick_read_int_reg_cleanup);
  * @req - request to use
  */
 
-int memstick_read_regs(struct memstick_dev *card, int offset, int len,
-	struct memstick_request *req)
+int memstick_read_regs(struct memstick_dev *card, int offset, int len)
 {
+	WARN_ON(!card->state_machine_running);
+
 	if (card->reg_addr.r_offset != offset ||
 					card->reg_addr.r_length != len) {
 		card->reg_addr.r_offset = offset;
@@ -508,12 +538,12 @@ int memstick_read_regs(struct memstick_dev *card, int offset, int len,
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
@@ -527,11 +557,12 @@ EXPORT_SYMBOL(memstick_read_regs);
  * @offset - offset of first register to read
  * @len - number of bytes to read
  * @buf - the register data to write
- * @req - request to use
  */
-int memstick_write_regs(struct memstick_dev *card, int offset, int len,
-	char *buf, struct memstick_request *req)
+int memstick_write_regs(struct memstick_dev *card,
+					int offset, int len, void *buf)
 {
+	WARN_ON(!card->state_machine_running);
+
 	if (card->reg_addr.w_offset != offset ||
 					card->reg_addr.w_length != len) {
 		card->reg_addr.w_offset = offset;
@@ -546,35 +577,44 @@ int memstick_write_regs(struct memstick_dev *card, int offset, int len,
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
 
 
 /**
- * memstick_run_state_machine - runs state machine untill it calls
- * memstick_complete_request.
- * Usefull for blocking IO in the card drivers.
+ * memstick_state_machine_exit - signal that request is completed
  * @card - card to use
- * state_func - the state machine
+ * @mrq - request to use
+ * @error - result of the request
+ *
+ * State machines call this to signal quit
  */
-int memstick_run_state_machine(struct memstick_dev *card,
-	int   (*state_func)(struct memstick_dev *card,
-					struct memstick_request **mrq))
+int memstick_state_machine_exit(struct memstick_dev *card, int error)
 {
-	card->next_request = state_func;
-	memstick_new_req(card->host);
-	wait_for_completion(&card->mrq_complete);
-	return card->current_mrq.error;
-}
-EXPORT_SYMBOL(memstick_run_state_machine);
+	struct memstick_request *mrq = &card->current_mrq;
+	WARN_ON(!card->state_machine_running);
+
+	/* Invalidate reg window on errors */
+
+	if (error)
+		memstick_invalidate_reg_window(card);
 
+	mrq->error = error;
+	card->state = -1;
+	card->int_polling = false;
+	card->next_request = h_memstick_default_bad;
+	card->state_machine_running = false;
+	complete(&card->mrq_complete);
+	return -ENXIO;
+}
+EXPORT_SYMBOL(memstick_state_machine_exit);
 
 static const char *tpc_names[] = {
 	"MS_TPC_READ_MG_STATUS",
@@ -605,120 +645,35 @@ EXPORT_SYMBOL(memstick_debug_get_tpc_name);
 
 
 /**
- * memstick_invalidate_reg_window - invalidate the card register
- * read/write window (start, len)
- * Use when not certain if card still remembers it
+ * memstick_reset_card - power cycles the card
+ * @card - card to use
  */
-void memstick_invalidate_reg_window(struct memstick_dev *card)
+int memstick_reset_card(struct memstick_dev *card)
 {
-	memset(&card->reg_addr, 0, sizeof(card->reg_addr));
-}
-EXPORT_SYMBOL(memstick_invalidate_reg_window);
+	int error;
+	struct memstick_host *host = card->host;
 
+	memstick_invalidate_reg_window(card);
 
+	error = host->set_param(host, MEMSTICK_POWER, MEMSTICK_POWER_OFF);
+	if (error)
+		return error;
 
-static struct memstick_dev *memstick_alloc_card(struct memstick_host *host)
-{
-	struct memstick_dev *card = kzalloc(sizeof(struct memstick_dev),
-					    GFP_KERNEL);
-	struct memstick_dev *old_card = host->card;
-	struct ms_id_register id_reg;
-
-	if (card) {
-		card->host = host;
-		dev_set_name(&card->dev, "%s", dev_name(&host->dev));
-		card->dev.parent = &host->dev;
-		card->dev.bus = &memstick_bus_type;
-		card->dev.release = memstick_free_card;
-		card->check = memstick_dummy_check;
-
-		card->reg_addr.r_offset = offsetof(struct ms_register, id);
-		card->reg_addr.r_length = sizeof(id_reg);
-		card->reg_addr.w_offset = offsetof(struct ms_register, id);
-		card->reg_addr.w_length = sizeof(id_reg);
-
-		init_completion(&card->mrq_complete);
-
-		host->card = card;
-		if (memstick_set_rw_addr(card))
-			goto err_out;
-
-		card->next_request = h_memstick_read_dev_id;
-		memstick_new_req(host);
-		wait_for_completion(&card->mrq_complete);
-
-		if (card->current_mrq.error)
-			goto err_out;
-	}
-	host->card = old_card;
-	return card;
-err_out:
-	host->card = old_card;
-	kfree(card);
-	return NULL;
-}
+	msleep(50);
 
-static int memstick_power_on(struct memstick_host *host)
-{
-	int rc = host->set_param(host, MEMSTICK_POWER, MEMSTICK_POWER_ON);
+	error = host->set_param(host, MEMSTICK_POWER, MEMSTICK_POWER_ON);
+	if (error)
+		return error;
 
-	if (!rc)
-		rc = host->set_param(host, MEMSTICK_INTERFACE, MEMSTICK_SERIAL);
+	error = host->set_param(host, MEMSTICK_INTERFACE, MEMSTICK_SERIAL);
+	if (error)
+		return error;
 
-	return rc;
+	return 0;
 }
+EXPORT_SYMBOL(memstick_reset_card);
 
-static void memstick_check(struct work_struct *work)
-{
-	struct memstick_host *host = container_of(work, struct memstick_host,
-						  media_checker);
-	struct memstick_dev *card;
-
-	dev_dbg(&host->dev, "memstick_check started\n");
-	mutex_lock(&host->lock);
-	if (!host->card) {
-		if (memstick_power_on(host))
-			goto out_power_off;
-	} else if (host->card->stop)
-		host->card->stop(host->card);
-
-	card = memstick_alloc_card(host);
-
-	if (!card) {
-		if (host->card) {
-			device_unregister(&host->card->dev);
-			host->card = NULL;
-		}
-	} else {
-		dev_dbg(&host->dev, "new card %02x, %02x, %02x\n",
-			card->id.type, card->id.category, card->id.class);
-		if (host->card) {
-			if (memstick_set_rw_addr(host->card)
-			    || !memstick_dev_match(host->card, &card->id)
-			    || !(host->card->check(host->card))) {
-				device_unregister(&host->card->dev);
-				host->card = NULL;
-			} else if (host->card->start)
-				host->card->start(host->card);
-		}
-
-		if (!host->card) {
-			host->card = card;
-			if (device_register(&card->dev)) {
-				kfree(host->card);
-				host->card = NULL;
-			}
-		} else
-			kfree(card);
-	}
-
-out_power_off:
-	if (!host->card)
-		host->set_param(host, MEMSTICK_POWER, MEMSTICK_POWER_OFF);
-
-	mutex_unlock(&host->lock);
-	dev_dbg(&host->dev, "memstick_check finished\n");
-}
+/*** host driver interface ***/
 
 /**
  * memstick_alloc_host - allocate a memstick_host structure
@@ -837,20 +792,48 @@ void memstick_resume_host(struct memstick_host *host)
 }
 EXPORT_SYMBOL(memstick_resume_host);
 
-int memstick_register_driver(struct memstick_driver *drv)
+/**
+ * memstick_detect_change - schedule media detection on memstick host
+ * @host - host to use
+ */
+void memstick_detect_change(struct memstick_host *host)
 {
-	drv->driver.bus = &memstick_bus_type;
-
-	return driver_register(&drv->driver);
+	queue_work(workqueue, &host->media_checker);
 }
-EXPORT_SYMBOL(memstick_register_driver);
+EXPORT_SYMBOL(memstick_detect_change);
 
-void memstick_unregister_driver(struct memstick_driver *drv)
+/**
+ * memstick_next_req - called by host driver to obtain next request to process
+ * @host - host to use
+ * @mrq - pointer to stick the request to
+ *
+ * Host calls this function from idle state (*mrq == NULL) or after finishing
+ * previous request (*mrq should point to it). If previous request was
+ * unsuccessful, it is retried for predetermined number of times. Return value
+ * of 0 means that new request was assigned to the host.
+ */
+int memstick_next_req(struct memstick_host *host, struct memstick_request **mrq)
 {
-	driver_unregister(&drv->driver);
-}
-EXPORT_SYMBOL(memstick_unregister_driver);
+	int rc = -ENXIO;
+
+	if ((*mrq) && (*mrq)->error && host->retries) {
+		(*mrq)->error = rc;
+		host->retries--;
+		return 0;
+	}
+
+	if (host->card && host->card->next_request)
+		rc = host->card->next_request(host->card);
 
+	if (!rc) {
+		*mrq = &host->card->current_mrq;
+		host->retries = cmd_retries > 1 ? cmd_retries - 1 : 1;
+	} else
+		*mrq = NULL;
+
+	return rc;
+}
+EXPORT_SYMBOL(memstick_next_req);
 
 static int __init memstick_init(void)
 {
diff --git a/drivers/memstick/core/ms_block.c b/drivers/memstick/core/ms_block.c
index 75ec529..9a9aa3a 100644
--- a/drivers/memstick/core/ms_block.c
+++ b/drivers/memstick/core/ms_block.c
@@ -241,17 +241,17 @@ static int msb_advance_sg(struct msb_data *msb)
  * Writes output to msb->current_sg, takes sector address from msb->reg.param
  * Can also be used to read extra data only. Set params accordintly.
  */
-static int h_msb_read_page(struct memstick_dev *card,
-				 struct memstick_request **mrq)
+static int h_msb_read_page(struct memstick_dev *card)
 {
 	struct msb_data *msb = memstick_get_drvdata(card);
+	struct memstick_request *mrq = &card->current_mrq;
+
 	struct scatterlist sg;
 	u8 command, intreg;
 
-	memstick_allocate_request(card, mrq);
-	if ((*mrq)->error) {
+	if (mrq->error) {
 		dbg("read_page, unknown error");
-		return memstick_complete_request(card, *mrq, 0);
+		return memstick_state_machine_exit(card, mrq->error);
 	}
 again:
 	switch (card->state) {
@@ -259,35 +259,32 @@ again:
 		if (!memstick_write_regs(card,
 			offsetof(struct ms_register, param),
 			sizeof(struct ms_param_register),
-			(unsigned char *)&msb->regs.param,
-			*mrq))
+			(unsigned char *)&msb->regs.param))
 			return 0;
 		break;
 
 	case 1: /* Execute the read command*/
 		command = MS_CMD_BLOCK_READ;
-		memstick_init_req(*mrq, MS_TPC_SET_CMD, &command, 1);
+		memstick_init_req(card, MS_TPC_SET_CMD, &command, 1);
 		break;
 
 	case 2: /* send INT request */
-		if (memstick_read_int_reg(card, *mrq, -1))
+		if (memstick_read_int_reg(card, -1))
 			break;
 		card->state++;
 
 	case 3: /* get result of the INT request*/
-		intreg = (*mrq)->data[0];
+		intreg = mrq->data[0];
 		msb->regs.status.interrupt = intreg;
 
 		if (intreg & MEMSTICK_INT_CMDNAK)
-			return memstick_complete_request(card, *mrq, -EIO);
+			return memstick_state_machine_exit(card, -EIO);
 
 		if (!(intreg & MEMSTICK_INT_CED)) {
 			card->state--;
 			goto again;
 		}
 
-		memstick_read_int_reg_cleanup(card);
-
 		if (intreg & MEMSTICK_INT_ERR)
 			card->state++;
 		else
@@ -298,26 +295,24 @@ again:
 	case 4: /* read the status register to understand source of the INT_ERR */
 		if (!memstick_read_regs(card,
 			offsetof(struct ms_register, status),
-			sizeof(struct ms_status_register),
-			*mrq))
+			sizeof(struct ms_status_register)))
 			return 0;
 		break;
 
 	case 5: /* get results of status check */
-		msb->regs.status = *(struct ms_status_register *)(*mrq)->data;
+		msb->regs.status = *(struct ms_status_register *)mrq->data;
 		card->state++;
 
 	case 6: /* Send extra data read request */
 		if (!memstick_read_regs(card,
 			offsetof(struct ms_register, extra_data),
-			sizeof(struct ms_extra_data_register),
-			*mrq))
+			sizeof(struct ms_extra_data_register)))
 			return 0;
 		break;
 
 	case 7: /* Save result of extra data request */
 		msb->regs.extra_data =
-			*(struct ms_extra_data_register *) (*mrq)->data;
+			*(struct ms_extra_data_register *) mrq->data;
 		card->state++;
 
 	case 8: /* Send the  MS_TPC_READ_LONG_DATA to read IO buffer */
@@ -329,25 +324,25 @@ again:
 		}
 
 		msb_set_sg(msb, &sg);
-		memstick_init_req_sg(*mrq, MS_TPC_READ_LONG_DATA, &sg);
+		memstick_init_req_sg(card, MS_TPC_READ_LONG_DATA, &sg);
 		break;
 
 	case 9: /* check validity of data buffer & done */
 
 		if (!(msb->regs.status.interrupt & MEMSTICK_INT_ERR))
-			return memstick_complete_request(card, *mrq, 0);
+			return memstick_state_machine_exit(card, 0);
 
 		if (msb->regs.status.status1 & MEMSTICK_UNCORR_ERROR) {
 			dbg("read_page: uncorrectable error");
-			return memstick_complete_request(card, *mrq, -EBADMSG);
+			return memstick_state_machine_exit(card, -EBADMSG);
 		}
 
 		if (msb->regs.status.status1 & MEMSTICK_CORR_ERROR) {
 			dbg("read_page: correctable error");
-			return memstick_complete_request(card, *mrq, -EUCLEAN);
+			return memstick_state_machine_exit(card, -EUCLEAN);
 		} else {
 			dbg("read_page: INT error, but no status error bits");
-			return memstick_complete_request(card, *mrq, -EIO);
+			return memstick_state_machine_exit(card, -EIO);
 		}
 	default:
 		BUG();
@@ -363,16 +358,16 @@ again:
  * Returns -EBADMSG if write fails due to uncorrectable error, or -EIO if
  * device refuses to take the command or something else
  */
-static int h_msb_write_block(struct memstick_dev *card,
-				 struct memstick_request **mrq)
+static int h_msb_write_block(struct memstick_dev *card)
 {
 	struct msb_data *msb = memstick_get_drvdata(card);
+	struct memstick_request *mrq = &card->current_mrq;
+
 	struct scatterlist sg;
 	u8 intreg, command;
 
-	memstick_allocate_request(card, mrq);
-	if ((*mrq)->error)
-		return memstick_complete_request(card, *mrq, 0);
+	if (mrq->error)
+		return memstick_state_machine_exit(card, mrq->error);
 
 again:
 	switch (card->state) {
@@ -387,37 +382,36 @@ again:
 			offsetof(struct ms_register, param),
 			sizeof(struct ms_param_register) +
 			sizeof(struct ms_extra_data_register) + 2,
-			(unsigned char *)&msb->regs.param,
-			*mrq))
+			(unsigned char *)&msb->regs.param))
 			return 0;
 		break;
 
 	case 1: /* execute the write command*/
 		command = MS_CMD_BLOCK_WRITE;
-		memstick_init_req(*mrq, MS_TPC_SET_CMD, &command, 1);
+		memstick_init_req(card, MS_TPC_SET_CMD, &command, 1);
 		break;
 
 	case 2: /* send INT request */
-		if (memstick_read_int_reg(card, *mrq, -1))
+		if (memstick_read_int_reg(card, -1))
 			break;
 		card->state++;
 
 	case 3: /* read INT response */
-		intreg = (*mrq)->data[0];
+		intreg = mrq->data[0];
 		msb->regs.status.interrupt = intreg;
 
 		/* errors mean out of here, and fast... */
 		if (intreg & (MEMSTICK_INT_CMDNAK))
-			return memstick_complete_request(card, *mrq, -EIO);
+			return memstick_state_machine_exit(card, -EIO);
 
 		if (intreg & MEMSTICK_INT_ERR)
-			return memstick_complete_request(card, *mrq, -EBADMSG);
+			return memstick_state_machine_exit(card, -EBADMSG);
 
 
 		/* for last page we need to poll CED */
 		if (msb->current_page == msb->pages_in_block) {
 			if (intreg & MEMSTICK_INT_CED)
-				return memstick_complete_request(card, *mrq, 0);
+				return memstick_state_machine_exit(card, 0);
 			card->state--;
 			goto again;
 
@@ -429,13 +423,12 @@ again:
 			goto again;
 		}
 
-		memstick_read_int_reg_cleanup(card);
 		card->state++;
 
 	case 4: /* send the MS_TPC_WRITE_LONG_DATA to perform the write*/
 		msb_set_sg(msb, &sg);
-		memstick_init_req_sg(*mrq, MS_TPC_WRITE_LONG_DATA, &sg);
-		(*mrq)->need_card_int = 1;
+		memstick_init_req_sg(card, MS_TPC_WRITE_LONG_DATA, &sg);
+		mrq->need_card_int = 1;
 		break;
 
 	case 5: /* Switch to next page + go back to int polling */
@@ -445,8 +438,8 @@ again:
 			if (msb_advance_sg(msb)) {
 				ms_printk(
 				"BUG: out of data while writing block!");
-				return memstick_complete_request(card,
-								*mrq, -EFAULT);
+				return memstick_state_machine_exit(
+								card, -EFAULT);
 			}
 		}
 		card->state = 2;
@@ -462,17 +455,17 @@ again:
  * This function is used to send simple IO requests to device that consist
  * of register write + command
  */
-static int h_msb_send_command(struct memstick_dev *card,
-				 struct memstick_request **mrq)
+static int h_msb_send_command(struct memstick_dev *card)
 {
 	struct msb_data *msb = memstick_get_drvdata(card);
+	struct memstick_request *mrq = &card->current_mrq;
+
 	u8 intreg;
 	int len;
 
-	memstick_allocate_request(card, mrq);
-	if ((*mrq)->error) {
+	if (mrq->error) {
 		dbg("send_command: unknown error");
-		return memstick_complete_request(card, *mrq, 0);
+		return memstick_state_machine_exit(card, mrq->error);
 	}
 
 again:
@@ -486,27 +479,26 @@ again:
 		if (!memstick_write_regs(card,
 			offsetof(struct ms_register, param),
 			len,
-			(unsigned char *)&msb->regs.param,
-			*mrq))
+			(unsigned char *)&msb->regs.param))
 			return 0;
 		break;
 
 	case 1: /* execute the command*/
-		memstick_init_req(*mrq, MS_TPC_SET_CMD, &msb->command_value, 1);
+		memstick_init_req(card, MS_TPC_SET_CMD, &msb->command_value, 1);
 		break;
 
 	case 2: /* send INT request */
-		if (memstick_read_int_reg(card, *mrq, -1))
+		if (memstick_read_int_reg(card, -1))
 			break;
 		card->state++;
 
 	case 3: /* poll for int bits */
-		intreg = (*mrq)->data[0];
+		intreg = mrq->data[0];
 
 		if (intreg & MEMSTICK_INT_CMDNAK)
-			return memstick_complete_request(card, *mrq, -EIO);
+			return memstick_state_machine_exit(card, -EIO);
 		if (intreg & MEMSTICK_INT_ERR)
-			return memstick_complete_request(card, *mrq, -EBADMSG);
+			return memstick_state_machine_exit(card, -EBADMSG);
 
 
 		if (!(intreg & MEMSTICK_INT_CED)) {
@@ -514,47 +506,45 @@ again:
 			goto again;
 		}
 
-		memstick_read_int_reg_cleanup(card);
-		return memstick_complete_request(card, *mrq, 0);
+		return memstick_state_machine_exit(card, 0);
 	}
 	card->state++;
 	return 0;
 }
 
 /* Small handler for card reset */
-static int h_msb_reset(struct memstick_dev *card,
-				 struct memstick_request **mrq)
+static int h_msb_reset(struct memstick_dev *card)
 {
 	u8 command = MS_CMD_RESET;
+	struct memstick_request *mrq = &card->current_mrq;
 
-	memstick_allocate_request(card, mrq);
-	if ((*mrq)->error)
-		return memstick_complete_request(card, *mrq, 0);
+	if (mrq->error)
+		return memstick_state_machine_exit(card, mrq->error);
 
 	switch (card->state) {
 	case 0:
-		memstick_init_req(*mrq, MS_TPC_SET_CMD, &command, 1);
-		(*mrq)->need_card_int = 0;
+		memstick_init_req(card, MS_TPC_SET_CMD, &command, 1);
+		mrq->need_card_int = 0;
 		break;
 	case 1:
-		return memstick_complete_request(card, *mrq, 0);
+		return memstick_state_machine_exit(card, 0);
 	}
 	card->state++;
 	return 0;
 }
 
 /* This handler is used to do serial->parallel switch */
-static int h_msb_parallel_switch(struct memstick_dev *card,
-					struct memstick_request **mrq)
+static int h_msb_parallel_switch(struct memstick_dev *card)
 {
 	struct msb_data *msb = memstick_get_drvdata(card);
+	struct memstick_request *mrq = &card->current_mrq;
+
 	struct memstick_host *host = card->host;
 
-	memstick_allocate_request(card, mrq);
-	if ((*mrq)->error) {
+	if (mrq->error) {
 		dbg("parallel_switch: error");
 		msb->regs.param.system &= ~MEMSTICK_SYS_PAM;
-		return memstick_complete_request(card, *mrq, 0);
+		return memstick_state_machine_exit(card, mrq->error);
 	}
 
 	switch (card->state) {
@@ -565,19 +555,18 @@ static int h_msb_parallel_switch(struct memstick_dev *card,
 		if (!memstick_write_regs(card,
 			offsetof(struct ms_register, param),
 			1,
-			(unsigned char *)&msb->regs.param,
-			*mrq))
+			(unsigned char *)&msb->regs.param))
 			return 0;
 		break;
 
 	case 1: /* Set parallel interface on our side + send a dummy request
 			to see if card responds */
 		host->set_param(host, MEMSTICK_INTERFACE, MEMSTICK_PAR4);
-		memstick_init_req(&card->current_mrq, MS_TPC_GET_INT, NULL, 1);
+		memstick_init_req(card, MS_TPC_GET_INT, NULL, 1);
 		break;
 
 	case 2:
-		return memstick_complete_request(card, *mrq, 0);
+		return memstick_state_machine_exit(card, 0);
 	}
 	card->state++;
 	return 0;
@@ -590,21 +579,15 @@ static int msb_reset(struct msb_data *msb)
 {
 	bool was_parallel = msb->regs.param.system & MEMSTICK_SYS_PAM;
 	struct memstick_dev *card = msb->card;
-	struct memstick_host *host = card->host;
 	int error;
 
-	memstick_invalidate_reg_window(card);
-
-	/* Reset the controller */
-	host->set_param(host, MEMSTICK_POWER, MEMSTICK_POWER_OFF);
-	msleep(100);
-	host->set_param(host, MEMSTICK_POWER, MEMSTICK_POWER_ON);
-	host->set_param(host, MEMSTICK_INTERFACE, MEMSTICK_SERIAL);
-
-
 	/* Reset the card */
 	msb->regs.param.system = MEMSTICK_SYS_BAMD;
-	error = memstick_run_state_machine(card, h_msb_reset);
+	error = memstick_reset_card(card);
+
+	if (!error)
+		error = memstick_run_state_machine(card, h_msb_reset, true);
+
 	if (error) {
 		dbg("Failed to reset the card");
 		msb->read_only = true;
@@ -622,7 +605,8 @@ static int msb_switch_to_parallel(struct msb_data *msb)
 {
 	int error;
 
-	error = memstick_run_state_machine(msb->card, h_msb_parallel_switch);
+	error = memstick_run_state_machine(msb->card,
+						h_msb_parallel_switch, true);
 	if (error) {
 		ms_printk("Switch to parallel failed");
 		msb->regs.param.system &= ~MEMSTICK_SYS_PAM;
@@ -650,7 +634,7 @@ static int msb_set_overwrite_flag(struct msb_data *msb,
 
 	dbg_verbose("changing overwrite flag to %02x for sector %d, page %d",
 							flag, pba, page);
-	return memstick_run_state_machine(msb->card, h_msb_send_command);
+	return memstick_run_state_machine(msb->card, h_msb_send_command, true);
 }
 
 static int msb_mark_bad(struct msb_data *msb, int pba)
@@ -687,7 +671,7 @@ static int msb_erase_block(struct msb_data *msb, u16 pba)
 
 
 		error = memstick_run_state_machine(msb->card,
-							h_msb_send_command);
+						h_msb_send_command, true);
 		if (!error || msb_reset(msb))
 			break;
 	}
@@ -747,7 +731,8 @@ static int msb_read_page(struct msb_data *msb,
 
 		msb->current_sg = sg;
 		msb->sg_offset = 0;
-		error = memstick_run_state_machine(msb->card, h_msb_read_page);
+		error = memstick_run_state_machine(msb->card,
+						h_msb_read_page, true);
 
 
 		if (error == -EUCLEAN) {
@@ -798,7 +783,7 @@ static int msb_read_oob(struct msb_data *msb, u16 pba, u16 page,
 		return -EINVAL;
 	}
 
-	error = memstick_run_state_machine(msb->card, h_msb_read_page);
+	error = memstick_run_state_machine(msb->card, h_msb_read_page, true);
 	*extra = msb->regs.extra_data;
 
 	if (error == -EUCLEAN) {
@@ -889,7 +874,7 @@ static int msb_write_block(struct msb_data *msb,
 		msb->sg_offset = 0;
 
 		error = memstick_run_state_machine(msb->card,
-							h_msb_write_block);
+						h_msb_write_block, true);
 
 		/* Sector we just wrote to is assumed erased since its pba
 			was erased. If it wasn't erased, write will succeed
@@ -2108,6 +2093,7 @@ static int msb_resume(struct memstick_dev *card)
 
 	new_msb->card = card;
 	memstick_set_drvdata(card, new_msb);
+	spin_lock_init(&new_msb->q_lock);
 
 	if (msb_init_card(card))
 		goto out;
diff --git a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/mspro_block.c
index c589d26..0f28828 100644
--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -372,40 +372,38 @@ static sysfs_show_t mspro_block_attr_show(unsigned char tag)
  * finished (and request processor should come back some time later).
  */
 
-static int h_mspro_block_reset(struct memstick_dev *card,
-					struct memstick_request **mrq)
+static int h_mspro_block_reset(struct memstick_dev *card)
 {
 	struct mspro_block_data *msb = memstick_get_drvdata(card);
 	struct ms_status_register *status;
+	struct memstick_request *mrq = &card->current_mrq;
+
 	u8 intreg;
 
-	memstick_allocate_request(card, mrq);
-	if ((*mrq)->error) {
-		dbg(card, "Error here");
-		return memstick_complete_request(card, *mrq, 0);
-	}
+	if (mrq->error)
+		return memstick_state_machine_exit(card, mrq->error);
 
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
-				return memstick_complete_request(card, *mrq, 0);
+				return memstick_state_machine_exit(card, 0);
 			}
-			return memstick_complete_request(card, *mrq, -EIO);
+			return memstick_state_machine_exit(card, -EIO);
 		}
 
 		if (intreg & MEMSTICK_INT_CMDNAK)
-			return memstick_complete_request(card, *mrq, -EIO);
+			return memstick_state_machine_exit(card, -EIO);
 
 
 		if (!(intreg & MEMSTICK_INT_CED)) {
@@ -413,22 +411,20 @@ again:
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
-		return memstick_complete_request(card, *mrq, 0);
+		return memstick_state_machine_exit(card, 0);
 	}
 
 	card->state++;
@@ -436,14 +432,14 @@ again:
 
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
-		return memstick_complete_request(card, *mrq, 0);
+	if (mrq->error)
+		return memstick_state_machine_exit(card, mrq->error);
 
 	switch (card->state) {
 
@@ -451,8 +447,7 @@ static int h_mspro_block_switch_interface(struct memstick_dev *card,
 		if (!memstick_write_regs(card,
 			offsetof(struct mspro_register, param),
 			1,
-			&msb->system,
-			*mrq))
+			&msb->system))
 			return 0;
 		break;
 
@@ -461,13 +456,13 @@ static int h_mspro_block_switch_interface(struct memstick_dev *card,
 		error = card->host->set_param(card->host,
 				MEMSTICK_INTERFACE, msb->target_interface);
 		if (error)
-			return memstick_complete_request(card, *mrq, -EFAULT);
+			return memstick_state_machine_exit(card, -EFAULT);
 
-		memstick_init_req(*mrq, MS_TPC_GET_INT, NULL, 1);
+		memstick_init_req(card, MS_TPC_GET_INT, NULL, 1);
 		break;
 
 	case 2: /* done */
-		return memstick_complete_request(card, *mrq, 0);
+		return memstick_state_machine_exit(card, 0);
 
 	}
 
@@ -476,21 +471,20 @@ static int h_mspro_block_switch_interface(struct memstick_dev *card,
 }
 
 /* State machine that handles the IO. Heart of the driver */
-static int h_mspro_block_transfer_data(struct memstick_dev *card,
-				       struct memstick_request **mrq)
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
 		msb->io_error = true;
 		card->state = 5;
 	}
@@ -498,17 +492,17 @@ again:
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
@@ -524,7 +518,6 @@ again:
 				goto again;
 			}
 
-			memstick_read_int_reg_cleanup(card);
 			card->state = 6;
 			goto again;
 		}
@@ -535,7 +528,6 @@ again:
 			goto again;
 		}
 
-		memstick_read_int_reg_cleanup(card);
 		card->state++;
 
 	case 3: /* init transfer of the data */
@@ -549,11 +541,11 @@ again:
 			msb->page_size,
 			offset_in_page(t_offset));
 
-		memstick_init_req_sg(*mrq, msb->data_dir == READ
+		memstick_init_req_sg(card, msb->data_dir == READ
 					   ? MS_TPC_READ_LONG_DATA
 					   : MS_TPC_WRITE_LONG_DATA,
 				     &t_sg);
-		(*mrq)->need_card_int = 1;
+		mrq->need_card_int = 1;
 		break;
 
 	case 4: /* switch to next page */
@@ -570,34 +562,36 @@ again:
 
 	case 5: /* after a error send STOP command */
 		command = MSPRO_CMD_STOP;
-		memstick_init_req(*mrq, MS_TPC_SET_CMD, &command, 1);
+		memstick_init_req(card, MS_TPC_SET_CMD, &command, 1);
 		break;
 
 	case 6: /* request complete - get next one*/
 		spin_lock_irqsave(&msb->q_lock, flags);
 
 		if (msb->io_error)
-			(*mrq)->error = -EIO;
+			mrq->error = -EIO;
 
 		if (msb->block_req) {
-			mspro_block_complete_req(card, (*mrq)->error);
-			error = mspro_block_issue_req(card);
+			mspro_block_complete_req(card, mrq->error);
+			error = mspro_block_issue_req(card, false);
+
+			if (error) {
+				WARN_ON(msb->block_req);
 
-			if (!msb->block_req) {
 				dbg_v(card, "IO: out of requests");
-				memstick_complete_request(card, *mrq, 0);
+				error = memstick_state_machine_exit(card, 0);
 				spin_unlock_irqrestore(&msb->q_lock, flags);
-				return -EAGAIN;
+				return error;
 			}
 
 			spin_unlock_irqrestore(&msb->q_lock, flags);
-			(*mrq)->error = 0;
+			mrq->error = 0;
 			card->state = 0;
 			goto again;
 
 		} else {
 			spin_unlock_irqrestore(&msb->q_lock, flags);
-			return memstick_complete_request(card, *mrq, 0);
+			return memstick_state_machine_exit(card, 0);
 		}
 	default:
 		BUG();
@@ -629,7 +623,7 @@ static int mspro_block_setup_io(struct memstick_dev *card, int direction,
  * Start execution of next block request,
  * or continue execution of the current one
  */
-static int mspro_block_issue_req(struct memstick_dev *card)
+static int mspro_block_issue_req(struct memstick_dev *card, bool first)
 {
 	struct mspro_block_data *msb = memstick_get_drvdata(card);
 	sector_t sec;
@@ -642,10 +636,17 @@ again:
 		msb->block_req = blk_fetch_request(msb->queue);
 		if (!msb->block_req) {
 			dbg(card, "IO: failed, because queue is empty");
-			return -EAGAIN;
+			return -ENXIO;
 		}
 	}
 
+	if (msb->eject) {
+		dbg(card, "IO: Refusing request, because card is removed");
+		__blk_end_request_all(msb->block_req, -ENODEV);
+		msb->block_req = NULL;
+		goto again;
+	}
+
 	sec = blk_rq_pos(msb->block_req) << 9;
 	sector_div(sec, msb->page_size);
 	pages = blk_rq_bytes(msb->block_req) / msb->page_size;
@@ -665,15 +666,14 @@ again:
 	dbg(card, "IO: %s: lba %x, pages %x", is_read ? "read" : "write",
 					(unsigned int)sec, pages);
 
-	/* can't use memstick_run_state_machine because we don't block */
-	card->next_request = h_mspro_block_transfer_data;
+	if (first)
+		memstick_run_state_machine(card,
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
@@ -705,7 +705,8 @@ static int mspro_block_read_attribute(struct memstick_dev *card,
 	sg_init_one(&msb->req_sg[0], buffer, len);
 	mspro_block_setup_io(card, READ, offset / msb->page_size,
 				len / msb->page_size, MSPRO_CMD_READ_ATRB);
-	return memstick_run_state_machine(card, h_mspro_block_transfer_data);
+	return memstick_run_state_machine(card,
+					h_mspro_block_transfer_data, true);
 }
 
 /* Memory allocated for attributes by this function should be freed by
@@ -724,7 +725,7 @@ static int mspro_block_read_attributes(struct memstick_dev *card)
 
 	int cnt, error, attr_count;
 
-	/* Allocate initial buffer */
+	/* Allocate cache buffer */
 	buffer_size = msb->page_size;
 	buffer_address = 0;
 	buffer = kmalloc(buffer_size, GFP_KERNEL);
@@ -898,61 +899,39 @@ static void mspro_block_submit_req(struct request_queue *q)
 {
 	struct memstick_dev *card = q->queuedata;
 	struct mspro_block_data *msb = memstick_get_drvdata(card);
-	struct request *req = NULL;
-
-	dbg(card, "IO: block layer submits us new request");
+	int error;
 
 	if (msb->block_req) {
-		dbg(card, "IO: Already have an request");
+		dbg_v(card,
+			"IO: block layer submits request, while we have one");
 		return;
 	}
 
-	if (msb->eject) {
-		dbg(card, "IO: Refusing requests on removed card");
-		while ((req = blk_fetch_request(q)) != NULL)
-			__blk_end_request_all(req, -ENODEV);
-		return;
-	}
+	dbg(card, "IO: block layer wakes us up for request processing");
 
-	if (mspro_block_issue_req(card)) {
-		dbg(card, "IO: Falure to issue request");
-		msb->block_req = NULL;
-	} else
-		memstick_new_req(card->host);
+	error = mspro_block_issue_req(card, true);
+	WARN_ON(error && msb->block_req != NULL);
 }
 
 /* Reset the card */
-static int mspro_block_reset(struct memstick_dev *card, bool full)
+static int mspro_block_reset(struct memstick_dev *card)
 {
-	struct memstick_host *host = card->host;
 	struct mspro_block_data *msb = memstick_get_drvdata(card);
 	int error;
 
 	dbg(card, "resetting the card");
 
 	msb->system = MEMSTICK_SYS_SERIAL;
+	error = memstick_reset_card(card);
 
-	error = host->set_param(host, MEMSTICK_POWER, MEMSTICK_POWER_OFF);
-	if (error)
-		return error;
-	msleep(50);
-
-	error = host->set_param(host, MEMSTICK_POWER, MEMSTICK_POWER_ON);
-	if (error)
-		return error;
-
-	error = host->set_param(host, MEMSTICK_INTERFACE, MEMSTICK_SERIAL);
-	if (error)
-		return error;
-
-	msleep(150);
-
-	/* Invalidate the register window */
-	memstick_invalidate_reg_window(card);
+	if (!error) {
+		msleep(150);
+		error = memstick_run_state_machine(card,
+					h_mspro_block_reset, true);
+	}
 
-	error = memstick_run_state_machine(card, h_mspro_block_reset);
 	if (error) {
-		dbg(card, "card reset failure");
+		dbg(card, "card reset failed");
 		return error;
 	}
 
@@ -974,11 +953,11 @@ static int mspro_block_switch_interface(struct memstick_dev *card)
 	msb->system = MEMSTICK_SYS_PAR4;
 	msb->target_interface = MEMSTICK_PAR4;
 	error = memstick_run_state_machine(card,
-						h_mspro_block_switch_interface);
+					h_mspro_block_switch_interface, true);
 	if (error) {
 		dbg(card, "failure to switch to parallel 4 bit inteface");
 		card->caps &= ~MEMSTICK_CAP_PAR4;
-		return mspro_block_reset(card, true);
+		return mspro_block_reset(card);
 	}
 
 	if (!(card->caps & host->caps & MEMSTICK_CAP_PAR8))
@@ -988,11 +967,11 @@ static int mspro_block_switch_interface(struct memstick_dev *card)
 	msb->target_interface = MEMSTICK_PAR8;
 	dbg(card, "trying to switch to parallel 8 bit inteface");
 	error = memstick_run_state_machine(card,
-					h_mspro_block_switch_interface);
+				h_mspro_block_switch_interface, true);
 	if (error) {
 		dbg(card, "failure to switch to parallel 8 bit inteface");
 		card->caps &= ~MEMSTICK_CAP_PAR8;
-		return mspro_block_reset(card, true);
+		return mspro_block_reset(card);
 	}
 
 	return error;
@@ -1006,7 +985,7 @@ static int mspro_block_init_card(struct memstick_dev *card)
 	/* TODO: can't we know what card supports from attributes? */
 	card->caps = MEMSTICK_CAP_PAR4 | MEMSTICK_CAP_PAR8;
 
-	rc = mspro_block_reset(card, false);
+	rc = mspro_block_reset(card);
 	if (rc)
 		return rc;
 
@@ -1058,10 +1037,13 @@ static int mspro_block_init_disk(struct memstick_dev *card)
 
 	msb->page_size = be16_to_cpu(sys_info->unit_size);
 
-	if (!idr_pre_get(&mspro_block_disk_idr, GFP_KERNEL))
+	mutex_lock(&mspro_block_disk_lock);
+
+	if (!idr_pre_get(&mspro_block_disk_idr, GFP_KERNEL)) {
+		mutex_unlock(&mspro_block_disk_lock);
 		return -ENOMEM;
+	}
 
-	mutex_lock(&mspro_block_disk_lock);
 	rc = idr_get_new(&mspro_block_disk_idr, card, &disk_id);
 	mutex_unlock(&mspro_block_disk_lock);
 
@@ -1250,6 +1232,8 @@ static int mspro_block_resume(struct memstick_dev *card)
 
 	new_msb->card = card;
 	memstick_set_drvdata(card, new_msb);
+	spin_lock_init(&new_msb->q_lock);
+
 	if (mspro_block_init_card(card))
 		goto out_free;
 
diff --git a/drivers/memstick/core/mspro_block.h b/drivers/memstick/core/mspro_block.h
index 86a340d..120f306 100644
--- a/drivers/memstick/core/mspro_block.h
+++ b/drivers/memstick/core/mspro_block.h
@@ -160,7 +160,7 @@ struct mspro_block_data {
 
 static void mspro_block_complete_req(struct memstick_dev *card, int error);
 static int mspro_block_switch_interface(struct memstick_dev *card);
-static int mspro_block_issue_req(struct memstick_dev *card);
+static int mspro_block_issue_req(struct memstick_dev *card, bool first);
 
 #define __dbg(card, level, format, ...) \
 	do { \
diff --git a/include/linux/memstick.h b/include/linux/memstick.h
index e7bc236..8e1802d 100644
--- a/include/linux/memstick.h
+++ b/include/linux/memstick.h
@@ -256,11 +256,11 @@ struct memstick_device_id {
  * and besides waiting, the host driver must read the INT register
  * (via data lines)
  *
- * In addition to that if hardware is 'smart', it could be able to read
- * the INT register even in parallel mode by sending MS_TPC_GET_INT
- * by itself. This capablility is indicated by host via
- * MEMSTICK_CAP_AUTO_GET_INT.
- * Then serial mode behavier must be the same as parallel
+ * In addition to that if hardware is 'smart', and is able to read
+ * the INT register even in serial mode by sending MS_TPC_GET_INT
+ * by itself (This capablility is indicated by host via
+ * MEMSTICK_CAP_AUTO_GET_INT),
+ * then the serial mode behavier must be the same as the parallel.
  */
 struct memstick_request {
 	unsigned char tpc;
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
@@ -302,6 +301,7 @@ struct memstick_dev {
 	unsigned long		 int_timeout;
 	int			 state;
 	int			 caps;
+	bool			 state_machine_running;
 };
 
 struct memstick_host {
@@ -338,9 +338,6 @@ struct memstick_driver {
 	struct device_driver      driver;
 };
 
-int memstick_register_driver(struct memstick_driver *drv);
-void memstick_unregister_driver(struct memstick_driver *drv);
-
 struct memstick_host *memstick_alloc_host(unsigned int extra,
 					  struct device *dev);
 
@@ -350,40 +347,32 @@ void memstick_free_host(struct memstick_host *host);
 void memstick_detect_change(struct memstick_host *host);
 void memstick_suspend_host(struct memstick_host *host);
 void memstick_resume_host(struct memstick_host *host);
-
-void memstick_init_req_sg(struct memstick_request *mrq, unsigned char tpc,
-			  const struct scatterlist *sg);
-void memstick_init_req(struct memstick_request *mrq, unsigned char tpc,
-		       const void *buf, size_t length);
 int memstick_next_req(struct memstick_host *host,
 		      struct memstick_request **mrq);
-void memstick_new_req(struct memstick_host *host);
-
-int memstick_set_rw_addr(struct memstick_dev *card);
 
 /* Helpers for high level drivers */
-void memstick_allocate_request(struct memstick_dev *card,
-					struct memstick_request **mrq);
 
-int memstick_complete_request(struct memstick_dev *card,
-			struct memstick_request *req, int error);
+int memstick_register_driver(struct memstick_driver *drv);
+void memstick_unregister_driver(struct memstick_driver *drv);
 
-int memstick_read_int_reg(struct memstick_dev *card,
-				struct memstick_request *req, long timeout);
+int memstick_run_state_machine(struct memstick_dev *card,
+	int   (*next_request)(struct memstick_dev *card), bool async);
 
-void memstick_read_int_reg_cleanup(struct memstick_dev *card);
+void memstick_init_req_sg(struct memstick_dev *card, unsigned char tpc,
+			  const struct scatterlist *sg);
+void memstick_init_req(struct memstick_dev *card, unsigned char tpc,
+		       const void *buf, size_t length);
+
+int memstick_read_int_reg(struct memstick_dev *card, long timeout);
 
-int memstick_read_regs(struct memstick_dev *card, int offset, int len,
-	struct memstick_request *req);
+int memstick_read_regs(struct memstick_dev *card, int offset, int len);
 
 int memstick_write_regs(struct memstick_dev *card, int offset, int len,
-	char *buf, struct memstick_request *req);
+	void *buf);
 
-void memstick_invalidate_reg_window(struct memstick_dev *card);
+int memstick_state_machine_exit(struct memstick_dev *card, int error);
 
-int memstick_run_state_machine(struct memstick_dev *card,
-	int   (*next_request)(struct memstick_dev *card,
-				struct memstick_request **mrq));
+int memstick_reset_card(struct memstick_dev *card);
 
 const char *memstick_debug_get_tpc_name(int tpc);
 
-- 
1.7.1

