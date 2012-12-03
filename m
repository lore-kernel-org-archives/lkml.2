Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab2LCM1F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 07:27:05 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:44337 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831Ab2LCM1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 07:27:02 -0500
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        peterz@infradead.org, mingo@kernel.org
Cc: ccross@android.com, Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH Resend 1/3] sched: fix nr_busy_cpus with coupled cpuidle
Date: Mon,  3 Dec 2012 13:26:26 +0100
Message-Id: <1354537588-25831-2-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1354537588-25831-1-git-send-email-vincent.guittot@linaro.org>
References: <1354537588-25831-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the coupled cpuidle driver (but probably also with other drivers),
a CPU loops in a temporary safe state while waiting for other CPUs of its
cluster to be ready to enter the coupled C-state. If an IRQ or a softirq
occurs, the CPU will stay in this internal loop if there is no need
to resched. The SCHED softirq clears the NOHZ and increases
nr_busy_cpus. If there is no need to resched, we will not call
set_cpu_sd_state_idle because of this internal loop in a cpuidle state.
We have to call set_cpu_sd_state_idle in tick_nohz_irq_exit which is used
to handle such situation.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/time/tick-sched.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 955d35b..b8d74ea 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -570,6 +570,8 @@ void tick_nohz_irq_exit(void)
 	if (!ts->inidle)
 		return;
 
+	set_cpu_sd_state_idle();
+
 	/* Cancel the timer because CPU already waken up from the C-states*/
 	menu_hrtimer_cancel();
 	__tick_nohz_idle_enter(ts);
-- 
1.7.9.5

