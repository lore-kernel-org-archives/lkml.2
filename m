Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235Ab1ACNub (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 08:50:31 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60593 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755103Ab1ACNu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 08:50:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=BHXKAd2UHv1ZlxgrRDASsJUPiziwzAguEbUJhidzfbLqWAY0/bSJNB32IrawFni065
         lxvr0dx08BMJi7GuXTCGx2m5pks/qjliW3ShOg+VDUzxiwAcQxnnp1FdaEGBxkXQPOUz
         kJehRVoKfg1Bc9xt2aQva/di5+1i2j7WSo/XY=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 13/32] misc/iwmc3200top: use system_wq instead of dedicated workqueues
Date: Mon,  3 Jan 2011 14:49:36 +0100
Message-Id: <1294062595-30097-14-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1294062595-30097-1-git-send-email-tj@kernel.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With cmwq, there's no reason to use separate workqueues in
iwmc3200top.  Drop them and use system_wq instead.  The used work
items are sync flushed before driver detach.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Tomas Winkler <tomas.winkler@intel.com>
---
Only compile tested.  Please feel free to take it into the subsystem
tree or simply ack - I'll route it through the wq tree.

Thanks.

 drivers/misc/iwmc3200top/iwmc3200top.h |    4 +---
 drivers/misc/iwmc3200top/main.c        |   14 +++++---------
 2 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/misc/iwmc3200top/iwmc3200top.h b/drivers/misc/iwmc3200top/iwmc3200top.h
index 740ff07..620973e 100644
--- a/drivers/misc/iwmc3200top/iwmc3200top.h
+++ b/drivers/misc/iwmc3200top/iwmc3200top.h
@@ -183,9 +183,7 @@ struct iwmct_priv {
 	u32 barker;
 	struct iwmct_dbg dbg;
 
-	/* drivers work queue */
-	struct workqueue_struct *wq;
-	struct workqueue_struct *bus_rescan_wq;
+	/* drivers work items */
 	struct work_struct bus_rescan_worker;
 	struct work_struct isr_worker;
 
diff --git a/drivers/misc/iwmc3200top/main.c b/drivers/misc/iwmc3200top/main.c
index c73cef2..727af07 100644
--- a/drivers/misc/iwmc3200top/main.c
+++ b/drivers/misc/iwmc3200top/main.c
@@ -89,7 +89,7 @@ static void op_top_message(struct iwmct_priv *priv, struct top_msg *msg)
 	switch (msg->hdr.opcode) {
 	case OP_OPR_ALIVE:
 		LOG_INFO(priv, FW_MSG, "Got ALIVE from device, wake rescan\n");
-		queue_work(priv->bus_rescan_wq, &priv->bus_rescan_worker);
+		schedule_work(&priv->bus_rescan_worker);
 		break;
 	default:
 		LOG_INFO(priv, FW_MSG, "Received msg opcode 0x%X\n",
@@ -360,7 +360,7 @@ static void iwmct_irq(struct sdio_func *func)
 	/* clear the function's interrupt request bit (write 1 to clear) */
 	sdio_writeb(func, 1, IWMC_SDIO_INTR_CLEAR_ADDR, &ret);
 
-	queue_work(priv->wq, &priv->isr_worker);
+	schedule_work(&priv->isr_worker);
 
 	LOG_TRACE(priv, IRQ, "exit iwmct_irq\n");
 
@@ -506,10 +506,6 @@ static int iwmct_probe(struct sdio_func *func,
 	priv->func = func;
 	sdio_set_drvdata(func, priv);
 
-
-	/* create drivers work queue */
-	priv->wq = create_workqueue(DRV_NAME "_wq");
-	priv->bus_rescan_wq = create_workqueue(DRV_NAME "_rescan_wq");
 	INIT_WORK(&priv->bus_rescan_worker, iwmct_rescan_worker);
 	INIT_WORK(&priv->isr_worker, iwmct_irq_read_worker);
 
@@ -604,9 +600,9 @@ static void iwmct_remove(struct sdio_func *func)
 	sdio_release_irq(func);
 	sdio_release_host(func);
 
-	/* Safely destroy osc workqueue */
-	destroy_workqueue(priv->bus_rescan_wq);
-	destroy_workqueue(priv->wq);
+	/* Make sure works are finished */
+	flush_work_sync(&priv->bus_rescan_worker);
+	flush_work_sync(&priv->isr_worker);
 
 	sdio_claim_host(func);
 	sdio_disable_func(func);
-- 
1.7.1

