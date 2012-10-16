Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258Ab2JPMIM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 08:08:12 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:43751 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558Ab2JPMIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 08:08:10 -0400
Message-ID: <507D4E21.6010202@linux.vnet.ibm.com>
Date: Tue, 16 Oct 2012 20:08:01 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v5 2/6] KVM: MMU: remove mmu_is_invalid
References: <507D4DE7.5080708@linux.vnet.ibm.com>
In-Reply-To: <507D4DE7.5080708@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12101612-5140-0000-0000-00000235EBC0
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
index 6f85fe0..b8d13d7 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2699,11 +2699,6 @@ static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu,
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
index 714e2c0..045d31a 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -340,7 +340,7 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	pte_access = sp->role.access & gpte_access(vcpu, gpte);
 	protect_clean_gpte(&pte_access, gpte);
 	pfn = gfn_to_pfn_atomic(vcpu->kvm, gpte_to_gfn(gpte));
-	if (mmu_invalid_pfn(pfn))
+	if (is_invalid_pfn(pfn))
 		return;

 	/*
@@ -416,7 +416,7 @@ static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, struct guest_walker *gw,
 		gfn = gpte_to_gfn(gpte);
 		pfn = pte_prefetch_gfn_to_pfn(vcpu, gfn,
 				      pte_access & ACC_WRITE_MASK);
-		if (mmu_invalid_pfn(pfn))
+		if (is_invalid_pfn(pfn))
 			break;

 		mmu_set_spte(vcpu, spte, sp->role.access, pte_access, 0, 0,
-- 
1.7.7.6

