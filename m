Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224Ab0EMBWA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 21:22:00 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:37520 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758197Ab0EMBVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 21:21:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=EAEWfN3qhrRXeh90w6Ts1BVdNujmkRGUxZKJvHvRfmaPqgAWXUcNaJvcs1wiCsUZQO
         mHdIAERWczuqHuprIp2hJ63r2qIWWh0PUbzwSvrQMRCFo+TCIA/aLG81Cw1LzllT7Ox0
         5EX13v0Z1FONv651taaL6m4A/BZdeTaCoaZpo=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Eric Paris <eparis@redhat.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 7/9] lockup_detector: Separate touch_nmi_watchdog code path from touch_watchdog
Date: Thu, 13 May 2010 03:21:12 +0200
Message-Id: <1273713674-8434-8-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1273713674-8434-1-git-send-regression-fweisbec@gmail.com>
References: <1273713674-8434-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Don Zickus <dzickus@redhat.com>

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
 
-- 
1.6.2.3

