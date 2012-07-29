Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985Ab2G2INv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 04:13:51 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:52599 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab2G2INs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 04:13:48 -0400
Message-ID: <5014F0B5.50602@linux.vnet.ibm.com>
Date: Sun, 29 Jul 2012 16:13:41 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 3/9] KVM: define kvm_hwpoison_pfn statically
References: <5014F053.8020305@linux.vnet.ibm.com>
In-Reply-To: <5014F053.8020305@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12072908-0260-0000-0000-000001973727
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Then, get_hwpoison_pfn and is_hwpoison_pfn can be removed

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c       |    2 +-
 include/linux/kvm_host.h |    4 ++--
 virt/kvm/kvm_main.c      |   13 +------------
 3 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 19bac91..320a781 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2651,7 +2651,7 @@ static void kvm_send_hwpoison_signal(unsigned long address, struct task_struct *
 static int kvm_handle_bad_page(struct kvm_vcpu *vcpu, gfn_t gfn, pfn_t pfn)
 {
 	kvm_release_pfn_clean(pfn);
-	if (is_hwpoison_pfn(pfn)) {
+	if (pfn == kvm_hwpoison_pfn) {
 		kvm_send_hwpoison_signal(gfn_to_hva(vcpu->kvm, gfn), current);
 		return 0;
 	}
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7cd6871..4de56cd 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -48,7 +48,8 @@
 #define KVM_MAX_MMIO_FRAGMENTS \
 	(KVM_MMIO_SIZE / KVM_USER_MMIO_SIZE + KVM_EXTRA_MMIO_FRAGMENTS)

-#define kvm_fault_pfn	(-EFAULT)
+#define kvm_fault_pfn		(-EFAULT)
+#define kvm_hwpoison_pfn	(-EHWPOISON)

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
index 2117aa8..390a03d 100644
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
+			return kvm_hwpoison_pfn;
 		}

 		vma = find_vma_intersection(current->mm, addr, addr+1);
-- 
1.7.7.6

