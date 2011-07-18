Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001Ab1GRNHq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 09:07:46 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:44034 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024Ab1GRNHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 09:07:45 -0400
From: Richard Weinberger <richard@nod.at>
To: user-mode-linux-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH 1/3] um: Disable scan_elf_aux() on x86_64
Date: Mon, 18 Jul 2011 15:07:34 +0200
Message-Id: <1310994456-14142-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reusing the host's vsyscall area makes only sense on x86_32.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/os-Linux/Makefile  |    4 +++-
 arch/um/os-Linux/elf_aux.c |    7 +------
 arch/um/os-Linux/main.c    |    4 ++++
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/um/os-Linux/Makefile b/arch/um/os-Linux/Makefile
index d66f038..b33f4df 100644
--- a/arch/um/os-Linux/Makefile
+++ b/arch/um/os-Linux/Makefile
@@ -3,10 +3,12 @@
 # Licensed under the GPL
 #
 
-obj-y = aio.o elf_aux.o execvp.o file.o helper.o irq.o main.o mem.o process.o \
+obj-y = aio.o execvp.o file.o helper.o irq.o main.o mem.o process.o \
 	registers.o sigio.o signal.o start_up.o time.o tty.o uaccess.o \
 	umid.o tls.o user_syms.o util.o drivers/ sys-$(SUBARCH)/ skas/
 
+obj-$(CONFIG_ARCH_REUSE_HOST_VSYSCALL_AREA) += elf_aux.o
+
 USER_OBJS := $(user-objs-y) aio.o elf_aux.o execvp.o file.o helper.o irq.o \
 	main.o mem.o process.o registers.o sigio.o signal.o start_up.o time.o \
 	tty.o tls.o uaccess.o umid.o util.o
diff --git a/arch/um/os-Linux/elf_aux.c b/arch/um/os-Linux/elf_aux.c
index 608784d..9533237 100644
--- a/arch/um/os-Linux/elf_aux.c
+++ b/arch/um/os-Linux/elf_aux.c
@@ -14,16 +14,11 @@
 #include "mem_user.h"
 #include <kern_constants.h>
 
-/* Use the one from the kernel - the host may miss it, if having old headers. */
-#if UM_ELF_CLASS == UM_ELFCLASS32
 typedef Elf32_auxv_t elf_auxv_t;
-#else
-typedef Elf64_auxv_t elf_auxv_t;
-#endif
 
 /* These are initialized very early in boot and never changed */
 char * elf_aux_platform;
-long elf_aux_hwcap;
+extern long elf_aux_hwcap;
 unsigned long vsyscall_ehdr;
 unsigned long vsyscall_end;
 unsigned long __kernel_vsyscall;
diff --git a/arch/um/os-Linux/main.c b/arch/um/os-Linux/main.c
index fb2a97a..8471b81 100644
--- a/arch/um/os-Linux/main.c
+++ b/arch/um/os-Linux/main.c
@@ -21,6 +21,8 @@
 #define STACKSIZE (8 * 1024 * 1024)
 #define THREAD_NAME_LEN (256)
 
+long elf_aux_hwcap;
+
 static void set_stklim(void)
 {
 	struct rlimit lim;
@@ -143,7 +145,9 @@ int __init main(int argc, char **argv, char **envp)
 	install_fatal_handler(SIGINT);
 	install_fatal_handler(SIGTERM);
 
+#ifdef CONFIG_ARCH_REUSE_HOST_VSYSCALL_AREA
 	scan_elf_aux(envp);
+#endif
 
 	do_uml_initcalls();
 	ret = linux_main(argc, argv);
-- 
1.7.6

