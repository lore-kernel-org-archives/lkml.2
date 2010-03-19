Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084Ab0CSDgo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 23:36:44 -0400
Received: from mga06.intel.com ([134.134.136.21]:30174 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752945Ab0CSDgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 23:36:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,272,1267430400"; 
   d="scan'208";a="501885587"
Subject: [PATCH] Enhance perf to collect KVM guest os statistics from host
 side
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       zhiteng.huang@intel.com
In-Reply-To: <1268717232.2813.36.camel@localhost>
References: <1268717232.2813.36.camel@localhost>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Fri, 19 Mar 2010 11:38:49 +0800
Message-Id: <1268969929.2813.184.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-16 at 13:27 +0800, Zhang, Yanmin wrote:
> From: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
> 
Here is the new patch of V2 against tip/master of March 17th
if anyone wants to try it.


ChangeLog V2:
	1) Based on Avi's suggestion, I moved callback functions
	to generic code area. So the kernel part of the patch is
	clearer.
	2) Add 'perf kvm stat'.


From: Zhang, Yanmin <yanmin_zhang@linux.intel.com>

Based on the discussion in KVM community, I worked out the patch to support
perf to collect guest os statistics from host side. This patch is implemented
with Ingo, Peter and some other guys' kind help. Yang Sheng pointed out a
critical bug and provided good suggestions with other guys. I really appreciate
their kind help.

The patch adds new subcommand kvm to perf.

  perf kvm top
  perf kvm record
  perf kvm report
  perf kvm diff
  perf kvm stat

The new perf could profile guest os kernel except guest os user space, but it
could summarize guest os user space utilization per guest os.

Below are some examples.
1) perf kvm top
[root@lkp-ne01 norm]# perf kvm --host --guest --guestkallsyms=/home/ymzhang/guest/kallsyms
--guestmodules=/home/ymzhang/guest/modules top

--------------------------------------------------------------------------------------------------------------------------
   PerfTop:   16010 irqs/sec  kernel:59.1% us: 1.5% guest kernel:31.9% guest us: 7.5% exact:  0.0% [1000Hz cycles],  (all, 16 CPUs)
--------------------------------------------------------------------------------------------------------------------------

             samples  pcnt function                  DSO
             _______ _____ _________________________ _______________________

            38770.00 20.4% __ticket_spin_lock        [guest.kernel.kallsyms]
            22560.00 11.9% ftrace_likely_update      [kernel.kallsyms]
             9208.00  4.8% __lock_acquire            [kernel.kallsyms]
             5473.00  2.9% trace_hardirqs_off_caller [kernel.kallsyms]
             5222.00  2.7% copy_user_generic_string  [guest.kernel.kallsyms]
             4450.00  2.3% validate_chain            [kernel.kallsyms]
             4262.00  2.2% trace_hardirqs_on_caller  [kernel.kallsyms]
             4239.00  2.2% do_raw_spin_lock          [kernel.kallsyms]
             3548.00  1.9% do_raw_spin_unlock        [kernel.kallsyms]
             2487.00  1.3% lock_release              [kernel.kallsyms]
             2165.00  1.1% __local_bh_disable        [kernel.kallsyms]
             1905.00  1.0% check_chain_key           [kernel.kallsyms]
             1737.00  0.9% lock_acquire              [kernel.kallsyms]
             1604.00  0.8% tcp_recvmsg               [kernel.kallsyms]
             1524.00  0.8% mark_lock                 [kernel.kallsyms]
             1464.00  0.8% schedule                  [kernel.kallsyms]
             1423.00  0.7% __d_lookup                [guest.kernel.kallsyms]

If you want to just show host data, pls. don't use parameter --guest.
The headline includes guest os kernel and userspace percentage.

2) perf kvm record
[root@lkp-ne01 norm]# perf kvm --host --guest --guestkallsyms=/home/ymzhang/guest/kallsyms
--guestmodules=/home/ymzhang/guest/modules record -f -a sleep 60
[ perf record: Woken up 15 times to write data ]
[ perf record: Captured and wrote 29.385 MB perf.data.kvm (~1283837 samples) ]

3) perf kvm report
        3.1) [root@lkp-ne01 norm]# perf kvm --host --guest --guestkallsyms=/home/ymzhang/guest/kallsyms
--guestmodules=/home/ymzhang/guest/modules report --sort pid --showcpuutilization>norm.host.guest.report.pid
# Samples: 424719292247
#
# Overhead  sys    us    guest sys    guest us            Command:  Pid
# ........  .....................
#
    50.57%     1.02%     0.00%    39.97%     9.58%  qemu-system-x86: 3587
    49.32%     1.35%     0.01%    35.20%    12.76%  qemu-system-x86: 3347
     0.07%     0.07%     0.00%     0.00%     0.00%             perf: 5217


Some performance guys require perf to show sys/us/guest_sys/guest_us per KVM guest
instance which is actually just a multi-threaded process. Above sub parameter --showcpuutilization
does so.

        3.2) [root@lkp-ne01 norm]# perf kvm --host --guest --guestkallsyms=/home/ymzhang/guest/kallsyms
--guestmodules=/home/ymzhang/guest/modules report >norm.host.guest.report
# Samples: 2466991384118
#
# Overhead          Command                                                             Shared Object  Symbol
# ........  ...............  ........................................................................  ......
#
    29.11%  qemu-system-x86  [guest.kernel.kallsyms]                                                   [g] __ticket_spin_lock
     5.88%       tbench_srv  [kernel.kallsyms]                                                         [k] ftrace_likely_update
     5.76%           tbench  [kernel.kallsyms]                                                         [k] ftrace_likely_update
     3.88%  qemu-system-x86                                                                34c3255482  [u] 0x000034c3255482
     1.83%           tbench  [kernel.kallsyms]                                                         [k] __lock_acquire
     1.81%       tbench_srv  [kernel.kallsyms]                                                         [k] __lock_acquire
     1.38%       tbench_srv  [kernel.kallsyms]                                                         [k] trace_hardirqs_off_caller
     1.37%           tbench  [kernel.kallsyms]                                                         [k] trace_hardirqs_off_caller
     1.13%  qemu-system-x86  [guest.kernel.kallsyms]                                                   [g] copy_user_generic_string
     1.04%       tbench_srv  [kernel.kallsyms]                                                         [k] validate_chain
     1.00%           tbench  [kernel.kallsyms]                                                         [k] trace_hardirqs_on_caller
     1.00%       tbench_srv  [kernel.kallsyms]                                                         [k] trace_hardirqs_on_caller
     0.95%           tbench  [kernel.kallsyms]                                                         [k] do_raw_spin_lock


[u] means it's in guest os user space. [g] means in guest os kernel. Other info is very direct.
If it shows a module such like [ext4], it means guest kernel module, because native host kernel's
modules are start from something like /lib/modules/XXX.


Below is the patch against tip/master tree of 17th March.

Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>

---

diff -Nraup linux-2.6_tip0317/arch/x86/include/asm/perf_event.h linux-2.6_tip0317_perfkvm/arch/x86/include/asm/perf_event.h
--- linux-2.6_tip0317/arch/x86/include/asm/perf_event.h	2010-03-18 09:04:36.597952883 +0800
+++ linux-2.6_tip0317_perfkvm/arch/x86/include/asm/perf_event.h	2010-03-18 15:06:19.579081193 +0800
@@ -143,17 +143,10 @@ extern void perf_events_lapic_init(void)
  */
 #define PERF_EFLAGS_EXACT	(1UL << 3)
 
-#define perf_misc_flags(regs)				\
-({	int misc = 0;					\
-	if (user_mode(regs))				\
-		misc |= PERF_RECORD_MISC_USER;		\
-	else						\
-		misc |= PERF_RECORD_MISC_KERNEL;	\
-	if (regs->flags & PERF_EFLAGS_EXACT)		\
-		misc |= PERF_RECORD_MISC_EXACT;		\
-	misc; })
-
-#define perf_instruction_pointer(regs)	((regs)->ip)
+struct pt_regs;
+extern unsigned long perf_instruction_pointer(struct pt_regs *regs);
+extern unsigned long perf_misc_flags(struct pt_regs *regs);
+#define perf_misc_flags(regs)	perf_misc_flags(regs)
 
 #else
 static inline void init_hw_perf_events(void)		{ }
diff -Nraup linux-2.6_tip0317/arch/x86/kernel/cpu/perf_event.c linux-2.6_tip0317_perfkvm/arch/x86/kernel/cpu/perf_event.c
--- linux-2.6_tip0317/arch/x86/kernel/cpu/perf_event.c	2010-03-18 09:04:36.665958497 +0800
+++ linux-2.6_tip0317_perfkvm/arch/x86/kernel/cpu/perf_event.c	2010-03-18 15:07:20.555339370 +0800
@@ -1708,3 +1708,30 @@ void perf_arch_fetch_caller_regs(struct 
 	local_save_flags(regs->flags);
 }
 #endif
+
+unsigned long perf_instruction_pointer(struct pt_regs *regs)
+{
+	unsigned long ip;
+	if (perf_guest_cbs && perf_guest_cbs->is_in_guest())
+		ip = perf_guest_cbs->get_guest_ip();
+	else
+		ip = instruction_pointer(regs);
+	return ip;
+}
+
+unsigned long perf_misc_flags(struct pt_regs *regs)
+{
+	int misc = 0;
+	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
+		misc |= perf_guest_cbs->is_user_mode() ?
+			PERF_RECORD_MISC_GUEST_USER :
+			PERF_RECORD_MISC_GUEST_KERNEL;
+	} else
+		misc |= user_mode(regs) ? PERF_RECORD_MISC_USER :
+			PERF_RECORD_MISC_KERNEL;
+	if (regs->flags & PERF_EFLAGS_EXACT)
+		misc |= PERF_RECORD_MISC_EXACT;
+
+	return misc;
+}
+
diff -Nraup linux-2.6_tip0317/arch/x86/kvm/x86.c linux-2.6_tip0317_perfkvm/arch/x86/kvm/x86.c
--- linux-2.6_tip0317/arch/x86/kvm/x86.c	2010-03-18 09:04:36.629956698 +0800
+++ linux-2.6_tip0317_perfkvm/arch/x86/kvm/x86.c	2010-03-18 15:06:19.579081193 +0800
@@ -3764,6 +3764,35 @@ static void kvm_timer_init(void)
 	}
 }
 
