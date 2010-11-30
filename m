Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077Ab0K3Jbp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 04:31:45 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58696 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752108Ab0K3Jbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 04:31:43 -0500
Message-ID: <4CF4C587.7080000@cn.fujitsu.com>
Date: Tue, 30 Nov 2010 17:36:07 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v3 2/3] KVM: MMU: fix accessed bit set on prefault path
References: <4CF4C535.8080405@cn.fujitsu.com>
In-Reply-To: <4CF4C535.8080405@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-30 17:31:51,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-30 17:31:53,
	Serialize complete at 2010-11-30 17:31:53
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Retry #PF is the speculative path, so don't set the accessed bit,
especially, stop prefault if shadow_accessed_mask = 0

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/mmu.c              |   12 +++++++-----
 arch/x86/kvm/x86.c              |    3 +++
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a4c5352..209da89 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -632,6 +632,7 @@ int kvm_pv_mmu_op(struct kvm_vcpu *vcpu, unsigned long bytes,
 u8 kvm_get_guest_memory_type(struct kvm_vcpu *vcpu, gfn_t gfn);
 
 extern bool tdp_enabled;
+extern u64 __read_mostly shadow_accessed_mask;
 
 enum emulation_result {
 	EMULATE_DONE,       /* no further processing */
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 5b71415..f34987d 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -199,8 +199,8 @@ static u64 __read_mostly shadow_notrap_nonpresent_pte;
 static u64 __read_mostly shadow_nx_mask;
 static u64 __read_mostly shadow_x_mask;	/* mutual exclusive with nx_mask */
 static u64 __read_mostly shadow_user_mask;
-static u64 __read_mostly shadow_accessed_mask;
 static u64 __read_mostly shadow_dirty_mask;
+u64 __read_mostly shadow_accessed_mask;
 
 static inline u64 rsvd_bits(int s, int e)
 {
@@ -2214,7 +2214,8 @@ static void direct_pte_prefetch(struct kvm_vcpu *vcpu, u64 *sptep)
 }
 
 static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
-			int map_writable, int level, gfn_t gfn, pfn_t pfn)
+			int map_writable, int level, gfn_t gfn, pfn_t pfn,
+			bool prefault)
 {
 	struct kvm_shadow_walk_iterator iterator;
 	struct kvm_mmu_page *sp;
@@ -2229,7 +2230,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
 				pte_access &= ~ACC_WRITE_MASK;
 			mmu_set_spte(vcpu, iterator.sptep, ACC_ALL, pte_access,
 				     0, write, 1, &pt_write,
-				     level, gfn, pfn, false, map_writable);
+				     level, gfn, pfn, prefault, map_writable);
 			direct_pte_prefetch(vcpu, iterator.sptep);
 			++vcpu->stat.pf_fixed;
 			break;
@@ -2321,7 +2322,8 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn,
 	if (mmu_notifier_retry(vcpu, mmu_seq))
 		goto out_unlock;
 	kvm_mmu_free_some_pages(vcpu);
-	r = __direct_map(vcpu, v, write, map_writable, level, gfn, pfn);
+	r = __direct_map(vcpu, v, write, map_writable, level, gfn, pfn,
+			 prefault);
 	spin_unlock(&vcpu->kvm->mmu_lock);
 
 
@@ -2683,7 +2685,7 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa, u32 error_code,
 		goto out_unlock;
 	kvm_mmu_free_some_pages(vcpu);
 	r = __direct_map(vcpu, gpa, write, map_writable,
-			 level, gfn, pfn);
+			 level, gfn, pfn, prefault);
 	spin_unlock(&vcpu->kvm->mmu_lock);
 
 	return r;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 410d2d1..83ed55f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6178,6 +6178,9 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 {
 	int r;
 
+	if (!shadow_accessed_mask)
+		return;
+
 	if (!vcpu->arch.mmu.direct_map || !work->arch.direct_map ||
 	      is_error_page(work->page))
 		return;
-- 
1.7.0.4

