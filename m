Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757033Ab0LHByc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:54:32 -0500
Received: from kroah.org ([198.145.64.141]:48557 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756931Ab0LHA7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:59:39 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:25 2010
Message-Id: <20101208005725.840990321@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:57:02 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        =?ISO-8859-15?q?Bj=C3=B6rn=20Smedman?= <bjorn.smedman@venatech.se>,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [045/289] mac80211: minstrel_ht A-MPDU fix
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: =?UTF-8?q?Bj=C3=B6rn=20Smedman?= <bjorn.smedman@venatech.se>

commit 15d46f38df87f89242e470f5797120fa384c1fc3 upstream.

This patch fixes two problems with the minstrel_ht rate control
algorithms handling of A-MPDU frames:

1. The ampdu_len field of the tx status is not always initialized for
non-HT frames (and it would probably be unreasonable to require all
drivers to do so). This could cause rate control statistics to be
corrupted. We now trust the ampdu_len and ampdu_ack_len fields only when
the frame is marked with the IEEE80211_TX_STAT_AMPDU flag.

2. Successful transmission attempts where only recognized when the A-MPDU
subframe carrying the rate control status information was marked with the
IEEE80211_TX_STAT_ACK flag. If this information happed to be carried on a
frame that failed to be ACKed then the other subframes (which may have
succeeded) where not correctly registered. We now update rate control
statistics regardless of whether the subframe carrying the information was
ACKed or not.

Signed-off-by: Björn Smedman <bjorn.smedman@venatech.se>
Acked-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/rc80211_minstrel_ht.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -397,8 +397,9 @@ minstrel_ht_tx_status(void *priv, struct
 	    !(info->flags & IEEE80211_TX_STAT_AMPDU))
 		return;
 
-	if (!info->status.ampdu_len) {
-		info->status.ampdu_ack_len = 1;
+	if (!(info->flags & IEEE80211_TX_STAT_AMPDU)) {
+		info->status.ampdu_ack_len =
+			(info->flags & IEEE80211_TX_STAT_ACK ? 1 : 0);
 		info->status.ampdu_len = 1;
 	}
 
@@ -426,7 +427,7 @@ minstrel_ht_tx_status(void *priv, struct
 		group = minstrel_ht_get_group_idx(&ar[i]);
 		rate = &mi->groups[group].rates[ar[i].idx % 8];
 
-		if (last && (info->flags & IEEE80211_TX_STAT_ACK))
+		if (last)
 			rate->success += info->status.ampdu_ack_len;
 
 		rate->attempts += ar[i].count * info->status.ampdu_len;


