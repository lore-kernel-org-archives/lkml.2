Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932391Ab1LGQVA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:21:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33721 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757764Ab1LGQU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:20:57 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:12:16 2011
Message-Id: <20111207161216.408196532@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:11:22 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Kevin Hilman <khilman@ti.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [020/104] ARM: OMAP: PM: only register TWL with voltage layer when device is present
In-Reply-To: <20111207161246.GA10995@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kevin Hilman <khilman@ti.com>

commit 46232a3622c6e33605906ee6690dfef372925f53 upstream.

Current code registers voltage layer details for TWL PMIC even when a TWL
has not been registered.  Fix this to only register the TWL with voltage
layer when the TWL PMIC is initialized by board-level code.

Signed-off-by: Kevin Hilman <khilman@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/mach-omap2/pm.c         |    6 ++----
 arch/arm/mach-omap2/twl-common.c |   11 +++++++++++
 arch/arm/mach-omap2/twl-common.h |    3 +++
 3 files changed, 16 insertions(+), 4 deletions(-)

--- a/arch/arm/mach-omap2/pm.c
+++ b/arch/arm/mach-omap2/pm.c
@@ -23,6 +23,7 @@
 #include "powerdomain.h"
 #include "clockdomain.h"
 #include "pm.h"
+#include "twl-common.h"
 
 static struct omap_device_pm_latency *pm_lats;
 
@@ -251,11 +252,8 @@ postcore_initcall(omap2_common_pm_init);
 
 static int __init omap2_common_pm_late_init(void)
 {
-	/* Init the OMAP TWL parameters */
-	omap3_twl_init();
-	omap4_twl_init();
-
 	/* Init the voltage layer */
+	omap_pmic_late_init();
 	omap_voltage_late_init();
 
 	/* Initialize the voltages */
--- a/arch/arm/mach-omap2/twl-common.c
+++ b/arch/arm/mach-omap2/twl-common.c
@@ -30,6 +30,7 @@
 #include <plat/usb.h>
 
 #include "twl-common.h"
+#include "pm.h"
 
 static struct i2c_board_info __initdata pmic_i2c_board_info = {
 	.addr		= 0x48,
@@ -48,6 +49,16 @@ void __init omap_pmic_init(int bus, u32
 	omap_register_i2c_bus(bus, clkrate, &pmic_i2c_board_info, 1);
 }
 
+void __init omap_pmic_late_init(void)
+{
+	/* Init the OMAP TWL parameters (if PMIC has been registerd) */
+	if (!pmic_i2c_board_info.irq)
+		return;
+
+	omap3_twl_init();
+	omap4_twl_init();
+}
+
 #if defined(CONFIG_ARCH_OMAP3)
 static struct twl4030_usb_data omap3_usb_pdata = {
 	.usb_mode	= T2_USB_MODE_ULPI,
--- a/arch/arm/mach-omap2/twl-common.h
+++ b/arch/arm/mach-omap2/twl-common.h
@@ -1,6 +1,8 @@
 #ifndef __OMAP_PMIC_COMMON__
 #define __OMAP_PMIC_COMMON__
 
+#include <plat/irqs.h>
+
 #define TWL_COMMON_PDATA_USB		(1 << 0)
 #define TWL_COMMON_PDATA_BCI		(1 << 1)
 #define TWL_COMMON_PDATA_MADC		(1 << 2)
@@ -30,6 +32,7 @@ struct twl4030_platform_data;
 
 void omap_pmic_init(int bus, u32 clkrate, const char *pmic_type, int pmic_irq,
 		    struct twl4030_platform_data *pmic_data);
+void omap_pmic_late_init(void);
 
 static inline void omap2_pmic_init(const char *pmic_type,
 				   struct twl4030_platform_data *pmic_data)


