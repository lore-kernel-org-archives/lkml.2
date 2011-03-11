Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986Ab1CKQXx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 11:23:53 -0500
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:44423 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751948Ab1CKQXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 11:23:37 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 0RmWIAYVM1mwNnOpCfKLD4G6JHMQQNiHFCS8zOgslxzkprz
 FBPFXloPJfC3p_8nSuJKWYp3PhRxr7RrZOCmX6I01lx1D_8HFruJXdxCxfjH
 x1BkvQ7KuwmuR4.1TIXXMB1ZJ0e3PsIPf61gGE2hWgKAFM8ahgLsDtbqaiyN
 h95_tpwh1XA9fo.rCD5JXX_BPTuavq5LtKwOTdzip9xJYLVFhrAszAsEPHdz
 X6bY8CH3KxPDw.8ZCwvtT1k7GMAtkP0hXYvGg6H1jFxhnXqIU9ppVN9jKNgU
 ocNnphQQ7WQM._ufiPU8b6tsJnrADwhKuoI5Xr4FhsVirlFc-
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20110311162334.162046931@linux.com>
User-Agent: quilt/0.48-1
Date: Fri, 11 Mar 2011 10:23:12 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [x86 this_cpu_has V1 2/4] x86: Avoid passing struct cpuinfo pointer to mce_available
References: <20110311162310.124405247@linux.com>
Content-Disposition: inline; filename=myfeat2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we do not pass the pointer to cpuinfio to mce available then its possible
to use this_cpu_has.

There are two use cases of mce_available: One with the current processor
and one with the boot cpu. Define a function for both cases. However, there
is only one case in which boot_mce_available is used. If we somehow can
get rid of that then the patch could be simplified.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 arch/x86/include/asm/mce.h             |    3 +-
 arch/x86/kernel/cpu/mcheck/mce.c       |   41 +++++++++++++++++++--------------
 arch/x86/kernel/cpu/mcheck/mce_intel.c |    2 -
 3 files changed, 27 insertions(+), 19 deletions(-)

