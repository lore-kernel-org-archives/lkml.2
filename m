Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab2DPSyA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 14:54:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47143 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189Ab2DPSx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 14:53:59 -0400
Date: Mon, 16 Apr 2012 11:53:28 -0700
From: tip-bot for Andreas Herrmann <andreas.herrmann3@amd.com>
Message-ID: <tip-68894632afb2729a1d8785c877840953894c7283@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        andreas.herrmann3@amd.com, sp@numascale.com, bp@amd64.org,
        stable@kernel.org, tglx@linutronix.de, borislav.petkov@amd.com,
        daniel@numascale-asia.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andreas.herrmann3@amd.com, sp@numascale.com, bp@amd64.org,
        stable@kernel.org, tglx@linutronix.de, daniel@numascale-asia.com,
        borislav.petkov@amd.com
In-Reply-To: <20120402160648.GR27684@alberich.amd.com>
References: <20120402160648.GR27684@alberich.amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/platform:
  Remove incorrect error message in x86_default_fixup_cpu_id()
Git-Commit-ID: 68894632afb2729a1d8785c877840953894c7283
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 16 Apr 2012 11:53:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  68894632afb2729a1d8785c877840953894c7283
Gitweb:     http://git.kernel.org/tip/68894632afb2729a1d8785c877840953894c7283
Author:     Andreas Herrmann <andreas.herrmann3@amd.com>
AuthorDate: Mon, 2 Apr 2012 18:06:48 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 16 Apr 2012 20:43:43 +0200

x86/platform: Remove incorrect error message in x86_default_fixup_cpu_id()

It's only called from amd.c:srat_detect_node(). The introduced
condition for calling the fixup code is true for all AMD
multi-node processors, e.g. Magny-Cours and Interlagos. There we
have 2 NUMA nodes on one socket. Thus there are cores having
different numa-node-id but with equal phys_proc_id.

There is no point to print error messages in such a situation.

The confusing/misleading error message was introduced with
commit 64be4c1c2428e148de6081af235e2418e6a66dda ("x86: Add
x86_init platform override to fix up NUMA core numbering").

Remove the default fixup function (especially the error message)
and replace it by a NULL pointer check, move the
Numascale-specific condition for calling the fixup into the
fixup-function itself and slightly adapt the comment.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Acked-by: Borislav Petkov <borislav.petkov@amd.com>
Cc: <stable@kernel.org>
Cc: <sp@numascale.com>
Cc: <bp@amd64.org>
Cc: <daniel@numascale-asia.com>
Link: http://lkml.kernel.org/r/20120402160648.GR27684@alberich.amd.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/x86_init.h      |    1 -
 arch/x86/kernel/apic/apic_numachip.c |    7 +++++--
 arch/x86/kernel/cpu/amd.c            |    7 ++++---
 arch/x86/kernel/cpu/common.c         |    9 ---------
 arch/x86/kernel/x86_init.c           |    1 -
 5 files changed, 9 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index baaca8d..764b66a 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -195,6 +195,5 @@ extern struct x86_msi_ops x86_msi;
 
 extern void x86_init_noop(void);
 extern void x86_init_uint_noop(unsigned int unused);
-extern void x86_default_fixup_cpu_id(struct cpuinfo_x86 *c, int node);
 
 #endif
diff --git a/arch/x86/kernel/apic/apic_numachip.c b/arch/x86/kernel/apic/apic_numachip.c
index 899803e..23e7542 100644
--- a/arch/x86/kernel/apic/apic_numachip.c
+++ b/arch/x86/kernel/apic/apic_numachip.c
@@ -207,8 +207,11 @@ static void __init map_csrs(void)
 
 static void fixup_cpu_id(struct cpuinfo_x86 *c, int node)
 {
-	c->phys_proc_id = node;
-	per_cpu(cpu_llc_id, smp_processor_id()) = node;
+
+	if (c->phys_proc_id != node) {
+		c->phys_proc_id = node;
+		per_cpu(cpu_llc_id, smp_processor_id()) = node;
+	}
 }
 
 static int __init numachip_system_init(void)
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 1248f9c..1c67ca1 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -353,10 +353,11 @@ static void __cpuinit srat_detect_node(struct cpuinfo_x86 *c)
 		node = per_cpu(cpu_llc_id, cpu);
 
 	/*
-	 * If core numbers are inconsistent, it's likely a multi-fabric platform,
-	 * so invoke platform-specific handler
+	 * On multi-fabric platform (e.g. Numascale NumaChip) a
+	 * platform-specific handler needs to be called to fixup some
+	 * IDs of the CPU.
 	 */
-	if (c->phys_proc_id != node)
+	if (x86_cpuinit.fixup_cpu_id)
 		x86_cpuinit.fixup_cpu_id(c, node);
 
 	if (!node_online(node)) {
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 67e2583..cf79302 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1163,15 +1163,6 @@ static void dbg_restore_debug_regs(void)
 #endif /* ! CONFIG_KGDB */
 
 /*
- * Prints an error where the NUMA and configured core-number mismatch and the
- * platform didn't override this to fix it up
- */
-void __cpuinit x86_default_fixup_cpu_id(struct cpuinfo_x86 *c, int node)
-{
-	pr_err("NUMA core number %d differs from configured core number %d\n", node, c->phys_proc_id);
-}
-
-/*
  * cpu_init() initializes state that is per-CPU. Some data is already
  * initialized (naturally) in the bootstrap process, such as the GDT
  * and IDT. We reload them nevertheless, this function acts as a
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index e9f265f..9cf71d0 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -93,7 +93,6 @@ struct x86_init_ops x86_init __initdata = {
 struct x86_cpuinit_ops x86_cpuinit __cpuinitdata = {
 	.early_percpu_clock_init	= x86_init_noop,
 	.setup_percpu_clockev		= setup_secondary_APIC_clock,
-	.fixup_cpu_id			= x86_default_fixup_cpu_id,
 };
 
 static void default_nmi_init(void) { };
