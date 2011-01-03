Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224Ab1ACNyb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 08:54:31 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36659 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754969Ab1ACNua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 08:50:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=om/Z6LqSu3/2kzkAGfRSHQcOVkPnCgKOdFdrmNL8IK55cKv2gp2e+YjK9heMobaK7j
         mb557ll/HH04XCyZ71qHcL4CmSTQ3bgVnrAUn/GHIfif8nDgN0FfvZEjHUzGYuRHQ0Rq
         RUy53SdeCb+3SPoASX0C38ZDhrKPhcSZI4lCw=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org
Subject: [PATCH 14/32] wireless/ipw2x00: use system_wq instead of dedicated workqueues
Date: Mon,  3 Jan 2011 14:49:37 +0100
Message-Id: <1294062595-30097-15-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1294062595-30097-1-git-send-email-tj@kernel.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With cmwq, there's no reason to use separate workqueues in ipw2x00
drivers.  Drop them and use system_wq instead.  All used work items
are sync canceled on driver detach.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
---
Only compile tested.  Please feel free to take it into the subsystem
tree or simply ack - I'll route it through the wq tree.

Thanks.

 drivers/net/wireless/ipw2x00/ipw2100.c |   70 +++++-------
 drivers/net/wireless/ipw2x00/ipw2100.h |    1 -
 drivers/net/wireless/ipw2x00/ipw2200.c |  196 ++++++++++++++------------------
 drivers/net/wireless/ipw2x00/ipw2200.h |    2 -
 4 files changed, 118 insertions(+), 151 deletions(-)

diff --git a/drivers/net/wireless/ipw2x00/ipw2100.c b/drivers/net/wireless/ipw2x00/ipw2100.c
index 61915f3..471a52a 100644
--- a/drivers/net/wireless/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/ipw2x00/ipw2100.c
@@ -706,11 +706,10 @@ static void schedule_reset(struct ipw2100_priv *priv)
 		netif_stop_queue(priv->net_dev);
 		priv->status |= STATUS_RESET_PENDING;
 		if (priv->reset_backoff)
-			queue_delayed_work(priv->workqueue, &priv->reset_work,
-					   priv->reset_backoff * HZ);
+			schedule_delayed_work(&priv->reset_work,
+					      priv->reset_backoff * HZ);
 		else
-			queue_delayed_work(priv->workqueue, &priv->reset_work,
-					   0);
+			schedule_delayed_work(&priv->reset_work, 0);
 
 		if (priv->reset_backoff < MAX_RESET_BACKOFF)
 			priv->reset_backoff++;
@@ -1474,7 +1473,7 @@ static int ipw2100_enable_adapter(struct ipw2100_priv *priv)
 
 	if (priv->stop_hang_check) {
 		priv->stop_hang_check = 0;
-		queue_delayed_work(priv->workqueue, &priv->hang_check, HZ / 2);
+		schedule_delayed_work(&priv->hang_check, HZ / 2);
 	}
 
       fail_up:
@@ -1808,8 +1807,8 @@ static int ipw2100_up(struct ipw2100_priv *priv, int deferred)
 
 		if (priv->stop_rf_kill) {
 			priv->stop_rf_kill = 0;
-			queue_delayed_work(priv->workqueue, &priv->rf_kill,
-					   round_jiffies_relative(HZ));
+			schedule_delayed_work(&priv->rf_kill,
+					      round_jiffies_relative(HZ));
 		}
 
 		deferred = 1;
@@ -2086,7 +2085,7 @@ static void isr_indicate_associated(struct ipw2100_priv *priv, u32 status)
 	priv->status |= STATUS_ASSOCIATING;
 	priv->connect_start = get_seconds();
 
-	queue_delayed_work(priv->workqueue, &priv->wx_event_work, HZ / 10);
+	schedule_delayed_work(&priv->wx_event_work, HZ / 10);
 }
 
 static int ipw2100_set_essid(struct ipw2100_priv *priv, char *essid,
@@ -2166,9 +2165,9 @@ static void isr_indicate_association_lost(struct ipw2100_priv *priv, u32 status)
 		return;
 
 	if (priv->status & STATUS_SECURITY_UPDATED)
-		queue_delayed_work(priv->workqueue, &priv->security_work, 0);
+		schedule_delayed_work(&priv->security_work, 0);
 
-	queue_delayed_work(priv->workqueue, &priv->wx_event_work, 0);
+	schedule_delayed_work(&priv->wx_event_work, 0);
 }
 
 static void isr_indicate_rf_kill(struct ipw2100_priv *priv, u32 status)
