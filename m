Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab2GZVoE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 17:44:04 -0400
Received: from [213.199.154.142] ([213.199.154.142]:11039 "EHLO
	db3outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753170Ab2GZVoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 17:44:02 -0400
X-Forefront-Antispam-Report: CIP:160.33.194.230;KIP:(null);UIP:(null);IPV:NLI;H:usculsndmail03v.am.sony.com;RD:mail.sonyusa.com;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2fh2a8h668h839hd25hf0ah107ah10d2h)
Message-ID: <5011B9A4.7000801@am.sony.com>
Date: Thu, 26 Jul 2012 14:41:56 -0700
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: "tglx@linutronix.de" <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
        <linux-rt-users@vger.kernel.org>
Subject: [PATCH RT v2] cpu unplug with PREEMPT_LL
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


v2: less UGLY (less intrusive in sched.c)

With CONFIG_PREEMPT_LL, cpu unplug generates a bunch of
  BUG: sleeping function called from invalid context
  BUG: scheduling while atomic

To reproduce the problem:
  echo 0 > /sys/devices/system/cpu/cpu1/online

This patch should maybe not be included in the RT patch set but it
may be useful to anyone determined to use cpu hotplug with PREEMPT_LL.

This patch was tested on 3.0.36-rt58 since that release has the latest
hotplug patches.  I will rework and test this on 3.5-rtX when that is available.

Signed-off-by: Frank Rowand <frank.rowand@am.sony.com>
---
 include/linux/preempt.h |   10 	8 +	2 -	0 !
 include/linux/sched.h   |    6 	3 +	3 -	0 !
 kernel/cpu.c            |   12 	12 +	0 -	0 !
 kernel/sched.c          |   10 	5 +	5 -	0 !
 4 files changed, 28 insertions(+), 10 deletions(-)

Index: b/include/linux/preempt.h
===================================================================
--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -109,8 +109,10 @@ do { \
 # define preempt_disable_nort()		do { } while (0)
 # define preempt_enable_nort()		do { } while (0)
 # ifdef CONFIG_SMP
-   extern void migrate_disable(void);
-   extern void migrate_enable(void);
+   extern void __migrate_disable(void);
+   extern void __migrate_enable(void);
+#  define migrate_disable()		__migrate_disable()
+#  define migrate_enable()		__migrate_enable()
 # else /* CONFIG_SMP */
 #  define migrate_disable()		do { } while (0)
 #  define migrate_enable()		do { } while (0)
@@ -122,6 +124,10 @@ do { \
 # define preempt_enable_nort()		preempt_enable()
 # define migrate_disable()		preempt_disable()
 # define migrate_enable()		preempt_enable()
+#ifdef CONFIG_PREEMPT_LL
+   extern void __migrate_disable(void);
+   extern void __migrate_enable(void);
+#endif
 #endif
 
 #ifdef CONFIG_PREEMPT_NOTIFIERS
Index: b/kernel/cpu.c
===================================================================
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -500,11 +500,19 @@ static int __ref _cpu_down(unsigned int 
 	cpumask_andnot(cpumask, cpu_online_mask, cpumask_of(cpu));
 	set_cpus_allowed_ptr(current, cpumask);
 	free_cpumask_var(cpumask);
+#ifdef CONFIG_PREEMPT_LL
+	__migrate_disable();
+#else
 	migrate_disable();
+#endif
 	mycpu = smp_processor_id();
 	if (mycpu == cpu) {
 		printk(KERN_ERR "Yuck! Still on unplug CPU\n!");
+#ifdef CONFIG_PREEMPT_LL
+		__migrate_enable();
+#else
 		migrate_enable();
+#endif
 		return -EBUSY;
 	}
 
@@ -557,7 +565,11 @@ static int __ref _cpu_down(unsigned int 
 out_release:
 	cpu_unplug_done(cpu);
 out_cancel:
+#ifdef CONFIG_PREEMPT_LL
+	__migrate_enable();
+#else
 	migrate_enable();
+#endif
 	cpu_hotplug_done();
 	if (!err)
 		cpu_notify_nofail(CPU_POST_DEAD | mod, hcpu);
Index: b/kernel/sched.c
===================================================================
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4192,7 +4192,7 @@ static inline void schedule_debug(struct
 	schedstat_inc(this_rq(), sched_count);
 }
 
-#if defined(CONFIG_PREEMPT_RT_FULL) && defined(CONFIG_SMP)
+#if (defined(CONFIG_PREEMPT_RT_FULL) || defined(CONFIG_PREEMPT_LL)) && defined(CONFIG_SMP)
 #define MIGRATE_DISABLE_SET_AFFIN	(1<<30) /* Can't make a negative */
 #define migrate_disabled_updated(p)	((p)->migrate_disable & MIGRATE_DISABLE_SET_AFFIN)
 #define migrate_disable_count(p)	((p)->migrate_disable & ~MIGRATE_DISABLE_SET_AFFIN)
@@ -4228,7 +4228,7 @@ static inline void update_migrate_disabl
 	p->migrate_disable |= MIGRATE_DISABLE_SET_AFFIN;
 }
 
-void migrate_disable(void)
+void __migrate_disable(void)
 {
 	struct task_struct *p = current;
 
@@ -4254,9 +4254,9 @@ void migrate_disable(void)
 	p->migrate_disable = 1;
 	preempt_enable();
 }
-EXPORT_SYMBOL(migrate_disable);
+EXPORT_SYMBOL(__migrate_disable);
 
-void migrate_enable(void)
+void __migrate_enable(void)
 {
 	struct task_struct *p = current;
 	const struct cpumask *mask;
@@ -4306,7 +4306,7 @@ void migrate_enable(void)
 	unpin_current_cpu();
 	preempt_enable();
 }
-EXPORT_SYMBOL(migrate_enable);
+EXPORT_SYMBOL(__migrate_enable);
 #else
 static inline void update_migrate_disable(struct task_struct *p) { }
 #define migrate_disabled_updated(p)		0
Index: b/include/linux/sched.h
===================================================================
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1260,7 +1260,7 @@ struct task_struct {
 #endif
 
 	unsigned int policy;
-#ifdef CONFIG_PREEMPT_RT_FULL
+#if defined(CONFIG_PREEMPT_RT_FULL) || defined(CONFIG_PREEMPT_LL)
 	int migrate_disable;
 #ifdef CONFIG_SCHED_DEBUG
 	int migrate_disable_atomic;
@@ -2678,7 +2678,7 @@ static inline void set_task_cpu(struct t
 
 static inline int __migrate_disabled(struct task_struct *p)
 {
-#ifdef CONFIG_PREEMPT_RT_FULL
+#if defined(CONFIG_PREEMPT_RT_FULL) || defined(CONFIG_PREEMPT_LL)
 	return p->migrate_disable;
 #else
 	return 0;
@@ -2688,7 +2688,7 @@ static inline int __migrate_disabled(str
 /* Future-safe accessor for struct task_struct's cpus_allowed. */
 static inline const struct cpumask *tsk_cpus_allowed(struct task_struct *p)
 {
-#ifdef CONFIG_PREEMPT_RT_FULL
+#if defined(CONFIG_PREEMPT_RT_FULL) || defined(CONFIG_PREEMPT_LL)
 	if (p->migrate_disable)
 		return cpumask_of(task_cpu(p));
 #endif

