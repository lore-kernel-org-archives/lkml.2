Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab0HXCbP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 22:31:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45614 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248Ab0HXCbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 22:31:13 -0400
From: Xiaotian Feng <dfeng@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Xiaotian Feng <dfeng@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: [PATCH -kvm] kvm: fix regression from rework KVM mmu_shrink() code
Date: Tue, 24 Aug 2010 10:31:07 +0800
Message-Id: <1282617067-7686-1-git-send-email-dfeng@redhat.com>
In-Reply-To: <20100824020721.GA14726@amt.cnet>
References: <20100824020721.GA14726@amt.cnet>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Latest kvm mmu_shrink code rework makes kernel changes kvm->arch.n_used_mmu_pages/
kvm->arch.n_max_mmu_pages at kvm_mmu_free_page/kvm_mmu_alloc_page, which is called
by kvm_mmu_commit_zap_page. So the kvm->arch.n_used_mmu_pages or
kvm_mmu_available_pages(vcpu->kvm) is unchanged after kvm_mmu_prepare_zap_page(),
This caused kvm_mmu_change_mmu_pages/__kvm_mmu_free_some_pages loops forever.
Moving kvm_mmu_commit_zap_page would make the while loop performs as normal.

Reported-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Tested-by: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Tim Pepper <lnxninja@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index f52a965..0991de3 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1724,10 +1724,9 @@ void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned int goal_nr_mmu_pages)
 
 			page = container_of(kvm->arch.active_mmu_pages.prev,
 					    struct kvm_mmu_page, link);
-			kvm_mmu_prepare_zap_page(kvm, page,
-							       &invalid_list);
+			kvm_mmu_prepare_zap_page(kvm, page, &invalid_list);
+			kvm_mmu_commit_zap_page(kvm, &invalid_list);
 		}
-		kvm_mmu_commit_zap_page(kvm, &invalid_list);
 		goal_nr_mmu_pages = kvm->arch.n_used_mmu_pages;
 	}
 
@@ -2976,9 +2975,9 @@ void __kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu)
 		sp = container_of(vcpu->kvm->arch.active_mmu_pages.prev,
 				  struct kvm_mmu_page, link);
 		kvm_mmu_prepare_zap_page(vcpu->kvm, sp, &invalid_list);
+		kvm_mmu_commit_zap_page(vcpu->kvm, &invalid_list);
 		++vcpu->kvm->stat.mmu_recycled;
 	}
-	kvm_mmu_commit_zap_page(vcpu->kvm, &invalid_list);
 }
 
 int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t cr2, u32 error_code)
-- 
1.7.2.1

