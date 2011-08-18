Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494Ab1HRTIw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:08:52 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47524 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab1HRTIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:08:50 -0400
Date: Thu, 18 Aug 2011 20:08:49 +0100
To: richard@nod.at
Subject: Subject: [PATCH 59/91] um: kill um_uaccess.h
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7xR-0007sP-Pb@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/include/asm/uaccess.h       |   89 +++++++++++++++++++++++++++++++--
 arch/um/include/shared/um_uaccess.h |   94 -----------------------------------
 2 files changed, 84 insertions(+), 99 deletions(-)
 delete mode 100644 arch/um/include/shared/um_uaccess.h

diff --git a/arch/um/include/asm/uaccess.h b/arch/um/include/asm/uaccess.h
index b9a895d..3f22fbf 100644
--- a/arch/um/include/asm/uaccess.h
+++ b/arch/um/include/asm/uaccess.h
@@ -6,15 +6,15 @@
 #ifndef __UM_UACCESS_H
 #define __UM_UACCESS_H
 
-#include <asm/errno.h>
-#include <asm/processor.h>
-
 /* thread_info has a mm_segment_t in it, so put the definition up here */
 typedef struct {
 	unsigned long seg;
 } mm_segment_t;
 
-#include "linux/thread_info.h"
+#include <linux/thread_info.h>
+#include <linux/errno.h>
+#include <asm/processor.h>
+#include <asm/elf.h>
 
 #define VERIFY_READ 0
 #define VERIFY_WRITE 1
