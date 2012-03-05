Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732Ab2CEKFj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 05:05:39 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:40050 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756714Ab2CEKFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 05:05:36 -0500
Message-ID: <1330941917.24353.63.camel@ThinkPad-T61>
Subject: [PATCH v2 x86 1/2]  fix page faults by nmiaction in nmi if
 kmemcheck is enabled
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, paulus@samba.org, mingo@elte.hu,
        acme@ghostprotocols.net, Vegard Nossum <vegardno@ifi.uio.no>,
        Don Zickus <dzickus@redhat.com>, tony.luck@intel.com, bp@amd64.org,
        robert.richter@amd.com, lenb@kernel.org, minyard@acm.org,
        wim@iguana.be, linux-edac@vger.kernel.org, oprofile-list@lists.sf.net,
        linux-acpi@vger.kernel.org, openipmi-developer@lists.sourceforge.net,
        linux-watchdog@vger.kernel.org
Date: Mon, 05 Mar 2012 18:05:17 +0800
In-Reply-To: <1330340324.11248.60.camel@twins>
References: <1329717665.3448.28.camel@ThinkPad-T61>
	 <1329735648.2293.307.camel@twins> <1329788560.3448.45.camel@ThinkPad-T61>
	 <1329819437.2293.382.camel@twins> <1329990828.19165.36.camel@ThinkPad-T61>
	 <1330340324.11248.60.camel@twins>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12030510-2000-0000-0000-000006A43CF6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch tries to fix the problem of page fault exception caused by
accessing nmiaction structure in nmi if kmemcheck is enabled. 

If kmemcheck is enabled, the memory allocated through slab are in pages
that are marked non-present, so that some checks could be done in the
page fault handling code ( e.g. whether the memory is read before
written to ). 
As nmiaction is allocated in this way, so it resides in a non-present
page. Then there is a page fault while the nmi code accessing the
nmiaction structure, which would then cause a warning by
WARN_ON_ONCE(in_nmi()) in kmemcheck_fault(), called by do_page_fault().

v2: as Peter suggested, changed the nmiaction to use static storage.

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
---
 arch/x86/include/asm/nmi.h              |   10 +++++-
 arch/x86/kernel/apic/hw_nmi.c           |    8 ++++-
 arch/x86/kernel/apic/x2apic_uv_x.c      |    7 ++++-
 arch/x86/kernel/cpu/mcheck/mce-inject.c |    8 ++++-
 arch/x86/kernel/cpu/perf_event.c        |    7 ++++-
 arch/x86/kernel/kgdb.c                  |   11 ++++--
 arch/x86/kernel/nmi.c                   |   49 ++----------------------------
 arch/x86/kernel/nmi_selftest.c          |   16 ++++++++--
 arch/x86/kernel/reboot.c                |    9 ++++-
 arch/x86/kernel/smp.c                   |    9 ++++-
 arch/x86/oprofile/nmi_int.c             |    8 ++++-
 drivers/acpi/apei/ghes.c                |    8 ++++-
 drivers/char/ipmi/ipmi_watchdog.c       |   10 +++++-
 drivers/watchdog/hpwdt.c                |   21 +++++++++++--
 14 files changed, 108 insertions(+), 73 deletions(-)

diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
index fd3f9f1..08d464f 100644
--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -35,8 +35,14 @@ enum {
 
 typedef int (*nmi_handler_t)(unsigned int, struct pt_regs *);
 
-int register_nmi_handler(unsigned int, nmi_handler_t, unsigned long,
-			 const char *);
+struct nmiaction {
+	struct list_head list;
+	nmi_handler_t handler;
+	unsigned int flags;
+	const char *name;
+};
+
+int register_nmi_handler(unsigned int, struct nmiaction *);
 
 void unregister_nmi_handler(unsigned int, const char *);
 
diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index 31cb9ae..9baea77 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -80,10 +80,14 @@ arch_trigger_all_cpu_backtrace_handler(unsigned int cmd, struct pt_regs *regs)
 	return NMI_DONE;
 }
 
+static struct nmiaction arch_trigger_all_cpu_bt_nmiaction = {
+	.handler	= arch_trigger_all_cpu_backtrace_handler,
+	.name		= "arch_bt",
+};
+
 static int __init register_trigger_all_cpu_backtrace(void)
 {
-	register_nmi_handler(NMI_LOCAL, arch_trigger_all_cpu_backtrace_handler,
-				0, "arch_bt");
+	register_nmi_handler(NMI_LOCAL, &arch_trigger_all_cpu_bt_nmiaction);
 	return 0;
 }
 early_initcall(register_trigger_all_cpu_backtrace);
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 79b05b8..5739042 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -715,9 +715,14 @@ int uv_handle_nmi(unsigned int reason, struct pt_regs *regs)
 	return NMI_HANDLED;
 }
 
