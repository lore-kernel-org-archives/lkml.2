Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059Ab2G2IPY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 04:15:24 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:33220 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089Ab2G2IPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 04:15:22 -0400
Message-ID: <5014F10B.6020901@linux.vnet.ibm.com>
Date: Sun, 29 Jul 2012 16:15:07 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 5/9] KVM: inline is_*_pfn functions
References: <5014F053.8020305@linux.vnet.ibm.com>
In-Reply-To: <5014F053.8020305@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12072908-6102-0000-0000-000001F6A8ED
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These functions are exported and can not inline, move them
to kvm_host.h to eliminate the overload of function call

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 include/linux/kvm_host.h |   19 ++++++++++++++++---
 virt/kvm/kvm_main.c      |   18 ------------------
 2 files changed, 16 insertions(+), 21 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index b02203f..98255ce 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -21,6 +21,7 @@
 #include <linux/slab.h>
 #include <linux/rcupdate.h>
 #include <linux/ratelimit.h>
+#include <linux/err.h>
 #include <asm/signal.h>

 #include <linux/kvm.h>
@@ -52,6 +53,21 @@
 #define kvm_hwpoison_pfn	(-EHWPOISON)
 #define kvm_bad_pfn		(-ENOENT)

+static inline int is_error_pfn(pfn_t pfn)
+{
+	return IS_ERR_VALUE(pfn);
+}
+
+static inline int is_noslot_pfn(pfn_t pfn)
+{
+	return pfn == -ENOENT;
+}
+
+static inline int is_invalid_pfn(pfn_t pfn)
+{
+	return !is_noslot_pfn(pfn) && is_error_pfn(pfn);
+}
+
 /*
  * vcpu->requests bit members
  */
@@ -397,9 +413,6 @@ id_to_memslot(struct kvm_memslots *slots, int id)
 extern struct page *bad_page;

 int is_error_page(struct page *page);
-int is_error_pfn(pfn_t pfn);
-int is_noslot_pfn(pfn_t pfn);
-int is_invalid_pfn(pfn_t pfn);
 int kvm_is_error_hva(unsigned long addr);
 int kvm_set_memory_region(struct kvm *kvm,
 			  struct kvm_userspace_memory_region *mem,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index da16191..51aaba4 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -937,24 +937,6 @@ int is_error_page(struct page *page)
 }
 EXPORT_SYMBOL_GPL(is_error_page);

-int is_error_pfn(pfn_t pfn)
-{
-	return IS_ERR_VALUE(pfn);
-}
-EXPORT_SYMBOL_GPL(is_error_pfn);
-
-int is_noslot_pfn(pfn_t pfn)
-{
-	return pfn == -ENOENT;
-}
-EXPORT_SYMBOL_GPL(is_noslot_pfn);
-
-int is_invalid_pfn(pfn_t pfn)
-{
-	return !is_noslot_pfn(pfn) && is_error_pfn(pfn);
-}
-EXPORT_SYMBOL_GPL(is_invalid_pfn);
-
 struct page *get_bad_page(void)
 {
 	return ERR_PTR(-ENOENT);
-- 
1.7.7.6

