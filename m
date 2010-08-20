Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab0HTAP3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 20:15:29 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35954 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468Ab0HTAPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 20:15:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=nyIoEX+kjnuhI/IdXNKd7K0Xc03vcZF5zp9TyzWp83hchYuZzQMk1KmfSE8dCl9NuN
         VqawEO0okIkM3EKogDkywVdwLArWejhSOFYEVdmAHXDetxd0dkRokb2LBM56qjwCfCK6
         adEW08v3uyj0zSqYBR2GwNlDpba5qmNSYPyZk=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Maxim Levitsky <maximlevisky@gmail.com>
Subject: [PATCH 1/3] memstick: add few common helpers
Date: Fri, 20 Aug 2010 03:15:03 +0300
Message-Id: <1282263305-4048-2-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282263305-4048-1-git-send-email-maximlevitsky@gmail.com>
References: <1282263305-4048-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I add here few helpers that should make memstick
block driver a bit simplier.
Currently only my forthcoming ms_block.c will use them,
but I plan to make mspro_blk use them too.

Signed-off-by: Maxim Levitsky <maximlevisky@gmail.com>
---
 drivers/memstick/core/memstick.c |  109 ++++++++++++++++++++++++++++++++++++++
 include/linux/memstick.h         |   22 +++++++-
 2 files changed, 130 insertions(+), 1 deletions(-)

diff --git a/drivers/memstick/core/memstick.c b/drivers/memstick/core/memstick.c
index c00fe82..1734ea3 100644
--- a/drivers/memstick/core/memstick.c
+++ b/drivers/memstick/core/memstick.c
@@ -362,6 +362,13 @@ static int h_memstick_set_rw_addr(struct memstick_dev *card,
 	}
 }
 
+
+static int h_mspro_block_default_bad(struct memstick_dev *card,
+				     struct memstick_request **mrq)
+{
+	return -ENXIO;
+}
+
 /**
  * memstick_set_rw_addr - issue SET_RW_REG_ADDR request and wait for it to
  *                        complete
@@ -377,6 +384,108 @@ int memstick_set_rw_addr(struct memstick_dev *card)
 }
 EXPORT_SYMBOL(memstick_set_rw_addr);
 
+
+/**
+ * memstick_fetch_request - initialize new request to use by request handler
+ * @card - card to use
+ * @mrq - request to initialize
+ */
+void memstick_fetch_request(struct memstick_dev *card,
+					struct memstick_request **mrq)
+{
+	if (*mrq == NULL) {
+		*mrq = &card->current_mrq;
+		(*mrq)->error = 0;
+		card->state = 0;
+	}
+}
+EXPORT_SYMBOL(memstick_fetch_request);
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
+	card->next_request = h_mspro_block_default_bad;
+	complete(&card->mrq_complete);
+	return -EAGAIN;
+}
+EXPORT_SYMBOL(memstick_complete_request);
+
+/**
+ * ms_send_int_request - optionaly init new MS_TPC_GET_INT.
+ * if last request already contains the int flags, reuse them
+ * returns 1 if new request was initialized
+ * Will artifictially return MEMSTICK_INT_CMDNAK if this function was
+ * called more that once in 300 msecs without memstick_finish_int_request
+ * in between
+ * @card - card to use
+ * @mrq - request to use
+ */
+
+int memstick_send_int_request(struct memstick_dev *card,
+					struct memstick_request *req)
+{
+	if (!card->int_polling) {
+		card->int_poll_start_time = jiffies;
+		card->int_polling = true;
+	} else if (time_after(jiffies,
+			card->int_poll_start_time + msecs_to_jiffies(300))) {
+		req->data[0] |= MEMSTICK_INT_CMDNAK;
+		return 0;
+	}
+
+	if ((card->caps & MEMSTICK_CAP_AUTO_GET_INT) && req->need_card_int) {
+		BUG_ON(req->error);
+		req->data[0] = req->int_reg;
+		req->need_card_int = 0;
+		return 0;
+	} else {
+		memstick_init_req(req, MS_TPC_GET_INT, NULL, 1);
+		return 1;
+	}
+}
+EXPORT_SYMBOL(memstick_send_int_request);
+
+/**
+ * Signal success of int polling, and cancel timeout
+ * Use this if you use memstick_send_int_request
+ * @card - card to use
+ */
+void memstick_finish_int_request(struct memstick_dev *card)
+{
+	card->int_polling = false;
+}
+EXPORT_SYMBOL(memstick_finish_int_request);
+
+/**
+ * memstick_do_request_handler - runs state machine untill it finishes
+ * helper to be used in card drivers
+ * @card - card to use
+ * next_request - the state machine
+ */
+int memstick_do_request_handler(struct memstick_dev *card,
+	int   (*next_request)(struct memstick_dev *card,
+					struct memstick_request **mrq))
+{
+	card->next_request = next_request;
+	memstick_new_req(card->host);
+	wait_for_completion(&card->mrq_complete);
+	return card->current_mrq.error;
+}
+EXPORT_SYMBOL(memstick_do_request_handler);
+
+
 static struct memstick_dev *memstick_alloc_card(struct memstick_host *host)
 {
 	struct memstick_dev *card = kzalloc(sizeof(struct memstick_dev),
diff --git a/include/linux/memstick.h b/include/linux/memstick.h
index 690c35a..3bbdb77 100644
--- a/include/linux/memstick.h
+++ b/include/linux/memstick.h
@@ -247,7 +247,7 @@ struct memstick_request {
 		struct scatterlist sg;
 		struct {
 			unsigned char data_len;
-			unsigned char data[15];
+			unsigned char data[32];
 		};
 	};
 };
@@ -270,6 +270,12 @@ struct memstick_dev {
 	void                     (*start)(struct memstick_dev *card);
 
 	struct device            dev;
+
+	/* Private area for request processing */
+	bool			 int_polling;
+	unsigned long		 int_poll_start_time;
+	int			 state;
+	int			 caps;
 };
 
 struct memstick_host {
@@ -329,6 +335,20 @@ void memstick_new_req(struct memstick_host *host);
 
 int memstick_set_rw_addr(struct memstick_dev *card);
 
+void memstick_fetch_request(struct memstick_dev *card,
+					struct memstick_request **mrq);
+int memstick_complete_request(struct memstick_dev *card,
+			struct memstick_request *req, int error);
+
+int memstick_send_int_request(struct memstick_dev *card,
+					struct memstick_request *req);
+
+void memstick_finish_int_request(struct memstick_dev *card);
+
+int memstick_do_request_handler(struct memstick_dev *card,
+	int   (*next_request)(struct memstick_dev *card,
+				struct memstick_request **mrq));
+
 static inline void *memstick_priv(struct memstick_host *host)
 {
 	return (void *)host->private;
-- 
1.7.0.4

