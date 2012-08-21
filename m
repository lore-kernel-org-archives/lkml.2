Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224Ab2HUDDM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 23:03:12 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:58284 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755775Ab2HUDDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 23:03:08 -0400
Message-ID: <5032FA1E.9080105@linux.vnet.ibm.com>
Date: Tue, 21 Aug 2012 11:01:50 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v6 09/12] KVM: introduce KVM_HVA_ERR_BAD
References: <5032F8FD.2020306@linux.vnet.ibm.com>
In-Reply-To: <5032F8FD.2020306@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12082103-2000-0000-0000-000008C7C6E3
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
index 4fd33e0..b9bba60 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -82,6 +82,13 @@ static inline bool is_invalid_pfn(pfn_t pfn)
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
@@ -430,7 +437,6 @@ id_to_memslot(struct kvm_memslots *slots, int id)
 	return slot;
 }

-int kvm_is_error_hva(unsigned long addr);
 int kvm_set_memory_region(struct kvm *kvm,
 			  struct kvm_userspace_memory_region *mem,
 			  int user_alloc);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c89d1b5..e3e1658 100644
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

