Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758086Ab2EIGLx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:11:53 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39075 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756527Ab2EIFxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:31 -0400
Message-Id: <20120509055052.184084951@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:53:13 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Oleg Nesterov <oleg@redhat.com>
Subject: [ 164/167] [PATCH] exit_signal: simplify the "we have changed execution domain"
 logic
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit e636825346b36a07ccfc8e30946d52855e21f681 upstream.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/exec.c     |    3 +++
 kernel/exit.c |    7 +------
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index b0695a9..1e94d22 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -977,6 +977,9 @@ static int de_thread(struct task_struct *tsk)
 	sig->notify_count = 0;
 
 no_thread_group:
+	/* we have changed execution domain */
+	tsk->exit_signal = SIGCHLD;
+
 	if (current->mm)
 		setmax_mm_hiwater_rss(&sig->maxrss, current->mm);
 
diff --git a/kernel/exit.c b/kernel/exit.c
index 752d2c0..51ac4ce 100644
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
1.7.10



