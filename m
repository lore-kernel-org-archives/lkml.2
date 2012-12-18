Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493Ab2LRINq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 03:13:46 -0500
Received: from canardo.mork.no ([148.122.252.1]:59518 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754209Ab2LRINo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 03:13:44 -0500
From: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Don Zickus <dzickus@redhat.com>, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Norbert Warmuth <nwarmuth@t-online.de>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [regression][PATCH v3] watchdog: Fix disable/enable regression
Date: Tue, 18 Dec 2012 09:13:09 +0100
Message-Id: <1355818389-18717-1-git-send-email-bjorn@mork.no>
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

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=51661

Cc: <stable@vger.kernel.org> # v3.7
Cc: Norbert Warmuth <nwarmuth@t-online.de>
Cc: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
---
v3:
  added Bugzilla reference and additional recipients
  rebased on current mainline
v2:
  implemented an alternate workaround for the original problem.

Hello,

Sorry for nagging, but this patch or some other fix should be applied
to mainline ASAP so it can be included in the 3.7 stable series. 3.7.0
and 3.7.1 dies when plugging AC power on a large number of laptop
systems.

I will not claim to understand this code, but it seemed to me like the
original problem was caused by the missing initialization of the hrtimer
in the disabled case. Calling hrtimer_cancel() on an initialized timer
not running should be perfectly OK.  And watchdog_nmi_disable() will 
not do anything unless the event is initialized.  So this patch looks
like a fix.

At least it survives both the original test cases and the post v3.7-rc8
regression test case.


Bjørn

 kernel/watchdog.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 997c6a1..75a2ab3 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -344,6 +344,10 @@ static void watchdog_enable(unsigned int cpu)
 {
 	struct hrtimer *hrtimer = &__raw_get_cpu_var(watchdog_hrtimer);
 
+	/* kick off the timer for the hardlockup detector */
+	hrtimer_init(hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	hrtimer->function = watchdog_timer_fn;
+
 	if (!watchdog_enabled) {
 		kthread_park(current);
 		return;
@@ -352,10 +356,6 @@ static void watchdog_enable(unsigned int cpu)
 	/* Enable the perf event */
 	watchdog_nmi_enable(cpu);
 
-	/* kick off the timer for the hardlockup detector */
-	hrtimer_init(hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
-	hrtimer->function = watchdog_timer_fn;
-
 	/* done here because hrtimer_start can only pin to smp_processor_id() */
 	hrtimer_start(hrtimer, ns_to_ktime(sample_period),
 		      HRTIMER_MODE_REL_PINNED);
@@ -369,9 +369,6 @@ static void watchdog_disable(unsigned int cpu)
 {
 	struct hrtimer *hrtimer = &__raw_get_cpu_var(watchdog_hrtimer);
 
-	if (!watchdog_enabled)
-		return;
-
 	watchdog_set_prio(SCHED_NORMAL, 0);
 	hrtimer_cancel(hrtimer);
 	/* disable the perf event */
-- 
1.7.10.4

