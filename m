Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab1ACNun (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 08:50:43 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36659 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755103Ab1ACNud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 08:50:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=mmiujMRKet+iy6X1FOyin2T+1045HuH3YOtqtFmBnzcuueNjSjUIUXRb5zSFT5r/8o
         2iOAcrNJA0kOxnMIOCmyzPvT0qBWvkj78edBaUVwlYMfnac54TeihtAAz0QBHl4SPwj9
         OVUXkCQUEeCN1hiTxnBM9YYgqgrlRejg4+7dM=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Dan Williams <dcbw@redhat.com>,
        libertas-dev@lists.infradead.org
Subject: [PATCH 15/32] wireless/libertas[_tf]: use system_wq instead of dedicated workqueues
Date: Mon,  3 Jan 2011 14:49:38 +0100
Message-Id: <1294062595-30097-16-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1294062595-30097-1-git-send-email-tj@kernel.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With cmwq, there's no reason to use separate workqueues in
libertas[_tf] drivers.  Drop them and use system_wq instead.  All used
work items are sync flushed/canceled on driver detach.

Cc: Dan Williams <dcbw@redhat.com>
Cc: libertas-dev@lists.infradead.org
---
Only compile tested.  Please feel free to take it into the subsystem
tree or simply ack - I'll route it through the wq tree.

Thanks.

 drivers/net/wireless/libertas/if_sdio.c        |   10 +++-------
 drivers/net/wireless/libertas_tf/cmd.c         |    6 +++---
 drivers/net/wireless/libertas_tf/libertas_tf.h |    2 --
 drivers/net/wireless/libertas_tf/main.c        |   16 ++++------------
 4 files changed, 10 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
index b4de0ca..257f664 100644
--- a/drivers/net/wireless/libertas/if_sdio.c
+++ b/drivers/net/wireless/libertas/if_sdio.c
@@ -129,7 +129,6 @@ struct if_sdio_card {
 	spinlock_t		lock;
 	struct if_sdio_packet	*packets;
 
-	struct workqueue_struct	*workqueue;
 	struct work_struct	packet_worker;
 
 	u8			rx_unit;
@@ -828,7 +827,7 @@ static int if_sdio_host_to_card(struct lbs_private *priv,
 
 	spin_unlock_irqrestore(&card->lock, flags);
 
-	queue_work(card->workqueue, &card->packet_worker);
+	schedule_work(&card->packet_worker);
 
 	ret = 0;
 
@@ -986,7 +985,6 @@ static int if_sdio_probe(struct sdio_func *func,
 	}
 
 	spin_lock_init(&card->lock);
-	card->workqueue = create_workqueue("libertas_sdio");
 	INIT_WORK(&card->packet_worker, if_sdio_host_to_card_worker);
 
 	/* Check if we support this card */
@@ -1114,7 +1112,7 @@ out:
 	return ret;
 
 err_activate_card:
-	flush_workqueue(card->workqueue);
+	flush_work_sync(&card->packet_worker);
 	lbs_remove_card(priv);
 reclaim:
 	sdio_claim_host(func);
@@ -1125,7 +1123,6 @@ disable:
 release:
 	sdio_release_host(func);
 free:
-	destroy_workqueue(card->workqueue);
 	while (card->packets) {
 		packet = card->packets;
 		card->packets = card->packets->next;
@@ -1171,8 +1168,7 @@ static void if_sdio_remove(struct sdio_func *func)
 	lbs_stop_card(card->priv);
 	lbs_remove_card(card->priv);
 
-	flush_workqueue(card->workqueue);
-	destroy_workqueue(card->workqueue);
+	flush_work_sync(&card->packet_worker);
 
 	sdio_claim_host(func);
 	sdio_release_irq(func);
diff --git a/drivers/net/wireless/libertas_tf/cmd.c b/drivers/net/wireless/libertas_tf/cmd.c
index 8945afd..c429e02 100644
--- a/drivers/net/wireless/libertas_tf/cmd.c
+++ b/drivers/net/wireless/libertas_tf/cmd.c
@@ -623,7 +623,7 @@ static struct cmd_ctrl_node *__lbtf_cmd_async(struct lbtf_private *priv,
 		lbtf_deb_host("PREP_CMD: cmdnode is NULL\n");
 
 		/* Wake up main thread to execute next command */
-		queue_work(lbtf_wq, &priv->cmd_work);
+		schedule_work(&priv->cmd_work);
 		cmdnode = ERR_PTR(-ENOBUFS);
 		goto done;
 	}
@@ -645,7 +645,7 @@ static struct cmd_ctrl_node *__lbtf_cmd_async(struct lbtf_private *priv,
 
 	cmdnode->cmdwaitqwoken = 0;
 	lbtf_queue_cmd(priv, cmdnode);
-	queue_work(lbtf_wq, &priv->cmd_work);
+	schedule_work(&priv->cmd_work);
 
  done:
 	lbtf_deb_leave_args(LBTF_DEB_HOST, "ret %p", cmdnode);
@@ -707,7 +707,7 @@ EXPORT_SYMBOL_GPL(__lbtf_cmd);
 void lbtf_cmd_response_rx(struct lbtf_private *priv)
 {
 	priv->cmd_response_rxed = 1;
-	queue_work(lbtf_wq, &priv->cmd_work);
+	schedule_work(&priv->cmd_work);
 }
 EXPORT_SYMBOL_GPL(lbtf_cmd_response_rx);
 
diff --git a/drivers/net/wireless/libertas_tf/libertas_tf.h b/drivers/net/wireless/libertas_tf/libertas_tf.h
index ad77b92..6b0f932 100644
--- a/drivers/net/wireless/libertas_tf/libertas_tf.h
+++ b/drivers/net/wireless/libertas_tf/libertas_tf.h
@@ -156,8 +156,6 @@ enum mv_ms_type {
 	MVMS_EVENT
 };
 
-extern struct workqueue_struct *lbtf_wq;
-
 struct lbtf_private;
 
 struct lbtf_offset_value {
diff --git a/drivers/net/wireless/libertas_tf/main.c b/drivers/net/wireless/libertas_tf/main.c
index 9278b3c..622d029 100644
--- a/drivers/net/wireless/libertas_tf/main.c
+++ b/drivers/net/wireless/libertas_tf/main.c
@@ -31,8 +31,6 @@ static const char lbtf_driver_version[] = "THINFIRM-USB8388-" DRIVER_RELEASE_VER
 #endif
 	"";
 
-struct workqueue_struct *lbtf_wq;
-
 static const struct ieee80211_channel lbtf_channels[] = {
 	{ .center_freq = 2412, .hw_value = 1 },
 	{ .center_freq = 2417, .hw_value = 2 },
@@ -188,7 +186,7 @@ static void command_timer_fn(unsigned long data)
 		le16_to_cpu(priv->cur_cmd->cmdbuf->command));
 
 	priv->cmd_timed_out = 1;
-	queue_work(lbtf_wq, &priv->cmd_work);
+	schedule_work(&priv->cmd_work);
 out:
 	spin_unlock_irqrestore(&priv->driver_lock, flags);
 	lbtf_deb_leave(LBTF_DEB_CMD);
@@ -230,7 +228,7 @@ static int lbtf_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	struct lbtf_private *priv = hw->priv;
 
 	priv->skb_to_tx = skb;
-	queue_work(lbtf_wq, &priv->tx_work);
+	schedule_work(&priv->tx_work);
 	/*
 	 * queue will be restarted when we receive transmission feedback if
 	 * there are no buffered multicast frames to send
@@ -706,7 +704,7 @@ void lbtf_send_tx_feedback(struct lbtf_private *priv, u8 retrycnt, u8 fail)
 	if (!priv->skb_to_tx && skb_queue_empty(&priv->bc_ps_buf))
 		ieee80211_wake_queues(priv->hw);
 	else
-		queue_work(lbtf_wq, &priv->tx_work);
+		schedule_work(&priv->tx_work);
 }
 EXPORT_SYMBOL_GPL(lbtf_send_tx_feedback);
 
@@ -726,7 +724,7 @@ void lbtf_bcn_sent(struct lbtf_private *priv)
 		}
 		if (tx_buff_bc) {
 			ieee80211_stop_queues(priv->hw);
-			queue_work(lbtf_wq, &priv->tx_work);
+			schedule_work(&priv->tx_work);
 		}
 	}
 
@@ -742,11 +740,6 @@ EXPORT_SYMBOL_GPL(lbtf_bcn_sent);
 static int __init lbtf_init_module(void)
 {
 	lbtf_deb_enter(LBTF_DEB_MAIN);
-	lbtf_wq = create_workqueue("libertastf");
-	if (lbtf_wq == NULL) {
-		printk(KERN_ERR "libertastf: couldn't create workqueue\n");
-		return -ENOMEM;
-	}
 	lbtf_deb_leave(LBTF_DEB_MAIN);
 	return 0;
 }
@@ -754,7 +747,6 @@ static int __init lbtf_init_module(void)
 static void __exit lbtf_exit_module(void)
 {
 	lbtf_deb_enter(LBTF_DEB_MAIN);
-	destroy_workqueue(lbtf_wq);
 	lbtf_deb_leave(LBTF_DEB_MAIN);
 }
 
-- 
1.7.1

