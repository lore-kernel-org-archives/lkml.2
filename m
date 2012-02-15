Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275Ab2BOTkK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 14:40:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53108 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755227Ab2BOTkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 14:40:05 -0500
Date: Wed, 15 Feb 2012 11:39:20 -0800
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Message-ID: <tip-0a8a2e78b7eece7c65884fcff9f98dc0fce89ee4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, john.stultz@linaro.org, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: john.stultz@linaro.org, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1327427984-23282-3-git-send-email-fweisbec@gmail.com>
References: <1327427984-23282-3-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] timer: Fix bad idle check on irq entry
Git-Commit-ID: 0a8a2e78b7eece7c65884fcff9f98dc0fce89ee4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 15 Feb 2012 11:39:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0a8a2e78b7eece7c65884fcff9f98dc0fce89ee4
Gitweb:     http://git.kernel.org/tip/0a8a2e78b7eece7c65884fcff9f98dc0fce89ee4
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Tue, 24 Jan 2012 18:59:44 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 15 Feb 2012 15:23:09 +0100

timer: Fix bad idle check on irq entry

idle_cpu() is called on irq entry to guess if we need to call
tick_check_idle(). This way we can catch up with jiffies if the tick
was stopped, stop accounting idle time during the interrupt and
maintain the sched clock if it is unstable.

But if we are going to exit the idle loop to schedule a new task (ie:
if we have a task in the runqueue or a remotely enqueued ttwu to
perform), the idle_cpu() check will return 0 such that we miss the
call to tick_check_idle() for all interrupts happening before we
schedule the new task.

As a result these interrupts and the softirqs coming along may deal
with stale jiffies values, bad sched clock values, and won't substract
their time from the idle time accounting.

Fix this with using is_idle_task() instead that strictly checks that
we are running the idle task, without caring about the fact we are
going to schedule a task soon.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Ingo Molnar <mingo@elte.hu>
Link: http://lkml.kernel.org/r/1327427984-23282-3-git-send-email-fweisbec@gmail.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/softirq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index 4eb3a0f..5ace266 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -297,7 +297,7 @@ void irq_enter(void)
 	int cpu = smp_processor_id();
 
 	rcu_irq_enter();
-	if (idle_cpu(cpu) && !in_interrupt()) {
+	if (is_idle_task(current) && !in_interrupt()) {
 		/*
 		 * Prevent raise_softirq from needlessly waking up ksoftirqd
 		 * here, as softirq will be serviced on return from interrupt.
