Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758999Ab1FVVMA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 17:12:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64842 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758969Ab1FVVLu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 17:11:50 -0400
Date: Wed, 22 Jun 2011 23:09:39 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, hch@infradead.org
Subject: [PATCH 5/8] reparent_leader: check EXIT_DEAD instead of
	task_detached()
Message-ID: <20110622210939.GF20549@redhat.com>
References: <1308322240-8247-1-git-send-email-tj@kernel.org> <1308322240-8247-7-git-send-email-tj@kernel.org> <20110622210757.GA20549@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110622210757.GA20549@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change reparent_leader() to check ->exit_state instead of ->exit_signal,
this matches the similar EXIT_DEAD check in wait_consider_task() and
allows us to cleanup the do_notify_parent/task_detached logic.

task_detached() was really needed during reparenting before 9cd80bbb
"do_wait() optimization: do not place sub-threads on ->children list"
to filter out the sub-threads. After this change task_detached(p) can
only be true if p is the dead group_leader and its parent ignores
SIGCHLD, in this case the caller of do_notify_parent() is going to
reap this task and it should set EXIT_DEAD.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/exit.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- ptrace/kernel/exit.c~5_reparent_leader_ck_exit_dead	2011-06-22 22:47:12.000000000 +0200
+++ ptrace/kernel/exit.c	2011-06-22 22:47:12.000000000 +0200
@@ -741,7 +741,7 @@ static void reparent_leader(struct task_
 {
 	list_move_tail(&p->sibling, &p->real_parent->children);
 
-	if (task_detached(p))
+	if (p->exit_state == EXIT_DEAD)
 		return;
 	/*
 	 * If this is a threaded reparent there is no need to

