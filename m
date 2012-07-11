Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933270Ab2GKVmK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 17:42:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50135 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756048Ab2GKVmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 17:42:06 -0400
Date: Wed, 11 Jul 2012 14:41:38 -0700
From: tip-bot for John Stultz <johnstul@us.ibm.com>
Message-ID: <tip-4873fa070ae84a4115f0b3c9dfabc224f1bc7c51@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, johnstul@us.ibm.com, jengelh@inai.de,
        tglx@linutronix.de, prarit@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        johnstul@us.ibm.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        jengelh@inai.de, prarit@redhat.com
In-Reply-To: <1341960205-56738-3-git-send-email-johnstul@us.ibm.com>
References: <1341960205-56738-3-git-send-email-johnstul@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] timekeeping:
  Fix leapsecond triggered load spike issue
Git-Commit-ID: 4873fa070ae84a4115f0b3c9dfabc224f1bc7c51
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 11 Jul 2012 14:41:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4873fa070ae84a4115f0b3c9dfabc224f1bc7c51
Gitweb:     http://git.kernel.org/tip/4873fa070ae84a4115f0b3c9dfabc224f1bc7c51
Author:     John Stultz <johnstul@us.ibm.com>
AuthorDate: Tue, 10 Jul 2012 18:43:20 -0400
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 11 Jul 2012 23:34:37 +0200

timekeeping: Fix leapsecond triggered load spike issue

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
---
 kernel/time/timekeeping.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 6f46a00..a413e59 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -963,6 +963,8 @@ static cycle_t logarithmic_accumulation(cycle_t offset, int shift)
 		leap = second_overflow(timekeeper.xtime.tv_sec);
 		timekeeper.xtime.tv_sec += leap;
 		timekeeper.wall_to_monotonic.tv_sec -= leap;
+		if (leap)
+			clock_was_set_delayed();
 	}
 
 	/* Accumulate raw time */
@@ -1079,6 +1081,8 @@ static void update_wall_time(void)
 		leap = second_overflow(timekeeper.xtime.tv_sec);
 		timekeeper.xtime.tv_sec += leap;
 		timekeeper.wall_to_monotonic.tv_sec -= leap;
+		if (leap)
+			clock_was_set_delayed();
 	}
 
 	timekeeping_update(false);
