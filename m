Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab2GQOmD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 10:42:03 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:40884 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab2GQOmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 10:42:00 -0400
Message-ID: <500579B1.9070804@linux.vnet.ibm.com>
Date: Tue, 17 Jul 2012 22:41:53 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 03/10] KVM: introduce gfn_to_pfn_memslot_atomic
References: <5005791B.8040807@linux.vnet.ibm.com>
In-Reply-To: <5005791B.8040807@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12071714-8256-0000-0000-00000359A301
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It can instead of hva_to_pfn_atomic

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c       |    5 +----
 include/linux/kvm_host.h |    3 ++-
 virt/kvm/kvm_main.c      |   14 ++++++++------
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 4ed543a..13d3c69 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2480,15 +2480,12 @@ static pfn_t pte_prefetch_gfn_to_pfn(struct kvm_vcpu *vcpu, gfn_t gfn,
 				     bool no_dirty_log)
 {
 	struct kvm_memory_slot *slot;
-	unsigned long hva;

 	slot = gfn_to_memslot_dirty_bitmap(vcpu, gfn, no_dirty_log);
 	if (!slot)
 		return get_fault_pfn();

-	hva = gfn_to_hva_memslot(slot, gfn);
-
-	return hva_to_pfn_atomic(hva);
+	return gfn_to_pfn_memslot_atomic(slot, gfn);
 }

 static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 8e6bc51..e4815e9 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -420,7 +420,6 @@ void kvm_release_page_dirty(struct page *page);
 void kvm_set_page_dirty(struct page *page);
 void kvm_set_page_accessed(struct page *page);

-pfn_t hva_to_pfn_atomic(unsigned long addr);
 pfn_t gfn_to_pfn_atomic(struct kvm *kvm, gfn_t gfn);
 pfn_t gfn_to_pfn_async(struct kvm *kvm, gfn_t gfn, bool *async,
 		       bool write_fault, bool *writable);
@@ -428,6 +427,8 @@ pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t gfn);
 pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
 		      bool *writable);
 pfn_t gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn);
+pfn_t gfn_to_pfn_memslot_atomic(struct kvm_memory_slot *slot, gfn_t gfn);
+
 void kvm_release_pfn_dirty(pfn_t);
 void kvm_release_pfn_clean(pfn_t pfn);
 void kvm_set_pfn_dirty(pfn_t pfn);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7cb29bb..6c1e746 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1156,12 +1156,6 @@ static pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
 	return pfn;
 }

-pfn_t hva_to_pfn_atomic(unsigned long addr)
-{
-	return hva_to_pfn(addr, true, NULL, true, NULL);
-}
-EXPORT_SYMBOL_GPL(hva_to_pfn_atomic);
-
 static pfn_t __gfn_to_pfn(struct kvm *kvm, gfn_t gfn, bool atomic, bool *async,
 			  bool write_fault, bool *writable)
 {
@@ -1211,6 +1205,14 @@ pfn_t gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn)
 	return hva_to_pfn(addr, false, NULL, true, NULL);
 }

+pfn_t gfn_to_pfn_memslot_atomic(struct kvm_memory_slot *slot, gfn_t gfn)
+{
+	unsigned long addr = gfn_to_hva_memslot(slot, gfn);
+
+	return hva_to_pfn(addr, true, NULL, true, NULL);
+}
+EXPORT_SYMBOL_GPL(gfn_to_pfn_memslot_atomic);
+
 int gfn_to_page_many_atomic(struct kvm *kvm, gfn_t gfn, struct page **pages,
 								  int nr_pages)
 {
-- 
1.7.7.6

