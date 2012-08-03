Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430Ab2HCHi6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 03:38:58 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:39004 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab2HCHiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 03:38:55 -0400
Message-ID: <501B7FFC.7080806@linux.vnet.ibm.com>
Date: Fri, 03 Aug 2012 15:38:36 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 03/10] KVM: introduce KVM_PFN_ERR_HWPOISON
References: <501B7F94.7090308@linux.vnet.ibm.com>
In-Reply-To: <501B7F94.7090308@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12080307-8878-0000-0000-0000037B8A00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Then, get_hwpoison_pfn and is_hwpoison_pfn can be removed

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c       |    2 +-
 include/linux/kvm_host.h |    2 +-
 virt/kvm/kvm_main.c      |   13 +------------
 3 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 39ed315..924b4e8 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2651,7 +2651,7 @@ static void kvm_send_hwpoison_signal(unsigned long address, struct task_struct *
 static int kvm_handle_bad_page(struct kvm_vcpu *vcpu, gfn_t gfn, pfn_t pfn)
 {
 	kvm_release_pfn_clean(pfn);
-	if (is_hwpoison_pfn(pfn)) {
+	if (pfn == KVM_PFN_ERR_HWPOISON) {
 		kvm_send_hwpoison_signal(gfn_to_hva(vcpu->kvm, gfn), current);
 		return 0;
 	}
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 4c39543..cbd5af8 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -49,6 +49,7 @@
 	(KVM_MMIO_SIZE / KVM_USER_MMIO_SIZE + KVM_EXTRA_MMIO_FRAGMENTS)

 #define KVM_PFN_ERR_FAULT	(-EFAULT)
+#define KVM_PFN_ERR_HWPOISON	(-EHWPOISON)

 /*
  * vcpu->requests bit members
@@ -396,7 +397,6 @@ extern struct page *bad_page;

 int is_error_page(struct page *page);
 int is_error_pfn(pfn_t pfn);
-int is_hwpoison_pfn(pfn_t pfn);
 int is_noslot_pfn(pfn_t pfn);
 int is_invalid_pfn(pfn_t pfn);
 int kvm_is_error_hva(unsigned long addr);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9c084f8..f17ce44 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -948,17 +948,6 @@ static pfn_t get_bad_pfn(void)
 	return -ENOENT;
 }

-static pfn_t get_hwpoison_pfn(void)
-{
-	return -EHWPOISON;
-}
-
-int is_hwpoison_pfn(pfn_t pfn)
-{
-	return pfn == -EHWPOISON;
-}
-EXPORT_SYMBOL_GPL(is_hwpoison_pfn);
-
 int is_noslot_pfn(pfn_t pfn)
 {
 	return pfn == -ENOENT;
@@ -1124,7 +1113,7 @@ static pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
 		if (npages == -EHWPOISON ||
 			(!async && check_user_page_hwpoison(addr))) {
 			up_read(&current->mm->mmap_sem);
-			return get_hwpoison_pfn();
+			return KVM_PFN_ERR_HWPOISON;
 		}

 		vma = find_vma_intersection(current->mm, addr, addr+1);
-- 
1.7.7.6

