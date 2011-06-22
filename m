Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759016Ab1FVVMa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 17:12:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759009Ab1FVVM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 17:12:28 -0400
Date: Wed, 22 Jun 2011 23:10:26 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, hch@infradead.org
Subject: [PATCH 8/8] redefine thread_group_leader() as exit_signal >= 0
Message-ID: <20110622211026.GI20549@redhat.com>
References: <1308322240-8247-1-git-send-email-tj@kernel.org> <1308322240-8247-7-git-send-email-tj@kernel.org> <20110622210757.GA20549@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110622210757.GA20549@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change de_thread() to set old_leader->exit_signal = -1. This is
good for the consistency, it is no longer the leader and all
sub-threads have exit_signal = -1 set by copy_process(CLONE_THREAD).

And this allows us to micro-optimize thread_group_leader(), it can
simply check exit_signal >= 0. This also makes sense because we
should move ->group_leader from task_struct to signal_struct.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/sched.h |    6 ++++--
 fs/exec.c             |    1 +
 2 files changed, 5 insertions(+), 2 deletions(-)

--- ptrace/include/linux/sched.h~8_thread_group_leader	2011-06-22 22:47:13.000000000 +0200
+++ ptrace/include/linux/sched.h	2011-06-22 22:47:14.000000000 +0200
@@ -2285,8 +2285,10 @@ static inline int get_nr_threads(struct 
 	return tsk->signal->nr_threads;
 }
 
-/* de_thread depends on thread_group_leader not being a pid based check */
-#define thread_group_leader(p)	(p == p->group_leader)
+static inline bool thread_group_leader(struct task_struct *p)
+{
+	return p->exit_signal >= 0;
+}
 
 /* Do to the insanities of de_thread it is possible for a process
  * to have the pid of the thread group leader without actually being
--- ptrace/fs/exec.c~8_thread_group_leader	2011-06-22 22:47:00.000000000 +0200
+++ ptrace/fs/exec.c	2011-06-22 22:47:14.000000000 +0200
@@ -963,6 +963,7 @@ static int de_thread(struct task_struct 
 		leader->group_leader = tsk;
 
 		tsk->exit_signal = SIGCHLD;
+		leader->exit_signal = -1;
 
 		BUG_ON(leader->exit_state != EXIT_ZOMBIE);
 		leader->exit_state = EXIT_DEAD;

