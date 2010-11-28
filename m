Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab0K1VCF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 16:02:05 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:37630 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782Ab0K1VAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 16:00:12 -0500
From: Pekka Enberg <penberg@kernel.org>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 05/13] w35und: Use pr_debug() for debugging
Date: Sun, 28 Nov 2010 23:00:00 +0200
Message-Id: <1290978008-29095-5-git-send-email-penberg@kernel.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1290978008-29095-1-git-send-email-penberg@kernel.org>
References: <1290978008-29095-1-git-send-email-penberg@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use pr_debug() for debugging printk's and kill the FULL_DEBUG macro. It would
be even better to use dev_dbg() but unfortunately looking up struct device in
the current code structure makes things very ugly.

Please note that I dropped the DataDmp() calls from
RFSynthesizer_SwitchingChannel() because that function doesn't exist.

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
 drivers/staging/winbond/mds.c     |   16 ++++------------
 drivers/staging/winbond/reg.c     |   27 +++++----------------------
 drivers/staging/winbond/sysdef.h  |   12 ------------
 drivers/staging/winbond/wb35reg.c |   20 +++++---------------
 drivers/staging/winbond/wb35rx.c  |   21 +++++----------------
 drivers/staging/winbond/wb35tx.c  |   16 ++++------------
 drivers/staging/winbond/wbusb.c   |   13 +++----------
 7 files changed, 26 insertions(+), 99 deletions(-)

