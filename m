Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338Ab0FOCAx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 22:00:53 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56979 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755912Ab0FOCAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 22:00:50 -0400
Date: Tue, 15 Jun 2010 12:00:48 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Johannes Berg <johannes.berg@intel.com>
Subject: linux-next: manual merge of the wireless tree with Linus' tree
Message-Id: <20100615120048.5d497ce1.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

Today's linux-next merge of the wireless tree got a conflict in
net/mac80211/mlme.c between commit
b054b747a694927879c94dd11af54d04346aed7d ("mac80211: fix deauth before
assoc") from Linus' tree and commit
36b3a628a4e85d002ee8813ebd2a5caef6d3c1a7 ("mac80211: common work skb
freeing") from the wireless tree.

Just context changes.  I fixed it up (see below) and can carry the fix
for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc net/mac80211/mlme.c
index 8fb85c3,74479c2..0000000
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@@ -1760,47 -1708,8 +1708,45 @@@ void ieee80211_sta_rx_queued_mgmt(struc
  	mutex_unlock(&ifmgd->mtx);
  
  	if (skb->len >= 24 + 2 /* mgmt + deauth reason */ &&
 -	    (fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_DEAUTH)
 +	    (fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_DEAUTH) {
 +		struct ieee80211_local *local = sdata->local;
 +		struct ieee80211_work *wk;
 +
 +		mutex_lock(&local->work_mtx);
 +		list_for_each_entry(wk, &local->work_list, list) {
 +			if (wk->sdata != sdata)
 +				continue;
 +
 +			if (wk->type != IEEE80211_WORK_ASSOC)
 +				continue;
 +
 +			if (memcmp(mgmt->bssid, wk->filter_ta, ETH_ALEN))
 +				continue;
 +			if (memcmp(mgmt->sa, wk->filter_ta, ETH_ALEN))
 +				continue;
 +
 +			/*
 +			 * Printing the message only here means we can't
 +			 * spuriously print it, but it also means that it
 +			 * won't be printed when the frame comes in before
 +			 * we even tried to associate or in similar cases.
 +			 *
 +			 * Ultimately, I suspect cfg80211 should print the
 +			 * messages instead.
 +			 */
 +			printk(KERN_DEBUG
 +			       "%s: deauthenticated from %pM (Reason: %u)\n",
 +			       sdata->name, mgmt->bssid,
 +			       le16_to_cpu(mgmt->u.deauth.reason_code));
 +
 +			list_del_rcu(&wk->list);
 +			free_work(wk);
 +			break;
 +		}
 +		mutex_unlock(&local->work_mtx);
 +
  		cfg80211_send_deauth(sdata->dev, (u8 *)mgmt, skb->len);
 +	}
-  out:
- 	kfree_skb(skb);
  }
  
  static void ieee80211_sta_timer(unsigned long data)