@@ -2183,8 +2182,7 @@ static void isr_indicate_rf_kill(struct ipw2100_priv *priv, u32 status)
 	/* Make sure the RF Kill check timer is running */
 	priv->stop_rf_kill = 0;
 	cancel_delayed_work(&priv->rf_kill);
-	queue_delayed_work(priv->workqueue, &priv->rf_kill,
-			   round_jiffies_relative(HZ));
+	schedule_delayed_work(&priv->rf_kill, round_jiffies_relative(HZ));
 }
 
 static void send_scan_event(void *data)
@@ -2219,13 +2217,12 @@ static void isr_scan_complete(struct ipw2100_priv *priv, u32 status)
 	/* Only userspace-requested scan completion events go out immediately */
 	if (!priv->user_requested_scan) {
 		if (!delayed_work_pending(&priv->scan_event_later))
-			queue_delayed_work(priv->workqueue,
-					&priv->scan_event_later,
-					round_jiffies_relative(msecs_to_jiffies(4000)));
+			schedule_delayed_work(&priv->scan_event_later,
+					      round_jiffies_relative(msecs_to_jiffies(4000)));
 	} else {
 		priv->user_requested_scan = 0;
 		cancel_delayed_work(&priv->scan_event_later);
-		queue_work(priv->workqueue, &priv->scan_event_now);
+		schedule_work(&priv->scan_event_now);
 	}
 }
 
@@ -4329,8 +4326,8 @@ static int ipw_radio_kill_sw(struct ipw2100_priv *priv, int disable_radio)
 			/* Make sure the RF_KILL check timer is running */
 			priv->stop_rf_kill = 0;
 			cancel_delayed_work(&priv->rf_kill);
-			queue_delayed_work(priv->workqueue, &priv->rf_kill,
-					   round_jiffies_relative(HZ));
+			schedule_delayed_work(&priv->rf_kill,
+					      round_jiffies_relative(HZ));
 		} else
 			schedule_reset(priv);
 	}
@@ -4461,20 +4458,17 @@ static void bd_queue_initialize(struct ipw2100_priv *priv,
 	IPW_DEBUG_INFO("exit\n");
 }
 
-static void ipw2100_kill_workqueue(struct ipw2100_priv *priv)
+static void ipw2100_kill_works(struct ipw2100_priv *priv)
 {
-	if (priv->workqueue) {
-		priv->stop_rf_kill = 1;
-		priv->stop_hang_check = 1;
-		cancel_delayed_work(&priv->reset_work);
-		cancel_delayed_work(&priv->security_work);
-		cancel_delayed_work(&priv->wx_event_work);
-		cancel_delayed_work(&priv->hang_check);
-		cancel_delayed_work(&priv->rf_kill);
-		cancel_delayed_work(&priv->scan_event_later);
-		destroy_workqueue(priv->workqueue);
-		priv->workqueue = NULL;
-	}
+	priv->stop_rf_kill = 1;
+	priv->stop_hang_check = 1;
+	cancel_delayed_work_sync(&priv->reset_work);
+	cancel_delayed_work_sync(&priv->security_work);
+	cancel_delayed_work_sync(&priv->wx_event_work);
+	cancel_delayed_work_sync(&priv->hang_check);
+	cancel_delayed_work_sync(&priv->rf_kill);
+	cancel_work_sync(&priv->scan_event_now);
+	cancel_delayed_work_sync(&priv->scan_event_later);
 }
 
 static int ipw2100_tx_allocate(struct ipw2100_priv *priv)
@@ -6046,7 +6040,7 @@ static void ipw2100_hang_check(struct work_struct *work)
 	priv->last_rtc = rtc;
 
 	if (!priv->stop_hang_check)
-		queue_delayed_work(priv->workqueue, &priv->hang_check, HZ / 2);
+		schedule_delayed_work(&priv->hang_check, HZ / 2);
 
 	spin_unlock_irqrestore(&priv->low_lock, flags);
 }
@@ -6062,8 +6056,8 @@ static void ipw2100_rf_kill(struct work_struct *work)
 	if (rf_kill_active(priv)) {
 		IPW_DEBUG_RF_KILL("RF Kill active, rescheduling GPIO check\n");
 		if (!priv->stop_rf_kill)
-			queue_delayed_work(priv->workqueue, &priv->rf_kill,
-					   round_jiffies_relative(HZ));
+			schedule_delayed_work(&priv->rf_kill,
+					      round_jiffies_relative(HZ));
 		goto exit_unlock;
 	}
 