diff --git a/drivers/staging/winbond/mds.c b/drivers/staging/winbond/mds.c
index 90f2cc0..8ae3d84 100644
--- a/drivers/staging/winbond/mds.c
+++ b/drivers/staging/winbond/mds.c
@@ -346,9 +346,7 @@ static void Mds_HeaderCopy(struct wbsoft_priv *adapter, struct wb35_descriptor *
 	ctmp1 = ctmpf = CURRENT_TX_RATE_FOR_MNG;
 
 	pDes->TxRate = ctmp1;
-	#ifdef _PE_TX_DUMP_
-	printk("Tx rate =%x\n", ctmp1);
-	#endif
+	pr_debug("Tx rate =%x\n", ctmp1);
 
 	pT01->T01_modulation_type = (ctmp1%3) ? 0 : 1;
 
@@ -426,9 +424,7 @@ Mds_Tx(struct wbsoft_priv *adapter)
 	do {
 		FillIndex = pMds->TxFillIndex;
 		if (pMds->TxOwner[FillIndex]) { /* Is owned by software 0:Yes 1:No */
-#ifdef _PE_TX_DUMP_
-			printk("[Mds_Tx] Tx Owner is H/W.\n");
-#endif
+			pr_debug("[Mds_Tx] Tx Owner is H/W.\n");
 			break;
 		}
 
@@ -472,9 +468,7 @@ Mds_Tx(struct wbsoft_priv *adapter)
 
 			/* For speed up Key setting */
 			if (pTxDes->EapFix) {
-#ifdef _PE_TX_DUMP_
-				printk("35: EPA 4th frame detected. Size = %d\n", PacketSize);
-#endif
+				pr_debug("35: EPA 4th frame detected. Size = %d\n", PacketSize);
 				pHwData->IsKeyPreSet = 1;
 			}
 
@@ -563,9 +557,7 @@ Mds_SendComplete(struct wbsoft_priv *adapter, struct T02_descriptor *pT02)
 					pHwData->tx_retry_count[RetryCount] += RetryCount;
 				else
 					pHwData->tx_retry_count[7] += RetryCount;
-				#ifdef _PE_STATE_DUMP_
-				printk("dto_tx_retry_count =%d\n", pHwData->dto_tx_retry_count);
-				#endif
+				pr_debug("dto_tx_retry_count =%d\n", pHwData->dto_tx_retry_count);
 				MTO_SetTxCount(adapter, TxRate, RetryCount);
 			}
 			pHwData->dto_tx_frag_count += (RetryCount+1);
diff --git a/drivers/staging/winbond/reg.c b/drivers/staging/winbond/reg.c
index 439d213..dcd7560 100644
--- a/drivers/staging/winbond/reg.c
+++ b/drivers/staging/winbond/reg.c
@@ -1012,9 +1012,7 @@ void RFSynthesizer_initial(struct hw_data *pHwData)
 	case RF_AIROHA_7230:
 		/* Start to fill RF parameters, PLL_ON should be pulled low. */
 		Wb35Reg_WriteSync(pHwData, 0x03dc, 0x00000000);
-		#ifdef _PE_STATE_DUMP_
-		printk("* PLL_ON    low\n");
-		#endif
+		pr_debug("* PLL_ON    low\n");
 		number = ARRAY_SIZE(al7230_rf_data_24);
 		Set_ChanIndep_RfData_al7230_24(pHwData, pltmp, number);
 		break;
@@ -1100,9 +1098,7 @@ void RFSynthesizer_initial(struct hw_data *pHwData)
 	case RF_AIROHA_7230:
 		/* RF parameters have filled completely, PLL_ON should be pulled high */
 		Wb35Reg_WriteSync(pHwData, 0x03dc, 0x00000080);
-		#ifdef _PE_STATE_DUMP_
-		printk("* PLL_ON    high\n");
-		#endif
+		pr_debug("* PLL_ON    high\n");
 
 		/* 2.4GHz */
 		ltmp = (1 << 31) | (0 << 30) | (24 << 24) | 0x9ABA8F;
@@ -1117,9 +1113,7 @@ void RFSynthesizer_initial(struct hw_data *pHwData)
 
 		/* 5GHz */
 		Wb35Reg_WriteSync(pHwData, 0x03dc, 0x00000000);
-		#ifdef _PE_STATE_DUMP_
-		printk("* PLL_ON    low\n");
-		#endif
+		pr_debug("* PLL_ON    low\n");
 
 		number = ARRAY_SIZE(al7230_rf_data_50);
 		Set_ChanIndep_RfData_al7230_50(pHwData, pltmp, number);
@@ -1129,9 +1123,7 @@ void RFSynthesizer_initial(struct hw_data *pHwData)
 		msleep(5);
 
 		Wb35Reg_WriteSync(pHwData, 0x03dc, 0x00000080);
-		#ifdef _PE_STATE_DUMP_
-		printk("* PLL_ON    high\n");
-		#endif
+		pr_debug("* PLL_ON    high\n");
 
 		ltmp = (1 << 31) | (0 << 30) | (24 << 24) | 0x9ABA8F;
 		Wb35Reg_WriteSync(pHwData, 0x0864, ltmp);
@@ -1797,9 +1789,7 @@ void RFSynthesizer_SwitchingChannel(struct hw_data *pHwData,  struct chan_info C
 
 			/* Write to register. number must less and equal than 16 */
 			Wb35Reg_BurstWrite(pHwData, 0x0864, pltmp, number, NO_INCREMENT);
-			#ifdef _PE_STATE_DUMP_
-			printk("Band changed\n");
-			#endif
+			pr_debug("Band changed\n");
 		}
 
 		if (Channel.band <= BAND_TYPE_OFDM_24) { /* channel 1 ~ 14 */
@@ -2338,13 +2328,6 @@ void EEPROMTxVgaAdjust(struct hw_data *pHwData)
 		pHwData->TxVgaFor50[32].TxVgaValue = pTxVga[17] - stmp * 2 / 4;
 		pHwData->TxVgaFor50[31].TxVgaValue = pTxVga[17] - stmp * 3 / 4;
 	}
-
-	#ifdef _PE_STATE_DUMP_
-	printk(" TxVgaFor24 :\n");
-	DataDmp((u8 *)pHwData->TxVgaFor24, 14 , 0);
-	printk(" TxVgaFor50 :\n");
-	DataDmp((u8 *)pHwData->TxVgaFor50, 70 , 0);
-	#endif
 }
 
 void BBProcessor_RateChanging(struct hw_data *pHwData,  u8 rate)
diff --git a/drivers/staging/winbond/sysdef.h b/drivers/staging/winbond/sysdef.h
index 8d4ebe1..04e6e8f 100644
--- a/drivers/staging/winbond/sysdef.h
+++ b/drivers/staging/winbond/sysdef.h
@@ -3,16 +3,4 @@
 #ifndef SYS_DEF_H
 #define SYS_DEF_H
 
-/* debug print options, mark what debug you don't need */
-
-#ifdef FULL_DEBUG
-#define _PE_STATE_DUMP_
-#define _PE_TX_DUMP_
-#define _PE_RX_DUMP_
-#define _PE_OID_DUMP_
-#define _PE_DTO_DUMP_
-#define _PE_REG_DUMP_
-#define _PE_USB_INI_DUMP_
-#endif
-
 #endif
