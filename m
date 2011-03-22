Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932210Ab1CVUlV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 16:41:21 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:59784 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755030Ab1CVUlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 16:41:17 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: uclinux-dev@uclinux.org, David Howells <dhowells@redhat.com>,
        Greg Ungerer <gerg@uclinux.org>, Paul Mundt <lethal@linux-sh.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Subject: [PATCH] NOMMU: support SMP dynamic percpu_alloc
Date: Tue, 22 Mar 2011 16:41:46 -0400
Message-Id: <1300826506-23192-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graf Yang <graf.yang@analog.com>

The percpu code requires more functions to be implemented in the mm core
which nommu currently does not provide.  So add inline implementations
since these are largely meaningless on nommu systems.

Signed-off-by: Graf Yang <graf.yang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 include/linux/vmalloc.h |   32 ++++++++++++++++++++++++++++++++
 1 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index 81f8622..01bbeb4 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -98,10 +98,27 @@ extern struct vm_struct *remove_vm_area(const void *addr);
 
 extern int map_vm_area(struct vm_struct *area, pgprot_t prot,
 			struct page ***pages);
+#ifdef CONFIG_MMU
 extern int map_kernel_range_noflush(unsigned long start, unsigned long size,
 				    pgprot_t prot, struct page **pages);
 extern void unmap_kernel_range_noflush(unsigned long addr, unsigned long size);
 extern void unmap_kernel_range(unsigned long addr, unsigned long size);
+#else
+static inline int
+map_kernel_range_noflush(unsigned long start, unsigned long size,
+			pgprot_t prot, struct page **pages)
+{
+	return size >> PAGE_SHIFT;
+}
+static inline void
+unmap_kernel_range_noflush(unsigned long addr, unsigned long size)
+{
+}
+static inline void
+unmap_kernel_range(unsigned long addr, unsigned long size)
+{
+}
+#endif
 
 /* Allocate/destroy a 'vmalloc' VM area. */
 extern struct vm_struct *alloc_vm_area(size_t size);
@@ -119,11 +136,26 @@ extern struct vm_struct *vmlist;
 extern __init void vm_area_register_early(struct vm_struct *vm, size_t align);
 
 #ifdef CONFIG_SMP
+# ifdef CONFIG_MMU
 struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
 				     const size_t *sizes, int nr_vms,
 				     size_t align);
 
 void pcpu_free_vm_areas(struct vm_struct **vms, int nr_vms);
+# else
+static inline struct vm_struct **
+pcpu_get_vm_areas(const unsigned long *offsets,
+		const size_t *sizes, int nr_vms,
+		size_t align)
+{
+	return NULL;
+}
+
+static inline void
+pcpu_free_vm_areas(struct vm_struct **vms, int nr_vms)
+{
+}
+# endif
 #endif
 
 #endif /* _LINUX_VMALLOC_H */
-- 
1.7.4.1

