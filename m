Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143Ab0JVXyO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 19:54:14 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60658 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319Ab0JVXyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 19:54:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=DFP5vYxnTUWI1+VK/2S9EoK3UhLTehkgQPtBqqdTLRHIa/S+ijzThTbCf7pzV4fQL/
         m7g4juL+pfMqos1fmn3+t08mIrzWOyecJ6Cwc6Fb/XEWcnva52f8H9hU4KlQmmE+mYb3
         J2KmjYawknGSwfe/ddcrTGV9mG35DHHICLFYo=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 03/29] memstick: core: add new functions
Date: Sat, 23 Oct 2010 01:53:31 +0200
Message-Id: <1287791637-10329-4-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287791637-10329-1-git-send-email-maximlevitsky@gmail.com>
References: <1287791637-10329-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a lot of support code that will be used later.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/memstick/core/memstick.c |  299 ++++++++++++++++++++++++++++++++++++--
 include/linux/memstick.h         |   32 ++++
 2 files changed, 318 insertions(+), 13 deletions(-)

diff --git a/drivers/memstick/core/memstick.c b/drivers/memstick/core/memstick.c
index 5a501a4..9fe36c7 100644
--- a/drivers/memstick/core/memstick.c
+++ b/drivers/memstick/core/memstick.c
@@ -249,6 +249,17 @@ static int h_memstick_set_rw_addr(struct memstick_dev *card,
 	}
 }
 
