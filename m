Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155Ab0DVUI3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:08:29 -0400
Received: from kroah.org ([198.145.64.141]:60130 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758174Ab0DVUCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:02:10 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:18 2010
Message-Id: <20100422195418.765388130@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:55:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Marcelo Tosatti <mtosatti@redhat.com>
Subject: [134/139] KVM: MMU: fix kvm_mmu_zap_page() and its calling path
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

(Cherry-picked from commit 77662e0028c7c63e34257fda03ff9625c59d939d)

This patch fix:

- calculate zapped page number properly in mmu_zap_unsync_children()
- calculate freeed page number properly kvm_mmu_change_mmu_pages()
- if zapped children page it shoud restart hlist walking

KVM-Stable-Tag.
Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/mmu.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1502,8 +1502,8 @@ static int mmu_zap_unsync_children(struc
 		for_each_sp(pages, sp, parents, i) {
 			kvm_mmu_zap_page(kvm, sp);
 			mmu_pages_clear_parents(&parents);
+			zapped++;
 		}
-		zapped += pages.nr;
 		kvm_mmu_pages_init(parent, &parents, &pages);
 	}
 
@@ -1554,14 +1554,16 @@ void kvm_mmu_change_mmu_pages(struct kvm
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
@@ -1608,7 +1610,8 @@ static void mmu_unshadow(struct kvm *kvm
 		    && !sp->role.invalid) {
 			pgprintk("%s: zap %lx %x\n",
 				 __func__, gfn, sp->role.word);
-			kvm_mmu_zap_page(kvm, sp);
+			if (kvm_mmu_zap_page(kvm, sp))
+				nn = bucket->first;
 		}
 	}
 }