+static struct nmiaction uv_nmiaction = {
+	.handler	= uv_handle_nmi,
+	.name		= "uv",
+};
+
 void uv_register_nmi_notifier(void)
 {
-	if (register_nmi_handler(NMI_UNKNOWN, uv_handle_nmi, 0, "uv"))
+	if (register_nmi_handler(NMI_UNKNOWN, &uv_nmiaction))
 		printk(KERN_WARNING "UV NMI handler failed to register\n");
 }
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce-inject.c b/arch/x86/kernel/cpu/mcheck/mce-inject.c
index fc4beb3..f9ab41c 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-inject.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-inject.c
@@ -229,14 +229,18 @@ static ssize_t mce_write(struct file *filp, const char __user *ubuf,
 	return usize;
 }
 
+static struct nmiaction mce_nmiaction = {
+	.handler	= mce_raise_notify,
+	.name		= "mce_notify",
+};
+
 static int inject_init(void)
 {
 	if (!alloc_cpumask_var(&mce_inject_cpumask, GFP_KERNEL))
 		return -ENOMEM;
 	printk(KERN_INFO "Machine check injector initialized\n");
 	register_mce_write_callback(mce_write);
-	register_nmi_handler(NMI_LOCAL, mce_raise_notify, 0,
-				"mce_notify");
+	register_nmi_handler(NMI_LOCAL, &mce_nmiaction);
 	return 0;
 }
 
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 5adce10..8bdff1b 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1246,6 +1246,11 @@ static void __init pmu_check_apic(void)
 	pr_info("no hardware sampling interrupt available.\n");
 }
 
+static struct nmiaction perf_event_nmiaction = {
+	.handler	= perf_event_nmi_handler,
+	.name		= "PMI",
+};
+
 static int __init init_hw_perf_events(void)
 {
 	struct x86_pmu_quirk *quirk;
@@ -1297,7 +1302,7 @@ static int __init init_hw_perf_events(void)
 		((1LL << x86_pmu.num_counters_fixed)-1) << X86_PMC_IDX_FIXED;
 
 	perf_events_lapic_init();
-	register_nmi_handler(NMI_LOCAL, perf_event_nmi_handler, 0, "PMI");
+	register_nmi_handler(NMI_LOCAL, &perf_event_nmiaction);
 
 	unconstrained = (struct event_constraint)
 		__EVENT_CONSTRAINT(0, (1ULL << x86_pmu.num_counters) - 1,
diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index faba577..d259d2a 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -601,6 +601,11 @@ static struct notifier_block kgdb_notifier = {
 	.notifier_call	= kgdb_notify,
 };
 
+static struct nmiaction kgdb_nmiaction = {
+	.handler	= kgdb_nmi_handler,
+	.name		= "kgdb",
+};
+
 /**
  *	kgdb_arch_init - Perform any architecture specific initalization.
  *
@@ -615,13 +620,11 @@ int kgdb_arch_init(void)
 	if (retval)
 		goto out;
 
-	retval = register_nmi_handler(NMI_LOCAL, kgdb_nmi_handler,
-					0, "kgdb");
+	retval = register_nmi_handler(NMI_LOCAL, &kgdb_nmiaction);
 	if (retval)
 		goto out1;
 
-	retval = register_nmi_handler(NMI_UNKNOWN, kgdb_nmi_handler,
-					0, "kgdb");
+	retval = register_nmi_handler(NMI_UNKNOWN, &kgdb_nmiaction);
 
 	if (retval)
 		goto out2;
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 47acaf3..d844acc 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -31,14 +31,6 @@
 #include <asm/nmi.h>
 #include <asm/x86_init.h>
 
-#define NMI_MAX_NAMELEN	16
-struct nmiaction {
-	struct list_head list;
-	nmi_handler_t handler;
-	unsigned int flags;
-	char *name;
-};
-
 struct nmi_desc {
 	spinlock_t lock;
 	struct list_head head;
@@ -160,51 +152,18 @@ static struct nmiaction *__free_nmi(unsigned int type, const char *name)
 	return (n);
 }
 
-int register_nmi_handler(unsigned int type, nmi_handler_t handler,
-			unsigned long nmiflags, const char *devname)
+int register_nmi_handler(unsigned int type, struct nmiaction *na)
 {
-	struct nmiaction *action;
-	int retval = -ENOMEM;
-
-	if (!handler)
+	if (!na->handler)
 		return -EINVAL;
 
-	action = kzalloc(sizeof(struct nmiaction), GFP_KERNEL);
-	if (!action)
-		goto fail_action;
-
-	action->handler = handler;
-	action->flags = nmiflags;
-	action->name = kstrndup(devname, NMI_MAX_NAMELEN, GFP_KERNEL);
-	if (!action->name)
-		goto fail_action_name;
-
-	retval = __setup_nmi(type, action);
-
-	if (retval)
-		goto fail_setup_nmi;
-
-	return retval;
-
-fail_setup_nmi:
-	kfree(action->name);
-fail_action_name:
-	kfree(action);
-fail_action:	
-
-	return retval;
+	return __setup_nmi(type, na);
 }
 EXPORT_SYMBOL_GPL(register_nmi_handler);
 
 void unregister_nmi_handler(unsigned int type, const char *name)
 {
-	struct nmiaction *a;
-
-	a = __free_nmi(type, name);
-	if (a) {
-		kfree(a->name);
-		kfree(a);
-	}
+	__free_nmi(type, name);
 }
 
 EXPORT_SYMBOL_GPL(unregister_nmi_handler);
diff --git a/arch/x86/kernel/nmi_selftest.c b/arch/x86/kernel/nmi_selftest.c
index 0d01a8e..40fd637 100644
--- a/arch/x86/kernel/nmi_selftest.c
+++ b/arch/x86/kernel/nmi_selftest.c
@@ -37,10 +37,15 @@ static int nmi_unk_cb(unsigned int val, struct pt_regs *regs)
 	return NMI_HANDLED;
 }
 
+static struct nmiaction selftest_unk_nmiaction = {
+	.handler	= nmi_unk_cb,
+	.name		= "nmi_selftest_unk",
+};
+
 static void init_nmi_testsuite(void)
 {
 	/* trap all the unknown NMIs we may generate */
-	register_nmi_handler(NMI_UNKNOWN, nmi_unk_cb, 0, "nmi_selftest_unk");
+	register_nmi_handler(NMI_UNKNOWN, &selftest_unk_nmiaction);
 }
 
 static void cleanup_nmi_testsuite(void)
@@ -58,12 +63,17 @@ static int test_nmi_ipi_callback(unsigned int val, struct pt_regs *regs)
         return NMI_DONE;
 }
 
