Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679Ab0KBSQN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 14:16:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:61535 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754645Ab0KBSQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 14:16:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,283,1286175600"; 
   d="scan'208,223";a="569683615"
Subject: Re: [PATCH -v3 3/6] x86, NMI, Rewrite NMI handler
From: Huang Ying <ying.huang@intel.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
In-Reply-To: <20101102174957.GA21468@redhat.com>
References: <1286864080.7768.179.camel@yhuang-dev>
	 <1286865071.2336.1478.camel@twins> <1286865447.7768.184.camel@yhuang-dev>
	 <1286865629.2336.1490.camel@twins> <1286865923.7768.188.camel@yhuang-dev>
	 <1286866193.2336.1503.camel@twins> <20101012135112.GE20436@basil.fritz.box>
	 <1286892927.29097.42.camel@twins> <20101027164522.GA25738@redhat.com>
	 <1288199324.3673.14.camel@laptop>  <20101102174957.GA21468@redhat.com>
Content-Type: multipart/mixed; boundary="=-PRpPBi3cUmNxk8/MyeY8"
Date: Wed, 03 Nov 2010 02:16:03 +0800
Message-ID: <1288721764.3067.6.camel@yhuang-mobile>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-PRpPBi3cUmNxk8/MyeY8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hi, Don,

