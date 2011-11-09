Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757192Ab1KJEX3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:23:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44128 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965232Ab1KJDkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:40:10 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:31:52 2011
Message-Id: <20111109213152.482831335@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:32:30 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Luciano Coelho <coelho@ti.com>
Subject: [103/264] wl12xx: fix forced passive scans
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luciano Coelho <coelho@ti.com>

commit 6cd9d21a0c1e2648c07c32c66bb25795ad3208aa upstream.

We were using incorrect max and min dwell times during forced passive
scans because we were still using the active scan states to scan
(passively) the channels that were not marked as passive.

Instead of doing passive scans in active states, we now skip active
states and scan for all channels in passive states.

Signed-off-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/wl12xx/scan.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

--- a/drivers/net/wireless/wl12xx/scan.c
+++ b/drivers/net/wireless/wl12xx/scan.c
@@ -83,14 +83,18 @@ static int wl1271_get_scan_channels(stru
 	for (i = 0, j = 0;
 	     i < req->n_channels && j < WL1271_SCAN_MAX_CHANNELS;
 	     i++) {
-
 		flags = req->channels[i]->flags;
 
 		if (!test_bit(i, wl->scan.scanned_ch) &&
 		    !(flags & IEEE80211_CHAN_DISABLED) &&
-		    ((!!(flags & IEEE80211_CHAN_PASSIVE_SCAN)) == passive) &&
-		    (req->channels[i]->band == band)) {
-
+		    (req->channels[i]->band == band) &&
+		    /*
+		     * In passive scans, we scan all remaining
+		     * channels, even if not marked as such.
+		     * In active scans, we only scan channels not
+		     * marked as passive.
+		     */
+		    (passive || !(flags & IEEE80211_CHAN_PASSIVE_SCAN))) {
 			wl1271_debug(DEBUG_SCAN, "band %d, center_freq %d ",
 				     req->channels[i]->band,
 				     req->channels[i]->center_freq);
@@ -142,6 +146,10 @@ static int wl1271_scan_send(struct wl127
 	int ret;
 	u16 scan_options = 0;
 
+	/* skip active scans if we don't have SSIDs */
+	if (!passive && wl->scan.req->n_ssids == 0)
+		return WL1271_NOTHING_TO_SCAN;
+
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
 	trigger = kzalloc(sizeof(*trigger), GFP_KERNEL);
 	if (!cmd || !trigger) {
@@ -152,8 +160,7 @@ static int wl1271_scan_send(struct wl127
 	/* We always use high priority scans */
 	scan_options = WL1271_SCAN_OPT_PRIORITY_HIGH;
 
-	/* No SSIDs means that we have a forced passive scan */
-	if (passive || wl->scan.req->n_ssids == 0)
+	if (passive)
 		scan_options |= WL1271_SCAN_OPT_PASSIVE;
 
 	cmd->params.scan_options = cpu_to_le16(scan_options);


