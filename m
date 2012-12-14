Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab2LNNox (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 08:44:53 -0500
Received: from canardo.mork.no ([148.122.252.1]:47281 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754138Ab2LNNow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 08:44:52 -0500
From: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Norbert Warmuth <nwarmuth@t-online.de>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH v2] watchdog: Fix disable/enable regression
Date: Fri, 14 Dec 2012 14:44:30 +0100
Message-Id: <1355492670-17590-1-git-send-email-bjorn@mork.no>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <87y5h1c70y.fsf@nemi.mork.no>
References: <87y5h1c70y.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 8d451690 ("watchdog: Fix CPU hotplug regression") cause
an oops or hard lockup when doing

 echo 0 > /proc/sys/kernel/nmi_watchdog
 echo 1 > /proc/sys/kernel/nmi_watchdog

and the kernel is booted with nmi_watchdog=1 (default)

Running laptop-mode-tools and disconnecting/connecting AC power
will cause this to trigger, making it a common failure scenario
on laptops.

Instead of bailing out of watchdog_disable() when !watchdog_enabled
we can initialize the hrtimer regardless of watchdog_enabled status.
This makes it safe to call watchdog_disable() in the nmi_watchdog=0
case, without the negative effect on the enabled => disabled =>
enabled case.

All these tests pass with this patch:
- nmi_watchdog=1
  echo 0 > /proc/sys/kernel/nmi_watchdog
  echo 1 > /proc/sys/kernel/nmi_watchdog

- nmi_watchdog=0
  echo 0 > /sys/devices/system/cpu/cpu1/online

- nmi_watchdog=0
  echo mem > /sys/power/state

Cc: <stable@vger.kernel.org> # v3.7
Cc: Norbert Warmuth <nwarmuth@t-online.de>
Cc: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
---
v2:
  implemented an alternate workaround for the original problem.

Hello Thomas,

I will not claim to understand this code, but it seemed to me like the
original problem was caused by the missing initialization of the hrtimer
in the disabled case. Calling hrtimer_cancel() on an initialized timer
not running should be perfectly OK.  And watchdog_nmi_disable() will 
not do anything unless the event is initialized.  So this patch looks
like a fix.


Bjørn

 kernel/watchdog.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index c8c21be..762081c 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -343,6 +343,10 @@ static void watchdog_enable(unsigned int cpu)
 {
 	struct hrtimer *hrtimer = &__raw_get_cpu_var(watchdog_hrtimer);
 
+	/* kick off the timer for the hardlockup detector */
+	hrtimer_init(hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	hrtimer->function = watchdog_timer_fn;
+
 	if (!watchdog_enabled) {
 		kthread_park(current);
 		return;
@@ -351,10 +355,6 @@ static void watchdog_enable(unsigned int cpu)
 	/* Enable the perf event */
 	watchdog_nmi_enable(cpu);
 
-	/* kick off the timer for the hardlockup detector */
-	hrtimer_init(hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
-	hrtimer->function = watchdog_timer_fn;
-
 	/* done here because hrtimer_start can only pin to smp_processor_id() */
 	hrtimer_start(hrtimer, ns_to_ktime(get_sample_period()),
 		      HRTIMER_MODE_REL_PINNED);
@@ -368,9 +368,6 @@ static void watchdog_disable(unsigned int cpu)
 {
 	struct hrtimer *hrtimer = &__raw_get_cpu_var(watchdog_hrtimer);
 
-	if (!watchdog_enabled)
-		return;
-
 	watchdog_set_prio(SCHED_NORMAL, 0);
 	hrtimer_cancel(hrtimer);
 	/* disable the perf event */
-- 
1.7.2.5

