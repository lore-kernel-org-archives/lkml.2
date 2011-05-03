Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564Ab1ECNZl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 09:25:41 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44586 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab1ECNZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 09:25:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=RtUYpSLkYZEKNVGT3nxTIh0Ml/O/Y/SkSkjfQMOy4sX1Xvf5QyFjJxfL/glFNssf/I
         GG31t6DcCF/b0MFkgzl68ckLVvBTskYs8iPYmDXXEPl8yk7aZNkmTRs/1rLunyHg+zex
         0SK31SZz9yQqXOJMumrcPbq/IirXbZtA6246Y=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Will Deacon <will.deacon@arm.com>, Prasad <prasad@linux.vnet.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>, "v2.6.33.." <stable@kernel.org>
Subject: [PATCH 2/5] x86, hw_breakpoints: Fix racy access to ptrace breakpoints
Date: Tue,  3 May 2011 15:25:21 +0200
Message-Id: <1304429124-2376-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1304429124-2376-1-git-send-email-fweisbec@gmail.com>
References: <1304429124-2376-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
-- 
1.7.3.2

