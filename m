Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942Ab1BPATr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:19:47 -0500
Received: from kroah.org ([198.145.64.141]:38895 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756897Ab1BPATh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:19:37 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:31 2011
Message-Id: <20110216001431.137023988@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:11:57 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Paul Stewart <pstew@google.com>, Amod Bodas <amod.bodas@atheros.com>,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [060/272] ath9k: fix assumptions for idle calls on suspend/resume
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Luis R. Rodriguez <lrodriguez@atheros.com>

commit a08e7ade9ddf4fe79576f953cc5c1725e944d26c upstream.

mac80211 will notify drivers when to go idle and ath9k
assumed that it would get further notifications for idle
states after a device stop() config call but as per agreed
semantics the idle state of the radio is left up to driver
after mac80211 issues the stop() callback. The driver is
resposnbile for ensuring the device remains idle after
that even between suspend / resume calls.

This fixes suspend/resume when you issue suspend and resume
twice on ath9k when ath9k_stop() was already called. We need
to put the radio to full sleep in order for resume to work
correctly.

What might seem fishy is we are turning the radio off
after resume. The reason why we do this is because we know
we should not have anything enabled after a mac80211 tells
us to stop(), if we resume and never get a start() we won't
get another stop() by mac80211 so to be safe always bring
the 802.11 device with the radio disabled after resume,
this ensures that if we suspend we already have the radio
disabled and only a start() will ever trigger it on.

Cc: Paul Stewart <pstew@google.com>
Cc: Amod Bodas <amod.bodas@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/main.c |    4 ++--
 drivers/net/wireless/ath/ath9k/pci.c  |    3 +++
 2 files changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1418,8 +1418,8 @@ static void ath9k_stop(struct ieee80211_
 	ath9k_hw_configpcipowersave(ah, 1, 1);
 	ath9k_ps_restore(sc);
 
-	/* Finally, put the chip in FULL SLEEP mode */
-	ath9k_setpower(sc, ATH9K_PM_FULL_SLEEP);
+	sc->ps_idle = true;
+	ath_radio_disable(sc, hw);
 
 	sc->sc_flags |= SC_OP_INVALID;
 
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -290,6 +290,9 @@ static int ath_pci_resume(struct pci_dev
 			    AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
 	ath9k_hw_set_gpio(sc->sc_ah, sc->sc_ah->led_pin, 1);
 
+	sc->ps_idle = true;
+	ath_radio_disable(sc, hw);
+
 	return 0;
 }
 


