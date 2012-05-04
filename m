Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760075Ab2EDUwE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 16:52:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34670 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759955Ab2EDUuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:50:08 -0400
Message-Id: <20120504204248.567010730@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 04 May 2012 13:43:27 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 43/47] mac80211: fix AP mode EAP tx for VLAN stations
In-Reply-To: <20120504204307.GA13761@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 66f2c99af3d6f2d0aa1120884cf1c60613ef61c0 upstream.

EAP frames for stations in an AP VLAN are sent on the main AP interface
to avoid race conditions wrt. moving stations.
For that to work properly, sta_info_get_bss must be used instead of
sta_info_get when sending EAP packets.
Previously this was only done for cooked monitor injected packets, so
this patch adds a check for tx->skb->protocol to the same place.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/tx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1222,7 +1222,8 @@ ieee80211_tx_prepare(struct ieee80211_su
 		tx->sta = rcu_dereference(sdata->u.vlan.sta);
 		if (!tx->sta && sdata->dev->ieee80211_ptr->use_4addr)
 			return TX_DROP;
-	} else if (info->flags & IEEE80211_TX_CTL_INJECTED) {
+	} else if (info->flags & IEEE80211_TX_CTL_INJECTED ||
+		   tx->sdata->control_port_protocol == tx->skb->protocol) {
 		tx->sta = sta_info_get_bss(sdata, hdr->addr1);
 	}
 	if (!tx->sta)


