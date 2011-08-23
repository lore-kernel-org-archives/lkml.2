Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075Ab1HWWmv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 18:42:51 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35482 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755907Ab1HWWmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 18:42:18 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: greg@kroah.com, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 6/8] [RESEND] staging: et131x: Fix link detection signalling
Date: Tue, 23 Aug 2011 23:40:38 +0100
Message-Id: <1314139240-869-7-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1314139240-869-1-git-send-email-mark.einon@gmail.com>
References: <1312321621-2695-1-git-send-email-mark.einon@gmail.com>
 <1314139240-869-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove redundant code around netif_carrier_XXX calls, and associated adapter->media_state, which prevented the link from being reported as off.
Tested on an ET-1310 device.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et1310_phy.c     |   26 +-------------------------
 drivers/staging/et131x/et131x_adapter.h |    6 ------
 drivers/staging/et131x/et131x_initpci.c |   23 +----------------------
 3 files changed, 2 insertions(+), 53 deletions(-)

diff --git a/drivers/staging/et131x/et1310_phy.c b/drivers/staging/et131x/et1310_phy.c
index 6eb9d5c..2c6898f 100644
--- a/drivers/staging/et131x/et1310_phy.c
+++ b/drivers/staging/et131x/et1310_phy.c
@@ -737,16 +737,6 @@ void et131x_mii_check(struct et131x_adapter *adapter,
 	if (bmsr_ints & MI_BMSR_LINK_STATUS) {
 		if (bmsr & MI_BMSR_LINK_STATUS) {
 			adapter->boot_coma = 20;
-
-			/* Update our state variables and indicate the
-			 * connected state
-			 */
-			spin_lock_irqsave(&adapter->lock, flags);
-
-			adapter->media_state = NETIF_STATUS_MEDIA_CONNECT;
-
-			spin_unlock_irqrestore(&adapter->lock, flags);
-
 			netif_carrier_on(adapter->netdev);
 		} else {
 			dev_warn(&adapter->pdev->dev,
@@ -768,21 +758,7 @@ void et131x_mii_check(struct et131x_adapter *adapter,
 				et131x_mii_write(adapter, 0x12, register18);
 			}
 
-			/* For the first N seconds of life, we are in "link
-			 * detection" When we are in this state, we should
-			 * only report "connected". When the LinkDetection
-			 * Timer expires, we can report disconnected (handled
-			 * in the LinkDetectionDPC).
-			 */
-			if (adapter->media_state == NETIF_STATUS_MEDIA_DISCONNECT) {
-				spin_lock_irqsave(&adapter->lock, flags);
-				adapter->media_state =
-				    NETIF_STATUS_MEDIA_DISCONNECT;
-				spin_unlock_irqrestore(&adapter->lock,
-						       flags);
-
-				netif_carrier_off(adapter->netdev);
-			}
+			netif_carrier_off(adapter->netdev);
 
 			adapter->linkspeed = 0;
 			adapter->duplex_mode = 0;
diff --git a/drivers/staging/et131x/et131x_adapter.h b/drivers/staging/et131x/et131x_adapter.h
index 5dfa153..762e07c 100644
--- a/drivers/staging/et131x/et131x_adapter.h
+++ b/drivers/staging/et131x/et131x_adapter.h
@@ -196,12 +196,6 @@ struct et131x_adapter {
 	u8 ai_force_duplex;	/* duplex setting */
 	u16 ai_force_speed;	/* 'Speed', user over-ride of line speed */
 	u8 flowcontrol;		/* flow control validated by the far-end */
-	enum {
-		NETIF_STATUS_INVALID = 0,
-		NETIF_STATUS_MEDIA_CONNECT,
-		NETIF_STATUS_MEDIA_DISCONNECT,
-		NETIF_STATUS_MAX
-	} media_state;
 
 	/* Minimize init-time */
 	struct timer_list error_timer;
diff --git a/drivers/staging/et131x/et131x_initpci.c b/drivers/staging/et131x/et131x_initpci.c
index 59637c6..072cfb5 100644
--- a/drivers/staging/et131x/et131x_initpci.c
+++ b/drivers/staging/et131x/et131x_initpci.c
@@ -299,27 +299,6 @@ void et131x_error_timer_handler(unsigned long data)
 }
 
 /**
- * et131x_link_detection_handler
- *
- * Timer function for link up at driver load time
- */
-void et131x_link_detection_handler(unsigned long data)
-{
-	struct et131x_adapter *adapter = (struct et131x_adapter *) data;
-	unsigned long flags;
-
-	if (adapter->media_state == 0) {
-		spin_lock_irqsave(&adapter->lock, flags);
-
-		adapter->media_state = NETIF_STATUS_MEDIA_DISCONNECT;
-
-		spin_unlock_irqrestore(&adapter->lock, flags);
-
-		netif_carrier_off(adapter->netdev);
-	}
-}
-
-/**
  * et131x_configure_global_regs	-	configure JAGCore global regs
  * @adapter: pointer to our adapter structure
  *
@@ -718,7 +697,7 @@ static int __devinit et131x_pci_setup(struct pci_dev *pdev,
 	adapter->error_timer.data = (unsigned long)adapter;
 
 	/* Initialize link state */
-	et131x_link_detection_handler((unsigned long)adapter);
+	netif_carrier_off(adapter->netdev);
 
 	/* Initialize variable for counting how long we do not have
 							link status */
-- 
1.7.6

