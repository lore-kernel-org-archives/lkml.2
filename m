Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab0LGCaJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 21:30:09 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:55978 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752132Ab0LGCaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 21:30:08 -0500
Message-ID: <4CFD9D42.2050709@cn.fujitsu.com>
Date: Tue, 07 Dec 2010 10:34:42 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v5 2/3] KVM: MMU: fix accessed bit set on prefault path
References: <4CFD9D12.30709@cn.fujitsu.com>
In-Reply-To: <4CFD9D12.30709@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-07 10:30:12,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-07 10:30:13,
	Serialize complete at 2010-12-07 10:30:13
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Retry #PF is the speculative path, so don't set the accessed bit

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 4954de9..04f9033 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
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
 
 
@@ -2684,7 +2686,7 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa, u32 error_code,
 		goto out_unlock;
 	kvm_mmu_free_some_pages(vcpu);
 	r = __direct_map(vcpu, gpa, write, map_writable,
-			 level, gfn, pfn);
+			 level, gfn, pfn, prefault);
 	spin_unlock(&vcpu->kvm->mmu_lock);
 
 	return r;
-- 
1.7.0.4

