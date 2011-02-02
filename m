Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab1BBAp1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:45:27 -0500
Received: from mga01.intel.com ([192.55.52.88]:58271 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753949Ab1BBApR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:45:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="883418459"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: johannes.berg@intel.com, javier@cozybit.com, linville@tuxdriver.com,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH] [128/139] mac80211: fix mesh forwarding
Message-Id: <20110202004527.B26AE3E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:45:27 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/mac80211/rx.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6.35.y/net/mac80211/rx.c
===================================================================
--- linux-2.6.35.y.orig/net/mac80211/rx.c
+++ linux-2.6.35.y/net/mac80211/rx.c
@@ -1707,9 +1707,11 @@ ieee80211_rx_h_mesh_fwding(struct ieee80
 
 			fwd_skb = skb_copy(skb, GFP_ATOMIC);
 
-			if (!fwd_skb && net_ratelimit())
+			if (!fwd_skb && net_ratelimit()) {
 				printk(KERN_DEBUG "%s: failed to clone mesh frame\n",
 						   sdata->name);
+				goto out;
+			}
 
 			fwd_hdr =  (struct ieee80211_hdr *) fwd_skb->data;
 			memcpy(fwd_hdr->addr2, sdata->vif.addr, ETH_ALEN);
@@ -1747,6 +1749,7 @@ ieee80211_rx_h_mesh_fwding(struct ieee80
 		}
 	}
 
+ out:
 	if (is_multicast_ether_addr(hdr->addr1) ||
 	    sdata->dev->flags & IFF_PROMISC)
 		return RX_CONTINUE;
