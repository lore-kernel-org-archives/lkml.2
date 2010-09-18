Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569Ab0IRTls (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:41:48 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39383 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756438Ab0IRTlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:41:46 -0400
Date: Sat, 18 Sep 2010 20:41:45 +0100
To: linux-arch@vger.kernel.org
Subject: [PATCH 2/5] frv: fix address verification holes in
 setup_frame/setup_rt_frame
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Ox3I9-0006RJ-B5@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


a) sa_handler might be maliciously set to point to kernel memory;
blindly dereferencing it in FDPIC case is a Bad Idea(tm).

b) I'm not sure you need that set_fs(USER_DS) there at all, but
if you do, you'd better do it *before* checking the frame you've
decided to use with access_ok(), lest sigaltstack() becomes a
convenient roothole.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/frv/kernel/signal.c |   40 +++++++++++++++++++++++-----------------
 1 files changed, 23 insertions(+), 17 deletions(-)

diff --git a/arch/frv/kernel/signal.c b/arch/frv/kernel/signal.c
index 7fc2961..d06226b 100644
--- a/arch/frv/kernel/signal.c
+++ b/arch/frv/kernel/signal.c
@@ -253,6 +253,8 @@ static int setup_frame(int sig, struct k_sigaction *ka, sigset_t *set)
 	struct sigframe __user *frame;
 	int rsig;
 
+	set_fs(USER_DS);
+
 	frame = get_sigframe(ka, sizeof(*frame));
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
@@ -296,22 +298,23 @@ static int setup_frame(int sig, struct k_sigaction *ka, sigset_t *set)
 				   (unsigned long) (frame->retcode + 2));
 	}
 
-	/* set up registers for signal handler */
-	__frame->sp   = (unsigned long) frame;
-	__frame->lr   = (unsigned long) &frame->retcode;
-	__frame->gr8  = sig;
-
 	if (current->personality & FDPIC_FUNCPTRS) {
 		struct fdpic_func_descriptor __user *funcptr =
 			(struct fdpic_func_descriptor __user *) ka->sa.sa_handler;
-		__get_user(__frame->pc, &funcptr->text);
-		__get_user(__frame->gr15, &funcptr->GOT);
+		struct fdpic_func_descriptor desc;
+		if (copy_from_user(&desc, funcptr, sizeof(desc)))
+			goto give_sigsegv;
+		__frame->pc = desc.text;
+		__frame->gr15 = desc.GOT;
 	} else {
 		__frame->pc   = (unsigned long) ka->sa.sa_handler;
 		__frame->gr15 = 0;
 	}
 
-	set_fs(USER_DS);
+	/* set up registers for signal handler */
+	__frame->sp   = (unsigned long) frame;
+	__frame->lr   = (unsigned long) &frame->retcode;
+	__frame->gr8  = sig;
 
 	/* the tracer may want to single-step inside the handler */
 	if (test_thread_flag(TIF_SINGLESTEP))
@@ -341,6 +344,8 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	struct rt_sigframe __user *frame;
 	int rsig;
 
+	set_fs(USER_DS);
+
 	frame = get_sigframe(ka, sizeof(*frame));
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
@@ -394,23 +399,24 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 				   (unsigned long) (frame->retcode + 2));
 	}
 
-	/* Set up registers for signal handler */
-	__frame->sp  = (unsigned long) frame;
-	__frame->lr   = (unsigned long) &frame->retcode;
-	__frame->gr8 = sig;
-	__frame->gr9 = (unsigned long) &frame->info;
-
 	if (current->personality & FDPIC_FUNCPTRS) {
 		struct fdpic_func_descriptor __user *funcptr =
 			(struct fdpic_func_descriptor __user *) ka->sa.sa_handler;
-		__get_user(__frame->pc, &funcptr->text);
-		__get_user(__frame->gr15, &funcptr->GOT);
+		struct fdpic_func_descriptor desc;
+		if (copy_from_user(&desc, funcptr, sizeof(desc)))
+			goto give_sigsegv;
+		__frame->pc = desc.text;
+		__frame->gr15 = desc.GOT;
 	} else {
 		__frame->pc   = (unsigned long) ka->sa.sa_handler;
 		__frame->gr15 = 0;
 	}
 
-	set_fs(USER_DS);
+	/* Set up registers for signal handler */
+	__frame->sp  = (unsigned long) frame;
+	__frame->lr   = (unsigned long) &frame->retcode;
+	__frame->gr8 = sig;
+	__frame->gr9 = (unsigned long) &frame->info;
 
 	/* the tracer may want to single-step inside the handler */
 	if (test_thread_flag(TIF_SINGLESTEP))
-- 
1.5.6.5


