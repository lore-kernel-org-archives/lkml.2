Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759866Ab0FJXL3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 19:11:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57119 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753351Ab0FJXL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 19:11:28 -0400
Date: Fri, 11 Jun 2010 01:09:44 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Stanislaw Gruszka <sgruszka@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] sched: __sched_setscheduler: read RLIMIT_RTPRIO
	lockless
Message-ID: <20100610230944.GA25903@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__sched_setscheduler() takes lock_task_sighand() to access task->signal.
This is not needed since ea6d290c, ->signal can't go away.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/sched.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- 35-rc2/kernel/sched.c~1_SETSCHED_NO_SIGLOCK	2010-06-11 00:47:36.000000000 +0200
+++ 35-rc2/kernel/sched.c	2010-06-11 01:07:15.000000000 +0200
@@ -4432,12 +4432,8 @@ recheck:
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

