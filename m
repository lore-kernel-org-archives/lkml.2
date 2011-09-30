Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758810Ab1I3X1N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 19:27:13 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:53226 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754102Ab1I3X1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 19:27:08 -0400
From: Kevin Hilman <khilman@ti.com>
To: Abhilash K V <abhilash.kv@ti.com>
Cc: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>, <b-cousson@ti.com>, <paul@pwsan.com>,
        <aneesh@ti.com>, <santosh.shilimkar@ti.com>,
        <christian.gmeiner@gmail.com>, Vaibhav Hiremath <hvaibhav@ti.com>
Subject: Re: [PATCH v5 2/3] omap_twl: Prevent SR to enable for am3517/am3505 devices
Organization: Texas Instruments, Inc.
References: <1317363153-10259-1-git-send-email-abhilash.kv@ti.com>
	<1317363153-10259-2-git-send-email-abhilash.kv@ti.com>
	<1317363153-10259-3-git-send-email-abhilash.kv@ti.com>
	<87r52xhhkb.fsf@ti.com>
Date: Fri, 30 Sep 2011 16:27:03 -0700
In-Reply-To: <87r52xhhkb.fsf@ti.com> (Kevin Hilman's message of "Fri, 30 Sep
	2011 14:00:04 -0700")
Message-ID: <874nztfw6w.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Abhilash,

Kevin Hilman <khilman@ti.com> writes:

> Abhilash K V <abhilash.kv@ti.com> writes:
>
>> From: Abhilash K V <abhilash.kv@ti.com>
>>
>> In case of AM3517 & AM3505, SmartReflex is not applicable so
>> we must not enable it. So omap3_twl_init() is now not called
>> when the processor does not support SR.
>
> This still isn't right.
>
> The reason to skip the TWL PMIC init is not because SR is not available
> (TWL PMICs are quite usable without SR).  The reason to skip TWL PMIC
> init is because the PMIC is not present.
>
> Instead, we need to fix up the TWL/PMIC init so that TWL-specifics are
> only registered if a TWL driver is registered.
>

Below is a test patch that is a first pass at implementing what I
suggested above.  I tested this (along with your patch 3/3) on a
3430/n900 after removing the omap_pmic_init() call frome the board file.

Can you let me know if this solves the problem you're seeing on
platforms that don't have TWL PMICs?

After digging into this more, I'm increasingly aware that the way we're
managing the init of PMIC stuff is a mess.  Guess I need another round
of voltage layer cleanups to fix that up.  


Kevin

>From 1cd49077829a262155b96f8fdcdcdd6c54d83ed5 Mon Sep 17 00:00:00 2001
From: Kevin Hilman <khilman@ti.com>
Date: Fri, 30 Sep 2011 11:24:04 -0700
Subject: [PATCH] ARM: OMAP2+: PM: only register TWL with voltage layer when
 device is present

Current code registers voltage layer details for TWL PMIC even when a TWL
has not been registered.  Fix this to only register the TWL with voltage
layer when the TWL PMIC is initialized by board-level code.

Signed-off-by: Kevin Hilman <khilman@ti.com>
---
 arch/arm/mach-omap2/pm.c         |    6 ++----
 arch/arm/mach-omap2/twl-common.c |   11 +++++++++++
 arch/arm/mach-omap2/twl-common.h |    3 +++
 3 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-omap2/pm.c b/arch/arm/mach-omap2/pm.c
index d34fc52..602fc66 100644
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
diff --git a/arch/arm/mach-omap2/twl-common.c b/arch/arm/mach-omap2/twl-common.c
index daa056e..47133fa 100644
--- a/arch/arm/mach-omap2/twl-common.c
+++ b/arch/arm/mach-omap2/twl-common.c
@@ -30,6 +30,7 @@
 #include <plat/usb.h>
 
 #include "twl-common.h"
+#include "pm.h"
 
 static struct i2c_board_info __initdata pmic_i2c_board_info = {
 	.addr		= 0x48,
@@ -48,6 +49,16 @@ void __init omap_pmic_init(int bus, u32 clkrate,
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
diff --git a/arch/arm/mach-omap2/twl-common.h b/arch/arm/mach-omap2/twl-common.h
index 5e83a5b..275dde8 100644
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
-- 
1.7.6

