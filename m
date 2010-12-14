Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760219Ab0LNVWm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 16:22:42 -0500
Received: from hera.kernel.org ([140.211.167.34]:49669 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760165Ab0LNVWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 16:22:38 -0500
Date: Tue, 14 Dec 2010 21:21:57 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de, hpa@linux.intel.com,
        rjw@sisk.pl
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de, rjw@sisk.pl,
        hpa@linux.intel.com
In-Reply-To: <1290557500.4946.8.camel@sbsiddha-MOBL3.sc.intel.com>
References: <1290557500.4946.8.camel@sbsiddha-MOBL3.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/alternatives] x86, suspend: Avoid unnecessary smp alternatives switch during suspend/resume
Message-ID: <tip-3fb82d56ad003e804923185316236f26b30dfdd5@git.kernel.org>
Git-Commit-ID: 3fb82d56ad003e804923185316236f26b30dfdd5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 14 Dec 2010 21:21:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3fb82d56ad003e804923185316236f26b30dfdd5
Gitweb:     http://git.kernel.org/tip/3fb82d56ad003e804923185316236f26b30dfdd5
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Tue, 23 Nov 2010 16:11:40 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 13 Dec 2010 16:23:56 -0800

x86, suspend: Avoid unnecessary smp alternatives switch during suspend/resume

During suspend, we disable all the non boot cpus. And during resume we bring
them all back again. So no need to do alternatives_smp_switch() in between.

On my core 2 based laptop, this speeds up the suspend path by 15msec and the
resume path by 5 msec (suspend/resume speed up differences can be attributed
to the different P-states that the cpu is in during suspend/resume).

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <1290557500.4946.8.camel@sbsiddha-MOBL3.sc.intel.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
