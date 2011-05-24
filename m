Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757075Ab1EXD6n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 23:58:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:59525 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753148Ab1EXD6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 23:58:42 -0400
Date: Tue, 24 May 2011 03:58:20 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Message-ID: <tip-6e9101aeec39961308176e0f59e73ac5d37d243a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, msb@chromium.org, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, marcin.slusarz@gmail.com,
        fweisbec@gmail.com, tglx@linutronix.de, sfr@canb.auug.org.au,
        mingo@elte.hu, dzickus@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, msb@chromium.org,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        marcin.slusarz@gmail.com, fweisbec@gmail.com, sfr@canb.auug.org.au,
        tglx@linutronix.de, dzickus@redhat.com, mingo@elte.hu
In-Reply-To: <20110517071642.GF22305@elte.hu>
References: <20110524134129.8da27016.sfr@canb.auug.org.au>
	<20110517071642.GF22305@elte.hu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] watchdog: Fix non-standard prototype of get_softlockup_thresh()
Git-Commit-ID: 6e9101aeec39961308176e0f59e73ac5d37d243a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 24 May 2011 03:58:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6e9101aeec39961308176e0f59e73ac5d37d243a
Gitweb:     http://git.kernel.org/tip/6e9101aeec39961308176e0f59e73ac5d37d243a
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Tue, 24 May 2011 05:43:18 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 24 May 2011 05:53:39 +0200

watchdog: Fix non-standard prototype of get_softlockup_thresh()

This build warning slipped through:

  kernel/watchdog.c:102: warning: function declaration isn't a prototype

As reported by Stephen Rothwell.

Also address an unused variable warning that GCC 4.6.0 reports:
we cannot do anything about failed watchdog ops during CPU hotplug
(it's not serious enough to return an error from the notifier),
so ignore them.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mandeep Singh Baines <msb@chromium.org>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/20110524134129.8da27016.sfr@canb.auug.org.au
Signed-off-by: Ingo Molnar <mingo@elte.hu>
LKML-Reference: <20110517071642.GF22305@elte.hu>
---
 kernel/watchdog.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 6e63097..3d0c56a 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -98,7 +98,7 @@ __setup("nosoftlockup", nosoftlockup_setup);
  * the thresholds with a factor: we make the soft threshold twice the amount of
  * time the hard threshold is.
  */
-static int get_softlockup_thresh()
+static int get_softlockup_thresh(void)
 {
 	return watchdog_thresh * 2;
 }
@@ -415,15 +415,13 @@ static void watchdog_nmi_disable(int cpu) { return; }
 #endif /* CONFIG_HARDLOCKUP_DETECTOR */
 
 /* prepare/enable/disable routines */
-static int watchdog_prepare_cpu(int cpu)
+static void watchdog_prepare_cpu(int cpu)
 {
 	struct hrtimer *hrtimer = &per_cpu(watchdog_hrtimer, cpu);
 
 	WARN_ON(per_cpu(softlockup_watchdog, cpu));
 	hrtimer_init(hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	hrtimer->function = watchdog_timer_fn;
-
-	return 0;
 }
 
 static int watchdog_enable(int cpu)
@@ -542,17 +540,16 @@ static int __cpuinit
 cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 {
 	int hotcpu = (unsigned long)hcpu;
-	int err = 0;
 
 	switch (action) {
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
-		err = watchdog_prepare_cpu(hotcpu);
+		watchdog_prepare_cpu(hotcpu);
 		break;
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
 		if (watchdog_enabled)
-			err = watchdog_enable(hotcpu);
+			watchdog_enable(hotcpu);
 		break;
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_UP_CANCELED:
