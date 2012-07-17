Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189Ab2GQNyW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 09:54:22 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:51112 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754777Ab2GQNyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 09:54:18 -0400
Message-ID: <50056E83.7010403@linux.vnet.ibm.com>
Date: Tue, 17 Jul 2012 21:54:11 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 6/9] KVM: using get_fault_pfn to get the fault pfn
References: <50056DB8.7080702@linux.vnet.ibm.com>
In-Reply-To: <50056DB8.7080702@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12071703-9264-0000-0000-000001EE0C4C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using get_fault_pfn to cleanup the code

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c       |    6 ++----
 include/linux/kvm_host.h |    5 +----
 virt/kvm/kvm_main.c      |   13 ++++---------
 3 files changed, 7 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index a846a9c..e23cdae 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2483,10 +2483,8 @@ static pfn_t pte_prefetch_gfn_to_pfn(struct kvm_vcpu *vcpu, gfn_t gfn,
 	unsigned long hva;

 	slot = gfn_to_memslot_dirty_bitmap(vcpu, gfn, no_dirty_log);
-	if (!slot) {
-		get_page(fault_page);
-		return page_to_pfn(fault_page);
-	}
+	if (!slot)
+		return get_fault_pfn();

 	hva = gfn_to_hva_memslot(slot, gfn);

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index e3c86f8..258b35a 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -383,15 +383,11 @@ id_to_memslot(struct kvm_memslots *slots, int id)
 static inline int is_error_hpa(hpa_t hpa) { return hpa >> HPA_MSB; }

 extern struct page *bad_page;
-extern struct page *fault_page;
-
 extern pfn_t bad_pfn;
-extern pfn_t fault_pfn;

 int is_error_page(struct page *page);
 int is_error_pfn(pfn_t pfn);
 int is_hwpoison_pfn(pfn_t pfn);
-int is_fault_pfn(pfn_t pfn);
 int is_noslot_pfn(pfn_t pfn);
 int is_invalid_pfn(pfn_t pfn);
 int kvm_is_error_hva(unsigned long addr);
@@ -441,6 +437,7 @@ void kvm_release_pfn_clean(pfn_t pfn);
 void kvm_set_pfn_dirty(pfn_t pfn);
 void kvm_set_pfn_accessed(pfn_t pfn);
 void kvm_get_pfn(pfn_t pfn);
+pfn_t get_fault_pfn(void);

 int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
 			int len);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 60af030..feef72e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -103,8 +103,8 @@ static bool largepages_enabled = true;
 static struct page *hwpoison_page;
 static pfn_t hwpoison_pfn;

-struct page *fault_page;
-pfn_t fault_pfn;
+static struct page *fault_page;
+static pfn_t fault_pfn;

 inline int kvm_is_mmio_pfn(pfn_t pfn)
 {
@@ -950,12 +950,6 @@ int is_hwpoison_pfn(pfn_t pfn)
 }
 EXPORT_SYMBOL_GPL(is_hwpoison_pfn);

-int is_fault_pfn(pfn_t pfn)
-{
-	return pfn == fault_pfn;
-}
-EXPORT_SYMBOL_GPL(is_fault_pfn);
-
 int is_noslot_pfn(pfn_t pfn)
 {
 	return pfn == bad_pfn;
@@ -1039,11 +1033,12 @@ unsigned long gfn_to_hva(struct kvm *kvm, gfn_t gfn)
 }
 EXPORT_SYMBOL_GPL(gfn_to_hva);

-static pfn_t get_fault_pfn(void)
+pfn_t get_fault_pfn(void)
 {
 	get_page(fault_page);
 	return fault_pfn;
 }
+EXPORT_SYMBOL_GPL(get_fault_pfn);

 int get_user_page_nowait(struct task_struct *tsk, struct mm_struct *mm,
 	unsigned long start, int write, struct page **page)
-- 
1.7.7.6

