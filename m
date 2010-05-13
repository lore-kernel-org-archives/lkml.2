Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308Ab0EMGyX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 02:54:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:56803 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753413Ab0EMGyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 02:54:06 -0400
Date: Thu, 13 May 2010 06:53:40 GMT
From: tip-bot for Don Zickus <dzickus@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       eparis@redhat.com, peterz@infradead.org, randy.dunlap@oracle.com,
       gorcunov@gmail.com, fweisbec@gmail.com, tglx@linutronix.de,
       dzickus@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       eparis@redhat.com, peterz@infradead.org, gorcunov@gmail.com,
       randy.dunlap@oracle.com, fweisbec@gmail.com, tglx@linutronix.de,
       dzickus@redhat.com, mingo@elte.hu
In-Reply-To: <1273266711-18706-9-git-send-email-dzickus@redhat.com>
References: <1273266711-18706-9-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/nmi] lockup_detector: Separate touch_nmi_watchdog code path from touch_watchdog
Message-ID: <tip-d7c547335fa6b0090fa09c46ea0e965ac273a27e@git.kernel.org>
Git-Commit-ID: d7c547335fa6b0090fa09c46ea0e965ac273a27e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 13 May 2010 06:53:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d7c547335fa6b0090fa09c46ea0e965ac273a27e
Gitweb:     http://git.kernel.org/tip/d7c547335fa6b0090fa09c46ea0e965ac273a27e
Author:     Don Zickus <dzickus@redhat.com>
AuthorDate: Fri, 7 May 2010 17:11:51 -0400
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Wed, 12 May 2010 23:55:55 +0200

lockup_detector: Separate touch_nmi_watchdog code path from touch_watchdog

When I combined the nmi_watchdog (hardlockup) and softlockup code, I
also combined the paths the touch_watchdog and touch_nmi_watchdog took.
This may not be the best idea as pointed out by Frederic W., that the
touch_watchdog case probably should not reset the hardlockup count.

Therefore the patch below falls back to the previous idea of keeping
the touch_nmi_watchdog a superset of the touch_watchdog case.

Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
LKML-Reference: <1273266711-18706-9-git-send-email-dzickus@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/watchdog.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index f1541b7..57b8e2c 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -31,6 +31,7 @@ int watchdog_enabled;
 int __read_mostly softlockup_thresh = 60;
 
 static DEFINE_PER_CPU(unsigned long, watchdog_touch_ts);
+static DEFINE_PER_CPU(bool, watchdog_nmi_touch);
 static DEFINE_PER_CPU(struct task_struct *, softlockup_watchdog);
 static DEFINE_PER_CPU(struct hrtimer, watchdog_hrtimer);
 static DEFINE_PER_CPU(bool, softlockup_touch_sync);
@@ -139,6 +140,7 @@ void touch_all_softlockup_watchdogs(void)
 
 void touch_nmi_watchdog(void)
 {
+	__get_cpu_var(watchdog_nmi_touch) = true;
 	touch_softlockup_watchdog();
 }
 EXPORT_SYMBOL(touch_nmi_watchdog);
@@ -201,10 +203,9 @@ void watchdog_overflow_callback(struct perf_event *event, int nmi,
 		 struct pt_regs *regs)
 {
 	int this_cpu = smp_processor_id();
-	unsigned long touch_ts = per_cpu(watchdog_touch_ts, this_cpu);
 
-	if (touch_ts == 0) {
-		__touch_watchdog();
+	if (__get_cpu_var(watchdog_nmi_touch) == true) {
+		__get_cpu_var(watchdog_nmi_touch) = false;
 		return;
 	}
 
