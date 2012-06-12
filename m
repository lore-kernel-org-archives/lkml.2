Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420Ab2FLCtM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 22:49:12 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:32858 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab2FLCtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 22:49:09 -0400
Message-ID: <4FD6AE1B.7080501@linux.vnet.ibm.com>
Date: Tue, 12 Jun 2012 10:48:59 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v3 5/6] KVM: introduce gfn_to_hva_read/kvm_read_hva/kvm_read_hva_atomic
References: <4FD6ADA6.40008@linux.vnet.ibm.com>
In-Reply-To: <4FD6ADA6.40008@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12061116-0260-0000-0000-00000153E102
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of functions is only used to read data from host space, read is
a special case in the later patch

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 virt/kvm/kvm_main.c |   29 +++++++++++++++++++++++++----
 1 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 811c3ee..4b96bc2 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1051,6 +1051,27 @@ unsigned long gfn_to_hva(struct kvm *kvm, gfn_t gfn)
 }
 EXPORT_SYMBOL_GPL(gfn_to_hva);

+/*
+ * The hva returned by this function is only allowed to be read.
+ * It should pair with kvm_read_hva() or kvm_read_hva_atomic().
+ */
+static unsigned long gfn_to_hva_read(struct kvm *kvm, gfn_t gfn)
+{
+	return gfn_to_hva_many(gfn_to_memslot(kvm, gfn), gfn, NULL);
+}
+
+static int kvm_read_hva(void *data, void *hva, int len)
+{
+	return __copy_from_user(data, (void __user *)hva, len);
+
+}
+
+static int kvm_read_hva_atomic(void *data, void *hva, int len)
+{
+	return __copy_from_user_inatomic(data, (void __user *)hva, len);
+
+}
+
 static pfn_t get_fault_pfn(void)
 {
 	get_page(fault_page);
@@ -1325,10 +1346,10 @@ int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
 	int r;
 	unsigned long addr;

-	addr = gfn_to_hva(kvm, gfn);
+	addr = gfn_to_hva_read(kvm, gfn);
 	if (kvm_is_error_hva(addr))
 		return -EFAULT;
-	r = __copy_from_user(data, (void __user *)addr + offset, len);
+	r = kvm_read_hva(data, (void __user *)addr + offset, len);
 	if (r)
 		return -EFAULT;
 	return 0;
@@ -1363,11 +1384,11 @@ int kvm_read_guest_atomic(struct kvm *kvm, gpa_t gpa, void *data,
 	gfn_t gfn = gpa >> PAGE_SHIFT;
 	int offset = offset_in_page(gpa);

-	addr = gfn_to_hva(kvm, gfn);
+	addr = gfn_to_hva_read(kvm, gfn);
 	if (kvm_is_error_hva(addr))
 		return -EFAULT;
 	pagefault_disable();
-	r = __copy_from_user_inatomic(data, (void __user *)addr + offset, len);
+	r = kvm_read_hva_atomic(data, (void __user *)addr + offset, len);
 	pagefault_enable();
 	if (r)
 		return -EFAULT;
-- 
1.7.7.6

