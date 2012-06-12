Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997Ab2FLCsJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 22:48:09 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:48574 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393Ab2FLCsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 22:48:07 -0400
Message-ID: <4FD6ADDF.8080308@linux.vnet.ibm.com>
Date: Tue, 12 Jun 2012 10:47:59 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v3 3/6] KVM: introduce gfn_to_pfn_memslot_atomic
References: <4FD6ADA6.40008@linux.vnet.ibm.com>
In-Reply-To: <4FD6ADA6.40008@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12061116-5140-0000-0000-0000018FA8AB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It can instead of hva_to_pfn_atomic

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c       |    5 +----
 include/linux/kvm_host.h |    3 ++-
 virt/kvm/kvm_main.c      |   15 +++++++++------
 3 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index bfdcaa0..9bd9d0a 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2444,7 +2444,6 @@ static pfn_t pte_prefetch_gfn_to_pfn(struct kvm_vcpu *vcpu, gfn_t gfn,
 				     bool no_dirty_log)
 {
 	struct kvm_memory_slot *slot;
-	unsigned long hva;

 	slot = gfn_to_memslot_dirty_bitmap(vcpu, gfn, no_dirty_log);
 	if (!slot) {
@@ -2452,9 +2451,7 @@ static pfn_t pte_prefetch_gfn_to_pfn(struct kvm_vcpu *vcpu, gfn_t gfn,
 		return page_to_pfn(fault_page);
 	}

-	hva = gfn_to_hva_memslot(slot, gfn);
-
-	return hva_to_pfn_atomic(vcpu->kvm, hva);
+	return gfn_to_pfn_memslot_atomic(vcpu->kvm, slot, gfn);
 }

 static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index cf6bb58..62830cc 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -429,7 +429,6 @@ void kvm_release_page_dirty(struct page *page);
 void kvm_set_page_dirty(struct page *page);
 void kvm_set_page_accessed(struct page *page);

-pfn_t hva_to_pfn_atomic(struct kvm *kvm, unsigned long addr);
 pfn_t gfn_to_pfn_atomic(struct kvm *kvm, gfn_t gfn);
 pfn_t gfn_to_pfn_async(struct kvm *kvm, gfn_t gfn, bool *async,
 		       bool write_fault, bool *writable);
@@ -438,6 +437,8 @@ pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
 		      bool *writable);
 pfn_t gfn_to_pfn_memslot(struct kvm *kvm,
 			 struct kvm_memory_slot *slot, gfn_t gfn);
+pfn_t gfn_to_pfn_memslot_atomic(struct kvm *kvm,
+				struct kvm_memory_slot *slot, gfn_t gfn);
 void kvm_release_pfn_dirty(pfn_t);
 void kvm_release_pfn_clean(pfn_t pfn);
 void kvm_set_pfn_dirty(pfn_t pfn);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6a7756c..c59fad6 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1158,12 +1158,6 @@ static pfn_t hva_to_pfn(struct kvm *kvm, unsigned long addr, bool atomic,
 	return pfn;
 }

-pfn_t hva_to_pfn_atomic(struct kvm *kvm, unsigned long addr)
-{
-	return hva_to_pfn(kvm, addr, true, NULL, true, NULL);
-}
-EXPORT_SYMBOL_GPL(hva_to_pfn_atomic);
-
 static pfn_t __gfn_to_pfn(struct kvm *kvm, gfn_t gfn, bool atomic, bool *async,
 			  bool write_fault, bool *writable)
 {
@@ -1214,6 +1208,15 @@ pfn_t gfn_to_pfn_memslot(struct kvm *kvm,
 	return hva_to_pfn(kvm, addr, false, NULL, true, NULL);
 }

+pfn_t gfn_to_pfn_memslot_atomic(struct kvm *kvm,
+				struct kvm_memory_slot *slot, gfn_t gfn)
+{
+	unsigned long addr = gfn_to_hva_memslot(slot, gfn);
+
+	return hva_to_pfn(kvm, addr, true, NULL, true, NULL);
+}
+EXPORT_SYMBOL_GPL(gfn_to_pfn_memslot_atomic);
+
 int gfn_to_page_many_atomic(struct kvm *kvm, gfn_t gfn, struct page **pages,
 								  int nr_pages)
 {
-- 
1.7.7.6

