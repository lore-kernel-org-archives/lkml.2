Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862Ab0LHA70 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:59:26 -0500
Received: from kroah.org ([198.145.64.141]:48426 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756789Ab0LHA7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:59:19 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:23 2010
Message-Id: <20101208005723.789872348@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:56:41 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [024/289] ath9k: resume aggregation immediately after a hardware reset
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit fac6b6a065da42f826088c58bddad82e1b1ccb40 upstream.

Since aggregation is usually triggered by tx completion, a hardware
reset (because of beacon stuck, tx hang or baseband hang) can
significantly delay the transmission of the next AMPDU (until the next
tx completion event).
Fix this by rescheduling aggregation after such a reset.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/beacon.c |    2 +-
 drivers/net/wireless/ath/ath9k/main.c   |    4 ++--
 drivers/net/wireless/ath/ath9k/xmit.c   |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -366,7 +366,7 @@ void ath_beacon_tasklet(unsigned long da
 			ath_print(common, ATH_DBG_BEACON,
 				  "beacon is officially stuck\n");
 			sc->sc_flags |= SC_OP_TSF_RESET;
-			ath_reset(sc, false);
+			ath_reset(sc, true);
 		}
 
 		return;
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -554,7 +554,7 @@ void ath_hw_check(struct work_struct *wo
 
 		msleep(1);
 	}
-	ath_reset(sc, false);
+	ath_reset(sc, true);
 
 out:
 	ath9k_ps_restore(sc);
@@ -572,7 +572,7 @@ void ath9k_tasklet(unsigned long data)
 	ath9k_ps_wakeup(sc);
 
 	if (status & ATH9K_INT_FATAL) {
-		ath_reset(sc, false);
+		ath_reset(sc, true);
 		ath9k_ps_restore(sc);
 		return;
 	}
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2206,7 +2206,7 @@ static void ath_tx_complete_poll_work(st
 		ath_print(ath9k_hw_common(sc->sc_ah), ATH_DBG_RESET,
 			  "tx hung, resetting the chip\n");
 		ath9k_ps_wakeup(sc);
-		ath_reset(sc, false);
+		ath_reset(sc, true);
 		ath9k_ps_restore(sc);
 	}
 


