Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965096Ab1C3V0n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:26:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:51977 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965069Ab1C3VJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:09:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="903736065"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: senthilkumar@atheros.com, linville@tuxdriver.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [198/275] ath9k_hw: Fix incorrect macversion and macrev checks
Message-Id: <20110330210722.31BA23E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:07:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Senthil Balasubramanian <senthilkumar@atheros.com>

commit ac45c12dfb3f727a5a7a3332ed9c11b4a5ab287e upstream.

There are few places where we are checking for macversion and revsions
before RTC is powered ON. However we are reading the macversion and
revisions only after RTC is powered ON and so both macversion and
revisions are actully zero and this leads to incorrect srev checks

Incorrect srev checks can cause registers to be configured wrongly and can
cause unexpected behavior. Fixing this seems to address the ASPM issue that
we have observed. The laptop becomes very slow and hangs mostly with ASPM L1
enabled without this fix.

fix this by reading the macversion and revisisons even before we start
using them. There is no reason why should we delay reading this info
until RTC is powered on as this is just a register information.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/net/wireless/ath/ath9k/hw.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/drivers/net/wireless/ath/ath9k/hw.c
===================================================================
--- linux-2.6.35.y.orig/drivers/net/wireless/ath/ath9k/hw.c	2011-03-29 22:50:41.231203416 -0700
+++ linux-2.6.35.y/drivers/net/wireless/ath/ath9k/hw.c	2011-03-29 23:03:02.404238651 -0700
@@ -519,6 +519,8 @@
 	if (ah->hw_version.devid == AR5416_AR9100_DEVID)
 		ah->hw_version.macVersion = AR_SREV_VERSION_9100;
 
+	ath9k_hw_read_revisions(ah);
+
 	if (!ath9k_hw_set_reset_reg(ah, ATH9K_RESET_POWER_ON)) {
 		ath_print(common, ATH_DBG_FATAL,
 			  "Couldn't reset chip\n");
@@ -1096,8 +1098,6 @@
 		return false;
 	}
 
-	ath9k_hw_read_revisions(ah);
-
 	return ath9k_hw_set_reset(ah, ATH9K_RESET_WARM);
 }
 
