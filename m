Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944Ab1BPBoj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:44:39 -0500
Received: from kroah.org ([198.145.64.141]:38837 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756855Ab1BPATY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:19:24 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:30 2011
Message-Id: <20110216001430.303416881@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:11:49 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Johannes Berg <johannes@sipsolutions.net>,
        Luciano Coelho <coelho@ti.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [052/272] mac80211: use maximum number of AMPDU frames as default in BA RX
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Luciano Coelho <coelho@ti.com>

commit 82694f764dad783a123394e2220b92b9be721b43 upstream.

When the buffer size is set to zero in the block ack parameter set
field, we should use the maximum supported number of subframes.  The
existing code was bogus and was doing some unnecessary calculations
that lead to wrong values.

Thanks Johannes for helping me figure this one out.

Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Luciano Coelho <coelho@ti.com>
Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>

---
 net/mac80211/agg-rx.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -187,8 +187,6 @@ void ieee80211_process_addba_request(str
 				     struct ieee80211_mgmt *mgmt,
 				     size_t len)
 {
-	struct ieee80211_hw *hw = &local->hw;
-	struct ieee80211_conf *conf = &hw->conf;
 	struct tid_ampdu_rx *tid_agg_rx;
 	u16 capab, tid, timeout, ba_policy, buf_size, start_seq_num, status;
 	u8 dialog_token;
@@ -233,13 +231,8 @@ void ieee80211_process_addba_request(str
 		goto end_no_lock;
 	}
 	/* determine default buffer size */
-	if (buf_size == 0) {
-		struct ieee80211_supported_band *sband;
-
-		sband = local->hw.wiphy->bands[conf->channel->band];
-		buf_size = IEEE80211_MIN_AMPDU_BUF;
-		buf_size = buf_size << sband->ht_cap.ampdu_factor;
-	}
+	if (buf_size == 0)
+		buf_size = IEEE80211_MAX_AMPDU_BUF;
 
 
 	/* examine state machine */


