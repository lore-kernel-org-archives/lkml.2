Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932522Ab2HPNR7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 09:17:59 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:58468 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932123Ab2HPNQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 09:16:21 -0400
From: Roland Stigge <stigge@antcom.de>
To: linux@arm.linux.org.uk, artem.bityutskiy@linux.intel.com,
        linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, aletes.xgr@gmail.com, dwmw2@infradead.org,
        linux-mtd@lists.infradead.org
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH] ARM: LPC32xx: Provide DMA filter callbacks via platform data
Date: Thu, 16 Aug 2012 15:15:33 +0200
Message-Id: <1345122935-22115-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SLC and MLC NAND drivers now need their dma_filter callbacks via platform
data to make them independent of single DMA engine drivers.

(This also helps fixing build errors of the SLC and MLC drivers when building
as modules because direct access to AMBA dma filter functions isn't available
via export.)

Signed-off-by: Roland Stigge <stigge@antcom.de>

---

Applies to v3.6-rc1

 arch/arm/mach-lpc32xx/phy3250.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- linux-2.6.orig/arch/arm/mach-lpc32xx/phy3250.c
+++ linux-2.6/arch/arm/mach-lpc32xx/phy3250.c
@@ -37,6 +37,8 @@
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
 #include <linux/clk.h>
+#include <linux/mtd/lpc32xx_slc.h>
+#include <linux/mtd/lpc32xx_mlc.h>
 
 #include <asm/setup.h>
 #include <asm/mach-types.h>
@@ -223,6 +225,14 @@ static struct mmci_platform_data lpc32xx
 	 * gather, and the MMCI driver doesn't do it this way */
 };
 
+static struct lpc32xx_slc_platform_data lpc32xx_slc_data = {
+	.dma_filter = pl08x_filter_id,
+};
+
+static struct lpc32xx_mlc_platform_data lpc32xx_mlc_data = {
+	.dma_filter = pl08x_filter_id,
+};
+
 static const struct of_dev_auxdata lpc32xx_auxdata_lookup[] __initconst = {
 	OF_DEV_AUXDATA("arm,pl022", 0x20084000, "dev:ssp0", &lpc32xx_ssp0_data),
 	OF_DEV_AUXDATA("arm,pl022", 0x2008C000, "dev:ssp1", &lpc32xx_ssp1_data),
@@ -230,6 +240,10 @@ static const struct of_dev_auxdata lpc32
 	OF_DEV_AUXDATA("arm,pl080", 0x31000000, "pl08xdmac", &pl08x_pd),
 	OF_DEV_AUXDATA("arm,pl18x", 0x20098000, "20098000.sd",
 		       &lpc32xx_mmci_data),
+	OF_DEV_AUXDATA("nxp,lpc3220-slc", 0x20020000, "20020000.flash",
+		       &lpc32xx_slc_data),
+	OF_DEV_AUXDATA("nxp,lpc3220-mlc", 0x200a8000, "200a8000.flash",
+		       &lpc32xx_mlc_data),
 	{ }
 };
 
