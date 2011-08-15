Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173Ab1HOPyT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 11:54:19 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46598 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156Ab1HOPyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 11:54:16 -0400
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
Subject: [PATCH 28/32] nohz/cpuset: Flush cputimes for getrusage() and times() syscalls
Date: Mon, 15 Aug 2011 17:52:25 +0200
Message-Id: <1313423549-27093-29-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both syscalls need to iterate through the thread group to get
the cputimes. As some threads of the group may be running on
nohz cpuset, we need to flush the cputimes there.

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
 kernel/sys.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index e4128b2..f6de4b1 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -43,6 +43,7 @@
 #include <linux/syscalls.h>
 #include <linux/kprobes.h>
 #include <linux/user_namespace.h>
+#include <linux/cpuset.h>
 
 #include <linux/kmsg_dump.h>
 
@@ -908,6 +909,8 @@ void do_sys_times(struct tms *tms)
 {
 	cputime_t tgutime, tgstime, cutime, cstime;
 
+	cpuset_nohz_flush_cputimes();
+
 	spin_lock_irq(&current->sighand->siglock);
 	thread_group_times(current, &tgutime, &tgstime);
 	cutime = current->signal->cutime;
@@ -1536,6 +1539,9 @@ static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
 		goto out;
 	}
 
+	/* For thread_group_times */
+	cpuset_nohz_flush_cputimes();
+
 	if (!lock_task_sighand(p, &flags))
 		return;
 
-- 
1.7.5.4

