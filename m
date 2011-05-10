Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152Ab1EJSUi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 14:20:38 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:56730 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752097Ab1EJSUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 14:20:36 -0400
From: Richard Weinberger <richard@nod.at>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 4/4] um: os_dump_core() cleanup
Date: Tue, 10 May 2011 20:18:58 +0200
Message-Id: <1305051538-7191-4-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1305051538-7191-1-git-send-email-richard@nod.at>
References: <1305051538-7191-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When os_dump_core() raises SIGTERM to bring down all
UML processes this would also trigger the quite complex
do_uml_exitcalls() routine.
This is why UML crashed often while panicking.

Let's make os_dump_core() short and painless by killing all UML
processes with SIGHUP and calling the only sane exit call in this
context (remove_umid_dir()) by hand.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/include/shared/os.h |    1 +
 arch/um/os-Linux/umid.c     |    2 +-
 arch/um/os-Linux/util.c     |   22 +++++++---------------
 3 files changed, 9 insertions(+), 16 deletions(-)

diff --git a/arch/um/include/shared/os.h b/arch/um/include/shared/os.h
index f06a5da..5f88ee7 100644
--- a/arch/um/include/shared/os.h
+++ b/arch/um/include/shared/os.h
@@ -226,6 +226,7 @@ extern int os_get_thread_area(user_desc_t *info, int pid);
 extern int umid_file_name(char *name, char *buf, int len);
 extern int set_umid(char *name);
 extern char *get_umid(void);
+extern void remove_umid_dir(void);
 
 /* signal.c */
 extern void timer_init(void);
diff --git a/arch/um/os-Linux/umid.c b/arch/um/os-Linux/umid.c
index a27defb..48312a4 100644
--- a/arch/um/os-Linux/umid.c
+++ b/arch/um/os-Linux/umid.c
@@ -382,7 +382,7 @@ __uml_setup("uml_dir=", set_uml_dir,
 "    The location to place the pid and umid files.\n\n"
 );
 
-static void remove_umid_dir(void)
+void remove_umid_dir(void)
 {
 	char dir[strlen(uml_dir) + UMID_LEN + 1], err;
 
diff --git a/arch/um/os-Linux/util.c b/arch/um/os-Linux/util.c
index 42827ca..73d32f2 100644
--- a/arch/um/os-Linux/util.c
+++ b/arch/um/os-Linux/util.c
@@ -103,30 +103,21 @@ void os_dump_core(void)
 	signal(SIGSEGV, SIG_DFL);
 
 	/*
-	 * We are about to SIGTERM this entire process group to ensure that
-	 * nothing is around to run after the kernel exits.  The
-	 * kernel wants to abort, not die through SIGTERM, so we
-	 * ignore it here.
+	 * Send SIGHUP to kill non-kernel processes, kernel processes
+	 * ignore SIGHUP.
+	 * We are using SIGHUP because it has the same effect as SIGTERM
+	 * but it does not trigger other signal handlers.
 	 */
+	kill(0, SIGHUP);
 
-	signal(SIGTERM, SIG_IGN);
-	kill(0, SIGTERM);
 	/*
 	 * Most of the other processes associated with this UML are
 	 * likely sTopped, so give them a SIGCONT so they see the
-	 * SIGTERM.
+	 * SIGHUP.
 	 */
 	kill(0, SIGCONT);
 
 	/*
-	 * Now, having sent signals to everyone but us, make sure they
-	 * die by ptrace.  Processes can survive what's been done to
-	 * them so far - the mechanism I understand is receiving a
-	 * SIGSEGV and segfaulting immediately upon return.  There is
-	 * always a SIGSEGV pending, and (I'm guessing) signals are
-	 * processed in numeric order so the SIGTERM (signal 15 vs
-	 * SIGSEGV being signal 11) is never handled.
-	 *
 	 * Run a waitpid loop until we get some kind of error.
 	 * Hopefully, it's ECHILD, but there's not a lot we can do if
 	 * it's something else.  Tell os_kill_ptraced_process not to
@@ -137,5 +128,6 @@ void os_dump_core(void)
 	while ((pid = waitpid(-1, NULL, WNOHANG | __WALL)) > 0)
 		os_kill_ptraced_process(pid, 0);
 
+	remove_umid_dir();
 	uml_abort();
 }
-- 
1.7.4.2

