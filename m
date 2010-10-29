Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761515Ab0J2NLh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 09:11:37 -0400
Received: from mail.windriver.com ([147.11.1.11]:64323 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756735Ab0J2NLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 09:11:35 -0400
Message-ID: <4CCAC7F7.9060400@windriver.com>
Date: Fri, 29 Oct 2010 08:11:19 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Subject: Re: [PATCH] kdb: avoid on-stack cpumask, old-style accessors
References: <201010272030.34310.rusty@rustcorp.com.au> <4CC810A0.80609@windriver.com> <201010292018.26776.rusty@rustcorp.com.au>
In-Reply-To: <201010292018.26776.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Oct 2010 13:11:20.0643 (UTC) FILETIME=[C76FE930:01CB776A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2010 04:48 AM, Rusty Russell wrote:
> 
> We could, or look harder at that code to see if the mask is really needed?

How right you are!  We don't even need the mask in the first place.
The code can be refactored at the same time it is made to actually
work.  It turns out that the per_cpu command doesn't work properly at
the moment in the mainline.

That means I will drop your patch, but I really do appreciate you
pointing this out.

Thanks!
Jason.

--

From: Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH] kdb: fix per_cpu command to remove supress mask
Date: Fri Oct 29 08:04:16 CDT 2010

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
 kernel/debug/kdb/kdb_main.c |   46 ++++++++++----------------------------------
 1 file changed, 11 insertions(+), 35 deletions(-)

--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -2603,20 +2603,17 @@ static int kdb_summary(int argc, const c
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
@@ -2649,46 +2646,25 @@ static int kdb_per_cpu(int argc, const c
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
 
