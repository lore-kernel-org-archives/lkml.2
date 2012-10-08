Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018Ab2JHDAL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 23:00:11 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:3676 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751211Ab2JHDAJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 23:00:09 -0400
X-IronPort-AV: E=Sophos;i="4.80,549,1344182400"; 
   d="scan'208";a="5956546"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: mingo@redhat.com, peterz@infradead.org
Cc: miaox@cn.fujitsu.com, wency@cn.fujitsu.com, linux-kernel@vger.kernel.org,
        linux-numa@vger.kernel.org, Tang Chen <tangchen@cn.fujitsu.com>
Subject: [PATCH] Do not use cpu_to_node() to find an offlined cpu's node.
Date: Mon, 8 Oct 2012 10:59:43 +0800
Message-Id: <1349665183-11718-1-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/08 10:57:57,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/08 10:57:59,
	Serialize complete at 2012/10/08 10:57:59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a cpu is offline, its nid will be set to -1, and cpu_to_node(cpu) will
return -1. As a result, cpumask_of_node(nid) will return NULL. In this case,
find_next_bit() in for_each_cpu will get a NULL pointer and cause panic.

Here is a call trace:
[  609.824017] Call Trace:
[  609.824017]  <IRQ> 
[  609.824017]  [<ffffffff810b0721>] select_fallback_rq+0x71/0x190
[  609.824017]  [<ffffffff810b086e>] ? try_to_wake_up+0x2e/0x2f0
[  609.824017]  [<ffffffff810b0b0b>] try_to_wake_up+0x2cb/0x2f0
[  609.824017]  [<ffffffff8109da08>] ? __run_hrtimer+0x78/0x320
[  609.824017]  [<ffffffff810b0b85>] wake_up_process+0x15/0x20
[  609.824017]  [<ffffffff8109ce62>] hrtimer_wakeup+0x22/0x30
[  609.824017]  [<ffffffff8109da13>] __run_hrtimer+0x83/0x320
[  609.824017]  [<ffffffff8109ce40>] ? update_rmtp+0x80/0x80
[  609.824017]  [<ffffffff8109df56>] hrtimer_interrupt+0x106/0x280
[  609.824017]  [<ffffffff810a72c8>] ? sd_free_ctl_entry+0x68/0x70
[  609.824017]  [<ffffffff8167cf39>] smp_apic_timer_interrupt+0x69/0x99
[  609.824017]  [<ffffffff8167be2f>] apic_timer_interrupt+0x6f/0x80

There is a hrtimer process sleeping, whose cpu has already been offlined.
When it is waken up, it tries to find another cpu to run, and get a -1 nid.
As a result, cpumask_of_node(-1) returns NULL, and causes ernel panic.

This patch fixes this problem by judging if the nid is -1.
If nid is not -1, a cpu on the same node will be picked.
Else, a online cpu on another node will be picked.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 kernel/sched/core.c |   24 +++++++++++++++---------
 1 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 66b36ab..e76dce9 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1263,18 +1263,24 @@ EXPORT_SYMBOL_GPL(kick_process);
  */
 static int select_fallback_rq(int cpu, struct task_struct *p)
 {
-	const struct cpumask *nodemask = cpumask_of_node(cpu_to_node(cpu));
+	int nid = cpu_to_node(cpu);
+	const struct cpumask *nodemask = NULL;
 	enum { cpuset, possible, fail } state = cpuset;
 	int dest_cpu;
 
-	/* Look for allowed, online CPU in same node. */
-	for_each_cpu(dest_cpu, nodemask) {
-		if (!cpu_online(dest_cpu))
-			continue;
-		if (!cpu_active(dest_cpu))
-			continue;
-		if (cpumask_test_cpu(dest_cpu, tsk_cpus_allowed(p)))
-			return dest_cpu;
+	/* If the cpu has been offlined, its nid was set to -1. */
+	if (nid != -1) {
+		nodemask = cpumask_of_node(nid);
+
+		/* Look for allowed, online CPU in same node. */
+		for_each_cpu(dest_cpu, nodemask) {
+			if (!cpu_online(dest_cpu))
+				continue;
+			if (!cpu_active(dest_cpu))
+				continue;
+			if (cpumask_test_cpu(dest_cpu, tsk_cpus_allowed(p)))
+				return dest_cpu;
+		}
 	}
 
 	for (;;) {
-- 
1.7.1

