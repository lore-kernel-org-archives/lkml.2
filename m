Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919Ab2LMOBt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:01:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44022 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879Ab2LMOBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:01:46 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 017/241] ath9k: fix stale pointers potentially causing access to free'd skbs
Date: Thu, 13 Dec 2012 11:56:22 -0200
Message-Id: <1355407206-17100-18-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/net/wireless/ath/ath9k/xmit.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index b78773b..11f252f 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -337,6 +337,7 @@ static struct ath_buf *ath_tx_get_buffer(struct ath_softc *sc)
 	}
 
 	bf = list_first_entry(&sc->tx.txbuf, struct ath_buf, list);
+	bf->bf_next = NULL;
 	list_del(&bf->list);
 
 	spin_unlock_bh(&sc->tx.txbuflock);
@@ -1760,6 +1761,7 @@ static void ath_tx_send_normal(struct ath_softc *sc, struct ath_txq *txq,
 	list_add_tail(&bf->list, &bf_head);
 	bf->bf_state.bf_type = 0;
 
+	bf->bf_next = NULL;
 	bf->bf_lastbf = bf;
 	ath_tx_fill_desc(sc, bf, txq, fi->framelen);
 	ath_tx_txqaddbuf(sc, txq, &bf_head, false);
-- 
1.7.9.5

