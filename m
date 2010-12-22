Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955Ab0LVO0F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 09:26:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36142 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681Ab0LVO0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 09:26:03 -0500
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, fweisbec@gmail.com,
        LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH v2] x86, nmi_watchdog:  Remove ARCH_HAS_NMI_WATCHDOG and rely on CONFIG_HARDLOCKUP_DETECTOR
Date: Wed, 22 Dec 2010 09:25:42 -0500
Message-Id: <1293027942-7599-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The x86 arch has shifted its use of the nmi_watchdog from a local implementation
to the global one provide by kernel/watchdog.c.  This shift has caused a whole
bunch of compile problems under different config options.  I attempt to simplify
things with the patch below.

In order to simplify things, I had to come to terms with the meaning of two terms
ARCH_HAS_NMI_WATCHDOG and CONFIG_HARDLOCKUP_DETECTOR.  Basically they mean the
same thing, the former on a local level and the latter on a global level.

With the old x86 nmi watchdog gone, there is no need to rely on defining the
ARCH_HAS_NMI_WATCHDOG variable because it doesn't make sense any more.  x86 will
now use the global implementation.

The changes below do a few things.  First it changes the few places that relied on
ARCH_HAS_NMI_WATCHDOG to use CONFIG_X86_LOCAL_APIC (the former was an alias for
the latter anyway, so nothing unusual here).  Those pieces of code were relying more
on local apic functionality the nmi watchdog functionality, so the change should
make sense.

Second, I removed the x86 implementation of touch_nmi_watchdog().  It isn't need
now, instead x86 will rely on kernel/watchdog.c's implementation.

Third, I removed the #define ARCH_HAS_NMI_WATCHDOG itself from x86.  And tweaked
the include/linux/nmi.h file to tell users to look for an externally defined
touch_nmi_watchdog in the case of ARCH_HAS_NMI_WATCHDOG _or_ CONFIG_HARDLOCKUP_DETECTOR.
This changes removes some of the ugliness in that file.

Finally, I added a Kconfig dependency for CONFIG_HARDLOCKUP_DETECTOR that said you
can't have ARCH_HAS_NMI_WATCHDOG _and_ CONFIG_HARDLOCKUP_DETECTOR.  You can only have
one nmi_watchdog.

Tested with
ARCH=i386: allnoconfig, defconfig, allyesconfig, (various broken configs)
ARCH=x86_64: allnoconfig, defconfig, allyesconfig, (various broken configs)

Hopefully, after this patch I won't get any more compile broken emails. :-)

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/include/asm/irq.h    |    4 ----
 arch/x86/include/asm/nmi.h    |    2 +-
 arch/x86/kernel/apic/hw_nmi.c |   10 ----------
 drivers/watchdog/hpwdt.c      |    4 ++--
 include/linux/nmi.h           |    6 +-----
 lib/Kconfig.debug             |    3 ++-
 6 files changed, 6 insertions(+), 23 deletions(-)

diff --git a/arch/x86/include/asm/irq.h b/arch/x86/include/asm/irq.h
index 13b0eba..ba870bb 100644
--- a/arch/x86/include/asm/irq.h
+++ b/arch/x86/include/asm/irq.h
@@ -15,10 +15,6 @@ static inline int irq_canonicalize(int irq)
 	return ((irq == 2) ? 9 : irq);
 }
 
-#ifdef CONFIG_X86_LOCAL_APIC
-# define ARCH_HAS_NMI_WATCHDOG
-#endif
-
 #ifdef CONFIG_X86_32
 extern void irq_ctx_init(int cpu);
 #else
diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
index 3545838..c4021b9 100644
--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -5,7 +5,7 @@
 #include <asm/irq.h>
 #include <asm/io.h>
 
-#ifdef ARCH_HAS_NMI_WATCHDOG
+#ifdef CONFIG_X86_LOCAL_APIC
 
 extern void die_nmi(char *str, struct pt_regs *regs, int do_panic);
 extern int avail_to_resrv_perfctr_nmi_bit(unsigned int);
diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index 93da91d..c57d0b5 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -17,7 +17,6 @@
 #include <linux/nmi.h>
 #include <linux/module.h>
 
-#ifdef ARCH_HAS_NMI_WATCHDOG
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
 u64 hw_nmi_get_sample_period(void)
 {
@@ -25,15 +24,6 @@ u64 hw_nmi_get_sample_period(void)
 }
 #endif
 
-#ifndef CONFIG_HARDLOCKUP_DETECTOR
-void touch_nmi_watchdog(void)
-{
-	touch_softlockup_watchdog();
-}
-EXPORT_SYMBOL(touch_nmi_watchdog);
-#endif
-#endif
-
 #ifdef arch_trigger_all_cpu_backtrace
 /* For reliability, we're prepared to waste bits here. */
 static DECLARE_BITMAP(backtrace_mask, NR_CPUS) __read_mostly;
diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index c19f4a2..dea7b5b 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -642,7 +642,7 @@ static struct notifier_block die_notifier = {
  */
 
 #ifdef CONFIG_HPWDT_NMI_DECODING
-#ifdef ARCH_HAS_NMI_WATCHDOG
+#ifdef CONFIG_X86_LOCAL_APIC
 static void __devinit hpwdt_check_nmi_decoding(struct pci_dev *dev)
 {
 	/*
@@ -657,7 +657,7 @@ static void __devinit hpwdt_check_nmi_decoding(struct pci_dev *dev)
 	dev_warn(&dev->dev, "NMI decoding is disabled. "
 		"Your kernel does not support a NMI Watchdog.\n");
 }
-#endif /* ARCH_HAS_NMI_WATCHDOG */
+#endif /* CONFIG_X86_LOCAL_APIC */
 
 static int __devinit hpwdt_init_nmi_decoding(struct pci_dev *dev)
 {
diff --git a/include/linux/nmi.h b/include/linux/nmi.h
index 17ccf44..c536f85 100644
--- a/include/linux/nmi.h
+++ b/include/linux/nmi.h
@@ -14,18 +14,14 @@
  * may be used to reset the timeout - for code which intentionally
  * disables interrupts for a long time. This call is stateless.
  */
-#ifdef ARCH_HAS_NMI_WATCHDOG
+#if defined(ARCH_HAS_NMI_WATCHDOG) || defined(CONFIG_HARDLOCKUP_DETECTOR)
 #include <asm/nmi.h>
 extern void touch_nmi_watchdog(void);
 #else
-#ifndef CONFIG_HARDLOCKUP_DETECTOR
 static inline void touch_nmi_watchdog(void)
 {
 	touch_softlockup_watchdog();
 }
-#else
-extern void touch_nmi_watchdog(void);
-#endif
 #endif
 
 /*
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 28b42b9..2d05adb 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -173,7 +173,8 @@ config LOCKUP_DETECTOR
 	  An NMI is generated every 60 seconds or so to check for hardlockups.
 
 config HARDLOCKUP_DETECTOR
-	def_bool LOCKUP_DETECTOR && PERF_EVENTS && HAVE_PERF_EVENTS_NMI
+	def_bool LOCKUP_DETECTOR && PERF_EVENTS && HAVE_PERF_EVENTS_NMI && \
+		 !ARCH_HAS_NMI_WATCHDOG
 
 config BOOTPARAM_SOFTLOCKUP_PANIC
 	bool "Panic (Reboot) On Soft Lockups"
-- 
1.7.3.2

