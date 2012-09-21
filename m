Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584Ab2IUG6A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 02:58:00 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:42007 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755286Ab2IUG56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 02:57:58 -0400
Message-ID: <505C0FE9.9040107@linux.vnet.ibm.com>
Date: Fri, 21 Sep 2012 14:57:45 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v3 2/7] KVM: MMU: remove mmu_is_invalid
References: <505C0FA8.5070007@linux.vnet.ibm.com>
In-Reply-To: <505C0FA8.5070007@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12092106-5564-0000-0000-0000048EB720
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove mmu_is_invalid and use is_invalid_pfn instead

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c         |    5 -----
 arch/x86/kvm/paging_tmpl.h |    4 ++--
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 0f56169..3e9728b 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2700,11 +2700,6 @@ static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu,
 	}
 }

-static bool mmu_invalid_pfn(pfn_t pfn)
-{
-	return unlikely(is_invalid_pfn(pfn));
-}
-
 static bool handle_abnormal_pfn(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn,
 				pfn_t pfn, unsigned access, int *ret_val)
 {
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 9ce6bc0..b400761 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -370,7 +370,7 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	pgprintk("%s: gpte %llx spte %p\n", __func__, (u64)gpte, spte);
 	pte_access = sp->role.access & FNAME(gpte_access)(vcpu, gpte, true);
 	pfn = gfn_to_pfn_atomic(vcpu->kvm, gpte_to_gfn(gpte));
-	if (mmu_invalid_pfn(pfn))
+	if (is_invalid_pfn(pfn))
 		return;

 	/*
@@ -446,7 +446,7 @@ static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, struct guest_walker *gw,
 		gfn = gpte_to_gfn(gpte);
 		pfn = pte_prefetch_gfn_to_pfn(vcpu, gfn,
 				      pte_access & ACC_WRITE_MASK);
-		if (mmu_invalid_pfn(pfn))
+		if (is_invalid_pfn(pfn))
 			break;

 		mmu_set_spte(vcpu, spte, sp->role.access, pte_access, 0, 0,
-- 
1.7.7.6

