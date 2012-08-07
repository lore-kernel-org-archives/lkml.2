Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab2HGJxD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 05:53:03 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:52794 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab2HGJxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 05:53:01 -0400
Message-ID: <5020E574.3000502@linux.vnet.ibm.com>
Date: Tue, 07 Aug 2012 17:52:52 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v5 08/12] KVM: introduce KVM_HVA_ERR_BAD
References: <5020E423.9080004@linux.vnet.ibm.com>
In-Reply-To: <5020E423.9080004@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12080709-2674-0000-0000-00000583EA8C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Then, remove bad_hva and inline kvm_is_error_hva

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 include/linux/kvm_host.h |    8 +++++++-
 virt/kvm/kvm_main.c      |   13 +------------
 2 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 8306f24..7737e45 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -77,6 +77,13 @@ static inline bool is_invalid_pfn(pfn_t pfn)
 	return !is_noslot_pfn(pfn) && is_error_pfn(pfn);
 }

+#define KVM_HVA_ERR_BAD	(PAGE_OFFSET)
+
+static inline bool kvm_is_error_hva(unsigned long addr)
+{
+	return addr == PAGE_OFFSET;
+}
+
 #define KVM_ERR_PTR_BAD_PAGE	(ERR_PTR(-ENOENT))

 static inline bool is_error_page(struct page *page)
@@ -425,7 +432,6 @@ id_to_memslot(struct kvm_memslots *slots, int id)
 	return slot;
 }

-int kvm_is_error_hva(unsigned long addr);
 int kvm_set_memory_region(struct kvm *kvm,
 			  struct kvm_userspace_memory_region *mem,
 			  int user_alloc);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index bf6dede..1bd83a6 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -931,17 +931,6 @@ void kvm_disable_largepages(void)
 }
 EXPORT_SYMBOL_GPL(kvm_disable_largepages);

-static inline unsigned long bad_hva(void)
-{
-	return PAGE_OFFSET;
-}
-
-int kvm_is_error_hva(unsigned long addr)
-{
-	return addr == bad_hva();
-}
-EXPORT_SYMBOL_GPL(kvm_is_error_hva);
-
 struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn)
 {
 	return __gfn_to_memslot(kvm_memslots(kvm), gfn);
@@ -988,7 +977,7 @@ static unsigned long gfn_to_hva_many(struct kvm_memory_slot *slot, gfn_t gfn,
 				     gfn_t *nr_pages)
 {
 	if (!slot || slot->flags & KVM_MEMSLOT_INVALID)
-		return bad_hva();
+		return KVM_HVA_ERR_BAD;

 	if (nr_pages)
 		*nr_pages = slot->npages - (gfn - slot->base_gfn);
-- 
1.7.7.6

