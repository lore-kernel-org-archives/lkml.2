Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350Ab0EaHUc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 03:20:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:44436 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756346Ab0EaHU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 03:20:27 -0400
Date: Mon, 31 May 2010 07:18:52 GMT
From: "tip-bot for Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, ego@in.ibm.com, aarora@linux.vnet.ibm.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, tj@kernel.org,
       tglx@linutronix.de, aarora@in.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, aarora@linux.vnet.ibm.com,
       ego@in.ibm.com, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tj@kernel.org, tglx@linutronix.de, aarora@in.ibm.com, mingo@elte.hu
In-Reply-To: <20100525132346.GA14986@amitarora.in.ibm.com>
References: <20100525132346.GA14986@amitarora.in.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Make sure timers have migrated before killing the migration_thread
Message-ID: <tip-54e88fad223c4e1d94289611a90c7fe3ebe5631b@git.kernel.org>
Git-Commit-ID: 54e88fad223c4e1d94289611a90c7fe3ebe5631b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 31 May 2010 07:18:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  54e88fad223c4e1d94289611a90c7fe3ebe5631b
Gitweb:     http://git.kernel.org/tip/54e88fad223c4e1d94289611a90c7fe3ebe5631b
Author:     Amit K. Arora <aarora@linux.vnet.ibm.com>
AuthorDate: Tue, 25 May 2010 18:53:46 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 31 May 2010 08:37:44 +0200

sched: Make sure timers have migrated before killing the migration_thread

Problem: In a stress test where some heavy tests were running along with
regular CPU offlining and onlining, a hang was observed. The system seems
to be hung at a point where migration_call() tries to kill the
migration_thread of the dying CPU, which just got moved to the current
CPU. This migration thread does not get a chance to run (and die) since
rt_throttled is set to 1 on current, and it doesn't get cleared as the
hrtimer which is supposed to reset the rt bandwidth
(sched_rt_period_timer) is tied to the CPU which we just marked dead!

Solution: This patch pushes the killing of migration thread to
"CPU_POST_DEAD" event. By then all the timers (including
sched_rt_period_timer) should have got migrated (along with other
callbacks).

Signed-off-by: Amit Arora <aarora@in.ibm.com>
Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <20100525132346.GA14986@amitarora.in.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/stop_machine.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index b4e7431..70f8d90 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -321,7 +321,7 @@ static int __cpuinit cpu_stop_cpu_callback(struct notifier_block *nfb,
 
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_UP_CANCELED:
-	case CPU_DEAD:
+	case CPU_POST_DEAD:
 	{
 		struct cpu_stop_work *work;
 
