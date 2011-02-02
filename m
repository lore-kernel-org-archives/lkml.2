Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016Ab1BBBH1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 20:07:27 -0500
Received: from mga09.intel.com ([134.134.136.24]:36336 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752666Ab1BBAng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:43:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="703028324"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: rmanoharan@atheros.com, linville@tuxdriver.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [32/139] ath9k: Disable SWBA interrupt on remove_interface
Message-Id: <20110202004347.4F8CD3E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:43:47 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Rajkumar Manoharan <rmanoharan@atheros.com>

commit 46047784b8cdcfc916f6c1cccee0c18dd1223dfd upstream.

while removing beaconing mode interface, SWBA interrupt
was never disabled when there are no other beaconing interfaces.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/net/wireless/ath/ath9k/main.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

Index: linux-2.6.35.y/drivers/net/wireless/ath/ath9k/main.c
===================================================================
--- linux-2.6.35.y.orig/drivers/net/wireless/ath/ath9k/main.c
+++ linux-2.6.35.y/drivers/net/wireless/ath/ath9k/main.c
@@ -1501,6 +1501,7 @@ static void ath9k_remove_interface(struc
 	struct ath_softc *sc = aphy->sc;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_vif *avp = (void *)vif->drv_priv;
+	bool bs_valid = false;
 	int i;
 
 	ath_print(common, ATH_DBG_CONFIG, "Detach Interface\n");
@@ -1529,7 +1530,15 @@ static void ath9k_remove_interface(struc
 			       "slot\n", __func__);
 			sc->beacon.bslot[i] = NULL;
 			sc->beacon.bslot_aphy[i] = NULL;
-		}
+		} else if (sc->beacon.bslot[i])
+			bs_valid = true;
+	}
+	if (!bs_valid && (sc->sc_ah->imask & ATH9K_INT_SWBA)) {
+		/* Disable SWBA interrupt */
+		sc->sc_ah->imask &= ~ATH9K_INT_SWBA;
+		ath9k_ps_wakeup(sc);
+		ath9k_hw_set_interrupts(sc->sc_ah, sc->sc_ah->imask);
+		ath9k_ps_restore(sc);
 	}
 
 	sc->nvifs--;
