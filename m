Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570Ab1BVVFA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 16:05:00 -0500
Received: from mga09.intel.com ([134.134.136.24]:38728 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753136Ab1BVVEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 16:04:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,207,1297065600"; 
   d="scan'208";a="711922438"
From: Darren Hart <dvhart@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        richard.purdie@linuxfoundation.org, dvhart@linux.intel.com
Subject: [PATCH 2/2] sched: allow users with rtprio rlimit to change from SCHED_IDLE policy
Date: Tue, 22 Feb 2011 13:04:34 -0800
Message-Id: <1298408674-3130-3-git-send-email-dvhart@linux.intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1298408674-3130-1-git-send-email-dvhart@linux.intel.com>
References: <1298408674-3130-1-git-send-email-dvhart@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As it stands, users with rtprio rlimit permissions can change their policy from
SCHED_OTHER to SCHED_FIFO and back. They can change to SCHED_IDLE, but not back
to SCHED_FIFO. If they have the rtprio permission, they should be able to. Once
in SCHED_FIFO, they could go back to SCHED_OTHER. This patch allows users with
rtprio permission to change out of SCHED_IDLE.

This patch allows the following test-case to pass for users with rtprio
permissions with or without the ifdef block:

int main()
{
	int ret;
	struct sched_param sp;

	/* switch to SCHED_FIFO */
	sp.sched_priority = 1;
	ret = sched_setscheduler(0, SCHED_FIFO, &sp);
	printf("setscheduler FIFO: %d\n", ret);
	if (ret) return ret;

	/* switch to SCHED_IDLE */
	sp.sched_priority = 0;
	ret = sched_setscheduler(0, SCHED_IDLE, &sp);
	printf("setscheduler IDLE: %d\n", ret);
	if (ret) return ret;

	/* switch to SCHED_FIFO */
	sp.sched_priority = 1;
	ret = sched_setscheduler(0, SCHED_FIFO, &sp);
	printf("setscheduler FIFO: %d\n", ret);
	if (ret) return ret;
	/* switch back to SCHED_OTHER */
	sp.sched_priority = 0;
	ret = sched_setscheduler(0, SCHED_OTHER, &sp);
	printf("setscheduler OTHER: %d\n", ret);

	return ret;
}

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>
CC: Richard Purdie <richard.purdie@linuxfoundation.org>
---
 kernel/sched.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 18d38e4..ec6943e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4822,12 +4822,16 @@ recheck:
 			    param->sched_priority > rlim_rtprio)
 				return -EPERM;
 		}
+
 		/*
-		 * Like positive nice levels, dont allow tasks to
-		 * move out of SCHED_IDLE either:
+		 * Like positive nice levels, don't allow tasks to move out of
+		 * SCHED_IDLE either. Make an exception if the user can set rt
+		 * policy normally.
 		 */
-		if (p->policy == SCHED_IDLE && policy != SCHED_IDLE)
-			return -EPERM;
+		if (p->policy == SCHED_IDLE && policy != SCHED_IDLE) {
+			if (!task_rlimit(p, RLIMIT_RTPRIO))
+				return -EPERM;
+		}
 
 		/* can't change other user's priorities */
 		if (!check_same_owner(p))
-- 
1.7.1

