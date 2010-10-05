Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435Ab0JEADu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 20:03:50 -0400
Received: from smtp-out.google.com ([74.125.121.35]:32518 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283Ab0JEADs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 20:03:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=o77ZV5MLTmjQWSzxKWHV9MpGM6Mc63UhHWYEVLLhsouaeP0VvwWeSeoQXw2ty0GAtY
         9ttJtv05/mzJ/d+MzkwQ==
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Venkatesh Pallipadi <venki@google.com>
Subject: Proper kernel irq time accounting -v4
Date: Mon,  4 Oct 2010 17:03:15 -0700
Message-Id: <1286237003-12406-1-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previous versions:
-v0: http://lkml.indiana.edu/hypermail//linux/kernel/1005.3/00411.html
     lkml subject - "Finer granularity and task/cgroup irq time accounting"

-v1: http://lkml.indiana.edu/hypermail//linux/kernel/1007.2/00987.html
     lkml subject - "Finer granularity and task/cgroup irq time accounting"

-v2: http://lkml.indiana.edu/hypermail//linux/kernel/1009.2/00488.html
     lkml subject - "Proper kernel irq time accounting"

-v3: http://lkml.indiana.edu/hypermail//linux/kernel/1009.3/02482.html
     lkml subject - "Proper kernel irq time accounting -v3"


Change from -v3:
- Switch to using sched_clock_cpu instead of sched_clock in
  account_system_vtime. This needed tick_check_idle to be called early in
  irq_enter.
- Do not account softirq time in ksoftirqd context. We want ksoftirqd to
  continue having sched exec_runtime.
- Add a boot option to disable tsc based irq accounting in x86.
- Remove the patch that exported irq times in /proc/interrupts and
  /proc/softirqs. I am relooking at other options to export that and
  will have a replacement patch soon.


Description:
Here is some background information about interrupt time accounting in kernel
and related problems.

Interrupts always run in the context of currently running task. Softirqs mostly
run in the context of currently running task, unless softirqd gets involved.
/proc/interrupts and /proc/softirqs are the interfaces that report the number
of interrupts and softirqs per CPU since boot. /proc/stat has fields that
report per CPU and system-wide interrupt and softirq processing time in
clock_t units.


There are two problems with the way interrupts are accounted by the kernel.

(1) Coarse grained interrupt time reporting
On most archs (except s390, powerpc, ia64 with CONFIG_VIRT_CPU_ACCOUNTING),
the interrupt and softirq time reported in /proc/stat is tick sample based.
Kernel looks at what it is doing at each CPU tick and accounts the entire
tick to that particular activity. This means the data in /proc/stat is
pretty coarse grained.

One related problem (atleast on x86), with recent
"Run irq handlers with interrupts disabled" change, timer interrupt cannot
fire when there is an interrupt being serviced [1]. As a result sampling based
hardirq time in /proc/stat cannot capture any hardirq time at all.

(2) Accounting irq processing time to current task/taskgroup
Whenever irq processing happens, kernel accounts that time to currently
running task. The exec_runtime reported in /proc/<pid>/schedstat and
<cgroup>/cpuacct.usage* includes any irq processing that happened while
the task was running. The scheduler vruntime calculations
also account any irq processing to the current task. This means exec time
accounting during heavy irq processing is kind of random, depending on
when and which CPU processing happens and what task happened to be
running on that CPU at that time.


Solution to (1) involves adding extra timing on irq entry/exit to
get the fine granularity info and then exporting it to user.
The following patchset addresses this problem in a way similar to [2][3].
Keeps most of the code that does the timing generic
(CONFIG_IRQ_TIME_ACCOUNTING), based off of sched_clock(). And adds support for
this in x86. This time is not yet exported to userspace yet. Patch for that
coming soon.

One partial solution proposed in [2][3] for (2) above, was to capture this
interrupt time at task/taskgroup level and let user know how much irq
processing time kernel charged to each task/taskgroup. But, that solution
did not solve task timeslice including irq processing.
Peter Zijlstra and Martin Schwidefsky disagreed with that approach and
wanted to see more complete solution in not accounting irq processing time
to tasks at all.

The patchset below tries this more complete solution, with two scheduler
related changes. First, to take out irq processing time from the time
scheduler accounts to the task. Second, make adjustments to the CPU
power, to account for irq processing activity on the CPU. That in turn
results in irq busy CPU pulling tasks corresponding to its non-irq
processing bandwidth that it has got.

The changes here is only enabled for CONFIG_IRQ_TIME_ACCOUNTING as of now.

Thanks,
Venki

References:

[1] http://lkml.indiana.edu/hypermail//linux/kernel/1005.3/00864.html
    lkml subject - "genirq: Run irq handlers with interrupts disabled"

[2] http://lkml.indiana.edu/hypermail//linux/kernel/1005.3/00411.html
    lkml subject - "Finer granularity and task/cgroup irq time accounting"

[3] http://lkml.indiana.edu/hypermail//linux/kernel/1007.2/00987.html
    lkml subject - "Finer granularity and task/cgroup irq time accounting"

Signed-off-by: Venkatesh Pallipadi <venki@google.com>

