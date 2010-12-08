Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180Ab0LHBxn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:53:43 -0500
Received: from kroah.org ([198.145.64.141]:48568 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756940Ab0LHA7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:59:41 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:26 2010
Message-Id: <20101208005726.065079086@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:57:04 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [047/289] mac80211: fix channel assumption for association done work
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Luis R. Rodriguez <lrodriguez@atheros.com>

commit e7480bbb926c5816e4fbfca70748096bbe0e4978 upstream.

Be consistent and use the wk->chan instead of the
local->hw.conf.channel for the association done work.
This prevents any possible races against channel changes
while we run this work.

In the case that the race did happen we would be initializing
the bit rates for the new AP under the assumption of a wrong
channel and in the worst case, wrong band. This could lead
to trying to assuming we could use CCK frames on 5 GHz, for
example.

This patch has a fix for kernels >= v2.6.34

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/mlme.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1262,7 +1262,7 @@ static bool ieee80211_assoc_success(stru
 
 	rates = 0;
 	basic_rates = 0;
-	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+	sband = local->hw.wiphy->bands[wk->chan->band];
 
 	for (i = 0; i < elems.supp_rates_len; i++) {
 		int rate = (elems.supp_rates[i] & 0x7f) * 5;
@@ -1298,11 +1298,11 @@ static bool ieee80211_assoc_success(stru
 		}
 	}
 
-	sta->sta.supp_rates[local->hw.conf.channel->band] = rates;
+	sta->sta.supp_rates[wk->chan->band] = rates;
 	sdata->vif.bss_conf.basic_rates = basic_rates;
 
 	/* cf. IEEE 802.11 9.2.12 */
-	if (local->hw.conf.channel->band == IEEE80211_BAND_2GHZ &&
+	if (wk->chan->band == IEEE80211_BAND_2GHZ &&
 	    have_higher_than_11mbit)
 		sdata->flags |= IEEE80211_SDATA_OPERATING_GMODE;
 	else