diff --git a/drivers/staging/winbond/wb35reg.c b/drivers/staging/winbond/wb35reg.c
index 7707223..f33f4f8 100644
--- a/drivers/staging/winbond/wb35reg.c
+++ b/drivers/staging/winbond/wb35reg.c
@@ -150,9 +150,7 @@ unsigned char Wb35Reg_WriteSync(struct hw_data *pHwData, u16 RegisterNo, u32 Reg
 	Wb35Reg_EP0VM_start(pHwData);
 
 	if (ret < 0) {
-#ifdef _PE_REG_DUMP_
-		printk("EP0 Write register usb message sending error\n");
-#endif
+		pr_debug("EP0 Write register usb message sending error\n");
 		pHwData->SurpriseRemove = 1;
 		return false;
 	}
@@ -320,9 +318,7 @@ unsigned char Wb35Reg_ReadSync(struct hw_data *pHwData, u16 RegisterNo, u32 *pRe
 	Wb35Reg_EP0VM_start(pHwData);
 
 	if (ret < 0) {
-#ifdef _PE_REG_DUMP_
-		printk("EP0 Read register usb message sending error\n");
-#endif
+		pr_debug("EP0 Read register usb message sending error\n");
 		pHwData->SurpriseRemove = 1;
 		return false;
 	}
@@ -442,9 +438,7 @@ void Wb35Reg_EP0VM(struct hw_data *pHwData)
 	ret = usb_submit_urb(urb, GFP_ATOMIC);
 
 	if (ret < 0) {
-#ifdef _PE_REG_DUMP_
-		printk("EP0 Irp sending error\n");
-#endif
+		pr_debug("EP0 Irp sending error\n");
 		goto cleanup;
 	}
 	return;
@@ -479,9 +473,7 @@ void Wb35Reg_EP0VM_complete(struct urb *urb)
 		spin_unlock_irq(&reg->EP0VM_spin_lock);
 
 		if (reg->EP0VM_status) {
-#ifdef _PE_REG_DUMP_
-			printk("EP0 IoCompleteRoutine return error\n");
-#endif
+			pr_debug("EP0 IoCompleteRoutine return error\n");
 			reg->EP0vm_state = VM_STOP;
 			pHwData->SurpriseRemove = 1;
 		} else {
@@ -526,9 +518,7 @@ void Wb35Reg_destroy(struct hw_data *pHwData)
 			usb_free_urb(urb);
 			kfree(reg_queue);
 		} else {
-#ifdef _PE_REG_DUMP_
-			printk("EP0 queue release error\n");
-#endif
+			pr_debug("EP0 queue release error\n");
 		}
 		spin_lock_irq(&reg->EP0VM_spin_lock);
 
diff --git a/drivers/staging/winbond/wb35rx.c b/drivers/staging/winbond/wb35rx.c
index 5af271f..0255728 100644
--- a/drivers/staging/winbond/wb35rx.c
+++ b/drivers/staging/winbond/wb35rx.c
@@ -109,10 +109,7 @@ static u16 Wb35Rx_indicate(struct ieee80211_hw *hw)
 
 			/* Basic check for Rx length. Is length valid? */
 			if (PacketSize > MAX_PACKET_SIZE) {
-#ifdef _PE_RX_DUMP_
-				printk("Serious ERROR : Rx data size too long, size =%d\n", PacketSize);
-#endif
-
+				pr_debug("Serious ERROR : Rx data size too long, size =%d\n", PacketSize);
 				pWb35Rx->EP3vm_state = VM_STOP;
 				pWb35Rx->Ep3ErrorCount2++;
 				break;
@@ -186,9 +183,7 @@ static void Wb35Rx_Complete(struct urb *urb)
 
 	/* The URB is completed, check the result */
 	if (pWb35Rx->EP3VM_status != 0) {
-#ifdef _PE_USB_STATE_DUMP_
-		printk("EP3 IoCompleteRoutine return error\n");
-#endif
+		pr_debug("EP3 IoCompleteRoutine return error\n");
 		pWb35Rx->EP3vm_state = VM_STOP;
 		goto error;
 	}
@@ -249,9 +244,7 @@ static void Wb35Rx(struct ieee80211_hw *hw)
 	RxBufferId = pWb35Rx->RxBufferId;
 	if (!pWb35Rx->RxOwner[RxBufferId]) {
 		/* It's impossible to run here. */
-#ifdef _PE_RX_DUMP_
-		printk("Rx driver fifo unavailable\n");
-#endif
+		pr_debug("Rx driver fifo unavailable\n");
 		goto error;
 	}
 
@@ -337,9 +330,7 @@ void Wb35Rx_stop(struct hw_data *pHwData)
 	/* Canceling the Irp if already sends it out. */
 	if (pWb35Rx->EP3vm_state == VM_RUNNING) {
 		usb_unlink_urb(pWb35Rx->RxUrb); /* Only use unlink, let Wb35Rx_destroy to free them */
-#ifdef _PE_RX_DUMP_
-		printk("EP3 Rx stop\n");
-#endif
+		pr_debug("EP3 Rx stop\n");
 	}
 }
 
@@ -355,8 +346,6 @@ void Wb35Rx_destroy(struct hw_data *pHwData)
 
 	if (pWb35Rx->RxUrb)
 		usb_free_urb(pWb35Rx->RxUrb);
-#ifdef _PE_RX_DUMP_
-	printk("Wb35Rx_destroy OK\n");
-#endif
+	pr_debug("Wb35Rx_destroy OK\n");
 }
 
diff --git a/drivers/staging/winbond/wb35tx.c b/drivers/staging/winbond/wb35tx.c
index fd52554..8f0d527 100644
--- a/drivers/staging/winbond/wb35tx.c
+++ b/drivers/staging/winbond/wb35tx.c
@@ -153,16 +153,12 @@ void Wb35Tx_stop(struct hw_data * pHwData)
 	// Trying to canceling the Trp of EP2
 	if (pWb35Tx->EP2vm_state == VM_RUNNING)
 		usb_unlink_urb( pWb35Tx->Tx2Urb ); // Only use unlink, let Wb35Tx_destrot to free them
-	#ifdef _PE_TX_DUMP_
-	printk("EP2 Tx stop\n");
-	#endif
+	pr_debug("EP2 Tx stop\n");
 
 	// Trying to canceling the Irp of EP4
 	if (pWb35Tx->EP4vm_state == VM_RUNNING)
 		usb_unlink_urb( pWb35Tx->Tx4Urb ); // Only use unlink, let Wb35Tx_destrot to free them
-	#ifdef _PE_TX_DUMP_
-	printk("EP4 Tx stop\n");
-	#endif
+	pr_debug("EP4 Tx stop\n");
 }
 
 //======================================================
