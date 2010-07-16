Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935548Ab0GPD1L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 23:27:11 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61239 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S935497Ab0GPD1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 23:27:08 -0400
Message-ID: <4C3FD098.4090701@cn.fujitsu.com>
Date: Fri, 16 Jul 2010 11:23:04 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: [PATCH v2 2/6] KVM: MMU: fix page accessed tracking lost if ept is
 enabled
References: <4C3FCFD7.5070005@cn.fujitsu.com>
In-Reply-To: <4C3FCFD7.5070005@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current code, if ept is enabled(shadow_accessed_mask = 0), the page
accessed tracking is lost

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 1a4b42e..5937054 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -687,7 +687,7 @@ static void drop_spte(struct kvm *kvm, u64 *sptep, u64 new_spte)
 	if (!is_rmap_spte(old_spte))
 		return;
 	pfn = spte_to_pfn(old_spte);
-	if (old_spte & shadow_accessed_mask)
+	if (!shadow_accessed_mask || old_spte & shadow_accessed_mask)
 		kvm_set_pfn_accessed(pfn);
 	if (is_writable_pte(old_spte))
 		kvm_set_pfn_dirty(pfn);
@@ -815,7 +815,8 @@ static int kvm_set_pte_rmapp(struct kvm *kvm, unsigned long *rmapp,
 				kvm_set_pfn_dirty(spte_to_pfn(*spte));
 			old_spte = __xchg_spte(spte, new_spte);
 			if (is_shadow_present_pte(old_spte)
-			    && (old_spte & shadow_accessed_mask))
+			    && (!shadow_accessed_mask ||
+			    old_spte & shadow_accessed_mask))
 				mark_page_accessed(pfn_to_page(spte_to_pfn(old_spte)));
 			spte = rmap_next(kvm, rmapp, spte);
 		}
-- 
1.6.1.2


