Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab1CaMkY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 08:40:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:56723 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795Ab1CaMkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 08:40:23 -0400
Date: Thu, 31 Mar 2011 12:39:47 GMT
From: tip-bot for Dario Faggioli <raistlin@linux.it>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, raistlin@linux.it, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, raistlin@linux.it,
        mingo@elte.hu
In-Reply-To: <1300971618.3960.82.camel@Palantir>
References: <1300971618.3960.82.camel@Palantir>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Leave sched_setscheduler() earlier if possible, do not disturb SCHED_FIFO tasks
Message-ID: <tip-a51e91981870d013fcfcc08b0117997edbcbc7a7@git.kernel.org>
Git-Commit-ID: a51e91981870d013fcfcc08b0117997edbcbc7a7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 31 Mar 2011 12:39:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a51e91981870d013fcfcc08b0117997edbcbc7a7
Gitweb:     http://git.kernel.org/tip/a51e91981870d013fcfcc08b0117997edbcbc7a7
Author:     Dario Faggioli <raistlin@linux.it>
AuthorDate: Thu, 24 Mar 2011 14:00:18 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 31 Mar 2011 13:00:34 +0200

sched: Leave sched_setscheduler() earlier if possible, do not disturb SCHED_FIFO tasks

sched_setscheduler() (in sched.c) is called in order of changing the
scheduling policy and/or the real-time priority of a task. Thus,
if we find out that neither of those are actually being modified, it
is possible to return earlier and save the overhead of a full
deactivate+activate cycle of the task in question.

Beside that, if we have more than one SCHED_FIFO task with the same
priority on the same rq (which means they share the same priority queue)
having one of them changing its position in the priority queue because of
a sched_setscheduler (as it happens by means of the deactivate+activate)
that does not actually change the priority violates POSIX which states,
for SCHED_FIFO:

  "If a thread whose policy or priority has been modified by
   pthread_setschedprio() is a running thread or is runnable, the effect on
   its position in the thread list depends on the direction of the
   modification, as follows: a. <...> b. If the priority is unchanged, the
   thread does not change position in the thread list. c. <...>"

     http://pubs.opengroup.org/onlinepubs/009695399/functions/xsh_chap02_08.html

 (ed: And the POSIX specification here does, briefly and somewhat unexpectedly,
      match what common sense tells us as well. )

Signed-off-by: Dario Faggioli <raistlin@linux.it>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1300971618.3960.82.camel@Palantir>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index f592ce6..a884551 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5011,6 +5011,17 @@ recheck:
 		return -EINVAL;
 	}
 
+	/*
+	 * If not changing anything there's no need to proceed further:
+	 */
+	if (unlikely(policy == p->policy && (!rt_policy(policy) ||
+			param->sched_priority == p->rt_priority))) {
+
+		__task_rq_unlock(rq);
+		raw_spin_unlock_irqrestore(&p->pi_lock, flags);
+		return 0;
+	}
+
 #ifdef CONFIG_RT_GROUP_SCHED
 	if (user) {
 		/*
