Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932Ab0HULH1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 07:07:27 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62198 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751819Ab0HULHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 07:07:25 -0400
Message-ID: <4C7105EF.6050009@cn.fujitsu.com>
Date: Sun, 22 Aug 2010 19:11:43 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v7 3/5] KVM: MMU: introduce gfn_to_page_many_atomic() function
References: <4C710549.9090704@cn.fujitsu.com>
In-Reply-To: <4C710549.9090704@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce this function to get consecutive gfn's pages, it can reduce
gup's overload, used by later patch

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 include/linux/kvm_host.h |    3 +++
 virt/kvm/kvm_main.c      |   29 ++++++++++++++++++++++++++++-
 2 files changed, 31 insertions(+), 1 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 307d0e2..b837ec8 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -289,6 +289,9 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 void kvm_disable_largepages(void);
 void kvm_arch_flush_shadow(struct kvm *kvm);
 
+int gfn_to_page_many_atomic(struct kvm *kvm, gfn_t gfn, struct page **pages,
+			    int nr_pages);
+
 struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn);
 unsigned long gfn_to_hva(struct kvm *kvm, gfn_t gfn);
 void kvm_release_page_clean(struct page *page);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2dc0c18..a92469d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -927,15 +927,25 @@ int memslot_id(struct kvm *kvm, gfn_t gfn)
 	return memslot - slots->memslots;
 }
 
-unsigned long gfn_to_hva(struct kvm *kvm, gfn_t gfn)
+static unsigned long gfn_to_hva_many(struct kvm *kvm, gfn_t gfn,
+				     gfn_t *nr_pages)
 {
 	struct kvm_memory_slot *slot;
 
 	slot = gfn_to_memslot(kvm, gfn);
 	if (!slot || slot->flags & KVM_MEMSLOT_INVALID)
 		return bad_hva();
+
+	if (nr_pages)
+		*nr_pages = slot->npages - (gfn - slot->base_gfn);
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
@@ -1010,6 +1020,23 @@ pfn_t gfn_to_pfn_memslot(struct kvm *kvm,
 	return hva_to_pfn(kvm, addr, false);
 }
 
+int gfn_to_page_many_atomic(struct kvm *kvm, gfn_t gfn, struct page **pages,
+								  int nr_pages)
+{
+	unsigned long addr;
+	gfn_t entry;
+
+	addr = gfn_to_hva_many(kvm, gfn, &entry);
+	if (kvm_is_error_hva(addr))
+		return -1;
+
+	if (entry < nr_pages)
+		return 0;
+
+	return __get_user_pages_fast(addr, nr_pages, 1, pages);
+}
+EXPORT_SYMBOL_GPL(gfn_to_page_many_atomic);
+
 struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
 {
 	pfn_t pfn;
-- 
1.7.0.4

