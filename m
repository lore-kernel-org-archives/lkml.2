Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933073Ab0G3SJr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:09:47 -0400
Received: from kroah.org ([198.145.64.141]:59188 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932764Ab0G3R5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:57:36 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:50 2010
Message-Id: <20100730175149.998070695@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:53:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [177/205] mac80211: fix supported rates IE if AP doesnt give us its rates
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit 76f273640134f3eb8257179cd5b3bc6ba5fe4a96 upstream.

If AP do not provide us supported rates before assiociation, send
all rates we are supporting instead of empty information element.

v1 -> v2: Add comment.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/work.c |   28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -213,15 +213,25 @@ static void ieee80211_send_assoc(struct
 
 	sband = local->hw.wiphy->bands[wk->chan->band];
 
-	/*
-	 * Get all rates supported by the device and the AP as
-	 * some APs don't like getting a superset of their rates
-	 * in the association request (e.g. D-Link DAP 1353 in
-	 * b-only mode)...
-	 */
-	rates_len = ieee80211_compatible_rates(wk->assoc.supp_rates,
-					       wk->assoc.supp_rates_len,
-					       sband, &rates);
+	if (wk->assoc.supp_rates_len) {
+		/*
+		 * Get all rates supported by the device and the AP as
+		 * some APs don't like getting a superset of their rates
+		 * in the association request (e.g. D-Link DAP 1353 in
+		 * b-only mode)...
+		 */
+		rates_len = ieee80211_compatible_rates(wk->assoc.supp_rates,
+						       wk->assoc.supp_rates_len,
+						       sband, &rates);
+	} else {
+		/*
+		 * In case AP not provide any supported rates information
+		 * before association, we send information element(s) with
+		 * all rates that we support.
+		 */
+		rates = ~0;
+		rates_len = sband->n_bitrates;
+	}
 
 	skb = alloc_skb(local->hw.extra_tx_headroom +
 			sizeof(*mgmt) + /* bit too much but doesn't matter */


