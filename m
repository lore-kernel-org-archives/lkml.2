Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651Ab1AFKWd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 05:22:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44730 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752427Ab1AFKWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 05:22:31 -0500
Date: Thu, 6 Jan 2011 11:22:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/alternatives changes for v2.6.38
Message-ID: <20110106102221.GA24222@elte.hu>
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

Please pull the latest x86-alternatives-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-alternatives-for-linus


out-of-topic modifications in x86-alternatives-for-linus:
---------------------------------------------------------
kernel/cpu.c                       # 3fb82d5: x86, suspend: Avoid unnecessary s

 Thanks,

	Ingo

------------------>
Suresh Siddha (1):
      x86, suspend: Avoid unnecessary smp alternatives switch during suspend/resume


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
index 083e99d..837c81e 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1166,6 +1166,20 @@ out:
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
index f6e726f..8ccc182 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -386,6 +386,14 @@ out:
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
@@ -397,6 +405,7 @@ int disable_nonboot_cpus(void)
 	 * with the userspace trying to use the CPU hotplug at the same time
 	 */
 	cpumask_clear(frozen_cpus);
+	arch_disable_nonboot_cpus_begin();
 
 	printk("Disabling non-boot CPUs ...\n");
 	for_each_online_cpu(cpu) {
@@ -412,6 +421,8 @@ int disable_nonboot_cpus(void)
 		}
 	}
 
+	arch_disable_nonboot_cpus_end();
+
 	if (!error) {
 		BUG_ON(num_online_cpus() > 1);
 		/* Make sure the CPUs won't be enabled by someone else */