On Tue, 2010-11-02 at 10:50 -0700, Don Zickus wrote:
> On Wed, Oct 27, 2010 at 07:08:44PM +0200, Peter Zijlstra wrote:
> > On Wed, 2010-10-27 at 12:45 -0400, Don Zickus wrote:
> > > I assume this is sorta of what Peter was looking for.
> > 
> > Yeah close, except the prio field of the various notification blocks
> > need to get adjusted to preserve semantics.
> 
> Here is my next crack at it.  I added some global defines to make it more
> clear what the priorities are.
> 
> Again the intent was to roll something like this patch into Huang's
> original patch.  This would help simplify the notifier chain and add
> priorities to maintain the original relationships.
> 
> Cheers,
> Don
> 
> 
> diff --git a/arch/x86/include/asm/kdebug.h b/arch/x86/include/asm/kdebug.h
> index 5bdfca8..e28ec43 100644
> --- a/arch/x86/include/asm/kdebug.h
> +++ b/arch/x86/include/asm/kdebug.h
> @@ -18,7 +18,6 @@ enum die_val {
>  	DIE_TRAP,
>  	DIE_GPF,
>  	DIE_CALL,
> -	DIE_NMI_IPI,
>  	DIE_PAGE_FAULT,
>  	DIE_NMIUNKNOWN,
>  };
> diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
> index 932f0f8..cfb6156 100644
> --- a/arch/x86/include/asm/nmi.h
> +++ b/arch/x86/include/asm/nmi.h
> @@ -68,6 +68,26 @@ static inline int nmi_watchdog_active(void)
>  }
>  #endif
>  
> +/*
> + * Define some priorities for the nmi notifier call chain.
> + *
> + * Create a local nmi bit that has a higher priority than
> + * external nmis, because the local ones are more frequent.
> + * 
> + * Also setup some default high/normal/low settings for
> + * subsystems to registers with.  Using 4 bits to seperate
> + * the priorities.  This can go alot higher if needed be.
> + */
> +
> +#define NMI_LOCAL_SHIFT		16	/* randomly picked */
> +#define NMI_LOCAL_BIT		(1ULL << NMI_LOCAL_SHIFT)
> +#define NMI_HIGH_PRIOR		(1ULL << 8)
> +#define NMI_NORMAL_PRIOR	(1ULL << 4)
> +#define NMI_LOW_PRIOR		(1ULL << 0)
> +#define NMI_LOCAL_HIGH_PRIOR	(NMI_LOCAL_BIT | NMI_HIGH_PRIOR)
> +#define NMI_LOCAL_NORMAL_PRIOR	(NMI_LOCAL_BIT | NMI_NORMAL_PRIOR)
> +#define NMI_LOCAL_LOW_PRIOR	(NMI_LOCAL_BIT | NMI_LOW_PRIOR)
> +
>  void lapic_watchdog_stop(void);
>  int lapic_watchdog_init(unsigned nmi_hz);
>  int lapic_wd_event(unsigned nmi_hz);
> diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
> index 07a837d..44ff8c9 100644
> --- a/arch/x86/kernel/apic/hw_nmi.c
> +++ b/arch/x86/kernel/apic/hw_nmi.c
> @@ -67,7 +67,6 @@ arch_trigger_all_cpu_backtrace_handler(struct notifier_block *self,
>  
>  	switch (cmd) {
>  	case DIE_NMI:
> -	case DIE_NMI_IPI:
>  		break;
>  
>  	default:
> @@ -95,7 +94,7 @@ arch_trigger_all_cpu_backtrace_handler(struct notifier_block *self,
>  static __read_mostly struct notifier_block backtrace_notifier = {
>  	.notifier_call          = arch_trigger_all_cpu_backtrace_handler,
>  	.next                   = NULL,
> -	.priority               = 1
> +	.priority               = NMI_LOCAL_LOW_PRIOR,
>  };
>  
>  static int __init register_trigger_all_cpu_backtrace(void)
> diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
> index be6f9c4..e6c6294 100644
> --- a/arch/x86/kernel/apic/x2apic_uv_x.c
> +++ b/arch/x86/kernel/apic/x2apic_uv_x.c
> @@ -605,7 +605,7 @@ void __cpuinit uv_cpu_init(void)
>   */
>  int uv_handle_nmi(struct notifier_block *self, unsigned long reason, void *data)
>  {
> -	if (reason != DIE_NMI_IPI)
> +	if (reason != DIE_NMIUNKNOWN)
>  		return NOTIFY_OK;
>  
>  	if (in_crash_kexec)
> diff --git a/arch/x86/kernel/cpu/mcheck/mce-inject.c b/arch/x86/kernel/cpu/mcheck/mce-inject.c
> index e7dbde7..a779719 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce-inject.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce-inject.c
> @@ -25,6 +25,7 @@
>  #include <linux/gfp.h>
>  #include <asm/mce.h>
>  #include <asm/apic.h>
> +#include <asm/nmi.h>
>  
>  /* Update fake mce registers on current CPU. */
>  static void inject_mce(struct mce *m)
> @@ -83,7 +84,7 @@ static int mce_raise_notify(struct notifier_block *self,
>  	struct die_args *args = (struct die_args *)data;
>  	int cpu = smp_processor_id();
>  	struct mce *m = &__get_cpu_var(injectm);
> -	if (val != DIE_NMI_IPI || !cpumask_test_cpu(cpu, mce_inject_cpumask))
> +	if (val != DIE_NMI || !cpumask_test_cpu(cpu, mce_inject_cpumask))
>  		return NOTIFY_DONE;
>  	cpumask_clear_cpu(cpu, mce_inject_cpumask);
>  	if (m->inject_flags & MCJ_EXCEPTION)
> @@ -95,7 +96,7 @@ static int mce_raise_notify(struct notifier_block *self,
>  
>  static struct notifier_block mce_raise_nb = {
>  	.notifier_call = mce_raise_notify,
> -	.priority = 1000,
> +	.priority = NMI_LOCAL_NORMAL_PRIOR,
>  };
>  
>  /* Inject mce on current CPU */
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index da98b6d..55a3797 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -1226,7 +1226,7 @@ perf_event_nmi_handler(struct notifier_block *self,
>  		return NOTIFY_DONE;
>  
>  	switch (cmd) {
> -	case DIE_NMI_IPI:
> +	case DIE_NMI:
>  		break;
>  	case DIE_NMIUNKNOWN:
>  		this_nmi = percpu_read(irq_stat.__nmi_count);
> @@ -1276,7 +1276,7 @@ perf_event_nmi_handler(struct notifier_block *self,
>  static __read_mostly struct notifier_block perf_event_nmi_notifier = {
>  	.notifier_call		= perf_event_nmi_handler,
>  	.next			= NULL,
> -	.priority		= 1
> +	.priority		= NMI_LOCAL_LOW_PRIOR,
>  };
>  
>  static struct event_constraint unconstrained;
> diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
> index 852b819..020d052 100644
> --- a/arch/x86/kernel/kgdb.c
> +++ b/arch/x86/kernel/kgdb.c
> @@ -523,10 +523,6 @@ static int __kgdb_notify(struct die_args *args, unsigned long cmd)
>  		}
>  		return NOTIFY_DONE;
>  
> -	case DIE_NMI_IPI:
> -		/* Just ignore, we will handle the roundup on DIE_NMI. */
> -		return NOTIFY_DONE;
> -
>  	case DIE_NMIUNKNOWN:
>  		if (was_in_debug_nmi[raw_smp_processor_id()]) {
>  			was_in_debug_nmi[raw_smp_processor_id()] = 0;
> @@ -604,7 +600,7 @@ static struct notifier_block kgdb_notifier = {
>  	/*
>  	 * Lowest-prio notifier priority, we want to be notified last:
>  	 */
> -	.priority	= -INT_MAX,
> +	.priority	= NMI_LOCAL_LOW_PRIOR,
>  };
>  
>  /**
> diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
> index e3af342..eabbde6 100644
> --- a/arch/x86/kernel/reboot.c
> +++ b/arch/x86/kernel/reboot.c
> @@ -18,6 +18,7 @@
>  #include <asm/pci_x86.h>
>  #include <asm/virtext.h>
>  #include <asm/cpu.h>
> +#include <asm/nmi.h>
>  
>  #ifdef CONFIG_X86_32
>  # include <linux/ctype.h>
> @@ -753,7 +754,7 @@ static int crash_nmi_callback(struct notifier_block *self,
>  {
>  	int cpu;
>  
> -	if (val != DIE_NMI_IPI)
> +	if (val != DIE_NMI)
>  		return NOTIFY_OK;
>  
>  	cpu = raw_smp_processor_id();
> @@ -784,6 +785,8 @@ static void smp_send_nmi_allbutself(void)
>  
>  static struct notifier_block crash_nmi_nb = {
>  	.notifier_call = crash_nmi_callback,
> +	/* we want to be the first one called */
> +	.priority = NMI_LOCAL_HIGH_PRIOR+1,
>  };
>  
>  /* Halt all other CPUs, calling the specified function on each of them
> diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
> index d8acab3..9e56e3d 100644
> --- a/arch/x86/kernel/traps.c
> +++ b/arch/x86/kernel/traps.c
> @@ -395,8 +395,7 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
>  	 * CPU-specific NMI: send to specific CPU or NMI sources must
>  	 * be processed on specific CPU
>  	 */
> -	if (notify_die(DIE_NMI_IPI, "nmi_ipi", regs, 0, 2, SIGINT)
> -	    == NOTIFY_STOP)
> +	if (notify_die(DIE_NMI, "nmi_ipi", regs, 0, 2, SIGINT) == NOTIFY_STOP)
>  		return;
>  
>  	/* Non-CPU-specific NMI: NMI sources can be processed on any CPU */
> @@ -405,9 +404,6 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
>  	if (!cpu) {
>  		reason = get_nmi_reason();
>  		if (reason & NMI_REASON_MASK) {
> -			if (notify_die(DIE_NMI, "nmi", regs, reason, 2, SIGINT)
> -			    == NOTIFY_STOP)
> -				return;
>  			if (reason & NMI_REASON_SERR)
>  				pci_serr_error(reason, regs);
>  			else if (reason & NMI_REASON_IOCHK)
> @@ -423,9 +419,6 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
>  		}
>  	}
>  
> -	if (notify_die(DIE_NMI, "nmi", regs, 0, 2, SIGINT) == NOTIFY_STOP)
> -		return;
> -
>  #if defined(CONFIG_X86_LOCAL_APIC) && !defined(CONFIG_LOCKUP_DETECTOR)
>  	if (nmi_watchdog_tick(regs, reason))
>  		return;
> diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
> index 57f01bb..43b4f35 100644
> --- a/arch/x86/oprofile/nmi_int.c
> +++ b/arch/x86/oprofile/nmi_int.c
> @@ -64,7 +64,7 @@ static int profile_exceptions_notify(struct notifier_block *self,
>  	int ret = NOTIFY_DONE;
>  
>  	switch (val) {
> -	case DIE_NMI_IPI:
> +	case DIE_NMI:
>  		if (ctr_running)
>  			model->check_ctrs(args->regs, &__get_cpu_var(cpu_msrs));
>  		else if (!nmi_enabled)
> @@ -360,7 +360,7 @@ static void nmi_cpu_setup(void *dummy)
>  static struct notifier_block profile_exceptions_nb = {
>  	.notifier_call = profile_exceptions_notify,
>  	.next = NULL,
> -	.priority = 2
> +	.priority = NMI_LOCAL_LOW_PRIOR,
>  };
>  
>  static void nmi_cpu_restore_registers(struct op_msrs *msrs)
> diff --git a/arch/x86/oprofile/nmi_timer_int.c b/arch/x86/oprofile/nmi_timer_int.c
> index ab72a21..0197aa1 100644
> --- a/arch/x86/oprofile/nmi_timer_int.c
> +++ b/arch/x86/oprofile/nmi_timer_int.c
> @@ -25,7 +25,7 @@ static int profile_timer_exceptions_notify(struct notifier_block *self,
>  	int ret = NOTIFY_DONE;
>  
>  	switch (val) {
> -	case DIE_NMI_IPI:
> +	case DIE_NMI:
>  		oprofile_add_sample(args->regs, 0);
>  		ret = NOTIFY_STOP;
>  		break;
> @@ -38,7 +38,7 @@ static int profile_timer_exceptions_notify(struct notifier_block *self,
>  static struct notifier_block profile_timer_exceptions_nb = {
>  	.notifier_call = profile_timer_exceptions_notify,
>  	.next = NULL,
> -	.priority = 0
> +	.priority = NMI_EXT_LOW_PRIOR,

Do not find definition of NMI_EXT_LOW_PRIOR, forget to add it?

BTW: Attach a patch I used to test external NMI. Hope that is useful to
you.

Best Regards,
Huang Ying


--=-PRpPBi3cUmNxk8/MyeY8
Content-Disposition: attachment; filename="0008-x86-NMI-NMI-injecting-support.patch"
Content-Type: text/x-patch; name="0008-x86-NMI-NMI-injecting-support.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From 99a4accf4ccc36ac79c8663bd08e81884aedddaf Mon Sep 17 00:00:00 2001
From: Huang Ying <ying.huang@intel.com>
Date: Thu, 9 Sep 2010 14:28:44 +0800
Subject: [PATCH 08/38] x86, NMI, NMI injecting support

This patch implements trigger NMI on specified CPUs. At the same time,
the NMI reason (contents of port 0x61) can be faked too. This can be
used to debug and test the NMI handler.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 arch/x86/Kconfig.debug            |   10 +++
 arch/x86/include/asm/mach_traps.h |    9 +++-
 arch/x86/kernel/Makefile          |    1 +
 arch/x86/kernel/nmi_inject.c      |  117 +++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/traps.c           |   34 ++++++++++-
 5 files changed, 167 insertions(+), 4 deletions(-)
 create mode 100644 arch/x86/kernel/nmi_inject.c

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 7508508..d6bb833 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -299,4 +299,14 @@ config DEBUG_STRICT_USER_COPY_CHECKS
 
 	  If unsure, or if you run an older (pre 4.4) gcc, say N.
 
+config NMI_INJECT
+	tristate "NMI injecting support"
+	depends on DEBUG_KERNEL
+	---help---
+	  This can be used to trigger NMI on specified CPUs. And the
+	  reason of NMI (contents of port 0x61) can be faked
+	  too. This can be used to debug and test the NMI handler.
+
+	  If unsure, say N.
+
 endmenu
diff --git a/arch/x86/include/asm/mach_traps.h b/arch/x86/include/asm/mach_traps.h
index 72a8b52..4235bb3 100644
--- a/arch/x86/include/asm/mach_traps.h
+++ b/arch/x86/include/asm/mach_traps.h
@@ -17,7 +17,7 @@
 #define NMI_REASON_CLEAR_IOCHK	0x08
 #define NMI_REASON_CLEAR_MASK	0x0f
 
-static inline unsigned char get_nmi_reason(void)
+static inline unsigned char __get_nmi_reason(void)
 {
 	return inb(NMI_REASON_PORT);
 }
@@ -40,4 +40,11 @@ static inline void reassert_nmi(void)
 		unlock_cmos();
 }
 
+struct nmi_reason_inject_data {
+	unsigned char reason;
+	unsigned char valid : 1;
+};
+
+extern struct nmi_reason_inject_data nmi_reason_inject_data;
+
 #endif /* _ASM_X86_MACH_DEFAULT_MACH_TRAPS_H */
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 2dde3c7..5f98f33 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -119,6 +119,7 @@ obj-$(CONFIG_X86_CHECK_BIOS_CORRUPTION) += check.o
 obj-$(CONFIG_SWIOTLB)			+= pci-swiotlb.o
 
 obj-y					+= hwerr.o
+obj-$(CONFIG_NMI_INJECT)		+= nmi_inject.o
 
 ###
 # 64 bit specific files
diff --git a/arch/x86/kernel/nmi_inject.c b/arch/x86/kernel/nmi_inject.c
new file mode 100644
index 0000000..2b61148
--- /dev/null
+++ b/arch/x86/kernel/nmi_inject.c
@@ -0,0 +1,117 @@
+/*
+ * NMI injector, for NMI handler testing
+ *
+ * Copyright 2010 Intel Corp.
+ *   Author: Huang Ying <ying.huang@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/debugfs.h>
+#include <linux/cpu.h>
+#include <asm/mach_traps.h>
+#include <asm/apic.h>
+
+static int nmi_reason_inject_get(void *data, u64 *val)
+{
+	if (nmi_reason_inject_data.valid)
+		*val = nmi_reason_inject_data.reason;
+	else
+		*val = ~0ULL;
+	return 0;
+}
+
+static int nmi_reason_inject_set(void *data, u64 val)
+{
+	nmi_reason_inject_data.reason = val;
+	nmi_reason_inject_data.valid = 1;
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(nmi_reason_inject_fops, nmi_reason_inject_get,
+			nmi_reason_inject_set, "0x%llx\n");
+
+static int nmi_reason_uninject_set(void *data, u64 val)
+{
+	nmi_reason_inject_data.valid = 0;
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(nmi_reason_uninject_fops, NULL,
+			nmi_reason_uninject_set, "%llu\n");
+
+static int nmi_inject_set(void *data, u64 val)
+{
+	int cpu;
+	cpumask_var_t cpu_mask;
+
+	alloc_cpumask_var(&cpu_mask, GFP_KERNEL);
+	cpumask_clear(cpu_mask);
+	for_each_online_cpu(cpu) {
+		if (cpu >= sizeof(val))
+			continue;
+		if (val & (1ULL << cpu))
+			cpumask_set_cpu(cpu, cpu_mask);
+	}
+	if (!cpumask_empty(cpu_mask))
+		apic->send_IPI_mask(cpu_mask, NMI_VECTOR);
+	free_cpumask_var(cpu_mask);
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(nmi_inject_fops, NULL, nmi_inject_set, "0x%llx\n");
+
+static struct dentry *nmi_debug_dir;
+
+static int __init nmi_inject_init(void)
+{
+	int rc;
+	struct dentry *de;
+
+	rc = -ENOMEM;
+	nmi_debug_dir = debugfs_create_dir("nmi", NULL);
+	if (!nmi_debug_dir)
+		return rc;
+	de = debugfs_create_file("inject", S_IWUSR, nmi_debug_dir,
+				 NULL, &nmi_inject_fops);
+	if (!de)
+		goto err;
+	de = debugfs_create_file("reason_inject", S_IRUSR | S_IWUSR,
+				 nmi_debug_dir, NULL, &nmi_reason_inject_fops);
+	if (!de)
+		goto err;
+	de = debugfs_create_file("reason_uninject", S_IWUSR,
+				 nmi_debug_dir, NULL, &nmi_reason_uninject_fops);
+	if (!de)
+		goto err;
+
+	return 0;
+err:
+	debugfs_remove_recursive(nmi_debug_dir);
+	return rc;
+}
+
+static void __exit nmi_inject_exit(void)
+{
+	debugfs_remove_recursive(nmi_debug_dir);
+}
+
+module_init(nmi_inject_init);
+module_exit(nmi_inject_exit);
+
+MODULE_AUTHOR("Huang Ying");
+MODULE_DESCRIPTION("NMI injecting support");
+MODULE_LICENSE("GPL");
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 42f16f7..acfb1a9 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -316,6 +316,34 @@ static int __init setup_unknown_nmi_panic(char *str)
 }
 __setup("unknown_nmi_panic", setup_unknown_nmi_panic);
 
+struct nmi_reason_inject_data nmi_reason_inject_data;
+EXPORT_SYMBOL_GPL(nmi_reason_inject_data);
+
+static inline unsigned char get_nmi_reason(void)
+{
+	if (nmi_reason_inject_data.valid)
+		return nmi_reason_inject_data.reason;
+	else
+		return __get_nmi_reason();
+}
+
+static inline void outb_nmi_reason(unsigned char reason)
+{
+	static unsigned char prev_reason;
+
+	if (nmi_reason_inject_data.valid) {
+		if (reason & NMI_REASON_CLEAR_SERR)
+			nmi_reason_inject_data.reason &= ~NMI_REASON_SERR;
+		if (prev_reason == (reason | NMI_REASON_CLEAR_IOCHK) &&
+		    !(reason & NMI_REASON_CLEAR_IOCHK))
+			nmi_reason_inject_data.reason &= ~NMI_REASON_IOCHK;
+		if (!nmi_reason_inject_data.reason)
+			nmi_reason_inject_data.valid = 0;
+		prev_reason = reason;
+	} else
+		outb(reason, NMI_REASON_PORT);
+}
+
 static notrace __kprobes void
 pci_serr_error(unsigned char reason, struct pt_regs *regs)
 {
@@ -340,7 +368,7 @@ pci_serr_error(unsigned char reason, struct pt_regs *regs)
 
 	/* Clear and disable the PCI SERR error line. */
 	reason = (reason & NMI_REASON_CLEAR_MASK) | NMI_REASON_CLEAR_SERR;
-	outb(reason, NMI_REASON_PORT);
+	outb_nmi_reason(reason);
 }
 
 static notrace __kprobes void
@@ -358,7 +386,7 @@ io_check_error(unsigned char reason, struct pt_regs *regs)
 
 	/* Re-enable the IOCK line, wait for a few seconds */
 	reason = (reason & NMI_REASON_CLEAR_MASK) | NMI_REASON_CLEAR_IOCHK;
-	outb(reason, NMI_REASON_PORT);
+	outb_nmi_reason(reason);
 
 	i = 20000;
 	while (--i) {
@@ -367,7 +395,7 @@ io_check_error(unsigned char reason, struct pt_regs *regs)
 	}
 
 	reason &= ~NMI_REASON_CLEAR_IOCHK;
-	outb(reason, NMI_REASON_PORT);
+	outb_nmi_reason(reason);
 }
 
 static notrace __kprobes void
-- 
1.7.1


--=-PRpPBi3cUmNxk8/MyeY8--

