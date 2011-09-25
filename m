Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751411Ab1IYRt7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 13:49:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35486 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995Ab1IYRt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 13:49:58 -0400
Date: Sun, 25 Sep 2011 19:46:22 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matt Fleming <matt@console-pimps.org>, Tejun Heo <htejun@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH for 3.1] ptrace: PTRACE_LISTEN forgets to unlock ->siglock
Message-ID: <20110925174622.GA18509@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If PTRACE_LISTEN fails after lock_task_sighand() it doesn't drop ->siglock.

Reported-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/ptrace.c |   23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

--- 3.1/kernel/ptrace.c~1_PTRACE_LISTEN_siglock	2011-09-25 19:14:32.000000000 +0200
+++ 3.1/kernel/ptrace.c	2011-09-25 19:40:57.000000000 +0200
@@ -744,20 +744,17 @@ int ptrace_request(struct task_struct *c
 			break;
 
 		si = child->last_siginfo;
-		if (unlikely(!si || si->si_code >> 8 != PTRACE_EVENT_STOP))
-			break;
-
-		child->jobctl |= JOBCTL_LISTENING;
-
-		/*
-		 * If NOTIFY is set, it means event happened between start
-		 * of this trap and now.  Trigger re-trap immediately.
-		 */
-		if (child->jobctl & JOBCTL_TRAP_NOTIFY)
-			signal_wake_up(child, true);
-
+		if (likely(si && (si->si_code >> 8) == PTRACE_EVENT_STOP)) {
+			child->jobctl |= JOBCTL_LISTENING;
+			/*
+			 * If NOTIFY is set, it means event happened between
+			 * start of this trap and now.  Trigger re-trap.
+			 */
+			if (child->jobctl & JOBCTL_TRAP_NOTIFY)
+				signal_wake_up(child, true);
+			ret = 0;
+		}
 		unlock_task_sighand(child, &flags);
-		ret = 0;
 		break;
 
 	case PTRACE_DETACH:	 /* detach a process that was attached. */

