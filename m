Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108Ab2GIOyq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:54:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38094 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754301Ab2GIOh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:37:56 -0400
Message-Id: <20120709143117.087082807@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 09 Jul 2012 15:31:19 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Stone Piao <piaoyun@marvell.com>,
        Avinash Patil <patila@marvell.com>, Kiran Divekar <dkiran@marvell.com>,
        Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 03/48] mwifiex: fix 11n rx packet drop issue
In-Reply-To: <20120709143116.348975190@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stone Piao <piaoyun@marvell.com>

commit 925839243dc9aa4ef25305f5afd10ed18258a4ac upstream.

Currently we check the sequence number of last packet received
against start_win. If a sequence hole is detected, start_win is
updated to next sequence number.

Since the rx sequence number is initialized to 0, a corner case
exists when BA setup happens immediately after association. As
0 is a valid sequence number, start_win gets increased to 1
incorrectly. This causes the first packet with sequence number 0
being dropped.

Initialize rx sequence number as 0xffff and skip adjusting
start_win if the sequence number remains 0xffff. The sequence
number will be updated once the first packet is received.

Signed-off-by: Stone Piao <piaoyun@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/mwifiex/11n_rxreorder.c |    5 +++--
 drivers/net/wireless/mwifiex/11n_rxreorder.h |    7 +++++++
 drivers/net/wireless/mwifiex/wmm.c           |    2 ++
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.c b/drivers/net/wireless/mwifiex/11n_rxreorder.c
index 9c44088..900ee12 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.c
@@ -256,7 +256,8 @@ mwifiex_11n_create_rx_reorder_tbl(struct mwifiex_private *priv, u8 *ta,
 	else
 		last_seq = priv->rx_seq[tid];
 
-	if (last_seq >= new_node->start_win)
+	if (last_seq != MWIFIEX_DEF_11N_RX_SEQ_NUM &&
+	    last_seq >= new_node->start_win)
 		new_node->start_win = last_seq + 1;
 
 	new_node->win_size = win_size;
@@ -596,5 +597,5 @@ void mwifiex_11n_cleanup_reorder_tbl(struct mwifiex_private *priv)
 	spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
 
 	INIT_LIST_HEAD(&priv->rx_reorder_tbl_ptr);
-	memset(priv->rx_seq, 0, sizeof(priv->rx_seq));
+	mwifiex_reset_11n_rx_seq_num(priv);
 }
diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.h b/drivers/net/wireless/mwifiex/11n_rxreorder.h
index f1bffeb..6c9815a 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.h
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.h
@@ -37,6 +37,13 @@
 
 #define ADDBA_RSP_STATUS_ACCEPT 0
 
+#define MWIFIEX_DEF_11N_RX_SEQ_NUM	0xffff
+
+static inline void mwifiex_reset_11n_rx_seq_num(struct mwifiex_private *priv)
+{
+	memset(priv->rx_seq, 0xff, sizeof(priv->rx_seq));
+}
+
 int mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *,
 			       u16 seqNum,
 			       u16 tid, u8 *ta,
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index f3fc655..8c2b5c0 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -404,6 +404,8 @@ mwifiex_wmm_init(struct mwifiex_adapter *adapter)
 		priv->add_ba_param.tx_win_size = MWIFIEX_AMPDU_DEF_TXWINSIZE;
 		priv->add_ba_param.rx_win_size = MWIFIEX_AMPDU_DEF_RXWINSIZE;
 
+		mwifiex_reset_11n_rx_seq_num(priv);
+
 		atomic_set(&priv->wmm.tx_pkts_queued, 0);
 		atomic_set(&priv->wmm.highest_queued_prio, HIGH_PRIO_TID);
 	}


