Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932423Ab0G3Rfr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:35:47 -0400
Received: from kroah.org ([198.145.64.141]:35672 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759390Ab0G3Rea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:34:30 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:31:06 2010
Message-Id: <20100730173106.441098554@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:30:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [041/140] mac80211: do not wip out old supported rates
In-Reply-To: <20100730173205.GA22581@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit f0b058b61711ebf5be94d6865ca7b2c259b71d37 upstream.

Use old supported rates, if AP do not provide supported rates
information element in a new managment frame.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/scan.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -60,7 +60,7 @@ ieee80211_bss_info_update(struct ieee802
 			  bool beacon)
 {
 	struct ieee80211_bss *bss;
-	int clen;
+	int clen, srlen;
 	s32 signal = 0;
 
 	if (local->hw.flags & IEEE80211_HW_SIGNAL_DBM)
@@ -92,23 +92,24 @@ ieee80211_bss_info_update(struct ieee802
 	if (bss->dtim_period == 0)
 		bss->dtim_period = 1;
 
-	bss->supp_rates_len = 0;
+	/* replace old supported rates if we get new values */
+	srlen = 0;
 	if (elems->supp_rates) {
-		clen = IEEE80211_MAX_SUPP_RATES - bss->supp_rates_len;
+		clen = IEEE80211_MAX_SUPP_RATES;
 		if (clen > elems->supp_rates_len)
 			clen = elems->supp_rates_len;
-		memcpy(&bss->supp_rates[bss->supp_rates_len], elems->supp_rates,
-		       clen);
-		bss->supp_rates_len += clen;
+		memcpy(bss->supp_rates, elems->supp_rates, clen);
+		srlen += clen;
 	}
 	if (elems->ext_supp_rates) {
-		clen = IEEE80211_MAX_SUPP_RATES - bss->supp_rates_len;
+		clen = IEEE80211_MAX_SUPP_RATES - srlen;
 		if (clen > elems->ext_supp_rates_len)
 			clen = elems->ext_supp_rates_len;
-		memcpy(&bss->supp_rates[bss->supp_rates_len],
-		       elems->ext_supp_rates, clen);
-		bss->supp_rates_len += clen;
+		memcpy(bss->supp_rates + srlen, elems->ext_supp_rates, clen);
+		srlen += clen;
 	}
+	if (srlen)
+		bss->supp_rates_len = srlen;
 
 	bss->wmm_used = elems->wmm_param || elems->wmm_info;
 


