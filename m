Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645Ab1HRTDc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:03:32 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44280 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607Ab1HRTDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:03:30 -0400
Date: Thu, 18 Aug 2011 20:03:29 +0100
To: richard@nod.at
Subject: Subject: [PATCH 27/91] um: kill dead code around uaccess
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7sH-0007cV-Cu@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/include/shared/os.h         |    6 ------
 arch/um/include/shared/um_uaccess.h |    3 ---
 arch/um/kernel/Makefile             |    2 +-
 arch/um/kernel/uaccess.c            |   33 ---------------------------------
 arch/um/os-Linux/Makefile           |    4 ++--
 arch/um/os-Linux/uaccess.c          |   32 --------------------------------
 6 files changed, 3 insertions(+), 77 deletions(-)
 delete mode 100644 arch/um/kernel/uaccess.c
 delete mode 100644 arch/um/os-Linux/uaccess.c

diff --git a/arch/um/include/shared/os.h b/arch/um/include/shared/os.h
index 83c7c2e..2e2663a 100644
--- a/arch/um/include/shared/os.h
+++ b/arch/um/include/shared/os.h
@@ -203,12 +203,6 @@ extern int os_drop_memory(void *addr, int length);
 extern int can_drop_memory(void);
 extern void os_flush_stdout(void);
 
-/* uaccess.c */
-extern unsigned long __do_user_copy(void *to, const void *from, int n,
-				    void **fault_addr, jmp_buf **fault_catcher,
-				    void (*op)(void *to, const void *from,
-					       int n), int *faulted_out);
-
 /* execvp.c */
 extern int execvp_noalloc(char *buf, const char *file, char *const argv[]);
 /* helper.c */
diff --git a/arch/um/include/shared/um_uaccess.h b/arch/um/include/shared/um_uaccess.h
index 45c0499..51e1cce 100644
--- a/arch/um/include/shared/um_uaccess.h
+++ b/arch/um/include/shared/um_uaccess.h
@@ -32,9 +32,6 @@
 extern int copy_from_user(void *to, const void __user *from, int n);
 extern int copy_to_user(void __user *to, const void *from, int n);
 
-extern int __do_copy_to_user(void *to, const void *from, int n,
-			     void **fault_addr, jmp_buf **fault_catcher);
-
 /*
  * strncpy_from_user: - Copy a NUL terminated string from userspace.
  * @dst:   Destination address, in kernel space.  This buffer must be at
diff --git a/arch/um/kernel/Makefile b/arch/um/kernel/Makefile
index c4491c1..bc49474 100644
--- a/arch/um/kernel/Makefile
+++ b/arch/um/kernel/Makefile
@@ -11,7 +11,7 @@ clean-files :=
 
 obj-y = config.o exec.o exitcode.o init_task.o irq.o ksyms.o mem.o \
 	physmem.o process.o ptrace.o reboot.o sigio.o \
-	signal.o smp.o syscall.o sysrq.o time.o tlb.o trap.o uaccess.o \
+	signal.o smp.o syscall.o sysrq.o time.o tlb.o trap.o \
 	um_arch.o umid.o skas/
 
 obj-$(CONFIG_BLK_DEV_INITRD) += initrd.o
diff --git a/arch/um/kernel/uaccess.c b/arch/um/kernel/uaccess.c
deleted file mode 100644
index dd33f04..0000000
--- a/arch/um/kernel/uaccess.c
+++ /dev/null
@@ -1,33 +0,0 @@
-/*
- * Copyright (C) 2001 Chris Emerson (cemerson@chiark.greenend.org.uk)
- * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
- * Licensed under the GPL
- */
-
-/*
- * These are here rather than tt/uaccess.c because skas mode needs them in
- * order to do SIGBUS recovery when a tmpfs mount runs out of room.
- */
-
-#include <linux/string.h>
-#include "os.h"
-
-static void __do_copy(void *to, const void *from, int n)
-{
-	memcpy(to, from, n);
-}
-
-
-int __do_copy_to_user(void *to, const void *from, int n,
-		      void **fault_addr, jmp_buf **fault_catcher)
-{
-	unsigned long fault;
-	int faulted;
-
-	fault = __do_user_copy(to, from, n, fault_addr, fault_catcher,
-			       __do_copy, &faulted);
-	if (!faulted)
-		return 0;
-	else
-		return n - (fault - (unsigned long) to);
-}
diff --git a/arch/um/os-Linux/Makefile b/arch/um/os-Linux/Makefile
index b33f4df..7aec5bf 100644
--- a/arch/um/os-Linux/Makefile
+++ b/arch/um/os-Linux/Makefile
@@ -4,14 +4,14 @@
 #
 
 obj-y = aio.o execvp.o file.o helper.o irq.o main.o mem.o process.o \
-	registers.o sigio.o signal.o start_up.o time.o tty.o uaccess.o \
+	registers.o sigio.o signal.o start_up.o time.o tty.o \
 	umid.o tls.o user_syms.o util.o drivers/ sys-$(SUBARCH)/ skas/
 
 obj-$(CONFIG_ARCH_REUSE_HOST_VSYSCALL_AREA) += elf_aux.o
 
 USER_OBJS := $(user-objs-y) aio.o elf_aux.o execvp.o file.o helper.o irq.o \
 	main.o mem.o process.o registers.o sigio.o signal.o start_up.o time.o \
-	tty.o tls.o uaccess.o umid.o util.o
+	tty.o tls.o umid.o util.o
 
 CFLAGS_user_syms.o += -DSUBARCH_$(SUBARCH)
 
diff --git a/arch/um/os-Linux/uaccess.c b/arch/um/os-Linux/uaccess.c
deleted file mode 100644
index 087ed74..0000000
--- a/arch/um/os-Linux/uaccess.c
+++ /dev/null
@@ -1,32 +0,0 @@
-/*
- * Copyright (C) 2001 Chris Emerson (cemerson@chiark.greenend.org.uk)
- * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
- * Licensed under the GPL
- */
-
-#include <stddef.h>
-#include "longjmp.h"
-
-unsigned long __do_user_copy(void *to, const void *from, int n,
-			     void **fault_addr, jmp_buf **fault_catcher,
-			     void (*op)(void *to, const void *from,
-					int n), int *faulted_out)
-{
-	unsigned long *faddrp = (unsigned long *) fault_addr, ret;
-
-	jmp_buf jbuf;
-	*fault_catcher = &jbuf;
-	if (UML_SETJMP(&jbuf) == 0) {
-		(*op)(to, from, n);
-		ret = 0;
-		*faulted_out = 0;
-	}
-	else {
-		ret = *faddrp;
-		*faulted_out = 1;
-	}
-	*fault_addr = NULL;
-	*fault_catcher = NULL;
-	return ret;
-}
-
-- 
1.7.2.5


