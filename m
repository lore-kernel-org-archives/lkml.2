Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932973Ab1BPAsn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:48:43 -0500
Received: from kroah.org ([198.145.64.141]:45468 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932940Ab1BPAse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:48:34 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:21:03 2011
Message-Id: <20110216002103.904039746@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:20:16 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Felix Fietkau <nbd@openwrt.org>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 048/176] mac80211: fix initialization of skb->cb in ieee80211_subif_start_xmit
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 489ee9195a7de9e6bc833d639ff6b553ffdad90e upstream.

The change 'mac80211: Fix BUG in pskb_expand_head when transmitting shared skbs'
added a check for copying the skb if it's shared, however the tx info variable
still points at the cb of the old skb

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/tx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1694,7 +1694,7 @@ netdev_tx_t ieee80211_subif_start_xmit(s
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_tx_info *info;
 	int ret = NETDEV_TX_BUSY, head_need;
 	u16 ethertype, hdrlen,  meshhdrlen = 0;
 	__le16 fc;
@@ -1984,6 +1984,7 @@ netdev_tx_t ieee80211_subif_start_xmit(s
 	skb_set_network_header(skb, nh_pos);
 	skb_set_transport_header(skb, h_pos);
 
+	info = IEEE80211_SKB_CB(skb);
 	memset(info, 0, sizeof(*info));
 
 	dev->trans_start = jiffies;


