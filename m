Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653Ab2INJ6H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 05:58:07 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:34035 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756305Ab2INJ6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 05:58:04 -0400
Message-ID: <5052FF9F.5070400@linux.vnet.ibm.com>
Date: Fri, 14 Sep 2012 17:57:51 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 2/5] KVM: MMU: do not release pfn in mmu_set_spte
References: <5052FF61.3070600@linux.vnet.ibm.com>
In-Reply-To: <5052FF61.3070600@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12091409-5816-0000-0000-00000474B3A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It helps us to cleanup release pfn in the later patches

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c         |   29 ++++++++++++++---------------
 arch/x86/kvm/paging_tmpl.h |   18 +++++++++++-------
 2 files changed, 25 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index f74c63a..29ce28b 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2496,9 +2496,6 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 				rmap_recycle(vcpu, sptep, gfn);
 		}
 	}
-
-	if (!is_error_pfn(pfn))
-		kvm_release_pfn_clean(pfn);
 }

 static void nonpaging_new_cr3(struct kvm_vcpu *vcpu)
@@ -2535,12 +2532,15 @@ static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
 	if (ret <= 0)
 		return -1;

-	for (i = 0; i < ret; i++, gfn++, start++)
+	for (i = 0; i < ret; i++, gfn++, start++) {
 		mmu_set_spte(vcpu, start, ACC_ALL,
 			     access, 0, 0, NULL,
 			     sp->role.level, gfn,
 			     page_to_pfn(pages[i]), true, true);

+		kvm_release_page_clean(pages[i]);
+	}
+
 	return 0;
 }

@@ -2863,23 +2863,22 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, u32 error_code,
 		return r;

 	spin_lock(&vcpu->kvm->mmu_lock);
-	if (mmu_notifier_retry(vcpu, mmu_seq))
+	if (mmu_notifier_retry(vcpu, mmu_seq)) {
+		r = 0;
 		goto out_unlock;
+	}
+
 	kvm_mmu_free_some_pages(vcpu);
 	if (likely(!force_pt_level))
 		transparent_hugepage_adjust(vcpu, &gfn, &pfn, &level);
 	r = __direct_map(vcpu, v, write, map_writable, level, gfn, pfn,
 			 prefault);
-	spin_unlock(&vcpu->kvm->mmu_lock);
-
-
-	return r;

 out_unlock:
 	spin_unlock(&vcpu->kvm->mmu_lock);
 	if (!is_error_pfn(pfn))
 		kvm_release_pfn_clean(pfn);
-	return 0;
+	return r;
 }


@@ -3333,22 +3332,22 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa, u32 error_code,
 		return r;

 	spin_lock(&vcpu->kvm->mmu_lock);
-	if (mmu_notifier_retry(vcpu, mmu_seq))
+	if (mmu_notifier_retry(vcpu, mmu_seq)) {
+		r = 0;
 		goto out_unlock;
+	}
+
 	kvm_mmu_free_some_pages(vcpu);
 	if (likely(!force_pt_level))
 		transparent_hugepage_adjust(vcpu, &gfn, &pfn, &level);
 	r = __direct_map(vcpu, gpa, write, map_writable,
 			 level, gfn, pfn, prefault);
-	spin_unlock(&vcpu->kvm->mmu_lock);
-
-	return r;

 out_unlock:
 	spin_unlock(&vcpu->kvm->mmu_lock);
 	if (!is_error_pfn(pfn))
 		kvm_release_pfn_clean(pfn);
-	return 0;
+	return r;
 }

 static void nonpaging_free(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index c004ab6..92f466c 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -380,6 +380,9 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	mmu_set_spte(vcpu, spte, sp->role.access, pte_access, 0, 0,
 		     NULL, PT_PAGE_TABLE_LEVEL,
 		     gpte_to_gfn(gpte), pfn, true, true);
+
+	if (!is_error_pfn(pfn))
+		kvm_release_pfn_clean(pfn);
 }

 static bool FNAME(gpte_changed)(struct kvm_vcpu *vcpu,
@@ -452,6 +455,8 @@ static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, struct guest_walker *gw,
 		mmu_set_spte(vcpu, spte, sp->role.access, pte_access, 0, 0,
 			     NULL, PT_PAGE_TABLE_LEVEL, gfn,
 			     pfn, true, true);
+		if (!is_error_pfn(pfn))
+			kvm_release_pfn_clean(pfn);
 	}
 }

@@ -544,8 +549,7 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 out_gpte_changed:
 	if (sp)
 		kvm_mmu_put_page(sp, it.sptep);
-	if (!is_error_pfn(pfn))
-		kvm_release_pfn_clean(pfn);
+
 	return NULL;
 }

@@ -625,8 +629,10 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
 		return r;

 	spin_lock(&vcpu->kvm->mmu_lock);
-	if (mmu_notifier_retry(vcpu, mmu_seq))
+	if (mmu_notifier_retry(vcpu, mmu_seq)) {
+		r = 0;
 		goto out_unlock;
+	}

 	kvm_mmu_audit(vcpu, AUDIT_PRE_PAGE_FAULT);
 	kvm_mmu_free_some_pages(vcpu);
@@ -640,15 +646,13 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,

 	++vcpu->stat.pf_fixed;
 	kvm_mmu_audit(vcpu, AUDIT_POST_PAGE_FAULT);
-	spin_unlock(&vcpu->kvm->mmu_lock);
-
-	return emulate;
+	r = emulate;

 out_unlock:
 	spin_unlock(&vcpu->kvm->mmu_lock);
 	if (!is_error_pfn(pfn))
 		kvm_release_pfn_clean(pfn);
-	return 0;
+	return r;
 }

 static gpa_t FNAME(get_level1_sp_gpa)(struct kvm_mmu_page *sp)
-- 
1.7.7.6

