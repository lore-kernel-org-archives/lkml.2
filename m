Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881Ab2ILO7A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 10:59:00 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:55989 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab2ILO64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 10:58:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v9 13/13] ARM: consolidate pen_release instead of having per platform definitions
Date: Wed, 12 Sep 2012 16:58:26 +0200
Message-Id: <1347461906-13527-14-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1347461906-13527-1-git-send-email-arnd@arndb.de>
References: <1347461906-13527-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:pdnPuA29HiHZRCMjHwvyuMuAmsUVLlkCgBlfVAc2cVI
 NRP1cDJJVFgq7d/mxcupLYlZXu57z9FS8h4Jx0pzOVN7/1UyLa
 aRQwQNG7X9UQu8+bf6YbUo2JwlhtTTJNRk3lctI9GKF5UnxO9m
 v1xke4stRr75mL9ZR75QUchifeMUctwNQ70YKafY7OtH6qkakN
 p976XD3ibgQoinx2iDHAsLCwLuYXkmXjy4Xvg9iG8Rjai+CQnh
 fIJBy+2Y5W54sSxHRzi0yfpYWdDOEuPTNiSICL0K7kfQdXFej5
 PcaprYSYvV83ec8l8GVFxuC7DhyFzDBzLsI1j5oGTw+A5GUpPd
 f0WgHAyUn5fP8SUU1bspKT0S9K/6NMt95n4/G8nr+f9monevWZ
 HdyPNmF5Y7NsRShpEJehYd/Z4K6M0SsBeM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marc Zyngier <marc.zyngier@arm.com>

Almost each SMP platform defines pen_release to manage booting secondary
CPUs. This of course clashes with the single zImage effort.

Add the pen_release definition to the ARM SMP code, and remove all others.
This should only be used by platforms which lack any kind of CPU power
management...

Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/include/asm/smp.h        |    1 +
 arch/arm/kernel/smp.c             |    6 ++++++
 arch/arm/mach-exynos/hotplug.c    |    2 --
 arch/arm/mach-exynos/platsmp.c    |    7 -------
 arch/arm/mach-msm/hotplug.c       |    2 --
 arch/arm/mach-msm/platsmp.c       |    5 -----
 arch/arm/mach-realview/hotplug.c  |    2 --
 arch/arm/mach-spear13xx/hotplug.c |    2 --
 arch/arm/mach-spear13xx/platsmp.c |    5 -----
 arch/arm/mach-ux500/hotplug.c     |    2 --
 arch/arm/mach-ux500/platsmp.c     |    6 ------
 arch/arm/mach-vexpress/hotplug.c  |    2 --
 arch/arm/plat-versatile/platsmp.c |    6 ------
 13 files changed, 7 insertions(+), 41 deletions(-)

diff --git a/arch/arm/include/asm/smp.h b/arch/arm/include/asm/smp.h
index 3a8cfee..2e3be16 100644
--- a/arch/arm/include/asm/smp.h
+++ b/arch/arm/include/asm/smp.h
@@ -70,6 +70,7 @@ struct secondary_data {
 	void *stack;
 };
 extern struct secondary_data secondary_data;
+extern volatile int pen_release;
 
 extern int __cpu_disable(void);
 
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index ac3ce02..aa4ffe6 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -51,6 +51,12 @@
  */
 struct secondary_data secondary_data;
 
