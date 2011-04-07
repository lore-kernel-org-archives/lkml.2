Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756333Ab1DGSST (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 14:18:19 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:35827 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753106Ab1DGSSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 14:18:18 -0400
From: Kevin Hilman <khilman@ti.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Cc: linux-pm@lists.linux-foundation.org, Len Brown <lenb@kernel.org>,
        Nicole Chalhoub <n-chalhoub@ti.com>, Vincent Bour <v-bour@ti.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] nohz: delay going tickless under CPU load to favor deeper C states
Date: Thu,  7 Apr 2011 11:18:31 -0700
Message-Id: <1302200311-24263-1-git-send-email-khilman@ti.com>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicole Chalhoub <n-chalhoub@ti.com>

While there is CPU load, continue the periodic tick in order to give
CPUidle another opportunity to pick a deeper C-state instead of
spending potentially long idle times in a shallow C-state.

Long winded version:

When going idle with a high load average, CPUidle menu governor will
decide to pick a shallow C-state since one of the guiding principles
of the menu governor is "The busier the system, the less impact of C
states is acceptable" (taken from cpuidle/governors/menu.c.)  That
makes perfect sense.

However, there are missed power-saving opportunities for bursty
workloads with long idle times (e.g. MP3 playback.)  Given such a
workload, because of the load average, CPUidle tends to pick a shallow
C-state.  Because we also go tickless, this shallow C-state is used
for the duration of the idle period.  If the idle period is long, a
deeper C state would've resulted in better power savings.

This patch delays going tickless when there is a load such that on the
next tick, the CPUidle governor will have another opportunity to to
pick a deeper C-state.  Since the system will have been idle for
potentially a full tick, the load average will drop and a deeper C
state will most likely be chosen.

Delaying NOHZ decisions until the load is zero improved the load
estimation on our ARM/OMAP4 platform where HZ=128 and increased the
time spent in deep C-states (~50% of idle time in C-states deeper than
C1).  A power saving of ~20mA at battery level is observed during MP3
playback on OMAP4/Blaze board.

Signed-off-by: Nicole Chalhoub <n-chalhoub@ti.com>
Signed-off-by: Vincent Bour <v-bour@ti.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
[khilman@ti.com: rework changelog]
Signed-off-by: Kevin Hilman <khilman@ti.com>
---
 kernel/time/tick-sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index d5097c4..418066c 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -324,7 +324,7 @@ void tick_nohz_stop_sched_tick(int inidle)
 	} while (read_seqretry(&xtime_lock, seq));
 
 	if (rcu_needs_cpu(cpu) || printk_needs_cpu(cpu) ||
-	    arch_needs_cpu(cpu)) {
+	    arch_needs_cpu(cpu) || this_cpu_load()) {
 		next_jiffies = last_jiffies + 1;
 		delta_jiffies = 1;
 	} else {
-- 
1.7.4

