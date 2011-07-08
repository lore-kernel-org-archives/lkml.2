Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238Ab1GHFC6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:02:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41983 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754209Ab1GHFCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:02:52 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:16:57 2011
Message-Id: <20110708001657.158601365@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:16:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Nick Kossifidis <mickflemm@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [046/107] ath5k: Disable fast channel switching by default
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Nick Kossifidis <mickflemm@gmail.com>

commit a99168eece601d2a79ecfcb968ce226f2f30cf98 upstream.

Disable fast channel change by default on AR2413/AR5413 due to
some bug reports (it still works for me but it's better to be safe).
Add a module parameter "fastchanswitch" in case anyone wants to enable
it and play with it.

Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath5k/base.c  |   11 ++++++++++-
 drivers/net/wireless/ath/ath5k/reset.c |    5 ++++-
 2 files changed, 14 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -72,6 +72,11 @@ static int modparam_all_channels;
 module_param_named(all_channels, modparam_all_channels, bool, S_IRUGO);
 MODULE_PARM_DESC(all_channels, "Expose all channels the device can use.");
 
+static int modparam_fastchanswitch;
+module_param_named(fastchanswitch, modparam_fastchanswitch, bool, S_IRUGO);
+MODULE_PARM_DESC(fastchanswitch, "Enable fast channel switching for AR2413/AR5413 radios.");
+
+
 /* Module info */
 MODULE_AUTHOR("Jiri Slaby");
 MODULE_AUTHOR("Nick Kossifidis");
@@ -2644,6 +2649,7 @@ ath5k_reset(struct ath5k_softc *sc, stru
 	struct ath5k_hw *ah = sc->ah;
 	struct ath_common *common = ath5k_hw_common(ah);
 	int ret, ani_mode;
+	bool fast;
 
 	ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "resetting\n");
 
@@ -2663,7 +2669,10 @@ ath5k_reset(struct ath5k_softc *sc, stru
 	ath5k_drain_tx_buffs(sc);
 	if (chan)
 		sc->curchan = chan;
-	ret = ath5k_hw_reset(ah, sc->opmode, sc->curchan, chan != NULL,
+
+	fast = ((chan != NULL) && modparam_fastchanswitch) ? 1 : 0;
+
+	ret = ath5k_hw_reset(ah, sc->opmode, sc->curchan, fast,
 								skip_pcu);
 	if (ret) {
 		ATH5K_ERR(sc, "can't reset hardware (%d)\n", ret);
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -1119,8 +1119,11 @@ int ath5k_hw_reset(struct ath5k_hw *ah,
 			/* Non fatal, can happen eg.
 			 * on mode change */
 			ret = 0;
-		} else
+		} else {
+			ATH5K_DBG(ah->ah_sc, ATH5K_DEBUG_RESET,
+				"fast chan change successful\n");
 			return 0;
+		}
 	}
 
 	/*


