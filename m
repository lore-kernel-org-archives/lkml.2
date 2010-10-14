Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab0JNCdW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 22:33:22 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39159 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188Ab0JNCdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 22:33:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=X1VFIIcNaTAXLCtlTKi3nyplKVkOLddgN5s/jRrmoTRhqSO6cZQGHKBz8bgNfZM4I+
         3jYW5xb8iswORDnlVotZELXML/+cntuWNLtf9DNj2kJQ3BeLdtIoI7kOD11un2fwDXst
         oZYQi8tzioXHXwGjeP1GGqFTRU4cx0kvevAa8=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Maxim Levitsky <maximlevisky@gmail.com>
Subject: [PATCH 1/6] memstick: core: add series of common helpers.
Date: Thu, 14 Oct 2010 02:40:00 +0200
Message-Id: <1287016805-5175-2-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287016805-5175-1-git-send-email-maximlevitsky@gmail.com>
References: <1287016805-5175-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code is currently unused, but it will be used
in following patches.

Signed-off-by: Maxim Levitsky <maximlevisky@gmail.com>
---
 drivers/memstick/core/memstick.c |  240 ++++++++++++++++++++++++++++++++++++++
 include/linux/memstick.h         |   82 +++++++++++--
 2 files changed, 310 insertions(+), 12 deletions(-)

diff --git a/drivers/memstick/core/memstick.c b/drivers/memstick/core/memstick.c
index c00fe82..4c457ae 100644
--- a/drivers/memstick/core/memstick.c
+++ b/drivers/memstick/core/memstick.c
@@ -362,6 +362,13 @@ static int h_memstick_set_rw_addr(struct memstick_dev *card,
 	}
 }
 
