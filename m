Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918Ab1BPBjQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:39:16 -0500
Received: from kroah.org ([198.145.64.141]:39045 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757074Ab1BPAUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:20:13 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:33 2011
Message-Id: <20110216001433.317172788@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:12:19 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Quan <david.quan@atheros.com>,
        Jouni Malinen <jouni.malinen@atheros.com>,
        Easwar Krishnan <easwar.krishnan@atheros.com>,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [082/272] cfg80211: fix disabling channels based on hints
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Luis R. Rodriguez <lrodriguez@atheros.com>

commit ca4ffe8f2848169a8ded0ea8a60b2d81925564c9 upstream.

After a module loads you will have loaded the world roaming regulatory
domain or a custom regulatory domain. Further regulatory hints are
welcomed and should be respected unless the regulatory hint is coming
from a country IE as the IEEE spec allows for a country IE to be a subset
of what is allowed by the local regulatory agencies.

So disable all channels that do not fit a regulatory domain sent
from a unless the hint is from a country IE and the country IE had
no information about the band we are currently processing.

This fixes a few regulatory issues, for example for drivers that depend
on CRDA and had no 5 GHz freqencies allowed were not properly disabling
5 GHz at all, furthermore it also allows users to restrict devices
further as was intended.

If you recieve a country IE upon association we will also disable the
channels that are not allowed if the country IE had at least one
channel on the respective band we are procesing.

This was the original intention behind this design but it was
completely overlooked...

Cc: David Quan <david.quan@atheros.com>
Cc: Jouni Malinen <jouni.malinen@atheros.com>
cc: Easwar Krishnan <easwar.krishnan@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/nl80211.h |    6 +++++-
 net/wireless/reg.c      |   20 +++++++++++++++++++-
 2 files changed, 24 insertions(+), 2 deletions(-)

--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1307,7 +1307,11 @@ enum nl80211_bitrate_attr {
  * 	wireless core it thinks its knows the regulatory domain we should be in.
  * @NL80211_REGDOM_SET_BY_COUNTRY_IE: the wireless core has received an
  * 	802.11 country information element with regulatory information it
- * 	thinks we should consider.
+ * 	thinks we should consider. cfg80211 only processes the country
+ *	code from the IE, and relies on the regulatory domain information
+ *	structure pased by userspace (CRDA) from our wireless-regdb.
+ *	If a channel is enabled but the country code indicates it should
+ *	be disabled we disable the channel and re-enable it upon disassociation.
  */
 enum nl80211_reg_initiator {
 	NL80211_REGDOM_SET_BY_CORE,
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -750,8 +750,26 @@ static void handle_channel(struct wiphy
 			  desired_bw_khz,
 			  &reg_rule);
 
-	if (r)
+	if (r) {
+		/*
+		 * We will disable all channels that do not match our
+		 * recieved regulatory rule unless the hint is coming
+		 * from a Country IE and the Country IE had no information
+		 * about a band. The IEEE 802.11 spec allows for an AP
+		 * to send only a subset of the regulatory rules allowed,
+		 * so an AP in the US that only supports 2.4 GHz may only send
+		 * a country IE with information for the 2.4 GHz band
+		 * while 5 GHz is still supported.
+		 */
+		if (initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE &&
+		    r == -ERANGE)
+			return;
+
+		REG_DBG_PRINT("cfg80211: Disabling freq %d MHz\n",
+			      chan->center_freq);
+		chan->flags = IEEE80211_CHAN_DISABLED;
 		return;
+	}
 
 	power_rule = &reg_rule->power_rule;
 	freq_range = &reg_rule->freq_range;


