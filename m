Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013Ab0IKORe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 10:17:34 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50581 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577Ab0IKORc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 10:17:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=B4i5c49a/KRk0dnMFct/RO6D00LfX4cDYnWJTvG2gQHsKoYF3eAhZJiQGBCHz0gM83
         uWh0+LnW6NVzsi0ketnVEg5KUgIRM8xNLG99jJtTPUSRPDhp9TOG6oKkyWIV2YY8kczC
         WUFZz5BNNnjmLp+MoouUek87kxP6VBPU3rwdE=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH 01/10] staging: rt2860: change plain format of mac address to %pM in *printf()
Date: Sat, 11 Sep 2010 17:17:04 +0300
Message-Id: <735b00c1124fd4c2c68dfe9446ac05db9aa72fcd.1284214458.git.andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are many locations where MAC or BSSID is printed. The plain format
is used in such places. *printf() in kernel recognizes
%pM, %pMF and %pm format parameters to print out 6-byte array as MAC
address. This patch changes plain format to custom %pM which is widely
used in kernel.

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 drivers/staging/rt2860/common/ba_action.c   |    4 ++--
 drivers/staging/rt2860/common/cmm_mac_usb.c |    5 +----
 drivers/staging/rt2860/common/cmm_wpa.c     |    4 ++--
 drivers/staging/rt2860/common/mlme.c        |    7 +++----
 drivers/staging/rt2860/common/rtmp_init.c   |   12 +++---------
 drivers/staging/rt2860/rt_linux.c           |    4 +---
 drivers/staging/rt2860/rt_linux.h           |    3 ---
 drivers/staging/rt2860/sta/assoc.c          |    7 ++-----
 drivers/staging/rt2860/sta/connect.c        |   24 ++++++------------------
 drivers/staging/rt2860/sta/rtmp_data.c      |    4 ++--
 drivers/staging/rt2860/sta/sync.c           |   12 +++++-------
 drivers/staging/rt2860/sta_ioctl.c          |   11 +++--------
 12 files changed, 30 insertions(+), 67 deletions(-)

diff --git a/drivers/staging/rt2860/common/ba_action.c b/drivers/staging/rt2860/common/ba_action.c
index 174f2a7..3f71c50 100644
--- a/drivers/staging/rt2860/common/ba_action.c
+++ b/drivers/staging/rt2860/common/ba_action.c
@@ -654,8 +654,8 @@ BOOLEAN BARecSessionAdd(struct rt_rtmp_adapter *pAd,
 	} else {
 		Status = FALSE;
 		DBGPRINT(RT_DEBUG_TRACE,
-			 ("Can't Accept ADDBA for %02x:%02x:%02x:%02x:%02x:%02x TID = %d\n",
-			  PRINT_MAC(pEntry->Addr), TID));
+			("Can't Accept ADDBA for %pM TID = %d\n",
+				&pEntry->Addr[0], TID));
 	}
 	return (Status);
 }
diff --git a/drivers/staging/rt2860/common/cmm_mac_usb.c b/drivers/staging/rt2860/common/cmm_mac_usb.c
index 8aec70f..d08abf7 100644
--- a/drivers/staging/rt2860/common/cmm_mac_usb.c
+++ b/drivers/staging/rt2860/common/cmm_mac_usb.c
@@ -663,10 +663,7 @@ int RTUSBWriteHWMACAddress(struct rt_rtmp_adapter *pAd)
 	StaMacReg1.field.Byte5 = pAd->CurrentAddress[5];
 	StaMacReg1.field.U2MeMask = 0xff;
 	DBGPRINT_RAW(RT_DEBUG_TRACE,
-		     ("Local MAC = %02x:%02x:%02x:%02x:%02x:%02x\n",
-		      pAd->CurrentAddress[0], pAd->CurrentAddress[1],
-		      pAd->CurrentAddress[2], pAd->CurrentAddress[3],
-		      pAd->CurrentAddress[4], pAd->CurrentAddress[5]));
+		("Local MAC = %pM\n", &pAd->CurrentAddress[0]));
 
 	RTUSBWriteMACRegister(pAd, MAC_ADDR_DW0, StaMacReg0.word);
 	RTUSBWriteMACRegister(pAd, MAC_ADDR_DW1, StaMacReg1.word);
