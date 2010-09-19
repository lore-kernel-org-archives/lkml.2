Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702Ab0ISKBU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 06:01:20 -0400
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:58210 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388Ab0ISKBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 06:01:09 -0400
From: Pekka Enberg <penberg@kernel.org>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Sandro Bonazzola <sandro.bonazzola@gmail.com>,
        Lars Lindley <lindley@coyote.org>, Pavel Machek <pavel@ucw.cz>,
        Ruslan Pisarev <ruslan@rpisarev.org.ua>
Subject: [PATCH 1/2] w35und: Use NETDEV_TX_BUSY if MLMESendFrame fails
Date: Sun, 19 Sep 2010 13:01:02 +0300
Message-Id: <1284890463-14048-1-git-send-email-penberg@kernel.org>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes MLMESendFrame to return NETDEV_TX_BUSY if MLME frame is in
use so that wbsoft_tx() doesn't blindly return NETDEV_TX_OK in that case.

Cc: Sandro Bonazzola <sandro.bonazzola@gmail.com>
Cc: Lars Lindley <lindley@coyote.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Ruslan Pisarev <ruslan@rpisarev.org.ua>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
 drivers/staging/winbond/mlmetxrx.c   |   13 ++++++-------
 drivers/staging/winbond/mlmetxrx_f.h |    3 +--
 drivers/staging/winbond/wbusb.c      |    4 +---
 3 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/winbond/mlmetxrx.c b/drivers/staging/winbond/mlmetxrx.c
index 74488c2..6b28898 100644
--- a/drivers/staging/winbond/mlmetxrx.c
+++ b/drivers/staging/winbond/mlmetxrx.c
@@ -19,14 +19,13 @@
 
 #include "mds_f.h"
 
-/* ============================================================================= */
-u8 MLMESendFrame(struct wbsoft_priv *adapter, u8 *pMMPDU, u16 len, u8 DataType)
-/*	DataType : FRAME_TYPE_802_11_MANAGEMENT, FRAME_TYPE_802_11_MANAGEMENT_CHALLENGE,
-				FRAME_TYPE_802_11_DATA */
+#include <linux/netdevice.h>
+
+int MLMESendFrame(struct wbsoft_priv *adapter, u8 *pMMPDU, u16 len, u8 DataType)
 {
 	if (adapter->sMlmeFrame.IsInUsed != PACKET_FREE_TO_USE) {
 		adapter->sMlmeFrame.wNumTxMMPDUDiscarded++;
-		return false;
+		return NETDEV_TX_BUSY;
 	}
 	adapter->sMlmeFrame.IsInUsed = PACKET_COME_FROM_MLME;
 
@@ -40,9 +39,9 @@ u8 MLMESendFrame(struct wbsoft_priv *adapter, u8 *pMMPDU, u16 len, u8 DataType)
 	/* H/W will enter power save by set the register. S/W don't send null frame
 	with PWRMgt bit enbled to enter power save now. */
 
-	/* Transmit NDIS packet */
 	Mds_Tx(adapter);
-	return true;
+
+	return NETDEV_TX_OK;
 }
 
 void MLME_GetNextPacket(struct wbsoft_priv *adapter, struct wb35_descriptor *desc)
diff --git a/drivers/staging/winbond/mlmetxrx_f.h b/drivers/staging/winbond/mlmetxrx_f.h
index d1aa261..ddccbc2 100644
--- a/drivers/staging/winbond/mlmetxrx_f.h
+++ b/drivers/staging/winbond/mlmetxrx_f.h
@@ -11,8 +11,7 @@
 #include "core.h"
 
 void MLME_GetNextPacket(struct wbsoft_priv *adapter, struct wb35_descriptor *pDes);
-u8 MLMESendFrame(struct wbsoft_priv *adapter,
-		 u8 *pMMPDU, u16 len, u8 DataType);
+int MLMESendFrame(struct wbsoft_priv *adapter, u8 *pMMPDU, u16 len, u8 DataType);
 
 void
 MLME_SendComplete(struct wbsoft_priv *adapter, u8 PacketID,
diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
index 5419f4f..157c05b 100644
--- a/drivers/staging/winbond/wbusb.c
+++ b/drivers/staging/winbond/wbusb.c
@@ -121,9 +121,7 @@ static int wbsoft_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
 {
 	struct wbsoft_priv *priv = dev->priv;
 
-	MLMESendFrame(priv, skb->data, skb->len, FRAME_TYPE_802_11_MANAGEMENT);
-
-	return NETDEV_TX_OK;
+	return MLMESendFrame(priv, skb->data, skb->len, FRAME_TYPE_802_11_MANAGEMENT);
 }
 
 static int wbsoft_start(struct ieee80211_hw *dev)
-- 
1.6.3.3