@@ -38,7 +38,86 @@ typedef struct {
 
 #define segment_eq(a, b) ((a).seg == (b).seg)
 
-#include "um_uaccess.h"
+#define __under_task_size(addr, size) \
+	(((unsigned long) (addr) < TASK_SIZE) && \
+	 (((unsigned long) (addr) + (size)) < TASK_SIZE))
+
+#define __access_ok_vsyscall(type, addr, size) \
+	 ((type == VERIFY_READ) && \
+	  ((unsigned long) (addr) >= FIXADDR_USER_START) && \
+	  ((unsigned long) (addr) + (size) <= FIXADDR_USER_END) && \
+	  ((unsigned long) (addr) + (size) >= (unsigned long)(addr)))
+
+#define __addr_range_nowrap(addr, size) \
+	((unsigned long) (addr) <= ((unsigned long) (addr) + (size)))
+
+#define access_ok(type, addr, size) \
+	(__addr_range_nowrap(addr, size) && \
+	 (__under_task_size(addr, size) || \
+	  __access_ok_vsyscall(type, addr, size) || \
+	  segment_eq(get_fs(), KERNEL_DS)))
+
+extern int copy_from_user(void *to, const void __user *from, int n);
+extern int copy_to_user(void __user *to, const void *from, int n);
+
+/*
+ * strncpy_from_user: - Copy a NUL terminated string from userspace.
+ * @dst:   Destination address, in kernel space.  This buffer must be at
+ *         least @count bytes long.
+ * @src:   Source address, in user space.
+ * @count: Maximum number of bytes to copy, including the trailing NUL.
+ *
+ * Copies a NUL-terminated string from userspace to kernel space.
+ *
+ * On success, returns the length of the string (not including the trailing
+ * NUL).
+ *
+ * If access to userspace fails, returns -EFAULT (some data may have been
+ * copied).
+ *
+ * If @count is smaller than the length of the string, copies @count bytes
+ * and returns @count.
+ */
+
+extern int strncpy_from_user(char *dst, const char __user *src, int count);
+
+/*
+ * __clear_user: - Zero a block of memory in user space, with less checking.
+ * @to:   Destination address, in user space.
+ * @n:    Number of bytes to zero.
+ *
+ * Zero a block of memory in user space.  Caller must check
+ * the specified block with access_ok() before calling this function.
+ *
+ * Returns number of bytes that could not be cleared.
+ * On success, this will be zero.
+ */
+extern int __clear_user(void __user *mem, int len);
+
+/*
+ * clear_user: - Zero a block of memory in user space.
+ * @to:   Destination address, in user space.
+ * @n:    Number of bytes to zero.
+ *
+ * Zero a block of memory in user space.
+ *
+ * Returns number of bytes that could not be cleared.
+ * On success, this will be zero.
+ */
+extern int clear_user(void __user *mem, int len);
+
+/*
+ * strlen_user: - Get the size of a string in user space.
+ * @str: The string to measure.
+ * @n:   The maximum valid length
+ *
+ * Get the size of a NUL-terminated string in user space.
+ *
+ * Returns the size of the string INCLUDING the terminating NUL.
+ * On exception, returns 0.
+ * If the string is too long, returns a value greater than @n.
+ */
+extern int strnlen_user(const void __user *str, int len);
 
 #define __copy_from_user(to, from, n) copy_from_user(to, from, n)
 
diff --git a/arch/um/include/shared/um_uaccess.h b/arch/um/include/shared/um_uaccess.h
deleted file mode 100644
index 51e1cce..0000000
--- a/arch/um/include/shared/um_uaccess.h
+++ /dev/null
@@ -1,94 +0,0 @@
-/* 
- * Copyright (C) 2002 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
- * Licensed under the GPL
- */
-
-#ifndef __ARCH_UM_UACCESS_H
-#define __ARCH_UM_UACCESS_H
-
-#include <asm/elf.h>
-#include <asm/fixmap.h>
-#include "sysdep/archsetjmp.h"
-
-#define __under_task_size(addr, size) \
-	(((unsigned long) (addr) < TASK_SIZE) && \
-	 (((unsigned long) (addr) + (size)) < TASK_SIZE))
-
-#define __access_ok_vsyscall(type, addr, size) \
-	 ((type == VERIFY_READ) && \
-	  ((unsigned long) (addr) >= FIXADDR_USER_START) && \
-	  ((unsigned long) (addr) + (size) <= FIXADDR_USER_END) && \
-	  ((unsigned long) (addr) + (size) >= (unsigned long)(addr)))
-
-#define __addr_range_nowrap(addr, size) \
-	((unsigned long) (addr) <= ((unsigned long) (addr) + (size)))
-
-#define access_ok(type, addr, size) \
-	(__addr_range_nowrap(addr, size) && \
-	 (__under_task_size(addr, size) || \
-	  __access_ok_vsyscall(type, addr, size) || \
-	  segment_eq(get_fs(), KERNEL_DS)))
-
-extern int copy_from_user(void *to, const void __user *from, int n);
-extern int copy_to_user(void __user *to, const void *from, int n);
-
-/*
- * strncpy_from_user: - Copy a NUL terminated string from userspace.
- * @dst:   Destination address, in kernel space.  This buffer must be at
- *         least @count bytes long.
- * @src:   Source address, in user space.
- * @count: Maximum number of bytes to copy, including the trailing NUL.
- *
- * Copies a NUL-terminated string from userspace to kernel space.
- *
- * On success, returns the length of the string (not including the trailing
- * NUL).
- *
- * If access to userspace fails, returns -EFAULT (some data may have been
- * copied).
- *
- * If @count is smaller than the length of the string, copies @count bytes
- * and returns @count.
- */
-
-extern int strncpy_from_user(char *dst, const char __user *src, int count);
-
-/*
- * __clear_user: - Zero a block of memory in user space, with less checking.
- * @to:   Destination address, in user space.
- * @n:    Number of bytes to zero.
- *
- * Zero a block of memory in user space.  Caller must check
- * the specified block with access_ok() before calling this function.
- *
- * Returns number of bytes that could not be cleared.
- * On success, this will be zero.
- */
-extern int __clear_user(void __user *mem, int len);
-
-/*
- * clear_user: - Zero a block of memory in user space.
- * @to:   Destination address, in user space.
- * @n:    Number of bytes to zero.
- *
- * Zero a block of memory in user space.
- *
- * Returns number of bytes that could not be cleared.
- * On success, this will be zero.
- */
-extern int clear_user(void __user *mem, int len);
-
-/*
- * strlen_user: - Get the size of a string in user space.
- * @str: The string to measure.
- * @n:   The maximum valid length
- *
- * Get the size of a NUL-terminated string in user space.
- *
- * Returns the size of the string INCLUDING the terminating NUL.
- * On exception, returns 0.
- * If the string is too long, returns a value greater than @n.
- */
-extern int strnlen_user(const void __user *str, int len);
-
-#endif
-- 
1.7.2.5


