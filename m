Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933347Ab2KOEJ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:09:59 -0500
Received: from mail.kernel.org ([198.145.19.201]:48230 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755533Ab2KOEJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:09:57 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 01/38] ath9k: fix stale pointers potentially causing access to freed skbs
Date: Wed, 14 Nov 2012 20:09:58 -0800
Message-Id: <20121115040933.003106614@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121115040932.918082372@linuxfoundation.org>
References: <20121115040932.918082372@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 8c6e30936a7893a85f6222084f0f26aceb81137a upstream.

bf->bf_next is only while buffers are chained as part of an A-MPDU
in the tx queue. When a tid queue is flushed (e.g. on tearing down
an aggregation session), frames can be enqueued again as normal
transmission, without bf_next being cleared. This can lead to the
old pointer being dereferenced again later.

This patch might fix crashes and "Failed to stop TX DMA!" messages.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/xmit.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -272,6 +272,7 @@ static struct ath_buf *ath_tx_get_buffer
 	}
 
 	bf = list_first_entry(&sc->tx.txbuf, struct ath_buf, list);
+	bf->bf_next = NULL;
 	list_del(&bf->list);
 
 	spin_unlock_bh(&sc->tx.txbuflock);
@@ -1488,6 +1489,7 @@ static void ath_tx_send_normal(struct at
 	if (tid)
 		INCR(tid->seq_start, IEEE80211_SEQ_MAX);
 
+	bf->bf_next = NULL;
 	bf->bf_lastbf = bf;
 	fi = get_frame_info(bf->bf_mpdu);
 	ath_buf_set_rate(sc, bf, fi->framelen);


