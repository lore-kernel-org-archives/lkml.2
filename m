Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab2IQAuq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 20:50:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33387 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753057Ab2IQAtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:49:40 -0400
Message-Id: <20120917003639.652036557@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:38:02 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Malcolm Priestley <tvboxspy@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 097/135] staging: vt6656: [BUG] - Failed connection, incorrect endian.
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Malcolm Priestley <tvboxspy@gmail.com>

commit aa209eef3ce8419ff2926c2fa944dfbfb5afbacb upstream.

Hi,

This patch fixes a bug with driver failing to negotiate a connection.

The bug was traced to commit
203e4615ee9d9fa8d3506b9d0ef30095e4d5bc90
staging: vt6656: removed custom definitions of Ethernet packet types

In that patch, definitions in include/linux/if_ether.h replaced ones
in tether.h which had both big and little endian definitions.

include/linux/if_ether.h only refers to big endian values, cpu_to_be16
should be used for the correct endian architectures.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/vt6656/dpc.c  |    2 +-
 drivers/staging/vt6656/rxtx.c |   38 +++++++++++++++++++-------------------
 2 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/vt6656/dpc.c b/drivers/staging/vt6656/dpc.c
index e4bdf2a..3aa895e 100644
--- a/drivers/staging/vt6656/dpc.c
+++ b/drivers/staging/vt6656/dpc.c
@@ -200,7 +200,7 @@ s_vProcessRxMACHeader (
     } else if (!compare_ether_addr(pbyRxBuffer, &pDevice->abySNAP_RFC1042[0])) {
         cbHeaderSize += 6;
         pwType = (PWORD) (pbyRxBufferAddr + cbHeaderSize);
-	if ((*pwType == cpu_to_le16(ETH_P_IPX)) ||
+	if ((*pwType == cpu_to_be16(ETH_P_IPX)) ||
 	    (*pwType == cpu_to_le16(0xF380))) {
 		cbHeaderSize -= 8;
             pwType = (PWORD) (pbyRxBufferAddr + cbHeaderSize);
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index bb46452..b6e04e7 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -1699,7 +1699,7 @@ s_bPacketToWirelessUsb(
     // 802.1H
     if (ntohs(psEthHeader->wType) > ETH_DATA_LEN) {
 	if (pDevice->dwDiagRefCount == 0) {
-		if ((psEthHeader->wType == cpu_to_le16(ETH_P_IPX)) ||
+		if ((psEthHeader->wType == cpu_to_be16(ETH_P_IPX)) ||
 		    (psEthHeader->wType == cpu_to_le16(0xF380))) {
 			memcpy((PBYTE) (pbyPayloadHead),
 			       abySNAP_Bridgetunnel, 6);
@@ -2838,10 +2838,10 @@ int nsDMA_tx_packet(PSDevice pDevice, unsigned int uDMAIdx, struct sk_buff *skb)
     Packet_Type = skb->data[ETH_HLEN+1];
     Descriptor_type = skb->data[ETH_HLEN+1+1+2];
     Key_info = (skb->data[ETH_HLEN+1+1+2+1] << 8)|(skb->data[ETH_HLEN+1+1+2+2]);
-    if (pDevice->sTxEthHeader.wType == cpu_to_le16(ETH_P_PAE)) {
-	/* 802.1x OR eapol-key challenge frame transfer */
-	if (((Protocol_Version == 1) || (Protocol_Version == 2)) &&
-		(Packet_Type == 3)) {
+	if (pDevice->sTxEthHeader.wType == cpu_to_be16(ETH_P_PAE)) {
+		/* 802.1x OR eapol-key challenge frame transfer */
+		if (((Protocol_Version == 1) || (Protocol_Version == 2)) &&
+			(Packet_Type == 3)) {
                         bTxeapol_key = TRUE;
                        if(!(Key_info & BIT3) &&  //WPA or RSN group-key challenge
 			   (Key_info & BIT8) && (Key_info & BIT9)) {    //send 2/2 key
@@ -2987,19 +2987,19 @@ int nsDMA_tx_packet(PSDevice pDevice, unsigned int uDMAIdx, struct sk_buff *skb)
         }
     }
 
-    if (pDevice->sTxEthHeader.wType == cpu_to_le16(ETH_P_PAE)) {
-        if (pDevice->byBBType != BB_TYPE_11A) {
-            pDevice->wCurrentRate = RATE_1M;
-            pDevice->byACKRate = RATE_1M;
-            pDevice->byTopCCKBasicRate = RATE_1M;
-            pDevice->byTopOFDMBasicRate = RATE_6M;
-        } else {
-            pDevice->wCurrentRate = RATE_6M;
-            pDevice->byACKRate = RATE_6M;
-            pDevice->byTopCCKBasicRate = RATE_1M;
-            pDevice->byTopOFDMBasicRate = RATE_6M;
-        }
-    }
+	if (pDevice->sTxEthHeader.wType == cpu_to_be16(ETH_P_PAE)) {
+		if (pDevice->byBBType != BB_TYPE_11A) {
+			pDevice->wCurrentRate = RATE_1M;
+			pDevice->byACKRate = RATE_1M;
+			pDevice->byTopCCKBasicRate = RATE_1M;
+			pDevice->byTopOFDMBasicRate = RATE_6M;
+		} else {
+			pDevice->wCurrentRate = RATE_6M;
+			pDevice->byACKRate = RATE_6M;
+			pDevice->byTopCCKBasicRate = RATE_1M;
+			pDevice->byTopOFDMBasicRate = RATE_6M;
+		}
+	}
 
     DBG_PRT(MSG_LEVEL_DEBUG,
 	    KERN_INFO "dma_tx: pDevice->wCurrentRate = %d\n",
@@ -3015,7 +3015,7 @@ int nsDMA_tx_packet(PSDevice pDevice, unsigned int uDMAIdx, struct sk_buff *skb)
 
     if (bNeedEncryption == TRUE) {
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"ntohs Pkt Type=%04x\n", ntohs(pDevice->sTxEthHeader.wType));
-	if ((pDevice->sTxEthHeader.wType) == cpu_to_le16(ETH_P_PAE)) {
+	if ((pDevice->sTxEthHeader.wType) == cpu_to_be16(ETH_P_PAE)) {
 		bNeedEncryption = FALSE;
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Pkt Type=%04x\n", (pDevice->sTxEthHeader.wType));
             if ((pMgmt->eCurrMode == WMAC_MODE_ESS_STA) && (pMgmt->eCurrState == WMAC_STATE_ASSOC)) {


