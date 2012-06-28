Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932450Ab2F1GHz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 02:07:55 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:47679 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932372Ab2F1GHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 02:07:50 -0400
X-AuditID: b753bd60-982efba000000f6c-c7-4febf4b408ba
X-AuditID: b753bd60-982efba000000f6c-c7-4febf4b408ba
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Subject: [RFC PATCH 04/18] KVM: Replace local_irq_disable/enable with
 local_irq_save/restore
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 28 Jun 2012 15:07:40 +0900
Message-ID: <20120628060740.19298.69063.stgit@localhost.localdomain>
In-Reply-To: <20120628060719.19298.43879.stgit@localhost.localdomain>
References: <20120628060719.19298.43879.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace local_irq_disable/enable with local_irq_save/restore in the path
where is executed on slave CPUs. This is required because irqs are disabled
while the guest is running on the slave CPUs.

Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---

 arch/x86/kvm/mmu.c |   20 ++++++++++++--------
 arch/x86/kvm/vmx.c |    5 +++--
 arch/x86/kvm/x86.c |    7 ++++---
 arch/x86/mm/gup.c  |    7 ++++---
 4 files changed, 23 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index be3cea4..6139e1d 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -549,13 +549,14 @@ static u64 mmu_spte_get_lockless(u64 *sptep)
 	return __get_spte_lockless(sptep);
 }
 
-static void walk_shadow_page_lockless_begin(struct kvm_vcpu *vcpu)
+static void walk_shadow_page_lockless_begin(struct kvm_vcpu *vcpu,
+					    unsigned long *flags)
 {
 	/*
 	 * Prevent page table teardown by making any free-er wait during
 	 * kvm_flush_remote_tlbs() IPI to all active vcpus.
 	 */
-	local_irq_disable();
+	local_irq_save(*flags);
 	vcpu->mode = READING_SHADOW_PAGE_TABLES;
 	/*
 	 * Make sure a following spte read is not reordered ahead of the write
@@ -564,7 +565,8 @@ static void walk_shadow_page_lockless_begin(struct kvm_vcpu *vcpu)
 	smp_mb();
 }
 
-static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
+static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu,
+					  unsigned long *flags)
 {
 	/*
 	 * Make sure the write to vcpu->mode is not reordered in front of
@@ -573,7 +575,7 @@ static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
 	 */
 	smp_mb();
 	vcpu->mode = OUTSIDE_GUEST_MODE;
-	local_irq_enable();
+	local_irq_restore(*flags);
 }
 
 static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
@@ -2959,12 +2961,13 @@ static u64 walk_shadow_page_get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr)
 {
 	struct kvm_shadow_walk_iterator iterator;
 	u64 spte = 0ull;
+	unsigned long flags;
 
-	walk_shadow_page_lockless_begin(vcpu);
+	walk_shadow_page_lockless_begin(vcpu, &flags);
 	for_each_shadow_entry_lockless(vcpu, addr, iterator, spte)
 		if (!is_shadow_present_pte(spte))
 			break;
-	walk_shadow_page_lockless_end(vcpu);
+	walk_shadow_page_lockless_end(vcpu, &flags);
 
 	return spte;
 }
@@ -4043,15 +4046,16 @@ int kvm_mmu_get_spte_hierarchy(struct kvm_vcpu *vcpu, u64 addr, u64 sptes[4])
 	struct kvm_shadow_walk_iterator iterator;
 	u64 spte;
 	int nr_sptes = 0;
+	unsigned long flags;
 
-	walk_shadow_page_lockless_begin(vcpu);
+	walk_shadow_page_lockless_begin(vcpu, &flags);
 	for_each_shadow_entry_lockless(vcpu, addr, iterator, spte) {
 		sptes[iterator.level-1] = spte;
 		nr_sptes++;
 		if (!is_shadow_present_pte(spte))
 			break;
 	}
-	walk_shadow_page_lockless_end(vcpu);
+	walk_shadow_page_lockless_end(vcpu, &flags);
 
 	return nr_sptes;
 }
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 32eb588..6ea77e4 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1516,12 +1516,13 @@ static void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	if (vmx->loaded_vmcs->cpu != cpu) {
 		struct desc_ptr *gdt = &__get_cpu_var(host_gdt);
 		unsigned long sysenter_esp;
+		unsigned long flags;
 
 		kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
-		local_irq_disable();
+		local_irq_save(flags);
 		list_add(&vmx->loaded_vmcs->loaded_vmcss_on_cpu_link,
 			 &per_cpu(loaded_vmcss_on_cpu, cpu));
-		local_irq_enable();
+		local_irq_restore(flags);
 
 		/*
 		 * Linux uses per-cpu TSS and GDT, so set these when switching
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index be6d549..4a69c66 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5229,6 +5229,7 @@ static void process_nmi(struct kvm_vcpu *vcpu)
 static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 {
 	int r;
+	unsigned long flags;
 	bool req_int_win = !irqchip_in_kernel(vcpu->kvm) &&
 		vcpu->run->request_interrupt_window;
 	bool req_immediate_exit = 0;
@@ -5314,13 +5315,13 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	 */
 	smp_mb();
 
-	local_irq_disable();
+	local_irq_save(flags);
 
 	if (vcpu->mode == EXITING_GUEST_MODE || vcpu->requests
 	    || need_resched() || signal_pending(current)) {
 		vcpu->mode = OUTSIDE_GUEST_MODE;
 		smp_wmb();
-		local_irq_enable();
+		local_irq_restore(flags);
 		preempt_enable();
 		kvm_x86_ops->cancel_injection(vcpu);
 		r = 1;
@@ -5359,7 +5360,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 	vcpu->mode = OUTSIDE_GUEST_MODE;
 	smp_wmb();
-	local_irq_enable();
+	local_irq_restore(flags);
 
 	++vcpu->stat.exits;
 
diff --git a/arch/x86/mm/gup.c b/arch/x86/mm/gup.c
index dd74e46..6679525 100644
--- a/arch/x86/mm/gup.c
+++ b/arch/x86/mm/gup.c
@@ -315,6 +315,7 @@ int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 	struct mm_struct *mm = current->mm;
 	unsigned long addr, len, end;
 	unsigned long next;
+	unsigned long flags;
 	pgd_t *pgdp;
 	int nr = 0;
 
@@ -349,7 +350,7 @@ int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 	 * (which we do on x86, with the above PAE exception), we can follow the
 	 * address down to the the page and take a ref on it.
 	 */
-	local_irq_disable();
+	local_irq_save(flags);
 	pgdp = pgd_offset(mm, addr);
 	do {
 		pgd_t pgd = *pgdp;
@@ -360,7 +361,7 @@ int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 		if (!gup_pud_range(pgd, addr, next, write, pages, &nr))
 			goto slow;
 	} while (pgdp++, addr = next, addr != end);
-	local_irq_enable();
+	local_irq_restore(flags);
 
 	VM_BUG_ON(nr != (end - start) >> PAGE_SHIFT);
 	return nr;
@@ -369,7 +370,7 @@ int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 		int ret;
 
 slow:
-		local_irq_enable();
+		local_irq_restore(flags);
 slow_irqon:
 		/* Try to get the remaining pages with get_user_pages */
 		start += nr << PAGE_SHIFT;


