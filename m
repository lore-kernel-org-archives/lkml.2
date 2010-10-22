Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756421Ab0JVX4g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 19:56:36 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39325 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755034Ab0JVXyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 19:54:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ro0Zw3oDjfQyqbGU+IcrDEzXJDlwh+A+P+zwt4f9UzpMgdvSVONMvlB7e7CCTr/lPU
         2pA9fdC6dICN/sJcVWAIaZhzGEOm9i7XPkiV4rcOCRWATQ9Vk0qYWP4QLjG5zZLacx3O
         Sk5Ut2NDW0PD/xBrDpmmWFlG0+oIIU3AQFjCk=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Maxim Levitsky <maxim-levitsky@gmail.com>
Subject: [PATCH 24/29] memstick: jmb38x_ms: rework processing of the TPC one after another.
Date: Sat, 23 Oct 2010 01:53:52 +0200
Message-Id: <1287791637-10329-25-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287791637-10329-1-git-send-email-maximlevitsky@gmail.com>
References: <1287791637-10329-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lift some common code.
Also make sure new TPC is always exacuted from a tasklet.
While this decreases IO speed a bit, this makes sure
we won't have large latency.

Signed-off-by: Maxim Levitsky <maxim-levitsky@gmail.com>
---
 drivers/memstick/host/jmb38x_ms.c |   74 ++++++++++++++++++-------------------
 drivers/memstick/host/jmb38x_ms.h |    5 ++-
 2 files changed, 40 insertions(+), 39 deletions(-)

diff --git a/drivers/memstick/host/jmb38x_ms.c b/drivers/memstick/host/jmb38x_ms.c
index 77e4971..16d022e 100644
--- a/drivers/memstick/host/jmb38x_ms.c
+++ b/drivers/memstick/host/jmb38x_ms.c
@@ -263,6 +263,11 @@ static int j38ms_execute_tpc(struct j38ms_host *host)
 	bool is_read = host->req->data_dir == READ;
 	dma_addr_t dma_address;
 
+	if (host->dead) {
+		host->req->error = -ETIME;
+		return 0;
+	}
+
 	if (!(j38ms_read_reg(host, STATUS) & STATUS_HAS_MEDIA)) {
 		dbg(host, "IO: card removed, refusing to send TPC");
 		host->req->error = -ENODEV;
@@ -384,10 +389,9 @@ exec:
 }
 
 /* Cleanups execution of current TPC */
-static void j38ms_complete_tpc(struct memstick_host *msh, int last)
+static void j38ms_complete_tpc(struct memstick_host *msh)
 {
 	struct j38ms_host *host = memstick_priv(msh);
-	int rc;
 	del_timer(&host->timer);
 
 	dbg(host, "IO: TPC complete (error : %d)", host->req->error);
@@ -422,18 +426,6 @@ static void j38ms_complete_tpc(struct memstick_host *msh, int last)
 	}
 
 	j38ms_clear_reg_mask(host, HOST_CONTROL, HOST_CONTROL_LED);
-
-	if (!last) {
-		do {
-			rc = memstick_next_req(msh, &host->req);
-		} while (!rc && j38ms_execute_tpc(host));
-	} else {
-		do {
-			rc = memstick_next_req(msh, &host->req);
-			if (!rc)
-				host->req->error = -ETIME;
-		} while (!rc);
-	}
 }
 
 /* Interrupt handler */
@@ -507,7 +499,8 @@ out:
 
 	if (host->req && (((host->cmd_flags & CMD_READY)
 		&& (host->cmd_flags & FIFO_READY)) || host->req->error)) {
-		j38ms_complete_tpc(msh, 0);
+		j38ms_complete_tpc(msh);
+		tasklet_schedule(&host->tasklet);
 	}
 
 	spin_unlock(&host->lock);
@@ -525,7 +518,8 @@ static void j38ms_irq_timeout(unsigned long data)
 	spin_lock_irqsave(&host->lock, flags);
 	if (host->req) {
 		host->req->error = -ETIME;
-		j38ms_complete_tpc(msh, 0);
+		j38ms_complete_tpc(msh);
+		tasklet_schedule(&host->tasklet);
 	}
 	spin_unlock_irqrestore(&host->lock, flags);
 }
@@ -535,30 +529,29 @@ static void j38ms_submit_tasklet(unsigned long data)
 	struct memstick_host *msh = (struct memstick_host *)data;
 	struct j38ms_host *host = memstick_priv(msh);
 	unsigned long flags;
