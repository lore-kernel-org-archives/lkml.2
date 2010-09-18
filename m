Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579Ab0IRSbS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 14:31:18 -0400
Received: from relay01.mx.bawue.net ([193.7.176.67]:58190 "EHLO
	relay01.mx.bawue.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280Ab0IRSbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 14:31:17 -0400
From: Nils Radtke <lkml@Think-Future.com>
To: gregkh@suse.de
Cc: kernel-janitors@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: wlan-ng: p80211netdev.c cleanup
Date: Sat, 18 Sep 2010 20:30:52 +0200
Message-Id: <1284834652-26171-1-git-send-email-lkml@Think-Future.com>
X-Mailer: git-send-email 1.7.1
X-Bkp: p2mi
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Effected preliminary cleanup lead by the idea of kerneljanitor.org .
As recommended I'm asking for approval of the location of cleanup
and the manner it happened to know I'm heading in the right
direction.

Compiles. Not tested.

Signed-off-by: Nils Radtke <lkml@Think-Future.com>
---
 drivers/staging/wlan-ng/p80211netdev.c |   50 +++++++++++++++++++-------------
 1 files changed, 30 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/wlan-ng/p80211netdev.c b/drivers/staging/wlan-ng/p80211netdev.c
index aa1792c..8104e11 100644
--- a/drivers/staging/wlan-ng/p80211netdev.c
+++ b/drivers/staging/wlan-ng/p80211netdev.c
@@ -176,25 +176,30 @@ static struct net_device_stats *p80211knetdev_get_stats(netdevice_t * netdev)
 ----------------------------------------------------------------*/
 static int p80211knetdev_open(netdevice_t *netdev)
 {
-	int result = 0;		/* success */
+	int ret = 0;
 	wlandevice_t *wlandev = netdev->ml_priv;
 
 	/* Check to make sure the MSD is running */
-	if (wlandev->msdstate != WLAN_MSD_RUNNING)
-		return -ENODEV;
+	if (wlandev->msdstate != WLAN_MSD_RUNNING) {
+		ret = -ENODEV;
+		goto end;
+	}
 
 	/* Tell the MSD to open */
-	if (wlandev->open != NULL) {
-		result = wlandev->open(wlandev);
-		if (result == 0) {
-			netif_start_queue(wlandev->netdev);
-			wlandev->state = WLAN_DEVICE_OPEN;
-		}
-	} else {
-		result = -EAGAIN;
+	if (wlandev->open == NULL) {
+		printk(KERN_ERR "Sorry, got wlandev->open == NULL.\n");
+		ret = -EAGAIN;
+		goto end;
 	}
 
-	return result;
+	ret = wlandev->open(wlandev);
+	if (ret) {
+		netif_start_queue(wlandev->netdev);
+		wlandev->state = WLAN_DEVICE_OPEN;
+	}
+
+end:
+	return ret;
 }
 
 /*----------------------------------------------------------------
@@ -211,16 +216,23 @@ static int p80211knetdev_open(netdevice_t *netdev)
 ----------------------------------------------------------------*/
 static int p80211knetdev_stop(netdevice_t *netdev)
 {
-	int result = 0;
+	int ret = -EFAULT;
 	wlandevice_t *wlandev = netdev->ml_priv;
 
-	if (wlandev->close != NULL)
-		result = wlandev->close(wlandev);
+	if (wlandev->close == NULL) {
+		printk(KERN_ERR "Sorry, got wlandev->close == NULL.\n");
+		ret = -EFAULT; /* FIXME: nr: correct return code? */
+		goto end;
+	}
 
-	netif_stop_queue(wlandev->netdev);
-	wlandev->state = WLAN_DEVICE_CLOSED;
+	ret = wlandev->close(wlandev);
+	if (ret) {
+		netif_stop_queue(wlandev->netdev);
+		wlandev->state = WLAN_DEVICE_CLOSED;
+	}
 
-	return result;
+end:
+	return ret;
 }
 
 /*----------------------------------------------------------------
@@ -242,8 +254,6 @@ void p80211netdev_rx(wlandevice_t *wlandev, struct sk_buff *skb)
 	skb_queue_tail(&wlandev->nsd_rxq, skb);
 
 	tasklet_schedule(&wlandev->rx_bh);
-
-	return;
 }
 
 /*----------------------------------------------------------------
-- 
1.7.1

