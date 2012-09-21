Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862Ab2IUHAf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 03:00:35 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:40454 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755136Ab2IUHAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 03:00:32 -0400
Message-ID: <505C1083.4070102@linux.vnet.ibm.com>
Date: Fri, 21 Sep 2012 15:00:19 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v3 7/7] KVM: MMU: introduce page_fault_start/page_fault_end
References: <505C0FA8.5070007@linux.vnet.ibm.com>
In-Reply-To: <505C0FA8.5070007@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12092107-9574-0000-0000-0000048538C5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrap the common operations into these two functions

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c         |   55 ++++++++++++++++++++++++++++----------------
 arch/x86/kvm/paging_tmpl.h |   12 ++++-----
 2 files changed, 40 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index a455c0d..d75bf9a 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2848,6 +2848,31 @@ exit:
 static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
 			 gva_t gva, pfn_t *pfn, bool write, bool *writable);

+static bool
+page_fault_start(struct kvm_vcpu *vcpu, gfn_t *gfnp, pfn_t *pfnp, int *levelp,
+		 bool force_pt_level, unsigned long mmu_seq)
+	__acquires(vcpu->kvm->mmu_lock)
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
+	__releases(vcpu->kvm->mmu_lock)
+{
+	spin_unlock(&vcpu->kvm->mmu_lock);
+
+	if (likely(!is_noslot_pfn(pfn)))
+		kvm_release_pfn_clean(pfn);
+}
+
 static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, u32 error_code,
 			 gfn_t gfn, bool prefault)
 {
@@ -2885,22 +2910,17 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, u32 error_code,
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
-	if (likely(!is_noslot_pfn(pfn)))
-		kvm_release_pfn_clean(pfn);
+exit:
+	page_fault_end(vcpu, pfn);
 	return r;
 }

@@ -3354,22 +3374,17 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa, u32 error_code,
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
-	if (likely(!is_noslot_pfn(pfn)))
-		kvm_release_pfn_clean(pfn);
+exit:
+	page_fault_end(vcpu, pfn);
 	return r;
 }

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 298e5c2..269116d 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -597,10 +597,10 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
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
@@ -613,10 +613,8 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
 	++vcpu->stat.pf_fixed;
 	kvm_mmu_audit(vcpu, AUDIT_POST_PAGE_FAULT);

-out_unlock:
-	spin_unlock(&vcpu->kvm->mmu_lock);
-	if (likely(!is_noslot_pfn(pfn)))
-		kvm_release_pfn_clean(pfn);
+exit:
+	page_fault_end(vcpu, pfn);
 	return r;
 }

-- 
1.7.7.6

