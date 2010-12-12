Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338Ab0LLPx1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 10:53:27 -0500
Received: from hera.kernel.org ([140.211.167.34]:56543 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753111Ab0LLPxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 10:53:21 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 7/9] sungem: update gp->reset_task flushing
Date: Sun, 12 Dec 2010 16:53:03 +0100
Message-Id: <1292169185-10579-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1292169185-10579-1-git-send-email-tj@kernel.org>
References: <1292169185-10579-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 12 Dec 2010 15:53:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gp->reset_task_pending is always set right before reset_task is
scheduled and as there is no synchronization between the setting and
scheduling, busy looping on reset_task_pending before flushing
reset_task doesn't really buy anything.

Directly flush gp->reset_task on suspend and cancel on detach.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
---
 drivers/net/sungem.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/net/sungem.c b/drivers/net/sungem.c
index 4ceb3cf..9e992ca 100644
--- a/drivers/net/sungem.c
+++ b/drivers/net/sungem.c
@@ -2380,10 +2380,8 @@ static int gem_suspend(struct pci_dev *pdev, pm_message_t state)
 	 */
 	mutex_unlock(&gp->pm_mutex);
 
-	/* Wait for a pending reset task to complete */
-	while (gp->reset_task_pending)
-		yield();
-	flush_scheduled_work();
+	/* Wait for the pending reset task to complete */
+	flush_work_sync(&gp->reset_task);
 
 	/* Shut the PHY down eventually and setup WOL */
 	gem_stop_phy(gp, gp->asleep_wol);
@@ -2928,10 +2926,8 @@ static void gem_remove_one(struct pci_dev *pdev)
 		/* We shouldn't need any locking here */
 		gem_get_cell(gp);
 
-		/* Wait for a pending reset task to complete */
-		while (gp->reset_task_pending)
-			yield();
-		flush_scheduled_work();
+		/* Cancel reset task */
+		cancel_work_sync(&gp->reset_task);
 
 		/* Shut the PHY down */
 		gem_stop_phy(gp, 0);
-- 
1.7.1

