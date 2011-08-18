Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582Ab1HRTJM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:09:12 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47531 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349Ab1HRTJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:09:10 -0400
Date: Thu, 18 Aug 2011 20:09:09 +0100
To: richard@nod.at
Subject: Subject: [PATCH 61/91] um: take um_mmu.h to asm/mmu.h, clean
 asm/mmu_context.h a bit
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7xl-0007sr-Q3@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/include/asm/mmu.h         |   22 +++++++++++++++++-----
 arch/um/include/asm/mmu_context.h |    7 ++-----
 arch/um/include/shared/um_mmu.h   |   24 ------------------------
 3 files changed, 19 insertions(+), 34 deletions(-)
 delete mode 100644 arch/um/include/shared/um_mmu.h

diff --git a/arch/um/include/asm/mmu.h b/arch/um/include/asm/mmu.h
index cf259de..b1a7e47 100644
--- a/arch/um/include/asm/mmu.h
+++ b/arch/um/include/asm/mmu.h
@@ -1,12 +1,24 @@
 /* 
- * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2002 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
-#ifndef __MMU_H
-#define __MMU_H
+#ifndef __ARCH_UM_MMU_H
+#define __ARCH_UM_MMU_H
 
-#include "um_mmu.h"
+#include "mm_id.h"
+#include "ldt.h"
 
-#endif
+typedef struct mm_context {
+	struct mm_id id;
+	struct uml_ldt ldt;
+	struct page **stub_pages;
+} mm_context_t;
+
+extern void __switch_mm(struct mm_id * mm_idp);
 
+/* Avoid tangled inclusion with asm/ldt.h */
+extern long init_new_ldt(struct mm_context *to_mm, struct mm_context *from_mm);
+extern void free_ldt(struct mm_context *mm);
+
+#endif
diff --git a/arch/um/include/asm/mmu_context.h b/arch/um/include/asm/mmu_context.h
index 34d8130..591b3d8 100644
--- a/arch/um/include/asm/mmu_context.h
+++ b/arch/um/include/asm/mmu_context.h
@@ -6,15 +6,12 @@
 #ifndef __UM_MMU_CONTEXT_H
 #define __UM_MMU_CONTEXT_H
 
-#include "linux/sched.h"
-#include "um_mmu.h"
+#include <linux/sched.h>
+#include <asm/mmu.h>
 
 extern void arch_dup_mmap(struct mm_struct *oldmm, struct mm_struct *mm);
 extern void arch_exit_mmap(struct mm_struct *mm);
 
-#define get_mmu_context(task) do ; while(0)
-#define activate_context(tsk) do ; while(0)
-
 #define deactivate_mm(tsk,mm)	do { } while (0)
 
 extern void force_flush_all(void);
diff --git a/arch/um/include/shared/um_mmu.h b/arch/um/include/shared/um_mmu.h
deleted file mode 100644
index b1a7e47..0000000
--- a/arch/um/include/shared/um_mmu.h
+++ /dev/null
@@ -1,24 +0,0 @@
-/* 
- * Copyright (C) 2002 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
- * Licensed under the GPL
- */
-
-#ifndef __ARCH_UM_MMU_H
-#define __ARCH_UM_MMU_H
-
-#include "mm_id.h"
-#include "ldt.h"
-
-typedef struct mm_context {
-	struct mm_id id;
-	struct uml_ldt ldt;
-	struct page **stub_pages;
-} mm_context_t;
-
-extern void __switch_mm(struct mm_id * mm_idp);
-
-/* Avoid tangled inclusion with asm/ldt.h */
-extern long init_new_ldt(struct mm_context *to_mm, struct mm_context *from_mm);
-extern void free_ldt(struct mm_context *mm);
-
-#endif
-- 
1.7.2.5


