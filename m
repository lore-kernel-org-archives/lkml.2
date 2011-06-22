Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759005Ab1FVVMY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 17:12:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25755 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758941Ab1FVVMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 17:12:21 -0400
Date: Wed, 22 Jun 2011 23:10:11 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, hch@infradead.org
Subject: [PATCH 7/8] do not change dead_task->exit_signal
Message-ID: <20110622211011.GH20549@redhat.com>
References: <1308322240-8247-1-git-send-email-tj@kernel.org> <1308322240-8247-7-git-send-email-tj@kernel.org> <20110622210757.GA20549@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110622210757.GA20549@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__ptrace_detach() and do_notify_parent() set task->exit_signal = -1
to mark the task dead. This is no longer needed, nobody checks
exit_signal to detect the EXIT_DEAD task.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/ptrace.c |    1 -
 kernel/signal.c |    1 -
 2 files changed, 2 deletions(-)

--- ptrace/kernel/ptrace.c~7_dont_change_exit_signal	2011-06-22 22:47:11.000000000 +0200
+++ ptrace/kernel/ptrace.c	2011-06-22 22:47:14.000000000 +0200
@@ -384,7 +384,6 @@ static bool __ptrace_detach(struct task_
 			dead = do_notify_parent(p, p->exit_signal);
 		else if (ignoring_children(tracer->sighand)) {
 			__wake_up_parent(p, tracer);
-			p->exit_signal = -1;
 			dead = true;
 		}
 	}
--- ptrace/kernel/signal.c~7_dont_change_exit_signal	2011-06-22 22:47:11.000000000 +0200
+++ ptrace/kernel/signal.c	2011-06-22 22:47:14.000000000 +0200
@@ -1650,7 +1650,6 @@ bool do_notify_parent(struct task_struct
 		 * it, just use SIG_IGN instead).
 		 */
 		autoreap = true;
-		tsk->exit_signal = -1;
 		if (psig->action[SIGCHLD-1].sa.sa_handler == SIG_IGN)
 			sig = 0;
 	}

