Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760215Ab0FRKVd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 06:21:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:55191 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757833Ab0FRKVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 06:21:31 -0400
Date: Fri, 18 Jun 2010 10:21:03 GMT
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, oleg@redhat.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, oleg@redhat.com,
       mingo@elte.hu
In-Reply-To: <20100611180446.GA13025@redhat.com>
References: <20100611180446.GA13025@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix the racy usage of thread_group_cputimer() in fastpath_timer_check()
Message-ID: <tip-8d1f431cbec115a780cd551ab1b4955c125f8d31@git.kernel.org>
Git-Commit-ID: 8d1f431cbec115a780cd551ab1b4955c125f8d31
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 18 Jun 2010 10:21:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8d1f431cbec115a780cd551ab1b4955c125f8d31
Gitweb:     http://git.kernel.org/tip/8d1f431cbec115a780cd551ab1b4955c125f8d31
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Fri, 11 Jun 2010 20:04:46 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 18 Jun 2010 10:46:57 +0200

sched: Fix the racy usage of thread_group_cputimer() in fastpath_timer_check()

fastpath_timer_check()->thread_group_cputimer() is racy and
unneeded.

It is racy because another thread can clear ->running before
thread_group_cputimer() takes cputimer->lock. In this case
thread_group_cputimer() will set ->running = true again and call
thread_group_cputime(). But since we do not hold tasklist or
siglock, we can race with fork/exit and copy the wrong results
into cputimer->cputime.

It is unneeded because if ->running == true we can just use
the numbers in cputimer->cputime we already have.

Change fastpath_timer_check() to copy cputimer->cputime into
the local variable under cputimer->lock. We do not re-check
->running under cputimer->lock, run_posix_cpu_timers() does
this check later.

Note: we can add more optimizations on top of this change.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20100611180446.GA13025@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/posix-cpu-timers.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index d5dbef5..f66bdd3 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -1287,7 +1287,10 @@ static inline int fastpath_timer_check(struct task_struct *tsk)
 	if (sig->cputimer.running) {
 		struct task_cputime group_sample;
 
-		thread_group_cputimer(tsk, &group_sample);
+		spin_lock(&sig->cputimer.lock);
+		group_sample = sig->cputimer.cputime;
+		spin_unlock(&sig->cputimer.lock);
+
 		if (task_cputime_expired(&group_sample, &sig->cputime_expires))
 			return 1;
 	}
