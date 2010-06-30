Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671Ab0F3IKS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 04:10:18 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57013 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751934Ab0F3IKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 04:10:16 -0400
Message-ID: <4C2AFB05.10602@cn.fujitsu.com>
Date: Wed, 30 Jun 2010 16:06:29 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: [PATCH v3 7/11] KVM: MMU: introduce gfn_to_hva_many() function
References: <4C2AF9FA.9020601@cn.fujitsu.com>
In-Reply-To: <4C2AF9FA.9020601@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function not only return the gfn's hva but also the page number
after @gfn in the slot

It's used in the later patch

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 include/linux/kvm_host.h |    1 +
 virt/kvm/kvm_main.c      |   13 ++++++++++++-
 2 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 515fefd..8f7af32 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -289,6 +289,7 @@ void kvm_disable_largepages(void);
 void kvm_arch_flush_shadow(struct kvm *kvm);
 
 struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn);
+unsigned long gfn_to_hva_many(struct kvm *kvm, gfn_t gfn, int *entry);
 unsigned long gfn_to_hva(struct kvm *kvm, gfn_t gfn);
 void kvm_release_page_clean(struct page *page);
 void kvm_release_page_dirty(struct page *page);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 60bb3d5..a007889 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -913,15 +913,26 @@ static unsigned long gfn_to_hva_memslot(struct kvm_memory_slot *slot, gfn_t gfn)
 	return slot->userspace_addr + (gfn - slot->base_gfn) * PAGE_SIZE;
 }
 
-unsigned long gfn_to_hva(struct kvm *kvm, gfn_t gfn)
+unsigned long gfn_to_hva_many(struct kvm *kvm, gfn_t gfn, int *entry)
 {
 	struct kvm_memory_slot *slot;
 
 	slot = gfn_to_memslot(kvm, gfn);
+
 	if (!slot || slot->flags & KVM_MEMSLOT_INVALID)
 		return bad_hva();
+
+	if (entry)
+		*entry = slot->npages - (gfn - slot->base_gfn);
+
 	return gfn_to_hva_memslot(slot, gfn);
 }
+EXPORT_SYMBOL_GPL(gfn_to_hva_many);
+
+unsigned long gfn_to_hva(struct kvm *kvm, gfn_t gfn)
+{
+	return gfn_to_hva_many(kvm, gfn, NULL);
+}
 EXPORT_SYMBOL_GPL(gfn_to_hva);
 
 static pfn_t hva_to_pfn(struct kvm *kvm, unsigned long addr, bool atomic)
-- 
1.6.1.2


