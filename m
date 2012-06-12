Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262Ab2FLCse (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 22:48:34 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:38357 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351Ab2FLCsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 22:48:32 -0400
Message-ID: <4FD6ADF6.2030802@linux.vnet.ibm.com>
Date: Tue, 12 Jun 2012 10:48:22 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v3 4/6] KVM: pass slot to hva_to_pfn
References: <4FD6ADA6.40008@linux.vnet.ibm.com>
In-Reply-To: <4FD6ADA6.40008@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12061116-6102-0000-0000-000001ABDB19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This parameter will be used in the later patch

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 virt/kvm/kvm_main.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c59fad6..811c3ee 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1077,8 +1077,9 @@ static inline int check_user_page_hwpoison(unsigned long addr)
 	return rc == -EHWPOISON;
 }

-static pfn_t hva_to_pfn(struct kvm *kvm, unsigned long addr, bool atomic,
-			bool *async, bool write_fault, bool *writable)
+static pfn_t hva_to_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
+			unsigned long addr, bool atomic, bool *async,
+			bool write_fault, bool *writable)
 {
 	struct page *page[1];
 	int npages = 0;
@@ -1161,18 +1162,22 @@ static pfn_t hva_to_pfn(struct kvm *kvm, unsigned long addr, bool atomic,
 static pfn_t __gfn_to_pfn(struct kvm *kvm, gfn_t gfn, bool atomic, bool *async,
 			  bool write_fault, bool *writable)
 {
+	struct kvm_memory_slot *slot;
 	unsigned long addr;

 	if (async)
 		*async = false;

-	addr = gfn_to_hva(kvm, gfn);
+	slot = gfn_to_memslot(kvm, gfn);
+	addr = gfn_to_hva_many(slot, gfn, NULL);
+
 	if (kvm_is_error_hva(addr)) {
 		get_page(bad_page);
 		return page_to_pfn(bad_page);
 	}

-	return hva_to_pfn(kvm, addr, atomic, async, write_fault, writable);
+	return hva_to_pfn(kvm, slot, addr, atomic, async, write_fault,
+			  writable);
 }

 pfn_t gfn_to_pfn_atomic(struct kvm *kvm, gfn_t gfn)
@@ -1205,7 +1210,7 @@ pfn_t gfn_to_pfn_memslot(struct kvm *kvm,
 			 struct kvm_memory_slot *slot, gfn_t gfn)
 {
 	unsigned long addr = gfn_to_hva_memslot(slot, gfn);
-	return hva_to_pfn(kvm, addr, false, NULL, true, NULL);
+	return hva_to_pfn(kvm, slot, addr, false, NULL, true, NULL);
 }

 pfn_t gfn_to_pfn_memslot_atomic(struct kvm *kvm,
@@ -1213,7 +1218,7 @@ pfn_t gfn_to_pfn_memslot_atomic(struct kvm *kvm,
 {
 	unsigned long addr = gfn_to_hva_memslot(slot, gfn);

-	return hva_to_pfn(kvm, addr, true, NULL, true, NULL);
+	return hva_to_pfn(kvm, slot, addr, true, NULL, true, NULL);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_memslot_atomic);

-- 
1.7.7.6

