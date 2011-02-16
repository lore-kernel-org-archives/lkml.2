Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756997Ab1BPBnL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:43:11 -0500
Received: from kroah.org ([198.145.64.141]:38902 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756902Ab1BPATj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:19:39 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:31 2011
Message-Id: <20110216001431.237233003@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:11:58 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Paul Stewart <pstew@google.com>, Amod Bodas <amod.bodas@atheros.com>,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [061/272] ath9k: fix aphy / wiphy idle mismatch
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Luis R. Rodriguez <lrodriguez@atheros.com>

commit afe68d0a8f5961652e26cea39d74e2cc820de841 upstream.

ath9k supports its own set of virtual wiphys, and it uses
the mac80211 idle notifications to know when a device needs
to be idle or not. We recently changed ath9k to force idle
on driver stop() and on resume but forgot to take into account
ath9k's own virtual wiphy idle states. These are used internally
by ath9k to check if the device's radio should be powered down
on each idle call. Without this change its possible that the
device could have been forced off but the virtual wiphy idle
was left on.

Cc: Paul Stewart <pstew@google.com>
Cc: Amod Bodas <amod.bodas@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/main.c |    1 +
 drivers/net/wireless/ath/ath9k/pci.c  |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1419,6 +1419,7 @@ static void ath9k_stop(struct ieee80211_
 	ath9k_ps_restore(sc);
 
 	sc->ps_idle = true;
+	ath9k_set_wiphy_idle(aphy, true);
 	ath_radio_disable(sc, hw);
 
 	sc->sc_flags |= SC_OP_INVALID;
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -291,6 +291,7 @@ static int ath_pci_resume(struct pci_dev
 	ath9k_hw_set_gpio(sc->sc_ah, sc->sc_ah->led_pin, 1);
 
 	sc->ps_idle = true;
+	ath9k_set_wiphy_idle(aphy, true);
 	ath_radio_disable(sc, hw);
 
 	return 0;


