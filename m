Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759528Ab2ANACT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 19:02:19 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55116 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638Ab2ANACS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 19:02:18 -0500
Date: Sat, 14 Jan 2012 00:01:01 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Glauber Costa <glommer@parallels.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [BUG] vmstat reports no interrupts
Message-ID: <20120114000101.GL1068@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running a recent kernel, I'm seeing no interrupt activity being reported
by vmstat on my platforms.  Investigating, it seems to be caused by
this patch merged during the current merge window:

commit 3292beb340c76884427faa1f5d6085719477d889
Author: Glauber Costa <glommer@parallels.com>
Date:   Mon Nov 28 14:45:17 2011 -0200

    sched/accounting: Change cpustat fields to an array

    This patch changes fields in cpustat from a structure, to an
    u64 array. Math gets easier, and the code is more flexible.

    Signed-off-by: Glauber Costa <glommer@parallels.com>
    Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
    Cc: Linus Torvalds <torvalds@linux-foundation.org>
    Cc: Andrew Morton <akpm@linux-foundation.org>
    Cc: Paul Tuner <pjt@google.com>
    Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Link: http://lkml.kernel.org/r/1322498719-2255-2-git-send-email-glommer@parallels.com
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

This patch modifies show_stat() thusly:

        u64 sum = 0;

        for_each_possible_cpu(i) {
...
-               sum += kstat_cpu_irqs_sum(i);
-               sum += arch_irq_stat_cpu(i);

where 'sum' is the first value displayed on /proc/stat's intr line.
However, this file still contains:

#ifndef arch_irq_stat_cpu
#define arch_irq_stat_cpu(cpu) 0
#endif
#ifndef arch_irq_stat
#define arch_irq_stat() 0
#endif
#ifndef arch_idle_time
#define arch_idle_time(cpu) 0
#endif

at the top, and otherwise doesn't reference arch_irq_stat_cpu() anymore.

Although x86 (and only x86) implements arch_irq_stat(), this doesn't
return the total number of interrupts on the system.  Therefore, I
conclude that the same bug that I'm seeing on ARM should be visible on
every other arch, including x86.

I think this commit wasn't meant to delete these.  The patch below
restores vmstat's original behaviour for me.  Please confirm this fix
and submit upstream.

8<====
From: Russell King <rmk+kernel@arm.linux.org.uk>
proc: fix /proc/stat intr sum

Commit 3292beb340c7688 (sched/accounting: Change cpustat fields to an array)
deleted the code which provides us with the sum of all interrupts in
the system, causing vmstat to report zero interrupts occuring in the
system.  Fix this by restoring the code.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Tested-by: Russell King <rmk+kernel@arm.linux.org.uk> [on ARM]
---
 fs/proc/stat.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index d76ca6a..121f77c 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -77,6 +77,8 @@ static int show_stat(struct seq_file *p, void *v)
 		steal += kcpustat_cpu(i).cpustat[CPUTIME_STEAL];
 		guest += kcpustat_cpu(i).cpustat[CPUTIME_GUEST];
 		guest_nice += kcpustat_cpu(i).cpustat[CPUTIME_GUEST_NICE];
+		sum += kstat_cpu_irqs_sum(i);
+		sum += arch_irq_stat_cpu(i);
 
 		for (j = 0; j < NR_SOFTIRQS; j++) {
 			unsigned int softirq_stat = kstat_softirqs_cpu(j, i);

