Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542Ab2HCHle (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 03:41:34 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:35251 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab2HCHlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 03:41:31 -0400
Message-ID: <501B80A2.905@linux.vnet.ibm.com>
Date: Fri, 03 Aug 2012 15:41:22 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 07/10] KVM: introduce KVM_ERR_PTR_BAD_PAGE
References: <501B7F94.7090308@linux.vnet.ibm.com>
In-Reply-To: <501B7F94.7090308@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12080307-5564-0000-0000-000003DC401E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is used to eliminate the overload of function call and cleanup
the code

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 include/linux/kvm_host.h |    9 +++++++--
 virt/kvm/async_pf.c      |    2 +-
 virt/kvm/kvm_main.c      |   13 +------------
 3 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index bdf2182..0aebe7a 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -68,6 +68,13 @@ static inline int is_invalid_pfn(pfn_t pfn)
 	return !is_noslot_pfn(pfn) && is_error_pfn(pfn);
 }

+#define KVM_ERR_PTR_BAD_PAGE	(ERR_PTR(-ENOENT))
+
+static inline int is_error_page(struct page *page)
+{
+	return IS_ERR(page);
+}
+
 /*
  * vcpu->requests bit members
  */
@@ -410,7 +417,6 @@ id_to_memslot(struct kvm_memslots *slots, int id)
 	return slot;
 }

-int is_error_page(struct page *page);
 int kvm_is_error_hva(unsigned long addr);
 int kvm_set_memory_region(struct kvm *kvm,
 			  struct kvm_userspace_memory_region *mem,
@@ -437,7 +443,6 @@ void kvm_arch_flush_shadow(struct kvm *kvm);
 int gfn_to_page_many_atomic(struct kvm *kvm, gfn_t gfn, struct page **pages,
 			    int nr_pages);

-struct page *get_bad_page(void);
 struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn);
 unsigned long gfn_to_hva(struct kvm *kvm, gfn_t gfn);
 void kvm_release_page_clean(struct page *page);
diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
index 7972278..56f5533 100644
--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -203,7 +203,7 @@ int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu)
 	if (!work)
 		return -ENOMEM;

-	work->page = get_bad_page();
+	work->page = KVM_ERR_PTR_BAD_PAGE;
 	INIT_LIST_HEAD(&work->queue); /* for list_del to work */

 	spin_lock(&vcpu->async_pf.lock);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 08b600b..5873031 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -931,17 +931,6 @@ void kvm_disable_largepages(void)
 }
 EXPORT_SYMBOL_GPL(kvm_disable_largepages);

-int is_error_page(struct page *page)
-{
-	return IS_ERR(page);
-}
-EXPORT_SYMBOL_GPL(is_error_page);
-
-struct page *get_bad_page(void)
-{
-	return ERR_PTR(-ENOENT);
-}
-
 static inline unsigned long bad_hva(void)
 {
 	return PAGE_OFFSET;
@@ -1188,7 +1177,7 @@ static struct page *kvm_pfn_to_page(pfn_t pfn)
 	WARN_ON(kvm_is_mmio_pfn(pfn));

 	if (is_error_pfn(pfn) || kvm_is_mmio_pfn(pfn))
-		return get_bad_page();
+		return KVM_ERR_PTR_BAD_PAGE;

 	return pfn_to_page(pfn);
 }
-- 
1.7.7.6

