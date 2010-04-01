Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572Ab0DAIz1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 04:55:27 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56214 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754484Ab0DAIzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 04:55:18 -0400
Message-ID: <4BB45EE2.3010000@cn.fujitsu.com>
Date: Thu, 01 Apr 2010 16:52:50 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] KVM MMU: record reverse mapping for spte only if it's
 writable
References: <4BB45E65.2040006@cn.fujitsu.com>
In-Reply-To: <4BB45E65.2040006@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The read only spte mapping can't hurt shadow page cache,
so, no need to record it.

Using bit9 to record whether the spte is re-mapped

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |   17 +++++++++++++++--
 arch/x86/kvm/mmu.h |    1 +
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 5de92ae..999f572 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -259,7 +259,17 @@ static int is_dirty_gpte(unsigned long pte)
 
 static int is_rmap_spte(u64 pte)
 {
-	return is_shadow_present_pte(pte);
+	return pte & PT_RMAP_MASK;
+}
+
+static void spte_set_rmap(u64 *spte)
+{
+	*spte |= PT_RMAP_MASK;
+}
+
+static void spte_clear_rmap(u64 *spte)
+{
+	*spte &= ~PT_RMAP_MASK;
 }
 
 static int is_last_spte(u64 pte, int level)
@@ -543,7 +553,7 @@ static int rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
 	unsigned long *rmapp;
 	int i, count = 0;
 
-	if (!is_rmap_spte(*spte))
+	if (!is_shadow_present_pte(*spte) || !is_writable_pte(*spte))
 		return count;
 	gfn = unalias_gfn(vcpu->kvm, gfn);
 	sp = page_header(__pa(spte));
@@ -573,6 +583,7 @@ static int rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
 			;
 		desc->sptes[i] = spte;
 	}
+	spte_set_rmap(spte);
 	return count;
 }
 
@@ -610,6 +621,7 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
 
 	if (!is_rmap_spte(*spte))
 		return;
+	spte_clear_rmap(spte);
 	sp = page_header(__pa(spte));
 	pfn = spte_to_pfn(*spte);
 	if (*spte & shadow_accessed_mask)
@@ -646,6 +658,7 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
 		pr_err("rmap_remove: %p %llx many->many\n", spte, *spte);
 		BUG();
 	}
+
 }
 
 static u64 *rmap_next(struct kvm *kvm, unsigned long *rmapp, u64 *spte)
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index be66759..166b9b5 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -22,6 +22,7 @@
 #define PT_PAGE_SIZE_MASK (1ULL << 7)
 #define PT_PAT_MASK (1ULL << 7)
 #define PT_GLOBAL_MASK (1ULL << 8)
+#define PT_RMAP_MASK (1ULL << 9)
 #define PT64_NX_SHIFT 63
 #define PT64_NX_MASK (1ULL << PT64_NX_SHIFT)
 
-- 
1.6.1.2





