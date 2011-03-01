Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647Ab1CAHvr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 02:51:47 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54277 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755597Ab1CAHvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 02:51:45 -0500
Date: Tue, 1 Mar 2011 08:51:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: David Rientjes <rientjes@google.com>, Jack Steiner <steiner@sgi.com>,
        Robin Holt <holt@sgi.com>, Len Brown <len.brown@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yinghai Lu <yhlu.kernel@gmail.com>, linux-acpi@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 4/4] x86: Minimize SRAT messages
Message-ID: <20110301075128.GC12384@elte.hu>
References: <20110225180633.857892225@gulag1.americas.sgi.com>
 <20110225180634.422972243@gulag1.americas.sgi.com>
 <20110227120348.GE16453@elte.hu>
 <4D6BFA76.2060208@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6BFA76.2060208@sgi.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Travis <travis@sgi.com> wrote:

> Ingo Molnar wrote:
> >* Mike Travis <travis@sgi.com> wrote:
> >
> >>Condense the SRAT: messages to show all the APIC id's on one line for
> >>each Node.  This not only saves space in the log buf, it also makes
> >>it easier to spot inconsistencies in core to node placement.
> >>
> >>On a system with 2368 cores on 248 nodes the change will be...
> >>
> >>Was 2368 lines (for 2368 cores):
> >>
> >> 779 [0] SRAT: PXM 0 -> APIC 0x0000 -> Node 0
> >> 780 [0] SRAT: PXM 0 -> APIC 0x0002 -> Node 0
> >> 781 [0] SRAT: PXM 0 -> APIC 0x0004 -> Node 0
> >> ...
> >> 3145 [0] SRAT: PXM 247 -> APIC 0x3df0 -> Node 247
> >> 3146 [0] SRAT: PXM 247 -> APIC 0x3df2 -> Node 247
> >>
> >>Now it's 248 lines (for 248 Nodes):
> >>
> >> 821 [0] SRAT: Node 0: PXM:APIC 0:0x0 :0x2 :0x4 :0x10 :0x12 ...
> >> 822 [0] SRAT: Node 1: PXM:APIC 1:0x40 :0x42 :0x44 :0x50 :0x52 ...
> >> 823 [0] SRAT: Node 2: PXM:APIC 2:0x80 :0x82 :0x84 :0x90 :0x92 ...
> >> ...
> >> 1067 [0] SRAT: Node 246: PXM:APIC 246:0x3d80 :0x3d82 :0x3d84 :0x3d90 ...
> >> 1068 [0] SRAT: Node 247: PXM:APIC 247:0x3dc0 :0x3dc2 :0x3dc4 :0x3dd2 ...
> >>
> >>Signed-off-by: Mike Travis <travis@sgi.com>
> >>Reviewed-by: Jack Steiner <steiner@sgi.com>
> >>Reviewed-by: Robin Holt <holt@sgi.com>
> >>---
> >> arch/x86/mm/srat_64.c |   19 +++++++++++++++++--
> >> drivers/acpi/numa.c   |    7 +++++++
> >> 2 files changed, 24 insertions(+), 2 deletions(-)
> >>
> >>--- linux.orig/arch/x86/mm/srat_64.c
> >>+++ linux/arch/x86/mm/srat_64.c
> >>@@ -110,6 +110,12 @@ void __init acpi_numa_slit_init(struct a
> >> 	memblock_x86_reserve_range(phys, phys + length, "ACPI SLIT");
> >> }
> >>+/*
> >>+ * Keep track of previous node and PXM values so we can combine
> >>+ * same ones onto a single line.
> >>+ */
> >>+static int __initdata last_node = NUMA_NO_NODE, last_pxm =  PXM_INVAL;
> >>+
> >> /* Callback for Proximity Domain -> x2APIC mapping */
> >> void __init
> >> acpi_numa_x2apic_affinity_init(struct acpi_srat_x2apic_cpu_affinity *pa)
> >>@@ -141,8 +147,17 @@ acpi_numa_x2apic_affinity_init(struct ac
> >> 	set_apicid_to_node(apic_id, node);
> >> 	node_set(node, cpu_nodes_parsed);
> >> 	acpi_numa = 1;
> >>-	printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%04x -> Node %u\n",
> >>-	       pxm, apic_id, node);
> >>+	if (node != last_node) {
> >>+		pr_info("SRAT: Node %u: PXM:APIC %u:0x%x",
> >>+		       node, pxm, apic_id);
> >>+		last_node = node;
> >>+		last_pxm = pxm;
> >>+	} else if (pxm != last_pxm) {
> >>+		pr_cont(" %u:0x%x", pxm, apic_id);
> >>+		last_pxm = pxm;
> >>+	} else {
> >>+		pr_cont(" :0x%x", apic_id);
> >>+	}
> >> }
> >> /* Callback for Proximity Domain -> LAPIC mapping */
> >>--- linux.orig/drivers/acpi/numa.c
> >>+++ linux/drivers/acpi/numa.c
> >>@@ -286,6 +286,13 @@ int __init acpi_numa_init(void)
> >> 	if (!acpi_table_parse(ACPI_SIG_SRAT, acpi_parse_srat)) {
> >> 		acpi_table_parse_srat(ACPI_SRAT_TYPE_X2APIC_CPU_AFFINITY,
> >> 				     acpi_parse_x2apic_affinity, 0);
> >>+		/*
> >>+		 * Parsing ACPI_SRAT_TYPE_X2APIC_CPU_AFFINITY entries place
> >>+		 * multiple CPU's on the same Node line.  This can leave the
> >>+		 * last entry "dangling" without a newline.  Insert it here.
> >>+		 */
> >>+		pr_cont("\n");
> >
> >This is quite ugly as it breaks the genericity of the ACPI parsing
> >here. Is there no cleaner method that keeps this deinit \n
> >printing somehow within the realm of x86?
> >
> >Also, can there be cases where there's no 'dangling' line pending?
> >In that case the \n will be superfluous here.
> >
> >Thanks,
> >
> >	Ingo
> 
> Yes, David brought up the same point a couple of weeks ago.  I've tried and
> failed to find a solution, except that the printk function seems to add the
> newline if there is not one.  I asked if this was sufficient to rely on,
> and no one spoke up.  (Everyone is quick to object, but seemingly very slow
> to agree.)
> 
> And yes, there will always be a dangling line.  If the ACPI guys could tell
> me how to predict when this is the last entry, I would gladly change it.

Your problem is that the current way of ACPI parsing does not lend itself well to 
your stateful approach to printing compressed info.

Last i checked the C language was still Turing-complete so there *ought* to be some 
solution.

My problem is that you are asking me to commit a change to a piece of code i do not 
maintain. I do that reluctantly and i absolutely cannot do it when a patch has 
easily visible negative side-effects on code quality. So either get Len's Acked-by 
to add a small amount of crap to drivers/acpi/ (or better yet, get him to commit 
it), or code up a clean solution ...

Thanks,

	Ingo
