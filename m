Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852Ab2HGJui (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 05:50:38 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:43233 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab2HGJuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 05:50:35 -0400
Message-ID: <5020E4E2.2090406@linux.vnet.ibm.com>
Date: Tue, 07 Aug 2012 17:50:26 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v5 04/12] KVM: introduce gfn_to_hva_read/kvm_read_hva/kvm_read_hva_atomic
References: <5020E423.9080004@linux.vnet.ibm.com>
In-Reply-To: <5020E423.9080004@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12080709-8256-0000-0000-0000039D3EA4
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
index 543f9b7..26ffc87 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1002,6 +1002,27 @@ unsigned long gfn_to_hva(struct kvm *kvm, gfn_t gfn)
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
 int get_user_page_nowait(struct task_struct *tsk, struct mm_struct *mm,
 	unsigned long start, int write, struct page **page)
 {
@@ -1274,10 +1295,10 @@ int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
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
@@ -1312,11 +1333,11 @@ int kvm_read_guest_atomic(struct kvm *kvm, gpa_t gpa, void *data,
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

