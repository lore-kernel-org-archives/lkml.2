Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758202Ab0JUNtL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 09:49:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53440 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757961Ab0JUNtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 09:49:09 -0400
Date: Thu, 21 Oct 2010 15:49:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/idle for v2.6.37
Message-ID: <20101021134900.GA6130@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-idle-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-idle-for-linus

out-of-topic modifications in x86-idle-for-linus:
-------------------------------------------------
drivers/acpi/acpi_pad.c            # bc83ccc: x86, mwait: Move mwait constants 
drivers/idle/intel_idle.c          # bc83ccc: x86, mwait: Move mwait constants 

 Thanks,

	Ingo

------------------>
H. Peter Anvin (4):
      x86, mwait: Move mwait constants to a common header file
      x86, hotplug: Use mwait to offline a processor, fix the legacy case
      x86, hotplug: Move WBINVD back outside the play_dead loop
      x86, hotplug: In the MWAIT case of play_dead, CLFLUSH the cache line


 arch/x86/include/asm/mwait.h     |   15 +++++++
 arch/x86/include/asm/processor.h |   23 -----------
 arch/x86/kernel/acpi/cstate.c    |   11 +-----
 arch/x86/kernel/smpboot.c        |   80 +++++++++++++++++++++++++++++++++++++-
 drivers/acpi/acpi_pad.c          |    7 +---
 drivers/idle/intel_idle.c        |    9 +----
 6 files changed, 97 insertions(+), 48 deletions(-)
 create mode 100644 arch/x86/include/asm/mwait.h

diff --git a/arch/x86/include/asm/mwait.h b/arch/x86/include/asm/mwait.h
new file mode 100644
index 0000000..bcdff99
--- /dev/null
+++ b/arch/x86/include/asm/mwait.h
@@ -0,0 +1,15 @@
+#ifndef _ASM_X86_MWAIT_H
+#define _ASM_X86_MWAIT_H
+
+#define MWAIT_SUBSTATE_MASK		0xf
+#define MWAIT_CSTATE_MASK		0xf
+#define MWAIT_SUBSTATE_SIZE		4
+#define MWAIT_MAX_NUM_CSTATES		8
+
+#define CPUID_MWAIT_LEAF		5
+#define CPUID5_ECX_EXTENSIONS_SUPPORTED 0x1
+#define CPUID5_ECX_INTERRUPT_BREAK	0x2
+
+#define MWAIT_ECX_INTERRUPT_BREAK	0x1
+
+#endif /* _ASM_X86_MWAIT_H */
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 325b7bd..f358241 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -764,29 +764,6 @@ extern unsigned long		idle_halt;
 extern unsigned long		idle_nomwait;
 extern bool			c1e_detected;
 
-/*
- * on systems with caches, caches must be flashed as the absolute
- * last instruction before going into a suspended halt.  Otherwise,
- * dirty data can linger in the cache and become stale on resume,
- * leading to strange errors.
- *
- * perform a variety of operations to guarantee that the compiler
- * will not reorder instructions.  wbinvd itself is serializing
- * so the processor will not reorder.
- *
- * Systems without cache can just go into halt.
- */
-static inline void wbinvd_halt(void)
-{
-	mb();
-	/* check for clflush to determine if wbinvd is legal */
-	if (cpu_has_clflush)
-		asm volatile("cli; wbinvd; 1: hlt; jmp 1b" : : : "memory");
-	else
-		while (1)
-			halt();
-}
-
 extern void enable_sep_cpu(void);
 extern int sysenter_setup(void);
 
diff --git a/arch/x86/kernel/acpi/cstate.c b/arch/x86/kernel/acpi/cstate.c
index fb7a5f0..bcc4add 100644
--- a/arch/x86/kernel/acpi/cstate.c
+++ b/arch/x86/kernel/acpi/cstate.c
@@ -13,6 +13,7 @@
 
 #include <acpi/processor.h>
 #include <asm/acpi.h>
+#include <asm/mwait.h>
 
 /*
  * Initialize bm_flags based on the CPU cache properties
@@ -65,16 +66,6 @@ static struct cstate_entry *cpu_cstate_entry;	/* per CPU ptr */
 
 static short mwait_supported[ACPI_PROCESSOR_MAX_POWER];
 
-#define MWAIT_SUBSTATE_MASK	(0xf)
-#define MWAIT_CSTATE_MASK	(0xf)
-#define MWAIT_SUBSTATE_SIZE	(4)
-
-#define CPUID_MWAIT_LEAF (5)
-#define CPUID5_ECX_EXTENSIONS_SUPPORTED (0x1)
-#define CPUID5_ECX_INTERRUPT_BREAK	(0x2)
-
-#define MWAIT_ECX_INTERRUPT_BREAK	(0x1)
-
 #define NATIVE_CSTATE_BEYOND_HALT	(2)
 
 static long acpi_processor_ffh_cstate_probe_cpu(void *_cx)
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 8b3bfc4..fdccfe9 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -62,6 +62,7 @@
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/mtrr.h>
+#include <asm/mwait.h>
 #include <asm/vmi.h>
 #include <asm/apic.h>
 #include <asm/setup.h>
@@ -1383,11 +1384,88 @@ void play_dead_common(void)
 	local_irq_disable();
 }
 
