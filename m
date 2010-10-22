Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868Ab0JWAAh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 20:00:37 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39325 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934Ab0JVXyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 19:54:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Rp4dyR9VLiC6O+8NTSWrZETN8AhD3jmou5dNAlzGRbS+QLHZQf+779qAUn8eyBIC4D
         /30ViULH+ffqMiScZdMYBTSiM9jAWJRioLze/fTd/Bf25SRDg25jVX1iLseA1knjJWnJ
         z41V0XccUTnia7DKY+Q1PjE/0lJrD7cGB3KX0=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 02/29] memstick: core: reorder functions This patch just reorders functions in memstick.c So that host specific and card driver specific functions are now grouped together. This makes it easier to understand the code.
Date: Sat, 23 Oct 2010 01:53:30 +0200
Message-Id: <1287791637-10329-3-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287791637-10329-1-git-send-email-maximlevitsky@gmail.com>
References: <1287791637-10329-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/memstick/core/memstick.c |  293 ++++++++++++++++++++------------------
 include/linux/memstick.h         |   44 ++++---
 2 files changed, 184 insertions(+), 153 deletions(-)

diff --git a/drivers/memstick/core/memstick.c b/drivers/memstick/core/memstick.c
index c00fe82..5a501a4 100644
--- a/drivers/memstick/core/memstick.c
+++ b/drivers/memstick/core/memstick.c
@@ -202,119 +202,6 @@ static int memstick_dummy_check(struct memstick_dev *card)
 	return 0;
 }
 
