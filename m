Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231Ab0JVXzD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 19:55:03 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60658 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756165Ab0JVXy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 19:54:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=YsFezc//flH1C2nS4IFo0/iCZl4V2RtEsglwIjR94dFjgnPS0K0FWqNCzrihCLGqmQ
         t797DukTxKPCUBjIsR4hUMLE1nriuS/mBvy+iMKXQyRBmR2G/JUJe8BhW1YXzYoPDBCk
         F5yv8lAbvAaTpdziJLCgRNf3sTvS1L01QtrmY=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 25/29] memstick: jmb38x_ms: pass j38ms_host to few functions instead of memstick_host
Date: Sat, 23 Oct 2010 01:53:53 +0200
Message-Id: <1287791637-10329-26-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287791637-10329-1-git-send-email-maximlevitsky@gmail.com>
References: <1287791637-10329-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just for consistency

Signed-off-by: Maxim Levitsky<maximlevitsky@gmail.com>
---
 drivers/memstick/host/jmb38x_ms.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/memstick/host/jmb38x_ms.c b/drivers/memstick/host/jmb38x_ms.c
index 16d022e..725b485 100644
--- a/drivers/memstick/host/jmb38x_ms.c
+++ b/drivers/memstick/host/jmb38x_ms.c
@@ -510,24 +510,24 @@ out:
 /* Timer that is executed in absense of the interrupt */
 static void j38ms_irq_timeout(unsigned long data)
 {
-	struct memstick_host *msh = (struct memstick_host *)data;
-	struct j38ms_host *host = memstick_priv(msh);
+	struct j38ms_host *host = (struct j38ms_host *)data;
 	unsigned long flags;
 
-	dev_dbg(&host->chip->pdev->dev, "abort\n");
+	dbg(host, "interrupt timeout");
+
 	spin_lock_irqsave(&host->lock, flags);
 	if (host->req) {
 		host->req->error = -ETIME;
-		j38ms_complete_tpc(msh);
+		j38ms_complete_tpc(host->msh);
 		tasklet_schedule(&host->tasklet);
 	}
+
 	spin_unlock_irqrestore(&host->lock, flags);
 }
 
 static void j38ms_submit_tasklet(unsigned long data)
 {
-	struct memstick_host *msh = (struct memstick_host *)data;
-	struct j38ms_host *host = memstick_priv(msh);
+	struct j38ms_host *host = (struct j38ms_host *)data;
 	unsigned long flags;
 
 	spin_lock_irqsave(&host->lock, flags);
@@ -768,15 +768,15 @@ static struct memstick_host *j38ms_alloc_host(struct j38ms *jm, int cnt)
 	snprintf(host->host_id, sizeof(host->host_id), DRIVER_NAME ":slot%d",
 		 host->id);
 	host->irq = jm->pdev->irq;
-	host->timeout_jiffies = msecs_to_jiffies(1000);
 
-	tasklet_init(&host->notify, j38ms_submit_tasklet, (unsigned long)msh);
 	msh->request = j38ms_submit_req;
 	msh->set_param = j38ms_set_param;
 
 	msh->caps = MEMSTICK_CAP_PAR4 | MEMSTICK_CAP_PAR8;
 
-	setup_timer(&host->timer, j38ms_irq_timeout, (unsigned long)msh);
+	host->timeout_jiffies = msecs_to_jiffies(1000);
+	setup_timer(&host->timer, j38ms_irq_timeout, (unsigned long)host);
+	tasklet_init(&host->tasklet, j38ms_submit_tasklet, (unsigned long)host);
 
 	host->dma_bounce_page = pci_alloc_consistent(
 				jm->pdev, PAGE_SIZE, &host->dma_bus_address);
-- 
1.7.1