+
+static int h_memstick_default_bad(struct memstick_dev *card,
+				     struct memstick_request **mrq)
+{
+	return -ENXIO;
+}
+
 /**
  * memstick_set_rw_addr - issue SET_RW_REG_ADDR request and wait for it to
  *                        complete
@@ -377,6 +384,239 @@ int memstick_set_rw_addr(struct memstick_dev *card)
 }
 EXPORT_SYMBOL(memstick_set_rw_addr);
 
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
+/**
+ * memstick_complete_req - signal that request is completed
+ * @card - card to use
+ * @mrq - request to use
+ * @error - result of the request
+ *
+ * Card drivers can use that function to signal end of request
+ */
+int memstick_complete_request(struct memstick_dev *card,
+			struct memstick_request *req, int error)
+{
+	if (error)
+		req->error = error;
+
+	card->state = -1;
+	card->int_polling = false;
+	card->next_request = h_memstick_default_bad;
+
+	/* Invalidate reg window on errors */
+	if (req->error)
+		memstick_invalidate_reg_window(card);
+
+	complete(&card->mrq_complete);
+	return -EAGAIN;
+}
+EXPORT_SYMBOL(memstick_complete_request);
+
+/**
+ * memstick_read_int_reg - read INT status from the card
+ * if last request already contains the int flags, will return 0
+ * returns 1 if new request was initialized
+ * Will artifictially return MEMSTICK_INT_CMDNAK if this function was
+ * called more that once in 300 msecs without memstick_finish_int_request
+ * in between
+ * @card - card to use
+ * @req - request to use
+ */
+
+int memstick_read_int_reg(struct memstick_dev *card,
+				struct memstick_request *req, long timeout)
+{
+
+	if (!card->int_polling) {
+		card->int_timeout = jiffies +
+			msecs_to_jiffies(timeout == -1 ? 300 : timeout);
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
+/**
+ * memstick_run_state_machine - runs state machine untill it calls
+ * memstick_complete_request.
+ * Usefull for blocking IO in the card drivers.
+ * @card - card to use
+ * state_func - the state machine
+ */
+int memstick_run_state_machine(struct memstick_dev *card,
+	int   (*state_func)(struct memstick_dev *card,
+					struct memstick_request **mrq))
+{
+	card->next_request = state_func;
+	memstick_new_req(card->host);
+	wait_for_completion(&card->mrq_complete);
+	return card->current_mrq.error;
+}
+EXPORT_SYMBOL(memstick_run_state_machine);
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
+
+/**
+ * memstick_invalidate_reg_window - invalidate the card register
+ * read/write window (start, len)
+ * Use when not certain if card still remembers it
+ */
+void memstick_invalidate_reg_window(struct memstick_dev *card)
+{
+	memset(&card->reg_addr, 0, sizeof(card->reg_addr));
+}
+EXPORT_SYMBOL(memstick_invalidate_reg_window);
+
+
+
 static struct memstick_dev *memstick_alloc_card(struct memstick_host *host)
 {
 	struct memstick_dev *card = kzalloc(sizeof(struct memstick_dev),
diff --git a/include/linux/memstick.h b/include/linux/memstick.h
index 690c35a..c6e4a99 100644
--- a/include/linux/memstick.h
+++ b/include/linux/memstick.h
@@ -45,14 +45,14 @@ struct ms_status_register {
 #define MEMSTICK_STATUS1_DTER 0x20
 #define MEMSTICK_STATUS1_FB1  0x40
 #define MEMSTICK_STATUS1_MB   0x80
-} __attribute__((packed));
+} __packed;
 
 struct ms_id_register {
 	unsigned char type;
 	unsigned char if_mode;
 	unsigned char category;
 	unsigned char class;
-} __attribute__((packed));
+} __packed;
 
 struct ms_param_register {
 	unsigned char system;
@@ -68,7 +68,7 @@ struct ms_param_register {
 #define MEMSTICK_CP_OVERWRITE 0x80
 
 	unsigned char page_address;
-} __attribute__((packed));
+} __packed;
 
 struct ms_extra_data_register {
 	unsigned char  overwrite_flag;
@@ -84,7 +84,7 @@ struct ms_extra_data_register {
 #define MEMSTICK_MANAGEMENT_SCMS0  0x20
 
 	unsigned short logical_address;
-} __attribute__((packed));
+} __packed;
 
 struct ms_register {
 	struct ms_status_register     status;
@@ -92,7 +92,7 @@ struct ms_register {
 	unsigned char                 reserved[8];
 	struct ms_param_register      param;
 	struct ms_extra_data_register extra_data;
-} __attribute__((packed));
+} __packed;
 
 struct mspro_param_register {
 	unsigned char  system;
@@ -103,7 +103,7 @@ struct mspro_param_register {
 	__be16 data_count;
 	__be32 data_address;
 	unsigned char  tpc_param;
-} __attribute__((packed));
+} __packed;
 
 struct mspro_io_info_register {
 	unsigned char version;
@@ -111,20 +111,28 @@ struct mspro_io_info_register {
 	unsigned char current_req;
 	unsigned char card_opt_info;
 	unsigned char rdy_wait_time;
-} __attribute__((packed));
+} __packed;
 
 struct mspro_io_func_register {
 	unsigned char func_enable;
 	unsigned char func_select;
 	unsigned char func_intmask;
 	unsigned char transfer_mode;
-} __attribute__((packed));
+} __packed;
 
 struct mspro_io_cmd_register {
 	unsigned short tpc_param;
 	unsigned short data_count;
 	unsigned int   data_address;
-} __attribute__((packed));
+} __packed;
+
+
+struct mspro_cmdex_argument {
+	unsigned char  command;
+	__be16 data_count;
+	__be32 data_address;
+} __packed;
+
 
 struct mspro_register {
 	struct ms_status_register     status;
@@ -138,14 +146,14 @@ struct mspro_register {
 	struct mspro_io_cmd_register  io_cmd;
 	unsigned char                 io_int;
 	unsigned char                 io_int_func;
-} __attribute__((packed));
+} __packed;
 
 struct ms_register_addr {
 	unsigned char r_offset;
 	unsigned char r_length;
 	unsigned char w_offset;
 	unsigned char w_length;
-} __attribute__((packed));
+} __packed;
 
 enum memstick_tpc {
 	MS_TPC_READ_MG_STATUS   = 0x01,
@@ -236,6 +244,24 @@ struct memstick_device_id {
 #define MEMSTICK_CLASS_WP             0x03
 };
 
+/* IO request that host driver gets from memtick core
+ *
+ * Note about the 'need_card_int' flag:
+
+ * In serial mode that flag _hints_ the host driver to wait till card
+ * raises the INT signal, so that core could spare sending redundant
+ * MS_TPC_GET_INT requests.
+ *
+ * In _parallel_ mode, that flag must be honored,
+ * and besides waiting, the host driver must read the INT register
+ * (via data lines)
+ *
+ * In addition to that if hardware is 'smart', it could be able to read
+ * the INT register even in parallel mode by sending MS_TPC_GET_INT
+ * by itself. This capablility is indicated by host via
+ * MEMSTICK_CAP_AUTO_GET_INT.
+ * Then serial mode behavier must be the same as parallel
+ */
 struct memstick_request {
 	unsigned char tpc;
 	unsigned char data_dir:1,
@@ -247,7 +273,7 @@ struct memstick_request {
 		struct scatterlist sg;
 		struct {
 			unsigned char data_len;
-			unsigned char data[15];
+			unsigned char data[32];
 		};
 	};
 };
@@ -270,6 +296,12 @@ struct memstick_dev {
 	void                     (*start)(struct memstick_dev *card);
 
 	struct device            dev;
+
+	/* Private area for request processing */
+	bool			 int_polling;
+	unsigned long		 int_timeout;
+	int			 state;
+	int			 caps;
 };
 
 struct memstick_host {
@@ -329,6 +361,32 @@ void memstick_new_req(struct memstick_host *host);
 
 int memstick_set_rw_addr(struct memstick_dev *card);
 
+/* Helpers for high level drivers */
+void memstick_allocate_request(struct memstick_dev *card,
+					struct memstick_request **mrq);
+
+int memstick_complete_request(struct memstick_dev *card,
+			struct memstick_request *req, int error);
+
+int memstick_read_int_reg(struct memstick_dev *card,
+					struct memstick_request *req);
+
+void memstick_read_int_reg_cleanup(struct memstick_dev *card);
+
+int memstick_read_regs(struct memstick_dev *card, int offset, int len,
+	struct memstick_request *req);
+
+int memstick_write_regs(struct memstick_dev *card, int offset, int len,
+	char *buf, struct memstick_request *req);
+
+void memstick_invalidate_reg_window(struct memstick_dev *card);
+
+int memstick_run_state_machine(struct memstick_dev *card,
+	int   (*next_request)(struct memstick_dev *card,
+				struct memstick_request **mrq));
+
+const char *memstick_debug_get_tpc_name(int tpc);
+
 static inline void *memstick_priv(struct memstick_host *host)
 {
 	return (void *)host->private;
-- 
1.7.1

