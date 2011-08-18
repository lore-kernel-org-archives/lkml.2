Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab1HRTJw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:09:52 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47554 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414Ab1HRTJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:09:50 -0400
Date: Thu, 18 Aug 2011 20:09:49 +0100
To: richard@nod.at
Subject: Subject: [PATCH 65/91] um: merge os-Linux/tls.c into
 arch/x86/um/os-Linux/tls.c
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7yP-0007wS-R3@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


it's i386-specific; moreover, analogs on other targets have
incompatible interface - PTRACE_GET_THREAD_AREA does exist
elsewhere, but struct user_desc does *not*

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/include/shared/os.h     |    5 -----
 arch/um/os-Linux/Makefile       |    4 ++--
 arch/um/os-Linux/tls.c          |   35 -----------------------------------
 arch/x86/um/os-Linux/tls.c      |   34 +++++++++++++++++++++++++++++++++-
 arch/x86/um/shared/sysdep/tls.h |    3 +++
 5 files changed, 38 insertions(+), 43 deletions(-)
 delete mode 100644 arch/um/os-Linux/tls.c

diff --git a/arch/um/include/shared/os.h b/arch/um/include/shared/os.h
index caa6661..89b686c1 100644
--- a/arch/um/include/shared/os.h
+++ b/arch/um/include/shared/os.h
@@ -10,7 +10,6 @@
 #include "irq_user.h"
 #include "longjmp.h"
 #include "mm_id.h"
-#include "sysdep/tls.h"
 
 #define CATCH_EINTR(expr) while ((errno = 0, ((expr) < 0)) && (errno == EINTR))
 
@@ -212,10 +211,6 @@ extern int run_helper_thread(int (*proc)(void *), void *arg,
 extern int helper_wait(int pid);
 
 
-/* tls.c */
-extern int os_set_thread_area(user_desc_t *info, int pid);
-extern int os_get_thread_area(user_desc_t *info, int pid);
-
 /* umid.c */
 extern int umid_file_name(char *name, char *buf, int len);
 extern int set_umid(char *name);
diff --git a/arch/um/os-Linux/Makefile b/arch/um/os-Linux/Makefile
index 015d000..dd76410 100644
--- a/arch/um/os-Linux/Makefile
+++ b/arch/um/os-Linux/Makefile
@@ -5,13 +5,13 @@
 
 obj-y = aio.o execvp.o file.o helper.o irq.o main.o mem.o process.o \
 	registers.o sigio.o signal.o start_up.o time.o tty.o \
-	umid.o tls.o user_syms.o util.o drivers/ skas/
+	umid.o user_syms.o util.o drivers/ skas/
 
 obj-$(CONFIG_ARCH_REUSE_HOST_VSYSCALL_AREA) += elf_aux.o
 
 USER_OBJS := $(user-objs-y) aio.o elf_aux.o execvp.o file.o helper.o irq.o \
 	main.o mem.o process.o registers.o sigio.o signal.o start_up.o time.o \
-	tty.o tls.o umid.o util.o
+	tty.o umid.o util.o
 
 CFLAGS_user_syms.o += -DSUBARCH_$(SUBARCH)
 
diff --git a/arch/um/os-Linux/tls.c b/arch/um/os-Linux/tls.c
deleted file mode 100644
index 7327780..0000000
--- a/arch/um/os-Linux/tls.c
+++ /dev/null
@@ -1,35 +0,0 @@
-#include <errno.h>
-#include <sys/ptrace.h>
-#include "sysdep/tls.h"
-
-/* TLS support - we basically rely on the host's one.*/
-
-#ifndef PTRACE_GET_THREAD_AREA
-#define PTRACE_GET_THREAD_AREA 25
-#endif
-
-#ifndef PTRACE_SET_THREAD_AREA
-#define PTRACE_SET_THREAD_AREA 26
-#endif
-
-int os_set_thread_area(user_desc_t *info, int pid)
-{
-	int ret;
-
-	ret = ptrace(PTRACE_SET_THREAD_AREA, pid, info->entry_number,
-		     (unsigned long) info);
-	if (ret < 0)
-		ret = -errno;
-	return ret;
-}
-
-int os_get_thread_area(user_desc_t *info, int pid)
-{
-	int ret;
-
-	ret = ptrace(PTRACE_GET_THREAD_AREA, pid, info->entry_number,
-		     (unsigned long) info);
-	if (ret < 0)
-		ret = -errno;
-	return ret;
-}
diff --git a/arch/x86/um/os-Linux/tls.c b/arch/x86/um/os-Linux/tls.c
index 281e83e..82276b6 100644
--- a/arch/x86/um/os-Linux/tls.c
+++ b/arch/x86/um/os-Linux/tls.c
@@ -1,15 +1,25 @@
 #include <errno.h>
 #include <linux/unistd.h>
 
+#include <sys/ptrace.h>
 #include <sys/syscall.h>
 #include <unistd.h>
 
 #include "sysdep/tls.h"
 
+#ifndef PTRACE_GET_THREAD_AREA
+#define PTRACE_GET_THREAD_AREA 25
+#endif
+
+#ifndef PTRACE_SET_THREAD_AREA
+#define PTRACE_SET_THREAD_AREA 26
+#endif
+
 /* Checks whether host supports TLS, and sets *tls_min according to the value
  * valid on the host.
  * i386 host have it == 6; x86_64 host have it == 12, for i386 emulation. */
-void check_host_supports_tls(int *supports_tls, int *tls_min) {
+void check_host_supports_tls(int *supports_tls, int *tls_min)
+{
 	/* Values for x86 and x86_64.*/
 	int val[] = {GDT_ENTRY_TLS_MIN_I386, GDT_ENTRY_TLS_MIN_X86_64};
 	int i;
@@ -33,3 +43,25 @@ void check_host_supports_tls(int *supports_tls, int *tls_min) {
 
 	*supports_tls = 0;
 }
+
+int os_set_thread_area(user_desc_t *info, int pid)
+{
+	int ret;
+
+	ret = ptrace(PTRACE_SET_THREAD_AREA, pid, info->entry_number,
+		     (unsigned long) info);
+	if (ret < 0)
+		ret = -errno;
+	return ret;
+}
+
+int os_get_thread_area(user_desc_t *info, int pid)
+{
+	int ret;
+
+	ret = ptrace(PTRACE_GET_THREAD_AREA, pid, info->entry_number,
+		     (unsigned long) info);
+	if (ret < 0)
+		ret = -errno;
+	return ret;
+}
diff --git a/arch/x86/um/shared/sysdep/tls.h b/arch/x86/um/shared/sysdep/tls.h
index db2ae9c..f2f30bd 100644
--- a/arch/x86/um/shared/sysdep/tls.h
+++ b/arch/x86/um/shared/sysdep/tls.h
@@ -29,6 +29,9 @@ typedef struct user_desc user_desc_t;
 
 # endif /* __KERNEL__ */
 
+extern int os_set_thread_area(user_desc_t *info, int pid);
+extern int os_get_thread_area(user_desc_t *info, int pid);
+
 #ifdef __i386__
 #define GDT_ENTRY_TLS_MIN_I386 6
 #define GDT_ENTRY_TLS_MIN_X86_64 12
-- 
1.7.2.5


