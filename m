Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965385Ab2CBLvj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 06:51:39 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:47239
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965054Ab2CBLvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 06:51:37 -0500
X-SpamScore: -9
X-BigFish: VPS-9(zz1432N98dKzz1202hzz8275bhz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M09A9U-02-6BI-02
X-M-MSG: 
Date: Fri, 2 Mar 2012 12:51:30 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: <mingo@redhat.com>, <hpa@zytor.com>, <linux-kernel@vger.kernel.org>,
        <sp@numascale.com>, <bp@amd64.org>, <tglx@linutronix.de>,
        <borislav.petkov@amd.com>, <daniel@numascale-asia.com>,
        <linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/urgent] x86/platform: Remove incorrect error message in
 x86_default_fixup_cpu_id()
Message-ID: <20120302115130.GA17876@alberich.amd.com>
References: <20120224153127.GD28921@alberich.amd.com>
 <tip-20b25f03fbd17b4e32b786024a5f9c6306795411@git.kernel.org>
 <20120302110440.GA24019@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120302110440.GA24019@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2012 at 12:04:40PM +0100, Ingo Molnar wrote:
> 
> * tip-bot for Andreas Herrmann <andreas.herrmann3@amd.com> wrote:
> 
> > +++ b/arch/x86/kernel/cpu/common.c
> > diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
> > index 947a06c..67cf78a 100644
> > --- a/arch/x86/kernel/x86_init.c
> > +++ b/arch/x86/kernel/x86_init.c
> > @@ -90,6 +90,7 @@ struct x86_init_ops x86_init __initdata = {
> >  	},
> >  };
> >  
> > +void __cpuinit x86_default_fixup_cpu_id(struct cpuinfo_x86 *c, int n) { }
> >  struct x86_cpuinit_ops x86_cpuinit __cpuinitdata = {
> 
> Hm, I missed this first time around:
> 
>  - why is this function global? It's not used by anything else.

No reason. Should be static.

>  - why is it squeezed before a structure without any vertical 
>    separation?

Should be corrected too.

>  - why does it have the body as { }, as if it were an inline 
>    function?

To make it fit into one line, similar to other default init functions,
e.g.  default_nmi_init().

> Really, this should either be a short static function, with a 
> proper body, or we should accept a NULL pointer there and check 
> for it before calling it - there's a single usage site right 
> now.

> The latter looks like the cleanest solution to me.

Yes, the NULL pointer check is probably the better alternative.
How about below patch version?


Regards,
Andreas
--
x86: Remove wrong error message in x86_default_fixup_cpu_id

It's only called from amd.c:srat_detect_node(). The introduced
condition for calling the fixup code is true for all AMD multi-node
processors, e.g. Magny-Cours and Interlagos. There we have 2 NUMA
nodes on one socket. Thus there are cores having different
numa-node-id but with equal phys_proc_id.

There is no point to print error messages in such a situation.

The confusing/misleading error message was introduced with commit
64be4c1c2428e148de6081af235e2418e6a66dda (x86: Add x86_init platform
override to fix up NUMA core numbering).

Remove the default fixup function (especially the error message) and
replace it by a NULL pointer check, move the Numascale-specific
condition for calling the fixup into the fixup-function itself and
slightly adapt the comment.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/include/asm/x86_init.h      |    1 -
 arch/x86/kernel/apic/apic_numachip.c |    7 +++++--
 arch/x86/kernel/cpu/amd.c            |    7 ++++---
 arch/x86/kernel/cpu/common.c         |    9 ---------
 arch/x86/kernel/x86_init.c           |    1 -
 5 files changed, 9 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 517d476..a609c39 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -189,6 +189,5 @@ extern struct x86_msi_ops x86_msi;
 
 extern void x86_init_noop(void);
 extern void x86_init_uint_noop(unsigned int unused);
-extern void x86_default_fixup_cpu_id(struct cpuinfo_x86 *c, int node);
 
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
index 0a44b90..c8fd678 100644
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
index ade9c79..abd0af5 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1162,15 +1162,6 @@ static void dbg_restore_debug_regs(void)
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
index 947a06c..83b05ad 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -92,7 +92,6 @@ struct x86_init_ops x86_init __initdata = {
 
 struct x86_cpuinit_ops x86_cpuinit __cpuinitdata = {
 	.setup_percpu_clockev		= setup_secondary_APIC_clock,
-	.fixup_cpu_id			= x86_default_fixup_cpu_id,
 };
 
 static void default_nmi_init(void) { };
-- 
1.7.8.4



