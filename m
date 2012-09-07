Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759640Ab2IGGNm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 02:13:42 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:57573 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306Ab2IGGNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 02:13:40 -0400
Message-ID: <5049908A.7070501@linux.vnet.ibm.com>
Date: Fri, 07 Sep 2012 14:13:30 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 1/3] KVM: MMU: release noslot pfn on the fail path properly
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12090706-9264-0000-0000-0000024A0AAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can not directly call kvm_release_pfn_clean to release the pfn
since we can meet noslot pfn which is used to cache mmio info into
spte

Introduce mmu_release_pfn_clean to do this kind of thing

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c         |   19 ++++++++++++++-----
 arch/x86/kvm/paging_tmpl.h |    4 ++--
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 399c177..3c10bca 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2432,6 +2432,16 @@ done:
 	return ret;
 }

+/*
+ * The primary user is page fault path which call it to properly
+ * release noslot_pfn.
+ */
+static void mmu_release_pfn_clean(pfn_t pfn)
+{
+	if (!is_error_pfn(pfn))
+		kvm_release_pfn_clean(pfn);
+}
+
 static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 			 unsigned pt_access, unsigned pte_access,
 			 int user_fault, int write_fault,
@@ -2497,8 +2507,7 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		}
 	}

-	if (!is_error_pfn(pfn))
-		kvm_release_pfn_clean(pfn);
+	mmu_release_pfn_clean(pfn);
 }

 static void nonpaging_new_cr3(struct kvm_vcpu *vcpu)
@@ -2618,7 +2627,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
 					      1, ACC_ALL, iterator.sptep);
 			if (!sp) {
 				pgprintk("nonpaging_map: ENOMEM\n");
-				kvm_release_pfn_clean(pfn);
+				mmu_release_pfn_clean(pfn);
 				return -ENOMEM;
 			}

@@ -2882,7 +2891,7 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, u32 error_code,

 out_unlock:
 	spin_unlock(&vcpu->kvm->mmu_lock);
-	kvm_release_pfn_clean(pfn);
+	mmu_release_pfn_clean(pfn);
 	return 0;
 }

@@ -3350,7 +3359,7 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa, u32 error_code,

 out_unlock:
 	spin_unlock(&vcpu->kvm->mmu_lock);
-	kvm_release_pfn_clean(pfn);
+	mmu_release_pfn_clean(pfn);
 	return 0;
 }

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index bf8c42b..f075259 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -544,7 +544,7 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 out_gpte_changed:
 	if (sp)
 		kvm_mmu_put_page(sp, it.sptep);
-	kvm_release_pfn_clean(pfn);
+	mmu_release_pfn_clean(pfn);
 	return NULL;
 }

@@ -645,7 +645,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,

 out_unlock:
 	spin_unlock(&vcpu->kvm->mmu_lock);
-	kvm_release_pfn_clean(pfn);
+	mmu_release_pfn_clean(pfn);
 	return 0;
 }

-- 
1.7.7.6

