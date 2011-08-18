Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713Ab1HRTDm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:03:42 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44283 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563Ab1HRTDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:03:40 -0400
Date: Thu, 18 Aug 2011 20:03:39 +0100
To: richard@nod.at
Subject: Subject: [PATCH 28/91] um: merge hard_handler() instances, switch to use of SA_SIGINFO
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7sR-0007cn-D8@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/os-Linux/signal.c            |   12 ++++++++----
 arch/um/os-Linux/sys-i386/Makefile   |    2 +-
 arch/um/os-Linux/sys-i386/signal.c   |   13 -------------
 arch/um/os-Linux/sys-x86_64/Makefile |    2 +-
 arch/um/os-Linux/sys-x86_64/signal.c |   16 ----------------
 5 files changed, 10 insertions(+), 35 deletions(-)
 delete mode 100644 arch/um/os-Linux/sys-i386/signal.c
 delete mode 100644 arch/um/os-Linux/sys-x86_64/signal.c

diff --git a/arch/um/os-Linux/signal.c b/arch/um/os-Linux/signal.c
index 4fc3cd1..2dde9f6 100644
--- a/arch/um/os-Linux/signal.c
+++ b/arch/um/os-Linux/signal.c
@@ -127,7 +127,7 @@ void set_sigstack(void *sig_stack, int size)
 
 static void (*handlers[_NSIG])(int sig, struct sigcontext *sc);
 
-void handle_signal(int sig, struct sigcontext *sc)
+static void handle_signal(int sig, struct sigcontext *sc)
 {
 	unsigned long pending = 1UL << sig;
 
@@ -168,7 +168,11 @@ void handle_signal(int sig, struct sigcontext *sc)
 	} while (pending);
 }
 
-extern void hard_handler(int sig);
+static void hard_handler(int sig, siginfo_t *info, void *p)
+{
+	struct ucontext *uc = p;
+	handle_signal(sig, (struct sigcontext *) &uc->uc_mcontext);
+}
 
 void set_handler(int sig, void (*handler)(int), int flags, ...)
 {
@@ -178,7 +182,7 @@ void set_handler(int sig, void (*handler)(int), int flags, ...)
 	int mask;
 
 	handlers[sig] = (void (*)(int, struct sigcontext *)) handler;
-	action.sa_handler = hard_handler;
+	action.sa_sigaction = hard_handler;
 
 	sigemptyset(&action.sa_mask);
 
@@ -190,7 +194,7 @@ void set_handler(int sig, void (*handler)(int), int flags, ...)
 	if (sig == SIGSEGV)
 		flags |= SA_NODEFER;
 
-	action.sa_flags = flags;
+	action.sa_flags = flags | SA_SIGINFO;
 	action.sa_restorer = NULL;
 	if (sigaction(sig, &action, NULL) < 0)
 		panic("sigaction failed - errno = %d\n", errno);
diff --git a/arch/um/os-Linux/sys-i386/Makefile b/arch/um/os-Linux/sys-i386/Makefile
index b4bc6ac..d491754 100644
--- a/arch/um/os-Linux/sys-i386/Makefile
+++ b/arch/um/os-Linux/sys-i386/Makefile
@@ -3,7 +3,7 @@
 # Licensed under the GPL
 #
 
-obj-y = registers.o signal.o task_size.o tls.o
+obj-y = registers.o task_size.o tls.o
 
 USER_OBJS := $(obj-y)
 
diff --git a/arch/um/os-Linux/sys-i386/signal.c b/arch/um/os-Linux/sys-i386/signal.c
deleted file mode 100644
index f311609..0000000
--- a/arch/um/os-Linux/sys-i386/signal.c
+++ /dev/null
@@ -1,13 +0,0 @@
-/*
- * Copyright (C) 2006 Jeff Dike (jdike@{addtoit,linux.intel}.com)
- * Licensed under the GPL
- */
-
-#include <signal.h>
-
-extern void handle_signal(int sig, struct sigcontext *sc);
-
-void hard_handler(int sig)
-{
-	handle_signal(sig, (struct sigcontext *) (&sig + 1));
-}
diff --git a/arch/um/os-Linux/sys-x86_64/Makefile b/arch/um/os-Linux/sys-x86_64/Makefile
index a44a47f..58f6e0a 100644
--- a/arch/um/os-Linux/sys-x86_64/Makefile
+++ b/arch/um/os-Linux/sys-x86_64/Makefile
@@ -3,7 +3,7 @@
 # Licensed under the GPL
 #
 
-obj-y = registers.o prctl.o signal.o task_size.o
+obj-y = registers.o prctl.o task_size.o
 
 USER_OBJS := $(obj-y)
 
diff --git a/arch/um/os-Linux/sys-x86_64/signal.c b/arch/um/os-Linux/sys-x86_64/signal.c
deleted file mode 100644
index 82a3888..0000000
--- a/arch/um/os-Linux/sys-x86_64/signal.c
+++ /dev/null
@@ -1,16 +0,0 @@
-/*
- * Copyright (C) 2006 Jeff Dike (jdike@{addtoit,linux.intel}.com)
- * Licensed under the GPL
- */
-
-#include <signal.h>
-
-extern void handle_signal(int sig, struct sigcontext *sc);
-
-void hard_handler(int sig)
-{
-	struct ucontext *uc;
-	asm("movq %%rdx, %0" : "=r" (uc));
-
-	handle_signal(sig, (struct sigcontext *) &uc->uc_mcontext);
-}
-- 
1.7.2.5


