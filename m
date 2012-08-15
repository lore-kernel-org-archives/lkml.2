Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757219Ab2HOULq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:11:46 -0400
Received: from mail.windriver.com ([147.11.1.11]:37028 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756934Ab2HOTv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:51:57 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
        Prarit Bhargava <prarit@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 114/165] timekeeping: Fix leapsecond triggered load spike issue
Date: Wed, 15 Aug 2012 15:47:38 -0400
Message-ID: <1345060109-9187-115-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Stultz <johnstul@us.ibm.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 4873fa070ae84a4115f0b3c9dfabc224f1bc7c51 upstream.

The timekeeping code misses an update of the hrtimer subsystem after a
leap second happened. Due to that timers based on CLOCK_REALTIME are
either expiring a second early or late depending on whether a leap
second has been inserted or deleted until an operation is initiated
which causes that update. Unless the update happens by some other
means this discrepancy between the timekeeping and the hrtimer data
stays forever and timers are expired either early or late.

The reported immediate workaround - $ data -s "`date`" - is causing a
call to clock_was_set() which updates the hrtimer data structures.
See: http://www.sheeri.com/content/mysql-and-leap-second-high-cpu-and-fix

Add the missing clock_was_set() call to update_wall_time() in case of
a leap second event. The actual update is deferred to softirq context
as the necessary smp function call cannot be invoked from hard
interrupt context.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Reported-by: Jan Engelhardt <jengelh@inai.de>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Prarit Bhargava <prarit@redhat.com>
Cc: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/1341960205-56738-3-git-send-email-johnstul@us.ibm.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/time/timekeeping.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index adfa89d..634c9ee 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -769,6 +769,8 @@ static cycle_t logarithmic_accumulation(cycle_t offset, int shift)
 		leap = second_overflow(xtime.tv_sec);
 		xtime.tv_sec += leap;
 		wall_to_monotonic.tv_sec -= leap;
+		if (leap)
+			clock_was_set_delayed();
 	}
 
 	/* Accumulate into raw time */
-- 
1.7.12.rc2

