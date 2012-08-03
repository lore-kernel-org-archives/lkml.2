Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658Ab2HCHkW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 03:40:22 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:43079 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505Ab2HCHkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 03:40:20 -0400
Message-ID: <501B804F.4040205@linux.vnet.ibm.com>
Date: Fri, 03 Aug 2012 15:39:59 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 05/10] KVM: inline is_*_pfn functions
References: <501B7F94.7090308@linux.vnet.ibm.com>
In-Reply-To: <501B7F94.7090308@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12080307-3864-0000-0000-0000040703CE
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
index ba8b222..f604d1d 100644
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
 #define KVM_PFN_ERR_HWPOISON	(-EHWPOISON)
 #define KVM_PFN_ERR_BAD		(-ENOENT)

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
index 75d3c76..08b600b 100644
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

