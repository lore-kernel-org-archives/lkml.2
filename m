Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996Ab0KAU3h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 16:29:37 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:34943 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831Ab0KAU3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 16:29:34 -0400
From: Pekka Enberg <penberg@kernel.org>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 3/4] w35und: Kill struct hwdata ->HwStop
Date: Mon,  1 Nov 2010 22:29:30 +0200
Message-Id: <1288643371-10310-3-git-send-email-penberg@kernel.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1288643371-10310-1-git-send-email-penberg@kernel.org>
References: <1288643371-10310-1-git-send-email-penberg@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch kills the ->HwStop member of struct hwdata. It's a read-only
variable that's always zero so it's safe to remove it.

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
 drivers/staging/winbond/wb35rx.c |    4 ++--
 drivers/staging/winbond/wb35tx.c |    8 ++++----
 drivers/staging/winbond/wbhal.h  |    3 ---
 3 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/winbond/wb35rx.c b/drivers/staging/winbond/wb35rx.c
index 448514a..5af271f 100644
--- a/drivers/staging/winbond/wb35rx.c
+++ b/drivers/staging/winbond/wb35rx.c
@@ -174,7 +174,7 @@ static void Wb35Rx_Complete(struct urb *urb)
 	/* The IRP is completed */
 	pWb35Rx->EP3vm_state = VM_COMPLETED;
 
-	if (pHwData->SurpriseRemove || pHwData->HwStop) /* Must be here, or RxBufferId is invalid */
+	if (pHwData->SurpriseRemove) /* Must be here, or RxBufferId is invalid */
 		goto error;
 
 	if (pWb35Rx->rx_halt)
@@ -239,7 +239,7 @@ static void Wb35Rx(struct ieee80211_hw *hw)
 	u32			RxBufferId;
 
 	/* Issuing URB */
-	if (pHwData->SurpriseRemove || pHwData->HwStop)
+	if (pHwData->SurpriseRemove)
 		goto error;
 
 	if (pWb35Rx->rx_halt)
diff --git a/drivers/staging/winbond/wb35tx.c b/drivers/staging/winbond/wb35tx.c
index 2a9d055..fd52554 100644
--- a/drivers/staging/winbond/wb35tx.c
+++ b/drivers/staging/winbond/wb35tx.c
@@ -41,7 +41,7 @@ static void Wb35Tx_complete(struct urb * pUrb)
 	pWb35Tx->TxSendIndex++;
 	pWb35Tx->TxSendIndex %= MAX_USB_TX_BUFFER_NUMBER;
 
-	if (pHwData->SurpriseRemove || pHwData->HwStop) // Let WbWlanHalt to handle surprise remove
+	if (pHwData->SurpriseRemove) // Let WbWlanHalt to handle surprise remove
 		goto error;
 
 	if (pWb35Tx->tx_halt)
@@ -74,7 +74,7 @@ static void Wb35Tx(struct wbsoft_priv *adapter)
 	u32		SendIndex;
 
 
-	if (pHwData->SurpriseRemove || pHwData->HwStop)
+	if (pHwData->SurpriseRemove)
 		goto cleanup;
 
 	if (pWb35Tx->tx_halt)
@@ -222,7 +222,7 @@ static void Wb35Tx_EP2VM_complete(struct urb * pUrb)
 	pWb35Tx->EP2VM_status = pUrb->status;
 
 	// For Linux 2.4. Interrupt will always trigger
-	if (pHwData->SurpriseRemove || pHwData->HwStop) // Let WbWlanHalt to handle surprise remove
+	if (pHwData->SurpriseRemove) // Let WbWlanHalt to handle surprise remove
 		goto error;
 
 	if (pWb35Tx->tx_halt)
@@ -263,7 +263,7 @@ static void Wb35Tx_EP2VM(struct wbsoft_priv *adapter)
 	u32 *	pltmp = (u32 *)pWb35Tx->EP2_buf;
 	int		retv;
 
-	if (pHwData->SurpriseRemove || pHwData->HwStop)
+	if (pHwData->SurpriseRemove)
 		goto error;
 
 	if (pWb35Tx->tx_halt)
diff --git a/drivers/staging/winbond/wbhal.h b/drivers/staging/winbond/wbhal.h
index 6f4cd76..1c91588 100644
--- a/drivers/staging/winbond/wbhal.h
+++ b/drivers/staging/winbond/wbhal.h
@@ -511,9 +511,6 @@ struct hw_data {
 
 	/* For global timer */
 	u32		time_count;	/* TICK_TIME_100ms 1 = 100ms */
-
-	/* For error recover */
-	u32		HwStop;
 };
 
 #endif
-- 
1.7.0.4

