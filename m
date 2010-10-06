Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759544Ab0JFSGf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 14:06:35 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:50112 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759524Ab0JFSGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 14:06:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 6/8] arm: generalize asm/signal.h
Date: Wed,  6 Oct 2010 20:06:18 +0200
Message-Id: <1286388380-20646-7-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1286388380-20646-1-git-send-email-arnd@arndb.de>
References: <1286388380-20646-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:xNq0I7Nke//8wtswbyskzjJpXnzxs+ax9L5cKij/IVg
 Ir58pluNi5Zbqdgd3qI3wcJnpMEgoT9oqCNP/lt/ZhI51jZSEJ
 iefJeAhK0RAsYoMjl41EQmvZOd9nXRLaveqg4WgVf59YwvP5J7
 iMUPE8VWCjBjdZpO+uRGgY/2TICbeJseX2bjYpt4+cGCFM05B5
 pdAUMcNdRYtjOV+TSPZAw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The signal.h implementation in arm is mostly generic, this
makes it look like the version in include/asm-generic/.

In addition to the definitions from the generic file, arm
needs two SA_FLAGS values (SA_THIRTYTWO and SA_RESTORER)
and a nonstandard signal (SIGSWI) as well as the definition
of the legacy struct old_sigaction.

We do however drop support for libc5 and older using the
header in user space. This was done on other architectures
before because libc5 header compatibility has been broken
elsewhere for a long time already.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/include/asm/signal.h |  119 +++++++++++++++++++----------------------
 1 files changed, 56 insertions(+), 63 deletions(-)

diff --git a/arch/arm/include/asm/signal.h b/arch/arm/include/asm/signal.h
index 43ba0fb..6c67030 100644
--- a/arch/arm/include/asm/signal.h
+++ b/arch/arm/include/asm/signal.h
@@ -1,33 +1,27 @@
 #ifndef _ASMARM_SIGNAL_H
 #define _ASMARM_SIGNAL_H
 
-#include <linux/types.h>
+/*
+ * ARM specific SA_FLAGS values:
+ * SA_THIRTYTWO		delivers the signal in 32-bit mode, even if the task 
+ *			is running in 26-bit.
+ * SA_RESTART		flag to get restarting signals (which were the default long ago)
+ */
+#define SA_THIRTYTWO	0x02000000
+#define SA_RESTORER	0x04000000
 
-/* Avoid too many header ordering problems.  */
-struct siginfo;
+/*
+ * ARM specific signals
+ */
+#define SIGSWI		32
 
-#ifdef __KERNEL__
-/* Most things should be clean enough to redefine this at will, if care
-   is taken to make libc match.  */
+/* Generic stuff below */
+#include <linux/types.h>
 
 #define _NSIG		64
-#define _NSIG_BPW	32
+#define _NSIG_BPW	__BITS_PER_LONG
 #define _NSIG_WORDS	(_NSIG / _NSIG_BPW)
 
-typedef unsigned long old_sigset_t;		/* at least 32 bits */
-
-typedef struct {
-	unsigned long sig[_NSIG_WORDS];
-} sigset_t;
-
-#else
-/* Here we must cater to libcs that poke about in kernel headers.  */
-
-#define NSIG		32
-typedef unsigned long sigset_t;
-
-#endif /* __KERNEL__ */
-
 #define SIGHUP		 1
 #define SIGINT		 2
 #define SIGQUIT		 3
@@ -68,22 +62,20 @@ typedef unsigned long sigset_t;
 
 /* These should not be considered constants from userland.  */
 #define SIGRTMIN	32
+#ifndef SIGRTMAX
 #define SIGRTMAX	_NSIG