@@ -6209,8 +6203,6 @@ static struct net_device *ipw2100_alloc_device(struct pci_dev *pci_dev,
 	INIT_LIST_HEAD(&priv->fw_pend_list);
 	INIT_STAT(&priv->fw_pend_stat);
 
-	priv->workqueue = create_workqueue(DRV_NAME);
-
 	INIT_DELAYED_WORK(&priv->reset_work, ipw2100_reset_adapter);
 	INIT_DELAYED_WORK(&priv->security_work, ipw2100_security_work);
 	INIT_DELAYED_WORK(&priv->wx_event_work, ipw2100_wx_event_work);
@@ -6410,7 +6402,7 @@ static int ipw2100_pci_init_one(struct pci_dev *pci_dev,
 		if (dev->irq)
 			free_irq(dev->irq, priv);
 
-		ipw2100_kill_workqueue(priv);
+		ipw2100_kill_works(priv);
 
 		/* These are safe to call even if they weren't allocated */
 		ipw2100_queues_free(priv);
@@ -6460,9 +6452,7 @@ static void __devexit ipw2100_pci_remove_one(struct pci_dev *pci_dev)
 		 * first, then close() will crash. */
 		unregister_netdev(dev);
 
-		/* ipw2100_down will ensure that there is no more pending work
-		 * in the workqueue's, so we can safely remove them now. */
-		ipw2100_kill_workqueue(priv);
+		ipw2100_kill_works(priv);
 
 		ipw2100_queues_free(priv);
 
diff --git a/drivers/net/wireless/ipw2x00/ipw2100.h b/drivers/net/wireless/ipw2x00/ipw2100.h
index 838002b..99cba96 100644
--- a/drivers/net/wireless/ipw2x00/ipw2100.h
+++ b/drivers/net/wireless/ipw2x00/ipw2100.h
@@ -580,7 +580,6 @@ struct ipw2100_priv {
 
 	struct tasklet_struct irq_tasklet;
 
-	struct workqueue_struct *workqueue;
 	struct delayed_work reset_work;
 	struct delayed_work security_work;
 	struct delayed_work wx_event_work;
diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
index 8d6ed5f..7319395 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -894,9 +894,8 @@ static void ipw_led_link_on(struct ipw_priv *priv)
 
 		/* If we aren't associated, schedule turning the LED off */
 		if (!(priv->status & STATUS_ASSOCIATED))
-			queue_delayed_work(priv->workqueue,
-					   &priv->led_link_off,
-					   LD_TIME_LINK_ON);
+			schedule_delayed_work(&priv->led_link_off,
+					      LD_TIME_LINK_ON);
 	}
 
 	spin_unlock_irqrestore(&priv->lock, flags);
@@ -939,8 +938,8 @@ static void ipw_led_link_off(struct ipw_priv *priv)
 		 * turning the LED on (blink while unassociated) */
 		if (!(priv->status & STATUS_RF_KILL_MASK) &&
 		    !(priv->status & STATUS_ASSOCIATED))
-			queue_delayed_work(priv->workqueue, &priv->led_link_on,
-					   LD_TIME_LINK_OFF);
+			schedule_delayed_work(&priv->led_link_on,
+					      LD_TIME_LINK_OFF);
 
 	}
 
@@ -980,13 +979,11 @@ static void __ipw_led_activity_on(struct ipw_priv *priv)
 		priv->status |= STATUS_LED_ACT_ON;
 
 		cancel_delayed_work(&priv->led_act_off);
-		queue_delayed_work(priv->workqueue, &priv->led_act_off,
-				   LD_TIME_ACT_ON);
+		schedule_delayed_work(&priv->led_act_off, LD_TIME_ACT_ON);
 	} else {
 		/* Reschedule LED off for full time period */
 		cancel_delayed_work(&priv->led_act_off);
-		queue_delayed_work(priv->workqueue, &priv->led_act_off,
-				   LD_TIME_ACT_ON);
+		schedule_delayed_work(&priv->led_act_off, LD_TIME_ACT_ON);
 	}
 }
 
