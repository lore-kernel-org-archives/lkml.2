Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983Ab2ALV7Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 16:59:16 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:50517 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755209Ab2ALV7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 16:59:14 -0500
From: Venkatesh Pallipadi <venki@google.com>
To: Eric Biederman <ebiederm@xmission.com>, Andi Kleen <andi@firstfloor.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Aaron Durbin <adurbin@google.com>, linux-kernel@vger.kernel.org,
        Venkatesh Pallipadi <venki@google.com>
Subject: [PATCH] Kexec reboot and stale/inconsistent system state
Date: Thu, 12 Jan 2012 13:58:41 -0800
Message-Id: <1326405521-2736-1-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Of course, kexec reboots has a lot of advantantages. There is one
blind spot though, in the way we handle shutdown of the old kernel in kexec.
The problem: there are drivers in the kernel that change
system state either during init or during normal operation. During a
hardware reboot these system states would get reset to default.
But, with kexec reboot this system state can stay persistent with the
new kernel and can lead to some inconsistencies.

More concrete x86 example:
* Kernel_v0 has a driver which sets a particular MSR.
* Kernel_v1 has a different version of the driver which does not touch the
MSR and assumes it to be at BIOS init state.
* Now we have a kexec reboot from Kernel_v0 to Kernel_v1 and the MSR will
stay set leading to potential inconsistent state.

One such driver I was looking at is drivers/idle/intel_idle.c, which sets
the MSR during init and forgets about it. There are other drivers which can
potentially have similar problems - like MTRR, etc. There can be other
state in the system like chipset state and device state etc, though
I expect most of it won't be a problem based on the way drivers init.

Seemingly simple solution is to do the needed cleanup in driver's module_exit
code path. That is not enough as module_exit for all builtin drivers are
all discarded.

What if we retain all the module_exits in CONFIG_KEXEC case and do a
cleanup before launching a new kernel. This should work, but most of the
module_exit code assumes that they will be only called when corresponding
init is successful. I couldn't find a clean and easy way of associating
module's init function with its exit function and to save the result of
init.

Alternate quick solution is to create a new module interface to register
kexec cleanup function as in the patch below. But, this is not generic enough
yet and does not handle the case where we have done the cleanup and kexec
fails after that and we have to do some setup again to run with old kernel.

Before spending more time on this, just wanted to run this RFC along to see:
* How big/serious this problem really is?
* Has this been looked at before and any other potential solution for this?

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
---
 drivers/idle/intel_idle.c         |   25 ++++++++++++++++++++++++-
 include/asm-generic/vmlinux.lds.h |   15 +++++++++++++++
 include/linux/init.h              |    7 +++++++
 kernel/kexec.c                    |    8 ++++++++
 4 files changed, 54 insertions(+), 1 deletions(-)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 5d2f8e1..a4cda68 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -92,6 +92,7 @@ static struct cpuidle_state *cpuidle_state_table;
  * Indicate which enable bits to clear here.
  */
 static unsigned long long auto_demotion_disable_flags;
+static unsigned long long auto_demote_msr_saved;
 
 /*
  * Set this flag for states where the HW flushes the TLB for us
@@ -324,6 +325,11 @@ static void auto_demotion_disable(void *dummy)
 	wrmsrl(MSR_NHM_SNB_PKG_CST_CFG_CTL, msr_bits);
 }
 
+static void auto_demotion_reset(void *dummy)
+{
+	wrmsrl(MSR_NHM_SNB_PKG_CST_CFG_CTL, auto_demote_msr_saved);
+}
+
 /*
  * intel_idle_probe()
  */
@@ -470,14 +476,27 @@ static int intel_idle_cpuidle_driver_init(void)
 		drv->state_count += 1;
 	}
 
-	if (auto_demotion_disable_flags)
+	if (auto_demotion_disable_flags) {
+		rdmsrl(MSR_NHM_SNB_PKG_CST_CFG_CTL, auto_demote_msr_saved);
 		smp_call_function(auto_demotion_disable, NULL, 1);
+	}
 
 	return 0;
 }
 
 
 /*
+ * intel_idle_cpuidle_driver_exit()
+ * Restore Hardware state
+ */
+static void intel_idle_cpuidle_driver_exit(void)
+{
+	if (auto_demotion_disable_flags)
+		smp_call_function(auto_demotion_reset, NULL, 1);
+}
+
+
+/*
  * intel_idle_cpuidle_devices_init()
  * allocate, initialize, register cpuidle_devices
  */
@@ -550,12 +569,14 @@ static int __init intel_idle_init(void)
 	if (retval) {
 		printk(KERN_DEBUG PREFIX "intel_idle yielding to %s",
 			cpuidle_get_driver()->name);
+		intel_idle_cpuidle_driver_exit();
 		return retval;
 	}
 
 	retval = intel_idle_cpuidle_devices_init();
 	if (retval) {
 		cpuidle_unregister_driver(&intel_idle_driver);
+		intel_idle_cpuidle_driver_exit();
 		return retval;
 	}
 
