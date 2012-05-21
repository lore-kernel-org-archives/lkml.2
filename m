Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227Ab2EUGxM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 02:53:12 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:46179 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab2EUGxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 02:53:10 -0400
Message-ID: <4FB9E499.2010505@linux.vnet.ibm.com>
Date: Mon, 21 May 2012 14:45:45 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH] KVM: fix async page fault working for readonly mapping
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12052020-9264-0000-0000-000001874B71
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we map a readonly memory space from host to guest and the page is
not currently mapped in the host, we will get a fault-pfn and async
is not allowed, then the vm will crash

The reason is only writable vma can be allowed to be async in current
code

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 virt/kvm/kvm_main.c |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6bd34a6..b6c8962 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1052,6 +1052,21 @@ static inline int check_user_page_hwpoison(unsigned long addr)
 	return rc == -EHWPOISON;
 }

+static bool vma_is_avalid(struct vm_area_struct *vma, bool write_fault)
+{
+	if (write_fault) {
+		if (unlikely(!(vma->vm_flags & VM_WRITE)))
+			return false;
+
+		return true;
+	}
+
+	if (unlikely(!(vma->vm_flags & (VM_READ | VM_EXEC | VM_WRITE))))
+		return false;
+
+	return true;
+}
+
 static pfn_t hva_to_pfn(struct kvm *kvm, unsigned long addr, bool atomic,
 			bool *async, bool write_fault, bool *writable)
 {
@@ -1075,7 +1090,6 @@ static pfn_t hva_to_pfn(struct kvm *kvm, unsigned long addr, bool atomic,

 		if (writable)
 			*writable = write_fault;
-
 		if (async) {
 			down_read(&current->mm->mmap_sem);
 			npages = get_user_page_nowait(current, current->mm,
@@ -1122,8 +1136,9 @@ static pfn_t hva_to_pfn(struct kvm *kvm, unsigned long addr, bool atomic,
 				vma->vm_pgoff;
 			BUG_ON(!kvm_is_mmio_pfn(pfn));
 		} else {
-			if (async && (vma->vm_flags & VM_WRITE))
+			if (async && vma_is_avalid(vma, write_fault))
 				*async = true;
+
 			pfn = get_fault_pfn();
 		}
 		up_read(&current->mm->mmap_sem);
-- 
1.7.7.6

