Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126Ab1LUVS3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 16:18:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54031 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754109Ab1LUVSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 16:18:23 -0500
From: Don Zickus <dzickus@redhat.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        avi@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
        tglx@linutronix.de, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 1/5] sched: Minimize the number of touch_softlockup_watchdogs
Date: Wed, 21 Dec 2011 16:17:41 -0500
Message-Id: <1324502265-24521-2-git-send-email-dzickus@redhat.com>
In-Reply-To: <1324502265-24521-1-git-send-email-dzickus@redhat.com>
References: <1324502265-24521-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am looking to add a change to the softlockup code that
creates a timestamp every time it is touched.  However, there is
some overhead to touching cpu_clock all the time.

I noticed sched_clock_idle_wakeup_event runs
touch_softlockup_watchdog every microsecond or about a
million times a second.  That seemed excessive.

The only use I can see for touching the softlockup watchdog
is to reset the clock on long delays.  Considering most of the
time the delay is 0, it seems pointless to touch the watchdog.

This saves about a million calls a second and avoids any new
overhead by changes in the softlockup watchdog.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 kernel/sched/clock.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/clock.c b/kernel/sched/clock.c
index c685e31..802e03b 100644
--- a/kernel/sched/clock.c
+++ b/kernel/sched/clock.c
@@ -274,7 +274,8 @@ void sched_clock_idle_wakeup_event(u64 delta_ns)
 		return;
 
 	sched_clock_tick();
-	touch_softlockup_watchdog();
+	if (delta_ns > 0)
+		touch_softlockup_watchdog();
 }
 EXPORT_SYMBOL_GPL(sched_clock_idle_wakeup_event);
 
-- 
1.7.7.4

