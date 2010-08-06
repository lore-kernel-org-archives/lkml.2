Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965013Ab0HFSkk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 14:40:40 -0400
Received: from kroah.org ([198.145.64.141]:48662 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964918Ab0HFSfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 14:35:55 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Aug  6 11:32:01 2010
Message-Id: <20100806183201.824104398@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 06 Aug 2010 11:30:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [20/38] ath9k: fix a buffer leak in A-MPDU completion
In-Reply-To: <20100806183250.GA23019@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 73e194639d90594d06d0c10019c0ab4638869135 upstream.

When ath_tx_complete_aggr() is called, it's responsible for returning
all buffers in the linked list. This was not done when the STA lookup
failed, leading to a race condition that could leak a few buffers when
a STA just disconnected.
Fix this by immediately returning all buffers to the free list in this case.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/xmit.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -329,6 +329,7 @@ static void ath_tx_complete_aggr(struct
 	int isaggr, txfail, txpending, sendbar = 0, needreset = 0, nbad = 0;
 	bool rc_update = true;
 	struct ieee80211_tx_rate rates[4];
+	unsigned long flags;
 
 	skb = bf->bf_mpdu;
 	hdr = (struct ieee80211_hdr *)skb->data;
@@ -344,6 +345,10 @@ static void ath_tx_complete_aggr(struct
 	sta = ieee80211_find_sta_by_hw(hw, hdr->addr1);
 	if (!sta) {
 		rcu_read_unlock();
+
+		spin_lock_irqsave(&sc->tx.txbuflock, flags);
+		list_splice_tail_init(bf_q, &sc->tx.txbuf);
+		spin_unlock_irqrestore(&sc->tx.txbuflock, flags);
 		return;
 	}
 