@@ -1795,13 +1792,11 @@ static int ipw_radio_kill_sw(struct ipw_priv *priv, int disable_radio)
 	if (disable_radio) {
 		priv->status |= STATUS_RF_KILL_SW;
 
-		if (priv->workqueue) {
-			cancel_delayed_work(&priv->request_scan);
-			cancel_delayed_work(&priv->request_direct_scan);
-			cancel_delayed_work(&priv->request_passive_scan);
-			cancel_delayed_work(&priv->scan_event);
-		}
-		queue_work(priv->workqueue, &priv->down);
+		cancel_delayed_work(&priv->request_scan);
+		cancel_delayed_work(&priv->request_direct_scan);
+		cancel_delayed_work(&priv->request_passive_scan);
+		cancel_delayed_work(&priv->scan_event);
+		schedule_work(&priv->down);
 	} else {
 		priv->status &= ~STATUS_RF_KILL_SW;
 		if (rf_kill_active(priv)) {
@@ -1809,10 +1804,10 @@ static int ipw_radio_kill_sw(struct ipw_priv *priv, int disable_radio)
 					  "disabled by HW switch\n");
 			/* Make sure the RF_KILL check timer is running */
 			cancel_delayed_work(&priv->rf_kill);
-			queue_delayed_work(priv->workqueue, &priv->rf_kill,
-					   round_jiffies_relative(2 * HZ));
+			schedule_delayed_work(&priv->rf_kill,
+					      round_jiffies_relative(2 * HZ));
 		} else
-			queue_work(priv->workqueue, &priv->up);
+			schedule_work(&priv->up);
 	}
 
 	return 1;
@@ -2056,7 +2051,7 @@ static void ipw_irq_tasklet(struct ipw_priv *priv)
 		cancel_delayed_work(&priv->request_passive_scan);
 		cancel_delayed_work(&priv->scan_event);
 		schedule_work(&priv->link_down);
-		queue_delayed_work(priv->workqueue, &priv->rf_kill, 2 * HZ);
+		schedule_delayed_work(&priv->rf_kill, 2 * HZ);
 		handled |= IPW_INTA_BIT_RF_KILL_DONE;
 	}
 
@@ -2096,7 +2091,7 @@ static void ipw_irq_tasklet(struct ipw_priv *priv)
 		priv->status &= ~STATUS_HCMD_ACTIVE;
 		wake_up_interruptible(&priv->wait_command_queue);
 
-		queue_work(priv->workqueue, &priv->adapter_restart);
+		schedule_work(&priv->adapter_restart);
 		handled |= IPW_INTA_BIT_FATAL_ERROR;
 	}
 
@@ -2316,11 +2311,6 @@ static int ipw_send_adapter_address(struct ipw_priv *priv, u8 * mac)
 	return ipw_send_cmd_pdu(priv, IPW_CMD_ADAPTER_ADDRESS, ETH_ALEN, mac);
 }
 
-/*
- * NOTE: This must be executed from our workqueue as it results in udelay
- * being called which may corrupt the keyboard if executed on default
- * workqueue
- */
 static void ipw_adapter_restart(void *adapter)
 {
 	struct ipw_priv *priv = adapter;
@@ -2361,13 +2351,13 @@ static void ipw_scan_check(void *data)
 		IPW_DEBUG_SCAN("Scan completion watchdog resetting "
 			       "adapter after (%dms).\n",
 			       jiffies_to_msecs(IPW_SCAN_CHECK_WATCHDOG));
-		queue_work(priv->workqueue, &priv->adapter_restart);
+		schedule_work(&priv->adapter_restart);
 	} else if (priv->status & STATUS_SCANNING) {
 		IPW_DEBUG_SCAN("Scan completion watchdog aborting scan "
 			       "after (%dms).\n",
 			       jiffies_to_msecs(IPW_SCAN_CHECK_WATCHDOG));
 		ipw_abort_scan(priv);
-		queue_delayed_work(priv->workqueue, &priv->scan_check, HZ);
+		schedule_delayed_work(&priv->scan_check, HZ);
 	}
 }
 
@@ -3936,7 +3926,7 @@ static void ipw_send_disassociate(struct ipw_priv *priv, int quiet)
 
 	if (priv->status & STATUS_ASSOCIATING) {
 		IPW_DEBUG_ASSOC("Disassociating while associating.\n");
-		queue_work(priv->workqueue, &priv->disassociate);
+		schedule_work(&priv->disassociate);
 		return;
 	}
 
@@ -4353,8 +4343,7 @@ static void ipw_gather_stats(struct ipw_priv *priv)
 
 	priv->quality = quality;
 
-	queue_delayed_work(priv->workqueue, &priv->gather_stats,
-			   IPW_STATS_INTERVAL);
+	schedule_delayed_work(&priv->gather_stats, IPW_STATS_INTERVAL);
 }
 
 static void ipw_bg_gather_stats(struct work_struct *work)