+/*
+ * We need to flush the caches before going to sleep, lest we have
+ * dirty data in our caches when we come back up.
+ */
+static inline void mwait_play_dead(void)
+{
+	unsigned int eax, ebx, ecx, edx;
+	unsigned int highest_cstate = 0;
+	unsigned int highest_subcstate = 0;
+	int i;
+	void *mwait_ptr;
+
+	if (!cpu_has(&current_cpu_data, X86_FEATURE_MWAIT))
+		return;
+	if (!cpu_has(&current_cpu_data, X86_FEATURE_CLFLSH))
+		return;
+	if (current_cpu_data.cpuid_level < CPUID_MWAIT_LEAF)
+		return;
+
+	eax = CPUID_MWAIT_LEAF;
+	ecx = 0;
+	native_cpuid(&eax, &ebx, &ecx, &edx);
+
+	/*
+	 * eax will be 0 if EDX enumeration is not valid.
+	 * Initialized below to cstate, sub_cstate value when EDX is valid.
+	 */
+	if (!(ecx & CPUID5_ECX_EXTENSIONS_SUPPORTED)) {
+		eax = 0;
+	} else {
+		edx >>= MWAIT_SUBSTATE_SIZE;
+		for (i = 0; i < 7 && edx; i++, edx >>= MWAIT_SUBSTATE_SIZE) {
+			if (edx & MWAIT_SUBSTATE_MASK) {
+				highest_cstate = i;
+				highest_subcstate = edx & MWAIT_SUBSTATE_MASK;
+			}
+		}
+		eax = (highest_cstate << MWAIT_SUBSTATE_SIZE) |
+			(highest_subcstate - 1);
+	}
+
+	/*
+	 * This should be a memory location in a cache line which is
+	 * unlikely to be touched by other processors.  The actual
+	 * content is immaterial as it is not actually modified in any way.
+	 */
+	mwait_ptr = &current_thread_info()->flags;
+
+	wbinvd();
+
+	while (1) {
+		/*
+		 * The CLFLUSH is a workaround for erratum AAI65 for
+		 * the Xeon 7400 series.  It's not clear it is actually
+		 * needed, but it should be harmless in either case.
+		 * The WBINVD is insufficient due to the spurious-wakeup
+		 * case where we return around the loop.
+		 */
+		clflush(mwait_ptr);
+		__monitor(mwait_ptr, 0, 0);
+		mb();
+		__mwait(eax, 0);
+	}
+}
+
+static inline void hlt_play_dead(void)
+{
+	if (current_cpu_data.x86 >= 4)
+		wbinvd();
+
+	while (1) {
+		native_halt();
+	}
+}
+
 void native_play_dead(void)
 {
 	play_dead_common();
 	tboot_shutdown(TB_SHUTDOWN_WFS);
-	wbinvd_halt();
+
+	mwait_play_dead();	/* Only returns on failure */
+	hlt_play_dead();
 }
 
 #else /* ... !CONFIG_HOTPLUG_CPU */
diff --git a/drivers/acpi/acpi_pad.c b/drivers/acpi/acpi_pad.c
index b76848c..ca2694d 100644
--- a/drivers/acpi/acpi_pad.c
+++ b/drivers/acpi/acpi_pad.c
@@ -30,18 +30,13 @@
 #include <linux/slab.h>
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
+#include <asm/mwait.h>
 
 #define ACPI_PROCESSOR_AGGREGATOR_CLASS	"acpi_pad"
 #define ACPI_PROCESSOR_AGGREGATOR_DEVICE_NAME "Processor Aggregator"
 #define ACPI_PROCESSOR_AGGREGATOR_NOTIFY 0x80
 static DEFINE_MUTEX(isolated_cpus_lock);
 
-#define MWAIT_SUBSTATE_MASK	(0xf)
-#define MWAIT_CSTATE_MASK	(0xf)
-#define MWAIT_SUBSTATE_SIZE	(4)
-#define CPUID_MWAIT_LEAF (5)
-#define CPUID5_ECX_EXTENSIONS_SUPPORTED (0x1)
-#define CPUID5_ECX_INTERRUPT_BREAK	(0x2)
 static unsigned long power_saving_mwait_eax;
 
 static unsigned char tsc_detected_unstable;
diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index a10152b..065c804 100755
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -59,18 +59,11 @@
 #include <linux/hrtimer.h>	/* ktime_get_real() */
 #include <trace/events/power.h>
 #include <linux/sched.h>
+#include <asm/mwait.h>
 
 #define INTEL_IDLE_VERSION "0.4"
 #define PREFIX "intel_idle: "
 
-#define MWAIT_SUBSTATE_MASK	(0xf)
-#define MWAIT_CSTATE_MASK	(0xf)
-#define MWAIT_SUBSTATE_SIZE	(4)
-#define MWAIT_MAX_NUM_CSTATES	8
-#define CPUID_MWAIT_LEAF (5)
-#define CPUID5_ECX_EXTENSIONS_SUPPORTED (0x1)
-#define CPUID5_ECX_INTERRUPT_BREAK	(0x2)
-
 static struct cpuidle_driver intel_idle_driver = {
 	.name = "intel_idle",
 	.owner = THIS_MODULE,
