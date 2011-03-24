Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab1CXQov (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 12:44:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7521 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907Ab1CXQou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 12:44:50 -0400
Date: Thu, 24 Mar 2011 17:44:36 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>
Cc: oleg@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH,RFC] perf: panic due to inclied cpu context task_ctx value
Message-ID: <20110324164436.GC1930@jolsa.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

following program triggers panic in the current tip tree.
run it like: "while [ 1 ]; do ./ctx ; done"

--- reproducer
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <linux/perf_event.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/syscall.h>

static int trace_event__id(const char *evname)
{
	char *filename;
	int err = -1, fd;

	if (asprintf(&filename,
		     "/sys/kernel/debug/tracing/events/syscalls/%s/id",
		     evname) < 0)
		return -1;

	fd = open(filename, O_RDONLY);
	if (fd >= 0) {
		char id[16];
		if (read(fd, id, sizeof(id)) > 0)
			err = atoi(id);
		close(fd);
	}

	free(filename);
	return err;
}

static inline int
sys_perf_event_open(struct perf_event_attr *attr,
		pid_t pid, int cpu, int group_fd, 
		unsigned long flags)
{       
	attr->size = sizeof(*attr);
	return syscall(__NR_perf_event_open, attr, pid, cpu,
		group_fd, flags);
}

int main(int argc, char **argv)
{
	struct perf_event_attr attr;
#define CPU_MAX 2
	int fd[CPU_MAX], cpu, i, l;
	int id = trace_event__id("sys_enter_open");

	if (id < 0) {
		printf("is debugfs mounted on /sys/kernel/debug?\n");
		return -1;
	}

	memset(&attr, 0, sizeof(attr));
	attr.type = PERF_TYPE_TRACEPOINT;
	attr.config = id;

	for(l = 0; l < 5; l++) {
		for(cpu = 0; cpu < CPU_MAX; cpu++)
			fd[cpu] = sys_perf_event_open(&attr,
				0, cpu, -1, 0);

		for(i = 0; i < 1000; i++) {
			close(open("krava", 0));
		}

		for(cpu = 0; cpu < CPU_MAX; cpu++)
			close(fd[cpu]);
	}

	return 0;
}
---

--- panic msg
[  157.737618] BUG: unable to handle kernel NULL pointer dereference at           (null)
[  157.737618] IP: [<ffffffff81104e9b>] perf_ctx_adjust_freq+0x5b/0x130
[  157.737618] PGD 7835c067 PUD 7be57067 PMD 0 
[  157.737618] Oops: 0000 [#1] SMP 
[  157.737618] last sysfs file: /sys/devices/system/cpu/online
[  157.737618] CPU 1 
[  157.737618] Modules linked in:
[  157.737618] 
[  157.737618] Pid: 2112, comm: perf Not tainted 2.6.38-tip+ #602 Intel Corporation Montevina platform/To be filled by O.E.M.
[  157.737618] RIP: 0010:[<ffffffff81104e9b>]  [<ffffffff81104e9b>] perf_ctx_adjust_freq+0x5b/0x130
[  157.737618] RSP: 0018:ffff88007b483d68  EFLAGS: 00010087
[  157.737618] RAX: 0000000000000000 RBX: ffff880077a811c0 RCX: ffffffff818b32ab
[  157.737618] RDX: 0000000000000000 RSI: 0000000000000082 RDI: ffff880077a811cc
[  157.737618] RBP: ffff88007b483da8 R08: 0000000000000000 R09: 0000000000000000
[  157.737618] R10: 0000000000000000 R11: 0000000000000000 R12: 00000000000f41a8
[  157.737618] R13: fffffffffffffff0 R14: ffff880077a81210 R15: ffff88007b483d70
[  157.737618] FS:  00007fba6834e720(0000) GS:ffff88007b480000(0000) knlGS:0000000000000000
[  157.737618] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  157.737618] CR2: 0000000000000000 CR3: 000000007bf93000 CR4: 00000000000406e0
[  157.737618] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  157.737618] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  157.737618] Process perf (pid: 2112, threadinfo ffff88007be02000, task ffff880076088400)
[  157.737618] Stack:
[  157.737618]  ffff88007b483da8 0000000000000000 0000000000000000 ffff88007b4940d0
[  157.737618]  ffff88007b48e578 ffff880077a811c0 ffff88007b4941a8 0000000000000000
[  157.737618]  ffff88007b483e18 ffffffff811050e7 ffff88007b491540 ffff880000000001
[  157.737618] Call Trace:
[  157.737618]  <IRQ> 
[  157.737618]  [<ffffffff811050e7>] perf_event_task_tick+0x177/0x330
[  157.737618]  [<ffffffff8107b408>] scheduler_tick+0xd8/0x300
[  157.737618]  [<ffffffff81091abe>] update_process_times+0x6e/0x90
[  157.737618]  [<ffffffff810b49a3>] tick_sched_timer+0x93/0xe0
[  157.737618]  [<ffffffff810a7ed1>] __run_hrtimer+0x121/0x250
[  157.737618]  [<ffffffff810b4910>] ? tick_sched_timer+0x0/0xe0
[  157.737618]  [<ffffffff810a832e>] hrtimer_interrupt+0xee/0x210
[  157.737618]  [<ffffffff81514f5b>] smp_apic_timer_interrupt+0x6b/0x9b
[  157.737618]  [<ffffffff81514393>] apic_timer_interrupt+0x13/0x20
[  157.737618]  <EOI> 
[  157.737618]  [<ffffffff8108166b>] ? vprintk+0x22b/0x480
[  157.737618]  [<ffffffff810fe02a>] ? perf_event_read+0x11a/0x120
[  157.737618]  [<ffffffff81508226>] printk+0x41/0x43
[  157.737618]  [<ffffffff810ff5d4>] perf_release+0x34/0xe0
[  157.737618]  [<ffffffff8114e644>] fput+0x124/0x2d0
[  157.737618]  [<ffffffff8114a66b>] filp_close+0x7b/0xd0
[  157.737618]  [<ffffffff8114a75d>] sys_close+0x9d/0x130
[  157.737618]  [<ffffffff81513c02>] tracesys+0xd0/0xd5
[  157.737618] Code: 48 8d 7b 0c e8 d7 66 40 00 48 8b 43 50 48 89 45 c8 4c 8b 6d c8 49 83 ed 10 eb 10 0f 1f 44 00 00 48 89 45 c8 4d 8b 2f 49 83 ed 10 
[  157.737618]  8b 45 10 49 8d 55 10 49 39 d6 0f 18 08 74 55 41 83 7d 58 01 
[  157.737618] RIP  [<ffffffff81104e9b>] perf_ctx_adjust_freq+0x5b/0x130
[  157.737618]  RSP <ffff88007b483d68>
[  157.737618] CR2: 0000000000000000
[  157.737618] ---[ end trace 7175df90a55db905 ]---
---

