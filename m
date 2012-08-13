Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434Ab2HMWQx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 18:16:53 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43626 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755420Ab2HMWQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 18:16:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 28/65] wireless: reg: restore previous behaviour of chan->max_power calculations
Date: Mon, 13 Aug 2012 15:14:12 -0700
Message-Id: <20120813221417.437614172@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813221414.965154048@linuxfoundation.org>
References: <20120813221414.965154048@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit 5e31fc0815a4e2c72b1b495fe7a0d8f9bfb9e4b4 upstream.

commit eccc068e8e84c8fe997115629925e0422a98e4de
Author: Hong Wu <Hong.Wu@dspg.com>
Date:   Wed Jan 11 20:33:39 2012 +0200

    wireless: Save original maximum regulatory transmission power for the calucation of the local maximum transmit pow

changed the way we calculate chan->max_power as min(chan->max_power,
chan->max_reg_power). That broke rt2x00 (and perhaps some other
drivers) that do not set chan->max_power. It is not so easy to fix this
problem correctly in rt2x00.

According to commit eccc068e8 changelog, change claim only to save
maximum regulatory power - changing setting of chan->max_power was side
effect. This patch restore previous calculations of chan->max_power and
do not touch chan->max_reg_power.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/wireless/reg.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -891,7 +891,21 @@ static void handle_channel(struct wiphy
 	chan->max_antenna_gain = min(chan->orig_mag,
 		(int) MBI_TO_DBI(power_rule->max_antenna_gain));
 	chan->max_reg_power = (int) MBM_TO_DBM(power_rule->max_eirp);
-	chan->max_power = min(chan->max_power, chan->max_reg_power);
+	if (chan->orig_mpwr) {
+		/*
+		 * Devices that have their own custom regulatory domain
+		 * but also use WIPHY_FLAG_STRICT_REGULATORY will follow the
+		 * passed country IE power settings.
+		 */
+		if (initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE &&
+		    wiphy->flags & WIPHY_FLAG_CUSTOM_REGULATORY &&
+		    wiphy->flags & WIPHY_FLAG_STRICT_REGULATORY)
+			chan->max_power = chan->max_reg_power;
+		else
+			chan->max_power = min(chan->orig_mpwr,
+					      chan->max_reg_power);
+	} else
+		chan->max_power = chan->max_reg_power;
 }
 
 static void handle_band(struct wiphy *wiphy,


