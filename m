Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759490Ab0GAVxK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:53:10 -0400
Received: from kroah.org ([198.145.64.141]:60843 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758939Ab0GAVNg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:13:36 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:51 2010
Message-Id: <20100701174251.746581277@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:42:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Shanyu Zhao <shanyu.zhao@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [063/200] mac80211: fix rts threshold check
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shanyu Zhao <shanyu.zhao@intel.com>

commit a2c40249a36d0b4d76d1caf6bf806e4ae5b06e8a upstream.

Currently whenever rts thresold is set, every packet will use RTS
protection no matter its size exceeds the threshold or not. This is
due to a bug in the rts threshold check.
	if (len > tx->local->hw.wiphy->rts_threshold) {
		txrc.rts = rts = true;
	}
Basically it is comparing an int (len) and a u32 (rts_threshold),
and the variable len is assigned as:
	len = min_t(int, tx->skb->len + FCS_LEN,
			 tx->local->hw.wiphy->frag_threshold);
However, when frag_threshold is "-1", len is always "-1", which is
0xffffffff therefore rts is always set to true.

Signed-off-by: Shanyu Zhao <shanyu.zhao@intel.com>
Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/tx.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -584,7 +584,8 @@ ieee80211_tx_h_rate_ctrl(struct ieee8021
 	struct ieee80211_hdr *hdr = (void *)tx->skb->data;
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_rate *rate;
-	int i, len;
+	int i;
+	u32 len;
 	bool inval = false, rts = false, short_preamble = false;
 	struct ieee80211_tx_rate_control txrc;
 	u32 sta_flags;
@@ -593,7 +594,7 @@ ieee80211_tx_h_rate_ctrl(struct ieee8021
 
 	sband = tx->local->hw.wiphy->bands[tx->channel->band];
 
-	len = min_t(int, tx->skb->len + FCS_LEN,
+	len = min_t(u32, tx->skb->len + FCS_LEN,
 			 tx->local->hw.wiphy->frag_threshold);
 
 	/* set up the tx rate control struct we give the RC algo */


