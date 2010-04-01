Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab0DAIxe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 04:53:34 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57904 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754493Ab0DAIxZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 04:53:25 -0400
Message-ID: <4BB45E65.2040006@cn.fujitsu.com>
Date: Thu, 01 Apr 2010 16:50:45 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] KVM MMU: cleanup/fix mmu audit code
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch does:
- 'sp' parameter in inspect_spte_fn() is not used, so remove it
- fix 'kvm' and 'slots' is not defined in count_rmaps()
- fix a bug in inspect_spte_has_rmap()

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index d7700bb..5de92ae 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3178,8 +3178,7 @@ static gva_t canonicalize(gva_t gva)
 }
 
 
-typedef void (*inspect_spte_fn) (struct kvm *kvm, struct kvm_mmu_page *sp,
-				 u64 *sptep);
+typedef void (*inspect_spte_fn) (struct kvm *kvm, u64 *sptep);
 
 static void __mmu_spte_walk(struct kvm *kvm, struct kvm_mmu_page *sp,
 			    inspect_spte_fn fn)
@@ -3195,7 +3194,7 @@ static void __mmu_spte_walk(struct kvm *kvm, struct kvm_mmu_page *sp,
 				child = page_header(ent & PT64_BASE_ADDR_MASK);
 				__mmu_spte_walk(kvm, child, fn);
 			} else
-				fn(kvm, sp, &sp->spt[i]);
+				fn(kvm, &sp->spt[i]);
 		}
 	}
 }
@@ -3286,6 +3285,8 @@ static void audit_mappings(struct kvm_vcpu *vcpu)
 
 static int count_rmaps(struct kvm_vcpu *vcpu)
 {
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_memslots *slots;
 	int nmaps = 0;
 	int i, j, k, idx;
 
@@ -3319,7 +3320,7 @@ static int count_rmaps(struct kvm_vcpu *vcpu)
 	return nmaps;
 }
 
-void inspect_spte_has_rmap(struct kvm *kvm, struct kvm_mmu_page *sp, u64 *sptep)
+void inspect_spte_has_rmap(struct kvm *kvm, u64 *sptep)
 {
 	unsigned long *rmapp;
 	struct kvm_mmu_page *rev_sp;
@@ -3335,14 +3336,14 @@ void inspect_spte_has_rmap(struct kvm *kvm, struct kvm_mmu_page *sp, u64 *sptep)
 			printk(KERN_ERR "%s: no memslot for gfn %ld\n",
 					 audit_msg, gfn);
 			printk(KERN_ERR "%s: index %ld of sp (gfn=%lx)\n",
-					audit_msg, sptep - rev_sp->spt,
+			       audit_msg, (long int)(sptep - rev_sp->spt),
 					rev_sp->gfn);
 			dump_stack();
 			return;
 		}
 
 		rmapp = gfn_to_rmap(kvm, rev_sp->gfns[sptep - rev_sp->spt],
-				    is_large_pte(*sptep));
+				    rev_sp->role.level);
 		if (!*rmapp) {
 			if (!printk_ratelimit())
 				return;
@@ -3377,7 +3378,7 @@ static void check_writable_mappings_rmap(struct kvm_vcpu *vcpu)
 				continue;
 			if (!(ent & PT_WRITABLE_MASK))
 				continue;
-			inspect_spte_has_rmap(vcpu->kvm, sp, &pt[i]);
+			inspect_spte_has_rmap(vcpu->kvm, &pt[i]);
 		}
 	}
 	return;
-- 
1.6.1.2

