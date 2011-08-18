Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797Ab1HRTKw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:10:52 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47581 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865Ab1HRTKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:10:50 -0400
Date: Thu, 18 Aug 2011 20:10:49 +0100
To: richard@nod.at
Subject: Subject: [PATCH 71/91] um: take ldt.h to
 arch/x86/um/asm/mm_context.h
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7zN-0007zt-TA@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


it's x86-only and we have no business playing with it in asm/mmu.h; make
the latter have
	struct uml_arch_mm_context arch;
instead of
	struct uml_ldt ldt;
and let arch/<subarch>/um/asm/mm_context.h decide what'll be in there.
While we are at it, kill host_ldt.h - it's not needed in part of places
that include it (we want asm/ldt.h in those) and it can be trivially
expanded into the single remaining one.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/include/asm/mmu.h            |    4 +-
 arch/um/include/shared/ldt.h         |   37 -----------------
 arch/x86/um/asm/mm_context.h         |   72 ++++++++++++++++++++++++++++++++++
 arch/x86/um/asm/processor_32.h       |    2 +-
 arch/x86/um/ldt.c                    |   36 ++++++++--------
 arch/x86/um/shared/sysdep/host_ldt.h |   37 -----------------
 arch/x86/um/shared/sysdep/tls.h      |    1 -
 7 files changed, 93 insertions(+), 96 deletions(-)
 delete mode 100644 arch/um/include/shared/ldt.h
 create mode 100644 arch/x86/um/asm/mm_context.h
 delete mode 100644 arch/x86/um/shared/sysdep/host_ldt.h

diff --git a/arch/um/include/asm/mmu.h b/arch/um/include/asm/mmu.h
index b1a7e47..30509b9 100644
--- a/arch/um/include/asm/mmu.h
+++ b/arch/um/include/asm/mmu.h
@@ -7,11 +7,11 @@
 #define __ARCH_UM_MMU_H
 
 #include "mm_id.h"
-#include "ldt.h"
+#include <asm/mm_context.h>
 
 typedef struct mm_context {
 	struct mm_id id;
-	struct uml_ldt ldt;
+	struct uml_arch_mm_context arch;
 	struct page **stub_pages;
 } mm_context_t;
 
diff --git a/arch/um/include/shared/ldt.h b/arch/um/include/shared/ldt.h
deleted file mode 100644
index a7f999a..0000000
--- a/arch/um/include/shared/ldt.h
+++ /dev/null
@@ -1,37 +0,0 @@
-/*
- * Copyright (C) 2004 Fujitsu Siemens Computers GmbH
- * Licensed under the GPL
- *
- * Author: Bodo Stroesser <bstroesser@fujitsu-siemens.com>
- */
-
-#ifndef __ASM_LDT_H
-#define __ASM_LDT_H
-
-#include <linux/mutex.h>
-#include <sysdep/host_ldt.h>
-
-extern void ldt_host_info(void);
-
-#define LDT_PAGES_MAX \
-	((LDT_ENTRIES * LDT_ENTRY_SIZE)/PAGE_SIZE)
-#define LDT_ENTRIES_PER_PAGE \
-	(PAGE_SIZE/LDT_ENTRY_SIZE)
-#define LDT_DIRECT_ENTRIES \
-	((LDT_PAGES_MAX*sizeof(void *))/LDT_ENTRY_SIZE)
-
-struct ldt_entry {
-	__u32 a;
-	__u32 b;
-};
-
-typedef struct uml_ldt {
-	int entry_count;
-	struct mutex lock;
-	union {
-		struct ldt_entry * pages[LDT_PAGES_MAX];
-		struct ldt_entry entries[LDT_DIRECT_ENTRIES];
-	} u;
-} uml_ldt_t;
-
-#endif
diff --git a/arch/x86/um/asm/mm_context.h b/arch/x86/um/asm/mm_context.h
new file mode 100644
index 0000000..4a73d63
--- /dev/null
+++ b/arch/x86/um/asm/mm_context.h
@@ -0,0 +1,72 @@
+/*
+ * Copyright (C) 2004 Fujitsu Siemens Computers GmbH
+ * Licensed under the GPL
+ *
+ * Author: Bodo Stroesser <bstroesser@fujitsu-siemens.com>
+ */
+
+#ifndef __ASM_LDT_H
+#define __ASM_LDT_H
+
+#include <linux/mutex.h>
+#include <asm/ldt.h>
+
+extern void ldt_host_info(void);
+
+#define LDT_PAGES_MAX \
+	((LDT_ENTRIES * LDT_ENTRY_SIZE)/PAGE_SIZE)
+#define LDT_ENTRIES_PER_PAGE \
+	(PAGE_SIZE/LDT_ENTRY_SIZE)
+#define LDT_DIRECT_ENTRIES \
+	((LDT_PAGES_MAX*sizeof(void *))/LDT_ENTRY_SIZE)
+
+struct ldt_entry {
+	__u32 a;
+	__u32 b;
+};
+
+typedef struct uml_ldt {
+	int entry_count;
+	struct mutex lock;
+	union {
+		struct ldt_entry * pages[LDT_PAGES_MAX];
+		struct ldt_entry entries[LDT_DIRECT_ENTRIES];
+	} u;
+} uml_ldt_t;
+
+#define LDT_entry_a(info) \
+	((((info)->base_addr & 0x0000ffff) << 16) | ((info)->limit & 0x0ffff))
+
+#define LDT_entry_b(info) \
+	(((info)->base_addr & 0xff000000) | \
+	(((info)->base_addr & 0x00ff0000) >> 16) | \
+	((info)->limit & 0xf0000) | \
+	(((info)->read_exec_only ^ 1) << 9) | \
+	((info)->contents << 10) | \
+	(((info)->seg_not_present ^ 1) << 15) | \
+	((info)->seg_32bit << 22) | \
+	((info)->limit_in_pages << 23) | \
+	((info)->useable << 20) | \
+	0x7000)
+
+#define _LDT_empty(info) (\
+	(info)->base_addr	== 0	&& \
+	(info)->limit		== 0	&& \
+	(info)->contents	== 0	&& \
+	(info)->read_exec_only	== 1	&& \
+	(info)->seg_32bit	== 0	&& \
+	(info)->limit_in_pages	== 0	&& \
+	(info)->seg_not_present	== 1	&& \
+	(info)->useable		== 0	)
+
+#ifdef CONFIG_X86_64
+#define LDT_empty(info) (_LDT_empty(info) && ((info)->lm == 0))
+#else
+#define LDT_empty(info) (_LDT_empty(info))
+#endif
+
+struct uml_arch_mm_context {
+	uml_ldt_t ldt;
+};
+
+#endif
diff --git a/arch/x86/um/asm/processor_32.h b/arch/x86/um/asm/processor_32.h
index e5b72fa..c4078b5 100644
--- a/arch/x86/um/asm/processor_32.h
+++ b/arch/x86/um/asm/processor_32.h
@@ -7,8 +7,8 @@
 #define __UM_PROCESSOR_I386_H
 
 #include <linux/string.h>
