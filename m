Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002Ab1CUXNt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:13:49 -0400
Received: from kroah.org ([198.145.64.141]:49000 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754893Ab1CUXNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:13:44 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:10:52 2011
Message-Id: <20110321231052.388064347@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:09:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Senthil Balasubramanian <senthilkumar@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [16/44] ath9k_hw: Fix incorrect macversion and macrev checks
In-Reply-To: <20110321231105.GA1744@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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

---
 drivers/net/wireless/ath/ath9k/hw.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -917,6 +917,8 @@ int ath9k_hw_init(struct ath_hw *ah)
 	ath9k_hw_init_defaults(ah);
 	ath9k_hw_init_config(ah);
 
+	ath9k_hw_read_revisions(ah);
+
 	if (!ath9k_hw_set_reset_reg(ah, ATH9K_RESET_POWER_ON)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_FATAL, "Couldn't reset chip\n");
 		return -EIO;
@@ -1758,8 +1760,6 @@ static bool ath9k_hw_set_reset_power_on(
 		return false;
 	}
 
-	ath9k_hw_read_revisions(ah);
-
 	return ath9k_hw_set_reset(ah, ATH9K_RESET_WARM);
 }
 