@@ -4389,10 +4378,10 @@ static void ipw_handle_missed_beacon(struct ipw_priv *priv,
 			IPW_DEBUG(IPW_DL_INFO | IPW_DL_NOTIF |
 				  IPW_DL_STATE,
 				  "Aborting scan with missed beacon.\n");
-			queue_work(priv->workqueue, &priv->abort_scan);
+			schedule_work(&priv->abort_scan);
 		}
 
-		queue_work(priv->workqueue, &priv->disassociate);
+		schedule_work(&priv->disassociate);
 		return;
 	}
 
@@ -4418,8 +4407,7 @@ static void ipw_handle_missed_beacon(struct ipw_priv *priv,
 		if (!(priv->status & STATUS_ROAMING)) {
 			priv->status |= STATUS_ROAMING;
 			if (!(priv->status & STATUS_SCANNING))
-				queue_delayed_work(priv->workqueue,
-						   &priv->request_scan, 0);
+				schedule_delayed_work(&priv->request_scan, 0);
 		}
 		return;
 	}
@@ -4432,7 +4420,7 @@ static void ipw_handle_missed_beacon(struct ipw_priv *priv,
 		 * channels..) */
 		IPW_DEBUG(IPW_DL_INFO | IPW_DL_NOTIF | IPW_DL_STATE,
 			  "Aborting scan with missed beacon.\n");
-		queue_work(priv->workqueue, &priv->abort_scan);
+		schedule_work(&priv->abort_scan);
 	}
 
 	IPW_DEBUG_NOTIF("Missed beacon: %d\n", missed_count);
@@ -4455,8 +4443,8 @@ static void handle_scan_event(struct ipw_priv *priv)
 	/* Only userspace-requested scan completion events go out immediately */
 	if (!priv->user_requested_scan) {
 		if (!delayed_work_pending(&priv->scan_event))
-			queue_delayed_work(priv->workqueue, &priv->scan_event,
-					 round_jiffies_relative(msecs_to_jiffies(4000)));
+			schedule_delayed_work(&priv->scan_event,
+					      round_jiffies_relative(msecs_to_jiffies(4000)));
 	} else {
 		union iwreq_data wrqu;
 
@@ -4509,20 +4497,17 @@ static void ipw_rx_notification(struct ipw_priv *priv,
 
 						IPW_DEBUG_ASSOC
 						    ("queueing adhoc check\n");
-						queue_delayed_work(priv->
-								   workqueue,
-								   &priv->
-								   adhoc_check,
-								   le16_to_cpu(priv->
-								   assoc_request.
-								   beacon_interval));
+						schedule_delayed_work(
+							&priv->adhoc_check,
+							le16_to_cpu(priv->
+							assoc_request.
+							beacon_interval));
 						break;
 					}
 
 					priv->status &= ~STATUS_ASSOCIATING;
 					priv->status |= STATUS_ASSOCIATED;
-					queue_work(priv->workqueue,
-						   &priv->system_config);
+					schedule_work(&priv->system_config);
 
 #ifdef CONFIG_IPW2200_QOS
 #define IPW_GET_PACKET_STYPE(x) WLAN_FC_GET_STYPE( \
@@ -4785,43 +4770,37 @@ static void ipw_rx_notification(struct ipw_priv *priv,
 #ifdef CONFIG_IPW2200_MONITOR
 			if (priv->ieee->iw_mode == IW_MODE_MONITOR) {
 				priv->status |= STATUS_SCAN_FORCED;
-				queue_delayed_work(priv->workqueue,
-						   &priv->request_scan, 0);
+				schedule_delayed_work(&priv->request_scan, 0);
 				break;
 			}
 			priv->status &= ~STATUS_SCAN_FORCED;
 #endif				/* CONFIG_IPW2200_MONITOR */
 
 			/* Do queued direct scans first */
-			if (priv->status & STATUS_DIRECT_SCAN_PENDING) {
-				queue_delayed_work(priv->workqueue,
-						   &priv->request_direct_scan, 0);
-			}
+			if (priv->status & STATUS_DIRECT_SCAN_PENDING)
+				schedule_delayed_work(&priv->request_direct_scan, 0);
 
 			if (!(priv->status & (STATUS_ASSOCIATED |
 					      STATUS_ASSOCIATING |
 					      STATUS_ROAMING |
 					      STATUS_DISASSOCIATING)))
-				queue_work(priv->workqueue, &priv->associate);
+				schedule_work(&priv->associate);
 			else if (priv->status & STATUS_ROAMING) {
 				if (x->status == SCAN_COMPLETED_STATUS_COMPLETE)
 					/* If a scan completed and we are in roam mode, then
 					 * the scan that completed was the one requested as a
 					 * result of entering roam... so, schedule the
 					 * roam work */
-					queue_work(priv->workqueue,
-						   &priv->roam);
+					schedule_work(&priv->roam);
 				else
 					/* Don't schedule if we aborted the scan */
 					priv->status &= ~STATUS_ROAMING;
 			} else if (priv->status & STATUS_SCAN_PENDING)
-				queue_delayed_work(priv->workqueue,
-						   &priv->request_scan, 0);
+				schedule_delayed_work(&priv->request_scan, 0);
 			else if (priv->config & CFG_BACKGROUND_SCAN
 				 && priv->status & STATUS_ASSOCIATED)
-				queue_delayed_work(priv->workqueue,
-						   &priv->request_scan,
-						   round_jiffies_relative(HZ));
+				schedule_delayed_work(&priv->request_scan,
+						      round_jiffies_relative(HZ));
 
 			/* Send an empty event to user space.
 			 * We don't send the received data on the event because
@@ -5185,7 +5164,7 @@ static void ipw_rx_queue_restock(struct ipw_priv *priv)
 	/* If the pre-allocated buffer pool is dropping low, schedule to
 	 * refill it */
 	if (rxq->free_count <= RX_LOW_WATERMARK)
-		queue_work(priv->workqueue, &priv->rx_replenish);
+		schedule_work(&priv->rx_replenish);
 
 	/* If we've added more space for the firmware to place data, tell it */
 	if (write != rxq->write)
@@ -6126,8 +6105,8 @@ static void ipw_adhoc_check(void *data)
 		return;
 	}
 
-	queue_delayed_work(priv->workqueue, &priv->adhoc_check,
-			   le16_to_cpu(priv->assoc_request.beacon_interval));
+	schedule_delayed_work(&priv->adhoc_check,
+			      le16_to_cpu(priv->assoc_request.beacon_interval));
 }
 
 static void ipw_bg_adhoc_check(struct work_struct *work)
