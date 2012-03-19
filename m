Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161485Ab2CSQLU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 12:11:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6259 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758042Ab2CSQLQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 12:11:16 -0400
Date: Mon, 19 Mar 2012 17:03:22 +0100
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
Subject: [PATCH 1/3] exit_signal: simplify the "we have changed execution
	domain" logic
Message-ID: <20120319160322.GB4910@redhat.com>
References: <1331421919-15499-1-git-send-email-tixxdz@opendz.org> <1331421919-15499-2-git-send-email-tixxdz@opendz.org> <20120311172512.GA2729@redhat.com> <20120311174953.GB2729@redhat.com> <CA+55aFx43nZmhRg5Qv5x-4BdgcM-y80ECrgC8mCWc0RqU+_8rQ@mail.gmail.com> <20120314185510.GA14172@redhat.com> <20120314190939.GC14172@redhat.com> <20120319160249.GA4910@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120319160249.GA4910@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

exit_notify() checks "tsk->self_exec_id != tsk->parent_exec_id"
to handle the "we have changed execution domain" case.

We can change do_thread() to always set ->exit_signal = SIGCHLD
and remove this check to simplify the code.

We could change setup_new_exec() instead, this looks more logical
because it increments ->self_exec_id. But note that de_thread()
already resets ->exit_signal if it changes the leader, let's keep
both changes close to each other.

Note that we change ->exit_signal lockless, this changes the rules.
Thereafter ->exit_signal is not stable under tasklist but this is
fine, the only possible change is OLDSIG -> SIGCHLD. This can race
with eligible_child() but the race is harmless. We can race with
reparent_leader() which changes our ->exit_signal in parallel, but
it does the same change to SIGCHLD.

The noticeable user-visible change is that the execing task is not
"visible" to do_wait()->eligible_child(__WCLONE) right after exec.
To me this looks more logical, and this is consistent with mt case.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/exec.c     |    3 +++
 kernel/exit.c |    7 +------
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 92ce83a..218d074 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -975,6 +975,9 @@ static int de_thread(struct task_struct *tsk)
 	sig->notify_count = 0;
 
 no_thread_group:
+	/* we have changed execution domain */
+	tsk->exit_signal = SIGCHLD;
+
 	if (current->mm)
 		setmax_mm_hiwater_rss(&sig->maxrss, current->mm);
 
diff --git a/kernel/exit.c b/kernel/exit.c
index 7b36288..522c1aa 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -827,14 +827,9 @@ static void exit_notify(struct task_struct *tsk, int group_dead)
 	 * If the parent exec id doesn't match the exec id we saved
 	 * when we started then we know the parent has changed security
 	 * domain.
-	 *
-	 * If our self_exec id doesn't match our parent_exec_id then
-	 * we have changed execution domain as these two values started
-	 * the same after a fork.
 	 */
 	if (thread_group_leader(tsk) && tsk->exit_signal != SIGCHLD &&
-	    (tsk->parent_exec_id != tsk->real_parent->self_exec_id ||
-	     tsk->self_exec_id != tsk->parent_exec_id))
+	    tsk->parent_exec_id != tsk->real_parent->self_exec_id)
 		tsk->exit_signal = SIGCHLD;
 
 	if (unlikely(tsk->ptrace)) {
-- 
1.5.5.1


