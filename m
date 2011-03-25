Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730Ab1CYRJl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 13:09:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45561 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673Ab1CYRJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 13:09:39 -0400
Subject: Re: [tip:perf/urgent] perf, x86: Complain louder about BIOSen
 corrupting CPU/PMU state and continue
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, eric.dumazet@gmail.com, efault@gmx.de,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
        mingo@elte.hu, linux-tip-commits@vger.kernel.org
In-Reply-To: <AANLkTi=Dgo7Ck-Nc+qq7roRqcO9mtoA_FLt=QA6mdK_W@mail.gmail.com>
References: <tip-45daae575e08bbf7405c5a3633e956fa364d1b4f@git.kernel.org>
	 <AANLkTi=Dgo7Ck-Nc+qq7roRqcO9mtoA_FLt=QA6mdK_W@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Mar 2011 18:11:40 +0100
Message-ID: <1301073100.2250.229.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-25 at 09:44 -0700, Linus Torvalds wrote:
> On Fri, Mar 25, 2011 at 4:52 AM, tip-bot for Ingo Molnar <mingo@elte.hu> wrote:
> >
> > perf, x86: Complain louder about BIOSen corrupting CPU/PMU state and continue

> Also, don't we need to make sure that the event isn't tied to the SCI
> line? I thought the affected BIOSen did something odd with the local
> apic setup too? But that might be some fevered nightmare dream of
> mine, and/or just a misunderstanding from the hallway discussion I've
> had with people about this.

I don't think they actually can do this, there is only a single PMU
interrupt line and we program that to the NMI vector on startup. Now the
SMM crap could of course read out the APIC programming and put an SMI
trap on whatever interrupt it points to, but I'm not sure its doing
that. Afaik its simply polling state or somesuch.

> This might also be something we do want to give a kernel command line
> option for. As in "bios=allow-annoying-pmu-thing" or whatever.

I had such a patch, Ingo argued against it and we decided not to do it,
but we could still.

---
Subject: perf, x86: Allow forcing the PMU
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Thu Dec 09 15:03:11 CET 2010

Allow an admin to force the PMU, even though it appears to be in use.

Use with caustion, abusers get to keep all pieces.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 Documentation/kernel-parameters.txt |    6 ++++++
 arch/x86/kernel/cpu/perf_event.c    |   20 ++++++++++++++++++++
 2 files changed, 26 insertions(+)

Index: linux-2.6/Documentation/kernel-parameters.txt
===================================================================
--- linux-2.6.orig/Documentation/kernel-parameters.txt
+++ linux-2.6/Documentation/kernel-parameters.txt
@@ -2020,6 +2020,12 @@ and is between 256 and 4096 characters.
 			allocator.  This parameter is primarily	for debugging
 			and performance comparison.
 
+	perf_event.force.	[x86] Force the usage of the PMU, even if there were
+			active counters. This usually indicates a broken BIOS
+			and forcing it will result in an ill-functioning system.
+			It is useful however with kexec/kdump when you know
+			the BIOS is good and the previous OS didn't clean up.
+
 	pf.		[PARIDE]
 			See Documentation/blockdev/paride.txt.
 
Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
@@ -43,6 +43,18 @@ do {								\
 #endif
 
 /*
+ * Kernel parameter to force the PMU despite it appearing in-use.
+ *
+ * If you use this when the BIOS actually has stolen a resource you will end up
+ * with an ill-functioning system.
+ *
+ * This flag is only useful for kexec/kdump like things where the previous
+ * kernel did set up PMU resources and forgot to shut them down.
+ */
+static int force;
+module_param(force, bool, 0444);
+
+/*
  * best effort, GUP based copy_from_user() that assumes IRQ or NMI context
  */
 static unsigned long
@@ -195,6 +207,7 @@ struct x86_pmu {
 	 */
 	const char	*name;
 	int		version;
+	int		forced;
 	int		(*handle_irq)(struct pt_regs *);
 	void		(*disable_all)(void);
 	void		(*enable_all)(int added);
@@ -415,6 +428,10 @@ static bool check_hw_exists(void)
 	return true;
 
 bios_fail:
+	if (force) {
+		x86_pmu.forced = 1;
+		return true;
+	}
 	printk(KERN_CONT "Broken BIOS detected, software events only.\n");
 	printk(KERN_ERR FW_BUG "the BIOS has corrupted hw-PMU resources (MSR: %x=%Lx)\n", reg, val);
 	return false;
@@ -1421,6 +1438,9 @@ int __init init_hw_perf_events(void)
 
 	pr_cont("%s PMU driver.\n", x86_pmu.name);
 
+	if (x86_pmu.forced)
+		printk(KERN_WARNING "WARNING: Forced the PMU, might not work correctly due to BIOS wreckage.\n");
+
 	if (x86_pmu.quirks)
 		x86_pmu.quirks();
 


