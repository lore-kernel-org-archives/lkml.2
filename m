Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758806Ab2FQSY5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 14:24:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50401 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758606Ab2FQSXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 14:23:04 -0400
Message-Id: <20120617175945.029846020@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Jun 2012 19:00:07 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Johannes Berg <johannes.berg@intel.com>,
        Nirav Shah <nirav.j2.shah@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 26/69] mac80211: clean up remain-on-channel on interface stop
In-Reply-To: <20120617175941.281333656@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 71ecfa1893034eeb1c93e02e22ee2ad26d080858 upstream.

When any interface goes down, it could be the one that we
were doing a remain-on-channel with. We therefore need to
cancel the remain-on-channel and flush the related work
structs so they don't run after the interface has been
removed or even destroyed.

It's also possible in this case that an off-channel SKB
was never transmitted, so free it if this is the case.
Note that this can also happen if the driver finishes
the off-channel period without ever starting it.

Reported-by: Nirav Shah <nirav.j2.shah@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/mac80211/iface.c      |   12 ++++++++++++
 net/mac80211/offchannel.c |   16 ++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index d4c19a7..8664111 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -637,6 +637,18 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 		ieee80211_configure_filter(local);
 		break;
 	default:
+		mutex_lock(&local->mtx);
+		if (local->hw_roc_dev == sdata->dev &&
+		    local->hw_roc_channel) {
+			/* ignore return value since this is racy */
+			drv_cancel_remain_on_channel(local);
+			ieee80211_queue_work(&local->hw, &local->hw_roc_done);
+		}
+		mutex_unlock(&local->mtx);
+
+		flush_work(&local->hw_roc_start);
+		flush_work(&local->hw_roc_done);
+
 		flush_work(&sdata->work);
 		/*
 		 * When we get here, the interface is marked down.
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index f054e94..935aa4b 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -234,6 +234,22 @@ static void ieee80211_hw_roc_done(struct work_struct *work)
 		return;
 	}
 
+	/* was never transmitted */
+	if (local->hw_roc_skb) {
+		u64 cookie;
+
+		cookie = local->hw_roc_cookie ^ 2;
+
+		cfg80211_mgmt_tx_status(local->hw_roc_dev, cookie,
+					local->hw_roc_skb->data,
+					local->hw_roc_skb->len, false,
+					GFP_KERNEL);
+
+		kfree_skb(local->hw_roc_skb);
+		local->hw_roc_skb = NULL;
+		local->hw_roc_skb_for_status = NULL;
+	}
+
 	if (!local->hw_roc_for_tx)
 		cfg80211_remain_on_channel_expired(local->hw_roc_dev,
 						   local->hw_roc_cookie,


