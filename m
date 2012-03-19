Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758194Ab2CSQLk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 12:11:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758042Ab2CSQLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 12:11:38 -0400
Date: Mon, 19 Mar 2012 17:03:41 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        James Morris <james.l.morris@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@elte.hu>,
        Roland McGrath <roland@hack.frob.com>,
        Solar Designer <solar@openwall.com>,
        Djalal Harouni <tixxdz@opendz.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] exit_signal: fix the "parent has changed security
	domain" logic
Message-ID: <20120319160341.GC4910@redhat.com>
References: <1331421919-15499-1-git-send-email-tixxdz@opendz.org> <1331421919-15499-2-git-send-email-tixxdz@opendz.org> <20120311172512.GA2729@redhat.com> <20120311174953.GB2729@redhat.com> <CA+55aFx43nZmhRg5Qv5x-4BdgcM-y80ECrgC8mCWc0RqU+_8rQ@mail.gmail.com> <20120314185510.GA14172@redhat.com> <20120314190939.GC14172@redhat.com> <20120319160249.GA4910@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120319160249.GA4910@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

exit_notify() changes ->exit_signal if the parent already did exec.
This doesn't really work, we are not going to send the signal now
if there is another live thread or the exiting task is traced. The
parent can exec before the last dies or the tracer detaches.

Move this check into do_notify_parent() which actually sends the
signal.

The user-visible change is that we do not change ->exit_signal,
and thus the exiting task is still "clone children" for
do_wait()->eligible_child(__WCLONE). Hopefully this is fine, the
current logic is racy anyway.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/exit.c   |   14 --------------
 kernel/signal.c |    9 +++++++++
 2 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 522c1aa..bd9f4c9 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -818,20 +818,6 @@ static void exit_notify(struct task_struct *tsk, int group_dead)
 	if (group_dead)
 		kill_orphaned_pgrp(tsk->group_leader, NULL);
 
-	/* Let father know we died
-	 *
-	 * Thread signals are configurable, but you aren't going to use
-	 * that to send signals to arbitrary processes.
-	 * That stops right now.
-	 *
-	 * If the parent exec id doesn't match the exec id we saved
-	 * when we started then we know the parent has changed security
-	 * domain.
-	 */
-	if (thread_group_leader(tsk) && tsk->exit_signal != SIGCHLD &&
-	    tsk->parent_exec_id != tsk->real_parent->self_exec_id)
-		tsk->exit_signal = SIGCHLD;
-
 	if (unlikely(tsk->ptrace)) {
 		int sig = thread_group_leader(tsk) &&
 				thread_group_empty(tsk) &&
diff --git a/kernel/signal.c b/kernel/signal.c
index c73c428..b09cf3b 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1642,6 +1642,15 @@ bool do_notify_parent(struct task_struct *tsk, int sig)
 	BUG_ON(!tsk->ptrace &&
 	       (tsk->group_leader != tsk || !thread_group_empty(tsk)));
 
+	if (sig != SIGCHLD) {
+		/*
+		 * This is only possible if parent == real_parent.
+		 * Check if it has changed security domain.
+		 */
+		if (tsk->parent_exec_id != tsk->parent->self_exec_id)
+			sig = SIGCHLD;
+	}
+
 	info.si_signo = sig;
 	info.si_errno = 0;
 	/*
-- 
1.5.5.1


