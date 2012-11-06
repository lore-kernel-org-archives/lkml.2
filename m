Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037Ab2KFKjU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 05:39:20 -0500
Received: from service87.mimecast.com ([91.220.42.44]:41225 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab2KFKjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 05:39:05 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: pjt@google.com, paul.mckenney@linaro.org, tglx@linutronix.de,
        tj@kernel.org, suresh.b.siddha@intel.com, venki@google.com,
        mingo@redhat.com, peterz@infradead.org, rostedt@goodmis.org
Cc: Arvind.Chauhan@arm.com, linaro-dev@lists.linaro.org, patches@linaro.org,
        pdsw-power-team@arm.com, linux-kernel@vger.kernel.org,
        linux-rt-users@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 Resend 2/4] timer: hrtimer: Don't check idle_cpu() before calling get_nohz_timer_target()
Date: Tue,  6 Nov 2012 16:08:44 +0530
Message-Id: <5caa3dab5feb7cc3d78b4f9a19dbb24401796b53.1352196505.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1352196505.git.viresh.kumar@linaro.org>
References: <cover.1352196505.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1352196505.git.viresh.kumar@linaro.org>
References: <cover.1352196505.git.viresh.kumar@linaro.org>
X-OriginalArrivalTime: 06 Nov 2012 10:38:55.0124 (UTC) FILETIME=[EB8DB540:01CDBC0A]
X-MC-Unique: 112110610385633701
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id qA6AdOpM014379

Check for current cpu's idleness already done in implementation of
sched_select_cpu() which is called by get_nohz_timer_target(). So, no need to
call idle_cpu() twice, once from sched_select_cpu() and once from timer and
hrtimer before calling get_nohz_timer_target().

This patch removes calls to idle_cpu() from timer and hrtimer.

This also reduces an extra call to smp_processor_id() when
get_nohz_timer_target() is called.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/hrtimer.c | 2 +-
 kernel/timer.c   | 8 +++++---
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 6db7a5e..74bdaf6 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -159,7 +159,7 @@ struct hrtimer_clock_base *lock_hrtimer_base(const struct hrtimer *timer,
 static int hrtimer_get_target(int this_cpu, int pinned)
 {
 #ifdef CONFIG_NO_HZ
-	if (!pinned && get_sysctl_timer_migration() && idle_cpu(this_cpu))
+	if (!pinned && get_sysctl_timer_migration())
 		return get_nohz_timer_target();
 #endif
 	return this_cpu;
diff --git a/kernel/timer.c b/kernel/timer.c
index 367d008..1170ece 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -735,11 +735,13 @@ __mod_timer(struct timer_list *timer, unsigned long expires,
 
 	debug_activate(timer, expires);
 
-	cpu = smp_processor_id();
-
 #if defined(CONFIG_NO_HZ) && defined(CONFIG_SMP)
-	if (!pinned && get_sysctl_timer_migration() && idle_cpu(cpu))
+	if (!pinned && get_sysctl_timer_migration())
 		cpu = get_nohz_timer_target();
+	else
+		cpu = smp_processor_id();
+#else
+	cpu = smp_processor_id();
 #endif
 	new_base = per_cpu(tvec_bases, cpu);
 
-- 
1.7.12.rc2.18.g61b472e


