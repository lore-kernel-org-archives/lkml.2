Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881Ab2LVCAm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 21:00:42 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:41256 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab2LVB6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 20:58:35 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 19/25] net/caif: don't use [delayed_]work_pending()
Date: Fri, 21 Dec 2012 17:57:09 -0800
Message-Id: <1356141435-17340-20-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1356141435-17340-1-git-send-email-tj@kernel.org>
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need to test whether a (delayed) work item in pending
before queueing, flushing or cancelling it.  Most uses are unnecessary
and quite a few of them are buggy.

Remove unnecessary pending tests from caif.  Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
Please let me know how this patch should be routed.  I can take it
through the workqueue tree if necessary.

Thanks.

 drivers/net/caif/caif_shmcore.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/net/caif/caif_shmcore.c b/drivers/net/caif/caif_shmcore.c
index bc497d7..16bd654 100644
--- a/drivers/net/caif/caif_shmcore.c
+++ b/drivers/net/caif/caif_shmcore.c
@@ -183,9 +183,7 @@ int caif_shmdrv_rx_cb(u32 mbx_msg, void *priv)
 		spin_unlock_irqrestore(&pshm_drv->lock, flags);
 
 		/* Schedule RX work queue. */
-		if (!work_pending(&pshm_drv->shm_rx_work))
-			queue_work(pshm_drv->pshm_rx_workqueue,
-						&pshm_drv->shm_rx_work);
+		queue_work(pshm_drv->pshm_rx_workqueue, &pshm_drv->shm_rx_work);
 	}
 
 	/* Check for emptied buffers. */
@@ -246,9 +244,8 @@ int caif_shmdrv_rx_cb(u32 mbx_msg, void *priv)
 
 
 			/* Schedule the work queue. if required */
-			if (!work_pending(&pshm_drv->shm_tx_work))
-				queue_work(pshm_drv->pshm_tx_workqueue,
-							&pshm_drv->shm_tx_work);
+			queue_work(pshm_drv->pshm_tx_workqueue,
+				   &pshm_drv->shm_tx_work);
 		} else
 			spin_unlock_irqrestore(&pshm_drv->lock, flags);
 	}
@@ -374,8 +371,7 @@ static void shm_rx_work_func(struct work_struct *rx_work)
 	}
 
 	/* Schedule the work queue. if required */
-	if (!work_pending(&pshm_drv->shm_tx_work))
-		queue_work(pshm_drv->pshm_tx_workqueue, &pshm_drv->shm_tx_work);
+	queue_work(pshm_drv->pshm_tx_workqueue, &pshm_drv->shm_tx_work);
 
 }
 
@@ -528,8 +524,7 @@ static int shm_netdev_tx(struct sk_buff *skb, struct net_device *shm_netdev)
 	skb_queue_tail(&pshm_drv->sk_qhead, skb);
 
 	/* Schedule Tx work queue. for deferred processing of skbs*/
-	if (!work_pending(&pshm_drv->shm_tx_work))
-		queue_work(pshm_drv->pshm_tx_workqueue, &pshm_drv->shm_tx_work);
+	queue_work(pshm_drv->pshm_tx_workqueue, &pshm_drv->shm_tx_work);
 
 	return 0;
 }
-- 
1.8.0.2

