Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082Ab2G2IU1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 04:20:27 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:34632 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab2G2IUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 04:20:22 -0400
Message-ID: <5014F23F.9030806@linux.vnet.ibm.com>
Date: Sun, 29 Jul 2012 16:20:15 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 9/9] KVM: do not release the error page
References: <5014F053.8020305@linux.vnet.ibm.com>
In-Reply-To: <5014F053.8020305@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12072908-9574-0000-0000-000003C14C5F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit a2766325cf9f9, the error page is replaced by the
error code, it need not be released anymore

[ The patch is compiling tested for powerpc ]

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/powerpc/kvm/44x_tlb.c   |    1 -
 arch/powerpc/kvm/book3s_pr.c |    4 +---
 arch/x86/kvm/svm.c           |    1 -
 arch/x86/kvm/vmx.c           |    5 ++---
 arch/x86/kvm/x86.c           |    9 +++------
 include/linux/kvm_host.h     |    2 +-
 virt/kvm/async_pf.c          |    4 ++--
 virt/kvm/kvm_main.c          |    5 +++--
 8 files changed, 12 insertions(+), 19 deletions(-)

diff --git a/arch/powerpc/kvm/44x_tlb.c b/arch/powerpc/kvm/44x_tlb.c
index 33aa715..5dd3ab4 100644
--- a/arch/powerpc/kvm/44x_tlb.c
+++ b/arch/powerpc/kvm/44x_tlb.c
@@ -319,7 +319,6 @@ void kvmppc_mmu_map(struct kvm_vcpu *vcpu, u64 gvaddr, gpa_t gpaddr,
 	if (is_error_page(new_page)) {
 		printk(KERN_ERR "Couldn't get guest page for gfn %llx!\n",
 			(unsigned long long)gfn);
-		kvm_release_page_clean(new_page);
 		return;
 	}
 	hpaddr = page_to_phys(new_page);
diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
index a1baec3..05c28f5 100644
--- a/arch/powerpc/kvm/book3s_pr.c
+++ b/arch/powerpc/kvm/book3s_pr.c
@@ -242,10 +242,8 @@ static void kvmppc_patch_dcbz(struct kvm_vcpu *vcpu, struct kvmppc_pte *pte)
 	int i;

 	hpage = gfn_to_page(vcpu->kvm, pte->raddr >> PAGE_SHIFT);
-	if (is_error_page(hpage)) {
-		kvm_release_page_clean(hpage);
+	if (is_error_page(hpage))
 		return;
-	}

 	hpage_offset = pte->raddr & ~PAGE_MASK;
 	hpage_offset &= ~0xFFFULL;
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 687d0c3..31be4a5 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2105,7 +2105,6 @@ static void *nested_svm_map(struct vcpu_svm *svm, u64 gpa, struct page **_page)
 	return kmap(page);

 error:
-	kvm_release_page_clean(page);
 	kvm_inject_gp(&svm->vcpu, 0);

 	return NULL;
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 2300e53..4b6e809 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -596,10 +596,9 @@ static inline struct vmcs12 *get_vmcs12(struct kvm_vcpu *vcpu)
 static struct page *nested_get_page(struct kvm_vcpu *vcpu, gpa_t addr)
 {
 	struct page *page = gfn_to_page(vcpu->kvm, addr >> PAGE_SHIFT);
-	if (is_error_page(page)) {
-		kvm_release_page_clean(page);
+	if (is_error_page(page))
 		return NULL;
-	}
+
 	return page;
 }

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b6379e5..3c94d80 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1635,10 +1635,9 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 		vcpu->arch.time_page =
 				gfn_to_page(vcpu->kvm, data >> PAGE_SHIFT);

-		if (is_error_page(vcpu->arch.time_page)) {
-			kvm_release_page_clean(vcpu->arch.time_page);
+		if (is_error_page(vcpu->arch.time_page))
 			vcpu->arch.time_page = NULL;
-		}
+
 		break;
 	}
 	case MSR_KVM_ASYNC_PF_EN:
@@ -3941,10 +3940,8 @@ static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
 		goto emul_write;

 	page = gfn_to_page(vcpu->kvm, gpa >> PAGE_SHIFT);
-	if (is_error_page(page)) {
-		kvm_release_page_clean(page);
+	if (is_error_page(page))
 		goto emul_write;
-	}

 	kaddr = kmap_atomic(page);
 	kaddr += offset_in_page(gpa);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 08a9da9..76242a1 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -458,7 +458,7 @@ pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t gfn);
 pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
 		      bool *writable);
 pfn_t gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn);
-void kvm_release_pfn_dirty(pfn_t);
+void kvm_release_pfn_dirty(pfn_t pfn);
 void kvm_release_pfn_clean(pfn_t pfn);
 void kvm_set_pfn_dirty(pfn_t pfn);
 void kvm_set_pfn_accessed(pfn_t pfn);
diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
index aa38af6..1f434ef 100644
--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -111,7 +111,7 @@ void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu)
 			list_entry(vcpu->async_pf.done.next,
 				   typeof(*work), link);
 		list_del(&work->link);
-		if (work->page)
+		if (!is_error_page(work->page))
 			kvm_release_page_clean(work->page);
 		kmem_cache_free(async_pf_cache, work);
 	}
@@ -138,7 +138,7 @@ void kvm_check_async_pf_completion(struct kvm_vcpu *vcpu)

 		list_del(&work->queue);
 		vcpu->async_pf.queued--;
-		if (work->page)
+		if (!is_error_page(work->page))
 			kvm_release_page_clean(work->page);
 		kmem_cache_free(async_pf_cache, work);
 	}
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 0c29714..9eadb58 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1195,8 +1195,9 @@ EXPORT_SYMBOL_GPL(gfn_to_page);

 void kvm_release_page_clean(struct page *page)
 {
-	if (!is_error_page(page))
-		kvm_release_pfn_clean(page_to_pfn(page));
+	WARN_ON(is_error_page(page));
+
+	kvm_release_pfn_clean(page_to_pfn(page));
 }
 EXPORT_SYMBOL_GPL(kvm_release_page_clean);

-- 
1.7.7.6

