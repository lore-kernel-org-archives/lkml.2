Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891Ab0DON2A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 09:28:00 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61391 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753720Ab0DON16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 09:27:58 -0400
Message-ID: <4BC8652F.5010006@cn.fujitsu.com>
Date: Fri, 16 Apr 2010 21:25:03 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 2/5] KVM MMU: fix kvm_mmu_zap_page() and its calling path
References: <4BC864DD.3000606@cn.fujitsu.com>
In-Reply-To: <4BC864DD.3000606@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- calculate zapped page number properly in mmu_zap_unsync_children()
- calculate freeed page number properly kvm_mmu_change_mmu_pages()

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index a23ca75..41cccd4 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1481,13 +1481,16 @@ static int mmu_zap_unsync_children(struct kvm *kvm,
 		struct kvm_mmu_page *sp;
 
 		for_each_sp(pages, sp, parents, i) {
+			if (list_empty(&kvm->arch.active_mmu_pages))
+				goto exit;
+
 			kvm_mmu_zap_page(kvm, sp);
 			mmu_pages_clear_parents(&parents);
+			zapped++;
 		}
-		zapped += pages.nr;
 		kvm_mmu_pages_init(parent, &parents, &pages);
 	}
-
+exit:
 	return zapped;
 }
 
@@ -1540,7 +1543,7 @@ void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned int kvm_nr_mmu_pages)
 
 			page = container_of(kvm->arch.active_mmu_pages.prev,
 					    struct kvm_mmu_page, link);
-			kvm_mmu_zap_page(kvm, page);
+			used_pages -= kvm_mmu_zap_page(kvm, page);
 			used_pages--;
 		}
 		kvm->arch.n_free_mmu_pages = 0;
@@ -1589,7 +1592,8 @@ static void mmu_unshadow(struct kvm *kvm, gfn_t gfn)
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

