Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620Ab2BTIIy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 03:08:54 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:57493 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab2BTIIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 03:08:52 -0500
From: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com,
        bharata@linux.vnet.ibm.com
Subject: Re: [RFC PATCH 0/4] Gang scheduling in CFS
In-Reply-To: <20120105091059.GA3249@elte.hu>
References: <20111230095147.GA10543@elte.hu> <878vlu4bgh.fsf@linux.vnet.ibm.com> <87pqf5mqg4.fsf@abhimanyu.in.ibm.com> <4F017AD2.3090504@redhat.com> <87mxa3zqm1.fsf@abhimanyu.in.ibm.com> <4F046536.5080207@redhat.com> <4F048295.1050907@redhat.com> <4F04898B.1080600@redhat.com> <1325712710.3084.10.camel@laptop> <4F04C789.40209@redhat.com> <20120105091059.GA3249@elte.hu>
User-Agent: Notmuch/0.10.2+70~gf0e0053 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-redhat-linux-gnu)
Date: Mon, 20 Feb 2012 13:38:28 +0530
Message-ID: <87fwe6ork3.fsf@abhimanyu.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12021922-3568-0000-0000-0000013CA0F8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jan 2012 10:10:59 +0100, Ingo Molnar <mingo@elte.hu> wrote:
> 
> * Avi Kivity <avi@redhat.com> wrote:
> 
> > > So why wait for non-running vcpus at all? That is, why not 
> > > paravirt the TLB flush such that the invalidate marks the 
> > > non-running VCPU's state so that on resume it will first 
> > > flush its TLBs. That way you don't have to wake it up and 
> > > wait for it to invalidate its TLBs.
> > 
> > That's what Xen does, but it's tricky.  For example 
> > get_user_pages_fast() depends on the IPI to hold off page 
> > freeing, if we paravirt it we have to take that into 
> > consideration.
> > 
> > > Or am I like totally missing the point (I am after all 
> > > reading the thread backwards and I haven't yet fully paged 
> > > the kernel stuff back into my brain).
> > 
> > You aren't, and I bet those kernel pages are unswappable 
> > anyway.
> > 
> > > I guess tagging remote VCPU state like that might be 
> > > somewhat tricky.. but it seems worth considering, the whole 
> > > wake and wait for flush thing seems daft.
> > 
> > It's nasty, but then so is paravirt.  It's hard to get right, 
> > and it has a tendency to cause performance regressions as 
> > hardware improves.
> 
> Here it would massively improve performance - without regressing 
> the scheduler code massively.
> 
I tried doing an experiment with the flush_tlb_others_ipi. This depends
on Raghu's "kvm : Paravirt-spinlock support for KVM guests"
(https://lkml.org/lkml/2012/1/14/66), which has new hypercall for
kicking another vcpu out of halt.

  Here are the results from non-PLE hardware. Running ebizzy
  workload inside the VMs. The table shows the ebizzy score -
  Records/sec.

  8CPU Intel Xeon, HT disabled, 64 bit VM(8vcpu, 1G RAM)

  +--------+------------+------------+-------------+
  |        |  baseline  |   gang     |   pv_flush  |
  +--------+------------+------------+-------------+
  |   2VM  |   3979.50  |   8818.00  |   11002.50  |
  |   4VM  |   1817.50  |   6236.50  |    6196.75  |
  |   8VM  |    922.12  |   4043.00  |    4001.38  |
  +--------+------------+------------+-------------+

I will be posting the results for PLE hardware as well.

Here is the patch, this still needs to be hooked with the pv_mmu_ops. So,

Not-yet-Signed-off-by: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>

Index: linux-tip-f4ab688-pv/arch/x86/mm/tlb.c
===================================================================
--- linux-tip-f4ab688-pv.orig/arch/x86/mm/tlb.c	2012-02-14 18:26:21.000000000 +0800
+++ linux-tip-f4ab688-pv/arch/x86/mm/tlb.c	2012-02-20 15:23:10.242576314 +0800
@@ -43,6 +43,7 @@ union smp_flush_state {
 		struct mm_struct *flush_mm;
 		unsigned long flush_va;
 		raw_spinlock_t tlbstate_lock;
+		int sender_cpu;
 		DECLARE_BITMAP(flush_cpumask, NR_CPUS);
 	};
 	char pad[INTERNODE_CACHE_BYTES];
@@ -116,6 +117,9 @@ EXPORT_SYMBOL_GPL(leave_mm);
  *
  * Interrupts are disabled.
  */
+#ifdef CONFIG_PARAVIRT_FLUSH_TLB
+extern void kvm_kick_cpu(int cpu);
+#endif
 
 /*
  * FIXME: use of asmlinkage is not consistent.  On x86_64 it's noop
@@ -166,6 +170,10 @@ out:
 	smp_mb__before_clear_bit();
 	cpumask_clear_cpu(cpu, to_cpumask(f->flush_cpumask));
 	smp_mb__after_clear_bit();
+#ifdef CONFIG_PARAVIRT_FLUSH_TLB
+	if (cpumask_empty(to_cpumask(f->flush_cpumask)))
+		kvm_kick_cpu(f->sender_cpu);
+#endif
 	inc_irq_stat(irq_tlb_count);
 }
 
@@ -184,7 +192,10 @@ static void flush_tlb_others_ipi(const s
 
 	f->flush_mm = mm;
 	f->flush_va = va;
+	f->sender_cpu = smp_processor_id();
 	if (cpumask_andnot(to_cpumask(f->flush_cpumask), cpumask, cpumask_of(smp_processor_id()))) {
+		int loop = 1024;
+
 		/*
 		 * We have to send the IPI only to
 		 * CPUs affected.
@@ -192,8 +203,15 @@ static void flush_tlb_others_ipi(const s
 		apic->send_IPI_mask(to_cpumask(f->flush_cpumask),
 			      INVALIDATE_TLB_VECTOR_START + sender);
 
+#ifdef CONFIG_PARAVIRT_FLUSH_TLB
+		while (!cpumask_empty(to_cpumask(f->flush_cpumask)) && --loop)
+			cpu_relax();
+		if (!loop && !cpumask_empty(to_cpumask(f->flush_cpumask)))
+			halt();
+#else
 		while (!cpumask_empty(to_cpumask(f->flush_cpumask)))
 			cpu_relax();
+#endif
 	}
 
 	f->flush_mm = NULL;
Index: linux-tip-f4ab688-pv/arch/x86/kernel/kvm.c
===================================================================
--- linux-tip-f4ab688-pv.orig/arch/x86/kernel/kvm.c	2012-02-14 18:26:55.000000000 +0800
+++ linux-tip-f4ab688-pv/arch/x86/kernel/kvm.c	2012-02-14 18:26:55.178450933 +0800
@@ -653,16 +653,17 @@ out:
 PV_CALLEE_SAVE_REGS_THUNK(kvm_lock_spinning);
 
 /* Kick a cpu by its apicid*/
-static inline void kvm_kick_cpu(int apicid)
+void kvm_kick_cpu(int cpu)
 {
+	int apicid = per_cpu(x86_cpu_to_apicid, cpu);
 	kvm_hypercall1(KVM_HC_KICK_CPU, apicid);
 }
+EXPORT_SYMBOL_GPL(kvm_kick_cpu);
 
 /* Kick vcpu waiting on @lock->head to reach value @ticket */
 static void kvm_unlock_kick(struct arch_spinlock *lock, __ticket_t ticket)
 {
 	int cpu;
-	int apicid;
 
 	add_stats(RELEASED_SLOW, 1);
 
@@ -671,8 +672,7 @@ static void kvm_unlock_kick(struct arch_
 		if (ACCESS_ONCE(w->lock) == lock &&
 		    ACCESS_ONCE(w->want) == ticket) {
 			add_stats(RELEASED_SLOW_KICKED, 1);
-			apicid = per_cpu(x86_cpu_to_apicid, cpu);
-			kvm_kick_cpu(apicid);
+			kvm_kick_cpu(cpu);
 			break;
 		}
 	}

