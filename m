Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154Ab0FON4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 09:56:19 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:49217 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757726Ab0FONzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 09:55:42 -0400
Subject: [RFC][PATCH 7/9] make kvm_get_kvm() more robust
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Tue, 15 Jun 2010 06:55:27 -0700
References: <20100615135518.BC244431@kernel.beaverton.ibm.com>
In-Reply-To: <20100615135518.BC244431@kernel.beaverton.ibm.com>
Message-Id: <20100615135527.262CFEA2@kernel.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The comment tells most of the story here.  This patch guarantees
that once a user decrements kvm->users_count to 0 that no one
will increment it again.

We'll need this in a moment because we are going to use
kvm->users_count as a more generic refcount.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/include/linux/kvm_host.h |    2 -
 linux-2.6.git-dave/virt/kvm/kvm_main.c      |   32 +++++++++++++++++++++++++---
 2 files changed, 30 insertions(+), 4 deletions(-)

diff -puN include/linux/kvm_host.h~make-kvm_get_kvm-more-robust include/linux/kvm_host.h
--- linux-2.6.git/include/linux/kvm_host.h~make-kvm_get_kvm-more-robust	2010-06-11 08:39:16.000000000 -0700
+++ linux-2.6.git-dave/include/linux/kvm_host.h	2010-06-11 08:39:16.000000000 -0700
@@ -247,7 +247,7 @@ int kvm_init(void *opaque, unsigned vcpu
 		  struct module *module);
 void kvm_exit(void);
 
-void kvm_get_kvm(struct kvm *kvm);
+int kvm_get_kvm(struct kvm *kvm);
 void kvm_put_kvm(struct kvm *kvm);
 
 static inline struct kvm_memslots *kvm_memslots(struct kvm *kvm)
diff -puN virt/kvm/kvm_main.c~make-kvm_get_kvm-more-robust virt/kvm/kvm_main.c
--- linux-2.6.git/virt/kvm/kvm_main.c~make-kvm_get_kvm-more-robust	2010-06-11 08:39:16.000000000 -0700
+++ linux-2.6.git-dave/virt/kvm/kvm_main.c	2010-06-11 08:39:16.000000000 -0700
@@ -496,9 +496,30 @@ static void kvm_destroy_vm(struct kvm *k
 	mmdrop(mm);
 }
 
-void kvm_get_kvm(struct kvm *kvm)
+/*
+ * Once the counter goes to 0, we destroy the
+ * kvm object.  Do not allow additional refs
+ * to be obtained once this occurs.
+ *
+ * Any calls which are done via the kvm fd
+ * could use atomic_inc().  That is because
+ * ->users_count is set to 1 when the kvm fd
+ * is created, and stays at least 1 while
+ * the fd exists.
+ *
+ * But, those calls are currently rare, so do
+ * this (more expensive) atomic_add_unless()
+ * to keep the number of functions down.
+ *
+ * Returns 0 if the reference was obtained
+ * successfully.
+ */
+int kvm_get_kvm(struct kvm *kvm)
 {
-	atomic_inc(&kvm->users_count);
+	int did_add = atomic_add_unless(&kvm->users_count, 1, 0);
+	if (did_add)
+		return 0;
+	return -EBUSY;
 }
 EXPORT_SYMBOL_GPL(kvm_get_kvm);
 
@@ -1332,7 +1353,12 @@ static int kvm_vm_ioctl_create_vcpu(stru
 	BUG_ON(kvm->vcpus[atomic_read(&kvm->online_vcpus)]);
 
 	/* Now it's all set up, let userspace reach it */
-	kvm_get_kvm(kvm);
+	r = kvm_get_kvm(kvm);
+	/*
+	 * Getting called via the kvm fd _should_ guarantee
+	 * that we can always get a reference.
+	 */
+	WARN_ON(r);
 	r = create_vcpu_fd(vcpu);
 	if (r < 0) {
 		kvm_put_kvm(kvm);
diff -puN arch/x86/kvm/mmu.c~make-kvm_get_kvm-more-robust arch/x86/kvm/mmu.c
_
