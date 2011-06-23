Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933674Ab1FWRh6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:37:58 -0400
Received: from mail.windriver.com ([147.11.1.11]:35209 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933653Ab1FWRhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:37:50 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org,
        Senthil Balasubramanian <senthilkumar@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 180/247] ath9k_hw: Fix incorrect macversion and macrev checks
Date: Thu, 23 Jun 2011 13:34:08 -0400
Message-Id: <1308850515-15242-121-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Senthil Balasubramanian <senthilkumar@atheros.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 1774a59..28d3d51 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -850,6 +850,8 @@ int ath9k_hw_init(struct ath_hw *ah)
 	ath9k_hw_init_defaults(ah);
 	ath9k_hw_init_config(ah);
 
+	ath9k_hw_read_revisions(ah);
+
 	if (!ath9k_hw_set_reset_reg(ah, ATH9K_RESET_POWER_ON)) {
 		ath_print(common, ATH_DBG_FATAL,
 			  "Couldn't reset chip\n");
@@ -1770,8 +1772,6 @@ static bool ath9k_hw_set_reset_power_on(struct ath_hw *ah)
 		return false;
 	}
 
-	ath9k_hw_read_revisions(ah);
-
 	return ath9k_hw_set_reset(ah, ATH9K_RESET_WARM);
 }
 
-- 
1.7.4.4

