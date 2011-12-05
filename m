Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289Ab1LENWv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 08:22:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57440 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932118Ab1LENWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 08:22:49 -0500
Date: Mon, 5 Dec 2011 05:22:27 -0800
From: tip-bot for Don Zickus <dzickus@redhat.com>
Message-ID: <tip-99e8b9ca90d688c3ac7d3a141b701c9694a93925@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        andi@firstfloor.org, torvalds@linux-foundation.org,
        peterz@infradead.org, robert.richter@amd.com, tglx@linutronix.de,
        mingo@elte.hu, dzickus@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, torvalds@linux-foundation.org,
        peterz@infradead.org, robert.richter@amd.com, tglx@linutronix.de,
        mingo@elte.hu, dzickus@redhat.com
In-Reply-To: <1318533267-18880-3-git-send-email-dzickus@redhat.com>
References: <1318533267-18880-3-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] x86, NMI: Add NMI IPI selftest
Git-Commit-ID: 99e8b9ca90d688c3ac7d3a141b701c9694a93925
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 05:22:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  99e8b9ca90d688c3ac7d3a141b701c9694a93925
Gitweb:     http://git.kernel.org/tip/99e8b9ca90d688c3ac7d3a141b701c9694a93925
Author:     Don Zickus <dzickus@redhat.com>
AuthorDate: Thu, 13 Oct 2011 15:14:26 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 5 Dec 2011 12:00:16 +0100

x86, NMI: Add NMI IPI selftest

The previous patch modified the stop cpus path to use NMI
instead of IRQ as the way to communicate to the other cpus to
shutdown.  There were some concerns that various machines may
have problems with using an NMI IPI.

This patch creates a selftest to check if NMI is working at
boot. The idea is to help catch any issues before the machine
panics and we learn the hard way.

Loosely based on the locking-selftest.c file, this separate file
runs a couple of simple tests and reports the results.  The
output looks like:

...
Brought up 4 CPUs
----------------
| NMI testsuite:
--------------------
  remote IPI:  ok  |
   local IPI:  ok  |
--------------------
Good, all   2 testcases passed! |
---------------------------------
Total of 4 processors activated (21330.61 BogoMIPS).
...

Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>
Cc: seiji.aguchi@hds.com
Cc: vgoyal@redhat.com
Cc: mjg@redhat.com
Cc: tony.luck@intel.com
Cc: gong.chen@intel.com
Cc: satoru.moriya@hds.com
Cc: avi@redhat.com
Cc: Andi Kleen <andi@firstfloor.org>
Link: http://lkml.kernel.org/r/1318533267-18880-3-git-send-email-dzickus@redhat.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig.debug         |   12 +++
 arch/x86/include/asm/smp.h     |    6 ++
 arch/x86/kernel/Makefile       |    1 +
 arch/x86/kernel/nmi_selftest.c |  179 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/smpboot.c      |    1 +
 5 files changed, 199 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 4caec12..97da3c1 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -287,4 +287,16 @@ config DEBUG_STRICT_USER_COPY_CHECKS
 
 	  If unsure, or if you run an older (pre 4.4) gcc, say N.
 
+config DEBUG_NMI_SELFTEST
+	bool "NMI Selftest"
+	depends on DEBUG_KERNEL
+	---help---
+	  Enabling this option turns on a quick NMI selftest to verify
+	  that the NMI behaves correctly.
+
+	  This might help diagnose strange hangs that rely on NMI to
+	  function properly.
+
+	  If unsure, say N.
+
 endmenu
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 73b11bc..0434c40 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -225,5 +225,11 @@ extern int hard_smp_processor_id(void);
 
 #endif /* CONFIG_X86_LOCAL_APIC */
 
+#ifdef CONFIG_DEBUG_NMI_SELFTEST
+extern void nmi_selftest(void);
+#else
+#define nmi_selftest() do { } while (0)
+#endif
+
 #endif /* __ASSEMBLY__ */
 #endif /* _ASM_X86_SMP_H */
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 8baca3c..02b2f05 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -80,6 +80,7 @@ obj-$(CONFIG_APB_TIMER)		+= apb_timer.o
 obj-$(CONFIG_AMD_NB)		+= amd_nb.o
 obj-$(CONFIG_DEBUG_RODATA_TEST)	+= test_rodata.o
 obj-$(CONFIG_DEBUG_NX_TEST)	+= test_nx.o
+obj-$(CONFIG_DEBUG_NMI_SELFTEST) += nmi_selftest.o
 
 obj-$(CONFIG_KVM_GUEST)		+= kvm.o
 obj-$(CONFIG_KVM_CLOCK)		+= kvmclock.o
