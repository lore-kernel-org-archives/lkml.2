Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab2I0JFJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 05:05:09 -0400
Received: from service87.mimecast.com ([91.220.42.44]:49452 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab2I0JEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 05:04:41 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: pjt@google.com, paul.mckenney@linaro.org, tglx@linutronix.de,
        tj@kernel.org, suresh.b.siddha@intel.com, venki@google.com,
        mingo@redhat.com, peterz@infradead.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Arvind.Chauhan@arm.com,
        amit.kucheria@linaro.org, vincent.guittot@linaro.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 2/3] timer: hrtimer: Don't check idle_cpu() before calling get_nohz_timer_target()
Date: Thu, 27 Sep 2012 14:34:04 +0530
Message-Id: <169feed8cddec1edecb311d2471df0a553d6e865.1348736069.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1348736069.git.viresh.kumar@linaro.org>
References: <cover.1348736069.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1348736069.git.viresh.kumar@linaro.org>
References: <cover.1348736069.git.viresh.kumar@linaro.org>
X-OriginalArrivalTime: 27 Sep 2012 09:04:16.0943 (UTC) FILETIME=[12920BF0:01CD9C8F]
X-MC-Unique: 112092710043920701
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id q8R95C1t004064

Check for current cpu's idleness already done in implementation of
sched_select_cpu() which is called by get_nohz_timer_target(). So, no need to
call idle_cpu() twice, once from sched_select_cpu() and once from timer and
hrtimer before calling get_nohz_timer_target().

This patch removes calls to idle_cpu() from timer and hrtimer.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/hrtimer.c | 2 +-
 kernel/timer.c   | 9 +++++----
 2 files changed, 6 insertions(+), 5 deletions(-)

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
index d5de1b2..8409d9d 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -720,7 +720,7 @@ __mod_timer(struct timer_list *timer, unsigned long expires,
 {
 	struct tvec_base *base, *new_base;
 	unsigned long flags;
-	int ret = 0 , cpu;
+	int ret = 0 , cpu = 0;
 
 	timer_stats_timer_set_start_info(timer);
 	BUG_ON(!timer->function);
@@ -733,12 +733,13 @@ __mod_timer(struct timer_list *timer, unsigned long expires,
 
 	debug_activate(timer, expires);
 
-	cpu = smp_processor_id();
-
 #if defined(CONFIG_NO_HZ) && defined(CONFIG_SMP)
-	if (!pinned && get_sysctl_timer_migration() && idle_cpu(cpu))
+	if (!pinned && get_sysctl_timer_migration())
 		cpu = get_nohz_timer_target();
 #endif
+	if (!cpu)
+		cpu = smp_processor_id();
+
 	new_base = per_cpu(tvec_bases, cpu);
 
 	if (base != new_base) {
-- 
1.7.12.rc2.18.g61b472e