-
-#define SIGSWI		32
+#endif
 
 /*
  * SA_FLAGS values:
  *
- * SA_NOCLDSTOP		flag to turn off SIGCHLD when children stop.
- * SA_NOCLDWAIT		flag on SIGCHLD to inhibit zombies.
- * SA_SIGINFO		deliver the signal with SIGINFO structs
- * SA_THIRTYTWO		delivers the signal in 32-bit mode, even if the task 
- *			is running in 26-bit.
- * SA_ONSTACK		allows alternate signal stacks (see sigaltstack(2)).
- * SA_RESTART		flag to get restarting signals (which were the default long ago)
- * SA_NODEFER		prevents the current signal from being masked in the handler.
- * SA_RESETHAND		clears the handler when the signal is delivered.
+ * SA_ONSTACK indicates that a registered stack_t will be used.
+ * SA_SIGINFO deliver the signal with SIGINFO structs
+ * SA_RESTART flag to get restarting signals (which were the default long ago)
+ * SA_NOCLDSTOP flag to turn off SIGCHLD when children stop.
+ * SA_RESETHAND clears the handler when the signal is delivered.
+ * SA_NOCLDWAIT flag on SIGCHLD to inhibit zombies.
+ * SA_NODEFER prevents the current signal from being masked in the handler.
  *
  * SA_ONESHOT and SA_NOMASK are the historical Linux names for the Single
  * Unix names RESETHAND and NODEFER respectively.
@@ -91,8 +83,6 @@ typedef unsigned long sigset_t;
 #define SA_NOCLDSTOP	0x00000001
 #define SA_NOCLDWAIT	0x00000002
 #define SA_SIGINFO	0x00000004
-#define SA_THIRTYTWO	0x02000000
-#define SA_RESTORER	0x04000000
 #define SA_ONSTACK	0x08000000
 #define SA_RESTART	0x10000000
 #define SA_NODEFER	0x40000000
@@ -101,8 +91,12 @@ typedef unsigned long sigset_t;
 #define SA_NOMASK	SA_NODEFER
 #define SA_ONESHOT	SA_RESETHAND
 
+/*
+ * New architectures should not define the obsolete
+ *	SA_RESTORER	0x04000000
+ */
 
-/* 
+/*
  * sigaltstack controls
  */
 #define SS_ONSTACK	1
@@ -111,20 +105,22 @@ typedef unsigned long sigset_t;
 #define MINSIGSTKSZ	2048
 #define SIGSTKSZ	8192
 
-#include <asm-generic/signal-defs.h>
+#ifndef __ASSEMBLY__
+typedef struct {
+	unsigned long sig[_NSIG_WORDS];
+} sigset_t;
 
-#ifdef __KERNEL__
-struct old_sigaction {
-	__sighandler_t sa_handler;
-	old_sigset_t sa_mask;
-	unsigned long sa_flags;
-	__sigrestore_t sa_restorer;
-};
+/* not actually used, but required for linux/syscalls.h */
+typedef unsigned long old_sigset_t;
+
+#include <asm-generic/signal-defs.h>
 
 struct sigaction {
 	__sighandler_t sa_handler;
 	unsigned long sa_flags;
+#ifdef SA_RESTORER
 	__sigrestore_t sa_restorer;
+#endif
 	sigset_t sa_mask;		/* mask last for extensibility */
 };
 
@@ -132,24 +128,6 @@ struct k_sigaction {
 	struct sigaction sa;
 };
 
-#else
-/* Here we must cater to libcs that poke about in kernel headers.  */
-
-struct sigaction {
-	union {
-	  __sighandler_t _sa_handler;
-	  void (*_sa_sigaction)(int, struct siginfo *, void *);
-	} _u;
-	sigset_t sa_mask;
-	unsigned long sa_flags;
-	void (*sa_restorer)(void);
-};
-
-#define sa_handler	_u._sa_handler
-#define sa_sigaction	_u._sa_sigaction
-
-#endif /* __KERNEL__ */
-
 typedef struct sigaltstack {
 	void __user *ss_sp;
 	int ss_flags;
@@ -157,8 +135,23 @@ typedef struct sigaltstack {
 } stack_t;
 
 #ifdef __KERNEL__
+
 #include <asm/sigcontext.h>
+#undef __HAVE_ARCH_SIG_BITOPS
+
 #define ptrace_signal_deliver(regs, cookie) do { } while (0)
-#endif
 
-#endif
+#endif /* __KERNEL__ */
+#endif /* __ASSEMBLY__ */
+
+/* End generic stuff */
+#ifdef __KERNEL__
+struct old_sigaction {
+	__sighandler_t sa_handler;
+	old_sigset_t sa_mask;
+	unsigned long sa_flags;
+	__sigrestore_t sa_restorer;
+};
+#endif /* __KERNEL__ */
+
+#endif /* _ASMARM_SIGNAL_H */
-- 
1.7.1

