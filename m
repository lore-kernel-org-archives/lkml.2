Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504Ab2KRA3d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 19:29:33 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:37977 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab2KRA3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 19:29:33 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: mingo@kernel.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] watchdog: Inject NMI when locked up and going to panic
Date: Sat, 17 Nov 2012 19:28:53 -0500
Message-Id: <1353198533-24473-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.0
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Send an NMI to all CPUs when a lockup is detected and the lockup
watchdog code is configured to panic. This gives us a fairly uptodate
snapshot of all CPUs in the system.

This lets us get stack trace of all CPUs which makes life easier
trying to debug a deadlock, and the NMI doesn't change anything
since the next step is a kernel panic.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 kernel/watchdog.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 9d4c8d5..26a5f88 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -239,10 +239,12 @@ static void watchdog_overflow_callback(struct perf_event *event,
 		if (__this_cpu_read(hard_watchdog_warn) == true)
 			return;
 
-		if (hardlockup_panic)
+		if (hardlockup_panic) {
+			trigger_all_cpu_backtrace();
 			panic("Watchdog detected hard LOCKUP on cpu %d", this_cpu);
-		else
+		} else {
 			WARN(1, "Watchdog detected hard LOCKUP on cpu %d", this_cpu);
+		}
 
 		__this_cpu_write(hard_watchdog_warn, true);
 		return;
@@ -323,8 +325,10 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 		else
 			dump_stack();
 
-		if (softlockup_panic)
+		if (softlockup_panic) {
+			trigger_all_cpu_backtrace();
 			panic("softlockup: hung tasks");
+		}
 		__this_cpu_write(soft_watchdog_warn, true);
 	} else
 		__this_cpu_write(soft_watchdog_warn, false);
-- 
1.8.0

