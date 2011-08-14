Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab1HNP7C (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 11:59:02 -0400
Received: from hera.kernel.org ([140.211.167.34]:51208 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517Ab1HNP67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 11:58:59 -0400
Date: Sun, 14 Aug 2011 15:58:42 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
Message-ID: <tip-c350a04efd1c89cd256b2abc8f07a21d0d53ff24@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1311779695.8691.2.camel@marge.simson.net>
References: <1311779695.8691.2.camel@marge.simson.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: fix broken SCHED_RESET_ON_FORK handling
Git-Commit-ID: c350a04efd1c89cd256b2abc8f07a21d0d53ff24
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 14 Aug 2011 15:58:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c350a04efd1c89cd256b2abc8f07a21d0d53ff24
Gitweb:     http://git.kernel.org/tip/c350a04efd1c89cd256b2abc8f07a21d0d53ff24
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Wed, 27 Jul 2011 17:14:55 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 14 Aug 2011 12:00:43 +0200

sched: fix broken SCHED_RESET_ON_FORK handling

Setting child->prio = current->normal_prio _after_ SCHED_RESET_ON_FORK has
been handled for an RT parent gives birth to a deranged mutant child with
non-RT policy, but RT prio and sched_class.

Move PI leakage protection up, always set priorities and weight, and if the
child is leaving RT class, reset rt_priority to the proper value.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1311779695.8691.2.camel@marge.simson.net
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   25 ++++++++++++-------------
 1 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index b1e8f0e..cf427bb 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2844,19 +2844,23 @@ void sched_fork(struct task_struct *p)
 	p->state = TASK_RUNNING;
 
 	/*
+	 * Make sure we do not leak PI boosting priority to the child.
+	 */
+	p->prio = current->normal_prio;
+
+	/*
 	 * Revert to default priority/policy on fork if requested.
 	 */
 	if (unlikely(p->sched_reset_on_fork)) {
-		if (p->policy == SCHED_FIFO || p->policy == SCHED_RR) {
+		if (task_has_rt_policy(p)) {
 			p->policy = SCHED_NORMAL;
-			p->normal_prio = p->static_prio;
-		}
-
-		if (PRIO_TO_NICE(p->static_prio) < 0) {
 			p->static_prio = NICE_TO_PRIO(0);
-			p->normal_prio = p->static_prio;
-			set_load_weight(p);
-		}
+			p->rt_priority = 0;
+		} else if (PRIO_TO_NICE(p->static_prio) < 0)
+			p->static_prio = NICE_TO_PRIO(0);
+
+		p->prio = p->normal_prio = __normal_prio(p);
+		set_load_weight(p);
 
 		/*
 		 * We don't need the reset flag anymore after the fork. It has
@@ -2865,11 +2869,6 @@ void sched_fork(struct task_struct *p)
 		p->sched_reset_on_fork = 0;
 	}
 
-	/*
-	 * Make sure we do not leak PI boosting priority to the child.
-	 */
-	p->prio = current->normal_prio;
-
 	if (!rt_prio(p->prio))
 		p->sched_class = &fair_sched_class;
 