-	int rc;
 
 	spin_lock_irqsave(&host->lock, flags);
-	if (!host->req) {
-		do {
-			rc = memstick_next_req(msh, &host->req);
-			dev_dbg(&host->chip->pdev->dev, "tasklet req %d\n", rc);
-		} while (!rc && j38ms_execute_tpc(host));
-	}
+	j38ms_next_request(host);
 	spin_unlock_irqrestore(&host->lock, flags);
 }
 
-static void j38ms_dummy_submit(struct memstick_host *msh)
-{
-	return;
-}
-
 static void j38ms_submit_req(struct memstick_host *msh)
 {
 	struct j38ms_host *host = memstick_priv(msh);
 
-	tasklet_schedule(&host->notify);
+	if (!host->req)
+		tasklet_schedule(&host->tasklet);
 }
 
+/* Asks for next request from upper layer and starts its execution */
+static void j38ms_next_request(struct j38ms_host *host)
+{
+	while (!memstick_next_req(host->msh, &host->req))
+		if (!j38ms_execute_tpc(host))
+			return;
+}
+
+
 /* hardware reset */
 static int j38ms_reset(struct j38ms_host *host)
 {
@@ -747,7 +740,6 @@ static int j38ms_count_slots(struct pci_dev *pdev)
 
 		if (256 != pci_resource_len(pdev, cnt))
 			break;
-
 		++rc;
 	}
 	return rc;
@@ -816,6 +808,7 @@ static void j38ms_free_host(struct memstick_host *msh)
 
 	pci_free_consistent(host->chip->pdev, PAGE_SIZE,
 		host->dma_bounce_page, host->dma_bus_address);
+
 	memstick_free_host(msh);
 }
 
@@ -905,21 +898,26 @@ static void j38ms_remove(struct pci_dev *dev)
 
 		host = memstick_priv(jm->hosts[cnt]);
 
-		jm->hosts[cnt]->request = j38ms_dummy_submit;
-		tasklet_kill(&host->notify);
-		writel(0, host->addr + INT_SIGNAL_ENABLE);
-		writel(0, host->addr + INT_STATUS_ENABLE);
-		mmiowb();
-		dev_dbg(&jm->pdev->dev, "interrupts off\n");
+		tasklet_kill(&host->tasklet);
+
 		spin_lock_irqsave(&host->lock, flags);
+		host->dead = true;
+
+		j38ms_write_reg(host, INT_SIGNAL_ENABLE, 0);
+		j38ms_write_reg(host, INT_STATUS_ENABLE, 0);
+
+		mmiowb();
+		dbg(host, "interrupts off");
+
 		if (host->req) {
 			host->req->error = -ETIME;
-			j38ms_complete_tpc(jm->hosts[cnt], 1);
+			j38ms_complete_tpc(jm->hosts[cnt]);
 		}
+
 		spin_unlock_irqrestore(&host->lock, flags);
 
 		memstick_remove_host(jm->hosts[cnt]);
-		dev_dbg(&jm->pdev->dev, "host removed\n");
+		dbg(host, "host removed");
 
 		j38ms_free_host(jm->hosts[cnt]);
 	}
diff --git a/drivers/memstick/host/jmb38x_ms.h b/drivers/memstick/host/jmb38x_ms.h
index 5599803..5d7ad18 100644
--- a/drivers/memstick/host/jmb38x_ms.h
+++ b/drivers/memstick/host/jmb38x_ms.h
@@ -146,8 +146,9 @@ struct j38ms_host {
 	struct j38ms            *chip;
 	struct memstick_host    *msh;
 	void __iomem            *addr;
+	bool			dead;
 	spinlock_t              lock;
-	struct tasklet_struct   notify;
+	struct tasklet_struct   tasklet;
 	int                     id;
 	char                    host_id[32];
 	int                     irq;
@@ -196,3 +197,5 @@ enum {
 #define dbg(host, format, ...)		__dbg(host, 1, format, ## __VA_ARGS__)
 #define dbg_v(host, format, ...)	__dbg(host, 2, format, ## __VA_ARGS__)
 #define dbg_reg(host, format, ...)	__dbg(host, 3, format, ## __VA_ARGS__)
+
+static void j38ms_next_request(struct j38ms_host *host);
-- 
1.7.1

