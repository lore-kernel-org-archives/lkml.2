Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588Ab1FPHj4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:39:56 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:46244 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755029Ab1FPHA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:00:28 -0400
X-Sasl-enc: X0qRFaAY3/u6MRcHdsKIFWmvWFCDu2dS2/U4yQvySpqg 1308207627
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:02:30 2011
Message-Id: <20110616000230.872700990@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 16:59:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Daniel Halperin <dhalperi@cs.washington.edu>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [19/89] ath9k: fix two more bugs in tx power
In-Reply-To: <20110616000258.GA14529@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Daniel Halperin <dhalperi@cs.washington.edu>

commit 21fdc87248d1d28492c775e05fa92b3c8c7bc8db upstream.

This is the same fix as

   commit 841051602e3fa18ea468fe5a177aa92b6eb44b56
   Author: Matteo Croce <technoboy85@gmail.com>
   Date:   Fri Dec 3 02:25:08 2010 +0100

   The ath9k driver subtracts 3 dBm to the txpower as with two radios the
   signal power is doubled.
   The resulting value is assigned in an u16 which overflows and makes
   the card work at full power.

in two more places. I grepped the ath tree and didn't find any others.

Signed-off-by: Daniel Halperin <dhalperi@cs.washington.edu>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   10 ++++++++--
 drivers/net/wireless/ath/ath9k/eeprom_9287.c   |   10 ++++++++--
 2 files changed, 16 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -4598,10 +4598,16 @@ static void ar9003_hw_set_power_per_rate
 	case 1:
 		break;
 	case 2:
-		scaledPower -= REDUCE_SCALED_POWER_BY_TWO_CHAIN;
+		if (scaledPower > REDUCE_SCALED_POWER_BY_TWO_CHAIN)
+			scaledPower -= REDUCE_SCALED_POWER_BY_TWO_CHAIN;
+		else
+			scaledPower = 0;
 		break;
 	case 3:
-		scaledPower -= REDUCE_SCALED_POWER_BY_THREE_CHAIN;
+		if (scaledPower > REDUCE_SCALED_POWER_BY_THREE_CHAIN)
+			scaledPower -= REDUCE_SCALED_POWER_BY_THREE_CHAIN;
+		else
+			scaledPower = 0;
 		break;
 	}
 
--- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
@@ -522,10 +522,16 @@ static void ath9k_hw_set_ar9287_power_pe
 	case 1:
 		break;
 	case 2:
-		scaledPower -= REDUCE_SCALED_POWER_BY_TWO_CHAIN;
+		if (scaledPower > REDUCE_SCALED_POWER_BY_TWO_CHAIN)
+			scaledPower -= REDUCE_SCALED_POWER_BY_TWO_CHAIN;
+		else
+			scaledPower = 0;
 		break;
 	case 3:
-		scaledPower -= REDUCE_SCALED_POWER_BY_THREE_CHAIN;
+		if (scaledPower > REDUCE_SCALED_POWER_BY_THREE_CHAIN)
+			scaledPower -= REDUCE_SCALED_POWER_BY_THREE_CHAIN;
+		else
+			scaledPower = 0;
 		break;
 	}
 	scaledPower = max((u16)0, scaledPower);