@@ -6516,8 +6495,7 @@ send_request:
 	} else
 		priv->status &= ~STATUS_SCAN_PENDING;
 
-	queue_delayed_work(priv->workqueue, &priv->scan_check,
-			   IPW_SCAN_CHECK_WATCHDOG);
+	schedule_delayed_work(&priv->scan_check, IPW_SCAN_CHECK_WATCHDOG);
 done:
 	mutex_unlock(&priv->mutex);
 	return err;
@@ -6987,8 +6965,7 @@ static int ipw_qos_handle_probe_response(struct ipw_priv *priv,
 				    !memcmp(network->ssid,
 					    priv->assoc_network->ssid,
 					    network->ssid_len)) {
-					queue_work(priv->workqueue,
-						   &priv->merge_networks);
+					schedule_work(&priv->merge_networks);
 				}
 	}
 
@@ -7656,7 +7633,7 @@ static int ipw_associate(void *data)
 	if (priv->status & STATUS_DISASSOCIATING) {
 		IPW_DEBUG_ASSOC("Not attempting association (in "
 				"disassociating)\n ");
-		queue_work(priv->workqueue, &priv->associate);
+		schedule_work(&priv->associate);
 		return 0;
 	}
 
@@ -7724,12 +7701,10 @@ static int ipw_associate(void *data)
 
 		if (!(priv->status & STATUS_SCANNING)) {
 			if (!(priv->config & CFG_SPEED_SCAN))
-				queue_delayed_work(priv->workqueue,
-						   &priv->request_scan,
-						   SCAN_INTERVAL);
+				schedule_delayed_work(&priv->request_scan,
+						      SCAN_INTERVAL);
 			else
-				queue_delayed_work(priv->workqueue,
-						   &priv->request_scan, 0);
+				schedule_delayed_work(&priv->request_scan, 0);
 		}
 
 		return 0;
@@ -8892,7 +8867,7 @@ static int ipw_wx_set_mode(struct net_device *dev,
 
 	priv->ieee->iw_mode = wrqu->mode;
 
-	queue_work(priv->workqueue, &priv->adapter_restart);
+	schedule_work(&priv->adapter_restart);
 	mutex_unlock(&priv->mutex);
 	return err;
 }
@@ -9591,7 +9566,7 @@ static int ipw_wx_set_scan(struct net_device *dev,
 
 	IPW_DEBUG_WX("Start scan\n");
 
-	queue_delayed_work(priv->workqueue, work, 0);
+	schedule_delayed_work(work, 0);
 
 	return 0;
 }
