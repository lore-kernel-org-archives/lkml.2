Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758361Ab1KSAOz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 19:14:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38652 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758416Ab1KSAJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 19:09:47 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Nov 18 16:03:29 2011
Message-Id: <20111119000329.329959267@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Fri, 18 Nov 2011 16:02:52 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Arend van Spriel <arend@broadcom.com>
Subject: [16/26] staging: brcm80211: fill in proper rx rate in mac80211 rx status
In-Reply-To: <20111119000336.GA8452@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arend van Spriel <arend@broadcom.com>

commit 5a84d6ad4c9306afb467a600a4c6d7b50da49440 upstream.

The brcmsmac driver supports different rates on 5GHz but this is not
taken into account when providing the rate index in the receive
status information passed to mac80211.

Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Henry Ptasinski <henryp@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c |    9 +++++++--
 drivers/staging/brcm80211/brcmsmac/mac80211_if.h |    6 ++++++
 drivers/staging/brcm80211/brcmsmac/main.c        |    8 ++++++++
 3 files changed, 21 insertions(+), 2 deletions(-)

--- a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
@@ -975,6 +975,10 @@ static struct ieee80211_channel brcms_5g
 	.hw_value = (rate100m / 5), \
 }
 
+/*
+ * The rate table is used for both 2.4G and 5G rates. The
+ * latter being a subset as it does not support CCK rates.
+ */
 static struct ieee80211_rate legacy_ratetable[] = {
 	RATE(10, 0),
 	RATE(20, IEEE80211_RATE_SHORT_PREAMBLE),
@@ -1016,8 +1020,9 @@ static struct ieee80211_supported_band b
 	.band = IEEE80211_BAND_5GHZ,
 	.channels = brcms_5ghz_nphy_chantable,
 	.n_channels = ARRAY_SIZE(brcms_5ghz_nphy_chantable),
-	.bitrates = legacy_ratetable + 4,
-	.n_bitrates = ARRAY_SIZE(legacy_ratetable) - 4,
+	.bitrates = legacy_ratetable + BRCMS_LEGACY_5G_RATE_OFFSET,
+	.n_bitrates = ARRAY_SIZE(legacy_ratetable) -
+			BRCMS_LEGACY_5G_RATE_OFFSET,
 	.ht_cap = {
 		   /* use IEEE80211_HT_CAP_* from include/linux/ieee80211.h */
 		   .cap = IEEE80211_HT_CAP_GRN_FLD | IEEE80211_HT_CAP_SGI_20 | IEEE80211_HT_CAP_SGI_40 | IEEE80211_HT_CAP_40MHZ_INTOLERANT,	/* No 40 mhz yet */
--- a/drivers/staging/brcm80211/brcmsmac/mac80211_if.h
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.h
@@ -20,6 +20,12 @@
 #include <linux/timer.h>
 #include <linux/interrupt.h>
 
+/*
+ * Starting index for 5G rates in the
+ * legacy rate table.
+ */
+#define BRCMS_LEGACY_5G_RATE_OFFSET	4
+
 /* softmac ioctl definitions */
 #define BRCMS_SET_SHORTSLOT_OVERRIDE		146
 
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -4608,6 +4608,14 @@ prep_mac80211_status(struct brcms_c_info
 			wiphy_err(wlc->wiphy, "%s: Unknown rate\n", __func__);
 		}
 
+		/*
+		 * For 5GHz, we should decrease the index as it is
+		 * a subset of the 2.4G rates. See bitrates field
+		 * of brcms_band_5GHz_nphy (in mac80211_if.c).
+		 */
+		if (rx_status->band == IEEE80211_BAND_5GHZ)
+			rx_status->rate_idx -= BRCMS_LEGACY_5G_RATE_OFFSET;
+
 		/* Determine short preamble and rate_idx */
 		preamble = 0;
 		if (IS_CCK(rspec)) {


