Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286Ab1HCXcF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:32:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34241 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756349Ab1HCXbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:31:12 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Aug  3 15:12:52 2011
Message-Id: <20110803221252.604974758@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 03 Aug 2011 15:01:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sven Neumann <s.neumann@raumfeld.com>, linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        Daniel Mack <daniel@zonque.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [085/102] cfg80211: really ignore the regulatory request
In-Reply-To: <20110803221345.GA10346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sven Neumann <s.neumann@raumfeld.com>

commit a203c2aa4cefccb879c879b8e1cad1a09a679e55 upstream.

At the beginning of wiphy_update_regulatory() a check is performed
whether the request is to be ignored. Then the request is sent to
the driver nevertheless. This happens even if last_request points
to NULL, leading to a crash in the driver:

 [<bf01d864>] (lbs_set_11d_domain_info+0x28/0x1e4 [libertas]) from [<c03b714c>] (wiphy_update_regulatory+0x4d0/0x4f4)
 [<c03b714c>] (wiphy_update_regulatory+0x4d0/0x4f4) from [<c03b4008>] (wiphy_register+0x354/0x420)
 [<c03b4008>] (wiphy_register+0x354/0x420) from [<bf01b17c>] (lbs_cfg_register+0x80/0x164 [libertas])
 [<bf01b17c>] (lbs_cfg_register+0x80/0x164 [libertas]) from [<bf020e64>] (lbs_start_card+0x20/0x88 [libertas])
 [<bf020e64>] (lbs_start_card+0x20/0x88 [libertas]) from [<bf02cbd8>] (if_sdio_probe+0x898/0x9c0 [libertas_sdio])

Fix this by returning early. Also remove the out: label as it is
not any longer needed.

Signed-off-by: Sven Neumann <s.neumann@raumfeld.com>
Cc: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Daniel Mack <daniel@zonque.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/wireless/reg.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1125,12 +1125,13 @@ void wiphy_update_regulatory(struct wiph
 	enum ieee80211_band band;
 
 	if (ignore_reg_update(wiphy, initiator))
-		goto out;
+		return;
+
 	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
 		if (wiphy->bands[band])
 			handle_band(wiphy, band, initiator);
 	}
-out:
+
 	reg_process_beacons(wiphy);
 	reg_process_ht_flags(wiphy);
 	if (wiphy->reg_notifier)


