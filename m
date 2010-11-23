Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406Ab0KWKXr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 05:23:47 -0500
Received: from hera.kernel.org ([140.211.167.34]:48454 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083Ab0KWKXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 05:23:45 -0500
Date: Tue, 23 Nov 2010 10:23:17 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Add some clock info to sched_debug
Message-ID: <tip-5bb6b1ea67a73f0665a41726dd7138977b992c6c@git.kernel.org>
Git-Commit-ID: 5bb6b1ea67a73f0665a41726dd7138977b992c6c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 23 Nov 2010 10:23:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5bb6b1ea67a73f0665a41726dd7138977b992c6c
Gitweb:     http://git.kernel.org/tip/5bb6b1ea67a73f0665a41726dd7138977b992c6c
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 19 Nov 2010 21:11:09 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 23 Nov 2010 10:29:08 +0100

sched: Add some clock info to sched_debug

Add more clock information to /proc/sched_debug, Thomas wanted to see
the sched_clock_stable state.

Requested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_clock.c |    2 +-
 kernel/sched_debug.c |   31 +++++++++++++++++++++++++++----
 2 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/kernel/sched_clock.c b/kernel/sched_clock.c
index 52f1a14..9d8af0b 100644
--- a/kernel/sched_clock.c
+++ b/kernel/sched_clock.c
@@ -79,7 +79,7 @@ unsigned long long __attribute__((weak)) sched_clock(void)
 }
 EXPORT_SYMBOL_GPL(sched_clock);
 
-static __read_mostly int sched_clock_running;
+__read_mostly int sched_clock_running;
 
 #ifdef CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
 __read_mostly int sched_clock_stable;
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index e6590e7..e95b774 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -250,6 +250,8 @@ void print_rt_rq(struct seq_file *m, int cpu, struct rt_rq *rt_rq)
 #undef P
 }
 
+extern __read_mostly int sched_clock_running;
+
 static void print_cpu(struct seq_file *m, int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
@@ -321,21 +323,42 @@ static const char *sched_tunable_scaling_names[] = {
 
 static int sched_debug_show(struct seq_file *m, void *v)
 {
-	u64 now = ktime_to_ns(ktime_get());
+	u64 ktime, sched_clk, cpu_clk;
+	unsigned long flags;
 	int cpu;
 
-	SEQ_printf(m, "Sched Debug Version: v0.09, %s %.*s\n",
+	local_irq_save(flags);
+	ktime = ktime_to_ns(ktime_get());
+	sched_clk = sched_clock();
+	cpu_clk = local_clock();
+	local_irq_restore(flags);
+
+	SEQ_printf(m, "Sched Debug Version: v0.10, %s %.*s\n",
 		init_utsname()->release,
 		(int)strcspn(init_utsname()->version, " "),
 		init_utsname()->version);
 
-	SEQ_printf(m, "now at %Lu.%06ld msecs\n", SPLIT_NS(now));
+#define P(x) \
+	SEQ_printf(m, "%-40s: %Ld\n", #x, (long long)(x))
+#define PN(x) \
+	SEQ_printf(m, "%-40s: %Ld.%06ld\n", #x, SPLIT_NS(x))
+	PN(ktime);
+	PN(sched_clk);
+	PN(cpu_clk);
+	P(jiffies);
+#ifdef CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
+	P(sched_clock_stable);
+#endif
+#undef PN
+#undef P
+
+	SEQ_printf(m, "\n");
+	SEQ_printf(m, "sysctl_sched\n");
 
 #define P(x) \
 	SEQ_printf(m, "  .%-40s: %Ld\n", #x, (long long)(x))
 #define PN(x) \
 	SEQ_printf(m, "  .%-40s: %Ld.%06ld\n", #x, SPLIT_NS(x))
-	P(jiffies);
 	PN(sysctl_sched_latency);
 	PN(sysctl_sched_min_granularity);
 	PN(sysctl_sched_wakeup_granularity);
