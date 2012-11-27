Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843Ab2K0Ty3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 14:54:29 -0500
Received: from mail-gg0-f202.google.com ([209.85.161.202]:63288 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755430Ab2K0Ty1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 14:54:27 -0500
From: Doug Anderson <dianders@chromium.org>
To: Olof Johansson <olof@lixom.net>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Doug Anderson <dianders@chromium.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: EXYNOS: Avoid early use of of_machine_is_compatible()
Date: Tue, 27 Nov 2012 11:53:14 -0800
Message-Id: <1354045994-8977-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recent commit "ARM: EXYNOS: add support for EXYNOS5440 SoC" broke
support for exynos5250 because of_machine_is_compatible() was used too
early in the boot process.  It also probably meant that the exynos5440
failed to use the proper iotable.  Switch to use
of_flat_dt_is_compatible() in both of these cases.

The failure I was seeing in exynos5250 because of this was:
  Division by zero in kernel.
  [<80015ed4>] (unwind_backtrace+0x0/0xec) from [<8045c7a4>] (dump_stack+0x20/0x24)
  [<8045c7a4>] (dump_stack+0x20/0x24) from [<80012990>] (__div0+0x20/0x28)
  [<80012990>] (__div0+0x20/0x28) from [<8021ab04>] (Ldiv0_64+0x8/0x18)
  [<8021ab04>] (Ldiv0_64+0x8/0x18) from [<80068560>] (__clocksource_updatefreq_scale+0x54/0x134)
  [<80068560>] (__clocksource_updatefreq_scale+0x54/0x134) from [<8006865c>] (__clocksource_register_scale+0x1c/0x54)
  [<8006865c>] (__clocksource_register_scale+0x1c/0x54) from [<80612a18>] (exynos_timer_init+0x100/0x1e8)
  [<80612a18>] (exynos_timer_init+0x100/0x1e8) from [<8060d184>] (time_init+0x28/0x38)
  [<8060d184>] (time_init+0x28/0x38) from [<8060a754>] (start_kernel+0x1e0/0x3c8)
  [<8060a754>] (start_kernel+0x1e0/0x3c8) from [<40008078>] (0x40008078)

Signed-off-by: Doug Anderson <dianders@chromium.org>

---
 arch/arm/mach-exynos/common.c          |    5 ++++-
 arch/arm/mach-exynos/mach-exynos5-dt.c |    4 +++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-exynos/common.c b/arch/arm/mach-exynos/common.c
index 73b940f..b919f5f 100644
--- a/arch/arm/mach-exynos/common.c
+++ b/arch/arm/mach-exynos/common.c
@@ -18,6 +18,7 @@
 #include <linux/sched.h>
 #include <linux/serial_core.h>
 #include <linux/of.h>
+#include <linux/of_fdt.h>
 #include <linux/of_irq.h>
 #include <linux/export.h>
 #include <linux/irqdomain.h>
@@ -335,8 +336,10 @@ void __init exynos_init_late(void)
 
 void __init exynos_init_io(struct map_desc *mach_desc, int size)
 {
+	unsigned long root = of_get_flat_dt_root();
+
 	/* initialize the io descriptors we need for initialization */
-	if (of_machine_is_compatible("samsung,exynos5440"))
+	if (of_flat_dt_is_compatible(root, "samsung,exynos5440"))
 		iotable_init(exynos5440_iodesc, ARRAY_SIZE(exynos5440_iodesc));
 	else
 		iotable_init(exynos_iodesc, ARRAY_SIZE(exynos_iodesc));
diff --git a/arch/arm/mach-exynos/mach-exynos5-dt.c b/arch/arm/mach-exynos/mach-exynos5-dt.c
index 67fa3c2..7b76c3f 100644
--- a/arch/arm/mach-exynos/mach-exynos5-dt.c
+++ b/arch/arm/mach-exynos/mach-exynos5-dt.c
@@ -122,9 +122,11 @@ static const struct of_dev_auxdata exynos5440_auxdata_lookup[] __initconst = {
 
 static void __init exynos5_dt_map_io(void)
 {
+	unsigned long root = of_get_flat_dt_root();
+
 	exynos_init_io(NULL, 0);
 
-	if (of_machine_is_compatible("samsung,exynos5250"))
+	if (of_flat_dt_is_compatible(root, "samsung,exynos5250"))
 		s3c24xx_init_clocks(24000000);
 }
 
-- 
1.7.7.3

