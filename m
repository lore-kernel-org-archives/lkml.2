Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932600Ab1DYU04 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:26:56 -0400
Received: from 1wt.eu ([62.212.114.60]:34654 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932308Ab1DYU0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:26:32 -0400
Message-Id: <20110425200233.861773910@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:02:52 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Tejun Heo <tj@kernel.org>, Roland McGrath <roland@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 020/173] ptrace: use safer wake up on ptrace_detach()
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 01e05e9a90b8f4c3997ae0537e87720eb475e532 upstream.

The wake_up_process() call in ptrace_detach() is spurious and not
interlocked with the tracee state.  IOW, the tracee could be running or
sleeping in any place in the kernel by the time wake_up_process() is
called.  This can lead to the tracee waking up unexpectedly which can be
dangerous.

The wake_up is spurious and should be removed but for now reduce its
toxicity by only waking up if the tracee is in TRACED or STOPPED state.

This bug can possibly be used as an attack vector.  I don't think it
will take too much effort to come up with an attack which triggers oops
somewhere.  Most sleeps are wrapped in condition test loops and should
be safe but we have quite a number of places where sleep and wakeup
conditions are expected to be interlocked.  Although the window of
opportunity is tiny, ptrace can be used by non-privileged users and with
some loading the window can definitely be extended and exploited.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Roland McGrath <roland@redhat.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/ptrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: longterm-2.6.27/kernel/ptrace.c
===================================================================
--- longterm-2.6.27.orig/kernel/ptrace.c	2011-01-23 10:52:37.000000000 +0100
+++ longterm-2.6.27/kernel/ptrace.c	2011-04-25 12:29:36.100278176 +0200
@@ -213,7 +213,7 @@
 	__ptrace_unlink(child);
 	/* .. and wake it up. */
 	if (child->exit_state != EXIT_ZOMBIE)
-		wake_up_process(child);
+		wake_up_state(child, TASK_TRACED | TASK_STOPPED);
 }
 
 int ptrace_detach(struct task_struct *child, unsigned int data)