The reason is task_ctx (struct perf_cpu_context) is holding an invalid
pointer inside perf_rotate_context function.

I think I found the reason and can workaround the issue with attached
patch, but I dont think it's proper solution, and I'm not sure how to fix
this properly ;)


Now here's what I think is happening..

- once an event is created by sys_perf_event_open, task context
  is created and it stays even if the event is closed, until the task
  is finished ... thats what I see in code and I assume it's correct

- when the task opens event, perf_sched_events jump label is incremented
  and following callbacks are started from scheduler

	__perf_event_task_sched_in
	__perf_event_task_sched_out

  These callback *in/out set/unset cpuctx->task_ctx value to the task
  context.

- close is called on event on CPU 0:
	- the task is scheduled on CPU 0
	- __perf_event_task_sched_in is called
	- cpuctx->task_ctx is set
	- perf_sched_events jump label is decremented and == 0
	- __perf_event_task_sched_out is not called
	- cpuctx->task_ctx on CPU 0 stays set

- exit is called on CPU 1:
	- the task is scheduled on CPU 1
	- perf_event_exit_task is called
	- task_ctx_sched_out unsets cpuctx->task_ctx on CPU 1
	- put_ctx destroys the context

- another call of perf_rotate_context on CPU 0 will use invalid
  task_ctx pointer, and eventualy panic


The attached workaround makes sure that the task_ctx is not set
when the context is being removed.  As I said it's not ment to be
fix.

any ideas?

thanks,
jirka


---
 kernel/perf_event.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index c75925c..25baf13 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -596,6 +596,19 @@ static void free_ctx(struct rcu_head *head)
 static void put_ctx(struct perf_event_context *ctx)
 {
 	if (atomic_dec_and_test(&ctx->refcount)) {
+
+                if (!atomic_read(&perf_sched_events)) {
+			int cpu;
+
+			for_each_possible_cpu(cpu) {
+				struct perf_cpu_context *cpuctx;
+
+				cpuctx = per_cpu_ptr(ctx->pmu->pmu_cpu_context, cpu);
+				if (cpuctx->task_ctx == ctx)
+					cpuctx->task_ctx = NULL;
+			}
+		}
+
 		if (ctx->parent_ctx)
 			put_ctx(ctx->parent_ctx);
 		if (ctx->task)
-- 
1.7.1

