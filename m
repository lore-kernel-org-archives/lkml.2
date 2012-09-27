Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025Ab2I0KbS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 06:31:18 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:50610 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468Ab2I0KbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 06:31:17 -0400
MIME-Version: 1.0
In-Reply-To: <169feed8cddec1edecb311d2471df0a553d6e865.1348736069.git.viresh.kumar@linaro.org>
References: <cover.1348736069.git.viresh.kumar@linaro.org>
	<169feed8cddec1edecb311d2471df0a553d6e865.1348736069.git.viresh.kumar@linaro.org>
Date: Thu, 27 Sep 2012 16:01:16 +0530
Message-ID: <CAKohpo=OQd5jqPoK_gPsvEO3dFhUN=AnMAdDLnqNWbDQdBDFng@mail.gmail.com>
Subject: Re: [PATCH V2 2/3] timer: hrtimer: Don't check idle_cpu() before
 calling get_nohz_timer_target()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: pjt@google.com, paul.mckenney@linaro.org, tglx@linutronix.de,
        tj@kernel.org, suresh.b.siddha@intel.com, venki@google.com,
        mingo@redhat.com, peterz@infradead.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Arvind.Chauhan@arm.com,
        amit.kucheria@linaro.org, vincent.guittot@linaro.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 September 2012 14:34, Viresh Kumar <viresh.kumar@linaro.org> wrote:

>  #if defined(CONFIG_NO_HZ) && defined(CONFIG_SMP)
> -       if (!pinned && get_sysctl_timer_migration() && idle_cpu(cpu))
> +       if (!pinned && get_sysctl_timer_migration())
>                 cpu = get_nohz_timer_target();
>  #endif
> +       if (!cpu)
> +               cpu = smp_processor_id();

Ahh... Bad change... cpu can be returned as zero by get_nohz_timer_target().

Please consider below patch here:

------------8<-------------


Subject: [PATCH] timer: hrtimer: Don't check idle_cpu() before calling
 get_nohz_timer_target()

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
@@ -159,7 +159,7 @@ struct hrtimer_clock_base *lock_hrtimer_base(const
struct hrtimer *timer,
 static int hrtimer_get_target(int this_cpu, int pinned)
 {
 #ifdef CONFIG_NO_HZ
-	if (!pinned && get_sysctl_timer_migration() && idle_cpu(this_cpu))
+	if (!pinned && get_sysctl_timer_migration())
 		return get_nohz_timer_target();
 #endif
 	return this_cpu;
diff --git a/kernel/timer.c b/kernel/timer.c
index d5de1b2..db57606 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -733,11 +733,13 @@ __mod_timer(struct timer_list *timer, unsigned
long expires,

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
