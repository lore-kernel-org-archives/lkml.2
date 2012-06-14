Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026Ab2FNOnY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 10:43:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35371 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755453Ab2FNOnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 10:43:22 -0400
Date: Thu, 14 Jun 2012 07:43:00 -0700
From: tip-bot for Don Zickus <dzickus@redhat.com>
Message-ID: <tip-a70270468234749741c5893ae78e5bb524771402@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        nzimmer@sgi.com, tglx@linutronix.de, dzickus@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        nzimmer@sgi.com, tglx@linutronix.de, dzickus@redhat.com
In-Reply-To: <1339594548-17227-1-git-send-email-dzickus@redhat.com>
References: <1339594548-17227-1-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] watchdog: Quiet down the boot messages
Git-Commit-ID: a70270468234749741c5893ae78e5bb524771402
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 14 Jun 2012 07:43:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a70270468234749741c5893ae78e5bb524771402
Gitweb:     http://git.kernel.org/tip/a70270468234749741c5893ae78e5bb524771402
Author:     Don Zickus <dzickus@redhat.com>
AuthorDate: Wed, 13 Jun 2012 09:35:48 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 14 Jun 2012 12:20:50 +0200

watchdog: Quiet down the boot messages

A bunch of bugzillas have complained how noisy the nmi_watchdog
is during boot-up especially with its expected failure cases
(like virt and bios resource contention).

This is my attempt to quiet them down and keep it less confusing
for the end user.  What I did is print the message for cpu0 and
save it for future comparisons.  If future cpus have an
identical message as cpu0, then don't print the redundant info.
However, if a future cpu has a different message, happily print
that loudly.

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
    NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
    Booting Node   0, Processors  #1 #2 #3 Ok.
    Brought up 4 CPUs

V2: little changes based on Joe Perches' feedback
V3: printk cleanup based on Ingo's feedback; checkpatch fix
V4: keep printk as one long line
V5: Ingo fix ups

Reported-and-tested-by: Nathan Zimmer <nzimmer@sgi.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: nzimmer@sgi.com
Cc: joe@perches.com
Link: http://lkml.kernel.org/r/1339594548-17227-1-git-send-email-dzickus@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/watchdog.c |   19 ++++++++++++++++++-
 1 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index e5e1d85..4b1dfba 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -372,6 +372,13 @@ static int watchdog(void *unused)
 
 
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
+/*
+ * People like the simple clean cpu node info on boot.
+ * Reduce the watchdog noise by only printing messages
+ * that are different from what cpu0 displayed.
+ */
+static unsigned long cpu0_err;
+
 static int watchdog_nmi_enable(int cpu)
 {
 	struct perf_event_attr *wd_attr;
@@ -390,11 +397,21 @@ static int watchdog_nmi_enable(int cpu)
 
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
+		if (cpu == 0 || cpu0_err)
+			pr_info("enabled on all CPUs, permanently consumes one hw-PMU counter.\n");
 		goto out_save;
 	}
 
+	/* skip displaying the same error again */
+	if (cpu > 0 && (PTR_ERR(event) == cpu0_err))
+		return PTR_ERR(event);
 
 	/* vary the KERN level based on the returned errno */
 	if (PTR_ERR(event) == -EOPNOTSUPP)
