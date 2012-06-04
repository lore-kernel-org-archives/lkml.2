Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303Ab2FDFI5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 01:08:57 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:57731 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756078Ab2FDFIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 01:08:54 -0400
Subject: [PATCH v2 5/7] KVM: Introduce PV kick in flush tlb
To: peterz@infradead.org, mingo@elte.hu, mtosatti@redhat.com, avi@redhat.com
From: "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>
Cc: raghukt@linux.vnet.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, jeremy@goop.org,
        vatsa@linux.vnet.ibm.com, hpa@zytor.com
Date: Mon, 04 Jun 2012 10:38:17 +0530
Message-ID: <20120604050755.4560.24727.stgit@abhimanyu.in.ibm.com>
In-Reply-To: <20120604050223.4560.2874.stgit@abhimanyu.in.ibm.com>
References: <20120604050223.4560.2874.stgit@abhimanyu.in.ibm.com>
User-Agent: StGit/0.16-2-g0d85
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12060405-5816-0000-0000-000002FD78E7
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
 arch/x86/mm/tlb.c |   25 +++++++++++++++++--------
 1 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index f5dacdd..2c686bf 100644
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
@@ -167,6 +169,11 @@ out:
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
 
@@ -222,15 +229,17 @@ void kvm_flush_tlb_others(const struct cpumask *cpumask,
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
 
@@ -242,9 +251,6 @@ again:
 			}
 		}
 
-		if (cpumask_empty(to_cpumask(f->flush_cpumask)))
-			goto out;
-
 		apic->send_IPI_mask(to_cpumask(f->flush_cpumask),
 				    INVALIDATE_TLB_VECTOR_START + sender);
 
@@ -252,10 +258,13 @@ again:
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

