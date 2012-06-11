Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080Ab2FKUEl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 16:04:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39233 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751945Ab2FKUEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 16:04:31 -0400
From: Don Zickus <dzickus@redhat.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: nzimmer@sgi.com, joe@perches.com, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH v3] watchdog: Quiet down the boot messages
Date: Mon, 11 Jun 2012 16:04:10 -0400
Message-Id: <1339445050-29941-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A bunch of bugzillas have complained how noisy the nmi_watchdog is during
boot-up especially with its expected failure cases (like virt and bios
resource contention).

This is my attempt to quiet them down and keep it less confusing for the end
user.  What I did is print the message for cpu0 and save it for future
comparisons.  If future cpus have an identical message as cpu0, then don't
print the redundant info.  However, if a future cpu has a different message,
happily print that loudly.

Before the change, you would see something like:

    ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
    CPU0: Intel(R) Core(TM)2 Quad CPU    Q9550  @ 2.83GHz stepping 0a
    Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
    ... version:                2
    ... bit width:              40
    ... generic registers:      2
    ... value mask:             000000ffffffffff
    ... max period:             000000007fffffff
    ... fixed-purpose events:   3
    ... event mask:             0000000700000003
    NMI watchdog enabled, takes one hw-pmu counter.
    Booting Node   0, Processors  #1
    NMI watchdog enabled, takes one hw-pmu counter.
     #2
    NMI watchdog enabled, takes one hw-pmu counter.
     #3 Ok.
    NMI watchdog enabled, takes one hw-pmu counter.
    Brought up 4 CPUs
    Total of 4 processors activated (22607.24 BogoMIPS).

After the change, it is simplified to:

    ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
    CPU0: Intel(R) Core(TM)2 Quad CPU    Q9550  @ 2.83GHz stepping 0a
    Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
    ... version:                2
    ... bit width:              40
    ... generic registers:      2
    ... value mask:             000000ffffffffff
    ... max period:             000000007fffffff
    ... fixed-purpose events:   3
    ... event mask:             0000000700000003
    NMI watchdog enabled, takes one hw-pmu counter.
    Booting Node   0, Processors  #1 #2 #3 Ok.
    Brought up 4 CPUs

V2: little changes based on Joe Perches' feedback
V3: printk cleanup based on Ingo's feedback; checkpatch fix

Reported-and-tested-by: Nathan Zimmer <nzimmer@sgi.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 kernel/watchdog.c |   21 ++++++++++++++++++++-
 1 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index e5e1d85..74b1e27 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -377,6 +377,13 @@ static int watchdog_nmi_enable(int cpu)
 	struct perf_event_attr *wd_attr;
 	struct perf_event *event = per_cpu(watchdog_ev, cpu);
 
+	/*
+	 * People like the simple clean cpu node info on boot.
+	 * Reduce the watchdog noise by only printing messages
+	 * that are different from what cpu0 displayed.
+	 */
+	static unsigned long cpu0_err;
+
 	/* is it already setup and enabled? */
 	if (event && event->state > PERF_EVENT_STATE_OFF)
 		goto out;
@@ -390,11 +397,23 @@ static int watchdog_nmi_enable(int cpu)
 
 	/* Try to register using hardware perf events */
 	event = perf_event_create_kernel_counter(wd_attr, cpu, NULL, watchdog_overflow_callback, NULL);
+
+	/* save cpu0 error for future comparision */
+	if (cpu == 0 && IS_ERR(event))
+		cpu0_err = PTR_ERR(event);
+
 	if (!IS_ERR(event)) {
-		pr_info("enabled, takes one hw-pmu counter.\n");
+		/* only print for cpu0 or different than cpu0 */
+		if (cpu == 0 || cpu0_err) {
+			pr_info("enabled on all CPUs, permanently consumes ");
+			pr_cont("one hw-PMU counter.\n");
+		}
 		goto out_save;
 	}
 
+	/* skip displaying the same error again */
+	if (cpu > 0 && (PTR_ERR(event) == cpu0_err))
+		return PTR_ERR(event);
 
 	/* vary the KERN level based on the returned errno */
 	if (PTR_ERR(event) == -EOPNOTSUPP)
-- 
1.7.7.6

