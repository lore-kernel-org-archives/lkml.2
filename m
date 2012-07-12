Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162778Ab2GLXFT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:05:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63192 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162759Ab2GLXFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 19:05:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stone Piao <piaoyun@marvell.com>, Avinash Patil <patila@marvell.com>,
        Kiran Divekar <dkiran@marvell.com>, Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 41/68] mwifiex: fix 11n rx packet drop issue
Date: Thu, 12 Jul 2012 16:02:15 -0700
Message-Id: <20120712175039.088569258@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712175035.530652872@linuxfoundation.org>
References: <20120712175057.GA9917@kroah.com>
 <20120712175035.530652872@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/mwifiex/11n_rxreorder.c |    5 +++--
 drivers/net/wireless/mwifiex/11n_rxreorder.h |    7 +++++++
 drivers/net/wireless/mwifiex/wmm.c           |    2 ++
 3 files changed, 12 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.c
@@ -267,7 +267,8 @@ mwifiex_11n_create_rx_reorder_tbl(struct
 	else
 		last_seq = priv->rx_seq[tid];
 
-	if (last_seq >= new_node->start_win)
+	if (last_seq != MWIFIEX_DEF_11N_RX_SEQ_NUM &&
+	    last_seq >= new_node->start_win)
 		new_node->start_win = last_seq + 1;
 
 	new_node->win_size = win_size;
@@ -612,5 +613,5 @@ void mwifiex_11n_cleanup_reorder_tbl(str
 	spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
 
 	INIT_LIST_HEAD(&priv->rx_reorder_tbl_ptr);
-	memset(priv->rx_seq, 0, sizeof(priv->rx_seq));
+	mwifiex_reset_11n_rx_seq_num(priv);
 }
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
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -406,6 +406,8 @@ mwifiex_wmm_init(struct mwifiex_adapter
 		priv->add_ba_param.tx_win_size = MWIFIEX_AMPDU_DEF_TXWINSIZE;
 		priv->add_ba_param.rx_win_size = MWIFIEX_AMPDU_DEF_RXWINSIZE;
 
+		mwifiex_reset_11n_rx_seq_num(priv);
+
 		atomic_set(&priv->wmm.tx_pkts_queued, 0);
 		atomic_set(&priv->wmm.highest_queued_prio, HIGH_PRIO_TID);
 	}


