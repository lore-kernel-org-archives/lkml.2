Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069Ab2BXPbi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 10:31:38 -0500
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:25044
	"EHLO AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751266Ab2BXPbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 10:31:37 -0500
X-SpamScore: -1
X-BigFish: VPS-1(zz4015Izz1202hzz8275bhz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LZWLSE-02-HYV-02
X-M-MSG: 
Date: Fri, 24 Feb 2012 16:31:27 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: Borislav Petkov <bp@amd64.org>, <linux-kernel@vger.kernel.org>,
        Steffen Persvold <sp@numascale.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Daniel J Blueman <daniel@numascale-asia.com>
Subject: [PATCH resend] x86: Remove wrong error message in
 x86_default_fixup_cpu_id
Message-ID: <20120224153127.GD28921@alberich.amd.com>
References: <20120220171705.GA17069@alberich.amd.com>
 <20120221102725.GC14274@aftab>
 <4F437A71.6000402@numascale-asia.com>
 <20120222134707.GA9769@alberich.amd.com>
 <4F46138A.3030901@numascale-asia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4F46138A.3030901@numascale-asia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It's only called from amd.c:srat_detect_node(). The introduced
condition for calling the fixup code is true for all AMD multi-node
processors, e.g. Magny-Cours and Interlagos. There we have 2 NUMA
nodes on one socket. Thus there are cores having different
numa-node-id but with equal phys_proc_id.

There is no point to print error messages in such a situation.

The confusing/misleading error message was introduced with commit
64be4c1c2428e148de6081af235e2418e6a66dda (x86: Add x86_init platform
override to fix up NUMA core numbering).

Change the default fixup function (remove the error message), move the
Numascale-specific condition for calling the fixup into the
fixup-function itself and slightly adapt the comment.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Reviewed-by: Daniel J Blueman <daniel@numascale-asia.com>
---
 arch/x86/include/asm/x86_init.h      |    2 +-
 arch/x86/kernel/apic/apic_numachip.c |    7 +++++--
 arch/x86/kernel/cpu/amd.c            |    8 ++++----
 arch/x86/kernel/cpu/common.c         |    9 ---------
 arch/x86/kernel/x86_init.c           |    1 +
 5 files changed, 11 insertions(+), 16 deletions(-)


Please apply.


Thanks,

Andreas


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
index d43cad7..37da7a6 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1158,15 +1158,6 @@ static void dbg_restore_debug_regs(void)
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
-- 
1.7.8.4