diff --git a/arch/x86/kernel/nmi_selftest.c b/arch/x86/kernel/nmi_selftest.c
new file mode 100644
index 0000000..572adb6
--- /dev/null
+++ b/arch/x86/kernel/nmi_selftest.c
@@ -0,0 +1,179 @@
+/*
+ * arch/x86/kernel/nmi-selftest.c
+ *
+ * Testsuite for NMI: IPIs
+ *
+ * Started by Don Zickus:
+ * (using lib/locking-selftest.c as a guide)
+ *
+ *   Copyright (C) 2011 Red Hat, Inc., Don Zickus <dzickus@redhat.com>
+ */
+
+#include <linux/smp.h>
+#include <linux/cpumask.h>
+#include <linux/delay.h>
+
+#include <asm/apic.h>
+#include <asm/nmi.h>
+
+#define SUCCESS		0
+#define FAILURE		1
+#define TIMEOUT		2
+
+static int nmi_fail;
+
+/* check to see if NMI IPIs work on this machine */
+static DECLARE_BITMAP(nmi_ipi_mask, NR_CPUS) __read_mostly;
+
+static int testcase_total;
+static int testcase_successes;
+static int expected_testcase_failures;
+static int unexpected_testcase_failures;
+static int unexpected_testcase_unknowns;
+
+static int nmi_unk_cb(unsigned int val, struct pt_regs *regs)
+{
+	unexpected_testcase_unknowns++;
+	return NMI_HANDLED;
+}
+
+static void init_nmi_testsuite(void)
+{
+	/* trap all the unknown NMIs we may generate */
+	register_nmi_handler(NMI_UNKNOWN, nmi_unk_cb, 0, "nmi_selftest_unk");
+}
+
+static void cleanup_nmi_testsuite(void)
+{
+	unregister_nmi_handler(NMI_UNKNOWN, "nmi_selftest_unk");
+}
+
+static int test_nmi_ipi_callback(unsigned int val, struct pt_regs *regs)
+{
+        int cpu = raw_smp_processor_id();
+
+        if (cpumask_test_and_clear_cpu(cpu, to_cpumask(nmi_ipi_mask)))
+                return NMI_HANDLED;
+
+        return NMI_DONE;
+}
+
+static void test_nmi_ipi(struct cpumask *mask)
+{
+	unsigned long timeout;
+
+	if (register_nmi_handler(NMI_LOCAL, test_nmi_ipi_callback,
+				 NMI_FLAG_FIRST, "nmi_selftest")) {
+		nmi_fail = FAILURE;
+		return;
+	}
+
+	/* sync above data before sending NMI */
+	wmb();
+
+	apic->send_IPI_mask(mask, NMI_VECTOR);
+
+	/* Don't wait longer than a second */
+	timeout = USEC_PER_SEC;
+	while (!cpumask_empty(mask) && timeout--)
+	        udelay(1);
+
+	/* What happens if we timeout, do we still unregister?? */
+	unregister_nmi_handler(NMI_LOCAL, "nmi_selftest");
+
+	if (!timeout)
+		nmi_fail = TIMEOUT;
+	return;
+}
+
+static void remote_ipi(void)
+{
+	cpumask_copy(to_cpumask(nmi_ipi_mask), cpu_online_mask);
+	cpumask_clear_cpu(smp_processor_id(), to_cpumask(nmi_ipi_mask));
+	test_nmi_ipi(to_cpumask(nmi_ipi_mask));
+}
+
+static void local_ipi(void)
+{
+	cpumask_clear(to_cpumask(nmi_ipi_mask));
+	cpumask_set_cpu(smp_processor_id(), to_cpumask(nmi_ipi_mask));
+	test_nmi_ipi(to_cpumask(nmi_ipi_mask));
+}
+
+static void reset_nmi(void)
+{
+	nmi_fail = 0;
+}
+
+static void dotest(void (*testcase_fn)(void), int expected)
+{
+	testcase_fn();
+	/*
+	 * Filter out expected failures:
+	 */
+	if (nmi_fail != expected) {
+		unexpected_testcase_failures++;
+
+		if (nmi_fail == FAILURE)
+			printk("FAILED |");
+		else if (nmi_fail == TIMEOUT)
+			printk("TIMEOUT|");
+		else
+			printk("ERROR  |");
+		dump_stack();
+	} else {
+		testcase_successes++;
+		printk("  ok  |");
+	}
+	testcase_total++;
+
+	reset_nmi();
+}
+
+static inline void print_testname(const char *testname)
+{
+	printk("%12s:", testname);
+}
+
+void nmi_selftest(void)
+{
+	init_nmi_testsuite();
+
+        /*
+	 * Run the testsuite:
+	 */
+	printk("----------------\n");
+	printk("| NMI testsuite:\n");
+	printk("--------------------\n");
+
+	print_testname("remote IPI");
+	dotest(remote_ipi, SUCCESS);
+	printk("\n");
+	print_testname("local IPI");
+	dotest(local_ipi, SUCCESS);
+	printk("\n");
+
+	cleanup_nmi_testsuite();
+
+	if (unexpected_testcase_failures) {
+		printk("--------------------\n");
+		printk("BUG: %3d unexpected failures (out of %3d) - debugging disabled! |\n",
+			unexpected_testcase_failures, testcase_total);
+		printk("-----------------------------------------------------------------\n");
+	} else if (expected_testcase_failures && testcase_successes) {
+		printk("--------------------\n");
+		printk("%3d out of %3d testcases failed, as expected. |\n",
+			expected_testcase_failures, testcase_total);
+		printk("----------------------------------------------------\n");
+	} else if (expected_testcase_failures && !testcase_successes) {
+		printk("--------------------\n");
+		printk("All %3d testcases failed, as expected. |\n",
+			expected_testcase_failures);
+		printk("----------------------------------------\n");
+	} else {
+		printk("--------------------\n");
+		printk("Good, all %3d testcases passed! |\n",
+			testcase_successes);
+		printk("---------------------------------\n");
+	}
+}
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 9f548cb..1927781 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1142,6 +1142,7 @@ void __init native_smp_cpus_done(unsigned int max_cpus)
 {
 	pr_debug("Boot done.\n");
 
+	nmi_selftest();
 	impress_friends();
 #ifdef CONFIG_X86_IO_APIC
 	setup_ioapic_dest();
