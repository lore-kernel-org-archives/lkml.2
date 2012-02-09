Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758665Ab2BIWnE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 17:43:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25994 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758439Ab2BIWm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 17:42:59 -0500
From: Don Zickus <dzickus@redhat.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?q?Fernando=20Luis=20V=C3=A1zquez=20Cao?= 
	<fernando@oss.ntt.co.jp>,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 3/3] watchdog: fix code/comments mismatches
Date: Thu,  9 Feb 2012 17:42:22 -0500
Message-Id: <1328827342-6253-3-git-send-email-dzickus@redhat.com>
In-Reply-To: <1328827342-6253-1-git-send-email-dzickus@redhat.com>
References: <1328827342-6253-1-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fernando Luis Vázquez Cao <fernando@oss.ntt.co.jp>

Reflect the change in the soft and hard lockup thresholds and their relation to
the frequency of the hrtimer and NMI events in the code comments. While at it,
remove references to files that do not exist anymore.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 kernel/watchdog.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 1d7bca7..7633df9 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -3,12 +3,9 @@
  *
  * started by Don Zickus, Copyright (C) 2010 Red Hat, Inc.
  *
- * this code detects hard lockups: incidents in where on a CPU
- * the kernel does not respond to anything except NMI.
- *
- * Note: Most of this code is borrowed heavily from softlockup.c,
- * so thanks to Ingo for the initial implementation.
- * Some chunks also taken from arch/x86/kernel/apic/nmi.c, thanks
+ * Note: Most of this code is borrowed heavily from the original softlockup
+ * detector, so thanks to Ingo for the initial implementation.
+ * Some chunks also taken from the old x86-specific nmi watchdog code, thanks
  * to those contributors as well.
  */
 
@@ -117,9 +114,10 @@ static unsigned long get_sample_period(void)
 {
 	/*
 	 * convert watchdog_thresh from seconds to ns
-	 * the divide by 5 is to give hrtimer 5 chances to
-	 * increment before the hardlockup detector generates
-	 * a warning
+	 * the divide by 5 is to give hrtimer several chances (two
+	 * or three with the current relation between the soft
+	 * and hard thresholds) to increment before the
+	 * hardlockup detector generates a warning
 	 */
 	return get_softlockup_thresh() * (NSEC_PER_SEC / 5);
 }
@@ -336,9 +334,11 @@ static int watchdog(void *unused)
 
 	set_current_state(TASK_INTERRUPTIBLE);
 	/*
-	 * Run briefly once per second to reset the softlockup timestamp.
-	 * If this gets delayed for more than 60 seconds then the
-	 * debug-printout triggers in watchdog_timer_fn().
+	 * Run briefly (kicked by the hrtimer callback function) once every
+	 * get_sample_period() seconds (4 seconds by default) to reset the
+	 * softlockup timestamp. If this gets delayed for more than
+	 * 2*watchdog_thresh seconds then the debug-printout triggers in
+	 * watchdog_timer_fn().
 	 */
 	while (!kthread_should_stop()) {
 		__touch_watchdog();
-- 
1.7.7.6

