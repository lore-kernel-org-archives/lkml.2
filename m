Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760054Ab0FRKUA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 06:20:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:47000 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757902Ab0FRKT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 06:19:58 -0400
Date: Fri, 18 Jun 2010 10:19:31 GMT
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, oleg@redhat.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, oleg@redhat.com,
       mingo@elte.hu
In-Reply-To: <20100610230944.GA25903@redhat.com>
References: <20100610230944.GA25903@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: __sched_setscheduler: Read the RLIMIT_RTPRIO value lockless
Message-ID: <tip-a44702e8858a071aa0f2365113ea4a2e51c8b575@git.kernel.org>
Git-Commit-ID: a44702e8858a071aa0f2365113ea4a2e51c8b575
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 18 Jun 2010 10:19:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a44702e8858a071aa0f2365113ea4a2e51c8b575
Gitweb:     http://git.kernel.org/tip/a44702e8858a071aa0f2365113ea4a2e51c8b575
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Fri, 11 Jun 2010 01:09:44 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 18 Jun 2010 10:46:55 +0200

sched: __sched_setscheduler: Read the RLIMIT_RTPRIO value lockless

__sched_setscheduler() takes lock_task_sighand() to access task->signal.
This is not needed since ea6d290c, ->signal can't go away.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20100610230944.GA25903@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 132950b..b4427cc 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4600,12 +4600,8 @@ recheck:
 	 */
 	if (user && !capable(CAP_SYS_NICE)) {
 		if (rt_policy(policy)) {
-			unsigned long rlim_rtprio;
-
-			if (!lock_task_sighand(p, &flags))
-				return -ESRCH;
-			rlim_rtprio = task_rlimit(p, RLIMIT_RTPRIO);
-			unlock_task_sighand(p, &flags);
+			unsigned long rlim_rtprio =
+					task_rlimit(p, RLIMIT_RTPRIO);
 
 			/* can't set/change the rt policy */
 			if (policy != p->policy && !rlim_rtprio)
