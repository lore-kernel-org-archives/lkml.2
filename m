Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161Ab2BKXI0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 18:08:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45282 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836Ab2BKXIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 18:08:25 -0500
Date: Sat, 11 Feb 2012 15:08:12 -0800
From: "=?UTF-8?B?dGlwLWJvdCBmb3IgRmVybmFuZG8gTHVpcyBWw6F6cXVleiBDYW8=?=" 
	<fernando@oss.ntt.co.jp>
Message-ID: <tip-86f5e6a7b192721995ece919985ac75222402351@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        fernando@oss.ntt.co.jp, tglx@linutronix.de, mingo@elte.hu,
        dzickus@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fernando@oss.ntt.co.jp, tglx@linutronix.de, dzickus@redhat.com,
        mingo@elte.hu
In-Reply-To: <1328827342-6253-3-git-send-email-dzickus@redhat.com>
References: <1328827342-6253-3-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] watchdog: Fix code/comments mismatches
Git-Commit-ID: 86f5e6a7b192721995ece919985ac75222402351
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 11 Feb 2012 15:08:18 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  86f5e6a7b192721995ece919985ac75222402351
Gitweb:     http://git.kernel.org/tip/86f5e6a7b192721995ece919985ac75222402351
Author:     Fernando Luis Vázquez Cao <fernando@oss.ntt.co.jp>
AuthorDate: Thu, 9 Feb 2012 17:42:22 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 11 Feb 2012 15:11:33 +0100

watchdog: Fix code/comments mismatches

Reflect the change in the soft and hard lockup thresholds and
their relation to the frequency of the hrtimer and NMI events in
the code comments. While at it, remove references to files that
do not exist anymore.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Link: http://lkml.kernel.org/r/1328827342-6253-3-git-send-email-dzickus@redhat.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/watchdog.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index d117262..14bc092 100644
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
