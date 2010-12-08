Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905Ab0LHCAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 21:00:53 -0500
Received: from kroah.org ([198.145.64.141]:48409 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756815Ab0LHA7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:59:17 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:23 2010
Message-Id: <20101208005723.585521192@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:56:39 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Paul Stewart <pstew@google.com>, Amod Bodas <amod.bodas@atheros.com>,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [022/289] ath9k: fix regression on beacon loss after bgscan
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Luis R. Rodriguez <lrodriguez@atheros.com>

commit 52b8ac92496e03d6b5619204d7f3bae6ce6eae45 upstream.

When we return to the home channel we were never reseting our beacon
timers, this was casued by the fact that the scanning flag was still
on even after we returned to our home channel. There are also other
reasons why we would get a reset and if we are not off channel
we always need to resynch our beacon timers, because a reset will
clear them.

This bug is a regression introduced on 2.6.36. The order of the
changes are as follows:

5ee08656 - Sat Jul 31 - ath9k: prevent calibration during off-channel activity
a0daa0e7 - Tue Jul 27 - Revert "mac80211: fix sw scan bracketing"
543708be - Fri Jun 18 - mac80211: fix sw scan bracketing

mcgrof@tux ~/linux-2.6-allstable (git::master)$ git describe \
        --contains 5ee0865615f65f84e6ee9174771a6716c29e08e1
v2.6.36-rc1~43^2~34^2~22

mcgrof@tux ~/linux-2.6-allstable (git::master)$ git describe \
        --contains a0daa0e7592ada797d6835f11529097aabc27ad2
v2.6.36-rc1~571^2~64^2~13

mcgrof@tux ~/linux-2.6-allstable (git::master)$ git describe \
        --contains 543708be320d7df692d24b349ca01a947b340764
v2.6.36-rc1~571^2~107^2~187

So 5ee08656 would have worked if a0daa0e7 was not committed but
it was so this means 5ee08656 was broken since it assumed that
when we were in the channel change routine the scan flag would
be lifted. As it turns out the scan flag will be set when we
are already on the home channel.

For more details refer to:

http://code.google.com/p/chromium-os/issues/detail?id=5715

These issues will need to be considered for our solution on
reshifting the scan complete callback location on mac80211 on
current development kernel work.

This patch has stable fixes which apply down to [2.6.36+]

Cc: Paul Stewart <pstew@google.com>
Cc: Amod Bodas <amod.bodas@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/main.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -257,9 +257,11 @@ int ath_set_channel(struct ath_softc *sc
 	if (!(sc->sc_flags & (SC_OP_OFFCHANNEL | SC_OP_SCANNING))) {
 		ath_start_ani(common);
 		ieee80211_queue_delayed_work(sc->hw, &sc->tx_complete_work, 0);
-		ath_beacon_config(sc, NULL);
 	}
 
+	if (!(sc->sc_flags & (SC_OP_OFFCHANNEL)))
+		ath_beacon_config(sc, NULL);
+
  ps_restore:
 	ath9k_ps_restore(sc);
 	return r;
@@ -953,7 +955,7 @@ int ath_reset(struct ath_softc *sc, bool
 
 	ath_update_txpow(sc);
 
-	if (sc->sc_flags & SC_OP_BEACONS)
+	if ((sc->sc_flags & SC_OP_BEACONS) || !(sc->sc_flags & (SC_OP_OFFCHANNEL)))
 		ath_beacon_config(sc, NULL);	/* restart beacons */
 
 	ath9k_hw_set_interrupts(ah, ah->imask);


