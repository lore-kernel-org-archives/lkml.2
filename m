Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910Ab1IZTPb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 15:15:31 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:49573 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752902Ab1IZTP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 15:15:27 -0400
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        arve@android.com, markgross@thegnar.org,
        Alan Stern <stern@rowland.harvard.edu>, amit.kucheria@linaro.org,
        farrowg@sg.ibm.com, "Dmitry Fink (Palm GBU)" <Dmitry.Fink@palm.com>,
        linux-pm@lists.linux-foundation.org, khilman@ti.com,
        Magnus Damm <damm@opensource.se>, mjg@redhat.com, peterz@infradead.org
Subject: [PATCH 6/6] [RFC] alarmtimer: Deboost on nanosleep
Date: Mon, 26 Sep 2011 12:13:54 -0700
Message-Id: <1317064434-1829-7-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1317064434-1829-1-git-send-email-john.stultz@linaro.org>
References: <1317064434-1829-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Example of deboosting tasks before blocking on a wakeup
source like alarmtimer based nanosleep.

With this final patch, the kernel will be able to suspend
when SCHED_STAYAWAKE flagged tasks are blocked on the alarmtimer.

CC: Rafael J. Wysocki <rjw@sisk.pl>
CC: arve@android.com
CC: markgross@thegnar.org
CC: Alan Stern <stern@rowland.harvard.edu>
CC: amit.kucheria@linaro.org
CC: farrowg@sg.ibm.com
CC: Dmitry Fink (Palm GBU) <Dmitry.Fink@palm.com>
CC: linux-pm@lists.linux-foundation.org
CC: khilman@ti.com
CC: Magnus Damm <damm@opensource.se>
CC: mjg@redhat.com 
CC: peterz@infradead.org 
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/alarmtimer.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index 00ee80f..c855d40 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -568,9 +568,10 @@ static int alarmtimer_do_nsleep(struct alarm *alarm, ktime_t absexp)
 	do {
 		set_current_state(TASK_INTERRUPTIBLE);
 		alarm_start(alarm, absexp, ktime_set(0, 0));
-		if (likely(alarm->data))
+		if (likely(alarm->data)) {
+			sched_deboost_task_active_count(current);
 			schedule();
-
+		}
 		alarm_cancel(alarm);
 	} while (alarm->data && !signal_pending(current));
 
-- 
1.7.3.2.146.gca209