diff --git a/drivers/staging/rt2860/common/cmm_wpa.c b/drivers/staging/rt2860/common/cmm_wpa.c
index 9414aa3..78ca4ed 100644
--- a/drivers/staging/rt2860/common/cmm_wpa.c
+++ b/drivers/staging/rt2860/common/cmm_wpa.c
@@ -221,8 +221,8 @@ void WpaEAPOLKeyAction(struct rt_rtmp_adapter *pAd, struct rt_mlme_queue_elem *E
 			break;
 
 		DBGPRINT(RT_DEBUG_TRACE,
-			 ("Receive EAPoL-Key frame from STA %02X-%02X-%02X-%02X-%02X-%02X\n",
-			  PRINT_MAC(pEntry->Addr)));
+			("Receive EAPoL-Key frame from STA %pMF\n",
+				&pEntry->Addr[0]));
 
 		if (((pEapol_packet->ProVer != EAPOL_VER)
 		     && (pEapol_packet->ProVer != EAPOL_VER2))
diff --git a/drivers/staging/rt2860/common/mlme.c b/drivers/staging/rt2860/common/mlme.c
index 9fc34a8..e514033 100644
--- a/drivers/staging/rt2860/common/mlme.c
+++ b/drivers/staging/rt2860/common/mlme.c
@@ -1536,10 +1536,9 @@ void MlmeAutoReconnectLastSSID(struct rt_rtmp_adapter *pAd)
 {
 	if (pAd->StaCfg.bAutoConnectByBssid) {
 		DBGPRINT(RT_DEBUG_TRACE,
-			 ("Driver auto reconnect to last OID_802_11_BSSID setting - %02X:%02X:%02X:%02X:%02X:%02X\n",
-			  pAd->MlmeAux.Bssid[0], pAd->MlmeAux.Bssid[1],
-			  pAd->MlmeAux.Bssid[2], pAd->MlmeAux.Bssid[3],
-			  pAd->MlmeAux.Bssid[4], pAd->MlmeAux.Bssid[5]));
+			("Driver auto reconnect to last OID_802_11_BSSID "
+				"setting - %pM\n",
+				&pAd->MlmeAux.Bssid[0]));
 
 		pAd->MlmeAux.Channel = pAd->CommonCfg.Channel;
 		MlmeEnqueue(pAd,
diff --git a/drivers/staging/rt2860/common/rtmp_init.c b/drivers/staging/rt2860/common/rtmp_init.c
index ff9f87c..afeb528 100644
--- a/drivers/staging/rt2860/common/rtmp_init.c
+++ b/drivers/staging/rt2860/common/rtmp_init.c
@@ -749,13 +749,7 @@ void NICReadEEPROMParameters(struct rt_rtmp_adapter *pAd, u8 *mac_addr)
 		/*      pAd->PermanentAddress[5] = RandomByte(pAd)&0xf8; */
 
 		DBGPRINT_RAW(RT_DEBUG_TRACE,
-			     ("E2PROM MAC: =%02x:%02x:%02x:%02x:%02x:%02x\n",
-			      pAd->PermanentAddress[0],
-			      pAd->PermanentAddress[1],
-			      pAd->PermanentAddress[2],
-			      pAd->PermanentAddress[3],
-			      pAd->PermanentAddress[4],
-			      pAd->PermanentAddress[5]));
+			("E2PROM MAC: =%pM\n", &pAd->PermanentAddress[0]));
 		if (pAd->bLocalAdminMAC == FALSE) {
 			MAC_DW0_STRUC csr2;
 			MAC_DW1_STRUC csr3;
@@ -772,8 +766,8 @@ void NICReadEEPROMParameters(struct rt_rtmp_adapter *pAd, u8 *mac_addr)
 			csr3.field.U2MeMask = 0xff;
 			RTMP_IO_WRITE32(pAd, MAC_ADDR_DW1, csr3.word);
 			DBGPRINT_RAW(RT_DEBUG_TRACE,
-				     ("E2PROM MAC: =%02x:%02x:%02x:%02x:%02x:%02x\n",
-				      PRINT_MAC(pAd->PermanentAddress)));
+				("E2PROM MAC: =%pM\n",
+					&pAd->PermanentAddress[0]));
 		}
 	}
 
