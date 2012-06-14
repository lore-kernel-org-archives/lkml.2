Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177Ab2FOAD4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 20:03:56 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46571 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756924Ab2FOAAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 20:00:24 -0400
Message-Id: <20120614235625.786423624@linuxfoundation.org>
User-Agent: quilt/0.60-20.1
Date: Thu, 14 Jun 2012 16:56:44 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Nirav Shah <nirav.j2.shah@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 21/42] mac80211: clean up remain-on-channel on interface stop
In-Reply-To: <20120614235636.GA5275@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/iface.c      |   12 ++++++++++++
 net/mac80211/offchannel.c |   16 ++++++++++++++++
 2 files changed, 28 insertions(+)

--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -514,6 +514,18 @@ static void ieee80211_do_stop(struct iee
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
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -234,6 +234,22 @@ static void ieee80211_hw_roc_done(struct
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


