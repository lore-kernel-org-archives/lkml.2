Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab0ISKBK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 06:01:10 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:34690 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab0ISKBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 06:01:08 -0400
From: Pekka Enberg <penberg@kernel.org>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Lars Lindley <lindley@coyote.org>, Pavel Machek <pavel@ucw.cz>,
        Ruslan Pisarev <ruslan@rpisarev.org.ua>
Subject: [PATCH 2/2] w35und: Inline MLMESendFrame() to wbsoft_tx()
Date: Sun, 19 Sep 2010 13:01:03 +0300
Message-Id: <1284890463-14048-2-git-send-email-penberg@kernel.org>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1284890463-14048-1-git-send-email-penberg@kernel.org>
References: <1284890463-14048-1-git-send-email-penberg@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The wbsoft_tx() function is a simple wrapper on top of MLMESendFrame() so
inline the latter to the former.

Cc: Lars Lindley <lindley@coyote.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Ruslan Pisarev <ruslan@rpisarev.org.ua>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
 drivers/staging/winbond/mlmetxrx.c   |   25 -------------------------
 drivers/staging/winbond/mlmetxrx_f.h |    1 -
 drivers/staging/winbond/wbusb.c      |   21 ++++++++++++++++++++-
 3 files changed, 20 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/winbond/mlmetxrx.c b/drivers/staging/winbond/mlmetxrx.c
index 6b28898..7425a23 100644
--- a/drivers/staging/winbond/mlmetxrx.c
+++ b/drivers/staging/winbond/mlmetxrx.c
@@ -19,31 +19,6 @@
 
 #include "mds_f.h"
 
-#include <linux/netdevice.h>
-
-int MLMESendFrame(struct wbsoft_priv *adapter, u8 *pMMPDU, u16 len, u8 DataType)
-{
-	if (adapter->sMlmeFrame.IsInUsed != PACKET_FREE_TO_USE) {
-		adapter->sMlmeFrame.wNumTxMMPDUDiscarded++;
-		return NETDEV_TX_BUSY;
-	}
-	adapter->sMlmeFrame.IsInUsed = PACKET_COME_FROM_MLME;
-
-	/* Keep information for sending */
-	adapter->sMlmeFrame.pMMPDU = pMMPDU;
-	adapter->sMlmeFrame.DataType = DataType;
-	/* len must be the last setting due to QUERY_SIZE_SECOND of Mds */
-	adapter->sMlmeFrame.len = len;
-	adapter->sMlmeFrame.wNumTxMMPDU++;
-
-	/* H/W will enter power save by set the register. S/W don't send null frame
-	with PWRMgt bit enbled to enter power save now. */
-
-	Mds_Tx(adapter);
-
-	return NETDEV_TX_OK;
-}
-
 void MLME_GetNextPacket(struct wbsoft_priv *adapter, struct wb35_descriptor *desc)
 {
 	desc->InternalUsed = desc->buffer_start_index + desc->buffer_number;
diff --git a/drivers/staging/winbond/mlmetxrx_f.h b/drivers/staging/winbond/mlmetxrx_f.h
index ddccbc2..012507f 100644
--- a/drivers/staging/winbond/mlmetxrx_f.h
+++ b/drivers/staging/winbond/mlmetxrx_f.h
@@ -11,7 +11,6 @@
 #include "core.h"
 
 void MLME_GetNextPacket(struct wbsoft_priv *adapter, struct wb35_descriptor *pDes);
-int MLMESendFrame(struct wbsoft_priv *adapter, u8 *pMMPDU, u16 len, u8 DataType);
 
 void
 MLME_SendComplete(struct wbsoft_priv *adapter, u8 PacketID,
diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
index 157c05b..3f60cf7 100644
--- a/drivers/staging/winbond/wbusb.c
+++ b/drivers/staging/winbond/wbusb.c
@@ -121,7 +121,26 @@ static int wbsoft_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
 {
 	struct wbsoft_priv *priv = dev->priv;
 
-	return MLMESendFrame(priv, skb->data, skb->len, FRAME_TYPE_802_11_MANAGEMENT);
+	if (priv->sMlmeFrame.IsInUsed != PACKET_FREE_TO_USE) {
+		priv->sMlmeFrame.wNumTxMMPDUDiscarded++;
+		return NETDEV_TX_BUSY;
+	}
+
+	priv->sMlmeFrame.IsInUsed = PACKET_COME_FROM_MLME;
+
+	priv->sMlmeFrame.pMMPDU		= skb->data;
+	priv->sMlmeFrame.DataType	= FRAME_TYPE_802_11_MANAGEMENT;
+	priv->sMlmeFrame.len		= skb->len;
+	priv->sMlmeFrame.wNumTxMMPDU++;
+
+	/*
+	 * H/W will enter power save by set the register. S/W don't send null
+	 * frame with PWRMgt bit enbled to enter power save now.
+	 */
+
+	Mds_Tx(priv);
+
+	return NETDEV_TX_OK;
 }
 
 static int wbsoft_start(struct ieee80211_hw *dev)
-- 
1.6.3.3

