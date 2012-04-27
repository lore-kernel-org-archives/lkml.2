Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760770Ab2D0Q1l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 12:27:41 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:39896 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760750Ab2D0Q1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 12:27:39 -0400
Subject: [RFC PATCH v1 5/5] KVM: Introduce PV kick in flush tlb
To: peterz@infradead.org, mingo@elte.hu
From: "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>
Cc: jeremy@goop.org, mtosatti@redhat.com, kvm@vger.kernel.org, x86@kernel.org,
        vatsa@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, avi@redhat.com,
        hpa@zytor.com
Date: Fri, 27 Apr 2012 21:57:05 +0530
Message-ID: <20120427162646.27082.6948.stgit@abhimanyu>
In-Reply-To: <20120427161727.27082.43096.stgit@abhimanyu>
References: <20120427161727.27082.43096.stgit@abhimanyu>
User-Agent: StGit/0.16-2-g0d85
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12042716-8256-0000-0000-0000022A82A0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In place of looping continuously introduce a halt if we do not succeed
after some time.

For vcpus that were running an IPI is sent.  In case, it went to sleep
between this, we will be doing flush_on_enter(harmless). But as a
flush IPI was already sent, that will be processed in ipi handler,
this might result into something undesireable, i.e. It might clear the
flush_mask of a new request.

So after sending an IPI and waiting for a while, do a halt and wait
for a kick from the last vcpu.

Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Signed-off-by: Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>
---
 arch/x86/mm/tlb.c |   27 +++++++++++++++++++--------
 1 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 91ae34e..2a20e59 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -43,6 +43,8 @@ union smp_flush_state {
 	struct {
 		struct mm_struct *flush_mm;
 		unsigned long flush_va;
+		int sender_cpu;
+		unsigned int need_kick;
 		raw_spinlock_t tlbstate_lock;
 		DECLARE_BITMAP(flush_cpumask, NR_CPUS);
 	};
@@ -71,6 +73,8 @@ void leave_mm(int cpu)
 EXPORT_SYMBOL_GPL(leave_mm);
 
 DECLARE_PER_CPU(struct kvm_vcpu_state, vcpu_state) __aligned(64);
+extern void kvm_kick_cpu(int cpu);
+
 /*
  *
  * The flush IPI assumes that a thread switch happens in this order:
@@ -168,6 +172,11 @@ out:
 	smp_mb__before_clear_bit();
 	cpumask_clear_cpu(cpu, to_cpumask(f->flush_cpumask));
 	smp_mb__after_clear_bit();
+	if (f->need_kick && cpumask_empty(to_cpumask(f->flush_cpumask))) {
+		f->need_kick = 0;
+		smp_wmb();
+		kvm_kick_cpu(f->sender_cpu);
+	}
 	inc_irq_stat(irq_tlb_count);
 }
 
@@ -219,15 +228,17 @@ void kvm_flush_tlb_others(const struct cpumask *cpumask,
 	if (nr_cpu_ids > NUM_INVALIDATE_TLB_VECTORS)
 		raw_spin_lock(&f->tlbstate_lock);
 
+	cpu = smp_processor_id();
 	f->flush_mm = mm;
 	f->flush_va = va;
-	if (cpumask_andnot(to_cpumask(f->flush_cpumask), cpumask, cpumask_of(smp_processor_id()))) {
+	f->sender_cpu = cpu;
+	f->need_kick = 0;
+	if (cpumask_andnot(to_cpumask(f->flush_cpumask), cpumask, cpumask_of(cpu))) {
 		/*
 		 * We have to send the IPI only to online vCPUs
 		 * affected. And queue flush_on_enter for pre-empted
 		 * vCPUs
 		 */
-again:
 		for_each_cpu(cpu, to_cpumask(f->flush_cpumask)) {
 			v_state = &per_cpu(vcpu_state, cpu);
 
@@ -239,9 +250,6 @@ again:
 			}
 		}
 
-		if (cpumask_empty(to_cpumask(f->flush_cpumask)))
-			goto out;
-
 		apic->send_IPI_mask(to_cpumask(f->flush_cpumask),
 				    INVALIDATE_TLB_VECTOR_START + sender);
 
@@ -249,10 +257,13 @@ again:
 		while (!cpumask_empty(to_cpumask(f->flush_cpumask)) && --loop)
 			cpu_relax();
 
-		if (!cpumask_empty(to_cpumask(f->flush_cpumask)))
-			goto again;
+		if (!loop) {
+			f->need_kick = 1;
+			smp_mb();
+			while (!cpumask_empty(to_cpumask(f->flush_cpumask)))
+				halt();
+		}
 	}
-out:
 	f->flush_mm = NULL;
 	f->flush_va = 0;
 	if (nr_cpu_ids > NUM_INVALIDATE_TLB_VECTORS)

