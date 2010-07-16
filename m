Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935582Ab0GPDcK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 23:32:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60273 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S935559Ab0GPDcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 23:32:08 -0400
Message-ID: <4C3FD1C9.5010909@cn.fujitsu.com>
Date: Fri, 16 Jul 2010 11:28:09 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: [PATCH v2 5/6] KVM: MMU: cleanup spte set and accssed/dirty tracking
References: <4C3FCFD7.5070005@cn.fujitsu.com>
In-Reply-To: <4C3FCFD7.5070005@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce set_spte_track_bits() to cleanup current code

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 4123e8e..fb3ae54 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -679,7 +679,7 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
 	}
 }
 
-static void drop_spte(struct kvm *kvm, u64 *sptep, u64 new_spte)
+static void set_spte_track_bits(u64 *sptep, u64 new_spte)
 {
 	pfn_t pfn;
 	u64 old_spte;
@@ -692,6 +692,11 @@ static void drop_spte(struct kvm *kvm, u64 *sptep, u64 new_spte)
 		kvm_set_pfn_accessed(pfn);
 	if (is_writable_pte(old_spte))
 		kvm_set_pfn_dirty(pfn);
+}
+
+static void drop_spte(struct kvm *kvm, u64 *sptep, u64 new_spte)
+{
+	set_spte_track_bits(sptep, new_spte);
 	rmap_remove(kvm, sptep);
 }
 
@@ -791,7 +796,7 @@ static int kvm_set_pte_rmapp(struct kvm *kvm, unsigned long *rmapp,
 			     unsigned long data)
 {
 	int need_flush = 0;
-	u64 *spte, new_spte, old_spte;
+	u64 *spte, new_spte;
 	pte_t *ptep = (pte_t *)data;
 	pfn_t new_pfn;
 
@@ -812,13 +817,7 @@ static int kvm_set_pte_rmapp(struct kvm *kvm, unsigned long *rmapp,
 			new_spte &= ~PT_WRITABLE_MASK;
 			new_spte &= ~SPTE_HOST_WRITEABLE;
 			new_spte &= ~shadow_accessed_mask;
-			if (is_writable_pte(*spte))
-				kvm_set_pfn_dirty(spte_to_pfn(*spte));
-			old_spte = __xchg_spte(spte, new_spte);
-			if (is_shadow_present_pte(old_spte)
-			    && (!shadow_accessed_mask ||
-			    old_spte & shadow_accessed_mask))
-				mark_page_accessed(pfn_to_page(spte_to_pfn(old_spte)));
+			set_spte_track_bits(spte, new_spte);
 			spte = rmap_next(kvm, rmapp, spte);
 		}
 	}
-- 
1.6.1.2


