Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479Ab0GMJr7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 05:47:59 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52088 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752231Ab0GMJr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 05:47:57 -0400
Message-ID: <4C3C355E.1010202@cn.fujitsu.com>
Date: Tue, 13 Jul 2010 17:43:58 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: LKML <linux-kernel@vger.kernel.org>, KVM list <kvm@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 2/4] KVM: MMU: cleanup spte update path
References: <4C3C3518.7080505@cn.fujitsu.com>
In-Reply-To: <4C3C3518.7080505@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce set_spte_atomic() helper function to cleanup current code

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |   37 +++++++++++++++++++------------------
 1 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 9fc1524..67dbafa 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -303,6 +303,22 @@ static u64 __xchg_spte(u64 *sptep, u64 new_spte)
 #endif
 }
 
+static void set_spte_atomic(u64 *sptep, u64 new_spte)
+{
+	pfn_t pfn;
+	u64 old_spte;
+
+	old_spte = __xchg_spte(sptep, new_spte);
+	if (!is_rmap_spte(old_spte))
+		return;
+
+	pfn = spte_to_pfn(old_spte);
+	if (old_spte & shadow_accessed_mask)
+		kvm_set_pfn_accessed(pfn);
+	if (is_writable_pte(old_spte))
+		kvm_set_pfn_dirty(pfn);
+}
+
 static void update_spte(u64 *sptep, u64 new_spte)
 {
 	u64 old_spte;
@@ -680,17 +696,7 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
 
 static void drop_spte(struct kvm *kvm, u64 *sptep, u64 new_spte)
 {
-	pfn_t pfn;
-	u64 old_spte;
-
-	old_spte = __xchg_spte(sptep, new_spte);
-	if (!is_rmap_spte(old_spte))
-		return;
-	pfn = spte_to_pfn(old_spte);
-	if (old_spte & shadow_accessed_mask)
-		kvm_set_pfn_accessed(pfn);
-	if (is_writable_pte(old_spte))
-		kvm_set_pfn_dirty(pfn);
+	set_spte_atomic(sptep, new_spte);
 	rmap_remove(kvm, sptep);
 }
 
@@ -790,7 +796,7 @@ static int kvm_set_pte_rmapp(struct kvm *kvm, unsigned long *rmapp,
 			     unsigned long data)
 {
 	int need_flush = 0;
-	u64 *spte, new_spte, old_spte;
+	u64 *spte, new_spte;
 	pte_t *ptep = (pte_t *)data;
 	pfn_t new_pfn;
 
@@ -811,12 +817,7 @@ static int kvm_set_pte_rmapp(struct kvm *kvm, unsigned long *rmapp,
 			new_spte &= ~PT_WRITABLE_MASK;
 			new_spte &= ~SPTE_HOST_WRITEABLE;
 			new_spte &= ~shadow_accessed_mask;
-			if (is_writable_pte(*spte))
-				kvm_set_pfn_dirty(spte_to_pfn(*spte));
-			old_spte = __xchg_spte(spte, new_spte);
-			if (is_shadow_present_pte(old_spte)
-			    && (old_spte & shadow_accessed_mask))
-				mark_page_accessed(pfn_to_page(spte_to_pfn(old_spte)));
+			set_spte_atomic(spte, new_spte);
 			spte = rmap_next(kvm, rmapp, spte);
 		}
 	}
-- 
1.6.1.2


