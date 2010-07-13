Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735Ab0GMWan (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 18:30:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:42126 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754970Ab0GMWal (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 18:30:41 -0400
Date: Tue, 13 Jul 2010 22:30:16 GMT
Message-Id: <201007132230.o6DMUGwR018776@hera.kernel.org>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86 fixes for 2.6.35-rc6
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Feng Tang <feng.tang@intel.com>,
        Dmitry Torokhov <dtor@mail.ru>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Tony Luck <tony.luck@intel.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 13 Jul 2010 22:30:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This series consists of a single patchset which addresses the handling
of 8042 when CONFIG_X86_MRST is enabled: what should have been a
runtime check all along was incorrectly implemented as a compile-time
check.

Dmitry Torokhov has acked this series.

	-hpa


The following changes since commit 78178c7d6e127fff6dba027315fd6914304b05cf:
  Linus Torvalds (1):
        Merge branch 'drm-fixes' of git://git.kernel.org/.../airlied/drm-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

Feng Tang (5):
      x86: Add i8042 pre-detection hook to x86_platform_ops
      x86, mrst: Add i8042_detect API for Moorestwon platform
      Revert "Input: do not force selecting i8042 on Moorestown"
      Revert "Input: fixup X86_MRST selects"
      input: i8042 - add runtime check in x86's i8042_platform_init

H. Peter Anvin (1):
      x86, platform: Export x86_platform to modules

 arch/x86/include/asm/x86_init.h       |    2 ++
 arch/x86/kernel/mrst.c                |    7 +++++++
 arch/x86/kernel/x86_init.c            |    7 ++++++-
 drivers/input/keyboard/Kconfig        |    4 ++--
 drivers/input/mouse/Kconfig           |    2 +-
 drivers/input/serio/Kconfig           |    2 +-
 drivers/input/serio/i8042-x86ia64io.h |   10 ++++++++++
 7 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 519b543..baa579c 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -142,6 +142,7 @@ struct x86_cpuinit_ops {
  * @set_wallclock:		set time back to HW clock
  * @is_untracked_pat_range	exclude from PAT logic
  * @nmi_init			enable NMI on cpus
+ * @i8042_detect		pre-detect if i8042 controller exists
  */
 struct x86_platform_ops {
 	unsigned long (*calibrate_tsc)(void);
@@ -150,6 +151,7 @@ struct x86_platform_ops {
 	void (*iommu_shutdown)(void);
 	bool (*is_untracked_pat_range)(u64 start, u64 end);
 	void (*nmi_init)(void);
+	int (*i8042_detect)(void);
 };
 
 extern struct x86_init_ops x86_init;
diff --git a/arch/x86/kernel/mrst.c b/arch/x86/kernel/mrst.c
index e796448..5915e0b 100644
--- a/arch/x86/kernel/mrst.c
+++ b/arch/x86/kernel/mrst.c
@@ -216,6 +216,12 @@ static void __init mrst_setup_boot_clock(void)
 		setup_boot_APIC_clock();
 };
 
+/* MID systems don't have i8042 controller */
+static int mrst_i8042_detect(void)
+{
+	return 0;
+}
+
 /*
  * Moorestown specific x86_init function overrides and early setup
  * calls.
@@ -233,6 +239,7 @@ void __init x86_mrst_early_setup(void)
 	x86_cpuinit.setup_percpu_clockev = mrst_setup_secondary_clock;
 
 	x86_platform.calibrate_tsc = mrst_calibrate_tsc;
+	x86_platform.i8042_detect = mrst_i8042_detect;
 	x86_init.pci.init = pci_mrst_init;
 	x86_init.pci.fixup_irqs = x86_init_noop;
 
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index 61a1e8c..cd6da6b 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -5,6 +5,7 @@
  */
 #include <linux/init.h>
 #include <linux/ioport.h>
+#include <linux/module.h>
 
 #include <asm/bios_ebda.h>
 #include <asm/paravirt.h>
@@ -85,6 +86,7 @@ struct x86_cpuinit_ops x86_cpuinit __cpuinitdata = {
 };
 
 static void default_nmi_init(void) { };
+static int default_i8042_detect(void) { return 1; };
 
 struct x86_platform_ops x86_platform = {
 	.calibrate_tsc			= native_calibrate_tsc,
@@ -92,5 +94,8 @@ struct x86_platform_ops x86_platform = {
 	.set_wallclock			= mach_set_rtc_mmss,
 	.iommu_shutdown			= iommu_shutdown_noop,
 	.is_untracked_pat_range		= is_ISA_range,
-	.nmi_init			= default_nmi_init
+	.nmi_init			= default_nmi_init,
+	.i8042_detect			= default_i8042_detect
 };
+
+EXPORT_SYMBOL_GPL(x86_platform);
diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
index 0f9a478..3525f53 100644
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -69,11 +69,11 @@ config KEYBOARD_ATARI
 	  module will be called atakbd.
 
 config KEYBOARD_ATKBD
-	tristate "AT keyboard" if EMBEDDED || !X86 || X86_MRST
+	tristate "AT keyboard" if EMBEDDED || !X86
 	default y
 	select SERIO
 	select SERIO_LIBPS2
-	select SERIO_I8042 if X86 && !X86_MRST
+	select SERIO_I8042 if X86
 	select SERIO_GSCPS2 if GSC
 	help
 	  Say Y here if you want to use a standard AT or PS/2 keyboard. Usually
diff --git a/drivers/input/mouse/Kconfig b/drivers/input/mouse/Kconfig
index eeb58c1..c714ca2 100644
--- a/drivers/input/mouse/Kconfig
+++ b/drivers/input/mouse/Kconfig
@@ -17,7 +17,7 @@ config MOUSE_PS2
 	default y
 	select SERIO
 	select SERIO_LIBPS2
-	select SERIO_I8042 if X86 && !X86_MRST
+	select SERIO_I8042 if X86
 	select SERIO_GSCPS2 if GSC
 	help
 	  Say Y here if you have a PS/2 mouse connected to your system. This
diff --git a/drivers/input/serio/Kconfig b/drivers/input/serio/Kconfig
index 256b9e9..3bfe8fa 100644
--- a/drivers/input/serio/Kconfig
+++ b/drivers/input/serio/Kconfig
@@ -22,7 +22,7 @@ config SERIO_I8042
 	tristate "i8042 PC Keyboard controller" if EMBEDDED || !X86
 	default y
 	depends on !PARISC && (!ARM || ARCH_SHARK || FOOTBRIDGE_HOST) && \
-		   (!SUPERH || SH_CAYMAN) && !M68K && !BLACKFIN && !X86_MRST
+		   (!SUPERH || SH_CAYMAN) && !M68K && !BLACKFIN
 	help
 	  i8042 is the chip over which the standard AT keyboard and PS/2
 	  mouse are connected to the computer. If you use these devices,
diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index 6168469..81003c4 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -7,6 +7,10 @@
  * the Free Software Foundation.
  */
 
+#ifdef CONFIG_X86
+#include <asm/x86_init.h>
+#endif
+
 /*
  * Names.
  */
@@ -840,6 +844,12 @@ static int __init i8042_platform_init(void)
 {
 	int retval;
 
+#ifdef CONFIG_X86
+	/* Just return if pre-detection shows no i8042 controller exist */
+	if (!x86_platform.i8042_detect())
+		return -ENODEV;
+#endif
+
 /*
  * On ix86 platforms touching the i8042 data register region can do really
  * bad things. Because of this the region is always reserved on ix86 boxes.
