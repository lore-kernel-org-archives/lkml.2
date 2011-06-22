Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758318Ab1FVOcH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 10:32:07 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54792 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758244Ab1FVOcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 10:32:05 -0400
Message-ID: <4E01FD59.9030103@cn.fujitsu.com>
Date: Wed, 22 Jun 2011 22:34:01 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 15/22] KVM: MMU: abstract some functions to handle fault
 pfn
References: <4E01FBC9.3020009@cn.fujitsu.com>
In-Reply-To: <4E01FBC9.3020009@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-22 22:31:36,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-22 22:31:36,
	Serialize complete at 2011-06-22 22:31:36
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce handle_abnormal_pfn to handle fault pfn on page fault path,
introduce mmu_invalid_pfn to handle fault pfn on prefetch path

It is the preparing work for mmio page fault support

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c         |   47 ++++++++++++++++++++++++++++++++-----------
 arch/x86/kvm/paging_tmpl.h |   12 +++++-----
 2 files changed, 41 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 4a51042..4fe1cb3 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2221,18 +2221,15 @@ static void kvm_send_hwpoison_signal(unsigned long address, struct task_struct *
 	send_sig_info(SIGBUS, &info, tsk);
 }
 
-static int kvm_handle_bad_page(struct kvm_vcpu *vcpu, gva_t gva,
-			       unsigned access, gfn_t gfn, pfn_t pfn)
+static int kvm_handle_bad_page(struct kvm_vcpu *vcpu, gfn_t gfn, pfn_t pfn)
 {
 	kvm_release_pfn_clean(pfn);
 	if (is_hwpoison_pfn(pfn)) {
 		kvm_send_hwpoison_signal(gfn_to_hva(vcpu->kvm, gfn), current);
 		return 0;
-	} else if (is_fault_pfn(pfn))
-		return -EFAULT;
+	}
 
-	vcpu_cache_mmio_info(vcpu, gva, gfn, access);
-	return 1;
+	return -EFAULT;
 }
 
 static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu,
@@ -2277,6 +2274,33 @@ static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu,
 	}
 }
 
+static bool mmu_invalid_pfn(pfn_t pfn)
+{
+	return unlikely(is_invalid_pfn(pfn) || is_mmio_pfn(pfn));
+}
+
+static bool handle_abnormal_pfn(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn,
+				pfn_t pfn, unsigned access, int *ret_val)
+{
+	bool ret = true;
+
+	/* The pfn is invalid, report the error! */
+	if (unlikely(is_invalid_pfn(pfn))) {
+		*ret_val = kvm_handle_bad_page(vcpu, gfn, pfn);
+		goto exit;
+	}
+
+	if (unlikely(is_mmio_pfn(pfn))) {
+		vcpu_cache_mmio_info(vcpu, gva, gfn, access);
+		*ret_val = 1;
+		goto exit;
+	}
+
+	ret = false;
+exit:
+	return ret;
+}
+
 static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
 			 gva_t gva, pfn_t *pfn, bool write, bool *writable);
 
@@ -2311,9 +2335,8 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn,
 	if (try_async_pf(vcpu, prefault, gfn, v, &pfn, write, &map_writable))
 		return 0;
 
-	/* mmio */
-	if (is_error_pfn(pfn))
-		return kvm_handle_bad_page(vcpu, v, ACC_ALL, gfn, pfn);
+	if (handle_abnormal_pfn(vcpu, v, gfn, pfn, ACC_ALL, &r))
+		return r;
 
 	spin_lock(&vcpu->kvm->mmu_lock);
 	if (mmu_notifier_retry(vcpu, mmu_seq))
@@ -2685,9 +2708,9 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa, u32 error_code,
 	if (try_async_pf(vcpu, prefault, gfn, gpa, &pfn, write, &map_writable))
 		return 0;
 
-	/* mmio */
-	if (is_error_pfn(pfn))
-		return kvm_handle_bad_page(vcpu, 0, 0, gfn, pfn);
+	if (handle_abnormal_pfn(vcpu, 0, gfn, pfn, ACC_ALL, &r))
+		return r;
+
 	spin_lock(&vcpu->kvm->mmu_lock);
 	if (mmu_notifier_retry(vcpu, mmu_seq))
 		goto out_unlock;
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 58a29d0..870be69 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -373,7 +373,7 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	pgprintk("%s: gpte %llx spte %p\n", __func__, (u64)gpte, spte);
 	pte_access = sp->role.access & FNAME(gpte_access)(vcpu, gpte, true);
 	pfn = gfn_to_pfn_atomic(vcpu->kvm, gpte_to_gfn(gpte));
-	if (is_error_pfn(pfn)) {
+	if (mmu_invalid_pfn(pfn)) {
 		kvm_release_pfn_clean(pfn);
 		return;
 	}
@@ -451,7 +451,7 @@ static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, struct guest_walker *gw,
 		gfn = gpte_to_gfn(gpte);
 		pfn = pte_prefetch_gfn_to_pfn(vcpu, gfn,
 				      pte_access & ACC_WRITE_MASK);
-		if (is_error_pfn(pfn)) {
+		if (mmu_invalid_pfn(pfn)) {
 			kvm_release_pfn_clean(pfn);
 			break;
 		}
@@ -621,10 +621,10 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
 			 &map_writable))
 		return 0;
 
-	/* mmio */
-	if (is_error_pfn(pfn))
-		return kvm_handle_bad_page(vcpu, mmu_is_nested(vcpu) ? 0 :
-				      addr, walker.pte_access, walker.gfn, pfn);
+	if (handle_abnormal_pfn(vcpu, mmu_is_nested(vcpu) ? 0 : addr,
+				walker.gfn, pfn, walker.pte_access, &r))
+		return r;
+
 	spin_lock(&vcpu->kvm->mmu_lock);
 	if (mmu_notifier_retry(vcpu, mmu_seq))
 		goto out_unlock;
-- 
1.7.5.4

