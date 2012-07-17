Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545Ab2GQOmm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 10:42:42 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:55710 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963Ab2GQOmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 10:42:40 -0400
Message-ID: <500579D9.4040808@linux.vnet.ibm.com>
Date: Tue, 17 Jul 2012 22:42:33 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 04/10] KVM: introduce gfn_to_hva_read/kvm_read_hva/kvm_read_hva_atomic
References: <5005791B.8040807@linux.vnet.ibm.com>
In-Reply-To: <5005791B.8040807@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12071714-4790-0000-0000-000003BABB79
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of functions is only used to read data from host space, in the
later patch, we will only get a readonly hva in gfn_to_hva_read, and
the function name is a good hint to let gfn_to_hva_read to pair with
kvm_read_hva()/kvm_read_hva_atomic()

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 virt/kvm/kvm_main.c |   29 +++++++++++++++++++++++++----
 1 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6c1e746..a89c7b8 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1048,6 +1048,27 @@ unsigned long gfn_to_hva(struct kvm *kvm, gfn_t gfn)
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
+static int kvm_read_hva(void *data, void __user *hva, int len)
+{
+	return __copy_from_user(data, hva, len);
+
+}
+
+static int kvm_read_hva_atomic(void *data, void __user *hva, int len)
+{
+	return __copy_from_user_inatomic(data, hva, len);
+
+}
+
 pfn_t get_fault_pfn(void)
 {
 	get_page(fault_page);
@@ -1316,10 +1337,10 @@ int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
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
@@ -1354,11 +1375,11 @@ int kvm_read_guest_atomic(struct kvm *kvm, gpa_t gpa, void *data,
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

