Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655Ab0LHUlg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 15:41:36 -0500
Received: from hera.kernel.org ([140.211.167.34]:34582 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756341Ab0LHUle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 15:41:34 -0500
Date: Wed, 8 Dec 2010 20:41:05 GMT
From: tip-bot for Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, heiko.carstens@de.ibm.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, heiko.carstens@de.ibm.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20101201091109.GA8984@osiris.boeblingen.de.ibm.com>
References: <20101201091109.GA8984@osiris.boeblingen.de.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] nohz: Fix get_next_timer_interrupt() vs cpu hotplug
Message-ID: <tip-dbd87b5af055a0cc9bba17795c9a2b0d17795389@git.kernel.org>
Git-Commit-ID: dbd87b5af055a0cc9bba17795c9a2b0d17795389
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 08 Dec 2010 20:41:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dbd87b5af055a0cc9bba17795c9a2b0d17795389
Gitweb:     http://git.kernel.org/tip/dbd87b5af055a0cc9bba17795c9a2b0d17795389
Author:     Heiko Carstens <heiko.carstens@de.ibm.com>
AuthorDate: Wed, 1 Dec 2010 10:11:09 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 8 Dec 2010 20:15:07 +0100

nohz: Fix get_next_timer_interrupt() vs cpu hotplug

This fixes a bug as seen on 2.6.32 based kernels where timers got
enqueued on offline cpus.

If a cpu goes offline it might still have pending timers. These will
be migrated during CPU_DEAD handling after the cpu is offline.
However while the cpu is going offline it will schedule the idle task
which will then call tick_nohz_stop_sched_tick().

That function in turn will call get_next_timer_intterupt() to figure
out if the tick of the cpu can be stopped or not. If it turns out that
the next tick is just one jiffy off (delta_jiffies == 1)
tick_nohz_stop_sched_tick() incorrectly assumes that the tick should
not stop and takes an early exit and thus it won't update the load
balancer cpu.

Just afterwards the cpu will be killed and the load balancer cpu could
be the offline cpu.

On 2.6.32 based kernel get_nohz_load_balancer() gets called to decide
on which cpu a timer should be enqueued (see __mod_timer()). Which
leads to the possibility that timers get enqueued on an offline cpu.
These will never expire and can cause a system hang.

This has been observed 2.6.32 kernels. On current kernels
__mod_timer() uses get_nohz_timer_target() which doesn't have that
problem. However there might be other problems because of the too
early exit tick_nohz_stop_sched_tick() in case a cpu goes offline.

The easiest and probably safest fix seems to be to let
get_next_timer_interrupt() just lie and let it say there isn't any
pending timer if the current cpu is offline.

I also thought of moving migrate_[hr]timers() from CPU_DEAD to
CPU_DYING, but seeing that there already have been fixes at least in
the hrtimer code in this area I'm afraid that this could add new
subtle bugs.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20101201091109.GA8984@osiris.boeblingen.de.ibm.com>
Cc: stable@kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/timer.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index 7bd715f..353b922 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1252,6 +1252,12 @@ unsigned long get_next_timer_interrupt(unsigned long now)
 	struct tvec_base *base = __get_cpu_var(tvec_bases);
 	unsigned long expires;
 
+	/*
+	 * Pretend that there is no timer pending if the cpu is offline.
+	 * Possible pending timers will be migrated later to an active cpu.
+	 */
+	if (cpu_is_offline(smp_processor_id()))
+		return now + NEXT_TIMER_MAX_DELTA;
 	spin_lock(&base->lock);
 	if (time_before_eq(base->next_timer, base->timer_jiffies))
 		base->next_timer = __next_timer_interrupt(base);
