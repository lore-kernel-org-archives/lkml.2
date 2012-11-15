Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993201Ab2KOEMa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:12:30 -0500
Received: from mail.kernel.org ([198.145.19.201]:49601 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993147Ab2KOEMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:12:20 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 05/57] ath9k: Test for TID only in BlockAcks while checking tx status
Date: Wed, 14 Nov 2012 20:11:13 -0800
Message-Id: <20121115040933.550121774@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121115040933.223998671@linuxfoundation.org>
References: <20121115040933.223998671@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit 6fe7cc71bbf3a0bc28c9cec3c00bc11e81344412 upstream.

The ath9k xmit functions for AMPDUs can send frames as non-aggregate in case
only one frame is currently available. The client will then answer using a
normal Ack instead of a BlockAck. This acknowledgement has no TID stored and
therefore the hardware is not able to provide us the corresponding TID.

The TID set by the hardware in the tx status descriptor has to be seen as
undefined and not as a valid TID value for normal acknowledgements. Doing
otherwise results in a massive amount of retransmissions and stalls of
connections.

Users may experience low bandwidth and complete connection stalls in
environments with transfers using multiple TIDs.

This regression was introduced in b11b160defc48e4daa283f785192ea3a23a51f8e
("ath9k: validate the TID in the tx status information").

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Acked-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/xmit.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -419,7 +419,7 @@ static void ath_tx_complete_aggr(struct
 	u16 seq_st = 0, acked_cnt = 0, txfail_cnt = 0, seq_first;
 	u32 ba[WME_BA_BMP_SIZE >> 5];
 	int isaggr, txfail, txpending, sendbar = 0, needreset = 0, nbad = 0;
-	bool rc_update = true;
+	bool rc_update = true, isba;
 	struct ieee80211_tx_rate rates[4];
 	struct ath_frame_info *fi;
 	int nframes;
@@ -463,13 +463,17 @@ static void ath_tx_complete_aggr(struct
 	tidno = ieee80211_get_qos_ctl(hdr)[0] & IEEE80211_QOS_CTL_TID_MASK;
 	tid = ATH_AN_2_TID(an, tidno);
 	seq_first = tid->seq_start;
+	isba = ts->ts_flags & ATH9K_TX_BA;
 
 	/*
 	 * The hardware occasionally sends a tx status for the wrong TID.
 	 * In this case, the BA status cannot be considered valid and all
 	 * subframes need to be retransmitted
+	 *
+	 * Only BlockAcks have a TID and therefore normal Acks cannot be
+	 * checked
 	 */
-	if (tidno != ts->tid)
+	if (isba && tidno != ts->tid)
 		txok = false;
 
 	isaggr = bf_isaggr(bf);


