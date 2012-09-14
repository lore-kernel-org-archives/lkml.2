Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470Ab2INJ5f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 05:57:35 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:52312 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756305Ab2INJ5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 05:57:31 -0400
Message-ID: <5052FF82.1060106@linux.vnet.ibm.com>
Date: Fri, 14 Sep 2012 17:57:22 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 1/5] KVM: MMU: release noslot pfn on the fail path properly
References: <5052FF61.3070600@linux.vnet.ibm.com>
In-Reply-To: <5052FF61.3070600@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12091409-2000-0000-0000-0000091D06EF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can not directly call kvm_release_pfn_clean to release the pfn
since we can meet noslot pfn which is used to cache mmio info into
spte

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c         |    6 ++++--
 arch/x86/kvm/paging_tmpl.h |    6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index aa0b469..f74c63a 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2877,7 +2877,8 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, u32 error_code,

 out_unlock:
 	spin_unlock(&vcpu->kvm->mmu_lock);
-	kvm_release_pfn_clean(pfn);
+	if (!is_error_pfn(pfn))
+		kvm_release_pfn_clean(pfn);
 	return 0;
 }

@@ -3345,7 +3346,8 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa, u32 error_code,

 out_unlock:
 	spin_unlock(&vcpu->kvm->mmu_lock);
-	kvm_release_pfn_clean(pfn);
+	if (!is_error_pfn(pfn))
+		kvm_release_pfn_clean(pfn);
 	return 0;
 }

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index bf8c42b..c004ab6 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -544,7 +544,8 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 out_gpte_changed:
 	if (sp)
 		kvm_mmu_put_page(sp, it.sptep);
-	kvm_release_pfn_clean(pfn);
+	if (!is_error_pfn(pfn))
+		kvm_release_pfn_clean(pfn);
 	return NULL;
 }

@@ -645,7 +646,8 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,

 out_unlock:
 	spin_unlock(&vcpu->kvm->mmu_lock);
-	kvm_release_pfn_clean(pfn);
+	if (!is_error_pfn(pfn))
+		kvm_release_pfn_clean(pfn);
 	return 0;
 }

-- 
1.7.7.6

