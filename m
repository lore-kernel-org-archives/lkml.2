Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293Ab2LVB6H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 20:58:07 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:65027 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab2LVB6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 20:58:02 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        linux-wireless@vger.kernel.org
Subject: [PATCH 04/25] ipw2x00: simplify scan_event handling
Date: Fri, 21 Dec 2012 17:56:54 -0800
Message-Id: <1356141435-17340-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1356141435-17340-1-git-send-email-tj@kernel.org>
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Drop unnesssary delayd_work_pending() tests.

* Unify scan_event_{now|later} by using mod_delayed_work() w/ 0 delay
  for scan_event_now.

* Make ipw2200 scan_event handling match ipw2100 - use
  mod_delayed_work() w/ 0 delay for immediate scanning.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Stanislav Yakovlev <stas.yakovlev@gmail.com>
Cc: linux-wireless@vger.kernel.org
---
Please let me know how this patch should be routed.  I can take it
through the workqueue tree if necessary.

Thanks.

 drivers/net/wireless/ipw2x00/ipw2100.c | 31 ++++++++-----------------------
 drivers/net/wireless/ipw2x00/ipw2100.h |  3 +--
 drivers/net/wireless/ipw2x00/ipw2200.c | 13 +++----------
 3 files changed, 12 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/ipw2x00/ipw2100.c b/drivers/net/wireless/ipw2x00/ipw2100.c
index d92b21a..b3ab7b7 100644
--- a/drivers/net/wireless/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/ipw2x00/ipw2100.c
@@ -2181,9 +2181,10 @@ static void isr_indicate_rf_kill(struct ipw2100_priv *priv, u32 status)
 	mod_delayed_work(system_wq, &priv->rf_kill, round_jiffies_relative(HZ));
 }
 
-static void send_scan_event(void *data)
+static void ipw2100_scan_event(struct work_struct *work)
 {
-	struct ipw2100_priv *priv = data;
+	struct ipw2100_priv *priv = container_of(work, struct ipw2100_priv,
+						 scan_event.work);
 	union iwreq_data wrqu;
 
 	wrqu.data.length = 0;
@@ -2191,18 +2192,6 @@ static void send_scan_event(void *data)
 	wireless_send_event(priv->net_dev, SIOCGIWSCAN, &wrqu, NULL);
 }
 
-static void ipw2100_scan_event_later(struct work_struct *work)
-{
-	send_scan_event(container_of(work, struct ipw2100_priv,
-					scan_event_later.work));
-}
-
-static void ipw2100_scan_event_now(struct work_struct *work)
-{
-	send_scan_event(container_of(work, struct ipw2100_priv,
-					scan_event_now));
-}
-
 static void isr_scan_complete(struct ipw2100_priv *priv, u32 status)
 {
 	IPW_DEBUG_SCAN("scan complete\n");
@@ -2212,13 +2201,11 @@ static void isr_scan_complete(struct ipw2100_priv *priv, u32 status)
 
 	/* Only userspace-requested scan completion events go out immediately */
 	if (!priv->user_requested_scan) {
-		if (!delayed_work_pending(&priv->scan_event_later))
-			schedule_delayed_work(&priv->scan_event_later,
-					      round_jiffies_relative(msecs_to_jiffies(4000)));
+		schedule_delayed_work(&priv->scan_event,
+				      round_jiffies_relative(msecs_to_jiffies(4000)));
 	} else {
 		priv->user_requested_scan = 0;
-		cancel_delayed_work(&priv->scan_event_later);
-		schedule_work(&priv->scan_event_now);
+		mod_delayed_work(system_wq, &priv->scan_event, 0);
 	}
 }
 
@@ -4459,8 +4446,7 @@ static void ipw2100_kill_works(struct ipw2100_priv *priv)
 	cancel_delayed_work_sync(&priv->wx_event_work);
 	cancel_delayed_work_sync(&priv->hang_check);
 	cancel_delayed_work_sync(&priv->rf_kill);
-	cancel_work_sync(&priv->scan_event_now);
-	cancel_delayed_work_sync(&priv->scan_event_later);
+	cancel_delayed_work_sync(&priv->scan_event);
 }
 
 static int ipw2100_tx_allocate(struct ipw2100_priv *priv)
@@ -6195,8 +6181,7 @@ static struct net_device *ipw2100_alloc_device(struct pci_dev *pci_dev,
 	INIT_DELAYED_WORK(&priv->wx_event_work, ipw2100_wx_event_work);
 	INIT_DELAYED_WORK(&priv->hang_check, ipw2100_hang_check);
 	INIT_DELAYED_WORK(&priv->rf_kill, ipw2100_rf_kill);
-	INIT_WORK(&priv->scan_event_now, ipw2100_scan_event_now);
-	INIT_DELAYED_WORK(&priv->scan_event_later, ipw2100_scan_event_later);
+	INIT_DELAYED_WORK(&priv->scan_event, ipw2100_scan_event);
 
 	tasklet_init(&priv->irq_tasklet, (void (*)(unsigned long))
 		     ipw2100_irq_tasklet, (unsigned long)priv);
diff --git a/drivers/net/wireless/ipw2x00/ipw2100.h b/drivers/net/wireless/ipw2x00/ipw2100.h
index 5fe17cb..c6d7879 100644
--- a/drivers/net/wireless/ipw2x00/ipw2100.h
+++ b/drivers/net/wireless/ipw2x00/ipw2100.h
@@ -577,8 +577,7 @@ struct ipw2100_priv {
 	struct delayed_work wx_event_work;
 	struct delayed_work hang_check;
 	struct delayed_work rf_kill;
-	struct work_struct scan_event_now;
-	struct delayed_work scan_event_later;
+	struct delayed_work scan_event;
 
 	int user_requested_scan;
 
diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
index 844f201..2c2d6db 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -4480,18 +4480,11 @@ static void handle_scan_event(struct ipw_priv *priv)
 {
 	/* Only userspace-requested scan completion events go out immediately */
 	if (!priv->user_requested_scan) {
-		if (!delayed_work_pending(&priv->scan_event))
-			schedule_delayed_work(&priv->scan_event,
-					      round_jiffies_relative(msecs_to_jiffies(4000)));
+		schedule_delayed_work(&priv->scan_event,
+				      round_jiffies_relative(msecs_to_jiffies(4000)));
 	} else {
-		union iwreq_data wrqu;
-
 		priv->user_requested_scan = 0;
-		cancel_delayed_work(&priv->scan_event);
-
-		wrqu.data.length = 0;
-		wrqu.data.flags = 0;
-		wireless_send_event(priv->net_dev, SIOCGIWSCAN, &wrqu, NULL);
+		mod_delayed_work(system_wq, &priv->scan_event, 0);
 	}
 }
 
-- 
1.8.0.2