+/*
+ * control for which core is the next to come out of the secondary
+ * boot "holding pen"
+ */
+volatile int __cpuinitdata pen_release = -1;
+
 enum ipi_msg_type {
 	IPI_TIMER = 2,
 	IPI_RESCHEDULE,
diff --git a/arch/arm/mach-exynos/hotplug.c b/arch/arm/mach-exynos/hotplug.c
index d0a5a70..f1461ce 100644
--- a/arch/arm/mach-exynos/hotplug.c
+++ b/arch/arm/mach-exynos/hotplug.c
@@ -23,8 +23,6 @@
 
 #include "common.h"
 
-extern volatile int pen_release;
-
 static inline void cpu_enter_lowpower(void)
 {
 	unsigned int v;
diff --git a/arch/arm/mach-exynos/platsmp.c b/arch/arm/mach-exynos/platsmp.c
index 3fad8ad..8d57e42 100644
--- a/arch/arm/mach-exynos/platsmp.c
+++ b/arch/arm/mach-exynos/platsmp.c
@@ -40,13 +40,6 @@ extern void exynos4_secondary_startup(void);
 				S5P_INFORM5 : S5P_VA_SYSRAM)
 
 /*
- * control for which core is the next to come out of the secondary
- * boot "holding pen"
- */
-
-volatile int __cpuinitdata pen_release = -1;
-
-/*
  * Write pen_release in a way that is guaranteed to be visible to all
  * observers, irrespective of whether they're taking part in coherency
  * or not.  This is necessary for the hotplug code to work reliably.
diff --git a/arch/arm/mach-msm/hotplug.c b/arch/arm/mach-msm/hotplug.c
index d0f79e8..927a8d2 100644
--- a/arch/arm/mach-msm/hotplug.c
+++ b/arch/arm/mach-msm/hotplug.c
@@ -15,8 +15,6 @@
 
 #include "core.h"
 
-extern volatile int pen_release;
-
 static inline void cpu_enter_lowpower(void)
 {
 	/* Just flush the cache. Changing the coherency is not yet
diff --git a/arch/arm/mach-msm/platsmp.c b/arch/arm/mach-msm/platsmp.c
index ba3c4b0..57af32e 100644
--- a/arch/arm/mach-msm/platsmp.c
+++ b/arch/arm/mach-msm/platsmp.c
@@ -35,11 +35,6 @@
 #define GIC_PPI_EDGE_MASK 0xFFFFD7FF
 
 extern void msm_secondary_startup(void);
-/*
- * control for which core is the next to come out of the secondary
- * boot "holding pen".
- */
-volatile int pen_release = -1;
 
 static DEFINE_SPINLOCK(boot_lock);
 
diff --git a/arch/arm/mach-realview/hotplug.c b/arch/arm/mach-realview/hotplug.c
index 81a2a58..a5a02c2 100644
--- a/arch/arm/mach-realview/hotplug.c
+++ b/arch/arm/mach-realview/hotplug.c
@@ -16,8 +16,6 @@
 #include <asm/cp15.h>
 #include <asm/smp_plat.h>
 
-extern volatile int pen_release;
-
 static inline void cpu_enter_lowpower(void)
 {
 	unsigned int v;
diff --git a/arch/arm/mach-spear13xx/hotplug.c b/arch/arm/mach-spear13xx/hotplug.c
index 22e99b0..9b17e1e 100644
--- a/arch/arm/mach-spear13xx/hotplug.c
+++ b/arch/arm/mach-spear13xx/hotplug.c
@@ -17,8 +17,6 @@
 #include <asm/cp15.h>
 #include <asm/smp_plat.h>
 
-extern volatile int pen_release;
-
 static inline void cpu_enter_lowpower(void)
 {
 	unsigned int v;
diff --git a/arch/arm/mach-spear13xx/platsmp.c b/arch/arm/mach-spear13xx/platsmp.c
index 806343c..2eaa3fa 100644
--- a/arch/arm/mach-spear13xx/platsmp.c
+++ b/arch/arm/mach-spear13xx/platsmp.c
@@ -21,11 +21,6 @@
 #include <mach/spear.h>
 #include <mach/generic.h>
 
-/*
- * control for which core is the next to come out of the secondary
- * boot "holding pen"
- */
-volatile int __cpuinitdata pen_release = -1;
 static DEFINE_SPINLOCK(boot_lock);
 
 static void __iomem *scu_base = IOMEM(VA_SCU_BASE);
diff --git a/arch/arm/mach-ux500/hotplug.c b/arch/arm/mach-ux500/hotplug.c
index 17b9a15..4f6b2e1 100644
--- a/arch/arm/mach-ux500/hotplug.c
+++ b/arch/arm/mach-ux500/hotplug.c
@@ -17,8 +17,6 @@
 
 #include <mach/setup.h>
 
-extern volatile int pen_release;
-
 /*
  * platform-specific code to shutdown a CPU
  *
diff --git a/arch/arm/mach-ux500/platsmp.c b/arch/arm/mach-ux500/platsmp.c
index b6f4e0e..d60873e 100644
--- a/arch/arm/mach-ux500/platsmp.c
+++ b/arch/arm/mach-ux500/platsmp.c
@@ -28,12 +28,6 @@
 extern void u8500_secondary_startup(void);
 
 /*
- * control for which core is the next to come out of the secondary
- * boot "holding pen"
- */
-volatile int pen_release = -1;
-
-/*
  * Write pen_release in a way that is guaranteed to be visible to all
  * observers, irrespective of whether they're taking part in coherency
  * or not.  This is necessary for the hotplug code to work reliably.
diff --git a/arch/arm/mach-vexpress/hotplug.c b/arch/arm/mach-vexpress/hotplug.c
index e2a960f..b36a749 100644
--- a/arch/arm/mach-vexpress/hotplug.c
+++ b/arch/arm/mach-vexpress/hotplug.c
@@ -16,8 +16,6 @@
 #include <asm/smp_plat.h>
 #include <asm/cp15.h>
 
-extern volatile int pen_release;
-
 static inline void cpu_enter_lowpower(void)
 {
 	unsigned int v;
diff --git a/arch/arm/plat-versatile/platsmp.c b/arch/arm/plat-versatile/platsmp.c
index 39e60ac..04ca493 100644
--- a/arch/arm/plat-versatile/platsmp.c
+++ b/arch/arm/plat-versatile/platsmp.c
@@ -20,12 +20,6 @@
 #include <asm/hardware/gic.h>
 
 /*
- * control for which core is the next to come out of the secondary
- * boot "holding pen"
- */
-volatile int __cpuinitdata pen_release = -1;
-
-/*
  * Write pen_release in a way that is guaranteed to be visible to all
  * observers, irrespective of whether they're taking part in coherency
  * or not.  This is necessary for the hotplug code to work reliably.
-- 
1.7.10