+static DEFINE_PER_CPU(struct kvm_vcpu *, current_vcpu);
+
+static int kvm_is_in_guest(void)
+{
+	return percpu_read(current_vcpu) != NULL;
+}
+
+static int kvm_is_user_mode(void)
+{
+	int user_mode = 3;
+	if (percpu_read(current_vcpu))
+		user_mode = kvm_x86_ops->get_cpl(percpu_read(current_vcpu));
+	return user_mode != 0;
+}
+
+static unsigned long kvm_get_guest_ip(void)
+{
+	unsigned long ip = 0;
+	if (percpu_read(current_vcpu))
+		ip = kvm_rip_read(percpu_read(current_vcpu));
+	return ip;
+}
+
+static struct perf_guest_info_callbacks kvm_guest_cbs = {
+	.is_in_guest            = kvm_is_in_guest,
+	.is_user_mode           = kvm_is_user_mode,
+	.get_guest_ip           = kvm_get_guest_ip,
+};
+
 int kvm_arch_init(void *opaque)
 {
 	int r;
@@ -3800,6 +3829,8 @@ int kvm_arch_init(void *opaque)
 
 	kvm_timer_init();
 
+	perf_register_guest_info_callbacks(&kvm_guest_cbs);
+
 	return 0;
 
 out:
@@ -3808,6 +3839,8 @@ out:
 
 void kvm_arch_exit(void)
 {
+	perf_unregister_guest_info_callbacks(&kvm_guest_cbs);
+
 	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
 		cpufreq_unregister_notifier(&kvmclock_cpufreq_notifier_block,
 					    CPUFREQ_TRANSITION_NOTIFIER);
@@ -4338,7 +4371,10 @@ static int vcpu_enter_guest(struct kvm_v
 	}
 
 	trace_kvm_entry(vcpu->vcpu_id);
+
+	percpu_write(current_vcpu, vcpu);
 	kvm_x86_ops->run(vcpu);
+	percpu_write(current_vcpu, NULL);
 
 	/*
 	 * If the guest has used debug registers, at least dr7
diff -Nraup linux-2.6_tip0317/include/linux/perf_event.h linux-2.6_tip0317_perfkvm/include/linux/perf_event.h
--- linux-2.6_tip0317/include/linux/perf_event.h	2010-03-18 09:04:37.674034701 +0800
+++ linux-2.6_tip0317_perfkvm/include/linux/perf_event.h	2010-03-18 15:06:19.583056523 +0800
@@ -288,11 +288,13 @@ struct perf_event_mmap_page {
 	__u64	data_tail;		/* user-space written tail */
 };
 
-#define PERF_RECORD_MISC_CPUMODE_MASK		(3 << 0)
+#define PERF_RECORD_MISC_CPUMODE_MASK		(7 << 0)
 #define PERF_RECORD_MISC_CPUMODE_UNKNOWN	(0 << 0)
 #define PERF_RECORD_MISC_KERNEL			(1 << 0)
 #define PERF_RECORD_MISC_USER			(2 << 0)
 #define PERF_RECORD_MISC_HYPERVISOR		(3 << 0)
+#define PERF_RECORD_MISC_GUEST_KERNEL		(4 << 0)
+#define PERF_RECORD_MISC_GUEST_USER		(5 << 0)
 
 #define PERF_RECORD_MISC_EXACT			(1 << 14)
 /*
@@ -446,6 +448,12 @@ enum perf_callchain_context {
 # include <asm/perf_event.h>
 #endif
 
+struct perf_guest_info_callbacks {
+	int (*is_in_guest) (void);
+	int (*is_user_mode) (void);
+	unsigned long (*get_guest_ip) (void);
+};
+
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
 #include <asm/hw_breakpoint.h>
 #endif
@@ -913,6 +921,12 @@ static inline void perf_event_mmap(struc
 		__perf_event_mmap(vma);
 }
 
+extern struct perf_guest_info_callbacks *perf_guest_cbs;
+extern int perf_register_guest_info_callbacks(
+		struct perf_guest_info_callbacks *);
+extern int perf_unregister_guest_info_callbacks(
+		struct perf_guest_info_callbacks *);
+
 extern void perf_event_comm(struct task_struct *tsk);
 extern void perf_event_fork(struct task_struct *tsk);
 
@@ -982,6 +996,11 @@ perf_sw_event(u32 event_id, u64 nr, int 
 static inline void
 perf_bp_event(struct perf_event *event, void *data)			{ }
 
+static inline int perf_register_guest_info_callbacks
+(struct perf_guest_info_callbacks *)   {return 0; }
+static inline int perf_unregister_guest_info_callbacks
+(struct perf_guest_info_callbacks *)   {return 0; }
+
 static inline void perf_event_mmap(struct vm_area_struct *vma)		{ }
 static inline void perf_event_comm(struct task_struct *tsk)		{ }
 static inline void perf_event_fork(struct task_struct *tsk)		{ }
diff -Nraup linux-2.6_tip0317/kernel/perf_event.c linux-2.6_tip0317_perfkvm/kernel/perf_event.c
--- linux-2.6_tip0317/kernel/perf_event.c	2010-03-18 09:04:40.954262305 +0800
+++ linux-2.6_tip0317_perfkvm/kernel/perf_event.c	2010-03-18 15:06:19.583056523 +0800
@@ -2798,6 +2798,27 @@ void perf_arch_fetch_caller_regs(struct 
 #endif
 
 /*
+ * We assume there is only KVM supporting the callbacks.
+ * Later on, we might change it to a list if there is
+ * another virtualization implementation supporting the callbacks.
+ */
+struct perf_guest_info_callbacks *perf_guest_cbs;
+
+int perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
+{
+	perf_guest_cbs = cbs;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(perf_register_guest_info_callbacks);
+
+int perf_unregister_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
+{
+	perf_guest_cbs = NULL;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(perf_unregister_guest_info_callbacks);
+
+/*
  * Output
  */
 static bool perf_output_space(struct perf_mmap_data *data, unsigned long tail,
@@ -3740,7 +3761,7 @@ void __perf_event_mmap(struct vm_area_st
 		.event_id  = {
 			.header = {
 				.type = PERF_RECORD_MMAP,
-				.misc = 0,
+				.misc = PERF_RECORD_MISC_USER,
 				/* .size */
 			},
 			/* .pid */
diff -Nraup linux-2.6_tip0317/tools/perf/builtin-diff.c linux-2.6_tip0317_perfkvm/tools/perf/builtin-diff.c
--- linux-2.6_tip0317/tools/perf/builtin-diff.c	2010-03-18 09:04:40.914226433 +0800
+++ linux-2.6_tip0317_perfkvm/tools/perf/builtin-diff.c	2010-03-18 15:06:19.583056523 +0800
@@ -33,7 +33,7 @@ static int perf_session__add_hist_entry(
 		return -ENOMEM;
 
 	if (hit)
-		he->count += count;
+		__perf_session__add_count(he, al, count);
 
 	return 0;
 }
@@ -225,6 +225,9 @@ int cmd_diff(int argc, const char **argv
 			input_new = argv[1];
 		} else
 			input_new = argv[0];
+	} else if (symbol_conf.guest_vmlinux_name || symbol_conf.guest_kallsyms) {
+		input_old = "perf.data.host";
+		input_new = "perf.data.guest";
 	}
 
 	symbol_conf.exclude_other = false;
diff -Nraup linux-2.6_tip0317/tools/perf/builtin.h linux-2.6_tip0317_perfkvm/tools/perf/builtin.h
--- linux-2.6_tip0317/tools/perf/builtin.h	2010-03-18 09:04:40.910227768 +0800
+++ linux-2.6_tip0317_perfkvm/tools/perf/builtin.h	2010-03-18 15:06:19.583056523 +0800
@@ -32,5 +32,6 @@ extern int cmd_version(int argc, const c
 extern int cmd_probe(int argc, const char **argv, const char *prefix);
 extern int cmd_kmem(int argc, const char **argv, const char *prefix);
 extern int cmd_lock(int argc, const char **argv, const char *prefix);
+extern int cmd_kvm(int argc, const char **argv, const char *prefix);
 
 #endif
diff -Nraup linux-2.6_tip0317/tools/perf/builtin-kvm.c linux-2.6_tip0317_perfkvm/tools/perf/builtin-kvm.c
--- linux-2.6_tip0317/tools/perf/builtin-kvm.c	1970-01-01 08:00:00.000000000 +0800
+++ linux-2.6_tip0317_perfkvm/tools/perf/builtin-kvm.c	2010-03-18 15:06:19.583056523 +0800
@@ -0,0 +1,125 @@
+#include "builtin.h"
+#include "perf.h"
+
+#include "util/util.h"
+#include "util/cache.h"
+#include "util/symbol.h"
+#include "util/thread.h"
+#include "util/header.h"
+#include "util/session.h"
+
+#include "util/parse-options.h"
+#include "util/trace-event.h"
+
+#include "util/debug.h"
+
+#include <sys/prctl.h>
+
+#include <semaphore.h>
+#include <pthread.h>
+#include <math.h>
+
+static char			*file_name = NULL;
+static char			name_buffer[256];
+
+int				perf_host = 1;
+int				perf_guest = 0;
+
+static const char * const kvm_usage[] = {
+	"perf kvm [<options>] {top|record|report|diff|stat}",
+	NULL
+};
+
+static const struct option kvm_options[] = {
+	OPT_STRING('i', "input", &file_name, "file",
+		    "Input file name"),
+	OPT_STRING('o', "output", &file_name, "file",
+		    "Output file name"),
+	OPT_BOOLEAN(0, "guest", &perf_guest,
+		    "Collect guest os data"),
+	OPT_BOOLEAN(0, "host", &perf_host,
+		    "Collect guest os data"),
+	OPT_STRING(0, "guestvmlinux", &symbol_conf.guest_vmlinux_name, "file",
+		    "file saving guest os vmlinux"),
+	OPT_STRING(0, "guestkallsyms", &symbol_conf.guest_kallsyms, "file",
+		    "file saving guest os /proc/kallsyms"),
+	OPT_STRING(0, "guestmodules", &symbol_conf.guest_modules, "file",
+		    "file saving guest os /proc/modules"),
+	OPT_END()
+};
+
+static int __cmd_record(int argc, const char **argv)
+{
+	int rec_argc, i = 0, j;
+	const char **rec_argv;
+
+	rec_argc = argc + 2;
+	rec_argv = calloc(rec_argc + 1, sizeof(char *));
+	rec_argv[i++] = strdup("record");
+	rec_argv[i++] = strdup("-o");
+	rec_argv[i++] = strdup(file_name);
+	for (j = 1; j < argc; j++, i++)
+		rec_argv[i] = argv[j];
+
+	BUG_ON(i != rec_argc);
+
+	return cmd_record(i, rec_argv, NULL);
+}
+
+static int __cmd_report(int argc, const char **argv)
+{
+	int rec_argc, i = 0, j;
+	const char **rec_argv;
+
+	rec_argc = argc + 2;
+	rec_argv = calloc(rec_argc + 1, sizeof(char *));
+	rec_argv[i++] = strdup("report");
+	rec_argv[i++] = strdup("-i");
+	rec_argv[i++] = strdup(file_name);
+	for (j = 1; j < argc; j++, i++)
+		rec_argv[i] = argv[j];
+
+	BUG_ON(i != rec_argc);
+
+	return cmd_report(i, rec_argv, NULL);
+}
+
+int cmd_kvm(int argc, const char **argv, const char *prefix __used)
+{
+	perf_host = perf_guest = 0;
+
+	argc = parse_options(argc, argv, kvm_options, kvm_usage,
+			PARSE_OPT_STOP_AT_NON_OPTION);
+	if (!argc)
+		usage_with_options(kvm_usage, kvm_options);
+
+	if (!perf_host)
+		perf_guest = 1;
+
+	if (!file_name) {
+		if (perf_host && !perf_guest)
+			sprintf(name_buffer, "perf.data.host");
+		else if (!perf_host && perf_guest)
+			sprintf(name_buffer, "perf.data.guest");
+		else
+			sprintf(name_buffer, "perf.data.kvm");
+		file_name = name_buffer;
+	}
+
+	if (!strncmp(argv[0], "rec", 3)) {
+		return __cmd_record(argc, argv);
+	} else if (!strncmp(argv[0], "rep", 3)) {
+		return __cmd_report(argc, argv);
+	} else if (!strncmp(argv[0], "diff", 4)) {
+		return cmd_diff(argc, argv, NULL);
+	} else if (!strncmp(argv[0], "top", 3)) {
+		return cmd_top(argc, argv, NULL);
+	} else if (!strncmp(argv[0], "stat", 3)) {
+		return cmd_stat(argc, argv, NULL);
+	} else {
+		usage_with_options(kvm_usage, kvm_options);
+	}
+
+	return 0;
+}
+
diff -Nraup linux-2.6_tip0317/tools/perf/builtin-record.c linux-2.6_tip0317_perfkvm/tools/perf/builtin-record.c
--- linux-2.6_tip0317/tools/perf/builtin-record.c	2010-03-18 09:04:40.942263175 +0800
+++ linux-2.6_tip0317_perfkvm/tools/perf/builtin-record.c	2010-03-18 15:06:19.583056523 +0800
@@ -566,18 +566,58 @@ static int __cmd_record(int argc, const 
 	post_processing_offset = lseek(output, 0, SEEK_CUR);
 
 	err = event__synthesize_kernel_mmap(process_synthesized_event,
-					    session, "_text");
+					    session, "/proc/kallsyms",
+					    "kernel.kallsyms",
+					    session->vmlinux_maps,
+					    "_text", PERF_RECORD_MISC_KERNEL);
 	if (err < 0) {
 		pr_err("Couldn't record kernel reference relocation symbol.\n");
 		return err;
 	}
 
-	err = event__synthesize_modules(process_synthesized_event, session);
+	err = event__synthesize_modules(process_synthesized_event,
+				session,
+				&session->kmaps,
+				PERF_RECORD_MISC_KERNEL);
 	if (err < 0) {
 		pr_err("Couldn't record kernel reference relocation symbol.\n");
 		return err;
 	}
 
+	if (perf_guest) {
+		/*
+		 *As for guest kernel when processing subcommand record&report,
+		 *we arrange module mmap prior to guest kernel mmap and trigger
+		 *a preload dso because guest module symbols are loaded from guest
+		 *kallsyms instead of /lib/modules/XXX/XXX. This method is used to
+		 *avoid symbol missing when the first addr is in module instead of
+		 *in guest kernel
+		 */
+		err = event__synthesize_modules(process_synthesized_event,
+				session,
+				&session->guest_kmaps,
+				PERF_RECORD_MISC_GUEST_KERNEL);
+		if (err < 0) {
+			pr_err("Couldn't record guest kernel reference relocation symbol.\n");
+			return err;
+		}
+
+		/*
+		 * We use _stext for guest kernel because guest kernel's /proc/kallsyms
+		 * have no _text.
+		 */
+		err = event__synthesize_kernel_mmap(process_synthesized_event,
+				session, symbol_conf.guest_kallsyms,
+				"guest.kernel.kallsyms",
+				session->guest_vmlinux_maps,
+				"_stext",
+				PERF_RECORD_MISC_GUEST_KERNEL);
+		if (err < 0) {
+			pr_err("Couldn't record guest kernel reference relocation symbol.\n");
+			return err;
+		}
+	}
+
 	if (!system_wide && profile_cpu == -1)
 		event__synthesize_thread(target_pid, process_synthesized_event,
 					 session);
diff -Nraup linux-2.6_tip0317/tools/perf/builtin-report.c linux-2.6_tip0317_perfkvm/tools/perf/builtin-report.c
--- linux-2.6_tip0317/tools/perf/builtin-report.c	2010-03-18 09:04:40.926228328 +0800
+++ linux-2.6_tip0317_perfkvm/tools/perf/builtin-report.c	2010-03-18 15:06:19.587050319 +0800
@@ -104,7 +104,7 @@ static int perf_session__add_hist_entry(
 		return -ENOMEM;
 
 	if (hit)
-		he->count += data->period;
+		__perf_session__add_count(he, al,  data->period);
 
 	if (symbol_conf.use_callchain) {
 		if (!hit)
@@ -428,6 +428,8 @@ static const struct option options[] = {
 		   "sort by key(s): pid, comm, dso, symbol, parent"),
 	OPT_BOOLEAN('P', "full-paths", &symbol_conf.full_paths,
 		    "Don't shorten the pathnames taking into account the cwd"),
+	OPT_BOOLEAN(0, "showcpuutilization", &symbol_conf.show_cpu_utilization,
+		    "Show sample percentage for different cpu modes"),
 	OPT_STRING('p', "parent", &parent_pattern, "regex",
 		   "regex filter to identify parent, see: '--sort parent'"),
 	OPT_BOOLEAN('x', "exclude-other", &symbol_conf.exclude_other,
diff -Nraup linux-2.6_tip0317/tools/perf/builtin-top.c linux-2.6_tip0317_perfkvm/tools/perf/builtin-top.c
--- linux-2.6_tip0317/tools/perf/builtin-top.c	2010-03-18 09:04:40.926228328 +0800
+++ linux-2.6_tip0317_perfkvm/tools/perf/builtin-top.c	2010-03-18 15:06:19.587050319 +0800
@@ -417,8 +417,9 @@ static double sym_weight(const struct sy
 }
 
 static long			samples;
-static long			userspace_samples;
+static long			kernel_samples, userspace_samples;
 static long			exact_samples;
+static long			guest_us_samples, guest_kernel_samples;
 static const char		CONSOLE_CLEAR[] = "[H[2J";
 
 static void __list_insert_active_sym(struct sym_entry *syme)
@@ -458,7 +459,10 @@ static void print_sym_table(void)
 	int printed = 0, j;
 	int counter, snap = !display_weighted ? sym_counter : 0;
 	float samples_per_sec = samples/delay_secs;
-	float ksamples_per_sec = (samples-userspace_samples)/delay_secs;
+	float ksamples_per_sec = kernel_samples/delay_secs;
+	float userspace_samples_per_sec = (userspace_samples)/delay_secs;
+	float guest_kernel_samples_per_sec = (guest_kernel_samples)/delay_secs;
+	float guest_us_samples_per_sec = (guest_us_samples)/delay_secs;
 	float esamples_percent = (100.0*exact_samples)/samples;
 	float sum_ksamples = 0.0;
 	struct sym_entry *syme, *n;
@@ -467,7 +471,8 @@ static void print_sym_table(void)
 	int sym_width = 0, dso_width = 0, dso_short_width = 0;
 	const int win_width = winsize.ws_col - 1;
 
-	samples = userspace_samples = exact_samples = 0;
+	samples = userspace_samples = kernel_samples = exact_samples = 0;
+	guest_kernel_samples = guest_us_samples = 0;
 
 	/* Sort the active symbols */
 	pthread_mutex_lock(&active_symbols_lock);
@@ -498,10 +503,21 @@ static void print_sym_table(void)
 	puts(CONSOLE_CLEAR);
 
 	printf("%-*.*s\n", win_width, win_width, graph_dotted_line);
-	printf( "   PerfTop:%8.0f irqs/sec  kernel:%4.1f%%  exact: %4.1f%% [",
-		samples_per_sec,
-		100.0 - (100.0*((samples_per_sec-ksamples_per_sec)/samples_per_sec)),
-		esamples_percent);
+	if (!perf_guest) {
+		printf( "   PerfTop:%8.0f irqs/sec  kernel:%4.1f%%  exact: %4.1f%% [",
+			samples_per_sec,
+			100.0 - (100.0*((samples_per_sec-ksamples_per_sec)/samples_per_sec)),
+			esamples_percent);
+	} else {
+		printf( "   PerfTop:%8.0f irqs/sec  kernel:%4.1f%% us:%4.1f%%"
+			" guest kernel:%4.1f%% guest us:%4.1f%% exact: %4.1f%% [",
+			samples_per_sec,
+			100.0 - (100.0*((samples_per_sec-ksamples_per_sec)/samples_per_sec)),
+			100.0 - (100.0*((samples_per_sec-userspace_samples_per_sec)/samples_per_sec)),
+			100.0 - (100.0*((samples_per_sec-guest_kernel_samples_per_sec)/samples_per_sec)),
+			100.0 - (100.0*((samples_per_sec-guest_us_samples_per_sec)/samples_per_sec)),
+			esamples_percent);
+	}
 
 	if (nr_counters == 1 || !display_weighted) {
 		printf("%Ld", (u64)attrs[0].sample_period);
@@ -963,9 +979,20 @@ static void event__process_sample(const 
 			return;
 		break;
 	case PERF_RECORD_MISC_KERNEL:
+		++kernel_samples;
 		if (hide_kernel_symbols)
 			return;
 		break;
+	case PERF_RECORD_MISC_GUEST_KERNEL:
+		++guest_kernel_samples;
+		break;
+	case PERF_RECORD_MISC_GUEST_USER:
+		++guest_us_samples;
+		/*
+		 * TODO: we don't process guest user from host side
+		 * except simple counting 
+		 */
+		return;
 	default:
 		return;
 	}
diff -Nraup linux-2.6_tip0317/tools/perf/Makefile linux-2.6_tip0317_perfkvm/tools/perf/Makefile
--- linux-2.6_tip0317/tools/perf/Makefile	2010-03-18 09:04:40.938289813 +0800
+++ linux-2.6_tip0317_perfkvm/tools/perf/Makefile	2010-03-18 15:06:19.587050319 +0800
@@ -462,6 +462,7 @@ BUILTIN_OBJS += builtin-trace.o
 BUILTIN_OBJS += builtin-probe.o
 BUILTIN_OBJS += builtin-kmem.o
 BUILTIN_OBJS += builtin-lock.o
+BUILTIN_OBJS += builtin-kvm.o
 
 PERFLIBS = $(LIB_FILE)
 
diff -Nraup linux-2.6_tip0317/tools/perf/perf.c linux-2.6_tip0317_perfkvm/tools/perf/perf.c
--- linux-2.6_tip0317/tools/perf/perf.c	2010-03-18 09:04:40.926228328 +0800
+++ linux-2.6_tip0317_perfkvm/tools/perf/perf.c	2010-03-18 15:06:19.587050319 +0800
@@ -308,6 +308,7 @@ static void handle_internal_command(int 
 		{ "probe",	cmd_probe,	0 },
 		{ "kmem",	cmd_kmem,	0 },
 		{ "lock",	cmd_lock,	0 },
+		{ "kvm",	cmd_kvm,	0 },
 	};
 	unsigned int i;
 	static const char ext[] = STRIP_EXTENSION;
diff -Nraup linux-2.6_tip0317/tools/perf/perf.h linux-2.6_tip0317_perfkvm/tools/perf/perf.h
--- linux-2.6_tip0317/tools/perf/perf.h	2010-03-18 09:04:40.942263175 +0800
+++ linux-2.6_tip0317_perfkvm/tools/perf/perf.h	2010-03-18 15:06:19.587050319 +0800
@@ -133,4 +133,6 @@ struct ip_callchain {
 	u64 ips[0];
 };
 
+extern int perf_host, perf_guest;
+
 #endif
diff -Nraup linux-2.6_tip0317/tools/perf/util/event.c linux-2.6_tip0317_perfkvm/tools/perf/util/event.c
--- linux-2.6_tip0317/tools/perf/util/event.c	2010-03-18 09:04:40.934227537 +0800
+++ linux-2.6_tip0317_perfkvm/tools/perf/util/event.c	2010-03-18 15:06:19.587050319 +0800
@@ -112,7 +112,7 @@ static int event__synthesize_mmap_events
 		event_t ev = {
 			.header = {
 				.type = PERF_RECORD_MMAP,
-				.misc = 0, /* Just like the kernel, see kernel/perf_event.c __perf_event_mmap */
+				.misc = PERF_RECORD_MISC_USER, /* Just like the kernel, see kernel/perf_event.c __perf_event_mmap */
 			 },
 		};
 		int n;
@@ -158,11 +158,13 @@ static int event__synthesize_mmap_events
 }
 
 int event__synthesize_modules(event__handler_t process,
-			      struct perf_session *session)
+			      struct perf_session *session,
+			      struct map_groups *kmaps,
+			      unsigned int misc)
 {
 	struct rb_node *nd;
 
-	for (nd = rb_first(&session->kmaps.maps[MAP__FUNCTION]);
+	for (nd = rb_first(&kmaps->maps[MAP__FUNCTION]);
 	     nd; nd = rb_next(nd)) {
 		event_t ev;
 		size_t size;
@@ -173,7 +175,7 @@ int event__synthesize_modules(event__han
 
 		size = ALIGN(pos->dso->long_name_len + 1, sizeof(u64));
 		memset(&ev, 0, sizeof(ev));
-		ev.mmap.header.misc = 1; /* kernel uses 0 for user space maps, see kernel/perf_event.c __perf_event_mmap */
+		ev.mmap.header.misc = misc; /* kernel uses 0 for user space maps, see kernel/perf_event.c __perf_event_mmap */
 		ev.mmap.header.type = PERF_RECORD_MMAP;
 		ev.mmap.header.size = (sizeof(ev.mmap) -
 				        (sizeof(ev.mmap.filename) - size));
@@ -241,13 +243,17 @@ static int find_symbol_cb(void *arg, con
 
 int event__synthesize_kernel_mmap(event__handler_t process,
 				  struct perf_session *session,
-				  const char *symbol_name)
+				  const char *kallsyms_name,
+				  const char *mmap_name,
+				  struct map **maps,
+				  const char *symbol_name,
+				  unsigned int misc)
 {
 	size_t size;
 	event_t ev = {
 		.header = {
 			.type = PERF_RECORD_MMAP,
-			.misc = 1, /* kernel uses 0 for user space maps, see kernel/perf_event.c __perf_event_mmap */
+			.misc = misc, /* kernel uses PERF_RECORD_MISC_USER for user space maps, see kernel/perf_event.c __perf_event_mmap */
 		},
 	};
 	/*
@@ -257,16 +263,16 @@ int event__synthesize_kernel_mmap(event_
 	 */
 	struct process_symbol_args args = { .name = symbol_name, };
 
-	if (kallsyms__parse("/proc/kallsyms", &args, find_symbol_cb) <= 0)
+	if (kallsyms__parse(kallsyms_name, &args, find_symbol_cb) <= 0)
 		return -ENOENT;
 
 	size = snprintf(ev.mmap.filename, sizeof(ev.mmap.filename),
-			"[kernel.kallsyms.%s]", symbol_name) + 1;
+			"[%s.%s]", mmap_name, symbol_name) + 1;
 	size = ALIGN(size, sizeof(u64));
 	ev.mmap.header.size = (sizeof(ev.mmap) - (sizeof(ev.mmap.filename) - size));
 	ev.mmap.pgoff = args.start;
-	ev.mmap.start = session->vmlinux_maps[MAP__FUNCTION]->start;
-	ev.mmap.len   = session->vmlinux_maps[MAP__FUNCTION]->end - ev.mmap.start ;
+	ev.mmap.start = maps[MAP__FUNCTION]->start;
+	ev.mmap.len   = maps[MAP__FUNCTION]->end - ev.mmap.start ;
 
 	return process(&ev, session);
 }
@@ -320,19 +326,25 @@ int event__process_lost(event_t *self, s
 	return 0;
 }
 
-int event__process_mmap(event_t *self, struct perf_session *session)
+static void event_set_kernel_mmap_len(struct map **maps, event_t *self)
 {
-	struct thread *thread;
-	struct map *map;
+	maps[MAP__FUNCTION]->start = self->mmap.start;
+	maps[MAP__FUNCTION]->end   = self->mmap.start + self->mmap.len;
+	/*
+	 * Be a bit paranoid here, some perf.data file came with
+	 * a zero sized synthesized MMAP event for the kernel.
+	 */
+	if (maps[MAP__FUNCTION]->end == 0)
+		maps[MAP__FUNCTION]->end = ~0UL;
+}
 
-	dump_printf(" %d/%d: [%#Lx(%#Lx) @ %#Lx]: %s\n",
-		    self->mmap.pid, self->mmap.tid, self->mmap.start,
-		    self->mmap.len, self->mmap.pgoff, self->mmap.filename);
+static int __event__process_mmap(event_t *self, struct perf_session *session)
+{
+	struct map *map;
+	static const char kmmap_prefix[] = "[kernel.kallsyms.";
 
-	if (self->mmap.pid == 0) {
-		static const char kmmap_prefix[] = "[kernel.kallsyms.";
+	if (self->mmap.filename[0] == '/') {
 
-		if (self->mmap.filename[0] == '/') {
 			char short_module_name[1024];
 			char *name = strrchr(self->mmap.filename, '/'), *dot;
 
@@ -348,9 +360,10 @@ int event__process_mmap(event_t *self, s
 				 "[%.*s]", (int)(dot - name), name);
 			strxfrchar(short_module_name, '-', '_');
 
-			map = perf_session__new_module_map(session,
+			map = map_groups__new_module(&session->kmaps,
 							   self->mmap.start,
-							   self->mmap.filename);
+							   self->mmap.filename,
+							   0);
 			if (map == NULL)
 				goto out_problem;
 
@@ -373,22 +386,94 @@ int event__process_mmap(event_t *self, s
 			if (kernel == NULL)
 				goto out_problem;
 
-			kernel->kernel = 1;
-			if (__perf_session__create_kernel_maps(session, kernel) < 0)
+			kernel->kernel = DSO_TYPE_KERNEL;
+			if (__map_groups__create_kernel_maps(&session->kmaps,
+						session->vmlinux_maps, kernel) < 0)
 				goto out_problem;
 
-			session->vmlinux_maps[MAP__FUNCTION]->start = self->mmap.start;
-			session->vmlinux_maps[MAP__FUNCTION]->end   = self->mmap.start + self->mmap.len;
-			/*
-			 * Be a bit paranoid here, some perf.data file came with
-			 * a zero sized synthesized MMAP event for the kernel.
-			 */
-			if (session->vmlinux_maps[MAP__FUNCTION]->end == 0)
-				session->vmlinux_maps[MAP__FUNCTION]->end = ~0UL;
-
-			perf_session__set_kallsyms_ref_reloc_sym(session, symbol_name,
-								 self->mmap.pgoff);
+			event_set_kernel_mmap_len(session->vmlinux_maps, self);
+			perf_session__set_kallsyms_ref_reloc_sym(session->vmlinux_maps,
+							symbol_name,
+							self->mmap.pgoff);
 		}
+	return 0;
+
+out_problem:
+	return -1;
+}
+
+static int __event__process_guest_mmap(event_t *self, struct perf_session *session)
+{
+	struct map *map;
+
+	static const char kmmap_prefix[] = "[guest.kernel.kallsyms.";
+
+	if (memcmp(self->mmap.filename, kmmap_prefix,
+				sizeof(kmmap_prefix) - 1) == 0) {
+		const char *symbol_name = (self->mmap.filename +
+				sizeof(kmmap_prefix) - 1);
+		/*
+		 * Should be there already, from the build-id table in
+		 * the header.
+		 */
+		struct dso *kernel = __dsos__findnew(&dsos__guest_kernel,
+				"[guest.kernel.kallsyms]");
+		if (kernel == NULL)
+			goto out_problem;
+
+		kernel->kernel = DSO_TYPE_GUEST_KERNEL;
+		if (__map_groups__create_kernel_maps(&session->guest_kmaps,
+				session->guest_vmlinux_maps, kernel) < 0)
+			goto out_problem;
+
+		event_set_kernel_mmap_len(session->guest_vmlinux_maps, self);
+		perf_session__set_kallsyms_ref_reloc_sym(session->guest_vmlinux_maps,
+				symbol_name,
+				self->mmap.pgoff);
+		/*
+		 * preload dso of guest kernel and modules
+		 */
+		dso__load(kernel, session->guest_vmlinux_maps[MAP__FUNCTION], NULL);
+	} else if (self->mmap.filename[0] == '[') {
+		char *name;
+
+		map = map_groups__new_module(&session->guest_kmaps,
+				self->mmap.start,
+				self->mmap.filename,
+				1);
+		if (map == NULL)
+			goto out_problem;
+		name = strdup(self->mmap.filename);
+		if (name == NULL)
+			goto out_problem;
+
+		map->dso->short_name = name;
+		map->end = map->start + self->mmap.len;
+	}
+
+	return 0;
+out_problem:
+	return -1;
+}
+
+int event__process_mmap(event_t *self, struct perf_session *session)
+{
+	struct thread *thread;
+	struct map *map;
+	u8 cpumode = self->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
+	int ret;
+
+	dump_printf(" %d/%d: [%#Lx(%#Lx) @ %#Lx]: %s\n",
+			self->mmap.pid, self->mmap.tid, self->mmap.start,
+			self->mmap.len, self->mmap.pgoff, self->mmap.filename);
+
+	if (self->mmap.pid == 0) {
+		if (cpumode == PERF_RECORD_MISC_GUEST_KERNEL)
+			ret = __event__process_guest_mmap(self, session);
+		else
+			ret = __event__process_mmap(self, session);
+		if (ret < 0)
+			goto out_problem;
 		return 0;
 	}
 
@@ -441,15 +526,33 @@ void thread__find_addr_map(struct thread
 
 	al->thread = self;
 	al->addr = addr;
+	al->cpumode = cpumode;
 
-	if (cpumode == PERF_RECORD_MISC_KERNEL) {
+	if (cpumode == PERF_RECORD_MISC_KERNEL && perf_host) {
 		al->level = 'k';
 		mg = &session->kmaps;
-	} else if (cpumode == PERF_RECORD_MISC_USER)
+	} else if (cpumode == PERF_RECORD_MISC_USER && perf_host) {
 		al->level = '.';
-	else {
-		al->level = 'H';
+	} else if (cpumode == PERF_RECORD_MISC_GUEST_KERNEL && perf_guest) {
+		al->level = 'g';
+		mg = &session->guest_kmaps;
+	} else {
+		/* TODO: We don't support guest user space. Might support late */
+		if (cpumode == PERF_RECORD_MISC_GUEST_USER && perf_guest)
+			al->level = 'u';
+		else
+			al->level = 'H';
 		al->map = NULL;
+
+		if ((cpumode == PERF_RECORD_MISC_GUEST_USER ||
+			cpumode == PERF_RECORD_MISC_GUEST_KERNEL) &&
+			!perf_guest)
+			al->filtered = true;
+		if ((cpumode == PERF_RECORD_MISC_USER ||
+			cpumode == PERF_RECORD_MISC_KERNEL) &&
+			!perf_host)
+			al->filtered = true;
+
 		return;
 	}
 try_again:
@@ -464,10 +567,18 @@ try_again:
 		 * "[vdso]" dso, but for now lets use the old trick of looking
 		 * in the whole kernel symbol list.
 		 */
-		if ((long long)al->addr < 0 && mg != &session->kmaps) {
+		if ((long long)al->addr < 0 &&
+			mg != &session->kmaps &&
+			cpumode == PERF_RECORD_MISC_KERNEL) {
 			mg = &session->kmaps;
 			goto try_again;
 		}
+		if ((long long)al->addr < 0 &&
+				mg != &session->guest_kmaps &&
+				cpumode == PERF_RECORD_MISC_GUEST_KERNEL) {
+			mg = &session->guest_kmaps;
+			goto try_again;
+		}
 	} else
 		al->addr = al->map->map_ip(al->map, al->addr);
 }
@@ -513,6 +624,7 @@ int event__preprocess_sample(const event
 
 	dump_printf(" ... thread: %s:%d\n", thread->comm, thread->pid);
 
+	al->filtered = false;
 	thread__find_addr_location(thread, session, cpumode, MAP__FUNCTION,
 				   self->ip.ip, al, filter);
 	dump_printf(" ...... dso: %s\n",
@@ -536,7 +648,6 @@ int event__preprocess_sample(const event
 	    !strlist__has_entry(symbol_conf.sym_list, al->sym->name))
 		goto out_filtered;
 
-	al->filtered = false;
 	return 0;
 
 out_filtered:
diff -Nraup linux-2.6_tip0317/tools/perf/util/event.h linux-2.6_tip0317_perfkvm/tools/perf/util/event.h
--- linux-2.6_tip0317/tools/perf/util/event.h	2010-03-18 09:04:40.934227537 +0800
+++ linux-2.6_tip0317_perfkvm/tools/perf/util/event.h	2010-03-18 15:06:19.587050319 +0800
@@ -119,10 +119,17 @@ int event__synthesize_thread(pid_t pid, 
 void event__synthesize_threads(event__handler_t process,
 			       struct perf_session *session);
 int event__synthesize_kernel_mmap(event__handler_t process,
-				  struct perf_session *session,
-				  const char *symbol_name);
+				struct perf_session *session,
+				const char *kallsyms_name,
+				const char *mmap_name,
+				struct map **maps,
+				const char *symbol_name,
+				unsigned int misc);
+
 int event__synthesize_modules(event__handler_t process,
-			      struct perf_session *session);
+			      struct perf_session *session,
+			      struct map_groups *kmaps,
+			      unsigned int misc);
 
 int event__process_comm(event_t *self, struct perf_session *session);
 int event__process_lost(event_t *self, struct perf_session *session);
diff -Nraup linux-2.6_tip0317/tools/perf/util/hist.c linux-2.6_tip0317_perfkvm/tools/perf/util/hist.c
--- linux-2.6_tip0317/tools/perf/util/hist.c	2010-03-18 09:04:40.938289813 +0800
+++ linux-2.6_tip0317_perfkvm/tools/perf/util/hist.c	2010-03-18 15:06:19.587050319 +0800
@@ -8,6 +8,30 @@ struct callchain_param	callchain_param =
 	.min_percent = 0.5
 };
 
+void __perf_session__add_count(struct hist_entry *he,
+			struct addr_location *al,
+			u64 count)
+{
+	he->count += count;
+
+	switch (al->cpumode) {
+	case PERF_RECORD_MISC_KERNEL:
+		he->count_sys += count;
+		break;
+	case PERF_RECORD_MISC_USER:
+		he->count_us += count;
+		break;
+	case PERF_RECORD_MISC_GUEST_KERNEL:
+		he->count_guest_sys += count;
+		break;
+	case PERF_RECORD_MISC_GUEST_USER:
+		he->count_guest_us += count;
+		break;
+	default:
+		break;
+	}
+}
+
 /*
  * histogram, sorted on item, collects counts
  */
@@ -26,7 +50,6 @@ struct hist_entry *__perf_session__add_h
 		.sym	= al->sym,
 		.ip	= al->addr,
 		.level	= al->level,
-		.count	= count,
 		.parent = sym_parent,
 	};
 	int cmp;
@@ -48,6 +71,8 @@ struct hist_entry *__perf_session__add_h
 			p = &(*p)->rb_right;
 	}
 
+	__perf_session__add_count(&entry, al, count);
+
 	he = malloc(sizeof(*he));
 	if (!he)
 		return NULL;
@@ -462,7 +487,7 @@ size_t hist_entry__fprintf(struct hist_e
 			   u64 session_total)
 {
 	struct sort_entry *se;
-	u64 count, total;
+	u64 count, total, count_sys, count_us, count_guest_sys, count_guest_us;
 	const char *sep = symbol_conf.field_sep;
 	size_t ret;
 
@@ -472,15 +497,35 @@ size_t hist_entry__fprintf(struct hist_e
 	if (pair_session) {
 		count = self->pair ? self->pair->count : 0;
 		total = pair_session->events_stats.total;
+		count_sys = self->pair ? self->pair->count_sys : 0;
+		count_us = self->pair ? self->pair->count_us : 0;
+		count_guest_sys = self->pair ? self->pair->count_guest_sys : 0;
+		count_guest_us = self->pair ? self->pair->count_guest_us : 0;
 	} else {
 		count = self->count;
 		total = session_total;
+		count_sys = self->count_sys;
+		count_us = self->count_us;
+		count_guest_sys = self->count_guest_sys;
+		count_guest_us = self->count_guest_us;
 	}
 
-	if (total)
+	if (total) {
 		ret = percent_color_fprintf(fp, sep ? "%.2f" : "   %6.2f%%",
 					    (count * 100.0) / total);
-	else
+		if (symbol_conf.show_cpu_utilization) {
+			ret += percent_color_fprintf(fp, sep ? "%.2f" : "   %6.2f%%",
+					(count_sys * 100.0) / total);
+			ret += percent_color_fprintf(fp, sep ? "%.2f" : "   %6.2f%%",
+					(count_us * 100.0) / total);
+			if (perf_guest) {
+				ret += percent_color_fprintf(fp, sep ? "%.2f" : "   %6.2f%%",
+						(count_guest_sys * 100.0) / total);
+				ret += percent_color_fprintf(fp, sep ? "%.2f" : "   %6.2f%%",
+						(count_guest_us * 100.0) / total);
+			}
+		}
+	} else
 		ret = fprintf(fp, sep ? "%lld" : "%12lld ", count);
 
 	if (symbol_conf.show_nr_samples) {
@@ -576,6 +621,20 @@ size_t perf_session__fprintf_hists(struc
 			fputs("  Samples  ", fp);
 	}
 
+	if (symbol_conf.show_cpu_utilization) {
+		if (sep) {
+			ret += fprintf(fp, "%csys", *sep);
+			ret += fprintf(fp, "%cus", *sep);
+			ret += fprintf(fp, "%cguest sys", *sep);
+			ret += fprintf(fp, "%cguest us", *sep);
+		} else {
+			ret += fprintf(fp, "  sys  ");
+			ret += fprintf(fp, "  us  ");
+			ret += fprintf(fp, "  guest sys  ");
+			ret += fprintf(fp, "  guest us  ");
+		}
+	}
+
 	if (pair) {
 		if (sep)
 			ret += fprintf(fp, "%cDelta", *sep);
diff -Nraup linux-2.6_tip0317/tools/perf/util/hist.h linux-2.6_tip0317_perfkvm/tools/perf/util/hist.h
--- linux-2.6_tip0317/tools/perf/util/hist.h	2010-03-18 09:04:40.938289813 +0800
+++ linux-2.6_tip0317_perfkvm/tools/perf/util/hist.h	2010-03-18 15:06:19.591054262 +0800
@@ -12,6 +12,9 @@ struct addr_location;
 struct symbol;
 struct rb_root;
 
+void __perf_session__add_count(struct hist_entry *he,
+			struct addr_location *al,
+			u64 count);
 struct hist_entry *__perf_session__add_hist_entry(struct rb_root *hists,
 						  struct addr_location *al,
 						  struct symbol *parent,
diff -Nraup linux-2.6_tip0317/tools/perf/util/session.c linux-2.6_tip0317_perfkvm/tools/perf/util/session.c
--- linux-2.6_tip0317/tools/perf/util/session.c	2010-03-18 09:04:40.938289813 +0800
+++ linux-2.6_tip0317_perfkvm/tools/perf/util/session.c	2010-03-18 15:06:19.591054262 +0800
@@ -54,7 +54,12 @@ out_close:
 
 static inline int perf_session__create_kernel_maps(struct perf_session *self)
 {
-	return map_groups__create_kernel_maps(&self->kmaps, self->vmlinux_maps);
+	int ret;
+	ret = map_groups__create_kernel_maps(&self->kmaps, self->vmlinux_maps);
+	if (ret >= 0)
+		ret = map_groups__create_guest_kernel_maps(&self->guest_kmaps,
+				self->guest_vmlinux_maps);
+	return ret;
 }
 
 struct perf_session *perf_session__new(const char *filename, int mode, bool force)
@@ -77,6 +82,7 @@ struct perf_session *perf_session__new(c
 	self->cwdlen = 0;
 	self->unknown_events = 0;
 	map_groups__init(&self->kmaps);
+	map_groups__init(&self->guest_kmaps);
 
 	if (mode == O_RDONLY) {
 		if (perf_session__open(self, force) < 0)
@@ -356,7 +362,8 @@ int perf_header__read_build_ids(struct p
 		if (read(input, filename, len) != len)
 			goto out;
 
-		if (bev.header.misc & PERF_RECORD_MISC_KERNEL)
+		if ((bev.header.misc & PERF_RECORD_MISC_CPUMODE_MASK)
+			==  PERF_RECORD_MISC_KERNEL)
 			head = &dsos__kernel;
 
 		dso = __dsos__findnew(head, filename);
@@ -519,26 +526,33 @@ bool perf_session__has_traces(struct per
 	return true;
 }
 
-int perf_session__set_kallsyms_ref_reloc_sym(struct perf_session *self,
+int perf_session__set_kallsyms_ref_reloc_sym(struct map ** maps,
 					     const char *symbol_name,
 					     u64 addr)
 {
 	char *bracket;
 	enum map_type i;
+	struct ref_reloc_sym *ref;
 
-	self->ref_reloc_sym.name = strdup(symbol_name);
-	if (self->ref_reloc_sym.name == NULL)
+	ref = zalloc(sizeof(struct ref_reloc_sym));
+	if (ref == NULL)
 		return -ENOMEM;
 
-	bracket = strchr(self->ref_reloc_sym.name, ']');
+	ref->name = strdup(symbol_name);
+	if (ref->name == NULL) {
+		free(ref);
+		return -ENOMEM;
+	}
+
+	bracket = strchr(ref->name, ']');
 	if (bracket)
 		*bracket = '\0';
 
-	self->ref_reloc_sym.addr = addr;
+	ref->addr = addr;
 
 	for (i = 0; i < MAP__NR_TYPES; ++i) {
-		struct kmap *kmap = map__kmap(self->vmlinux_maps[i]);
-		kmap->ref_reloc_sym = &self->ref_reloc_sym;
+		struct kmap *kmap = map__kmap(maps[i]);
+		kmap->ref_reloc_sym = ref;
 	}
 
 	return 0;
diff -Nraup linux-2.6_tip0317/tools/perf/util/session.h linux-2.6_tip0317_perfkvm/tools/perf/util/session.h
--- linux-2.6_tip0317/tools/perf/util/session.h	2010-03-18 09:04:40.926228328 +0800
+++ linux-2.6_tip0317_perfkvm/tools/perf/util/session.h	2010-03-18 15:06:19.591054262 +0800
@@ -16,16 +16,17 @@ struct perf_session {
 	unsigned long		size;
 	unsigned long		mmap_window;
 	struct map_groups	kmaps;
+	struct map_groups	guest_kmaps;
 	struct rb_root		threads;
 	struct thread		*last_match;
 	struct map		*vmlinux_maps[MAP__NR_TYPES];
+	struct map		*guest_vmlinux_maps[MAP__NR_TYPES];
 	struct events_stats	events_stats;
 	struct rb_root		stats_by_id;
 	unsigned long		event_total[PERF_RECORD_MAX];
 	unsigned long		unknown_events;
 	struct rb_root		hists;
 	u64			sample_type;
-	struct ref_reloc_sym	ref_reloc_sym;
 	int			fd;
 	int			cwdlen;
 	char			*cwd;
@@ -67,26 +68,12 @@ bool perf_session__has_traces(struct per
 int perf_header__read_build_ids(struct perf_header *self, int input,
 				u64 offset, u64 file_size);
 
-int perf_session__set_kallsyms_ref_reloc_sym(struct perf_session *self,
+int perf_session__set_kallsyms_ref_reloc_sym(struct map ** maps,
 					     const char *symbol_name,
 					     u64 addr);
 
 void mem_bswap_64(void *src, int byte_size);
 
-static inline int __perf_session__create_kernel_maps(struct perf_session *self,
-						struct dso *kernel)
-{
-	return __map_groups__create_kernel_maps(&self->kmaps,
-						self->vmlinux_maps, kernel);
-}
-
-static inline struct map *
-	perf_session__new_module_map(struct perf_session *self,
-				     u64 start, const char *filename)
-{
-	return map_groups__new_module(&self->kmaps, start, filename);
-}
-
 #ifdef NO_NEWT_SUPPORT
 static inline void perf_session__browse_hists(struct rb_root *hists __used,
 					      u64 session_total __used,
diff -Nraup linux-2.6_tip0317/tools/perf/util/sort.h linux-2.6_tip0317_perfkvm/tools/perf/util/sort.h
--- linux-2.6_tip0317/tools/perf/util/sort.h	2010-03-18 09:04:40.930227237 +0800
+++ linux-2.6_tip0317_perfkvm/tools/perf/util/sort.h	2010-03-18 15:06:19.591054262 +0800
@@ -44,6 +44,10 @@ extern enum sort_type sort__first_dimens
 struct hist_entry {
 	struct rb_node		rb_node;
 	u64			count;
+	u64			count_sys;
+	u64			count_us;
+	u64			count_guest_sys;
+	u64			count_guest_us;
 	struct thread		*thread;
 	struct map		*map;
 	struct symbol		*sym;
diff -Nraup linux-2.6_tip0317/tools/perf/util/symbol.c linux-2.6_tip0317_perfkvm/tools/perf/util/symbol.c
--- linux-2.6_tip0317/tools/perf/util/symbol.c	2010-03-18 09:04:40.930227237 +0800
+++ linux-2.6_tip0317_perfkvm/tools/perf/util/symbol.c	2010-03-18 15:09:59.498404450 +0800
@@ -22,6 +22,8 @@ static void dsos__add(struct list_head *
 static struct map *map__new2(u64 start, struct dso *dso, enum map_type type);
 static int dso__load_kernel_sym(struct dso *self, struct map *map,
 				symbol_filter_t filter);
+static int dso__load_guest_kernel_sym(struct dso *self, struct map *map,
+			symbol_filter_t filter);
 static int vmlinux_path__nr_entries;
 static char **vmlinux_path;
 
@@ -180,6 +182,7 @@ struct dso *dso__new(const char *name)
 		self->loaded = 0;
 		self->sorted_by_name = 0;
 		self->has_build_id = 0;
+		self->kernel = DSO_TYPE_USER;
 	}
 
 	return self;
@@ -396,12 +399,9 @@ int kallsyms__parse(const char *filename
 		char *symbol_name;
 
 		line_len = getline(&line, &n, file);
-		if (line_len < 0)
+		if (line_len < 0 || !line)
 			break;
 
-		if (!line)
-			goto out_failure;
-
 		line[--line_len] = '\0'; /* \n */
 
 		len = hex2u64(line, &start);
@@ -453,6 +453,7 @@ static int map__process_kallsym_symbol(v
 	 * map__split_kallsyms, when we have split the maps per module
 	 */
 	symbols__insert(root, sym);
+
 	return 0;
 }
 
@@ -498,6 +499,15 @@ static int dso__split_kallsyms(struct ds
 			*module++ = '\0';
 
 			if (strcmp(curr_map->dso->short_name, module)) {
+				if (curr_map != map &&
+					self->kernel == DSO_TYPE_GUEST_KERNEL) {
+					/*
+					 * We assume all symbols of a module are continuous in
+					 * kallsyms, so curr_map points to a module and all its
+					 * symbols are in its kmap. Mark it as loaded.
+					 */
+					dso__set_loaded(curr_map->dso, curr_map->type);
+				}
 				curr_map = map_groups__find_by_name(kmaps, map->type, module);
 				if (curr_map == NULL) {
 					pr_debug("/proc/{kallsyms,modules} "
@@ -519,13 +529,19 @@ static int dso__split_kallsyms(struct ds
 			char dso_name[PATH_MAX];
 			struct dso *dso;
 
-			snprintf(dso_name, sizeof(dso_name), "[kernel].%d",
-				 kernel_range++);
+			if (self->kernel == DSO_TYPE_GUEST_KERNEL)
+				snprintf(dso_name, sizeof(dso_name), "[guest.kernel].%d",
+						kernel_range++);
+			else
+				snprintf(dso_name, sizeof(dso_name), "[kernel].%d",
+						kernel_range++);
 
 			dso = dso__new(dso_name);
 			if (dso == NULL)
 				return -1;
 
+			dso->kernel = self->kernel;
+
 			curr_map = map__new2(pos->start, dso, map->type);
 			if (curr_map == NULL) {
 				dso__delete(dso);
@@ -549,6 +565,10 @@ discard_symbol:		rb_erase(&pos->rb_node,
 		}
 	}
 
+	if (curr_map != map &&
+		self->kernel == DSO_TYPE_GUEST_KERNEL)
+		dso__set_loaded(curr_map->dso, curr_map->type);
+
 	return count;
 }
 
@@ -559,7 +579,10 @@ int dso__load_kallsyms(struct dso *self,
 		return -1;
 
 	symbols__fixup_end(&self->symbols[map->type]);
-	self->origin = DSO__ORIG_KERNEL;
+	if (self->kernel == DSO_TYPE_GUEST_KERNEL)
+		self->origin = DSO__ORIG_GUEST_KERNEL;
+	else
+		self->origin = DSO__ORIG_KERNEL;
 
 	return dso__split_kallsyms(self, map, filter);
 }
@@ -946,7 +969,7 @@ static int dso__load_sym(struct dso *sel
 	nr_syms = shdr.sh_size / shdr.sh_entsize;
 
 	memset(&sym, 0, sizeof(sym));
-	if (!self->kernel) {
+	if (self->kernel == DSO_TYPE_USER) {
 		self->adjust_symbols = (ehdr.e_type == ET_EXEC ||
 				elf_section_by_name(elf, &ehdr, &shdr,
 						     ".gnu.prelink_undo",
@@ -978,7 +1001,7 @@ static int dso__load_sym(struct dso *sel
 
 		section_name = elf_sec__name(&shdr, secstrs);
 
-		if (self->kernel || kmodule) {
+		if (self->kernel != DSO_TYPE_USER || kmodule) {
 			char dso_name[PATH_MAX];
 
 			if (strcmp(section_name,
@@ -1005,6 +1028,7 @@ static int dso__load_sym(struct dso *sel
 				curr_dso = dso__new(dso_name);
 				if (curr_dso == NULL)
 					goto out_elf_end;
+				curr_dso->kernel = self->kernel;
 				curr_map = map__new2(start, curr_dso,
 						     map->type);
 				if (curr_map == NULL) {
@@ -1015,7 +1039,10 @@ static int dso__load_sym(struct dso *sel
 				curr_map->unmap_ip = identity__map_ip;
 				curr_dso->origin = self->origin;
 				map_groups__insert(kmap->kmaps, curr_map);
-				dsos__add(&dsos__kernel, curr_dso);
+				if (curr_dso->kernel == DSO_TYPE_GUEST_KERNEL)
+					dsos__add(&dsos__guest_kernel, curr_dso);
+				else
+					dsos__add(&dsos__kernel, curr_dso);
 				dso__set_loaded(curr_dso, map->type);
 			} else
 				curr_dso = curr_map->dso;
@@ -1236,6 +1263,8 @@ char dso__symtab_origin(const struct dso
 		[DSO__ORIG_BUILDID] =  'b',
 		[DSO__ORIG_DSO] =      'd',
 		[DSO__ORIG_KMODULE] =  'K',
+		[DSO__ORIG_GUEST_KERNEL] =  'g',
+		[DSO__ORIG_GUEST_KMODULE] =  'G',
 	};
 
 	if (self == NULL || self->origin == DSO__ORIG_NOT_FOUND)
@@ -1254,8 +1283,10 @@ int dso__load(struct dso *self, struct m
 
 	dso__set_loaded(self, map->type);
 
-	if (self->kernel)
+	if (self->kernel == DSO_TYPE_KERNEL)
 		return dso__load_kernel_sym(self, map, filter);
+	else if (self->kernel == DSO_TYPE_GUEST_KERNEL)
+		return dso__load_guest_kernel_sym(self, map, filter);
 
 	name = malloc(size);
 	if (!name)
@@ -1459,7 +1490,7 @@ static int map_groups__set_modules_path(
 static struct map *map__new2(u64 start, struct dso *dso, enum map_type type)
 {
 	struct map *self = zalloc(sizeof(*self) +
-				  (dso->kernel ? sizeof(struct kmap) : 0));
+			  (dso->kernel != DSO_TYPE_USER ? sizeof(struct kmap) : 0));
 	if (self != NULL) {
 		/*
 		 * ->end will be filled after we load all the symbols
@@ -1471,11 +1502,15 @@ static struct map *map__new2(u64 start, 
 }
 
 struct map *map_groups__new_module(struct map_groups *self, u64 start,
-				   const char *filename)
+				   const char *filename, int guest)
 {
 	struct map *map;
-	struct dso *dso = __dsos__findnew(&dsos__kernel, filename);
+	struct dso *dso;
 
+	if (!guest)
+		dso = __dsos__findnew(&dsos__kernel, filename);
+	else
+		dso = __dsos__findnew(&dsos__guest_kernel, filename);
 	if (dso == NULL)
 		return NULL;
 
@@ -1483,16 +1518,20 @@ struct map *map_groups__new_module(struc
 	if (map == NULL)
 		return NULL;
 
-	dso->origin = DSO__ORIG_KMODULE;
+	if (guest)
+		dso->origin = DSO__ORIG_GUEST_KMODULE;
+	else
+		dso->origin = DSO__ORIG_KMODULE;
 	map_groups__insert(self, map);
 	return map;
 }
 
-static int map_groups__create_modules(struct map_groups *self)
+static int __map_groups__create_modules(struct map_groups *self,
+			const char * filename, int guest)
 {
 	char *line = NULL;
 	size_t n;
-	FILE *file = fopen("/proc/modules", "r");
+	FILE *file = fopen(filename, "r");
 	struct map *map;
 
 	if (file == NULL)
@@ -1526,16 +1565,17 @@ static int map_groups__create_modules(st
 		*sep = '\0';
 
 		snprintf(name, sizeof(name), "[%s]", line);
-		map = map_groups__new_module(self, start, name);
+		map = map_groups__new_module(self, start, name, guest);
 		if (map == NULL)
 			goto out_delete_line;
-		dso__kernel_module_get_build_id(map->dso);
+		if (!guest)
+			dso__kernel_module_get_build_id(map->dso);
 	}
 
 	free(line);
 	fclose(file);
 
-	return map_groups__set_modules_path(self);
+	return 0;
 
 out_delete_line:
 	free(line);
@@ -1543,6 +1583,21 @@ out_failure:
 	return -1;
 }
 
+static int map_groups__create_modules(struct map_groups *self)
+{
+	int ret;
+
+	ret = __map_groups__create_modules(self, "/proc/modules", 0);
+	if (ret >= 0)
+		ret = map_groups__set_modules_path(self);
+	return ret;
+}
+
+static int map_groups__create_guest_modules(struct map_groups *self)
+{
+	return  __map_groups__create_modules(self, symbol_conf.guest_modules, 1);
+}
+
 static int dso__load_vmlinux(struct dso *self, struct map *map,
 			     const char *vmlinux, symbol_filter_t filter)
 {
@@ -1702,8 +1757,45 @@ out_fixup:
 	return err;
 }
 
+static int dso__load_guest_kernel_sym(struct dso *self, struct map *map,
+				symbol_filter_t filter)
+{
+	int err;
+	const char *kallsyms_filename = NULL;
+
+	/*
+	 * if the user specified a vmlinux filename, use it and only
+	 * it, reporting errors to the user if it cannot be used.
+	 * Or use file guest_kallsyms inputted by user on commandline
+	 */
+	if (symbol_conf.guest_vmlinux_name != NULL) {
+		err = dso__load_vmlinux(self, map,
+					symbol_conf.guest_vmlinux_name, filter);
+		goto out_try_fixup;
+	}
+
+	kallsyms_filename = symbol_conf.guest_kallsyms;
+	if (!kallsyms_filename)
+		return -1;
+	err = dso__load_kallsyms(self, kallsyms_filename, map, filter);
+	if (err > 0)
+		pr_debug("Using %s for symbols\n", kallsyms_filename);
+
+out_try_fixup:
+	if (err > 0) {
+		if (kallsyms_filename != NULL)
+			dso__set_long_name(self, strdup("[guest.kernel.kallsyms]"));
+		map__fixup_start(map);
+		map__fixup_end(map);
+	}
+
+	return err;
+}
+
 LIST_HEAD(dsos__user);
 LIST_HEAD(dsos__kernel);
+LIST_HEAD(dsos__guest_user);
+LIST_HEAD(dsos__guest_kernel);
 
 static void dsos__add(struct list_head *head, struct dso *dso)
 {
@@ -1750,6 +1842,8 @@ void dsos__fprintf(FILE *fp)
 {
 	__dsos__fprintf(&dsos__kernel, fp);
 	__dsos__fprintf(&dsos__user, fp);
+	__dsos__fprintf(&dsos__guest_kernel, fp);
+	__dsos__fprintf(&dsos__guest_user, fp);
 }
 
 static size_t __dsos__fprintf_buildid(struct list_head *head, FILE *fp,
@@ -1779,7 +1873,19 @@ struct dso *dso__new_kernel(const char *
 
 	if (self != NULL) {
 		dso__set_short_name(self, "[kernel]");
-		self->kernel	 = 1;
+		self->kernel	 = DSO_TYPE_KERNEL;
+	}
+
+	return self;
+}
+
+struct dso *dso__new_guest_kernel(const char *name)
+{
+	struct dso *self = dso__new(name ?: "[guest.kernel.kallsyms]");
+
+	if (self != NULL) {
+		dso__set_short_name(self, "[guest.kernel]");
+		self->kernel     = DSO_TYPE_GUEST_KERNEL;
 	}
 
 	return self;
@@ -1804,6 +1910,15 @@ static struct dso *dsos__create_kernel(c
 	return kernel;
 }
 
+static struct dso *dsos__create_guest_kernel(const char *vmlinux)
+{
+	struct dso *kernel = dso__new_guest_kernel(vmlinux);
+
+	if (kernel != NULL)
+		dsos__add(&dsos__guest_kernel, kernel);
+	return kernel;
+}
+
 int __map_groups__create_kernel_maps(struct map_groups *self,
 				     struct map *vmlinux_maps[MAP__NR_TYPES],
 				     struct dso *kernel)
@@ -1963,3 +2078,24 @@ int map_groups__create_kernel_maps(struc
 	map_groups__fixup_end(self);
 	return 0;
 }
+
+int map_groups__create_guest_kernel_maps(struct map_groups *self,
+				   struct map *vmlinux_maps[MAP__NR_TYPES])
+{
+	struct dso *kernel = dsos__create_guest_kernel(symbol_conf.guest_vmlinux_name);
+
+	if (kernel == NULL)
+		return -1;
+
+	if (__map_groups__create_kernel_maps(self, vmlinux_maps, kernel) < 0)
+		return -1;
+
+	if (symbol_conf.use_modules && map_groups__create_guest_modules(self) < 0)
+		pr_debug("Problems creating module maps, continuing anyway...\n");
+	/*
+	 * Now that we have all the maps created, just set the ->end of them:
+	 */
+	map_groups__fixup_end(self);
+	return 0;
+}
+
diff -Nraup linux-2.6_tip0317/tools/perf/util/symbol.h linux-2.6_tip0317_perfkvm/tools/perf/util/symbol.h
--- linux-2.6_tip0317/tools/perf/util/symbol.h	2010-03-18 09:04:40.938289813 +0800
+++ linux-2.6_tip0317_perfkvm/tools/perf/util/symbol.h	2010-03-18 15:06:19.591054262 +0800
@@ -63,10 +63,14 @@ struct symbol_conf {
 			show_nr_samples,
 			use_callchain,
 			exclude_other,
-			full_paths;
+			full_paths,
+			show_cpu_utilization;
 	const char	*vmlinux_name,
 			*field_sep;
-	char            *dso_list_str,
+	const char	*guest_vmlinux_name,
+			*guest_kallsyms,
+			*guest_modules;
+	char		*dso_list_str,
 			*comm_list_str,
 			*sym_list_str,
 			*col_width_list_str;
@@ -95,6 +99,13 @@ struct addr_location {
 	u64	      addr;
 	char	      level;
 	bool	      filtered;
+	unsigned int  cpumode;
+};
+
+enum dso_kernel_type {
+	DSO_TYPE_USER = 0,
+	DSO_TYPE_KERNEL,
+	DSO_TYPE_GUEST_KERNEL
 };
 
 struct dso {
@@ -104,7 +115,7 @@ struct dso {
 	u8		 adjust_symbols:1;
 	u8		 slen_calculated:1;
 	u8		 has_build_id:1;
-	u8		 kernel:1;
+	enum dso_kernel_type	kernel;
 	u8		 hit:1;
 	u8		 annotate_warned:1;
 	unsigned char	 origin;
@@ -120,6 +131,7 @@ struct dso {
 
 struct dso *dso__new(const char *name);
 struct dso *dso__new_kernel(const char *name);
+struct dso *dso__new_guest_kernel(const char *name);
 void dso__delete(struct dso *self);
 
 bool dso__loaded(const struct dso *self, enum map_type type);
@@ -132,7 +144,7 @@ static inline void dso__set_loaded(struc
 
 void dso__sort_by_name(struct dso *self, enum map_type type);
 
-extern struct list_head dsos__user, dsos__kernel;
+extern struct list_head dsos__user, dsos__kernel, dsos__guest_user, dsos__guest_kernel;
 
 struct dso *__dsos__findnew(struct list_head *head, const char *name);
 
@@ -161,6 +173,8 @@ enum dso_origin {
 	DSO__ORIG_BUILDID,
 	DSO__ORIG_DSO,
 	DSO__ORIG_KMODULE,
+	DSO__ORIG_GUEST_KERNEL,
+	DSO__ORIG_GUEST_KMODULE,
 	DSO__ORIG_NOT_FOUND,
 };
 
diff -Nraup linux-2.6_tip0317/tools/perf/util/thread.h linux-2.6_tip0317_perfkvm/tools/perf/util/thread.h
--- linux-2.6_tip0317/tools/perf/util/thread.h	2010-03-18 09:04:40.926228328 +0800
+++ linux-2.6_tip0317_perfkvm/tools/perf/util/thread.h	2010-03-18 15:06:19.591054262 +0800
@@ -82,6 +82,9 @@ int __map_groups__create_kernel_maps(str
 int map_groups__create_kernel_maps(struct map_groups *self,
 				   struct map *vmlinux_maps[MAP__NR_TYPES]);
 
+int map_groups__create_guest_kernel_maps(struct map_groups *self,
+				   struct map *vmlinux_maps[MAP__NR_TYPES]);
+
 struct map *map_groups__new_module(struct map_groups *self, u64 start,
-				   const char *filename);
+				   const char *filename, int guest);
 #endif	/* __PERF_THREAD_H */


