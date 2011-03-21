Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab1CUXqo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:46:44 -0400
Received: from kroah.org ([198.145.64.141]:49440 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754861Ab1CUXPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:15:37 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:07:13 2011
Message-Id: <20110321230713.191113941@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:06:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [39/87] ath9k: remove support for the FIF_PROMISC_IN_BSS filter flag
In-Reply-To: <20110321230732.GA26510@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 2e286947f1294239527c11f9f466ddce6466455b upstream.

The hardware rx filter flag triggered by FIF_PROMISC_IN_BSS is overly broad
and covers even frames with PHY errors. When this flag is enabled, this message
shows up frequently during scanning or hardware resets:

ath: Could not stop RX, we could be confusing the DMA engine when we start RX up

Since promiscuous mode is usually not particularly useful, yet enabled by
default by bridging (either used normally in 4-addr mode, or with hacks
for various virtualization software), we should sacrifice it for better
reliability during normal operation.

This patch leaves it enabled if there are active monitor mode interfaces, since
it's very useful for debugging.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/recv.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -439,9 +439,7 @@ u32 ath_calcrxfilter(struct ath_softc *s
 	 * mode interface or when in monitor mode. AP mode does not need this
 	 * since it receives all in-BSS frames anyway.
 	 */
-	if (((sc->sc_ah->opmode != NL80211_IFTYPE_AP) &&
-	     (sc->rx.rxfilter & FIF_PROMISC_IN_BSS)) ||
-	    (sc->sc_ah->is_monitoring))
+	if (sc->sc_ah->is_monitoring)
 		rfilt |= ATH9K_RX_FILTER_PROM;
 
 	if (sc->rx.rxfilter & FIF_CONTROL)