-#include <sysdep/host_ldt.h>
 #include <asm/segment.h>
+#include <asm/ldt.h>
 
 extern int host_has_cmov;
 
diff --git a/arch/x86/um/ldt.c b/arch/x86/um/ldt.c
index 3f2bf20..26b0e39 100644
--- a/arch/x86/um/ldt.c
+++ b/arch/x86/um/ldt.c
@@ -137,7 +137,7 @@ static int read_ldt(void __user * ptr, unsigned long bytecount)
 {
 	int i, err = 0;
 	unsigned long size;
-	uml_ldt_t * ldt = &current->mm->context.ldt;
+	uml_ldt_t *ldt = &current->mm->context.arch.ldt;
 
 	if (!ldt->entry_count)
 		goto out;
@@ -205,7 +205,7 @@ static int read_default_ldt(void __user * ptr, unsigned long bytecount)
 
 static int write_ldt(void __user * ptr, unsigned long bytecount, int func)
 {
-	uml_ldt_t * ldt = &current->mm->context.ldt;
+	uml_ldt_t *ldt = &current->mm->context.arch.ldt;
 	struct mm_id * mm_idp = &current->mm->context.id;
 	int i, err;
 	struct user_desc ldt_info;
@@ -397,7 +397,7 @@ long init_new_ldt(struct mm_context *new_mm, struct mm_context *from_mm)
 
 
 	if (!ptrace_ldt)
-		mutex_init(&new_mm->ldt.lock);
+		mutex_init(&new_mm->arch.ldt.lock);
 
 	if (!from_mm) {
 		memset(&desc, 0, sizeof(desc));
@@ -429,7 +429,7 @@ long init_new_ldt(struct mm_context *new_mm, struct mm_context *from_mm)
 					break;
 			}
 		}
-		new_mm->ldt.entry_count = 0;
+		new_mm->arch.ldt.entry_count = 0;
 
 		goto out;
 	}
@@ -457,26 +457,26 @@ long init_new_ldt(struct mm_context *new_mm, struct mm_context *from_mm)
 		 * i.e., we have to use the stub for modify_ldt, which
 		 * can't handle the big read buffer of up to 64kB.
 		 */
