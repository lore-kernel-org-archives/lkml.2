Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678Ab0KLG7w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 01:59:52 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52951 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751771Ab0KLG7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 01:59:49 -0500
Message-ID: <4CDCE3C2.9030107@cn.fujitsu.com>
Date: Fri, 12 Nov 2010 14:50:42 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 5/5] KVM: MMU: retry #PF for softmmu
References: <4CDCE2B0.7000601@cn.fujitsu.com>
In-Reply-To: <4CDCE2B0.7000601@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-12 14:46:49,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-12 15:00:14,
	Serialize complete at 2010-11-12 15:00:14
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Retry #PF for softmmu only when the current vcpu has the same
root shadow page as the time when #PF occurs. it means they
have same paging environment

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/include/asm/kvm_host.h |    6 ++++++
 arch/x86/kvm/mmu.c              |   35 ++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/x86.c              |   15 ++++++++++++++-
 virt/kvm/async_pf.c             |    1 +
 4 files changed, 55 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b04c0fa..2cefe00 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -192,6 +192,8 @@ struct kvm_mmu_page {
 	struct list_head link;
 	struct hlist_node hash_link;
 
+	struct kref apfs_counter;
+
 	/*
 	 * The following two entries are used to key the shadow page in the
 	 * hash table.
@@ -600,6 +602,7 @@ struct kvm_x86_ops {
 struct kvm_arch_async_pf {
 	u32 token;
 	gfn_t gfn;
+	struct kvm_mmu_page *root_sp;
 	bool direct_map;
 };
 
@@ -698,6 +701,8 @@ void kvm_inject_nmi(struct kvm_vcpu *vcpu);
 
 int fx_init(struct kvm_vcpu *vcpu);
 
+struct kvm_mmu_page *get_vcpu_root_sp(struct kvm_vcpu *vcpu, gva_t gva);
+void kvm_mmu_release_apf_sp(struct kvm_mmu_page *sp);
 void kvm_mmu_flush_tlb(struct kvm_vcpu *vcpu);
 void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 		       const u8 *new, int bytes,
@@ -816,6 +821,7 @@ void kvm_set_shared_msr(unsigned index, u64 val, u64 mask);
 
 bool kvm_is_linear_rip(struct kvm_vcpu *vcpu, unsigned long linear_rip);
 
+void kvm_arch_clear_async_pf(struct kvm_async_pf *work);
 void kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
 				     struct kvm_async_pf *work);
 void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index bdb9fa9..4b6d54c 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -993,6 +993,19 @@ static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, int nr)
 	percpu_counter_add(&kvm_total_used_mmu_pages, nr);
 }
 
+static void free_shadow_page(struct kref *kref)
+{
+	struct kvm_mmu_page *sp;
+
+	sp = container_of(kref, struct kvm_mmu_page, apfs_counter);
+	kmem_cache_free(mmu_page_header_cache, sp);
+}
+
+void kvm_mmu_release_apf_sp(struct kvm_mmu_page *sp)
+{
+	kref_put(&sp->apfs_counter, free_shadow_page);
+}
+
 static void kvm_mmu_free_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	ASSERT(is_empty_shadow_page(sp->spt));
@@ -1001,7 +1014,7 @@ static void kvm_mmu_free_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 	__free_page(virt_to_page(sp->spt));
 	if (!sp->role.direct)
 		__free_page(virt_to_page(sp->gfns));
-	kmem_cache_free(mmu_page_header_cache, sp);
+	kvm_mmu_release_apf_sp(sp);
 	kvm_mod_used_mmu_pages(kvm, -1);
 }
 
@@ -1026,6 +1039,8 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu,
 	sp->multimapped = 0;
 	sp->parent_pte = parent_pte;
 	kvm_mod_used_mmu_pages(vcpu->kvm, +1);
+	kref_init(&sp->apfs_counter);
+
 	return sp;
 }
 
@@ -2603,13 +2618,31 @@ static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
 			     error_code & PFERR_WRITE_MASK, gfn, no_apf);
 }
 
+struct kvm_mmu_page *get_vcpu_root_sp(struct kvm_vcpu *vcpu, gva_t gva)
+{
+	struct kvm_shadow_walk_iterator iterator;
+	bool ret;
+
+	shadow_walk_init(&iterator, vcpu, gva);
+	ret = shadow_walk_okay(&iterator);
+	WARN_ON(!ret);
+
+	return page_header(__pa(iterator.sptep));
+}
+
 static int kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn)
 {
 	struct kvm_arch_async_pf arch;
+
 	arch.token = (vcpu->arch.apf.id++ << 12) | vcpu->vcpu_id;
 	arch.gfn = gfn;
 	arch.direct_map = vcpu->arch.mmu.direct_map;
 
+	if (!arch.direct_map) {
+		arch.root_sp = get_vcpu_root_sp(vcpu, gva);
+		kref_get(&arch.root_sp->apfs_counter);
+	}
+
 	return kvm_setup_async_pf(vcpu, gva, gfn, &arch);
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 003a0ca..1ecc1a9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6169,7 +6169,7 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 {
 	int r;
 
-	if (!vcpu->arch.mmu.direct_map || !work->arch.direct_map ||
+	if (vcpu->arch.mmu.direct_map != work->arch.direct_map ||
 	      is_error_page(work->page))
 		return;
 
@@ -6177,6 +6177,10 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 	if (unlikely(r))
 		return;
 
+	if (!vcpu->arch.mmu.direct_map &&
+	      get_vcpu_root_sp(vcpu, work->gva) != work->arch.root_sp)
+		return;
+
 	vcpu->arch.mmu.page_fault(vcpu, work->gva, 0, true);
 }
 
@@ -6248,6 +6252,12 @@ static int apf_put_user(struct kvm_vcpu *vcpu, u32 val)
 				      sizeof(val));
 }
 
+void kvm_arch_clear_async_pf(struct kvm_async_pf *work)
+{
+	if (!work->arch.direct_map)
+		kvm_mmu_release_apf_sp(work->arch.root_sp);
+}
+
 void kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
 				     struct kvm_async_pf *work)
 {
@@ -6269,6 +6279,9 @@ void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
 				 struct kvm_async_pf *work)
 {
 	trace_kvm_async_pf_ready(work->arch.token, work->gva);
+
+	kvm_arch_clear_async_pf(work);
+
 	if (is_error_page(work->page))
 		work->arch.token = ~0; /* broadcast wakeup */
 	else
diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
index 74268b4..c3d4788 100644
--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -101,6 +101,7 @@ void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu)
 				   typeof(*work), queue);
 		cancel_work_sync(&work->work);
 		list_del(&work->queue);
+		kvm_arch_clear_async_pf(work);
 		if (!work->done) /* work was canceled */
 			kmem_cache_free(async_pf_cache, work);
 	}
-- 
1.7.0.4