@@ -182,9 +178,7 @@ void Wb35Tx_destroy(struct hw_data * pHwData)
 	if (pWb35Tx->Tx2Urb)
 		usb_free_urb( pWb35Tx->Tx2Urb );
 
-	#ifdef _PE_TX_DUMP_
-	printk("Wb35Tx_destroy OK\n");
-	#endif
+	pr_debug("Wb35Tx_destroy OK\n");
 }
 
 void Wb35Tx_CurrentTime(struct wbsoft_priv *adapter, u32 TimeCount)
@@ -279,9 +273,7 @@ static void Wb35Tx_EP2VM(struct wbsoft_priv *adapter)
 	retv = usb_submit_urb(pUrb, GFP_ATOMIC);
 
 	if (retv < 0) {
-		#ifdef _PE_TX_DUMP_
-		printk("EP2 Tx Irp sending error\n");
-		#endif
+		pr_debug("EP2 Tx Irp sending error\n");
 		goto error;
 	}
 
diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
index dcb6d5b..5f54b0f 100644
--- a/drivers/staging/winbond/wbusb.c
+++ b/drivers/staging/winbond/wbusb.c
@@ -184,10 +184,7 @@ static void hal_set_current_channel_ex(struct hw_data *pHwData, struct chan_info
 	RFSynthesizer_SwitchingChannel(pHwData, channel); /* Switch channel */
 	pHwData->Channel = channel.ChanNo;
 	pHwData->band = channel.band;
-#ifdef _PE_STATE_DUMP_
-	printk("Set channel is %d, band =%d\n", pHwData->Channel,
-	       pHwData->band);
-#endif
+	pr_debug("Set channel is %d, band =%d\n", pHwData->Channel, pHwData->band);
 	reg->M28_MacControl &= ~0xff;	/* Clean channel information field */
 	reg->M28_MacControl |= channel.ChanNo;
 	Wb35Reg_WriteWithCallbackValue(pHwData, 0x0828, reg->M28_MacControl,
@@ -728,9 +725,7 @@ static int wb35_hw_init(struct ieee80211_hw *hw)
 	}
 
 	priv->sLocalPara.bAntennaNo = hal_get_antenna_number(pHwData);
-#ifdef _PE_STATE_DUMP_
-	printk("Driver init, antenna no = %d\n", psLOCAL->bAntennaNo);
-#endif
+	pr_debug("Driver init, antenna no = %d\n", priv->sLocalPara.bAntennaNo);
 	hal_get_hw_radio_off(pHwData);
 
 	/* Waiting for HAL setting OK */
@@ -856,9 +851,7 @@ static void wb35_hw_halt(struct wbsoft_priv *adapter)
 {
 	/* Turn off Rx and Tx hardware ability */
 	hal_stop(&adapter->sHwData);
-#ifdef _PE_USB_INI_DUMP_
-	printk("[w35und] Hal_stop O.K.\n");
-#endif
+	pr_debug("[w35und] Hal_stop O.K.\n");
 	/* Waiting Irp completed */
 	msleep(100);
 
-- 
1.7.0.4

