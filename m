Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758911Ab0G3RXs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:23:48 -0400
Received: from kroah.org ([198.145.64.141]:52304 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758782Ab0G3RUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:20:24 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:13 2010
Message-Id: <20100730171513.567445430@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:16:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [154/165] mac80211: fix supported rates IE if AP doesnt give us its rates
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

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
 net/mac80211/mlme.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -269,12 +269,6 @@ static void ieee80211_send_assoc(struct
 	if (wk->bss->wmm_used)
 		wmm = 1;
 
-	/* get all rates supported by the device and the AP as
-	 * some APs don't like getting a superset of their rates
-	 * in the association request (e.g. D-Link DAP 1353 in
-	 * b-only mode) */
-	rates_len = ieee80211_compatible_rates(wk->bss, sband, &rates);
-
 	if ((wk->bss->cbss.capability & WLAN_CAPABILITY_SPECTRUM_MGMT) &&
 	    (local->hw.flags & IEEE80211_HW_SPECTRUM_MGMT))
 		capab |= WLAN_CAPABILITY_SPECTRUM_MGMT;
@@ -309,6 +303,17 @@ static void ieee80211_send_assoc(struct
 	*pos++ = wk->ssid_len;
 	memcpy(pos, wk->ssid, wk->ssid_len);
 
+	if (wk->bss->supp_rates_len) {
+		/* get all rates supported by the device and the AP as
+		 * some APs don't like getting a superset of their rates
+		 * in the association request (e.g. D-Link DAP 1353 in
+		 * b-only mode) */
+		rates_len = ieee80211_compatible_rates(wk->bss, sband, &rates);
+	} else {
+		rates = ~0;
+		rates_len = sband->n_bitrates;
+	}
+
 	/* add all rates which were marked to be used above */
 	supp_rates_len = rates_len;
 	if (supp_rates_len > 8)


