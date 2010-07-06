Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab0GFKw0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 06:52:26 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56738 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753822Ab0GFKwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 06:52:25 -0400
Message-ID: <4C330A00.50108@cn.fujitsu.com>
Date: Tue, 06 Jul 2010 18:48:32 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: [PATCH v5 5/9] KVM: MMU: introduce gfn_to_page_many_atomic() function
References: <4C330918.6040709@cn.fujitsu.com>
In-Reply-To: <4C330918.6040709@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function not only return the gfn's page but also the page number
after @gfn in the slot

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 include/linux/kvm_host.h |    2 ++
 virt/kvm/kvm_main.c      |   29 ++++++++++++++++++++++++++++-
 2 files changed, 30 insertions(+), 1 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index e0fb543..53f663c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -288,6 +288,8 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 void kvm_disable_largepages(void);
 void kvm_arch_flush_shadow(struct kvm *kvm);
 
+int gfn_to_page_many_atomic(struct kvm *kvm, gfn_t gfn,
+			    struct page **pages, int nr_pages, bool *enough);
 struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn);
 unsigned long gfn_to_hva(struct kvm *kvm, gfn_t gfn);
 void kvm_release_page_clean(struct page *page);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 5467fe5..2cc6a7d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -923,15 +923,25 @@ static unsigned long gfn_to_hva_memslot(struct kvm_memory_slot *slot, gfn_t gfn)
 	return slot->userspace_addr + (gfn - slot->base_gfn) * PAGE_SIZE;
 }
 
-unsigned long gfn_to_hva(struct kvm *kvm, gfn_t gfn)
+static unsigned long gfn_to_hva_many(struct kvm *kvm, gfn_t gfn, int *entry)
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
+
+unsigned long gfn_to_hva(struct kvm *kvm, gfn_t gfn)
+{
+	return gfn_to_hva_many(kvm, gfn, NULL);
+}
 EXPORT_SYMBOL_GPL(gfn_to_hva);
 
 static pfn_t hva_to_pfn(struct kvm *kvm, unsigned long addr, bool atomic)
@@ -1011,6 +1021,23 @@ pfn_t gfn_to_pfn_memslot(struct kvm *kvm,
 	return hva_to_pfn(kvm, addr, false);
 }
 
+int gfn_to_page_many_atomic(struct kvm *kvm, gfn_t gfn,
+			    struct page **pages, int nr_pages, bool *enough)
+{
+	unsigned long addr;
+	int entry, ret;
+
+	addr = gfn_to_hva_many(kvm, gfn, &entry);
+	if (kvm_is_error_hva(addr))
+		return -1;
+
+	entry = min(entry, nr_pages);
+	*enough = (entry == nr_pages) ? true : false;
+	ret = __get_user_pages_fast(addr, entry, 1, pages);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(gfn_to_page_many_atomic);
+
 struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
 {
 	pfn_t pfn;
-- 
1.6.1.2


