Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123Ab0LHCCA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 21:02:00 -0500
Received: from kroah.org ([198.145.64.141]:48355 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755519Ab0LHA7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:59:08 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:22 2010
Message-Id: <20101208005722.692677295@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:56:30 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [013/289] ath9k: fix channel flag / regd issues with multiple cards
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit f209f5298217cf54cd5a9163e18b08d093faf8d9 upstream.

Since the regulatory code touches the channel array, it needs to be
copied for each device instance. That way the original channel array
can also be made const.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/init.c |   37 ++++++++++++++++++++++++++++------
 1 file changed, 31 insertions(+), 6 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -56,7 +56,7 @@ MODULE_PARM_DESC(blink, "Enable LED blin
  * on 5 MHz steps, we support the channels which we know
  * we have calibration data for all cards though to make
  * this static */
-static struct ieee80211_channel ath9k_2ghz_chantable[] = {
+static const struct ieee80211_channel ath9k_2ghz_chantable[] = {
 	CHAN2G(2412, 0), /* Channel 1 */
 	CHAN2G(2417, 1), /* Channel 2 */
 	CHAN2G(2422, 2), /* Channel 3 */
@@ -77,7 +77,7 @@ static struct ieee80211_channel ath9k_2g
  * on 5 MHz steps, we support the channels which we know
  * we have calibration data for all cards though to make
  * this static */
-static struct ieee80211_channel ath9k_5ghz_chantable[] = {
+static const struct ieee80211_channel ath9k_5ghz_chantable[] = {
 	/* _We_ call this UNII 1 */
 	CHAN5G(5180, 14), /* Channel 36 */
 	CHAN5G(5200, 15), /* Channel 40 */
@@ -477,10 +477,17 @@ err:
 	return -EIO;
 }
 
-static void ath9k_init_channels_rates(struct ath_softc *sc)
+static int ath9k_init_channels_rates(struct ath_softc *sc)
 {
+	void *channels;
+
 	if (test_bit(ATH9K_MODE_11G, sc->sc_ah->caps.wireless_modes)) {
-		sc->sbands[IEEE80211_BAND_2GHZ].channels = ath9k_2ghz_chantable;
+		channels = kmemdup(ath9k_2ghz_chantable,
+			sizeof(ath9k_2ghz_chantable), GFP_KERNEL);
+		if (!channels)
+		    return -ENOMEM;
+
+		sc->sbands[IEEE80211_BAND_2GHZ].channels = channels;
 		sc->sbands[IEEE80211_BAND_2GHZ].band = IEEE80211_BAND_2GHZ;
 		sc->sbands[IEEE80211_BAND_2GHZ].n_channels =
 			ARRAY_SIZE(ath9k_2ghz_chantable);
@@ -490,7 +497,15 @@ static void ath9k_init_channels_rates(st
 	}
 
 	if (test_bit(ATH9K_MODE_11A, sc->sc_ah->caps.wireless_modes)) {
-		sc->sbands[IEEE80211_BAND_5GHZ].channels = ath9k_5ghz_chantable;
+		channels = kmemdup(ath9k_5ghz_chantable,
+			sizeof(ath9k_5ghz_chantable), GFP_KERNEL);
+		if (!channels) {
+			if (sc->sbands[IEEE80211_BAND_2GHZ].channels)
+				kfree(sc->sbands[IEEE80211_BAND_2GHZ].channels);
+			return -ENOMEM;
+		}
+
+		sc->sbands[IEEE80211_BAND_5GHZ].channels = channels;
 		sc->sbands[IEEE80211_BAND_5GHZ].band = IEEE80211_BAND_5GHZ;
 		sc->sbands[IEEE80211_BAND_5GHZ].n_channels =
 			ARRAY_SIZE(ath9k_5ghz_chantable);
@@ -499,6 +514,7 @@ static void ath9k_init_channels_rates(st
 		sc->sbands[IEEE80211_BAND_5GHZ].n_bitrates =
 			ARRAY_SIZE(ath9k_legacy_rates) - 4;
 	}
+	return 0;
 }
 
 static void ath9k_init_misc(struct ath_softc *sc)
@@ -593,8 +609,11 @@ static int ath9k_init_softc(u16 devid, s
 	if (ret)
 		goto err_btcoex;
 
+	ret = ath9k_init_channels_rates(sc);
+	if (ret)
+		goto err_btcoex;
+
 	ath9k_init_crypto(sc);
-	ath9k_init_channels_rates(sc);
 	ath9k_init_misc(sc);
 
 	return 0;
@@ -751,6 +770,12 @@ static void ath9k_deinit_softc(struct at
 {
 	int i = 0;
 
+	if (sc->sbands[IEEE80211_BAND_2GHZ].channels)
+		kfree(sc->sbands[IEEE80211_BAND_2GHZ].channels);
+
+	if (sc->sbands[IEEE80211_BAND_5GHZ].channels)
+		kfree(sc->sbands[IEEE80211_BAND_5GHZ].channels);
+
         if ((sc->btcoex.no_stomp_timer) &&
 	    sc->sc_ah->btcoex_hw.scheme == ATH_BTCOEX_CFG_3WIRE)
 		ath_gen_timer_free(sc->sc_ah, sc->btcoex.no_stomp_timer);


