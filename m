Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965056Ab1KJDia (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:38:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43910 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935960Ab1KJDiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:38:17 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:31:49 2011
Message-Id: <20111109213149.148106238@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:31:57 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [070/264] ath9k: disable unnecessary PHY error reporting
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit ac06697c79bad09e44a8b1d52104014016fb90de upstream.

PHY errors relevant for ANI are always tracked by hardware counters, the
bits that allow them to pass through the rx filter are independent of that.
Enabling PHY errors in the rx filter often creates lots of useless DMA traffic
and might be responsible for some of the rx dma stop failure warnings.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/ani.c  |    5 -----
 drivers/net/wireless/ath/ath9k/recv.c |    5 +----
 2 files changed, 1 insertion(+), 9 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -502,9 +502,6 @@ static void ath9k_ani_reset_old(struct a
 		ath9k_hw_ani_control(ah, ATH9K_ANI_CCK_WEAK_SIGNAL_THR,
 				     ATH9K_ANI_CCK_WEAK_SIG_THR);
 
-		ath9k_hw_setrxfilter(ah, ath9k_hw_getrxfilter(ah) |
-				     ATH9K_RX_FILTER_PHYERR);
-
 		ath9k_ani_restart(ah);
 		return;
 	}
@@ -525,8 +522,6 @@ static void ath9k_ani_reset_old(struct a
 		ath9k_hw_ani_control(ah, ATH9K_ANI_FIRSTEP_LEVEL,
 				     aniState->firstepLevel);
 
-	ath9k_hw_setrxfilter(ah, ath9k_hw_getrxfilter(ah) &
-			     ~ATH9K_RX_FILTER_PHYERR);
 	ath9k_ani_restart(ah);
 
 	ENABLE_REGWRITE_BUFFER(ah);
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -433,12 +433,9 @@ void ath_rx_cleanup(struct ath_softc *sc
 
 u32 ath_calcrxfilter(struct ath_softc *sc)
 {
-#define	RX_FILTER_PRESERVE (ATH9K_RX_FILTER_PHYERR | ATH9K_RX_FILTER_PHYRADAR)
-
 	u32 rfilt;
 
-	rfilt = (ath9k_hw_getrxfilter(sc->sc_ah) & RX_FILTER_PRESERVE)
-		| ATH9K_RX_FILTER_UCAST | ATH9K_RX_FILTER_BCAST
+	rfilt = ATH9K_RX_FILTER_UCAST | ATH9K_RX_FILTER_BCAST
 		| ATH9K_RX_FILTER_MCAST;
 
 	if (sc->rx.rxfilter & FIF_PROBE_REQ)


