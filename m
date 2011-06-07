Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881Ab1FGNAJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 09:00:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54513 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753614Ab1FGNAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 09:00:07 -0400
Message-ID: <4DEE214E.2080103@cn.fujitsu.com>
Date: Tue, 07 Jun 2011 21:02:06 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 07/15] KVM: MMU: rename 'pt_write' to 'emulate'
References: <4DEE205E.8000601@cn.fujitsu.com>
In-Reply-To: <4DEE205E.8000601@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-07 20:59:49,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-07 20:59:49,
	Serialize complete at 2011-06-07 20:59:49
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If 'pt_write' is true, we need to emulate the fault. And in later patch, we
need to emulate the fault even though it is not a pt_write event, so rename
it to better fit the meaning

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c         |   10 +++++-----
 arch/x86/kvm/paging_tmpl.h |   16 ++++++++--------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index a10afd4..05e604d 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2014,7 +2014,7 @@ done:
 static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 			 unsigned pt_access, unsigned pte_access,
 			 int user_fault, int write_fault,
-			 int *ptwrite, int level, gfn_t gfn,
+			 int *emulate, int level, gfn_t gfn,
 			 pfn_t pfn, bool speculative,
 			 bool host_writable)
 {
@@ -2052,7 +2052,7 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		      level, gfn, pfn, speculative, true,
 		      host_writable)) {
 		if (write_fault)
-			*ptwrite = 1;
+			*emulate = 1;
 		kvm_mmu_flush_tlb(vcpu);
 	}
 
@@ -2175,7 +2175,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
 {
 	struct kvm_shadow_walk_iterator iterator;
 	struct kvm_mmu_page *sp;
-	int pt_write = 0;
+	int emulate = 0;
 	gfn_t pseudo_gfn;
 
 	for_each_shadow_entry(vcpu, (u64)gfn << PAGE_SHIFT, iterator) {
@@ -2183,7 +2183,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
 			unsigned pte_access = ACC_ALL;
 
 			mmu_set_spte(vcpu, iterator.sptep, ACC_ALL, pte_access,
-				     0, write, &pt_write,
+				     0, write, &emulate,
 				     level, gfn, pfn, prefault, map_writable);
 			direct_pte_prefetch(vcpu, iterator.sptep);
 			++vcpu->stat.pf_fixed;
@@ -2211,7 +2211,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
 				   | shadow_accessed_mask);
 		}
 	}
-	return pt_write;
+	return emulate;
 }
 
 static void kvm_send_hwpoison_signal(unsigned long address, struct task_struct *tsk)
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 95da29e..8353b69 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -465,7 +465,7 @@ static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, struct guest_walker *gw,
 static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 			 struct guest_walker *gw,
 			 int user_fault, int write_fault, int hlevel,
-			 int *ptwrite, pfn_t pfn, bool map_writable,
+			 int *emulate, pfn_t pfn, bool map_writable,
 			 bool prefault)
 {
 	unsigned access = gw->pt_access;
@@ -536,7 +536,7 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 	}
 
 	mmu_set_spte(vcpu, it.sptep, access, gw->pte_access,
-		     user_fault, write_fault, ptwrite, it.level,
+		     user_fault, write_fault, emulate, it.level,
 		     gw->gfn, pfn, prefault, map_writable);
 	FNAME(pte_prefetch)(vcpu, gw, it.sptep);
 
@@ -570,7 +570,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
 	int user_fault = error_code & PFERR_USER_MASK;
 	struct guest_walker walker;
 	u64 *sptep;
-	int write_pt = 0;
+	int emulate = 0;
 	int r;
 	pfn_t pfn;
 	int level = PT_PAGE_TABLE_LEVEL;
@@ -631,19 +631,19 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
 	if (!force_pt_level)
 		transparent_hugepage_adjust(vcpu, &walker.gfn, &pfn, &level);
 	sptep = FNAME(fetch)(vcpu, addr, &walker, user_fault, write_fault,
-			     level, &write_pt, pfn, map_writable, prefault);
+			     level, &emulate, pfn, map_writable, prefault);
 	(void)sptep;
-	pgprintk("%s: shadow pte %p %llx ptwrite %d\n", __func__,
-		 sptep, *sptep, write_pt);
+	pgprintk("%s: shadow pte %p %llx emulate %d\n", __func__,
+		 sptep, *sptep, emulate);
 
-	if (!write_pt)
+	if (!emulate)
 		vcpu->arch.last_pt_write_count = 0; /* reset fork detector */
 
 	++vcpu->stat.pf_fixed;
 	trace_kvm_mmu_audit(vcpu, AUDIT_POST_PAGE_FAULT);
 	spin_unlock(&vcpu->kvm->mmu_lock);
 
-	return write_pt;
+	return emulate;
 
 out_unlock:
 	spin_unlock(&vcpu->kvm->mmu_lock);
-- 
1.7.4.4

