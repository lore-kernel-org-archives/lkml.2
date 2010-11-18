Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759056Ab0KRPgP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 10:36:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13813 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752819Ab0KRPgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 10:36:14 -0500
Date: Thu, 18 Nov 2010 10:35:46 -0500
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 1/3] x86: only call smp_processor_id in non-preempt cases
Message-ID: <20101118153546.GA15430@redhat.com>
References: <1289573455-3410-1-git-send-email-dzickus@redhat.com>
 <20101118081407.GB23481@elte.hu>
 <20101118142213.GB18100@redhat.com>
 <20101118144921.GB28350@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101118144921.GB28350@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 03:49:21PM +0100, Ingo Molnar wrote:
> 
> * Don Zickus <dzickus@redhat.com> wrote:
> 
> > On Thu, Nov 18, 2010 at 09:14:07AM +0100, Ingo Molnar wrote:
> > > 
> > > * Don Zickus <dzickus@redhat.com> wrote:
> > > 
> > > > There are some paths that walk the die_chain with preemption on.
> > > 
> > > What are those codepaths? At minimum it's worth documenting them.
> > 
> > Well the one that caused the bug was do_general_protection which walks the
> > die_chain with DIE_GPF.
> > 
> > I can document them, though it might be time consuming to audit them and hope they 
> > don't change.
> 
> Listing one example is enough.
> 
> > [...]  I guess my bigger question is, is it expected that anyone who calls the 
> > die_chain to have preemption disabled?  If not, then does it matter if we document 
> > it?
> 
> Yes, it might be a bug to call those handlers with preemption on (or even with irqs 
> on). But if the code is fine as-is then documenting a single example would be nice.
> 

Is this better?

Cheers, 
Don

------------------------------------->
From: Don Zickus <dzickus@redhat.com>
Date: Mon, 1 Nov 2010 13:34:33 -0400
Subject: [PATCH 1/6] x86: only call smp_processor_id in non-preempt cases

There are some paths that walk the die_chain with preemption on.
Make sure we are in an NMI call before we start doing anything.

This was triggered by do_general_protection calling notify_die with
DIE_GPF.

Reported-by: Jan Kiszka <jan.kiszka@web.de>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/kernel/apic/hw_nmi.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index 5c4f952..ef4755d 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -49,7 +49,7 @@ arch_trigger_all_cpu_backtrace_handler(struct notifier_block *self,
 {
 	struct die_args *args = __args;
 	struct pt_regs *regs;
-	int cpu = smp_processor_id();
+	int cpu;
 
 	switch (cmd) {
 	case DIE_NMI:
@@ -60,6 +60,7 @@ arch_trigger_all_cpu_backtrace_handler(struct notifier_block *self,
 	}
 
 	regs = args->regs;
+	cpu = smp_processor_id();
 
 	if (cpumask_test_cpu(cpu, to_cpumask(backtrace_mask))) {
 		static arch_spinlock_t lock = __ARCH_SPIN_LOCK_UNLOCKED;
-- 
1.7.3.2

