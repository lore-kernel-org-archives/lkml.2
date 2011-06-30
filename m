Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758784Ab1F3IU7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 04:20:59 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55887 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758764Ab1F3IUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 04:20:52 -0400
Message-ID: <4E0C3256.6070505@cn.fujitsu.com>
Date: Thu, 30 Jun 2011 16:22:46 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v3 08/19] KVM: MMU: count used shadow pages on prepareing
 path
References: <4E0C3178.2080603@cn.fujitsu.com>
In-Reply-To: <4E0C3178.2080603@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-30 16:20:17,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-30 16:20:18,
	Serialize complete at 2011-06-30 16:20:18
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move counting used shadow pages from commiting path to preparing path to
reduce tlb flush on some paths

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index a62ba46..91d3069 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1039,7 +1039,7 @@ static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, int nr)
 	percpu_counter_add(&kvm_total_used_mmu_pages, nr);
 }
 
-static void kvm_mmu_free_page(struct kvm *kvm, struct kvm_mmu_page *sp)
+static void kvm_mmu_free_page(struct kvm_mmu_page *sp)
 {
 	ASSERT(is_empty_shadow_page(sp->spt));
 	hlist_del(&sp->hash_link);
@@ -1048,7 +1048,6 @@ static void kvm_mmu_free_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 	if (!sp->role.direct)
 		free_page((unsigned long)sp->gfns);
 	kmem_cache_free(mmu_page_header_cache, sp);
-	kvm_mod_used_mmu_pages(kvm, -1);
 }
 
 static unsigned kvm_page_table_hashfn(gfn_t gfn)
@@ -1655,6 +1654,7 @@ static int kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
 		/* Count self */
 		ret++;
 		list_move(&sp->link, invalid_list);
+		kvm_mod_used_mmu_pages(kvm, -1);
 	} else {
 		list_move(&sp->link, &kvm->arch.active_mmu_pages);
 		kvm_reload_remote_mmus(kvm);
@@ -1678,7 +1678,7 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
 	do {
 		sp = list_first_entry(invalid_list, struct kvm_mmu_page, link);
 		WARN_ON(!sp->role.invalid || sp->root_count);
-		kvm_mmu_free_page(kvm, sp);
+		kvm_mmu_free_page(sp);
 	} while (!list_empty(invalid_list));
 
 }
@@ -1704,8 +1704,8 @@ void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned int goal_nr_mmu_pages)
 			page = container_of(kvm->arch.active_mmu_pages.prev,
 					    struct kvm_mmu_page, link);
 			kvm_mmu_prepare_zap_page(kvm, page, &invalid_list);
-			kvm_mmu_commit_zap_page(kvm, &invalid_list);
 		}
+		kvm_mmu_commit_zap_page(kvm, &invalid_list);
 		goal_nr_mmu_pages = kvm->arch.n_used_mmu_pages;
 	}
 
@@ -3302,9 +3302,9 @@ void __kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu)
 		sp = container_of(vcpu->kvm->arch.active_mmu_pages.prev,
 				  struct kvm_mmu_page, link);
 		kvm_mmu_prepare_zap_page(vcpu->kvm, sp, &invalid_list);
-		kvm_mmu_commit_zap_page(vcpu->kvm, &invalid_list);
 		++vcpu->kvm->stat.mmu_recycled;
 	}
+	kvm_mmu_commit_zap_page(vcpu->kvm, &invalid_list);
 }
 
 int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t cr2, u32 error_code,
-- 
1.7.5.4

