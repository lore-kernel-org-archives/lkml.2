Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788Ab0HBTtK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 15:49:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:47157 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754628Ab0HBTtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 15:49:08 -0400
Date: Mon, 2 Aug 2010 19:48:47 GMT
From: tip-bot for Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, arjan@infradead.org, hpa@zytor.com,
        mingo@redhat.com, arjan@linux.intel.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, arjan@infradead.org,
        linux-kernel@vger.kernel.org, arjan@linux.intel.com,
        tglx@linutronix.de
In-Reply-To: <20100727210210.58d3118c@infradead.org>
References: <20100727210210.58d3118c@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] clockevents: Remove the per cpu tick skew
Message-ID: <tip-af5ab277ded04bd9bc6b048c5a2f0e7d70ef0867@git.kernel.org>
Git-Commit-ID: af5ab277ded04bd9bc6b048c5a2f0e7d70ef0867
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 02 Aug 2010 19:48:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  af5ab277ded04bd9bc6b048c5a2f0e7d70ef0867
Gitweb:     http://git.kernel.org/tip/af5ab277ded04bd9bc6b048c5a2f0e7d70ef0867
Author:     Arjan van de Ven <arjan@infradead.org>
AuthorDate: Tue, 27 Jul 2010 21:02:10 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 2 Aug 2010 21:45:58 +0200

clockevents: Remove the per cpu tick skew

Historically, Linux has tried to make the regular timer tick on the
various CPUs not happen at the same time, to avoid contention on
xtime_lock.

Nowadays, with the tickless kernel, this contention no longer happens
since time keeping and updating are done differently. In addition,
this skew is actually hurting power consumption in a measurable way on
many-core systems.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
LKML-Reference: <20100727210210.58d3118c@infradead.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 kernel/time/tick-sched.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 813993b..74644cc 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -780,7 +780,6 @@ void tick_setup_sched_timer(void)
 {
 	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
 	ktime_t now = ktime_get();
-	u64 offset;
 
 	/*
 	 * Emulate tick processing via per-CPU hrtimers:
@@ -790,10 +789,6 @@ void tick_setup_sched_timer(void)
 
 	/* Get the next period (per cpu) */
 	hrtimer_set_expires(&ts->sched_timer, tick_init_jiffy_update());
-	offset = ktime_to_ns(tick_period) >> 1;
-	do_div(offset, num_possible_cpus());
-	offset *= smp_processor_id();
-	hrtimer_add_expires_ns(&ts->sched_timer, offset);
 
 	for (;;) {
 		hrtimer_forward(&ts->sched_timer, now, tick_period);
