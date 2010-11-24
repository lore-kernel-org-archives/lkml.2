Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467Ab0KXALi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 19:11:38 -0500
Received: from mga11.intel.com ([192.55.52.93]:57571 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755288Ab0KXALh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 19:11:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,245,1288594800"; 
   d="scan'208";a="629719867"
Subject: Re: [patch] x86: avoid unnecessary smp alternatives switch during
 suspend/resume
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Nigel Cunningham <lkml@nigelcunningham.com.au>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Ben Gamari <bgamari@gmail.com>, xiyou.wangcong@gmail.com,
        Borislav Petkov <bp@alien8.de>
In-Reply-To: <4CE8E60D.9000303@nigelcunningham.com.au>
References: <1290211764.2637.8.camel@sbsiddha-MOBL3.sc.intel.com>
	 <4CE8E60D.9000303@nigelcunningham.com.au>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 23 Nov 2010 16:11:40 -0800
Message-Id: <1290557500.4946.8.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-11-21 at 01:27 -0800, Nigel Cunningham wrote:
> We have a few others things that want to modify their behaviour 
> according to whether we're doing the atomic copy/restore.

What are these other things and shouldn't they be using the smp_mode in
arch/x86/kernel/alternative.c ? Perhaps we need an API to export this
for others to use?

>  Perhaps it 
> would be an idea to just use a single flag, perhaps a value for 
> system_state?

I initially thought of system_state but as Peter mentioned, I was
worried that the system_state modification in this path might break some
suspend/resume code flow.

Anyways appended a slightly modified patch that uses similar flow like
the existing arch_enable_nonboot_cpus_{begin, end}

thanks,
suresh
---

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: x86: avoid unnecessary smp alternatives switch during suspend/resume

During suspend, we disable all the non boot cpus. And during resume we bring
them all back again. So no need to do alternatives_smp_switch() in between.

On my core 2 based laptop, this speeds up the suspend path by 15msec and the
resume path by 5 msec (suspend/resume speed up differences can be attributed
to the different P-states that the cpu is in during suspend/resume).

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/include/asm/alternative.h |    1 +
 arch/x86/kernel/alternative.c      |    3 ++-
 arch/x86/kernel/smpboot.c          |   14 ++++++++++++++
 kernel/cpu.c                       |   11 +++++++++++
 4 files changed, 28 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index 76561d2..01171f6 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -66,6 +66,7 @@ extern void alternatives_smp_module_add(struct module *mod, char *name,
 extern void alternatives_smp_module_del(struct module *mod);
 extern void alternatives_smp_switch(int smp);
 extern int alternatives_text_reserved(void *start, void *end);
+extern bool skip_smp_alternatives;
 #else
 static inline void alternatives_smp_module_add(struct module *mod, char *name,
 					       void *locks, void *locks_end,
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 5079f24..9f98eb4 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -353,6 +353,7 @@ void __init_or_module alternatives_smp_module_del(struct module *mod)
 	mutex_unlock(&smp_alt);
 }
 
+bool skip_smp_alternatives;
 void alternatives_smp_switch(int smp)
 {
 	struct smp_alt_module *mod;
@@ -368,7 +369,7 @@ void alternatives_smp_switch(int smp)
 	printk("lockdep: fixing up alternatives.\n");
 #endif
 
-	if (noreplace_smp || smp_alt_once)
+	if (noreplace_smp || smp_alt_once || skip_smp_alternatives)
 		return;
 	BUG_ON(!smp && (num_online_cpus() > 1));
 
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index f0a0624..589db1d 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1158,6 +1158,20 @@ out:
 	preempt_enable();
 }
 
+void arch_disable_nonboot_cpus_begin(void)
+{
+	/*
+	 * Avoid the smp alternatives switch during the disable_nonboot_cpus().
+	 * In the suspend path, we will be back in the SMP mode shortly anyways.
+	 */
+	skip_smp_alternatives = true;
+}
+
+void arch_disable_nonboot_cpus_end(void)
+{
+	skip_smp_alternatives = false;
+}
+
 void arch_enable_nonboot_cpus_begin(void)
 {
 	set_mtrr_aps_delayed_init();
diff --git a/kernel/cpu.c b/kernel/cpu.c
index cb7a1ef..156cc55 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -384,6 +384,14 @@ out:
 #ifdef CONFIG_PM_SLEEP_SMP
 static cpumask_var_t frozen_cpus;
 
+void __weak arch_disable_nonboot_cpus_begin(void)
+{
+}
+
+void __weak arch_disable_nonboot_cpus_end(void)
+{
+}
+
 int disable_nonboot_cpus(void)
 {
 	int cpu, first_cpu, error = 0;
@@ -395,6 +403,7 @@ int disable_nonboot_cpus(void)
 	 * with the userspace trying to use the CPU hotplug at the same time
 	 */
 	cpumask_clear(frozen_cpus);
+	arch_disable_nonboot_cpus_begin();
 
 	printk("Disabling non-boot CPUs ...\n");
 	for_each_online_cpu(cpu) {
@@ -410,6 +419,8 @@ int disable_nonboot_cpus(void)
 		}
 	}
 
+	arch_disable_nonboot_cpus_end();
+
 	if (!error) {
 		BUG_ON(num_online_cpus() > 1);
 		/* Make sure the CPUs won't be enabled by someone else */


