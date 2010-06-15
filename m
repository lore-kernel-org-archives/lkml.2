Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351Ab0FOCu2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 22:50:28 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54935 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756369Ab0FOCuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 22:50:24 -0400
Message-ID: <4C16E999.6050004@cn.fujitsu.com>
Date: Tue, 15 Jun 2010 10:46:49 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: [PATCH 3/6] KVM: MMU: introduce gfn_to_page_atomic() and gfn_to_pfn_atomic()
References: <4C16E6ED.7020009@cn.fujitsu.com> <4C16E75F.6020003@cn.fujitsu.com> <4C16E7AD.1060101@cn.fujitsu.com>
In-Reply-To: <4C16E7AD.1060101@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce gfn_to_page_atomic() and gfn_to_pfn_atomic(), those
functions is fast path and can used in atomic context, the later
patch will use those

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/mm/gup.c        |    2 +
 include/linux/kvm_host.h |    2 +
 virt/kvm/kvm_main.c      |   50 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/gup.c b/arch/x86/mm/gup.c
index 738e659..0c9034b 100644
--- a/arch/x86/mm/gup.c
+++ b/arch/x86/mm/gup.c
@@ -6,6 +6,7 @@
  */
 #include <linux/sched.h>
 #include <linux/mm.h>
+#include <linux/module.h>
 #include <linux/vmstat.h>
 #include <linux/highmem.h>
 
@@ -274,6 +275,7 @@ int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
 
 	return nr;
 }
+EXPORT_SYMBOL_GPL(__get_user_pages_fast);
 
 /**
  * get_user_pages_fast() - pin user pages in memory
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 2d96555..98c3e00 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -289,6 +289,7 @@ void kvm_arch_flush_shadow(struct kvm *kvm);
 gfn_t unalias_gfn(struct kvm *kvm, gfn_t gfn);
 gfn_t unalias_gfn_instantiation(struct kvm *kvm, gfn_t gfn);
 
+struct page *gfn_to_page_atomic(struct kvm *kvm, gfn_t gfn);
 struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn);
 unsigned long gfn_to_hva(struct kvm *kvm, gfn_t gfn);
 void kvm_release_page_clean(struct page *page);
@@ -296,6 +297,7 @@ void kvm_release_page_dirty(struct page *page);
 void kvm_set_page_dirty(struct page *page);
 void kvm_set_page_accessed(struct page *page);
 
+pfn_t gfn_to_pfn_atomic(struct kvm *kvm, gfn_t gfn);
 pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t gfn);
 pfn_t gfn_to_pfn_memslot(struct kvm *kvm,
 			 struct kvm_memory_slot *slot, gfn_t gfn);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 84a0906..b806f29 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -942,6 +942,41 @@ unsigned long gfn_to_hva(struct kvm *kvm, gfn_t gfn)
 }
 EXPORT_SYMBOL_GPL(gfn_to_hva);
 
+static pfn_t hva_to_pfn_atomic(struct kvm *kvm, unsigned long addr)
+{
+	struct page *page[1];
+	int npages;
+	pfn_t pfn;
+
+	npages = __get_user_pages_fast(addr, 1, 1, page);
+
+	if (unlikely(npages != 1)) {
+		if (is_hwpoison_address(addr)) {
+			get_page(hwpoison_page);
+			return page_to_pfn(hwpoison_page);
+		}
+		get_page(bad_page);
+		return page_to_pfn(bad_page);
+	} else
+		pfn = page_to_pfn(page[0]);
+
+	return pfn;
+}
+
+pfn_t gfn_to_pfn_atomic(struct kvm *kvm, gfn_t gfn)
+{
+	unsigned long addr;
+
+	addr = gfn_to_hva(kvm, gfn);
+	if (kvm_is_error_hva(addr)) {
+		get_page(bad_page);
+		return page_to_pfn(bad_page);
+	}
+
+	return hva_to_pfn_atomic(kvm, addr);
+}
+EXPORT_SYMBOL_GPL(gfn_to_pfn_atomic);
+
 static pfn_t hva_to_pfn(struct kvm *kvm, unsigned long addr)
 {
 	struct page *page[1];
@@ -1000,6 +1035,21 @@ pfn_t gfn_to_pfn_memslot(struct kvm *kvm,
 	return hva_to_pfn(kvm, addr);
 }
 
+struct page *gfn_to_page_atomic(struct kvm *kvm, gfn_t gfn)
+{
+	pfn_t pfn;
+
+	pfn = gfn_to_pfn_atomic(kvm, gfn);
+	if (!kvm_is_mmio_pfn(pfn))
+		return pfn_to_page(pfn);
+
+	WARN_ON(kvm_is_mmio_pfn(pfn));
+
+	get_page(bad_page);
+	return bad_page;
+}
+EXPORT_SYMBOL_GPL(gfn_to_page_atomic);
+
 struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
 {
 	pfn_t pfn;
-- 
1.6.1.2