@@ -566,6 +587,7 @@ static void __exit intel_idle_exit(void)
 {
 	intel_idle_cpuidle_devices_uninit();
 	cpuidle_unregister_driver(&intel_idle_driver);
+	intel_idle_cpuidle_driver_exit();
 
 	if (lapic_timer_reliable_states != LAPIC_TIMER_ALWAYS_RELIABLE) {
 		smp_call_function(__setup_broadcast_timer, (void *)false, 1);
@@ -577,6 +599,7 @@ static void __exit intel_idle_exit(void)
 
 module_init(intel_idle_init);
 module_exit(intel_idle_exit);
+sysstate_cleanup(intel_idle_cpuidle_driver_exit);
 
 module_param(max_cstate, int, 0444);
 
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index b5e2e4c..7b8f913 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -98,6 +98,14 @@
 #define MEM_DISCARD(sec) *(.mem##sec)
 #endif
 
+#ifdef CONFIG_KEXEC
+#define CLEANUP_KEEP(sec)    *(.cleanupcall##sec)
+#define CLEANUP_DISCARD(sec)
+#else
+#define CLEANUP_KEEP(sec)
+#define CLEANUP_DISCARD(sec) *(.cleanupcall##sec)
+#endif
+
 #ifdef CONFIG_FTRACE_MCOUNT_RECORD
 #define MCOUNT_REC()	. = ALIGN(8);				\
 			VMLINUX_SYMBOL(__start_mcount_loc) = .; \
@@ -167,6 +175,7 @@
 	CPU_KEEP(exit.data)						\
 	MEM_KEEP(init.data)						\
 	MEM_KEEP(exit.data)						\
+	CLEANUP_CALL							\
 	STRUCT_ALIGN();							\
 	*(__tracepoints)						\
 	/* implement dynamic printk debug */				\
@@ -511,6 +520,7 @@
 
 #define EXIT_TEXT							\
 	*(.exit.text)							\
+	CLEANUP_DISCARD(.text)						\
 	DEV_DISCARD(exit.text)						\
 	CPU_DISCARD(exit.text)						\
 	MEM_DISCARD(exit.text)
@@ -518,6 +528,11 @@
 #define EXIT_CALL							\
 	*(.exitcall.exit)
 
+#define CLEANUP_CALL							\
+	VMLINUX_SYMBOL(__cleanupcall_start) = .;			\
+	CLEANUP_KEEP(.text)						\
+	VMLINUX_SYMBOL(__cleanupcall_end) = .;
+
 /*
  * bss (Block Started by Symbol) - uninitialized data
  * zeroed during startup
diff --git a/include/linux/init.h b/include/linux/init.h
index 9146f39..009867f 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -45,6 +45,7 @@
 #define __initconst	__section(.init.rodata)
 #define __exitdata	__section(.exit.data)
 #define __exit_call	__used __section(.exitcall.exit)
+#define __cleanup_call	__used __section(.cleanupcall.text)
 
 /*
  * modpost check for section mismatches during the kernel build.
@@ -137,6 +138,7 @@
  */
 typedef int (*initcall_t)(void);
 typedef void (*exitcall_t)(void);
+typedef void (*cleanupcall_t)(void);
 
 extern initcall_t __con_initcall_start[], __con_initcall_end[];
 extern initcall_t __security_initcall_start[], __security_initcall_end[];
@@ -277,6 +279,9 @@ void __init parse_early_options(char *cmdline);
  */
 #define module_exit(x)	__exitcall(x);
 
+#define sysstate_cleanup(fn)	\
+	static cleanupcall_t __cleanupcall_##fn __cleanup_call = fn;
+
 #else /* MODULE */
 
 /* Don't use these in modules, but some people do... */
@@ -303,6 +308,8 @@ void __init parse_early_options(char *cmdline);
 	{ return exitfn; }					\
 	void cleanup_module(void) __attribute__((alias(#exitfn)));
 
+#define sysstate_cleanup(x)			/* nothing */
+
 #define __setup_param(str, unique_id, fn)	/* nothing */
 #define __setup(str, func) 			/* nothing */
 #endif
diff --git a/kernel/kexec.c b/kernel/kexec.c
index dc7bc08..8a53858 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -6,6 +6,7 @@
  * Version 2.  See the file COPYING for more details.
  */
 
+#include <linux/init.h>
 #include <linux/capability.h>
 #include <linux/mm.h>
 #include <linux/file.h>
@@ -1506,6 +1507,8 @@ static int __init crash_save_vmcoreinfo_init(void)
 
 module_init(crash_save_vmcoreinfo_init)
 
+extern cleanupcall_t __cleanupcall_start[], __cleanupcall_end[];
+
 /*
  * Move into place and start executing a preloaded standalone
  * executable.  If nothing was preloaded return an error.
@@ -1513,6 +1516,7 @@ module_init(crash_save_vmcoreinfo_init)
 int kernel_kexec(void)
 {
 	int error = 0;
+	cleanupcall_t *fn;
 
 	if (!mutex_trylock(&kexec_mutex))
 		return -EBUSY;
@@ -1521,6 +1525,10 @@ int kernel_kexec(void)
 		goto Unlock;
 	}
 
+	/* Call registered sysstate_cleanup routines in reverse link order */
+	for (fn = __cleanupcall_end - 1; fn >= __cleanupcall_start; fn--)
+		(*fn)();
+
 #ifdef CONFIG_KEXEC_JUMP
 	if (kexec_image->preserve_context) {
 		mutex_lock(&pm_mutex);
-- 
1.7.7.3

