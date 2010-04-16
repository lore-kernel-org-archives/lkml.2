Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729Ab0DPIjE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 04:39:04 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56862 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754867Ab0DPIjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 04:39:00 -0400
Message-ID: <4BC8216A.7090003@cn.fujitsu.com>
Date: Fri, 16 Apr 2010 16:35:54 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       KVM list <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 2/2] KVM MMU: KVM MMU: cleanup for restart hlist walking
References: <4BC82122.4020805@cn.fujitsu.com>
In-Reply-To: <4BC82122.4020805@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quote from Avi:

|Just change the assignment to a 'goto restart;' please,
|I don't like playing with list_for_each internals. 

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 94c95ad..a2a9073 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1564,13 +1564,14 @@ static int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
 	r = 0;
 	index = kvm_page_table_hashfn(gfn);
 	bucket = &kvm->arch.mmu_page_hash[index];
+restart:
 	hlist_for_each_entry_safe(sp, node, n, bucket, hash_link)
 		if (sp->gfn == gfn && !sp->role.direct) {
 			pgprintk("%s: gfn %lx role %x\n", __func__, gfn,
 				 sp->role.word);
 			r = 1;
 			if (kvm_mmu_zap_page(kvm, sp))
-				n = bucket->first;
+				goto restart;
 		}
 	return r;
 }
@@ -1584,13 +1585,14 @@ static void mmu_unshadow(struct kvm *kvm, gfn_t gfn)
 
 	index = kvm_page_table_hashfn(gfn);
 	bucket = &kvm->arch.mmu_page_hash[index];
+restart:
 	hlist_for_each_entry_safe(sp, node, nn, bucket, hash_link) {
 		if (sp->gfn == gfn && !sp->role.direct
 		    && !sp->role.invalid) {
 			pgprintk("%s: zap %lx %x\n",
 				 __func__, gfn, sp->role.word);
 			if (kvm_mmu_zap_page(kvm, sp))
-				nn = bucket->first;
+				goto restart;
 		}
 	}
 }
@@ -2670,6 +2672,8 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	}
 	index = kvm_page_table_hashfn(gfn);
 	bucket = &vcpu->kvm->arch.mmu_page_hash[index];
+
+restart:
 	hlist_for_each_entry_safe(sp, node, n, bucket, hash_link) {
 		if (sp->gfn != gfn || sp->role.direct || sp->role.invalid)
 			continue;
@@ -2690,7 +2694,7 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 			pgprintk("misaligned: gpa %llx bytes %d role %x\n",
 				 gpa, bytes, sp->role.word);
 			if (kvm_mmu_zap_page(vcpu->kvm, sp))
-				n = bucket->first;
+				goto restart;
 			++vcpu->kvm->stat.mmu_flooded;
 			continue;
 		}
@@ -2899,10 +2903,11 @@ void kvm_mmu_zap_all(struct kvm *kvm)
 	struct kvm_mmu_page *sp, *node;
 
 	spin_lock(&kvm->mmu_lock);
+restart:
 	list_for_each_entry_safe(sp, node, &kvm->arch.active_mmu_pages, link)
 		if (kvm_mmu_zap_page(kvm, sp))
-			node = container_of(kvm->arch.active_mmu_pages.next,
-					    struct kvm_mmu_page, link);
+			goto restart;
+
 	spin_unlock(&kvm->mmu_lock);
 
 	kvm_flush_remote_tlbs(kvm);
-- 
1.6.1.2


