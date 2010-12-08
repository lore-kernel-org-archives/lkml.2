Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932408Ab0LHBwa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:52:30 -0500
Received: from kroah.org ([198.145.64.141]:48602 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756950Ab0LHA7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:59:47 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:26 2010
Message-Id: <20101208005726.635972066@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:57:10 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Paul Stewart <pstew@google.com>, Amod Bodas <amod.bodas@atheros.com>,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [053/289] mac80211: send last 3/5 probe requests as unicast
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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

---
 net/mac80211/mlme.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1022,10 +1022,19 @@ static void ieee80211_mgd_probe_ap_send(
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


