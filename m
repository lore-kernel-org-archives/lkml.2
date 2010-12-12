Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411Ab0LLXpu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:45:50 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44648 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282Ab0LLXpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:45:16 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: lrodriguez@atheros.com, pstew@google.com, amod.bodas@atheros.com,
        linville@tuxdriver.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [19/223] mac80211: send last 3/5 probe requests as unicast
Message-Id: <20101212234514.CA59FB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:45:14 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Luis R. Rodriguez <lrodriguez@atheros.com>

commit f01a067d9e4598c71e3c9ee3a84859d2e8af4f8e upstream.

Some buggy APs do not respond to unicast probe requests
or send unicast probe requests very delayed so in the
worst case we should try to send broadcast probe requests,
otherwise we can get disconnected from these APs.

Even if drivers do not have filters to disregard probe
responses from foreign APs mac80211 will only process
probe responses from our associated AP for re-arming
connection monitoring.

We need to do this since the beacon monitor does not
push back the connection monitor by design so even if we
are getting beacons from these type of APs our connection
monitor currently relies heavily on the way the probe
requests are received on the AP. An example of an AP
affected by this is the Nexus One, but this has also been
observed with random APs.

We can probably optimize this later by using null funcs
instead of probe requests.

For more details refer to:

http://code.google.com/p/chromium-os/issues/detail?id=5715

This patch has fixes for stable kernels [2.6.35+].

Cc: Paul Stewart <pstew@google.com>
Cc: Amod Bodas <amod.bodas@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/mac80211/mlme.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

Index: linux/net/mac80211/mlme.c
===================================================================
--- linux.orig/net/mac80211/mlme.c
+++ linux/net/mac80211/mlme.c
@@ -970,10 +970,19 @@ static void ieee80211_mgd_probe_ap_send(
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	const u8 *ssid;
+	u8 *dst = ifmgd->associated->bssid;
+	u8 unicast_limit = max(1, IEEE80211_MAX_PROBE_TRIES - 3);
+
+	/*
+	 * Try sending broadcast probe requests for the last three
+	 * probe requests after the first ones failed since some
+	 * buggy APs only support broadcast probe requests.
+	 */
+	if (ifmgd->probe_send_count >= unicast_limit)
+		dst = NULL;
 
 	ssid = ieee80211_bss_get_ie(ifmgd->associated, WLAN_EID_SSID);
-	ieee80211_send_probe_req(sdata, ifmgd->associated->bssid,
-				 ssid + 2, ssid[1], NULL, 0);
+	ieee80211_send_probe_req(sdata, dst, ssid + 2, ssid[1], NULL, 0);
 
 	ifmgd->probe_send_count++;
 	ifmgd->probe_timeout = jiffies + IEEE80211_PROBE_WAIT;