diff --git a/drivers/staging/rt2860/rt_linux.c b/drivers/staging/rt2860/rt_linux.c
index 5b79f65..abfeea1 100644
--- a/drivers/staging/rt2860/rt_linux.c
+++ b/drivers/staging/rt2860/rt_linux.c
@@ -682,9 +682,7 @@ void RTMPSendWirelessEvent(struct rt_rtmp_adapter *pAd,
 
 		if (pAddr)
 			pBufPtr +=
-			    sprintf(pBufPtr,
-				    "(RT2860) STA(%02x:%02x:%02x:%02x:%02x:%02x) ",
-				    PRINT_MAC(pAddr));
+			    sprintf(pBufPtr, "(RT2860) STA(%pM) ", pAddr);
 		else if (BssIdx < MAX_MBSSID_NUM)
 			pBufPtr +=
 			    sprintf(pBufPtr, "(RT2860) BSS(wlan%d) ", BssIdx);
diff --git a/drivers/staging/rt2860/rt_linux.h b/drivers/staging/rt2860/rt_linux.h
index b370fb2..5acedf1 100644
--- a/drivers/staging/rt2860/rt_linux.h
+++ b/drivers/staging/rt2860/rt_linux.h
@@ -409,9 +409,6 @@ struct os_cookie {
 /***********************************************************************************
  *	OS debugging and printing related definitions and data structure
  ***********************************************************************************/
-#define PRINT_MAC(addr)	\
-	addr[0], addr[1], addr[2], addr[3], addr[4], addr[5]
-
 #ifdef DBG
 extern unsigned long RTDebugLevel;
 
diff --git a/drivers/staging/rt2860/sta/assoc.c b/drivers/staging/rt2860/sta/assoc.c
index 6e85d5e..1efd75b 100644
--- a/drivers/staging/rt2860/sta/assoc.c
+++ b/drivers/staging/rt2860/sta/assoc.c
@@ -794,11 +794,8 @@ void MlmeDisassocReqAction(struct rt_rtmp_adapter *pAd, struct rt_mlme_queue_ele
 	RTMPCancelTimer(&pAd->MlmeAux.DisassocTimer, &TimerCancelled);
 
 	DBGPRINT(RT_DEBUG_TRACE,
-		 ("ASSOC - Send DISASSOC request[BSSID::%02x:%02x:%02x:%02x:%02x:%02x (Reason=%d)\n",
-		  pDisassocReq->Addr[0], pDisassocReq->Addr[1],
-		  pDisassocReq->Addr[2], pDisassocReq->Addr[3],
-		  pDisassocReq->Addr[4], pDisassocReq->Addr[5],
-		  pDisassocReq->Reason));
+		("ASSOC - Send DISASSOC request[BSSID::%pM (Reason=%d)\n",
+			&pDisassocReq->Addr[0], pDisassocReq->Reason));
 	MgtMacHeaderInit(pAd, &DisassocHdr, SUBTYPE_DISASSOC, 0, pDisassocReq->Addr, pDisassocReq->Addr);	/* patch peap ttls switching issue */
 	MakeOutgoingFrame(pOutBuffer, &FrameLen,
 			  sizeof(struct rt_header_802_11), &DisassocHdr,
diff --git a/drivers/staging/rt2860/sta/connect.c b/drivers/staging/rt2860/sta/connect.c
index 55732b1..05b4af6 100644
--- a/drivers/staging/rt2860/sta/connect.c
+++ b/drivers/staging/rt2860/sta/connect.c
@@ -653,10 +653,8 @@ void CntlOidRTBssidProc(struct rt_rtmp_adapter *pAd, struct rt_mlme_queue_elem *
 			   RTMPMakeRSNIE(pAd, pAd->StaCfg.AuthMode, pAd->StaCfg.WepStatus, 0);
 			   } */
 			/* No active association, join the BSS immediately */
-			DBGPRINT(RT_DEBUG_TRACE,
-				 ("CNTL - joining %02x:%02x:%02x:%02x:%02x:%02x ...\n",
-				  pOidBssid[0], pOidBssid[1], pOidBssid[2],
-				  pOidBssid[3], pOidBssid[4], pOidBssid[5]));
+			DBGPRINT(RT_DEBUG_TRACE, ("CNTL - joining %pM ...\n",
+					&pOidBssid[0]));
 
 			JoinParmFill(pAd, &JoinReq, pAd->MlmeAux.BssIdx);
 			MlmeEnqueue(pAd, SYNC_STATE_MACHINE, MT2_MLME_JOIN_REQ,
@@ -778,13 +776,8 @@ void CntlWaitJoinProc(struct rt_rtmp_adapter *pAd, struct rt_mlme_queue_elem *El
 				LinkUp(pAd, BSS_ADHOC);
 				pAd->Mlme.CntlMachine.CurrState = CNTL_IDLE;
 				DBGPRINT(RT_DEBUG_TRACE,
-					 ("CNTL - join the IBSS = %02x:%02x:%02x:%02x:%02x:%02x ...\n",
-					  pAd->CommonCfg.Bssid[0],
-					  pAd->CommonCfg.Bssid[1],
-					  pAd->CommonCfg.Bssid[2],
-					  pAd->CommonCfg.Bssid[3],
-					  pAd->CommonCfg.Bssid[4],
-					  pAd->CommonCfg.Bssid[5]));
+					("CNTL - join the IBSS = %pM ...\n",
+						&pAd->CommonCfg.Bssid[0]));
 
 				pAd->IndicateMediaState =
 				    NdisMediaStateConnected;
@@ -902,13 +895,8 @@ void CntlWaitStartProc(struct rt_rtmp_adapter *pAd, struct rt_mlme_queue_elem *E
 			}
 
 			DBGPRINT(RT_DEBUG_TRACE,
-				 ("CNTL - start a new IBSS = %02x:%02x:%02x:%02x:%02x:%02x ...\n",
-				  pAd->CommonCfg.Bssid[0],
-				  pAd->CommonCfg.Bssid[1],
-				  pAd->CommonCfg.Bssid[2],
-				  pAd->CommonCfg.Bssid[3],
-				  pAd->CommonCfg.Bssid[4],
-				  pAd->CommonCfg.Bssid[5]));
+				("CNTL - start a new IBSS = %pM ...\n",
+					&pAd->CommonCfg.Bssid[0]));
 		} else {
 			DBGPRINT(RT_DEBUG_TRACE,
 				 ("CNTL - Start IBSS fail. BUG!\n"));
diff --git a/drivers/staging/rt2860/sta/rtmp_data.c b/drivers/staging/rt2860/sta/rtmp_data.c
index 5d348e9..fbe903c 100644
--- a/drivers/staging/rt2860/sta/rtmp_data.c
+++ b/drivers/staging/rt2860/sta/rtmp_data.c
@@ -976,8 +976,8 @@ int STASendPacket(struct rt_rtmp_adapter *pAd, void *pPacket)
 
 	if (!pEntry) {
 		DBGPRINT(RT_DEBUG_ERROR,
-			 ("STASendPacket->Cannot find pEntry(%2x:%2x:%2x:%2x:%2x:%2x) in MacTab!\n",
-			  PRINT_MAC(pSrcBufVA)));
+			("STASendPacket->Cannot find pEntry(%pM) in MacTab!\n",
+				pSrcBufVA));
 		/* Resourece is low, system did not allocate virtual address */
 		/* return NDIS_STATUS_FAILURE directly to upper layer */
 		RELEASE_NDIS_PACKET(pAd, pPacket, NDIS_STATUS_FAILURE);
diff --git a/drivers/staging/rt2860/sta/sync.c b/drivers/staging/rt2860/sta/sync.c
index cbe90a6..3abc362 100644
--- a/drivers/staging/rt2860/sta/sync.c
+++ b/drivers/staging/rt2860/sta/sync.c
@@ -424,9 +424,8 @@ void MlmeJoinReqAction(struct rt_rtmp_adapter *pAd, struct rt_mlme_queue_elem *E
 	} while (FALSE);
 
 	DBGPRINT(RT_DEBUG_TRACE,
-		 ("SYNC - Switch to ch %d, Wait BEACON from %02x:%02x:%02x:%02x:%02x:%02x\n",
-		  pBss->Channel, pBss->Bssid[0], pBss->Bssid[1], pBss->Bssid[2],
-		  pBss->Bssid[3], pBss->Bssid[4], pBss->Bssid[5]));
+		("SYNC - Switch to ch %d, Wait BEACON from %pM\n",
+			pBss->Channel, &pBss->Bssid[0]));
 
 	pAd->Mlme.SyncMachine.CurrState = JOIN_WAIT_BEACON;
 }
@@ -1225,10 +1224,9 @@ void PeerBeacon(struct rt_rtmp_adapter *pAd, struct rt_mlme_queue_elem *Elem)
 			for (i = 0; i < 6; i++) {
 				if (Bssid[i] > pAd->CommonCfg.Bssid[i]) {
 					DBGPRINT(RT_DEBUG_TRACE,
-						 ("SYNC - merge to the IBSS with bigger BSSID=%02x:%02x:%02x:%02x:%02x:%02x\n",
-						  Bssid[0], Bssid[1], Bssid[2],
-						  Bssid[3], Bssid[4],
-						  Bssid[5]));
+						("SYNC - merge to the IBSS "
+							"with bigger BSSID="
+							"%pM\n", &Bssid[0]));
 					AsicDisableSync(pAd);
 					COPY_MAC_ADDR(pAd->CommonCfg.Bssid,
 						      Bssid);
diff --git a/drivers/staging/rt2860/sta_ioctl.c b/drivers/staging/rt2860/sta_ioctl.c
index 6b8268d..bff7b0b 100644
--- a/drivers/staging/rt2860/sta_ioctl.c
+++ b/drivers/staging/rt2860/sta_ioctl.c
@@ -614,9 +614,7 @@ int rt_ioctl_siwap(struct net_device *dev,
 		    OID_802_11_BSSID,
 		    sizeof(NDIS_802_11_MAC_ADDRESS), (void *) & Bssid);
 
-	DBGPRINT(RT_DEBUG_TRACE,
-		 ("IOCTL::SIOCSIWAP %02x:%02x:%02x:%02x:%02x:%02x\n", Bssid[0],
-		  Bssid[1], Bssid[2], Bssid[3], Bssid[4], Bssid[5]));
+	DBGPRINT(RT_DEBUG_TRACE, ("IOCTL::SIOCSIWAP %pM\n", &Bssid[0]));
 
 	return 0;
 }
@@ -1513,11 +1511,8 @@ void getBaInfo(struct rt_rtmp_adapter *pAd, char *pOutBuf)
 		if (((pEntry->ValidAsCLI || pEntry->ValidAsApCli)
 		     && (pEntry->Sst == SST_ASSOC))
 		    || (pEntry->ValidAsWDS) || (pEntry->ValidAsMesh)) {
-			sprintf(pOutBuf + strlen(pOutBuf),
-				"\n%02X:%02X:%02X:%02X:%02X:%02X (Aid = %d) (AP) -\n",
-				pEntry->Addr[0], pEntry->Addr[1],
-				pEntry->Addr[2], pEntry->Addr[3],
-				pEntry->Addr[4], pEntry->Addr[5], pEntry->Aid);
+			sprintf(pOutBuf + strlen(pOutBuf), "\n%pM (Aid = %d) "
+				"(AP) -\n", &pEntry->Addr[0], pEntry->Aid);
 
 			sprintf(pOutBuf, "%s[Recipient]\n", pOutBuf);
 			for (j = 0; j < NUM_OF_TID; j++) {
-- 
1.7.2.2

