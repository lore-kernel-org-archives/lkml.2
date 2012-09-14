Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400Ab2INJ7Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 05:59:16 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:48190 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab2INJ7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 05:59:14 -0400
Message-ID: <5052FFEA.1040607@linux.vnet.ibm.com>
Date: Fri, 14 Sep 2012 17:59:06 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 4/5] KVM: MMU: introduce page_fault_start and page_fault_end
References: <5052FF61.3070600@linux.vnet.ibm.com>
In-Reply-To: <5052FF61.3070600@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12091409-5564-0000-0000-000004765604
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrap the common operations into these two functions

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c         |   53 +++++++++++++++++++++++++++----------------
 arch/x86/kvm/paging_tmpl.h |   16 +++++--------
 2 files changed, 39 insertions(+), 30 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 29ce28b..7e7b8cd 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2825,6 +2825,29 @@ exit:
 static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
 			 gva_t gva, pfn_t *pfn, bool write, bool *writable);

+static bool
+page_fault_start(struct kvm_vcpu *vcpu, gfn_t *gfnp, pfn_t *pfnp, int *levelp,
+		 bool force_pt_level, unsigned long mmu_seq)
+{
+	spin_lock(&vcpu->kvm->mmu_lock);
+	if (mmu_notifier_retry(vcpu, mmu_seq))
+		return false;
+
+	kvm_mmu_free_some_pages(vcpu);
+	if (likely(!force_pt_level))
+		transparent_hugepage_adjust(vcpu, gfnp, pfnp, levelp);
+
+	return true;
+}
+
+static void page_fault_end(struct kvm_vcpu *vcpu, pfn_t pfn)
+{
+	spin_unlock(&vcpu->kvm->mmu_lock);
+
+	if (!is_error_pfn(pfn))
+		kvm_release_pfn_clean(pfn);
+}
+
 static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, u32 error_code,
 			 gfn_t gfn, bool prefault)
 {
@@ -2862,22 +2885,17 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, u32 error_code,
 	if (handle_abnormal_pfn(vcpu, v, gfn, pfn, ACC_ALL, &r))
 		return r;

-	spin_lock(&vcpu->kvm->mmu_lock);
-	if (mmu_notifier_retry(vcpu, mmu_seq)) {
+	if (!page_fault_start(vcpu, &gfn, &pfn, &level, force_pt_level,
+	      mmu_seq)) {
 		r = 0;
-		goto out_unlock;
+		goto exit;
 	}

-	kvm_mmu_free_some_pages(vcpu);
-	if (likely(!force_pt_level))
-		transparent_hugepage_adjust(vcpu, &gfn, &pfn, &level);
 	r = __direct_map(vcpu, v, write, map_writable, level, gfn, pfn,
 			 prefault);

-out_unlock:
-	spin_unlock(&vcpu->kvm->mmu_lock);
-	if (!is_error_pfn(pfn))
-		kvm_release_pfn_clean(pfn);
+exit:
+	page_fault_end(vcpu, pfn);
 	return r;
 }

@@ -3331,22 +3349,17 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa, u32 error_code,
 	if (handle_abnormal_pfn(vcpu, 0, gfn, pfn, ACC_ALL, &r))
 		return r;

-	spin_lock(&vcpu->kvm->mmu_lock);
-	if (mmu_notifier_retry(vcpu, mmu_seq)) {
+	if (!page_fault_start(vcpu, &gfn, &pfn, &level, force_pt_level,
+	      mmu_seq)) {
 		r = 0;
-		goto out_unlock;
+		goto exit;
 	}

-	kvm_mmu_free_some_pages(vcpu);
-	if (likely(!force_pt_level))
-		transparent_hugepage_adjust(vcpu, &gfn, &pfn, &level);
 	r = __direct_map(vcpu, gpa, write, map_writable,
 			 level, gfn, pfn, prefault);

-out_unlock:
-	spin_unlock(&vcpu->kvm->mmu_lock);
-	if (!is_error_pfn(pfn))
-		kvm_release_pfn_clean(pfn);
+exit:
+	page_fault_end(vcpu, pfn);
 	return r;
 }

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 0adf376..1a738c5 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -624,26 +624,22 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
 				walker.gfn, pfn, walker.pte_access, &r))
 		return r;

-	spin_lock(&vcpu->kvm->mmu_lock);
-	if (mmu_notifier_retry(vcpu, mmu_seq)) {
+	if (!page_fault_start(vcpu, &walker.gfn, &pfn, &level,
+	      force_pt_level, mmu_seq)) {
 		r = 0;
-		goto out_unlock;
+		goto exit;
 	}

 	kvm_mmu_audit(vcpu, AUDIT_PRE_PAGE_FAULT);
-	kvm_mmu_free_some_pages(vcpu);
-	if (!force_pt_level)
-		transparent_hugepage_adjust(vcpu, &walker.gfn, &pfn, &level);
+
 	r = FNAME(fetch)(vcpu, addr, &walker, user_fault, write_fault,
 			 level, pfn, map_writable, prefault);

 	++vcpu->stat.pf_fixed;
 	kvm_mmu_audit(vcpu, AUDIT_POST_PAGE_FAULT);

-out_unlock:
-	spin_unlock(&vcpu->kvm->mmu_lock);
-	if (!is_error_pfn(pfn))
-		kvm_release_pfn_clean(pfn);
+exit:
+	page_fault_end(vcpu, pfn);
 	return r;
 }

-- 
1.7.7.6

