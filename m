Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab1HRTEl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:04:41 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44308 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740Ab1HRTEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:04:40 -0400
Date: Thu, 18 Aug 2011 20:04:39 +0100
To: richard@nod.at
Subject: Subject: [PATCH 34/91] um: fill the handlers array at build time
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7tP-0007g0-FT@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/include/shared/os.h     |    2 +-
 arch/um/os-Linux/process.c      |   12 ++++++------
 arch/um/os-Linux/signal.c       |   17 +++++++++++++----
 arch/um/os-Linux/skas/process.c |    2 +-
 4 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/arch/um/include/shared/os.h b/arch/um/include/shared/os.h
index 598ca82..caa6661 100644
--- a/arch/um/include/shared/os.h
+++ b/arch/um/include/shared/os.h
@@ -225,7 +225,7 @@ extern char *get_umid(void);
 extern void timer_init(void);
 extern void set_sigstack(void *sig_stack, int size);
 extern void remove_sigstack(void);
-extern void set_handler(int sig, void (*handler)(int));
+extern void set_handler(int sig);
 extern int change_sig(int signal, int on);
 extern void block_signals(void);
 extern void unblock_signals(void);
diff --git a/arch/um/os-Linux/process.c b/arch/um/os-Linux/process.c
index 075ae92..e08fe30 100644
--- a/arch/um/os-Linux/process.c
+++ b/arch/um/os-Linux/process.c
@@ -235,13 +235,13 @@ out:
 
 void init_new_thread_signals(void)
 {
-	set_handler(SIGSEGV, (__sighandler_t) sig_handler);
-	set_handler(SIGTRAP, (__sighandler_t) sig_handler);
-	set_handler(SIGFPE, (__sighandler_t) sig_handler);
-	set_handler(SIGILL, (__sighandler_t) sig_handler);
-	set_handler(SIGBUS, (__sighandler_t) sig_handler);
+	set_handler(SIGSEGV);
+	set_handler(SIGTRAP);
+	set_handler(SIGFPE);
+	set_handler(SIGILL);
+	set_handler(SIGBUS);
 	signal(SIGHUP, SIG_IGN);
-	set_handler(SIGIO, (__sighandler_t) sig_handler);
+	set_handler(SIGIO);
 	signal(SIGWINCH, SIG_IGN);
 	signal(SIGTERM, SIG_DFL);
 }
diff --git a/arch/um/os-Linux/signal.c b/arch/um/os-Linux/signal.c
index f248fb2..c4a4e20 100644
--- a/arch/um/os-Linux/signal.c
+++ b/arch/um/os-Linux/signal.c
@@ -111,7 +111,7 @@ void alarm_handler(int sig, struct sigcontext *sc)
 
 void timer_init(void)
 {
-	set_handler(SIGVTALRM, (__sighandler_t) alarm_handler);
+	set_handler(SIGVTALRM);
 }
 
 void set_sigstack(void *sig_stack, int size)
@@ -124,7 +124,17 @@ void set_sigstack(void *sig_stack, int size)
 		panic("enabling signal stack failed, errno = %d\n", errno);
 }
 
-static void (*handlers[_NSIG])(int sig, struct sigcontext *sc);
+static void (*handlers[_NSIG])(int sig, struct sigcontext *sc) = {
+	[SIGSEGV] = sig_handler,
+	[SIGBUS] = sig_handler,
+	[SIGILL] = sig_handler,
+	[SIGFPE] = sig_handler,
+	[SIGTRAP] = sig_handler,
+
+	[SIGIO] = sig_handler,
+	[SIGWINCH] = sig_handler,
+	[SIGVTALRM] = alarm_handler
+};
 
 static void handle_signal(int sig, struct sigcontext *sc)
 {
@@ -173,13 +183,12 @@ static void hard_handler(int sig, siginfo_t *info, void *p)
 	handle_signal(sig, (struct sigcontext *) &uc->uc_mcontext);
 }
 
-void set_handler(int sig, void (*handler)(int))
+void set_handler(int sig)
 {
 	struct sigaction action;
 	int flags = SA_SIGINFO | SA_ONSTACK;
 	sigset_t sig_mask;
 
-	handlers[sig] = (void (*)(int, struct sigcontext *)) handler;
 	action.sa_sigaction = hard_handler;
 
 	/* block irq ones */
diff --git a/arch/um/os-Linux/skas/process.c b/arch/um/os-Linux/skas/process.c
index 8515fdd..8a1ccc7 100644
--- a/arch/um/os-Linux/skas/process.c
+++ b/arch/um/os-Linux/skas/process.c
@@ -642,7 +642,7 @@ int start_idle_thread(void *stack, jmp_buf *switch_buf)
 {
 	int n;
 
-	set_handler(SIGWINCH, (__sighandler_t) sig_handler);
+	set_handler(SIGWINCH);
 
 	/*
 	 * Can't use UML_SETJMP or UML_LONGJMP here because they save
-- 
1.7.2.5


