Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758893Ab1FVVKQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 17:10:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758471Ab1FVVKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 17:10:15 -0400
Date: Wed, 22 Jun 2011 23:07:57 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, hch@infradead.org
Subject: [PATCH 0/8] kill task_detached() (Was: ptrace: kill detah
	tracehooks)
Message-ID: <20110622210757.GA20549@redhat.com>
References: <1308322240-8247-1-git-send-email-tj@kernel.org> <1308322240-8247-7-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308322240-8247-7-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove tracehook_notify_death(), and kill task_detached() logic.

IMHO, task_detached() is very strange and confusing. Sometimes it used
instead of !thread_group_leader() when the task is live. Sometimes it
is used to detect the EXIT_DEAD tasks (reparent_leader). Sometimes it
used after do_notify_parent() which sets ->exit_signal = -1 to signal
the caller it should set EXIT_DEAD.

Basically, this series does:

	- s/task_detached/thread_group_leader/ when the caller need
	  to know if it is the group_leader or not

	- s/task_detached/EXIT_DEAD/ when the caller needs to filter
	  out the EXIT_DEAD tasks

	- changes do_notify_parent() to return a boolean and converts
	  the callers from

	  	do_notify_parent(p);
	  	if (task_detached(p))
	  		// aha, do_notify_parent() changed ->exit_signal
	  		release_task(p)

	  to
		if (do_notify_parent(p))
			release_task(p)

	- kills the now unused task_detached()

	- makes task->exit_signal "const" and redefines thread_group_leader()
	  for micro-optimization.


 fs/exec.c                 |    1 +
 include/linux/sched.h     |   15 ++++-------
 include/linux/tracehook.h |   34 --------------------------
 kernel/exit.c             |   58 +++++++++++++++++++-------------------------
 kernel/ptrace.c           |   32 +++++++++++++-----------
 kernel/signal.c           |   16 ++++++------
 6 files changed, 57 insertions(+), 99 deletions(-)

Oleg.

