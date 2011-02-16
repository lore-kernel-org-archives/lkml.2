Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757107Ab1BPAUT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:20:19 -0500
Received: from kroah.org ([198.145.64.141]:39037 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756975Ab1BPAUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:20:11 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:33 2011
Message-Id: <20110216001433.228849239@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:12:18 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Easwar Krishnan <easwar.krishnan@atheros.com>,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [081/272] cfg80211: fix allowing country IEs for WIPHY_FLAG_STRICT_REGULATORY
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Luis R. Rodriguez <lrodriguez@atheros.com>

commit 749b527b21465fb079796c03ffb4302584dc31c1 upstream.

We should be enabling country IE hints for WIPHY_FLAG_STRICT_REGULATORY
even if we haven't yet recieved regulatory domain hint for the driver
if it needed one. Without this Country IEs are not passed on to drivers
that have set WIPHY_FLAG_STRICT_REGULATORY, today this is just all
Atheros chipset drivers: ath5k, ath9k, ar9170, carl9170.

This was part of the original design, however it was completely
overlooked...

Cc: Easwar Krishnan <easwar.krishnan@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/net/cfg80211.h |   15 ++++++++-------
 net/wireless/reg.c     |    1 +
 2 files changed, 9 insertions(+), 7 deletions(-)

--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1321,13 +1321,14 @@ struct cfg80211_ops {
  * 	initiator is %REGDOM_SET_BY_CORE).
  * @WIPHY_FLAG_STRICT_REGULATORY: tells us the driver for this device will
  *	ignore regulatory domain settings until it gets its own regulatory
- *	domain via its regulatory_hint(). After its gets its own regulatory
- *	domain it will only allow further regulatory domain settings to
- *	further enhance compliance. For example if channel 13 and 14 are
- *	disabled by this regulatory domain no user regulatory domain can
- *	enable these channels at a later time. This can be used for devices
- *	which do not have calibration information gauranteed for frequencies
- *	or settings outside of its regulatory domain.
+ *	domain via its regulatory_hint() unless the regulatory hint is
+ *	from a country IE. After its gets its own regulatory domain it will
+ *	only allow further regulatory domain settings to further enhance
+ *	compliance. For example if channel 13 and 14 are disabled by this
+ *	regulatory domain no user regulatory domain can enable these channels
+ *	at a later time. This can be used for devices which do not have
+ *	calibration information guaranteed for frequencies or settings
+ *	outside of its regulatory domain.
  * @WIPHY_FLAG_DISABLE_BEACON_HINTS: enable this if your driver needs to ensure
  *	that passive scan flags and beaconing flags may not be lifted by
  *	cfg80211 due to regulatory beacon hints. For more information on beacon
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -813,6 +813,7 @@ static bool ignore_reg_update(struct wip
 	 * desired regulatory domain set
 	 */
 	if (wiphy->flags & WIPHY_FLAG_STRICT_REGULATORY && !wiphy->regd &&
+	    initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE &&
 	    !is_world_regdom(last_request->alpha2))
 		return true;
 	return false;


