Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793Ab1EDU3c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 16:29:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:59507 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755771Ab1EDU3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 16:29:30 -0400
Date: Wed, 4 May 2011 20:28:55 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Message-ID: <tip-87dc669ba25777b67796d7262c569429e58b1ed4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        will.deacon@arm.com, a.p.zijlstra@chello.nl, lethal@linux-sh.org,
        fweisbec@gmail.com, stable@kernel.org, tglx@linutronix.de,
        oleg@redhat.com, prasad@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, will.deacon@arm.com, lethal@linux-sh.org,
        fweisbec@gmail.com, stable@kernel.org, oleg@redhat.com,
        tglx@linutronix.de, mingo@elte.hu, prasad@linux.vnet.ibm.com
In-Reply-To: <1302284067-7860-3-git-send-email-fweisbec@gmail.com>
References: <1302284067-7860-3-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] x86, hw_breakpoints: Fix racy access to ptrace breakpoints
Git-Commit-ID: 87dc669ba25777b67796d7262c569429e58b1ed4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 04 May 2011 20:28:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  87dc669ba25777b67796d7262c569429e58b1ed4
Gitweb:     http://git.kernel.org/tip/87dc669ba25777b67796d7262c569429e58b1ed4
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Fri, 8 Apr 2011 17:29:36 +0200
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Mon, 25 Apr 2011 17:32:40 +0200

x86, hw_breakpoints: Fix racy access to ptrace breakpoints

While the tracer accesses ptrace breakpoints, the child task may
concurrently exit due to a SIGKILL and thus release its breakpoints
at the same time. We can then dereference some freed pointers.

To fix this, hold a reference on the child breakpoints before
manipulating them.

Reported-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Prasad <prasad@linux.vnet.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: v2.6.33.. <stable@kernel.org>
Link: http://lkml.kernel.org/r/1302284067-7860-3-git-send-email-fweisbec@gmail.com
---
 arch/x86/kernel/ptrace.c |   36 ++++++++++++++++++++++++++----------
 1 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 45892dc..f65e5b5 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -608,6 +608,9 @@ static int ptrace_write_dr7(struct task_struct *tsk, unsigned long data)
 	unsigned len, type;
 	struct perf_event *bp;
 
+	if (ptrace_get_breakpoints(tsk) < 0)
+		return -ESRCH;
+
 	data &= ~DR_CONTROL_RESERVED;
 	old_dr7 = ptrace_get_dr7(thread->ptrace_bps);
 restore:
@@ -655,6 +658,9 @@ restore:
 		}
 		goto restore;
 	}
+
+	ptrace_put_breakpoints(tsk);
+
 	return ((orig_ret < 0) ? orig_ret : rc);
 }
 
@@ -668,10 +674,17 @@ static unsigned long ptrace_get_debugreg(struct task_struct *tsk, int n)
 
 	if (n < HBP_NUM) {
 		struct perf_event *bp;
+
+		if (ptrace_get_breakpoints(tsk) < 0)
+			return -ESRCH;
+
 		bp = thread->ptrace_bps[n];
 		if (!bp)
-			return 0;
-		val = bp->hw.info.address;
+			val = 0;
+		else
+			val = bp->hw.info.address;
+
+		ptrace_put_breakpoints(tsk);
 	} else if (n == 6) {
 		val = thread->debugreg6;
 	 } else if (n == 7) {
@@ -686,6 +699,10 @@ static int ptrace_set_breakpoint_addr(struct task_struct *tsk, int nr,
 	struct perf_event *bp;
 	struct thread_struct *t = &tsk->thread;
 	struct perf_event_attr attr;
+	int err = 0;
+
+	if (ptrace_get_breakpoints(tsk) < 0)
+		return -ESRCH;
 
 	if (!t->ptrace_bps[nr]) {
 		ptrace_breakpoint_init(&attr);
@@ -709,24 +726,23 @@ static int ptrace_set_breakpoint_addr(struct task_struct *tsk, int nr,
 		 * writing for the user. And anyway this is the previous
 		 * behaviour.
 		 */
-		if (IS_ERR(bp))
-			return PTR_ERR(bp);
+		if (IS_ERR(bp)) {
+			err = PTR_ERR(bp);
+			goto put;
+		}
 
 		t->ptrace_bps[nr] = bp;
 	} else {
-		int err;
-
 		bp = t->ptrace_bps[nr];
 
 		attr = bp->attr;
 		attr.bp_addr = addr;
 		err = modify_user_hw_breakpoint(bp, &attr);
-		if (err)
-			return err;
 	}
 
-
-	return 0;
+put:
+	ptrace_put_breakpoints(tsk);
+	return err;
 }
 
 /*
