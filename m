Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934424Ab1KJFTQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 00:19:16 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42003 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934327Ab1KJDYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:24:05 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:08 2011
Message-Id: <20111109212708.626849117@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:26:43 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [081/262] mac80211: fix offchannel TX cookie matching
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 28a1bcdb57d50f3038a255741ecc83e391e5282e upstream.

When I introduced in-kernel off-channel TX I
introduced a bug -- the work can't be canceled
again because the code clear the skb pointer.
Fix this by keeping track separately of whether
TX status has already been reported.

Reported-by: Jouni Malinen <j@w1.fi>
Tested-by: Jouni Malinen <j@w1.fi>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/cfg.c         |    2 +-
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/status.c      |    2 +-
 net/mac80211/work.c        |    2 +-
 4 files changed, 4 insertions(+), 3 deletions(-)

--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1798,7 +1798,7 @@ ieee80211_offchan_tx_done(struct ieee802
 	 * so in that case userspace will have to deal with it.
 	 */
 
-	if (wk->offchan_tx.wait && wk->offchan_tx.frame)
+	if (wk->offchan_tx.wait && !wk->offchan_tx.status)
 		cfg80211_mgmt_tx_status(wk->sdata->dev,
 					(unsigned long) wk->offchan_tx.frame,
 					wk->ie, wk->ie_len, false, GFP_KERNEL);
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -328,6 +328,7 @@ struct ieee80211_work {
 		struct {
 			struct sk_buff *frame;
 			u32 wait;
+			bool status;
 		} offchan_tx;
 	};
 
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -336,7 +336,7 @@ void ieee80211_tx_status(struct ieee8021
 				continue;
 			if (wk->offchan_tx.frame != skb)
 				continue;
-			wk->offchan_tx.frame = NULL;
+			wk->offchan_tx.status = true;
 			break;
 		}
 		rcu_read_unlock();
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -553,7 +553,7 @@ ieee80211_offchannel_tx(struct ieee80211
 		/*
 		 * After this, offchan_tx.frame remains but now is no
 		 * longer a valid pointer -- we still need it as the
-		 * cookie for canceling this work.
+		 * cookie for canceling this work/status matching.
 		 */
 		ieee80211_tx_skb(wk->sdata, wk->offchan_tx.frame);
 


