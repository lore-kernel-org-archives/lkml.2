Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757607Ab2EHRMB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 13:12:01 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:36794 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756585Ab2EHRMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 13:12:00 -0400
Message-ID: <1336497116.29640.23.camel@joe2Laptop>
Subject: [PATCH] staging: Remove test of is_broadcast with is_multicast
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Forest Bond <forest@alittletooquiet.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Tue, 08 May 2012 10:11:56 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A broadcast packet is a multicast packet, no need to test twice.

Reorder one defective test in rtl_core of is_multi_ether_addr
before is_broadcast_ether_addr as the is_multi returns true for
broadcast frames.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c |    5 +----
 drivers/staging/rtl8187se/r8180_core.c             |    3 +--
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c       |    9 ++++-----
 drivers/staging/rtl8192e/rtl819x_TSProc.c          |    2 +-
 drivers/staging/rtl8192e/rtllib_rx.c               |    6 +++---
 drivers/staging/rtl8192e/rtllib_tx.c               |    8 +++-----
 drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c  |    2 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c  |    7 +++----
 .../staging/rtl8192u/ieee80211/rtl819x_TSProc.c    |    2 +-
 drivers/staging/vt6656/dpc.c                       |    2 +-
 10 files changed, 19 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c
index 77bb068..89ed86e 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c
@@ -413,10 +413,7 @@ int ieee80211_rtl_xmit(struct sk_buff *skb,
 
 		/* Determine fragmentation size based on destination (multicast
 		* and broadcast are not fragmented) */
-//		if (is_multicast_ether_addr(dest) ||
-//		is_broadcast_ether_addr(dest)) {
-		if (is_multicast_ether_addr(header.addr1) ||
-		is_broadcast_ether_addr(header.addr1)) {
+		if (is_multicast_ether_addr(header.addr1)) {
 			frag_size = MAX_FRAG_THRESHOLD;
 			qos_ctl = QOS_CTL_NOTCONTAIN_ACK;
 		}
diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
index a513ec7..fd22b75 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -2003,8 +2003,7 @@ short rtl8180_tx(struct net_device *dev, u8* txbuf, int len, int priority,
 	}
 
 		memcpy(&dest, frag_hdr->addr1, ETH_ALEN);
-		if (is_multicast_ether_addr(dest) ||
-				is_broadcast_ether_addr(dest)) {
+		if (is_multicast_ether_addr(dest)) {
 			Duration = 0;
 			RtsDur = 0;
 			bRTSEnable = 0;
diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_core.c b/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
index 97a5f49..4f602b2 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
@@ -2024,10 +2024,10 @@ short rtl8192_tx(struct net_device *dev, struct sk_buff *skb)
 	stype = WLAN_FC_GET_STYPE(fc);
 	pda_addr = header->addr1;
 
-	if (is_multicast_ether_addr(pda_addr))
-		multi_addr = true;
-	else if (is_broadcast_ether_addr(pda_addr))
+	if (is_broadcast_ether_addr(pda_addr))
 		broad_addr = true;
+	else if (is_multicast_ether_addr(pda_addr))
+		multi_addr = true;
 	else
 		uni_addr = true;
 
@@ -2358,8 +2358,7 @@ static void rtl8192_rx_normal(struct net_device *dev)
 				stats.RxBufShift);
 			skb_trim(skb, skb->len - 4/*sCrcLng*/);
 			rtllib_hdr = (struct rtllib_hdr_1addr *)skb->data;
-			if (!is_broadcast_ether_addr(rtllib_hdr->addr1) &&
-			!is_multicast_ether_addr(rtllib_hdr->addr1)) {
+			if (!is_multicast_ether_addr(rtllib_hdr->addr1)) {
 				/* unicast packet */
 				unicast_packet = true;
 			}
diff --git a/drivers/staging/rtl8192e/rtl819x_TSProc.c b/drivers/staging/rtl8192e/rtl819x_TSProc.c
index 711a096..658e875 100644
--- a/drivers/staging/rtl8192e/rtl819x_TSProc.c
+++ b/drivers/staging/rtl8192e/rtl819x_TSProc.c
@@ -310,7 +310,7 @@ bool GetTs(struct rtllib_device *ieee, struct ts_common_info **ppTS,
 	   u8 *Addr, u8 TID, enum tr_select TxRxSelect, bool bAddNewTs)
 {
 	u8	UP = 0;
-	if (is_broadcast_ether_addr(Addr) || is_multicast_ether_addr(Addr)) {
+	if (is_multicast_ether_addr(Addr)) {
 		RTLLIB_DEBUG(RTLLIB_DL_ERR, "ERR! get TS for Broadcast or "
 			     "Multicast\n");
 		return false;
diff --git a/drivers/staging/rtl8192e/rtllib_rx.c b/drivers/staging/rtl8192e/rtllib_rx.c
index 40a59c9..8b8a5c6 100644
--- a/drivers/staging/rtl8192e/rtllib_rx.c
+++ b/drivers/staging/rtl8192e/rtllib_rx.c
@@ -1000,7 +1000,7 @@ static int rtllib_rx_data_filter(struct rtllib_device *ieee, u16 fc,
 			return -1;
 
 		/* {broad,multi}cast packets to our BSS go through */
-		if (is_multicast_ether_addr(dst) || is_broadcast_ether_addr(dst)) {
+		if (is_multicast_ether_addr(dst)) {
 			if (memcmp(bssid, ieee->current_network.bssid, ETH_ALEN))
 				return -1;
 		}
@@ -1269,7 +1269,7 @@ static int rtllib_rx_InfraAdhoc(struct rtllib_device *ieee, struct sk_buff *skb,
 	sc = le16_to_cpu(hdr->seq_ctl);
 
 	/*Filter pkt not to me*/
-	multicast = is_multicast_ether_addr(hdr->addr1)|is_broadcast_ether_addr(hdr->addr1);
+	multicast = is_multicast_ether_addr(hdr->addr1);
 	unicast = !multicast;
 	if (unicast && (compare_ether_addr(dev->dev_addr, hdr->addr1) != 0)) {
 		if (ieee->bNetPromiscuousMode)
@@ -1350,7 +1350,7 @@ static int rtllib_rx_InfraAdhoc(struct rtllib_device *ieee, struct sk_buff *skb,
 	/* Get TS for Rx Reorder  */
 	hdr = (struct rtllib_hdr_4addr *) skb->data;
 	if (ieee->current_network.qos_data.active && IsQoSDataFrame(skb->data)
-		&& !is_multicast_ether_addr(hdr->addr1) && !is_broadcast_ether_addr(hdr->addr1)
+		&& !is_multicast_ether_addr(hdr->addr1)
 		&& (!bToOtherSTA)) {
 		TID = Frame_QoSTID(skb->data);
 		SeqNum = WLAN_GET_SEQ_SEQ(sc);
diff --git a/drivers/staging/rtl8192e/rtllib_tx.c b/drivers/staging/rtl8192e/rtllib_tx.c
index f24aa00c..42900ee 100644
--- a/drivers/staging/rtl8192e/rtllib_tx.c
+++ b/drivers/staging/rtl8192e/rtllib_tx.c
@@ -296,8 +296,7 @@ static void rtllib_tx_query_agg_cap(struct rtllib_device *ieee,
 		return;
 	if (!IsQoSDataFrame(skb->data))
 		return;
-	if (is_multicast_ether_addr(hdr->addr1) ||
-	    is_broadcast_ether_addr(hdr->addr1))
+	if (is_multicast_ether_addr(hdr->addr1))
 		return;
 
 	if (tcb_desc->bdhcp || ieee->CntAfterLink < 2)
@@ -515,7 +514,7 @@ u16 rtllib_query_seqnum(struct rtllib_device *ieee, struct sk_buff *skb,
 {
 	u16 seqnum = 0;
 
-	if (is_multicast_ether_addr(dst) || is_broadcast_ether_addr(dst))
+	if (is_multicast_ether_addr(dst))
 		return 0;
 	if (IsQoSDataFrame(skb->data)) {
 		struct tx_ts_record *pTS = NULL;
@@ -698,8 +697,7 @@ int rtllib_xmit_inter(struct sk_buff *skb, struct net_device *dev)
 			       ETH_ALEN);
 		}
 
-		bIsMulticast = is_broadcast_ether_addr(header.addr1) ||
-			       is_multicast_ether_addr(header.addr1);
+		bIsMulticast = is_multicast_ether_addr(header.addr1);
 
 		header.frame_ctl = cpu_to_le16(fc);
 
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
index 6249c3f..e3cf7a4 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
@@ -1285,7 +1285,7 @@ int ieee80211_rx(struct ieee80211_device *ieee, struct sk_buff *skb,
 */
 //added by amy for reorder
 	if(ieee->current_network.qos_data.active && IsQoSDataFrame(skb->data)
-		&& !is_multicast_ether_addr(hdr->addr1) && !is_broadcast_ether_addr(hdr->addr1))
+		&& !is_multicast_ether_addr(hdr->addr1))
 	{
 		TID = Frame_QoSTID(skb->data);
 		SeqNum = WLAN_GET_SEQ_SEQ(sc);
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c
index 59c45a5..3f5ceeb 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c
@@ -314,7 +314,7 @@ void ieee80211_tx_query_agg_cap(struct ieee80211_device* ieee, struct sk_buff* s
 	if (!IsQoSDataFrame(skb->data))
 		return;
 
-	if (is_multicast_ether_addr(hdr->addr1) || is_broadcast_ether_addr(hdr->addr1))
+	if (is_multicast_ether_addr(hdr->addr1))
 		return;
 	//check packet and mode later
 #ifdef TO_DO_LIST
@@ -575,7 +575,7 @@ void ieee80211_txrate_selectmode(struct ieee80211_device* ieee, cb_desc* tcb_des
 
 void ieee80211_query_seqnum(struct ieee80211_device*ieee, struct sk_buff* skb, u8* dst)
 {
-	if (is_multicast_ether_addr(dst) || is_broadcast_ether_addr(dst))
+	if (is_multicast_ether_addr(dst))
 		return;
 	if (IsQoSDataFrame(skb->data)) //we deal qos data only
 	{
@@ -693,8 +693,7 @@ int ieee80211_xmit(struct sk_buff *skb, struct net_device *dev)
 
 		/* Determine fragmentation size based on destination (multicast
 		* and broadcast are not fragmented) */
-		if (is_multicast_ether_addr(header.addr1) ||
-		is_broadcast_ether_addr(header.addr1)) {
+		if (is_multicast_ether_addr(header.addr1)) {
 			frag_size = MAX_FRAG_THRESHOLD;
 			qos_ctl |= QOS_CTL_NOTCONTAIN_ACK;
 		}
diff --git a/drivers/staging/rtl8192u/ieee80211/rtl819x_TSProc.c b/drivers/staging/rtl8192u/ieee80211/rtl819x_TSProc.c
index 957ce4e..06a9824 100644
--- a/drivers/staging/rtl8192u/ieee80211/rtl819x_TSProc.c
+++ b/drivers/staging/rtl8192u/ieee80211/rtl819x_TSProc.c
@@ -350,7 +350,7 @@ bool GetTs(
 	// We do not build any TS for Broadcast or Multicast stream.
 	// So reject these kinds of search here.
 	//
-	if(is_broadcast_ether_addr(Addr) || is_multicast_ether_addr(Addr))
+	if (is_multicast_ether_addr(Addr))
 	{
 		IEEE80211_DEBUG(IEEE80211_DL_ERR, "get TS for Broadcast or Multicast\n");
 		return false;
diff --git a/drivers/staging/vt6656/dpc.c b/drivers/staging/vt6656/dpc.c
index c0edf97..e4bdf2a 100644
--- a/drivers/staging/vt6656/dpc.c
+++ b/drivers/staging/vt6656/dpc.c
@@ -452,7 +452,7 @@ RXbBulkInProcessData (
        }
     }
 
-    if (!is_multicast_ether_addr(pMACHeader->abyAddr1) && !is_broadcast_ether_addr(pMACHeader->abyAddr1)) {
+    if (!is_multicast_ether_addr(pMACHeader->abyAddr1)) {
         if ( WCTLbIsDuplicate(&(pDevice->sDupRxCache), (PS802_11Header) pbyFrame) ) {
             pDevice->s802_11Counter.FrameDuplicateCount++;
             return FALSE;


