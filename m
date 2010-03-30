Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526Ab0C3X6y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:58:54 -0400
Received: from kroah.org ([198.145.64.141]:45516 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932338Ab0C3XTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:19:00 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:57:09 2010
Message-Id: <20100330225708.630359553@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:56:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Vivek Natarajan <vnatarajan@atheros.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [104/116] mac80211: Reset dynamic ps timer in Rx path.
In-Reply-To: <20100330230600.GA28802@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Vivek Natarajan <vnatarajan@atheros.com>

commit e15276a4b220c54db665cf46a92bd9ceb9aeb052 upstream.

The current mac80211 implementation enables power save if there
is no Tx traffic for a specific timeout. Hence, PS is triggered
even if there is a continuous Rx only traffic(like UDP) going on.
This makes the drivers to wait on the tim bit in the next beacon
to awake which leads to redundant sleep-wake cycles.
Fix this by restarting the dynamic ps timer on receiving every
data packet.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/rx.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1590,6 +1590,7 @@ static ieee80211_rx_result debug_noinlin
 ieee80211_rx_h_data(struct ieee80211_rx_data *rx)
 {
 	struct net_device *dev = rx->dev;
+	struct ieee80211_local *local = rx->local;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
 	__le16 fc = hdr->frame_control;
 	int err;
@@ -1612,6 +1613,13 @@ ieee80211_rx_h_data(struct ieee80211_rx_
 	dev->stats.rx_packets++;
 	dev->stats.rx_bytes += rx->skb->len;
 
+	if (ieee80211_is_data(hdr->frame_control) &&
+	    !is_multicast_ether_addr(hdr->addr1) &&
+	    local->hw.conf.dynamic_ps_timeout > 0 && local->ps_sdata) {
+		mod_timer(&local->dynamic_ps_timer, jiffies +
+			  msecs_to_jiffies(local->hw.conf.dynamic_ps_timeout));
+	}
+
 	ieee80211_deliver_skb(rx);
 
 	return RX_QUEUED;


