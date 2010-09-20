Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570Ab0ITONW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 10:13:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35485 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756435Ab0ITONU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 10:13:20 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/5] frv: fix address verification holes in
	setup_frame/setup_rt_frame
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        David Howells <dhowells@redhat.com>
Date: Mon, 20 Sep 2010 15:13:09 +0100
Message-ID: <20100920141309.11066.27927.stgit@warthog.procyon.org.uk>
In-Reply-To: <20100920141304.11066.51314.stgit@warthog.procyon.org.uk>
References: <20100920141304.11066.51314.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ftp.linux.org.uk>

a) sa_handler might be maliciously set to point to kernel memory;
blindly dereferencing it in FDPIC case is a Bad Idea(tm).

b) I'm not sure you need that set_fs(USER_DS) there at all, but
if you do, you'd better do it *before* checking the frame you've
decided to use with access_ok(), lest sigaltstack() becomes a
convenient roothole.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/frv/kernel/signal.c |   38 ++++++++++++++++++++++----------------
 1 files changed, 22 insertions(+), 16 deletions(-)


diff --git a/arch/frv/kernel/signal.c b/arch/frv/kernel/signal.c
index 7fc2961..5fb2d06 100644
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
+	/* Set up registers for the signal handler */
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
@@ -395,22 +400,23 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	}
 
 	/* Set up registers for signal handler */
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
+	__frame->sp  = (unsigned long) frame;
+	__frame->lr  = (unsigned long) &frame->retcode;
+	__frame->gr8 = sig;
+	__frame->gr9 = (unsigned long) &frame->info;
 
 	/* the tracer may want to single-step inside the handler */
 	if (test_thread_flag(TIF_SINGLESTEP))

