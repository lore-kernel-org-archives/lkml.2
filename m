Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759147Ab2J3MYy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 08:24:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41288 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440Ab2J3MYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 08:24:51 -0400
Date: Tue, 30 Oct 2012 05:23:44 -0700
From: tip-bot for Michael Neuling <mikey@neuling.org>
Message-ID: <tip-0d855354ea351bec6b222e9fea86a876cfafdcb6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, michael@ellerman.id.au, bookjovi@gmail.com,
        tglx@linutronix.de, mikey@neuling.org, prasad@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, michael@ellerman.id.au, bookjovi@gmail.com,
        tglx@linutronix.de, prasad@linux.vnet.ibm.com, mikey@neuling.org
In-Reply-To: <1351268936-2956-1-git-send-email-fweisbec@gmail.com>
References: <1351268936-2956-1-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf, powerpc:
  Fix hw breakpoints returning -ENOSPC
Git-Commit-ID: 0d855354ea351bec6b222e9fea86a876cfafdcb6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 30 Oct 2012 05:23:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0d855354ea351bec6b222e9fea86a876cfafdcb6
Gitweb:     http://git.kernel.org/tip/0d855354ea351bec6b222e9fea86a876cfafdcb6
Author:     Michael Neuling <mikey@neuling.org>
AuthorDate: Fri, 26 Oct 2012 18:28:56 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 30 Oct 2012 10:07:58 +0100

perf, powerpc: Fix hw breakpoints returning -ENOSPC

I've been trying to get hardware breakpoints with perf to work
on POWER7 but I'm getting the following:

  % perf record -e mem:0x10000000 true

    Error: sys_perf_event_open() syscall returned with 28 (No space left on device).  /bin/dmesg may provide additional information.

    Fatal: No CONFIG_PERF_EVENTS=y kernel support configured?

  true: Terminated

(FWIW adding -a and it works fine)

Debugging it seems that __reserve_bp_slot() is returning ENOSPC
because it thinks there are no free breakpoint slots on this
CPU.

I have a 2 CPUs, so perf userspace is doing two perf_event_open
syscalls to add a counter to each CPU [1].  The first syscall
succeeds but the second is failing.

On this second syscall, fetch_bp_busy_slots() sets slots.pinned
to be 1, despite there being no breakpoint on this CPU.  This is
because the call the task_bp_pinned, checks all CPUs, rather
than just the current CPU. POWER7 only has one hardware
breakpoint per CPU (ie. HBP_NUM=1), so we return ENOSPC.

The following patch fixes this by checking the associated CPU
for each breakpoint in task_bp_pinned.  I'm not familiar with
this code, so it's provided as a reference to the above issue.

Signed-off-by: Michael Neuling <mikey@neuling.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Michael Ellerman <michael@ellerman.id.au>
Cc: Jovi Zhang <bookjovi@gmail.com>
Cc: K Prasad <prasad@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1351268936-2956-1-git-send-email-fweisbec@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/hw_breakpoint.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
index 9a7b487..fe8a916 100644
--- a/kernel/events/hw_breakpoint.c
+++ b/kernel/events/hw_breakpoint.c
@@ -111,14 +111,16 @@ static unsigned int max_task_bp_pinned(int cpu, enum bp_type_idx type)
  * Count the number of breakpoints of the same type and same task.
  * The given event must be not on the list.
  */
-static int task_bp_pinned(struct perf_event *bp, enum bp_type_idx type)
+static int task_bp_pinned(int cpu, struct perf_event *bp, enum bp_type_idx type)
 {
 	struct task_struct *tsk = bp->hw.bp_target;
 	struct perf_event *iter;
 	int count = 0;
 
 	list_for_each_entry(iter, &bp_task_head, hw.bp_list) {
-		if (iter->hw.bp_target == tsk && find_slot_idx(iter) == type)
+		if (iter->hw.bp_target == tsk &&
+		    find_slot_idx(iter) == type &&
+		    cpu == iter->cpu)
 			count += hw_breakpoint_weight(iter);
 	}
 
@@ -141,7 +143,7 @@ fetch_bp_busy_slots(struct bp_busy_slots *slots, struct perf_event *bp,
 		if (!tsk)
 			slots->pinned += max_task_bp_pinned(cpu, type);
 		else
-			slots->pinned += task_bp_pinned(bp, type);
+			slots->pinned += task_bp_pinned(cpu, bp, type);
 		slots->flexible = per_cpu(nr_bp_flexible[type], cpu);
 
 		return;
@@ -154,7 +156,7 @@ fetch_bp_busy_slots(struct bp_busy_slots *slots, struct perf_event *bp,
 		if (!tsk)
 			nr += max_task_bp_pinned(cpu, type);
 		else
-			nr += task_bp_pinned(bp, type);
+			nr += task_bp_pinned(cpu, bp, type);
 
 		if (nr > slots->pinned)
 			slots->pinned = nr;
@@ -188,7 +190,7 @@ static void toggle_bp_task_slot(struct perf_event *bp, int cpu, bool enable,
 	int old_idx = 0;
 	int idx = 0;
 
-	old_count = task_bp_pinned(bp, type);
+	old_count = task_bp_pinned(cpu, bp, type);
 	old_idx = old_count - 1;
 	idx = old_idx + weight;
 
