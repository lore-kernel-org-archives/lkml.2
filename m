Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615Ab0DPIhv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 04:37:51 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59719 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756076Ab0DPIht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 04:37:49 -0400
Message-ID: <4BC82122.4020805@cn.fujitsu.com>
Date: Fri, 16 Apr 2010 16:34:42 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 1/2] KVM MMU: fix kvm_mmu_zap_page() and its calling path
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix:

- calculate zapped page number properly in mmu_zap_unsync_children()
- calculate freeed page number properly kvm_mmu_change_mmu_pages()
- if zapped children page it shoud restart hlist walking

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index d217f9c..94c95ad 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1481,8 +1481,8 @@ static int mmu_zap_unsync_children(struct kvm *kvm,
 		for_each_sp(pages, sp, parents, i) {
 			kvm_mmu_zap_page(kvm, sp);
 			mmu_pages_clear_parents(&parents);
+			zapped++;
 		}
-		zapped += pages.nr;
 		kvm_mmu_pages_init(parent, &parents, &pages);
 	}
 
@@ -1533,14 +1533,16 @@ void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned int kvm_nr_mmu_pages)
 	 */
 
 	if (used_pages > kvm_nr_mmu_pages) {
-		while (used_pages > kvm_nr_mmu_pages) {
+		while (used_pages > kvm_nr_mmu_pages &&
+			!list_empty(&kvm->arch.active_mmu_pages)) {
 			struct kvm_mmu_page *page;
 
 			page = container_of(kvm->arch.active_mmu_pages.prev,
 					    struct kvm_mmu_page, link);
-			kvm_mmu_zap_page(kvm, page);
+			used_pages -= kvm_mmu_zap_page(kvm, page);
 			used_pages--;
 		}
+		kvm_nr_mmu_pages = used_pages;
 		kvm->arch.n_free_mmu_pages = 0;
 	}
 	else
@@ -1587,7 +1589,8 @@ static void mmu_unshadow(struct kvm *kvm, gfn_t gfn)
 		    && !sp->role.invalid) {
 			pgprintk("%s: zap %lx %x\n",
 				 __func__, gfn, sp->role.word);
-			kvm_mmu_zap_page(kvm, sp);
+			if (kvm_mmu_zap_page(kvm, sp))
+				nn = bucket->first;
 		}
 	}
 }
-- 
1.6.1.2

