Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758979Ab1FVVLv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 17:11:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19169 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758900Ab1FVVLr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 17:11:47 -0400
Date: Wed, 22 Jun 2011 23:09:54 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, hch@infradead.org
Subject: [PATCH 6/8] kill task_detached()
Message-ID: <20110622210954.GG20549@redhat.com>
References: <1308322240-8247-1-git-send-email-tj@kernel.org> <1308322240-8247-7-git-send-email-tj@kernel.org> <20110622210757.GA20549@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110622210757.GA20549@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Upadate the last user of task_detached(), wait_task_zombie(), to
use thread_group_leader() and kill task_detached().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/sched.h |    5 -----
 kernel/exit.c         |    5 ++---
 2 files changed, 2 insertions(+), 8 deletions(-)

--- ptrace/include/linux/sched.h~6_kill_task_detached	2011-06-22 22:47:12.000000000 +0200
+++ ptrace/include/linux/sched.h	2011-06-22 22:47:13.000000000 +0200
@@ -2319,11 +2319,6 @@ static inline int thread_group_empty(str
 #define delay_group_leader(p) \
 		(thread_group_leader(p) && !thread_group_empty(p))
 
-static inline int task_detached(struct task_struct *p)
-{
-	return p->exit_signal == -1;
-}
-
 /*
  * Protects ->fs, ->files, ->mm, ->group_info, ->comm, keyring
  * subscriptions and synchronises with wait4().  Also used in procfs.  Also
--- ptrace/kernel/exit.c~6_kill_task_detached	2011-06-22 22:47:12.000000000 +0200
+++ ptrace/kernel/exit.c	2011-06-22 22:47:13.000000000 +0200
@@ -189,7 +189,6 @@ repeat:
 	zap_leader = 0;
 	leader = p->group_leader;
 	if (leader != p && thread_group_empty(leader) && leader->exit_state == EXIT_ZOMBIE) {
-		BUG_ON(task_detached(leader));
 		/*
 		 * If we were the last child thread and the leader has
 		 * exited already, and the leader's parent ignores SIGCHLD,
@@ -1228,9 +1227,9 @@ static int wait_task_zombie(struct wait_
 	traced = ptrace_reparented(p);
 	/*
 	 * It can be ptraced but not reparented, check
-	 * !task_detached() to filter out sub-threads.
+	 * thread_group_leader() to filter out sub-threads.
 	 */
-	if (likely(!traced) && likely(!task_detached(p))) {
+	if (likely(!traced) && thread_group_leader(p)) {
 		struct signal_struct *psig;
 		struct signal_struct *sig;
 		unsigned long maxrss;

