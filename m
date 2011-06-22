Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758915Ab1FVVLF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 17:11:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48114 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758471Ab1FVVLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 17:11:03 -0400
Date: Wed, 22 Jun 2011 23:08:53 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, hch@infradead.org
Subject: [PATCH 3/8] __ptrace_detach: avoid task_detached(), check
	do_notify_parent()
Message-ID: <20110622210853.GD20549@redhat.com>
References: <1308322240-8247-1-git-send-email-tj@kernel.org> <1308322240-8247-7-git-send-email-tj@kernel.org> <20110622210757.GA20549@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110622210757.GA20549@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__ptrace_detach() relies on the current obscure behaviour of
do_notify_parent(tsk) which changes tsk->exit_signal if this child
should be silently reaped. That is why we check task_detached(), it
is true if the task is sub-thread, or it is the group_leader but
its exit_signal was changed by do_notify_parent().

This is confusing, change the code to rely on !thread_group_leader()
or the value returned by do_notify_parent().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/ptrace.c |   33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

--- ptrace/kernel/ptrace.c~3_detach_ck_notify	2011-06-22 22:47:03.000000000 +0200
+++ ptrace/kernel/ptrace.c	2011-06-22 22:47:11.000000000 +0200
@@ -370,25 +370,28 @@ static int ignoring_children(struct sigh
  */
 static bool __ptrace_detach(struct task_struct *tracer, struct task_struct *p)
 {
+	bool dead;
+
 	__ptrace_unlink(p);
 
-	if (p->exit_state == EXIT_ZOMBIE) {
-		if (!task_detached(p) && thread_group_empty(p)) {
-			if (!same_thread_group(p->real_parent, tracer))
-				do_notify_parent(p, p->exit_signal);
-			else if (ignoring_children(tracer->sighand)) {
-				__wake_up_parent(p, tracer);
-				p->exit_signal = -1;
-			}
-		}
-		if (task_detached(p)) {
-			/* Mark it as in the process of being reaped. */
-			p->exit_state = EXIT_DEAD;
-			return true;
+	if (p->exit_state != EXIT_ZOMBIE)
+		return false;
+
+	dead = !thread_group_leader(p);
+
+	if (!dead && thread_group_empty(p)) {
+		if (!same_thread_group(p->real_parent, tracer))
+			dead = do_notify_parent(p, p->exit_signal);
+		else if (ignoring_children(tracer->sighand)) {
+			__wake_up_parent(p, tracer);
+			p->exit_signal = -1;
+			dead = true;
 		}
 	}
-
-	return false;
+	/* Mark it as in the process of being reaped. */
+	if (dead)
+		p->exit_state = EXIT_DEAD;
+	return dead;
 }
 
 static int ptrace_detach(struct task_struct *child, unsigned int data)

