Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965695Ab2B1QoL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 11:44:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54025 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964951Ab2B1QoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 11:44:09 -0500
Date: Tue, 28 Feb 2012 08:42:48 -0800
From: tip-bot for Andreas Herrmann <andreas.herrmann3@amd.com>
Message-ID: <tip-20b25f03fbd17b4e32b786024a5f9c6306795411@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        andreas.herrmann3@amd.com, sp@numascale.com, bp@amd64.org,
        tglx@linutronix.de, mingo@elte.hu, daniel@numascale-asia.com,
        borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andreas.herrmann3@amd.com, sp@numascale.com, bp@amd64.org,
        tglx@linutronix.de, borislav.petkov@amd.com, mingo@elte.hu,
        daniel@numascale-asia.com
In-Reply-To: <20120224153127.GD28921@alberich.amd.com>
References: <20120224153127.GD28921@alberich.amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/platform:
  Remove incorrect error message in x86_default_fixup_cpu_id()
Git-Commit-ID: 20b25f03fbd17b4e32b786024a5f9c6306795411
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 28 Feb 2012 08:43:22 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  20b25f03fbd17b4e32b786024a5f9c6306795411
Gitweb:     http://git.kernel.org/tip/20b25f03fbd17b4e32b786024a5f9c6306795411
Author:     Andreas Herrmann <andreas.herrmann3@amd.com>
AuthorDate: Fri, 24 Feb 2012 16:31:27 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 28 Feb 2012 17:30:00 +0100

x86/platform: Remove incorrect error message in x86_default_fixup_cpu_id()

It's only called from amd.c:srat_detect_node(). The introduced
condition for calling the fixup code is true for all AMD
multi-node processors, e.g. Magny-Cours and Interlagos. There we
have 2 NUMA nodes on one socket. Thus there are cores having
different numa-node-id but with equal phys_proc_id.

There is no point to print error messages in such a situation.

The confusing/misleading error message was introduced with
commit 64be4c1c2428e148de6081af235e2418e6a66dda (x86: Add
x86_init platform override to fix up NUMA core numbering).

Change the default fixup function (remove the error message),
move the Numascale-specific condition for calling the fixup into
the fixup-function itself and slightly adapt the comment.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Reviewed-by: Daniel J Blueman <daniel@numascale-asia.com>
Acked-by: Borislav Petkov <bp@amd64.org>
Cc: Borislav Petkov <borislav.petkov@amd.com>
Cc: Steffen Persvold <sp@numascale.com>
Link: http://lkml.kernel.org/r/20120224153127.GD28921@alberich.amd.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/x86_init.h      |    2 +-
 arch/x86/kernel/apic/apic_numachip.c |    7 +++++--
 arch/x86/kernel/cpu/amd.c            |    8 ++++----
 arch/x86/kernel/cpu/common.c         |    9 ---------
 arch/x86/kernel/x86_init.c           |    1 +
 5 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 517d476..1bcacef 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -189,6 +189,6 @@ extern struct x86_msi_ops x86_msi;
 
 extern void x86_init_noop(void);
 extern void x86_init_uint_noop(unsigned int unused);
-extern void x86_default_fixup_cpu_id(struct cpuinfo_x86 *c, int node);
+extern void x86_default_fixup_cpu_id(struct cpuinfo_x86 *c, int n);
 
 #endif
diff --git a/arch/x86/kernel/apic/apic_numachip.c b/arch/x86/kernel/apic/apic_numachip.c
index 09d3d8c..ade0182 100644
--- a/arch/x86/kernel/apic/apic_numachip.c
+++ b/arch/x86/kernel/apic/apic_numachip.c
@@ -201,8 +201,11 @@ static void __init map_csrs(void)
 
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
index f4773f4..52b7287 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -352,11 +352,11 @@ static void __cpuinit srat_detect_node(struct cpuinfo_x86 *c)
 		node = per_cpu(cpu_llc_id, cpu);
 
 	/*
-	 * If core numbers are inconsistent, it's likely a multi-fabric platform,
-	 * so invoke platform-specific handler
+	 * On multi-fabric platform (e.g. Numascale NumaChip) a
+	 * platform-specific handler needs to be called to fixup some
+	 * IDs of the CPU.
 	 */
-	if (c->phys_proc_id != node)
-		x86_cpuinit.fixup_cpu_id(c, node);
+	x86_cpuinit.fixup_cpu_id(c, node);
 
 	if (!node_online(node)) {
 		/*
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index c0f7d68..1a810e4 100644
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
index 947a06c..67cf78a 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -90,6 +90,7 @@ struct x86_init_ops x86_init __initdata = {
 	},
 };
 
+void __cpuinit x86_default_fixup_cpu_id(struct cpuinfo_x86 *c, int n) { }
 struct x86_cpuinit_ops x86_cpuinit __cpuinitdata = {
 	.setup_percpu_clockev		= setup_secondary_APIC_clock,
 	.fixup_cpu_id			= x86_default_fixup_cpu_id,
