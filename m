Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932259Ab1FVOdg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 10:33:36 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59151 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932242Ab1FVOde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 10:33:34 -0400
Message-ID: <4E01FDB4.60306@cn.fujitsu.com>
Date: Wed, 22 Jun 2011 22:35:32 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 19/22] KVM: MMU: lockless walking shadow page table
References: <4E01FBC9.3020009@cn.fujitsu.com>
In-Reply-To: <4E01FBC9.3020009@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-22 22:33:07,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-22 22:33:07,
	Serialize complete at 2011-06-22 22:33:07
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use rcu to protect shadow pages table to be freed, so we can safely walk it,
it should run fastly and is needed by mmio page fault

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/include/asm/kvm_host.h |    8 +++
 arch/x86/kvm/mmu.c              |  132 ++++++++++++++++++++++++++++++++++++---
 2 files changed, 132 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 42e577d..87a868e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -233,6 +233,12 @@ struct kvm_mmu_page {
 	unsigned int unsync_children;
 	unsigned long parent_ptes;	/* Reverse mapping for parent_pte */
 	DECLARE_BITMAP(unsync_child_bitmap, 512);
+
+#ifdef CONFIG_X86_32
+	int clear_spte_count;
+#endif
+
+	struct rcu_head rcu;
 };
 
 struct kvm_pv_mmu_op_buffer {
@@ -477,6 +483,8 @@ struct kvm_arch {
 	u64 hv_guest_os_id;
 	u64 hv_hypercall;
 
+	atomic_t reader_counter;
+
 	#ifdef CONFIG_KVM_MMU_AUDIT
 	int audit_point;
 	#endif
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 0ba94e9..dad7ad9 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -182,6 +182,12 @@ struct kvm_shadow_walk_iterator {
 	     shadow_walk_okay(&(_walker));			\
 	     shadow_walk_next(&(_walker)))
 
+#define for_each_shadow_entry_lockless(_vcpu, _addr, _walker, spte)	\
+	for (shadow_walk_init(&(_walker), _vcpu, _addr);		\
+	     shadow_walk_okay(&(_walker)) &&				\
+		({ spte = mmu_spte_get_lockless(_walker.sptep); 1; });	\
+	     __shadow_walk_next(&(_walker), spte))
+
 static struct kmem_cache *pte_list_desc_cache;
 static struct kmem_cache *mmu_page_header_cache;
 static struct percpu_counter kvm_total_used_mmu_pages;
@@ -274,6 +280,11 @@ static u64 __update_clear_spte_slow(u64 *sptep, u64 spte)
 {
 	return xchg(sptep, spte);
 }
+
+static u64 __get_spte_lockless(u64 *sptep)
+{
+	return ACCESS_ONCE(*sptep);
+}
 #else
 union split_spte {
 	struct {
@@ -283,6 +294,18 @@ union split_spte {
 	u64 spte;
 };
 
+static void count_spte_clear(u64 *sptep, u64 spte)
+{
+	struct kvm_mmu_page *sp =  page_header(__pa(sptep));
+
+	if (is_shadow_present_pte(spte))
+		return;
+
+	/* Ensure the spte is completely set before we increase the count */
+	smp_wmb();
+	sp->clear_spte_count++;
+}
+
 static void __set_spte(u64 *sptep, u64 spte)
 {
 	union split_spte *ssptep, sspte;
@@ -318,6 +341,7 @@ static void __update_clear_spte_fast(u64 *sptep, u64 spte)
 	smp_wmb();
 
 	ssptep->spte_high = sspte.spte_high;
+	count_spte_clear(sptep, spte);
 }
 
 static u64 __update_clear_spte_slow(u64 *sptep, u64 spte)
@@ -330,9 +354,40 @@ static u64 __update_clear_spte_slow(u64 *sptep, u64 spte)
 	/* xchg acts as a barrier before the setting of the high bits */
 	orig.spte_low = xchg(&ssptep->spte_low, sspte.spte_low);
 	orig.spte_high = ssptep->spte_high = sspte.spte_high;
+	count_spte_clear(sptep, spte);
 
 	return orig.spte;
 }
+
+/*
+ * The idea using the light way get the spte on x86_32 guest is from
+ * gup_get_pte(arch/x86/mm/gup.c).
+ * The difference is we can not catch the spte tlb flush if we leave
+ * guest mode, so we emulate it by increase clear_spte_count when spte
+ * is cleared.
+ */
+static u64 __get_spte_lockless(u64 *sptep)
+{
+	struct kvm_mmu_page *sp =  page_header(__pa(sptep));
+	union split_spte spte, *orig = (union split_spte *)sptep;
+	int count;
+
+retry:
+	count = sp->clear_spte_count;
+	smp_rmb();
+
+	spte.spte_low = orig->spte_low;
+	smp_rmb();
+
+	spte.spte_high = orig->spte_high;
+	smp_rmb();
+
+	if (unlikely(spte.spte_low != orig->spte_low ||
+	      count != sp->clear_spte_count))
+		goto retry;
+
+	return spte.spte;
+}
 #endif
 
 static bool spte_is_bit_cleared(u64 old_spte, u64 new_spte, u64 bit_mask)
@@ -438,6 +493,28 @@ static void mmu_spte_clear_no_track(u64 *sptep)
 	__update_clear_spte_fast(sptep, 0ull);
 }
 
+static u64 mmu_spte_get_lockless(u64 *sptep)
+{
+	return __get_spte_lockless(sptep);
+}
+
+static void walk_shadow_page_lockless_begin(struct kvm_vcpu *vcpu)
+{
+	rcu_read_lock();
+	atomic_inc(&vcpu->kvm->arch.reader_counter);
+
+	/* Increase the counter before walking shadow page table */
+	smp_mb__after_atomic_inc();
+}
+
+static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
+{
+	/* Decrease the counter after walking shadow page table finished */
+	smp_mb__before_atomic_dec();
+	atomic_dec(&vcpu->kvm->arch.reader_counter);
+	rcu_read_unlock();
+}
+
 static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
 				  struct kmem_cache *base_cache, int min)
 {
@@ -1600,17 +1677,23 @@ static bool shadow_walk_okay(struct kvm_shadow_walk_iterator *iterator)
 	return true;
 }
 
-static void shadow_walk_next(struct kvm_shadow_walk_iterator *iterator)
+static void __shadow_walk_next(struct kvm_shadow_walk_iterator *iterator,
+			       u64 spte)
 {
-	if (is_last_spte(*iterator->sptep, iterator->level)) {
+	if (is_last_spte(spte, iterator->level)) {
 		iterator->level = 0;
 		return;
 	}
 
-	iterator->shadow_addr = *iterator->sptep & PT64_BASE_ADDR_MASK;
+	iterator->shadow_addr = spte & PT64_BASE_ADDR_MASK;
 	--iterator->level;
 }
 
+static void shadow_walk_next(struct kvm_shadow_walk_iterator *iterator)
+{
+	return __shadow_walk_next(iterator, *iterator->sptep);
+}
+
 static void link_shadow_page(u64 *sptep, struct kvm_mmu_page *sp)
 {
 	u64 spte;
@@ -1757,6 +1840,30 @@ static int kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
 	return ret;
 }
 
+static void kvm_mmu_isolate_pages(struct list_head *invalid_list)
+{
+	struct kvm_mmu_page *sp;
+
+	list_for_each_entry(sp, invalid_list, link)
+		kvm_mmu_isolate_page(sp);
+}
+
+static void free_pages_rcu(struct rcu_head *head)
+{
+	struct kvm_mmu_page *next, *sp;
+
+	sp = container_of(head, struct kvm_mmu_page, rcu);
+	while (sp) {
+		if (!list_empty(&sp->link))
+			next = list_first_entry(&sp->link,
+				      struct kvm_mmu_page, link);
+		else
+			next = NULL;
+		kvm_mmu_free_page(sp);
+		sp = next;
+	}
+}
+
 static void kvm_mmu_commit_zap_page(struct kvm *kvm,
 				    struct list_head *invalid_list)
 {
@@ -1767,6 +1874,14 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
 
 	kvm_flush_remote_tlbs(kvm);
 
+	if (atomic_read(&kvm->arch.reader_counter)) {
+		kvm_mmu_isolate_pages(invalid_list);
+		sp = list_first_entry(invalid_list, struct kvm_mmu_page, link);
+		list_del_init(invalid_list);
+		call_rcu(&sp->rcu, free_pages_rcu);
+		return;
+	}
+
 	do {
 		sp = list_first_entry(invalid_list, struct kvm_mmu_page, link);
 		WARN_ON(!sp->role.invalid || sp->root_count);
@@ -3797,16 +3912,17 @@ out:
 int kvm_mmu_get_spte_hierarchy(struct kvm_vcpu *vcpu, u64 addr, u64 sptes[4])
 {
 	struct kvm_shadow_walk_iterator iterator;
+	u64 spte;
 	int nr_sptes = 0;
 
-	spin_lock(&vcpu->kvm->mmu_lock);
-	for_each_shadow_entry(vcpu, addr, iterator) {
-		sptes[iterator.level-1] = *iterator.sptep;
+	walk_shadow_page_lockless_begin(vcpu);
+	for_each_shadow_entry_lockless(vcpu, addr, iterator, spte) {
+		sptes[iterator.level-1] = spte;
 		nr_sptes++;
-		if (!is_shadow_present_pte(*iterator.sptep))
+		if (!is_shadow_present_pte(spte))
 			break;
 	}
-	spin_unlock(&vcpu->kvm->mmu_lock);
+	walk_shadow_page_lockless_end(vcpu);
 
 	return nr_sptes;
 }
-- 
1.7.5.4

