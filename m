Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191Ab1K1WB7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 17:01:59 -0500
Received: from d1.icnet.pl ([212.160.220.21]:35480 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053Ab1K1WB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 17:01:58 -0500
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Tony Lindgren <tony@atomide.com>
Cc: Paul Walmsley <paul@pwsan.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Subject: [PATCH 2a/5] Remove unsafe clock values from omap1_defconfig
Date: Mon, 28 Nov 2011 23:00:44 +0100
Message-Id: <1322517644-5066-1-git-send-email-jkrzyszt@tis.icnet.pl>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <20111128174508.GO31337@atomide.com>
References: <20111128174508.GO31337@atomide.com>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DPLL1 reprogramming to a different rate is actually blocked inside
omap1_select_table_rate(), resulting in the defalut rate of 60 MHz
always used instead of the one selected in .config. OTOH, in
omap1_defconfig we currently rely on Kconfig options for the supported
MHz rates in case of boards which boot with dpll1 not set correctly by
their boot loaders.

This means that before we allow for reprogramming of dpll1 rate, we
should remove all unsafe clock selections from omap1_defconfig,
otherwise it will stop booting on boards with imperfect boot loaders,
as it would always try to change to 216MHz.

Keep only one safe clock rate per each supported xtal frequency, i.e.
60MHZ dpll1 for 12MHz xtal and 182MHz dpll1 for 13MHz xtal.

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
---
On Monday 28 of November 2011 at 18:45:09, Tony Lindgren wrote:
> * Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> [111126 19:06]:
> > According to comments in omap1_select_table_rate(), reprogramming dpll1
> > is tricky, and should always be done from SRAM.
> > 
> > While being at it, move OMAP730 special case handling inside
> > omap_sram_reprogram_clock().
> > 
> > Created on top of omap-fixes, not yet in mainline as of 3.2-rc3.
> > Tested on Amstrad Delta.
> 
> Thanks for looking into these issues. For most of this we should plan on
> getting them done for the next merge window because we currently rely
> on Kconfig options for the supported MHz rates. This means that with
> this change omap1_defconfig will stop booting on most systems as it
> would try to change to 216MHz. To fix that issue we should allow the
> boards to set the supported rates before applying this patch.

Hi Tony,
I'm not sure which of the patches you meant not ready for 3.2-rc. From
your comment I would conclude that only patch 3/5, which would really
break omap1_defconfig booting on some boards, is questionable, while you
posted this comment against patch 1/5, which I don't see how it could
break booting, including omap1_defconfig.

Anyway, I hope that the additional patch below is addressing all your
concerns.

Thanks,
Janusz

P.S. A replacement for patches 4 and 5, addressing Russell's comment,
in progress.


 arch/arm/configs/omap1_defconfig |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/arch/arm/configs/omap1_defconfig b/arch/arm/configs/omap1_defconfig
index a7e7775..945a34f 100644
--- a/arch/arm/configs/omap1_defconfig
+++ b/arch/arm/configs/omap1_defconfig
@@ -48,12 +48,7 @@ CONFIG_MACH_SX1=y
 CONFIG_MACH_NOKIA770=y
 CONFIG_MACH_AMS_DELTA=y
 CONFIG_MACH_OMAP_GENERIC=y
-CONFIG_OMAP_ARM_216MHZ=y
-CONFIG_OMAP_ARM_195MHZ=y
-CONFIG_OMAP_ARM_192MHZ=y
 CONFIG_OMAP_ARM_182MHZ=y
-CONFIG_OMAP_ARM_168MHZ=y
-# CONFIG_OMAP_ARM_60MHZ is not set
 # CONFIG_ARM_THUMB is not set
 CONFIG_PCCARD=y
 CONFIG_OMAP_CF=y
-- 
1.7.3.4

