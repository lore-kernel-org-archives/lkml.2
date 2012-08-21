Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918Ab2HUDAH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 23:00:07 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:57310 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755401Ab2HUDAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 23:00:02 -0400
Message-ID: <5032F9A9.50700@linux.vnet.ibm.com>
Date: Tue, 21 Aug 2012 10:59:53 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v6 05/12] KVM: introduce gfn_to_hva_read/kvm_read_hva/kvm_read_hva_atomic
References: <5032F8FD.2020306@linux.vnet.ibm.com>
In-Reply-To: <5032F8FD.2020306@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12082102-3864-0000-0000-00000442912A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of functions is only used to read data from host space, in the
later patch, we will only get a readonly hva in gfn_to_hva_read, and
the function name is a good hint to let gfn_to_hva_read to pair with
kvm_read_hva()/kvm_read_hva_atomic()

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 virt/kvm/kvm_main.c |   27 +++++++++++++++++++++++----
 1 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 543f9b7..6e3ea15 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1002,6 +1002,25 @@ unsigned long gfn_to_hva(struct kvm *kvm, gfn_t gfn)
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
+}
+
+static int kvm_read_hva_atomic(void *data, void __user *hva, int len)
+{
+	return __copy_from_user_inatomic(data, hva, len);
+}
+
 int get_user_page_nowait(struct task_struct *tsk, struct mm_struct *mm,
 	unsigned long start, int write, struct page **page)
 {
@@ -1274,10 +1293,10 @@ int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
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
@@ -1312,11 +1331,11 @@ int kvm_read_guest_atomic(struct kvm *kvm, gpa_t gpa, void *data,
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