-/**
- * memstick_detect_change - schedule media detection on memstick host
- * @host - host to use
- */
-void memstick_detect_change(struct memstick_host *host)
-{
-	queue_work(workqueue, &host->media_checker);
-}
-EXPORT_SYMBOL(memstick_detect_change);
-
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
-{
-	int rc = -ENXIO;
-
-	if ((*mrq) && (*mrq)->error && host->retries) {
-		(*mrq)->error = rc;
-		host->retries--;
-		return 0;
-	}
-
-	if (host->card && host->card->next_request)
-		rc = host->card->next_request(host->card, mrq);
-
-	if (!rc)
-		host->retries = cmd_retries > 1 ? cmd_retries - 1 : 1;
-	else
-		*mrq = NULL;
-
-	return rc;
-}
-EXPORT_SYMBOL(memstick_next_req);
-
-/**
- * memstick_new_req - notify the host that some requests are pending
- * @host - host to use
- */
-void memstick_new_req(struct memstick_host *host)
-{
-	if (host->card) {
-		host->retries = cmd_retries;
-		INIT_COMPLETION(host->card->mrq_complete);
-		host->request(host);
-	}
-}
-EXPORT_SYMBOL(memstick_new_req);
-
-/**
- * memstick_init_req_sg - set request fields needed for bulk data transfer
- * @mrq - request to use
- * @tpc - memstick Transport Protocol Command
- * @sg - TPC argument
- */
-void memstick_init_req_sg(struct memstick_request *mrq, unsigned char tpc,
-			  const struct scatterlist *sg)
-{
-	mrq->tpc = tpc;
-	if (tpc & 8)
-		mrq->data_dir = WRITE;
-	else
-		mrq->data_dir = READ;
-
-	mrq->sg = *sg;
-	mrq->long_data = 1;
-
-	if (tpc == MS_TPC_SET_CMD || tpc == MS_TPC_EX_SET_CMD)
-		mrq->need_card_int = 1;
-	else
-		mrq->need_card_int = 0;
-}
-EXPORT_SYMBOL(memstick_init_req_sg);
-
-/**
- * memstick_init_req - set request fields needed for short data transfer
- * @mrq - request to use
- * @tpc - memstick Transport Protocol Command
- * @buf - TPC argument buffer
- * @length - TPC argument size
- *
- * The intended use of this function (transfer of data items several bytes
- * in size) allows us to just copy the value between request structure and
- * user supplied buffer.
- */
-void memstick_init_req(struct memstick_request *mrq, unsigned char tpc,
-		       const void *buf, size_t length)
-{
-	mrq->tpc = tpc;
-	if (tpc & 8)
-		mrq->data_dir = WRITE;
-	else
-		mrq->data_dir = READ;
-
-	mrq->data_len = length > sizeof(mrq->data) ? sizeof(mrq->data) : length;
-	if (mrq->data_dir == WRITE)
-		memcpy(mrq->data, buf, mrq->data_len);
-
-	mrq->long_data = 0;
-
-	if (tpc == MS_TPC_SET_CMD || tpc == MS_TPC_EX_SET_CMD)
-		mrq->need_card_int = 1;
-	else
-		mrq->need_card_int = 0;
-}
-EXPORT_SYMBOL(memstick_init_req);
 
 /*
  * Functions prefixed with "h_" are protocol callbacks. They can be called from
@@ -362,20 +249,6 @@ static int h_memstick_set_rw_addr(struct memstick_dev *card,
 	}
 }
 
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
 
 static struct memstick_dev *memstick_alloc_card(struct memstick_host *host)
 {
@@ -418,7 +291,7 @@ err_out:
 	return NULL;
 }
 
-static int memstick_power_on(struct memstick_host *host)
+int memstick_power_on(struct memstick_host *host)
 {
 	int rc = host->set_param(host, MEMSTICK_POWER, MEMSTICK_POWER_ON);
 
@@ -480,6 +353,125 @@ out_power_off:
 	dev_dbg(&host->dev, "memstick_check finished\n");
 }
 
+/*** card driver interface ***/
+
+/**
+  * memstick_register_driver - Register new card driver
+  * @drv - the driver descriptior
+  */
+
+int memstick_register_driver(struct memstick_driver *drv)
+{
+	drv->driver.bus = &memstick_bus_type;
+
+	return driver_register(&drv->driver);
+}
+EXPORT_SYMBOL(memstick_register_driver);
+
+/**
+  * memstick_unregister_driver - deregister new card driver
+  * @drv - the driver descriptior
+  */
+
+void memstick_unregister_driver(struct memstick_driver *drv)
+{
+	driver_unregister(&drv->driver);
+}
+EXPORT_SYMBOL(memstick_unregister_driver);
+
+
+/**
+ * memstick_set_rw_addr - issue SET_RW_REG_ADDR request and wait for it to
+ *                        complete
+ * @card - media device to use
+ */
+int memstick_set_rw_addr(struct memstick_dev *card)
+{
+	card->next_request = h_memstick_set_rw_addr;
+	memstick_new_req(card->host);
+	wait_for_completion(&card->mrq_complete);
+
+	return card->current_mrq.error;
+}
+EXPORT_SYMBOL(memstick_set_rw_addr);
+
+
+
+
+/**
+ * memstick_new_req - notify the host that some requests are pending
+ * @host - host to use
+ */
+void memstick_new_req(struct memstick_host *host)
+{
+	if (host->card) {
+		host->retries = cmd_retries;
+		INIT_COMPLETION(host->card->mrq_complete);
+		host->request(host);
+	}
+}
+EXPORT_SYMBOL(memstick_new_req);
+
+/**
+ * memstick_init_req_sg - set request fields needed for bulk data transfer
+ * @mrq - request to use
+ * @tpc - memstick Transport Protocol Command
+ * @sg - TPC argument
+ */
+void memstick_init_req_sg(struct memstick_request *mrq, unsigned char tpc,
+			  const struct scatterlist *sg)
+{
+	mrq->tpc = tpc;
+	if (tpc & 8)
+		mrq->data_dir = WRITE;
+	else
+		mrq->data_dir = READ;
+
+	mrq->sg = *sg;
+	mrq->long_data = 1;
+
+	if (tpc == MS_TPC_SET_CMD || tpc == MS_TPC_EX_SET_CMD)
+		mrq->need_card_int = 1;
+	else
+		mrq->need_card_int = 0;
+}
+EXPORT_SYMBOL(memstick_init_req_sg);
+
+/**
+ * memstick_init_req - set request fields needed for short data transfer
+ * @mrq - request to use
+ * @tpc - memstick Transport Protocol Command
+ * @buf - TPC argument buffer
+ * @length - TPC argument size
+ *
+ * The intended use of this function (transfer of data items several bytes
+ * in size) allows us to just copy the value between request structure and
+ * user supplied buffer.
+ */
+void memstick_init_req(struct memstick_request *mrq, unsigned char tpc,
+		       const void *buf, size_t length)
+{
+	mrq->tpc = tpc;
+	if (tpc & 8)
+		mrq->data_dir = WRITE;
+	else
+		mrq->data_dir = READ;
+
+	mrq->data_len = length > sizeof(mrq->data) ? sizeof(mrq->data) : length;
+	if (mrq->data_dir == WRITE)
+		memcpy(mrq->data, buf, mrq->data_len);
+
+	mrq->long_data = 0;
+
+	if (tpc == MS_TPC_SET_CMD || tpc == MS_TPC_EX_SET_CMD)
+		mrq->need_card_int = 1;
+	else
+		mrq->need_card_int = 0;
+}
+EXPORT_SYMBOL(memstick_init_req);
+
+/*** low level (host) driver interface ***/
+
 /**
  * memstick_alloc_host - allocate a memstick_host structure
  * @extra: size of the user private data to allocate
@@ -597,19 +589,48 @@ void memstick_resume_host(struct memstick_host *host)
 }
 EXPORT_SYMBOL(memstick_resume_host);
 
-int memstick_register_driver(struct memstick_driver *drv)
-{
-	drv->driver.bus = &memstick_bus_type;
 
-	return driver_register(&drv->driver);
+/**
+ * memstick_detect_change - schedule media detection on memstick host
+ * @host - host to use
+ */
+void memstick_detect_change(struct memstick_host *host)
+{
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
+	int rc = -ENXIO;
+
+	if ((*mrq) && (*mrq)->error && host->retries) {
+		(*mrq)->error = rc;
+		host->retries--;
+		return 0;
+	}
+
+	if (host->card && host->card->next_request)
+		rc = host->card->next_request(host->card, mrq);
+
+	if (!rc)
+		host->retries = cmd_retries > 1 ? cmd_retries - 1 : 1;
+	else
+		*mrq = NULL;
+
+	return rc;
 }
