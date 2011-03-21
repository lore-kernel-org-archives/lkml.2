Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932251Ab1CUXRy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:17:54 -0400
Received: from kroah.org ([198.145.64.141]:52561 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755648Ab1CUXRn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:17:43 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:03:23 2011
Message-Id: <20110321230323.627053023@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:01:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Senthil Balasubramanian <senthilkumar@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [19/78] ath9k_hw: read and backup AR_WA register value even before chip reset on.
In-Reply-To: <20110321230346.GA14681@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Senthil Balasubramanian <senthilkumar@atheros.com>

commit 0a8d7cb0c8182df7a28ad719780071178c386f0f upstream.

We need to read and backup AR_WA register value permanently and reading
this after the chip is awakened results in this register being zeroed out.

This seems to fix the ASPM with L1 enabled issue that we have observed.
The laptop becomes very slow and hangs mostly with ASPM L1 enabled without
this fix.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/hw.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -495,6 +495,15 @@ static int __ath9k_hw_init(struct ath_hw
 	if (ah->hw_version.devid == AR5416_AR9100_DEVID)
 		ah->hw_version.macVersion = AR_SREV_VERSION_9100;
 
+	/*
+	 * Read back AR_WA into a permanent copy and set bits 14 and 17.
+	 * We need to do this to avoid RMW of this register. We cannot
+	 * read the reg when chip is asleep.
+	 */
+	ah->WARegVal = REG_READ(ah, AR_WA);
+	ah->WARegVal |= (AR_WA_D3_L1_DISABLE |
+			 AR_WA_ASPM_TIMER_BASED_DISABLE);
+
 	if (!ath9k_hw_set_reset_reg(ah, ATH9K_RESET_POWER_ON)) {
 		ath_err(common, "Couldn't reset chip\n");
 		return -EIO;
@@ -563,14 +572,6 @@ static int __ath9k_hw_init(struct ath_hw
 
 	ath9k_hw_init_mode_regs(ah);
 
-	/*
-	 * Read back AR_WA into a permanent copy and set bits 14 and 17.
-	 * We need to do this to avoid RMW of this register. We cannot
-	 * read the reg when chip is asleep.
-	 */
-	ah->WARegVal = REG_READ(ah, AR_WA);
-	ah->WARegVal |= (AR_WA_D3_L1_DISABLE |
-			 AR_WA_ASPM_TIMER_BASED_DISABLE);
 
 	if (ah->is_pciexpress)
 		ath9k_hw_configpcipowersave(ah, 0, 0);