+static struct nmiaction selftest_nmiaction = {
+	.handler	= test_nmi_ipi_callback,
+	.flags		= NMI_FLAG_FIRST,
+	.name		= "nmi_selftest",
+};
+
 static void test_nmi_ipi(struct cpumask *mask)
 {
 	unsigned long timeout;
 
-	if (register_nmi_handler(NMI_LOCAL, test_nmi_ipi_callback,
-				 NMI_FLAG_FIRST, "nmi_selftest")) {
+	if (register_nmi_handler(NMI_LOCAL, &selftest_nmiaction)) {
 		nmi_fail = FAILURE;
 		return;
 	}
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index d840e69..a0f8c15 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -799,6 +799,12 @@ static void smp_send_nmi_allbutself(void)
 	apic->send_IPI_allbutself(NMI_VECTOR);
 }
 
+static struct nmiaction crash_nmiaction = {
+	.handler	= crash_nmi_callback,
+	.flags		= NMI_FLAG_FIRST,
+	.name		= "crash",
+};
+
 /* Halt all other CPUs, calling the specified function on each of them
  *
  * This function can be used to halt all other CPUs on crash
@@ -817,8 +823,7 @@ void nmi_shootdown_cpus(nmi_shootdown_cb callback)
 
 	atomic_set(&waiting_for_crash_ipi, num_online_cpus() - 1);
 	/* Would it be better to replace the trap vector here? */
-	if (register_nmi_handler(NMI_LOCAL, crash_nmi_callback,
-				 NMI_FLAG_FIRST, "crash"))
+	if (register_nmi_handler(NMI_LOCAL, &crash_nmiaction))
 		return;		/* return what? */
 	/* Ensure the new callback function is set before sending
 	 * out the NMI
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 66c74f4..135d0b2 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -162,6 +162,12 @@ static int smp_stop_nmi_callback(unsigned int val, struct pt_regs *regs)
 	return NMI_HANDLED;
 }
 
+static struct nmiaction smp_stop_nmiaction = {
+	.handler	= smp_stop_nmi_callback,
+	.flags		= NMI_FLAG_FIRST,
+	.name		= "smp_stop",
+};
+
 static void native_nmi_stop_other_cpus(int wait)
 {
 	unsigned long flags;
@@ -179,8 +185,7 @@ static void native_nmi_stop_other_cpus(int wait)
 		if (atomic_cmpxchg(&stopping_cpu, -1, safe_smp_processor_id()) != -1)
 			return;
 
-		if (register_nmi_handler(NMI_LOCAL, smp_stop_nmi_callback,
-					 NMI_FLAG_FIRST, "smp_stop"))
+		if (register_nmi_handler(NMI_LOCAL, &smp_stop_nmiaction))
 			/* Note: we ignore failures here */
 			return;
 
diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 26b8a85..c3408f6 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -453,6 +453,11 @@ static struct notifier_block oprofile_cpu_nb = {
 	.notifier_call = oprofile_cpu_notifier
 };
 
+static struct nmiaction oprofile_nmiaction = {
+	.handler	= profile_exceptions_notify,
+	.name		= "oprofile",
+};
+
 static int nmi_setup(void)
 {
 	int err = 0;
@@ -489,8 +494,7 @@ static int nmi_setup(void)
 	ctr_running = 0;
 	/* make variables visible to the nmi handler: */
 	smp_mb();
-	err = register_nmi_handler(NMI_LOCAL, profile_exceptions_notify,
-					0, "oprofile");
+	err = register_nmi_handler(NMI_LOCAL, &oprofile_nmiaction);
 	if (err)
 		goto fail;
 
diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 9b3cac0..1d38f92 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -901,6 +901,11 @@ static unsigned long ghes_esource_prealloc_size(
 	return prealloc_size;
 }
 
+static struct nmiaction ghes_nmiaction = {
+	.handler	= ghes_notify_nmi,
+	.name		= "ghes",
+};
+
 static int __devinit ghes_probe(struct platform_device *ghes_dev)
 {
 	struct acpi_hest_generic *generic;
@@ -975,8 +980,7 @@ static int __devinit ghes_probe(struct platform_device *ghes_dev)
 		ghes_estatus_pool_expand(len);
 		mutex_lock(&ghes_list_mutex);
 		if (list_empty(&ghes_nmi))
-			register_nmi_handler(NMI_LOCAL, ghes_notify_nmi, 0,
-						"ghes");
+			register_nmi_handler(NMI_LOCAL, &ghes_nmiaction);
 		list_add_rcu(&ghes->list, &ghes_nmi);
 		mutex_unlock(&ghes_list_mutex);
 		break;
diff --git a/drivers/char/ipmi/ipmi_watchdog.c b/drivers/char/ipmi/ipmi_watchdog.c
index 34767a6..29a6e0a 100644
--- a/drivers/char/ipmi/ipmi_watchdog.c
+++ b/drivers/char/ipmi/ipmi_watchdog.c
@@ -1296,6 +1296,13 @@ static int preop_op(const char *inval, char *outval)
 	return 0;
 }
 
+#ifdef HAVE_DIE_NMI
+static struct nmiaction ipmi_nmiaction = {
+	.handler	= ipmi_nmi,
+	.name		= "ipmi",
+};
+#endif
+
 static void check_parms(void)
 {
 #ifdef HAVE_DIE_NMI
@@ -1313,8 +1320,7 @@ static void check_parms(void)
 		}
 	}
 	if (do_nmi && !nmi_handler_registered) {
-		rv = register_nmi_handler(NMI_UNKNOWN, ipmi_nmi, 0,
-						"ipmi");
+		rv = register_nmi_handler(NMI_UNKNOWN, &ipmi_nmiaction);
 		if (rv) {
 			printk(KERN_WARNING PFX
 			       "Can't register nmi handler\n");
diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index 8464ea1..e575e63 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -689,9 +689,22 @@ static void __devinit dmi_find_icru(const struct dmi_header *dm, void *dummy)
 	}
 }
 
+static struct nmiaction hpwdt_nmiaction[] = {
+	{
+		.handler	= hpwdt_pretimeout,
+		.name		= "hpwdt",
+	},
+	{
+		.handler	= hpwdt_pretimeout,
+		.flags		= NMI_FLAG_FIRST,
+		.name		= "hpwdt",
+	},
+};
+
 static int __devinit hpwdt_init_nmi_decoding(struct pci_dev *dev)
 {
 	int retval;
+	struct nmiaction *na = hpwdt_nmiaction;
 
 	/*
 	 * On typical CRU-based systems we need to map that service in
@@ -733,9 +746,11 @@ static int __devinit hpwdt_init_nmi_decoding(struct pci_dev *dev)
 	 * die notify list to handle a critical NMI. The default is to
 	 * be last so other users of the NMI signal can function.
 	 */
-	retval = register_nmi_handler(NMI_UNKNOWN, hpwdt_pretimeout,
-					(priority) ? NMI_FLAG_FIRST : 0,
-					"hpwdt");
+
+	if (priority)
+		na = &hpwdt_nmiaction[1];
+
+	retval = register_nmi_handler(NMI_UNKNOWN, na);
 	if (retval != 0) {
 		dev_warn(&dev->dev,
 			"Unable to register a die notifier (err=%d).\n",
-- 
1.7.1




