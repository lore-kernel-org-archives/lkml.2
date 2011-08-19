Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845Ab1HSLxB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 07:53:01 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:59023 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751685Ab1HSLwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 07:52:45 -0400
From: Abhilash K V <abhilash.kv@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>,
        Abhilash K V <abhilash.kv@ti.com>, Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH 2/2] AM3517: Support for MMC1
Date: Fri, 19 Aug 2011 17:22:31 +0530
Message-ID: <1313754751-11752-3-git-send-email-abhilash.kv@ti.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1313754751-11752-2-git-send-email-abhilash.kv@ti.com>
References: <1313754751-11752-1-git-send-email-abhilash.kv@ti.com>
 <1313754751-11752-2-git-send-email-abhilash.kv@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following error message which appears
while intializing MMC1 on the AM3517 EVM base-board:
    mmc0: host doesn't support card's voltages
    mmc0: error -22 whilst initialising SD card
The ocr_mask, which enumerates the volatges supported by the
MMC card was not being indicated before, assuming that a separate
Vcc regulator maybe another controllable regulator driver would be
doing this. This patch statically specifies a subset of the voltages
supported by the MMC driver, which are provided by the current fixed
voltage regulator on AM3517 EVM.

Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
Signed-off-by: Abhilash K V <abhilash.kv@ti.com>
---
 arch/arm/mach-omap2/hsmmc.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/hsmmc.c b/arch/arm/mach-omap2/hsmmc.c
index a9b45c7..9dee2e1 100644
--- a/arch/arm/mach-omap2/hsmmc.c
+++ b/arch/arm/mach-omap2/hsmmc.c
@@ -350,7 +350,15 @@ static int __init omap_hsmmc_pdata_init(struct omap2_hsmmc_info *c,
 	 *
 	 * temporary HACK: ocr_mask instead of fixed supply
 	 */
-	mmc->slots[0].ocr_mask = c->ocr_mask;
+	if (cpu_is_omap3505() || cpu_is_omap3517())
+		mmc->slots[0].ocr_mask = MMC_VDD_165_195 |
+					 MMC_VDD_26_27 |
+					 MMC_VDD_27_28 |
+					 MMC_VDD_29_30 |
+					 MMC_VDD_30_31 |
+					 MMC_VDD_31_32;
+	else
+		mmc->slots[0].ocr_mask = c->ocr_mask;
 
 	if (cpu_is_omap3517() || cpu_is_omap3505())
 		mmc->slots[0].set_power = nop_mmc_set_power;
-- 
1.7.1

