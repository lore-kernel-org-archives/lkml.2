Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126Ab1HOPyL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 11:54:11 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:58289 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093Ab1HOPyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 11:54:09 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Menage <menage@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: [PATCH 26/32] nohz/cpuset: Flush cputime on threads in nohz cpusets when waiting leader
Date: Mon, 15 Aug 2011 17:52:23 +0200
Message-Id: <1313423549-27093-27-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we wait for a zombie task, flush the cputimes on nohz cpusets
in case we are waiting for a group leader that has threads running
in nohz CPUs. This way thread_group_times() doesn't report stale
values.

<doubts>
If I understood well the code, by the time we call that thread_group_times(),
we may have childs that are still running, so this is necessary.
But I need to check deeper.
</doubts>

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Anton Blanchard <anton@au1.ibm.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Paul E . McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tim Pepper <lnxninja@linux.vnet.ibm.com>
---
 kernel/exit.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index f2b321b..43fb9ac 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -51,6 +51,7 @@
 #include <trace/events/sched.h>
 #include <linux/hw_breakpoint.h>
 #include <linux/oom.h>
+#include <linux/cpuset.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
@@ -1262,6 +1263,7 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 		 * group, which consolidates times for all threads in the
 		 * group including the group leader.
 		 */
+		cpuset_nohz_flush_cputimes();
 		thread_group_times(p, &tgutime, &tgstime);
 		spin_lock_irq(&p->real_parent->sighand->siglock);
 		psig = p->real_parent->signal;
-- 
1.7.5.4