-		mutex_lock(&from_mm->ldt.lock);
-		if (from_mm->ldt.entry_count <= LDT_DIRECT_ENTRIES)
-			memcpy(new_mm->ldt.u.entries, from_mm->ldt.u.entries,
-			       sizeof(new_mm->ldt.u.entries));
+		mutex_lock(&from_mm->arch.ldt.lock);
+		if (from_mm->arch.ldt.entry_count <= LDT_DIRECT_ENTRIES)
+			memcpy(new_mm->arch.ldt.u.entries, from_mm->arch.ldt.u.entries,
+			       sizeof(new_mm->arch.ldt.u.entries));
 		else {
-			i = from_mm->ldt.entry_count / LDT_ENTRIES_PER_PAGE;
+			i = from_mm->arch.ldt.entry_count / LDT_ENTRIES_PER_PAGE;
 			while (i-->0) {
 				page = __get_free_page(GFP_KERNEL|__GFP_ZERO);
 				if (!page) {
 					err = -ENOMEM;
 					break;
 				}
-				new_mm->ldt.u.pages[i] =
+				new_mm->arch.ldt.u.pages[i] =
 					(struct ldt_entry *) page;
-				memcpy(new_mm->ldt.u.pages[i],
-				       from_mm->ldt.u.pages[i], PAGE_SIZE);
+				memcpy(new_mm->arch.ldt.u.pages[i],
+				       from_mm->arch.ldt.u.pages[i], PAGE_SIZE);
 			}
 		}
-		new_mm->ldt.entry_count = from_mm->ldt.entry_count;
-		mutex_unlock(&from_mm->ldt.lock);
+		new_mm->arch.ldt.entry_count = from_mm->arch.ldt.entry_count;
+		mutex_unlock(&from_mm->arch.ldt.lock);
 	}
 
     out:
@@ -488,12 +488,12 @@ void free_ldt(struct mm_context *mm)
 {
 	int i;
 
-	if (!ptrace_ldt && mm->ldt.entry_count > LDT_DIRECT_ENTRIES) {
-		i = mm->ldt.entry_count / LDT_ENTRIES_PER_PAGE;
+	if (!ptrace_ldt && mm->arch.ldt.entry_count > LDT_DIRECT_ENTRIES) {
+		i = mm->arch.ldt.entry_count / LDT_ENTRIES_PER_PAGE;
 		while (i-- > 0)
-			free_page((long) mm->ldt.u.pages[i]);
+			free_page((long) mm->arch.ldt.u.pages[i]);
 	}
-	mm->ldt.entry_count = 0;
+	mm->arch.ldt.entry_count = 0;
 }
 
 int sys_modify_ldt(int func, void __user *ptr, unsigned long bytecount)
diff --git a/arch/x86/um/shared/sysdep/host_ldt.h b/arch/x86/um/shared/sysdep/host_ldt.h
deleted file mode 100644
index 246ff7a..0000000
--- a/arch/x86/um/shared/sysdep/host_ldt.h
+++ /dev/null
@@ -1,37 +0,0 @@
-#ifndef __ASM_HOST_LDT_H
-#define __ASM_HOST_LDT_H
-
-#include <asm/ldt.h>
-
-#define LDT_entry_a(info) \
-	((((info)->base_addr & 0x0000ffff) << 16) | ((info)->limit & 0x0ffff))
-
-#define LDT_entry_b(info) \
-	(((info)->base_addr & 0xff000000) | \
-	(((info)->base_addr & 0x00ff0000) >> 16) | \
-	((info)->limit & 0xf0000) | \
-	(((info)->read_exec_only ^ 1) << 9) | \
-	((info)->contents << 10) | \
-	(((info)->seg_not_present ^ 1) << 15) | \
-	((info)->seg_32bit << 22) | \
-	((info)->limit_in_pages << 23) | \
-	((info)->useable << 20) | \
-	0x7000)
-
-#define _LDT_empty(info) (\
-	(info)->base_addr	== 0	&& \
-	(info)->limit		== 0	&& \
-	(info)->contents	== 0	&& \
-	(info)->read_exec_only	== 1	&& \
-	(info)->seg_32bit	== 0	&& \
-	(info)->limit_in_pages	== 0	&& \
-	(info)->seg_not_present	== 1	&& \
-	(info)->useable		== 0	)
-
-#ifdef CONFIG_X86_64
-#define LDT_empty(info) (_LDT_empty(info) && ((info)->lm == 0))
-#else
-#define LDT_empty(info) (_LDT_empty(info))
-#endif
-
-#endif
diff --git a/arch/x86/um/shared/sysdep/tls.h b/arch/x86/um/shared/sysdep/tls.h
index f2f30bd..27cce00 100644
--- a/arch/x86/um/shared/sysdep/tls.h
+++ b/arch/x86/um/shared/sysdep/tls.h
@@ -24,7 +24,6 @@ typedef struct um_dup_user_desc {
 
 # else /* __KERNEL__ */
 
-#  include <ldt.h>
 typedef struct user_desc user_desc_t;
 
 # endif /* __KERNEL__ */
-- 
1.7.2.5


