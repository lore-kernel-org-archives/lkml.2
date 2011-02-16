Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028Ab1BPBmv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:42:51 -0500
Received: from kroah.org ([198.145.64.141]:38915 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756917Ab1BPATm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:19:42 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:31 2011
Message-Id: <20110216001431.433842637@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:12:00 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vasanthakumar Thiagarajan <vasanth@atheros.com>,
        Rajkumar Manoharan <rmanoharan@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [063/272] ath9k_hw: do PA offset calibration only on longcal interval
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Rajkumar Manoharan <rmanoharan@atheros.com>

commit 811ea256b30b37091b5bbf41517404cf98ab56c1 upstream.

The power detector adc offset calibration has to be done
on 4 minutes interval (longcal * pa_skip_count). But the commit
"ath9k_hw: fix a noise floor calibration related race condition"
makes the PA calibration executed more frequently beased on
nfcal_pending value. Running PAOffset calibration lesser than
longcal interval doesn't help anything and the worse part is that
it causes NF load timeouts and RX deaf conditions.

In a very noisy environment, where the distance b/w AP & station
is ~10 meter and running a downlink udp traffic with frequent
background scan causes "Timeout while waiting for nf to load:
AR_PHY_AGC_CONTROL=0x40d1a" and moves the chip into deaf state.
This issue was originaly reported in Android platform where
the network-manager application does bgscan more frequently
on AR9271 chips. (AR9285 family usb device).

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/ar9002_calib.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/ar9002_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
@@ -681,10 +681,6 @@ static bool ar9002_hw_calibrate(struct a
 
 	/* Do NF cal only at longer intervals */
 	if (longcal || nfcal_pending) {
-		/* Do periodic PAOffset Cal */
-		ar9002_hw_pa_cal(ah, false);
-		ar9002_hw_olc_temp_compensation(ah);
-
 		/*
 		 * Get the value from the previous NF cal and update
 		 * history buffer.
@@ -699,8 +695,12 @@ static bool ar9002_hw_calibrate(struct a
 			ath9k_hw_loadnf(ah, ah->curchan);
 		}
 
-		if (longcal)
+		if (longcal) {
 			ath9k_hw_start_nfcal(ah, false);
+			/* Do periodic PAOffset Cal */
+			ar9002_hw_pa_cal(ah, false);
+			ar9002_hw_olc_temp_compensation(ah);
+		}
 	}
 
 	return iscaldone;


