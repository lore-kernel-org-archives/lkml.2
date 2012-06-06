Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757750Ab2FFSJs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 14:09:48 -0400
Received: from relay3.sgi.com ([192.48.152.1]:42908 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751773Ab2FFSJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 14:09:47 -0400
Date: Wed, 6 Jun 2012 13:09:46 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Don Zickus <dzickus@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH] watchdog: reduce "NMI watchdog enabled, takes one hw-pmu
	counter." messages
Message-ID: <20120606180946.GA16566@gulag1.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 watchdog: reduces some noise on a large system
 The printk buffer can be flooded with with redundant
 "NMI watchdog enabled, takes one hw-pmu counter." messages.
 It doesn't add any value beyond the first.

 Note the message needs logged a second time if the watchdog was disabled then
 reenabled.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
---
 kernel/watchdog.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index e5e1d85..404b141 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -372,6 +372,8 @@ static int watchdog(void *unused)
 
 
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
+static bool already_notified;
+
 static int watchdog_nmi_enable(int cpu)
 {
 	struct perf_event_attr *wd_attr;
@@ -391,7 +393,10 @@ static int watchdog_nmi_enable(int cpu)
 	/* Try to register using hardware perf events */
 	event = perf_event_create_kernel_counter(wd_attr, cpu, NULL, watchdog_overflow_callback, NULL);
 	if (!IS_ERR(event)) {
-		pr_info("enabled, takes one hw-pmu counter.\n");
+		if (!already_notified) {
+			pr_info("enabled, takes one hw-pmu counter.\n");
+			already_notified = true;
+		}
 		goto out_save;
 	}
 
@@ -426,6 +431,7 @@ static void watchdog_nmi_disable(int cpu)
 
 		/* should be in cleanup, but blocks oprofile */
 		perf_event_release_kernel(event);
+		already_notified = false;
 	}
 	return;
 }
-- 
1.6.0.2

