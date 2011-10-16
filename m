Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751340Ab1JPK5S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 06:57:18 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63148 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027Ab1JPK5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 06:57:11 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-rt-users@vger.kernel.org, tglx@linutronix.de
Subject: [PATCH -rt 2/5] hotplug: Call cpu_unplug_begin() a little early
Date: Sun, 16 Oct 2011 18:56:44 +0800
Message-Id: <1318762607-2261-3-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1318762607-2261-1-git-send-email-yong.zhang0@gmail.com>
References: <1318762607-2261-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpu_unplug_begin() should be called before CPU_DOWN_PREPARE,
because at CPU_DOWN_PREPARE cpu_active is cleared and sched_domain
is rebuilt, it will finally lead to thread 'sync_unplug' will
be running on the cpu on which it's created.

I found by an incorrect warning on smp_processor_id() called by
sync_unplug/1, and trace shows below:
(echo 1 > /sys/device/system/cpu/cpu1/online)
  bash-1664  [000]    83.136620: _cpu_down: Bind sync_unplug to cpu 1
  bash-1664  [000]    83.136623: sched_wait_task: comm=sync_unplug/1 pid=1724 prio=120
  bash-1664  [000]    83.136624: _cpu_down: Wake sync_unplug
  bash-1664  [000]    83.136629: sched_wakeup: comm=sync_unplug/1 pid=1724 prio=120 success=1 target_cpu=000

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
---
 kernel/cpu.c |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 83fb084..13066a3 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -337,22 +337,20 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 		return -EBUSY;
 	}
 
-	err = __cpu_notify(CPU_DOWN_PREPARE | mod, hcpu, -1, &nr_calls);
+	cpu_hotplug_begin();
+	err = cpu_unplug_begin(cpu);
 	if (err) {
-		nr_calls--;
-		__cpu_notify(CPU_DOWN_FAILED | mod, hcpu, nr_calls, NULL);
-		printk("%s: attempt to take down CPU %u failed\n",
-				__func__, cpu);
+		printk("cpu_unplug_begin(%d) failed\n", cpu);
 		goto out_cancel;
 	}
 
-	cpu_hotplug_begin();
-	err = cpu_unplug_begin(cpu);
+	err = __cpu_notify(CPU_DOWN_PREPARE | mod, hcpu, -1, &nr_calls);
 	if (err) {
 		nr_calls--;
 		__cpu_notify(CPU_DOWN_FAILED | mod, hcpu, nr_calls, NULL);
-		printk("cpu_unplug_begin(%d) failed\n", cpu);
-		goto out_cancel;
+		printk("%s: attempt to take down CPU %u failed\n",
+				__func__, cpu);
+		goto out_release;
 	}
 
 	err = __stop_machine(take_cpu_down, &tcd_param, cpumask_of(cpu));
-- 
1.7.1