+static int h_memstick_default_bad(struct memstick_dev *card,
+				     struct memstick_request **mrq)
+{
+	return -ENXIO;
+}
+
+static void memstick_invalidate_reg_window(struct memstick_dev *card)
+{
+	memset(&card->reg_addr, 0, sizeof(card->reg_addr));
+}
+
 
 static struct memstick_dev *memstick_alloc_card(struct memstick_host *host)
 {
@@ -293,14 +304,23 @@ err_out:
 
 int memstick_power_on(struct memstick_host *host)
 {
-	int rc = host->set_param(host, MEMSTICK_POWER, MEMSTICK_POWER_ON);
+	int rc;
 
+	if (host->card)
+		memstick_invalidate_reg_window(host->card);
+
+	rc = host->set_param(host, MEMSTICK_POWER, MEMSTICK_POWER_ON);
 	if (!rc)
 		rc = host->set_param(host, MEMSTICK_INTERFACE, MEMSTICK_SERIAL);
 
 	return rc;
 }
 
+int memstick_power_off(struct memstick_host *host)
+{
+	return host->set_param(host, MEMSTICK_POWER, MEMSTICK_POWER_OFF);
+}
+
 static void memstick_check(struct work_struct *work)
 {
 	struct memstick_host *host = container_of(work, struct memstick_host,
@@ -347,7 +367,7 @@ static void memstick_check(struct work_struct *work)
 
 out_power_off:
 	if (!host->card)
-		host->set_param(host, MEMSTICK_POWER, MEMSTICK_POWER_OFF);
+		memstick_power_off(host);
 
 	mutex_unlock(&host->lock);
 	dev_dbg(&host->dev, "memstick_check finished\n");
@@ -356,10 +376,9 @@ out_power_off:
 /*** card driver interface ***/
 
 /**
-  * memstick_register_driver - Register new card driver
-  * @drv - the driver descriptior
-  */
-
+ * memstick_register_driver - register new card driver
+ * @drv - the driver info structure
+ */
 int memstick_register_driver(struct memstick_driver *drv)
 {
 	drv->driver.bus = &memstick_bus_type;
@@ -369,10 +388,10 @@ int memstick_register_driver(struct memstick_driver *drv)
 EXPORT_SYMBOL(memstick_register_driver);
 
 /**
-  * memstick_unregister_driver - deregister new card driver
-  * @drv - the driver descriptior
-  */
-
+ * memstick_unregister_driver - unregister a card driver
+ * usually called on card driver unload
+ * @drv - the driver info structure
+ */
 void memstick_unregister_driver(struct memstick_driver *drv)
 {
 	driver_unregister(&drv->driver);
@@ -396,8 +415,6 @@ int memstick_set_rw_addr(struct memstick_dev *card)
 EXPORT_SYMBOL(memstick_set_rw_addr);
 
 
-
-
 /**
  * memstick_new_req - notify the host that some requests are pending
  * @host - host to use
@@ -412,6 +429,93 @@ void memstick_new_req(struct memstick_host *host)
 }
 EXPORT_SYMBOL(memstick_new_req);
 
+
+/*** state machine support code ***/
+
+/**
+ * memstick_run_state_machine - runs IO state machine
+ * DON'T call from state machine code!
+ * Usefull for blocking IO in the card drivers.
+ * @card - card to use
+ * @state_func - the state machine
+ * @sync - if true, will wait till state machine exits using
+ * memstick_exit_state_machine
+ */
+int memstick_run_state_machine(struct memstick_dev *card,
+	int   (*state_func)(struct memstick_dev *card,
+			struct memstick_request **mrq), bool sync)
+{
+	WARN_ON(card->state != -1);
+
+	/* Init everything to prevent stale data from creeping in */
+	memset(&card->current_mrq, 0, sizeof(card->current_mrq));
+	card->int_polling = false;
+	card->state = 0;
+	card->exit_error = 0;
+
+
+	card->next_request = state_func;
+	card->host->retries = cmd_retries;
+	INIT_COMPLETION(card->mrq_complete);
+	card->host->request(card->host);
+
+	if (!sync)
+		return 0;
+
+	wait_for_completion(&card->mrq_complete);
+
+	WARN_ON(card->state != -1);
+	return card->exit_error;
+}
+EXPORT_SYMBOL(memstick_run_state_machine);
+
+
+/**
+ * memstick_exit_state_machine - signal that request is completed
+ * @card - card to use
+ * @mrq - request to use
+ * @error - result of the request
+ *
+ * State machines call this to signal quit
+ */
+int memstick_exit_state_machine(struct memstick_dev *card,
+			struct memstick_request *req, int error)
+{
+	if (error)
+		req->error = error;
+
+	card->state = -1;
+	card->exit_error = error;
+	card->next_request = h_memstick_default_bad;
+
+	/* Invalidate reg window on errors */
+	if (error)
+		memstick_invalidate_reg_window(card);
+
+	complete(&card->mrq_complete);
+	return -ENXIO;
+}
+EXPORT_SYMBOL(memstick_exit_state_machine);
+
+/**
+ * memstick_allocate_request - create new request for use in request handler
+ * @card - card to use
+ * @mrq - request to initialize
+ */
+void memstick_allocate_request(struct memstick_dev *card,
+					struct memstick_request **mrq)
+{
+	if (*mrq == NULL) {
+		*mrq = &card->current_mrq;
+		(*mrq)->error = 0;
+		(*mrq)->need_card_int = 0;
+		card->int_polling = false;
+		card->state = 0;
+	}
+}
+EXPORT_SYMBOL(memstick_allocate_request);
+
+
 /**
  * memstick_init_req_sg - set request fields needed for bulk data transfer
  * @mrq - request to use
@@ -470,6 +574,175 @@ void memstick_init_req(struct memstick_request *mrq, unsigned char tpc,
 }
 EXPORT_SYMBOL(memstick_init_req);
 
+/**
+ * memstick_read_int_reg - read INT status from the card
+ * if last request already contains the int flags, will return 0
+ * returns 1 if new request was initialized
+ * Will artifictially return MEMSTICK_INT_CMDNAK if more that 'timeout' msecs
+ * passed after last MS_TPC_GET_INT request (and no requests in between)
+ * if timeout == -1, then it is set to default value of 500 msec
+ * @card - card to use
+ * @timeout - the timeout. if -1, then uses default
+ */
+int memstick_read_int_reg(struct memstick_dev *card,
+				struct memstick_request *req, long timeout)
+{
+
+	if (!card->int_polling) {
+		card->int_timeout = jiffies +
+			msecs_to_jiffies(timeout == -1 ? 500 : timeout);
+		card->int_polling = true;
+	} else if (time_after(jiffies, card->int_timeout)) {
+		req->data[0] = MEMSTICK_INT_CMDNAK;
+		return 0;
+	}
+
+	if (((card->caps | card->host->caps) & MEMSTICK_CAP_AUTO_GET_INT) &&
+							req->need_card_int) {
+		BUG_ON(req->error);
+		req->data[0] = req->int_reg;
+		req->need_card_int = 0;
+		return 0;
+	} else {
+		memstick_init_req(req, MS_TPC_GET_INT, NULL, 1);
+		return 1;
+	}
+}
+EXPORT_SYMBOL(memstick_read_int_reg);
+
+
+/**
+ * memstick_read_int_reg_cleanup - cleanup after series of calls to
+ * memstick_read_int_reg. Used to cancel timeout.
+ * Use this if you use memstick_read_int_reg
+ * @card - card to use
+ */
+void memstick_read_int_reg_cleanup(struct memstick_dev *card)
+{
+	card->int_polling = false;
+}
+EXPORT_SYMBOL(memstick_read_int_reg_cleanup);
+
+
+/**
+ * memstick_read_regs - read the ms registers
+ * If there is need to change the R/W window,
+ * it will create the MS_TPC_SET_RW_REG_ADRS request and return 0,
+ * otherwise it will create a request for register read and return 1
+ * @card - card to use
+ * @offset - offset of first register to read
+ * @len - number of bytes to read
+ * @req - request to use
+ */
+
+int memstick_read_regs(struct memstick_dev *card, int offset, int len,
+	struct memstick_request *req)
+{
+	if (card->reg_addr.r_offset != offset ||
+					card->reg_addr.r_length != len) {
+		card->reg_addr.r_offset = offset;
+		card->reg_addr.r_length = len;
+
+		/* Set dummy window after reg invalidation to prevent
+			possible rejection of 0,0 window by the card */
+		if (!card->reg_addr.w_length) {
+			card->reg_addr.w_offset =
+					offsetof(struct ms_register, id);
+			card->reg_addr.w_length = sizeof(struct ms_id_register);
+		}
+
+		memstick_init_req(req, MS_TPC_SET_RW_REG_ADRS, &card->reg_addr,
+			sizeof(card->reg_addr));
+		return 0;
+	}
+
+	memstick_init_req(req, MS_TPC_READ_REG, NULL, len);
+	return 1;
+}
+EXPORT_SYMBOL(memstick_read_regs);
+
+/**
+ * memstick_write_regs - write the ms registers.
+ * If there is need to change the R/W window,
+ * it will create the MS_TPC_SET_RW_REG_ADRS request and return 0,
+ * otherwise it will create a request for register write and return 1
+ * @card - card to use
+ * @offset - offset of first register to read
+ * @len - number of bytes to read
+ * @buf - the register data to write
+ * @req - request to use
+ */
+int memstick_write_regs(struct memstick_dev *card, int offset, int len,
+	char *buf, struct memstick_request *req)
+{
+	if (card->reg_addr.w_offset != offset ||
+					card->reg_addr.w_length != len) {
+		card->reg_addr.w_offset = offset;
+		card->reg_addr.w_length = len;
+
+		/* Set dummy window after reg invalidation to prevent
+			possible rejection of 0,0 window by the card */
+		if (!card->reg_addr.r_length) {
+			card->reg_addr.r_offset =
+					offsetof(struct ms_register, id);
+
+			card->reg_addr.r_length = sizeof(struct ms_id_register);
+		}
+
+		memstick_init_req(req, MS_TPC_SET_RW_REG_ADRS, &card->reg_addr,
+			sizeof(card->reg_addr));
+		return 0;
+	}
+
+	memstick_init_req(req, MS_TPC_WRITE_REG, buf, len);
+	return 1;
+}
+EXPORT_SYMBOL(memstick_write_regs);
+
+
+static const char *tpc_names[] = {
+	"MS_TPC_READ_MG_STATUS",
+	"MS_TPC_READ_LONG_DATA",
+	"MS_TPC_READ_SHORT_DATA",
+	"MS_TPC_READ_REG",
+	"MS_TPC_READ_QUAD_DATA",
+	"INVALID",
+	"MS_TPC_GET_INT",
+	"MS_TPC_SET_RW_REG_ADRS",
+	"MS_TPC_EX_SET_CMD",
+	"MS_TPC_WRITE_QUAD_DATA",
+	"MS_TPC_WRITE_REG",
+	"MS_TPC_WRITE_SHORT_DATA",
+	"MS_TPC_WRITE_LONG_DATA",
+	"MS_TPC_SET_CMD",
+};
+
+/**
+ * memstick_debug_get_tpc_name - debug helper that returns string for
+ * a TPC number
+ */
+const char *memstick_debug_get_tpc_name(int tpc)
+{
+	return tpc_names[tpc-1];
+}
+EXPORT_SYMBOL(memstick_debug_get_tpc_name);
+
+/**
+ * memstick_reset - power cycles the host
+ */
+int memstick_reset(struct memstick_host *host)
+{
+	int error = memstick_power_off(host);
+	if (error)
+		return error;
+
+	/* TODO: why this delay ? */
+	msleep(50);
+
+	return memstick_power_on(host);
+}
+EXPORT_SYMBOL(memstick_reset);
+
 /*** low level (host) driver interface ***/
 
 /**
@@ -566,7 +839,7 @@ EXPORT_SYMBOL(memstick_free_host);
 void memstick_suspend_host(struct memstick_host *host)
 {
 	mutex_lock(&host->lock);
-	host->set_param(host, MEMSTICK_POWER, MEMSTICK_POWER_OFF);
+	memstick_power_off(host);
 	mutex_unlock(&host->lock);
 }
 EXPORT_SYMBOL(memstick_suspend_host);
diff --git a/include/linux/memstick.h b/include/linux/memstick.h
index 428c4a1..73586cb 100644
--- a/include/linux/memstick.h
+++ b/include/linux/memstick.h
@@ -296,6 +296,13 @@ struct memstick_dev {
 	void                     (*start)(struct memstick_dev *card);
 
 	struct device            dev;
+	int			 caps;
+
+	/* state machine's state */
+	int			 state;
+	int			 exit_error;
+	bool			 int_polling;
+	unsigned long		 int_timeout;
 };
 
 struct memstick_host {
@@ -349,6 +356,16 @@ void memstick_unregister_driver(struct memstick_driver *drv);
 
 int memstick_set_rw_addr(struct memstick_dev *card);
 
+int memstick_run_state_machine(struct memstick_dev *card,
+	int   (*state_func)(struct memstick_dev *card,
+			struct memstick_request **mrq), bool sync);
+
+int memstick_exit_state_machine(struct memstick_dev *card,
+			struct memstick_request *req, int error);
+
+void memstick_allocate_request(struct memstick_dev *card,
+					struct memstick_request **mrq);
+
 void memstick_new_req(struct memstick_host *host);
 
 void memstick_init_req_sg(struct memstick_request *mrq, unsigned char tpc,
@@ -356,6 +373,21 @@ void memstick_init_req_sg(struct memstick_request *mrq, unsigned char tpc,
 void memstick_init_req(struct memstick_request *mrq, unsigned char tpc,
 		       const void *buf, size_t length);
 
+int memstick_read_int_reg(struct memstick_dev *card,
+				struct memstick_request *req, long timeout);
+
+void memstick_read_int_reg_cleanup(struct memstick_dev *card);
+
+int memstick_read_regs(struct memstick_dev *card, int offset, int len,
+	struct memstick_request *req);
+
+int memstick_write_regs(struct memstick_dev *card, int offset, int len,
+	char *buf, struct memstick_request *req);
+
+const char *memstick_debug_get_tpc_name(int tpc);
+
+int memstick_reset(struct memstick_host *host);
+
 /* Interface for low-level (host) drivers */
 
 struct memstick_host *memstick_alloc_host(unsigned int extra,
-- 
1.7.1

