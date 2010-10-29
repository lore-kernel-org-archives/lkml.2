Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761613Ab0J2Sop (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 14:44:45 -0400
Received: from mail.windriver.com ([147.11.1.11]:58542 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761551Ab0J2Soh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 14:44:37 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 2/7] kdb: fix per_cpu command to remove supress mask
Date: Fri, 29 Oct 2010 13:43:36 -0500
Message-Id: <1288377821-24520-3-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1288377821-24520-1-git-send-email-jason.wessel@windriver.com>
References: <1288377821-24520-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 29 Oct 2010 18:43:49.0003 (UTC) FILETIME=[399615B0:01CB7799]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty pointed out that the per_cpu command uses up lots of space on
the stack and the cpu supress mask is probably not needed.

This patch removes the need for the supress mask as well as fixing up
the following problems with the kdb per_cpu command:
  * The per_cpu command should allow an address as an argument
  * When you have more data than can be displayed on one screen allow
    the user to break out of the print loop.

Reported-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 kernel/debug/kdb/kdb_main.c |   46 ++++++++++--------------------------------
 1 files changed, 11 insertions(+), 35 deletions(-)

diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index d7bda21..9755ac0 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -2603,20 +2603,17 @@ static int kdb_summary(int argc, const char **argv)
  */
 static int kdb_per_cpu(int argc, const char **argv)
 {
-	char buf[256], fmtstr[64];
-	kdb_symtab_t symtab;
-	cpumask_t suppress = CPU_MASK_NONE;
-	int cpu, diag;
-	unsigned long addr, val, bytesperword = 0, whichcpu = ~0UL;
+	char fmtstr[64];
+	int cpu, diag, nextarg = 1;
+	unsigned long addr, symaddr, val, bytesperword = 0, whichcpu = ~0UL;
 
 	if (argc < 1 || argc > 3)
 		return KDB_ARGCOUNT;
 
-	snprintf(buf, sizeof(buf), "per_cpu__%s", argv[1]);
-	if (!kdbgetsymval(buf, &symtab)) {
-		kdb_printf("%s is not a per_cpu variable\n", argv[1]);
-		return KDB_BADADDR;
-	}
+	diag = kdbgetaddrarg(argc, argv, &nextarg, &symaddr, NULL, NULL);
+	if (diag)
+		return diag;
+
 	if (argc >= 2) {
 		diag = kdbgetularg(argv[2], &bytesperword);
 		if (diag)
@@ -2649,46 +2646,25 @@ static int kdb_per_cpu(int argc, const char **argv)
 #define KDB_PCU(cpu) 0
 #endif
 #endif
-
 	for_each_online_cpu(cpu) {
+		if (KDB_FLAG(CMD_INTERRUPT))
+			return 0;
+
 		if (whichcpu != ~0UL && whichcpu != cpu)
 			continue;
-		addr = symtab.sym_start + KDB_PCU(cpu);
+		addr = symaddr + KDB_PCU(cpu);
 		diag = kdb_getword(&val, addr, bytesperword);
 		if (diag) {
 			kdb_printf("%5d " kdb_bfd_vma_fmt0 " - unable to "
 				   "read, diag=%d\n", cpu, addr, diag);
 			continue;
 		}
-#ifdef	CONFIG_SMP
-		if (!val) {
-			cpu_set(cpu, suppress);
-			continue;
-		}
-#endif	/* CONFIG_SMP */
 		kdb_printf("%5d ", cpu);
 		kdb_md_line(fmtstr, addr,
 			bytesperword == KDB_WORD_SIZE,
 			1, bytesperword, 1, 1, 0);
 	}
-	if (cpus_weight(suppress) == 0)
-		return 0;
-	kdb_printf("Zero suppressed cpu(s):");
-	for (cpu = first_cpu(suppress); cpu < num_possible_cpus();
-	     cpu = next_cpu(cpu, suppress)) {
-		kdb_printf(" %d", cpu);
-		if (cpu == num_possible_cpus() - 1 ||
-		    next_cpu(cpu, suppress) != cpu + 1)
-			continue;
-		while (cpu < num_possible_cpus() &&
-		       next_cpu(cpu, suppress) == cpu + 1)
-			++cpu;
-		kdb_printf("-%d", cpu);
-	}
-	kdb_printf("\n");
-
 #undef KDB_PCU
-
 	return 0;
 }
 
-- 
1.6.3.3

