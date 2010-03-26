Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408Ab0CZWDM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 18:03:12 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:39823 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754195Ab0CZWDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 18:03:10 -0400
Date: Fri, 26 Mar 2010 23:03:07 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: peterz@infradead.org, mingo@elte.hu, tglx@linutronix.de, oleg@redhat.com,
       Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 4/7] arch/mips/kernel: Use set_cpus_allowed_ptr
Message-ID: <Pine.LNX.4.64.1003262302480.6480@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use set_cpus_allowed_ptr rather than set_cpus_allowed.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression E1,E2;
@@

- set_cpus_allowed(E1, cpumask_of_cpu(E2))
+ set_cpus_allowed_ptr(E1, cpumask_of(E2))

@@
expression E;
identifier I;
@@

- set_cpus_allowed(E, I)
+ set_cpus_allowed_ptr(E, &I)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 arch/mips/kernel/cpufreq/loongson2_cpufreq.c |    4 ++--
 arch/mips/kernel/mips-mt-fpaff.c             |    4 ++--
 arch/mips/kernel/traps.c                     |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff -u -p a/arch/mips/kernel/cpufreq/loongson2_cpufreq.c b/arch/mips/kernel/cpufreq/loongson2_cpufreq.c
--- a/arch/mips/kernel/cpufreq/loongson2_cpufreq.c
+++ b/arch/mips/kernel/cpufreq/loongson2_cpufreq.c
@@ -65,7 +65,7 @@ static int loongson2_cpufreq_target(stru
 		return -ENODEV;
 
 	cpus_allowed = current->cpus_allowed;
-	set_cpus_allowed(current, cpumask_of_cpu(cpu));
+	set_cpus_allowed_ptr(current, cpumask_of(cpu));
 
 	if (cpufreq_frequency_table_target
 	    (policy, &loongson2_clockmod_table[0], target_freq, relation,
@@ -91,7 +91,7 @@ static int loongson2_cpufreq_target(stru
 	/* notifiers */
 	cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
 
-	set_cpus_allowed(current, cpus_allowed);
+	set_cpus_allowed_ptr(current, &cpus_allowed);
 
 	/* setting the cpu frequency */
 	clk_set_rate(cpuclk, freq);
diff -u -p a/arch/mips/kernel/mips-mt-fpaff.c b/arch/mips/kernel/mips-mt-fpaff.c
--- a/arch/mips/kernel/mips-mt-fpaff.c
+++ b/arch/mips/kernel/mips-mt-fpaff.c
@@ -100,10 +100,10 @@ asmlinkage long mipsmt_sys_sched_setaffi
 	if (test_ti_thread_flag(ti, TIF_FPUBOUND) &&
 	    cpus_intersects(new_mask, mt_fpu_cpumask)) {
 		cpus_and(effective_mask, new_mask, mt_fpu_cpumask);
-		retval = set_cpus_allowed(p, effective_mask);
+		retval = set_cpus_allowed_ptr(p, &effective_mask);
 	} else {
 		clear_ti_thread_flag(ti, TIF_FPUBOUND);
-		retval = set_cpus_allowed(p, new_mask);
+		retval = set_cpus_allowed_ptr(p, &new_mask);
 	}
 
 out_unlock:
diff -u -p a/arch/mips/kernel/traps.c b/arch/mips/kernel/traps.c
--- a/arch/mips/kernel/traps.c
+++ b/arch/mips/kernel/traps.c
@@ -862,7 +862,7 @@ static void mt_ase_fp_affinity(void)
 				= current->cpus_allowed;
 			cpus_and(tmask, current->cpus_allowed,
 				mt_fpu_cpumask);
-			set_cpus_allowed(current, tmask);
+			set_cpus_allowed_ptr(current, &tmask);
 			set_thread_flag(TIF_FPUBOUND);
 		}
 	}