@@ -9930,7 +9905,7 @@ static int ipw_wx_set_monitor(struct net_device *dev,
 #else
 			priv->net_dev->type = ARPHRD_IEEE80211;
 #endif
-			queue_work(priv->workqueue, &priv->adapter_restart);
+			schedule_work(&priv->adapter_restart);
 		}
 
 		ipw_set_channel(priv, parms[1]);
@@ -9940,7 +9915,7 @@ static int ipw_wx_set_monitor(struct net_device *dev,
 			return 0;
 		}
 		priv->net_dev->type = ARPHRD_ETHER;
-		queue_work(priv->workqueue, &priv->adapter_restart);
+		schedule_work(&priv->adapter_restart);
 	}
 	mutex_unlock(&priv->mutex);
 	return 0;
@@ -9954,7 +9929,7 @@ static int ipw_wx_reset(struct net_device *dev,
 {
 	struct ipw_priv *priv = libipw_priv(dev);
 	IPW_DEBUG_WX("RESET\n");
-	queue_work(priv->workqueue, &priv->adapter_restart);
+	schedule_work(&priv->adapter_restart);
 	return 0;
 }
 
@@ -10544,7 +10519,7 @@ static int ipw_net_set_mac_address(struct net_device *dev, void *p)
 	memcpy(priv->mac_addr, addr->sa_data, ETH_ALEN);
 	printk(KERN_INFO "%s: Setting MAC to %pM\n",
 	       priv->net_dev->name, priv->mac_addr);
-	queue_work(priv->workqueue, &priv->adapter_restart);
+	schedule_work(&priv->adapter_restart);
 	mutex_unlock(&priv->mutex);
 	return 0;
 }
@@ -10677,9 +10652,7 @@ static void ipw_rf_kill(void *adapter)
 
 	if (rf_kill_active(priv)) {
 		IPW_DEBUG_RF_KILL("RF Kill active, rescheduling GPIO check\n");
-		if (priv->workqueue)
-			queue_delayed_work(priv->workqueue,
-					   &priv->rf_kill, 2 * HZ);
+		schedule_delayed_work(&priv->rf_kill, 2 * HZ);
 		goto exit_unlock;
 	}
 
@@ -10690,7 +10663,7 @@ static void ipw_rf_kill(void *adapter)
 				  "device\n");
 
 		/* we can not do an adapter restart while inside an irq lock */
-		queue_work(priv->workqueue, &priv->adapter_restart);
+		schedule_work(&priv->adapter_restart);
 	} else
 		IPW_DEBUG_RF_KILL("HW RF Kill deactivated.  SW RF Kill still "
 				  "enabled\n");
@@ -10728,7 +10701,7 @@ static void ipw_link_up(struct ipw_priv *priv)
 	notify_wx_assoc_event(priv);
 
 	if (priv->config & CFG_BACKGROUND_SCAN)
-		queue_delayed_work(priv->workqueue, &priv->request_scan, HZ);
+		schedule_delayed_work(&priv->request_scan, HZ);
 }
 
 static void ipw_bg_link_up(struct work_struct *work)
@@ -10757,7 +10730,7 @@ static void ipw_link_down(struct ipw_priv *priv)
 
 	if (!(priv->status & STATUS_EXIT_PENDING)) {
 		/* Queue up another scan... */
-		queue_delayed_work(priv->workqueue, &priv->request_scan, 0);
+		schedule_delayed_work(&priv->request_scan, 0);
 	} else
 		cancel_delayed_work(&priv->scan_event);
 }
@@ -10775,7 +10748,6 @@ static int __devinit ipw_setup_deferred_work(struct ipw_priv *priv)
 {
 	int ret = 0;
 
-	priv->workqueue = create_workqueue(DRV_NAME);
 	init_waitqueue_head(&priv->wait_command_queue);
 	init_waitqueue_head(&priv->wait_state);
 
@@ -11332,8 +11304,7 @@ static int ipw_up(struct ipw_priv *priv)
 			IPW_WARNING("Radio Frequency Kill Switch is On:\n"
 				    "Kill switch must be turned off for "
 				    "wireless networking to work.\n");
-			queue_delayed_work(priv->workqueue, &priv->rf_kill,
-					   2 * HZ);
+			schedule_delayed_work(&priv->rf_kill, 2 * HZ);
 			return 0;
 		}
 
@@ -11343,8 +11314,7 @@ static int ipw_up(struct ipw_priv *priv)
 
 			/* If configure to try and auto-associate, kick
 			 * off a scan. */
