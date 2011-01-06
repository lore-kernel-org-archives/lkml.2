Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab1AFAbx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:31:53 -0500
Received: from kroah.org ([198.145.64.141]:36122 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754722Ab1AFAbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:31:51 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:10 2011
Message-Id: <20110106002310.039926463@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:24:01 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Johannes Berg <johannes.berg@intel.com>,
        Javier Cardona <javier@cozybit.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [142/152] mac80211: fix mesh forwarding
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit b51aff057c9d0ef6c529dc25fd9f775faf7b6c63 upstream.

Under memory pressure, the mac80211 mesh code
may helpfully print a message that it failed
to clone a mesh frame and then will proceed
to crash trying to use it anyway. Fix that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Acked-by: Javier Cardona <javier@cozybit.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/rx.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1712,9 +1712,11 @@ ieee80211_rx_h_mesh_fwding(struct ieee80
 
 			fwd_skb = skb_copy(skb, GFP_ATOMIC);
 
-			if (!fwd_skb && net_ratelimit())
+			if (!fwd_skb && net_ratelimit()) {
 				printk(KERN_DEBUG "%s: failed to clone mesh frame\n",
 						   sdata->name);
+				goto out;
+			}
 
 			fwd_hdr =  (struct ieee80211_hdr *) fwd_skb->data;
 			memcpy(fwd_hdr->addr2, sdata->vif.addr, ETH_ALEN);
@@ -1752,6 +1754,7 @@ ieee80211_rx_h_mesh_fwding(struct ieee80
 		}
 	}
 
+ out:
 	if (is_multicast_ether_addr(hdr->addr1) ||
 	    sdata->dev->flags & IFF_PROMISC)
 		return RX_CONTINUE;


