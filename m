Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759383Ab0J0KAi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 06:00:38 -0400
Received: from ozlabs.org ([203.10.76.45]:54607 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753538Ab0J0KAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 06:00:37 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH] kdb: avoid on-stack cpumask, old-style accessors
Date: Wed, 27 Oct 2010 20:30:34 +1030
User-Agent: KMail/1.13.5 (Linux/2.6.35-22-generic; KDE/4.5.1; i686; ; )
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201010272030.34310.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That's quite a big stack already; I assume moving it to a static bitmap
is OK for this usage (a cpumask_var_t might require kmalloc, not sure
that's a good idea here).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: kgdb-bugreport@lists.sourceforge.net
Cc: Jason Wessel <jason.wessel@windriver.com>
---
 kernel/debug/kdb/kdb_main.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -2598,6 +2598,9 @@ static int kdb_summary(int argc, const c
 	return 0;
 }
 
+/* Not sure when to initialize this, so make it a static bitmap. */
+static DECLARE_BITMAP(per_cpu_suppress, NR_CPUS);
+
 /*
  * kdb_per_cpu - This function implements the 'per_cpu' command.
  */
@@ -2605,7 +2608,7 @@ static int kdb_per_cpu(int argc, const c
 {
 	char buf[256], fmtstr[64];
 	kdb_symtab_t symtab;
-	cpumask_t suppress = CPU_MASK_NONE;
+	struct cpumask *suppress = to_cpumask(per_cpu_suppress);
 	int cpu, diag;
 	unsigned long addr, val, bytesperword = 0, whichcpu = ~0UL;
 
@@ -2649,7 +2652,7 @@ static int kdb_per_cpu(int argc, const c
 #define KDB_PCU(cpu) 0
 #endif
 #endif
-
+	cpumask_clear(suppress);
 	for_each_online_cpu(cpu) {
 		if (whichcpu != ~0UL && whichcpu != cpu)
 			continue;
@@ -2662,7 +2665,7 @@ static int kdb_per_cpu(int argc, const c
 		}
 #ifdef	CONFIG_SMP
 		if (!val) {
-			cpu_set(cpu, suppress);
+			cpumask_set_cpu(cpu, suppress);
 			continue;
 		}
 #endif	/* CONFIG_SMP */
@@ -2671,17 +2674,16 @@ static int kdb_per_cpu(int argc, const c
 			bytesperword == KDB_WORD_SIZE,
 			1, bytesperword, 1, 1, 0);
 	}
-	if (cpus_weight(suppress) == 0)
+	if (cpumask_weight(suppress) == 0)
 		return 0;
 	kdb_printf("Zero suppressed cpu(s):");
-	for (cpu = first_cpu(suppress); cpu < num_possible_cpus();
-	     cpu = next_cpu(cpu, suppress)) {
+	for_each_cpu(cpu, suppress) {
 		kdb_printf(" %d", cpu);
-		if (cpu == num_possible_cpus() - 1 ||
-		    next_cpu(cpu, suppress) != cpu + 1)
+		if (cpu == nr_cpu_ids - 1 ||
+		    cpumask_next(cpu, suppress) != cpu + 1)
 			continue;
-		while (cpu < num_possible_cpus() &&
-		       next_cpu(cpu, suppress) == cpu + 1)
+		while (cpu < nr_cpu_ids &&
+		       cpumask_next(cpu, suppress) == cpu + 1)
 			++cpu;
 		kdb_printf("-%d", cpu);
 	}
