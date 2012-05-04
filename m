Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564Ab2EDUrG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 16:47:06 -0400
Received: from mail-pz0-f45.google.com ([209.85.210.45]:45099 "EHLO
	mail-pz0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932434Ab2EDUq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:46:59 -0400
Message-Id: <20120504204229.329386059@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 04 May 2012 13:43:22 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Oleg Nesterov <oleg@redhat.com>
Subject: [ 58/75] exit_signal: fix the "parent has changed security domain" logic
In-Reply-To: <20120504204258.GA12552@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit b6e238dceed36891cc633167afe7151f1f3d83c5 upstream.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/exit.c   |   14 --------------
 kernel/signal.c |    9 +++++++++
 2 files changed, 9 insertions(+), 14 deletions(-)

--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -818,20 +818,6 @@ static void exit_notify(struct task_stru
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
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1642,6 +1642,15 @@ bool do_notify_parent(struct task_struct
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