Index: linux-2.6/arch/x86/include/asm/mce.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/mce.h	2011-01-19 14:01:22.000000000 -0600
+++ linux-2.6/arch/x86/include/asm/mce.h	2011-01-19 14:02:31.000000000 -0600
@@ -177,7 +177,8 @@ void mce_amd_feature_init(struct cpuinfo
 static inline void mce_amd_feature_init(struct cpuinfo_x86 *c) { }
 #endif
 
-int mce_available(struct cpuinfo_x86 *c);
+int this_cpu_mce_available(void);
+int boot_mce_available(void);
 
 DECLARE_PER_CPU(unsigned, mce_exception_count);
 DECLARE_PER_CPU(unsigned, mce_poll_count);
Index: linux-2.6/arch/x86/kernel/cpu/mcheck/mce.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mcheck/mce.c	2011-01-19 14:01:22.000000000 -0600
+++ linux-2.6/arch/x86/kernel/cpu/mcheck/mce.c	2011-01-19 16:21:42.000000000 -0600
@@ -434,11 +434,19 @@ static int mce_ring_add(unsigned long pf
 	return 0;
 }
 
-int mce_available(struct cpuinfo_x86 *c)
+int this_cpu_mce_available(void)
 {
 	if (mce_disabled)
 		return 0;
-	return cpu_has(c, X86_FEATURE_MCE) && cpu_has(c, X86_FEATURE_MCA);
+	return this_cpu_has(X86_FEATURE_MCE) && this_cpu_has(X86_FEATURE_MCA);
+}
+
+int boot_mce_available(void)
+{
+	if (mce_disabled)
+		return 0;
+	return cpu_has(&boot_cpu_data, X86_FEATURE_MCE) &&
+			cpu_has(&boot_cpu_data, X86_FEATURE_MCA);
 }
 
 static void mce_schedule_work(void)
@@ -1159,7 +1167,7 @@ static void mce_start_timer(unsigned lon
 
 	WARN_ON(smp_processor_id() != data);
 
-	if (mce_available(__this_cpu_ptr(&cpu_info))) {
+	if (this_cpu_mce_available()) {
 		machine_check_poll(MCP_TIMESTAMP,
 				&__get_cpu_var(mce_poll_banks));
 	}
@@ -1373,9 +1381,9 @@ static int __cpuinit __mcheck_cpu_apply_
 
 static void __cpuinit __mcheck_cpu_ancient_init(struct cpuinfo_x86 *c)
 {
-	if (c->x86 != 5)
+	if (this_cpu_read(cpu_info.x86) != 5)
 		return;
-	switch (c->x86_vendor) {
+	switch (this_cpu_read(cpu_info.x86_vendor)) {
 	case X86_VENDOR_INTEL:
 		intel_p5_mcheck_init(c);
 		break;
@@ -1402,17 +1410,16 @@ static void __mcheck_cpu_init_vendor(str
 static void __mcheck_cpu_init_timer(void)
 {
 	struct timer_list *t = &__get_cpu_var(mce_timer);
-	int *n = &__get_cpu_var(mce_next_interval);
 
 	setup_timer(t, mce_start_timer, smp_processor_id());
 
 	if (mce_ignore_ce)
 		return;
 
-	*n = check_interval * HZ;
-	if (!*n)
+	this_cpu_write(mce_next_interval, check_interval * HZ);
+	if (!this_cpu_read(mce_next_interval))
 		return;
-	t->expires = round_jiffies(jiffies + *n);
+	t->expires = round_jiffies(jiffies + this_cpu_read(mce_next_interval));
 	add_timer_on(t, smp_processor_id());
 }
 
@@ -1438,7 +1445,7 @@ void __cpuinit mcheck_cpu_init(struct cp
 
 	__mcheck_cpu_ancient_init(c);
 
-	if (!mce_available(c))
+	if (!this_cpu_mce_available())
 		return;
 
 	if (__mcheck_cpu_cap_init() < 0 || __mcheck_cpu_apply_quirks(c) < 0) {
@@ -1775,7 +1782,7 @@ static int mce_resume(struct sys_device
 static void mce_cpu_restart(void *data)
 {
 	del_timer_sync(&__get_cpu_var(mce_timer));
-	if (!mce_available(__this_cpu_ptr(&cpu_info)))
+	if (!this_cpu_mce_available())
 		return;
 	__mcheck_cpu_init_generic();
 	__mcheck_cpu_init_timer();
@@ -1790,7 +1797,7 @@ static void mce_restart(void)
 /* Toggle features for corrected errors */
 static void mce_disable_ce(void *all)
 {
-	if (!mce_available(__this_cpu_ptr(&cpu_info)))
+	if (!this_cpu_mce_available())
 		return;
 	if (all)
 		del_timer_sync(&__get_cpu_var(mce_timer));
@@ -1799,7 +1806,7 @@ static void mce_disable_ce(void *all)
 
 static void mce_enable_ce(void *all)
 {
-	if (!mce_available(__this_cpu_ptr(&cpu_info)))
+	if (!this_cpu_mce_available())
 		return;
 	cmci_reenable();
 	cmci_recheck();
@@ -1962,7 +1969,7 @@ static __cpuinit int mce_create_device(u
 	int err;
 	int i, j;
 
-	if (!mce_available(&boot_cpu_data))
+	if (!boot_mce_available())
 		return -EIO;
 
 	memset(&per_cpu(mce_dev, cpu).kobj, 0, sizeof(struct kobject));
@@ -2022,7 +2029,7 @@ static void __cpuinit mce_disable_cpu(vo
 	unsigned long action = *(unsigned long *)h;
 	int i;
 
-	if (!mce_available(__this_cpu_ptr(&cpu_info)))
+	if (!this_cpu_mce_available())
 		return;
 
 	if (!(action & CPU_TASKS_FROZEN))
@@ -2040,7 +2047,7 @@ static void __cpuinit mce_reenable_cpu(v
 	unsigned long action = *(unsigned long *)h;
 	int i;
 
-	if (!mce_available(__this_cpu_ptr(&cpu_info)))
+	if (!this_cpu_mce_available())
 		return;
 
 	if (!(action & CPU_TASKS_FROZEN))
@@ -2122,7 +2129,7 @@ static __init int mcheck_init_device(voi
 	int err;
 	int i = 0;
 
-	if (!mce_available(&boot_cpu_data))
+	if (!boot_mce_available())
 		return -EIO;
 
 	zalloc_cpumask_var(&mce_dev_initialized, GFP_KERNEL);
Index: linux-2.6/arch/x86/kernel/cpu/mcheck/mce_intel.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mcheck/mce_intel.c	2011-01-19 14:01:22.000000000 -0600
+++ linux-2.6/arch/x86/kernel/cpu/mcheck/mce_intel.c	2011-01-19 14:02:31.000000000 -0600
@@ -130,7 +130,7 @@ void cmci_recheck(void)
 	unsigned long flags;
 	int banks;
 
-	if (!mce_available(__this_cpu_ptr(&cpu_info)) || !cmci_supported(&banks))
+	if (!this_cpu_mce_available() || !cmci_supported(&banks))
 		return;
 	local_irq_save(flags);
 	machine_check_poll(MCP_TIMESTAMP, &__get_cpu_var(mce_banks_owned));

