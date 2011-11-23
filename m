Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759462Ab1KWAsg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:48:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42976 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759342Ab1KWAlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:41:49 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Nov 22 16:24:05 2011
Message-Id: <20111123002405.543519561@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Tue, 22 Nov 2011 16:23:17 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [10/53] mac80211: fix NULL dereference in radiotap code
In-Reply-To: <20111123002419.GA8531@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit f8d1ccf15568268c76f913b45ecdd33134387f1a upstream.

When receiving failed PLCP frames is enabled, there
won't be a rate pointer when we add the radiotap
header and thus the kernel will crash. Fix this by
not assuming the rate pointer is always valid. It's
still always valid for frames that have good PLCP
though, and that is checked & enforced.

This was broken by my
commit fc88518916793af8ad6a02e05ff254d95c36d875
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Fri Jul 30 13:23:12 2010 +0200

    mac80211: don't check rates on PLCP error frames

where I removed the check in this case but didn't
take into account that the rate info would be used.

Reported-by: Xiaokang Qin <xiaokang.qin@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/rx.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -140,8 +140,9 @@ ieee80211_add_rx_radiotap_header(struct
 	pos++;
 
 	/* IEEE80211_RADIOTAP_RATE */
-	if (status->flag & RX_FLAG_HT) {
+	if (!rate || status->flag & RX_FLAG_HT) {
 		/*
+		 * Without rate information don't add it. If we have,
 		 * MCS information is a separate field in radiotap,
 		 * added below. The byte here is needed as padding
 		 * for the channel though, so initialise it to 0.
@@ -162,12 +163,14 @@ ieee80211_add_rx_radiotap_header(struct
 	else if (status->flag & RX_FLAG_HT)
 		put_unaligned_le16(IEEE80211_CHAN_DYN | IEEE80211_CHAN_2GHZ,
 				   pos);
-	else if (rate->flags & IEEE80211_RATE_ERP_G)
+	else if (rate && rate->flags & IEEE80211_RATE_ERP_G)
 		put_unaligned_le16(IEEE80211_CHAN_OFDM | IEEE80211_CHAN_2GHZ,
 				   pos);
-	else
+	else if (rate)
 		put_unaligned_le16(IEEE80211_CHAN_CCK | IEEE80211_CHAN_2GHZ,
 				   pos);
+	else
+		put_unaligned_le16(IEEE80211_CHAN_2GHZ, pos);
 	pos += 2;
 
 	/* IEEE80211_RADIOTAP_DBM_ANTSIGNAL */