-			queue_delayed_work(priv->workqueue,
-					   &priv->request_scan, 0);
+			schedule_delayed_work(&priv->request_scan, 0);
 
 			return 0;
 		}
@@ -11810,7 +11780,7 @@ static int __devinit ipw_pci_probe(struct pci_dev *pdev,
 	err = request_irq(pdev->irq, ipw_isr, IRQF_SHARED, DRV_NAME, priv);
 	if (err) {
 		IPW_ERROR("Error allocating IRQ %d\n", pdev->irq);
-		goto out_destroy_workqueue;
+		goto out_iounmap;
 	}
 
 	SET_NETDEV_DEV(net_dev, &pdev->dev);
@@ -11878,9 +11848,6 @@ static int __devinit ipw_pci_probe(struct pci_dev *pdev,
 	sysfs_remove_group(&pdev->dev.kobj, &ipw_attribute_group);
       out_release_irq:
 	free_irq(pdev->irq, priv);
-      out_destroy_workqueue:
-	destroy_workqueue(priv->workqueue);
-	priv->workqueue = NULL;
       out_iounmap:
 	iounmap(priv->hw_base);
       out_pci_release_regions:
@@ -11923,18 +11890,31 @@ static void __devexit ipw_pci_remove(struct pci_dev *pdev)
 		kfree(priv->cmdlog);
 		priv->cmdlog = NULL;
 	}
-	/* ipw_down will ensure that there is no more pending work
-	 * in the workqueue's, so we can safely remove them now. */
-	cancel_delayed_work(&priv->adhoc_check);
-	cancel_delayed_work(&priv->gather_stats);
-	cancel_delayed_work(&priv->request_scan);
-	cancel_delayed_work(&priv->request_direct_scan);
-	cancel_delayed_work(&priv->request_passive_scan);
-	cancel_delayed_work(&priv->scan_event);
-	cancel_delayed_work(&priv->rf_kill);
-	cancel_delayed_work(&priv->scan_check);
-	destroy_workqueue(priv->workqueue);
-	priv->workqueue = NULL;
+
+	/* make sure all works are inactive */
+	cancel_delayed_work_sync(&priv->adhoc_check);
+	cancel_work_sync(&priv->associate);
+	cancel_work_sync(&priv->disassociate);
+	cancel_work_sync(&priv->system_config);
+	cancel_work_sync(&priv->rx_replenish);
+	cancel_work_sync(&priv->adapter_restart);
+	cancel_delayed_work_sync(&priv->rf_kill);
+	cancel_work_sync(&priv->up);
+	cancel_work_sync(&priv->down);
+	cancel_delayed_work_sync(&priv->request_scan);
+	cancel_delayed_work_sync(&priv->request_direct_scan);
+	cancel_delayed_work_sync(&priv->request_passive_scan);
+	cancel_delayed_work_sync(&priv->scan_event);
+	cancel_delayed_work_sync(&priv->gather_stats);
+	cancel_work_sync(&priv->abort_scan);
+	cancel_work_sync(&priv->roam);
+	cancel_delayed_work_sync(&priv->scan_check);
+	cancel_work_sync(&priv->link_up);
+	cancel_work_sync(&priv->link_down);
+	cancel_delayed_work_sync(&priv->led_link_on);
+	cancel_delayed_work_sync(&priv->led_link_off);
+	cancel_delayed_work_sync(&priv->led_act_off);
+	cancel_work_sync(&priv->merge_networks);
 
 	/* Free MAC hash list for ADHOC */
 	for (i = 0; i < IPW_IBSS_MAC_HASH_SIZE; i++) {
@@ -12022,7 +12002,7 @@ static int ipw_pci_resume(struct pci_dev *pdev)
 	priv->suspend_time = get_seconds() - priv->suspend_at;
 
 	/* Bring the device back up */
-	queue_work(priv->workqueue, &priv->up);
+	schedule_work(&priv->up);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/ipw2x00/ipw2200.h b/drivers/net/wireless/ipw2x00/ipw2200.h
index d7d049c..0441445 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.h
+++ b/drivers/net/wireless/ipw2x00/ipw2200.h
@@ -1299,8 +1299,6 @@ struct ipw_priv {
 	u8 direct_scan_ssid[IW_ESSID_MAX_SIZE];
 	u8 direct_scan_ssid_len;
 
-	struct workqueue_struct *workqueue;
-
 	struct delayed_work adhoc_check;
 	struct work_struct associate;
 	struct work_struct disassociate;
-- 
1.7.1

