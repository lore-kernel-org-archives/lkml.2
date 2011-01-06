Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080Ab1AFA3a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:29:30 -0500
Received: from kroah.org ([198.145.64.141]:35574 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754045Ab1AFA3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:29:25 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:00 2011
Message-Id: <20110106002300.139856997@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:22:16 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Rajkumar Manoharan <rmanoharan@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [037/152] ath9k: Disable SWBA interrupt on remove_interface
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Rajkumar Manoharan <rmanoharan@atheros.com>

commit 46047784b8cdcfc916f6c1cccee0c18dd1223dfd upstream.

while removing beaconing mode interface, SWBA interrupt
was never disabled when there are no other beaconing interfaces.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/main.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1484,6 +1484,7 @@ static void ath9k_remove_interface(struc
 	struct ath_softc *sc = aphy->sc;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_vif *avp = (void *)vif->drv_priv;
+	bool bs_valid = false;
 	int i;
 
 	ath_print(common, ATH_DBG_CONFIG, "Detach Interface\n");
@@ -1512,7 +1513,15 @@ static void ath9k_remove_interface(struc
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


