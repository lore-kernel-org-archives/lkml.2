Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759537Ab1CDLuU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 06:50:20 -0500
Received: from hera.kernel.org ([140.211.167.34]:41818 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754143Ab1CDLuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 06:50:14 -0500
Date: Fri, 4 Mar 2011 11:49:46 GMT
From: tip-bot for Darren Hart <dvhart@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, dvhart@linux.intel.com,
        richard.purdie@linuxfoundation.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dvhart@linux.intel.com, a.p.zijlstra@chello.nl,
        richard.purdie@linuxfoundation.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4D657BEE.4040608@linux.intel.com>
References: <4D657BEE.4040608@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Allow users with sufficient RLIMIT_NICE to change from SCHED_IDLE policy
Message-ID: <tip-c02aa73b1d18e43cfd79c2f193b225e84ca497c8@git.kernel.org>
Git-Commit-ID: c02aa73b1d18e43cfd79c2f193b225e84ca497c8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 04 Mar 2011 11:49:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c02aa73b1d18e43cfd79c2f193b225e84ca497c8
Gitweb:     http://git.kernel.org/tip/c02aa73b1d18e43cfd79c2f193b225e84ca497c8
Author:     Darren Hart <dvhart@linux.intel.com>
AuthorDate: Thu, 17 Feb 2011 15:37:07 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 4 Mar 2011 11:14:30 +0100

sched: Allow users with sufficient RLIMIT_NICE to change from SCHED_IDLE policy

The current scheduler implementation returns -EPERM when trying to
change from SCHED_IDLE to SCHED_OTHER or SCHED_BATCH. Since SCHED_IDLE
is considered to be a nice 20 on steroids, changing to another policy
should be allowed provided the RLIMIT_NICE is accounted for.

This patch allows the following test-case to pass with RLIMIT_NICE=40,
but still fail with RLIMIT_NICE=10 when the calling process is run
from a typical shell (nice 0, or 20 in rlimit terms).

int main()
{
	int ret;
	struct sched_param sp;
	sp.sched_priority = 0;

	/* switch to SCHED_IDLE */
	ret = sched_setscheduler(0, SCHED_IDLE, &sp);
	printf("setscheduler IDLE: %d\n", ret);
	if (ret) return ret;

	/* switch back to SCHED_OTHER */
	ret = sched_setscheduler(0, SCHED_OTHER, &sp);
	printf("setscheduler OTHER: %d\n", ret);

	return ret;
}

 $ ulimit -e
 40
 $ ./test
 setscheduler IDLE: 0
 setscheduler OTHER: 0

 $ ulimit -e 10
 $ ulimit -e
 10
 $ ./test
 setscheduler IDLE: 0
 setscheduler OTHER: -1

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Richard Purdie <richard.purdie@linuxfoundation.org>
LKML-Reference: <4D657BEE.4040608@linux.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 0c87126..f303070 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4981,12 +4981,15 @@ recheck:
 			    param->sched_priority > rlim_rtprio)
 				return -EPERM;
 		}
+
 		/*
-		 * Like positive nice levels, dont allow tasks to
-		 * move out of SCHED_IDLE either:
+		 * Treat SCHED_IDLE as nice 20. Only allow a switch to
+		 * SCHED_NORMAL if the RLIMIT_NICE would normally permit it.
 		 */
-		if (p->policy == SCHED_IDLE && policy != SCHED_IDLE)
-			return -EPERM;
+		if (p->policy == SCHED_IDLE && policy != SCHED_IDLE) {
+			if (!can_nice(p, TASK_NICE(p)))
+				return -EPERM;
+		}
 
 		/* can't change other user's priorities */
 		if (!check_same_owner(p))
