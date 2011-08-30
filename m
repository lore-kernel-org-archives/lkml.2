Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370Ab1H3CeA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 22:34:00 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50665 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751670Ab1H3Cd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 22:33:57 -0400
Message-ID: <4E5C4C8D.5040509@cn.fujitsu.com>
Date: Tue, 30 Aug 2011 10:35:57 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v3 05/11] KVM: MMU: do not mark accessed bit on pte write
 path
References: <4E5C4C20.3000403@cn.fujitsu.com>
In-Reply-To: <4E5C4C20.3000403@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-30 10:32:45,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-30 10:32:47,
	Serialize complete at 2011-08-30 10:32:47
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current code, the accessed bit is always set when page fault occurred,
do not need to set it on pte write path

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/include/asm/kvm_host.h |    1 -
 arch/x86/kvm/mmu.c              |   22 +---------------------
 2 files changed, 1 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 27a25df..58ea3a7 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -356,7 +356,6 @@ struct kvm_vcpu_arch {
 	gfn_t last_pt_write_gfn;
 	int   last_pt_write_count;
 	u64  *last_pte_updated;
-	gfn_t last_pte_gfn;
 
 	struct fpu guest_fpu;
 	u64 xcr0;
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 26aae11..7ec2a6a 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2206,11 +2206,6 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	if (set_mmio_spte(sptep, gfn, pfn, pte_access))
 		return 0;
 
-	/*
-	 * We don't set the accessed bit, since we sometimes want to see
-	 * whether the guest actually used the pte (in order to detect
-	 * demand paging).
-	 */
 	spte = PT_PRESENT_MASK;
 	if (!speculative)
 		spte |= shadow_accessed_mask;
@@ -2361,10 +2356,8 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		}
 	}
 	kvm_release_pfn_clean(pfn);
-	if (speculative) {
+	if (speculative)
 		vcpu->arch.last_pte_updated = sptep;
-		vcpu->arch.last_pte_gfn = gfn;
-	}
 }
 
 static void nonpaging_new_cr3(struct kvm_vcpu *vcpu)
@@ -3532,18 +3525,6 @@ static bool last_updated_pte_accessed(struct kvm_vcpu *vcpu)
 	return !!(spte && (*spte & shadow_accessed_mask));
 }
 
-static void kvm_mmu_access_page(struct kvm_vcpu *vcpu, gfn_t gfn)
-{
-	u64 *spte = vcpu->arch.last_pte_updated;
-
-	if (spte
-	    && vcpu->arch.last_pte_gfn == gfn
-	    && shadow_accessed_mask
-	    && !(*spte & shadow_accessed_mask)
-	    && is_shadow_present_pte(*spte))
-		set_bit(PT_ACCESSED_SHIFT, (unsigned long *)spte);
-}
-
 void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 		       const u8 *new, int bytes,
 		       bool guest_initiated)
@@ -3614,7 +3595,6 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	++vcpu->kvm->stat.mmu_pte_write;
 	trace_kvm_mmu_audit(vcpu, AUDIT_PRE_PTE_WRITE);
 	if (guest_initiated) {
-		kvm_mmu_access_page(vcpu, gfn);
 		if (gfn == vcpu->arch.last_pt_write_gfn
 		    && !last_updated_pte_accessed(vcpu)) {
 			++vcpu->arch.last_pt_write_count;
-- 
1.7.5.4