-EXPORT_SYMBOL(memstick_unregister_driver);
+EXPORT_SYMBOL(memstick_next_req);
 
 
 static int __init memstick_init(void)
diff --git a/include/linux/memstick.h b/include/linux/memstick.h
index 5479f7d..428c4a1 100644
--- a/include/linux/memstick.h
+++ b/include/linux/memstick.h
@@ -332,42 +332,52 @@ struct memstick_driver {
 	struct device_driver      driver;
 };
 
+/* interface  for high-level (card) drivers */
+
+static inline void *memstick_get_drvdata(struct memstick_dev *card)
+{
+	return dev_get_drvdata(&card->dev);
+}
+
+static inline void memstick_set_drvdata(struct memstick_dev *card, void *data)
+{
+	dev_set_drvdata(&card->dev, data);
+}
+
 int memstick_register_driver(struct memstick_driver *drv);
 void memstick_unregister_driver(struct memstick_driver *drv);
 
+int memstick_set_rw_addr(struct memstick_dev *card);
+
+void memstick_new_req(struct memstick_host *host);
+
+void memstick_init_req_sg(struct memstick_request *mrq, unsigned char tpc,
+			  const struct scatterlist *sg);
+void memstick_init_req(struct memstick_request *mrq, unsigned char tpc,
+		       const void *buf, size_t length);
+
+/* Interface for low-level (host) drivers */
+
 struct memstick_host *memstick_alloc_host(unsigned int extra,
 					  struct device *dev);
 
 int memstick_add_host(struct memstick_host *host);
 void memstick_remove_host(struct memstick_host *host);
 void memstick_free_host(struct memstick_host *host);
-void memstick_detect_change(struct memstick_host *host);
+
+
 void memstick_suspend_host(struct memstick_host *host);
 void memstick_resume_host(struct memstick_host *host);
 
-void memstick_init_req_sg(struct memstick_request *mrq, unsigned char tpc,
-			  const struct scatterlist *sg);
-void memstick_init_req(struct memstick_request *mrq, unsigned char tpc,
-		       const void *buf, size_t length);
+void memstick_detect_change(struct memstick_host *host);
+
 int memstick_next_req(struct memstick_host *host,
 		      struct memstick_request **mrq);
-void memstick_new_req(struct memstick_host *host);
 
-int memstick_set_rw_addr(struct memstick_dev *card);
 
 static inline void *memstick_priv(struct memstick_host *host)
 {
 	return (void *)host->private;
 }
 
-static inline void *memstick_get_drvdata(struct memstick_dev *card)
-{
-	return dev_get_drvdata(&card->dev);
-}
-
-static inline void memstick_set_drvdata(struct memstick_dev *card, void *data)
-{
-	dev_set_drvdata(&card->dev, data);
-}
-
 #endif
-- 
1.7.1

