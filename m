Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832Ab1CKDkg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 22:40:36 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54300 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752176Ab1CKDkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 22:40:33 -0500
Message-ID: <4D7999E6.9000406@cn.fujitsu.com>
Date: Fri, 11 Mar 2011 11:41:26 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 4/4] KVM: MMU: cleanup pte write path
References: <4D772F10.3020302@cn.fujitsu.com> <4D772FB7.8060007@cn.fujitsu.com> <4D78A642.8020708@redhat.com>
In-Reply-To: <4D78A642.8020708@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-11 11:39:14,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-11 11:39:15,
	Serialize complete at 2011-03-11 11:39:15
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2011 06:21 PM, Avi Kivity wrote:
> On 03/09/2011 09:43 AM, Xiao Guangrong wrote:
>> This patch does:
>> - call vcpu->arch.mmu.update_pte directly
>> - use gfn_to_pfn_atomic in update_pte path
>>
>> The suggestion is from Avi.
>>
>>
>>
>> -    mmu_guess_page_from_pte_write(vcpu, gpa, gentry);
>> +    mmu_seq = vcpu->kvm->mmu_notifier_seq;
>> +    smp_rmb();
> 
> smp_rmb() should come before, no? but the problem was present in the original code, too.
> 

Um, i think smb_rmb is used to avoid read mmu_notifier_seq reorder to the
behind of gfn_to_pfn in the original code, like this:


CPU A:                           B
                              
gfn_to_pfn
                             invalidate_page
                             mmu_notifier_seq++

read mmu_notifier_seq

then, cpu A will get the invalid pfn.

But, after this cleanup patch, we use gfn_to_pfn_atomic in the protection
of mmu_lock, so i think the mmu_seq code can be removed.


Subject: [PATCH] KVM: MMU: remove mmu_seq verification in kvm_mmu_pte_write

The mmu_seq verification can be removed since we get the pfn in the
protection of mmu_lock

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/include/asm/kvm_host.h |    2 +-
 arch/x86/kvm/mmu.c              |   16 +++++-----------
 arch/x86/kvm/paging_tmpl.h      |    4 +---
 3 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c8af099..18a95e9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -256,7 +256,7 @@ struct kvm_mmu {
 			 struct kvm_mmu_page *sp);
 	void (*invlpg)(struct kvm_vcpu *vcpu, gva_t gva);
 	void (*update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
-			u64 *spte, const void *pte, unsigned long mmu_seq);
+			   u64 *spte, const void *pte);
 	hpa_t root_hpa;
 	int root_level;
 	int shadow_root_level;
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 22fae75..2841805 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1206,7 +1206,7 @@ static void nonpaging_invlpg(struct kvm_vcpu *vcpu, gva_t gva)
 
 static void nonpaging_update_pte(struct kvm_vcpu *vcpu,
 				 struct kvm_mmu_page *sp, u64 *spte,
-				 const void *pte, unsigned long mmu_seq)
+				 const void *pte)
 {
 	WARN_ON(1);
 }
@@ -3163,9 +3163,8 @@ static void mmu_pte_write_zap_pte(struct kvm_vcpu *vcpu,
 }
 
 static void mmu_pte_write_new_pte(struct kvm_vcpu *vcpu,
-				  struct kvm_mmu_page *sp,
-				  u64 *spte,
-				  const void *new, unsigned long mmu_seq)
+				  struct kvm_mmu_page *sp, u64 *spte,
+				  const void *new)
 {
 	if (sp->role.level != PT_PAGE_TABLE_LEVEL) {
 		++vcpu->kvm->stat.mmu_pde_zapped;
@@ -3173,7 +3172,7 @@ static void mmu_pte_write_new_pte(struct kvm_vcpu *vcpu,
         }
 
 	++vcpu->kvm->stat.mmu_pte_updated;
-	vcpu->arch.mmu.update_pte(vcpu, sp, spte, new, mmu_seq);
+	vcpu->arch.mmu.update_pte(vcpu, sp, spte, new);
 }
 
 static bool need_remote_flush(u64 old, u64 new)
@@ -3229,7 +3228,6 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	struct kvm_mmu_page *sp;
 	struct hlist_node *node;
 	LIST_HEAD(invalid_list);
-	unsigned long mmu_seq;
 	u64 entry, gentry, *spte;
 	unsigned pte_size, page_offset, misaligned, quadrant, offset;
 	int level, npte, invlpg_counter, r, flooded = 0;
@@ -3271,9 +3269,6 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 		break;
 	}
 
-	mmu_seq = vcpu->kvm->mmu_notifier_seq;
-	smp_rmb();
-
 	spin_lock(&vcpu->kvm->mmu_lock);
 	if (atomic_read(&vcpu->kvm->arch.invlpg_counter) != invlpg_counter)
 		gentry = 0;
@@ -3345,8 +3340,7 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 			if (gentry &&
 			      !((sp->role.word ^ vcpu->arch.mmu.base_role.word)
 			      & mask.word))
-				mmu_pte_write_new_pte(vcpu, sp, spte, &gentry,
-						      mmu_seq);
+				mmu_pte_write_new_pte(vcpu, sp, spte, &gentry);
 			if (!remote_flush && need_remote_flush(entry, *spte))
 				remote_flush = true;
 			++spte;
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 7514050..3dee563 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -325,7 +325,7 @@ no_present:
 }
 
 static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
-			      u64 *spte, const void *pte, unsigned long mmu_seq)
+			      u64 *spte, const void *pte)
 {
 	pt_element_t gpte;
 	unsigned pte_access;
@@ -342,8 +342,6 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		kvm_release_pfn_clean(pfn);
 		return;
 	}
-	if (mmu_notifier_retry(vcpu, mmu_seq))
-		return;
 
 	/*
 	 * we call mmu_set_spte() with host_writable = true beacuse that
-- 
1.7.4
