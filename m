Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934041Ab1ESSia (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:38:30 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:33193 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933868Ab1ESScY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:32:24 -0400
X-Sasl-enc: 2Kp8wcrg3Kgmiz1ritehisBhzt1p/XzWaL6FJhHpM7D6 1305829943
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May 19 11:31:25 2011
Message-Id: <20110519183125.858909473@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 19 May 2011 11:30:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Will Deacon <will.deacon@arm.com>, Prasad <prasad@linux.vnet.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: [03/24] x86, hw_breakpoints: Fix racy access to ptrace breakpoints
In-Reply-To: <20110519182446.GA23751@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 2650
Lines: 111

From: Frederic Weisbecker <fweisbec@gmail.com>

commit 87dc669ba25777b67796d7262c569429e58b1ed4 upstream.

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
Link: http://lkml.kernel.org/r/1302284067-7860-3-git-send-email-fweisbec@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/ptrace.c |   36 ++++++++++++++++++++++++++----------
 1 file changed, 26 insertions(+), 10 deletions(-)

--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -635,6 +635,9 @@ static int ptrace_write_dr7(struct task_
 	unsigned len, type;
 	struct perf_event *bp;
 
+	if (ptrace_get_breakpoints(tsk) < 0)
+		return -ESRCH;
+
 	data &= ~DR_CONTROL_RESERVED;
 	old_dr7 = ptrace_get_dr7(thread->ptrace_bps);
 restore:
@@ -682,6 +685,9 @@ restore:
 		}
 		goto restore;
 	}
+
+	ptrace_put_breakpoints(tsk);
+
 	return ((orig_ret < 0) ? orig_ret : rc);
 }
 
@@ -695,10 +701,17 @@ static unsigned long ptrace_get_debugreg
 
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
@@ -713,6 +726,10 @@ static int ptrace_set_breakpoint_addr(st
 	struct perf_event *bp;
 	struct thread_struct *t = &tsk->thread;
 	struct perf_event_attr attr;
+	int err = 0;
+
+	if (ptrace_get_breakpoints(tsk) < 0)
+		return -ESRCH;
 
 	if (!t->ptrace_bps[nr]) {
 		hw_breakpoint_init(&attr);
@@ -736,24 +753,23 @@ static int ptrace_set_breakpoint_addr(st
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


