Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933750Ab0FCDN1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 23:13:27 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50855 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933726Ab0FCDNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 23:13:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=qAVDqCPqeX6Brnl7iABUOrWiKj3NpnPn4kaV7KGxkuh9ZHapwIM/6S8n3e2sYol2uh
         Xzh2cVoS3ykF2zOFeW2GBSkwH7Sd7SmWJNTn//0h5a0SUClMTUwpOOdXnP0BMqKADhBJ
         RD/0B2cX3CSkgIIy/QkNZXW2lPOExJFlvRx20=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Stephane Eranian <eranian@google.com>
Subject: [GIT PULL] perf crash fix
Date: Thu,  3 Jun 2010 05:13:30 +0200
Message-Id: <1275534810-1837-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the perf/urgent branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	perf/urgent

Thanks,
	Frederic
---

Frederic Weisbecker (1):
      perf: Fix racy software pmu disabling


 kernel/perf_event.c |   20 ++++++++------------
 1 files changed, 8 insertions(+), 12 deletions(-)

---
commit f5ec7ecb6794782197305cd2fdd552b914800330
Author: Frederic Weisbecker <fweisbec@gmail.com>
Date:   Thu Jun 3 03:46:03 2010 +0200

    perf: Fix racy software pmu disabling
    
    Running "perf record -a -e faults" triggers the following bug:
    
    	BUG: unable to handle kernel paging request at 00200200 <-- LIST_POISON2
    	IP: [<c10aeebb>] perf_swevent_disable+0xb/0x20
    	*pde = 00000000
    	Oops: 0002 [#1] PREEMPT SMP
    	last sysfs file: /sys/devices/system/cpu/online
    
    	Pid: 3357, comm: perf Not tainted 2.6.35-rc1-atom #571 MS-7418/MS-7418
    	EIP: 0060:[<c10aeebb>] EFLAGS: 00010046 CPU: 0
    	EIP is at perf_swevent_disable+0xb/0x20
    	EAX: f5641400 EBX: f5641400 ECX: 00200200 EDX: 00000000
    	ESI: 00000000 EDI: f56414f8 EBP: f49dda80 ESP: f49dda80
    	 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
    	Process perf (pid: 3357, ti=f49dc000 task=f48504b0 task.ti=f49dc000)
    	Stack:
    	 f49ddacc c10b0a9d 3b987840 00000000 00000001 00000000 00000000 000f41a8
    	<0> 00000000 f5641400 00000001 00000000 3b9aca00 00000000 000003e8 00000000
    	<0> f5641400 00000001 00000000 f49ddaf0 c10b5b71 00000001 00000000 c283f180
    	Call Trace:
    	 [<c10b0a9d>] ? perf_adjust_period+0x3cd/0x3f0
    	 [<c10b5b71>] ? perf_ctx_adjust_freq+0xe1/0x140
    	 [<c10b5d0f>] ? perf_event_task_tick+0x13f/0x160
    	 [<c103e9e0>] ? scheduler_tick+0x110/0x310
    	 [<c10510e7>] ? update_process_times+0x47/0x60
    	 [<c106d55c>] ? tick_sched_timer+0x5c/0xb0
    	 [<c1061f07>] ? __run_hrtimer+0x67/0x330
    	 [<c106d500>] ? tick_sched_timer+0x0/0xb0
    	 [<c1062562>] ? hrtimer_interrupt+0x202/0x2f0
    	 [<c134f8d5>] ? write_msg+0xd5/0xe0
    	 [<c101edb0>] ? smp_apic_timer_interrupt+0x50/0x90
    	 [<c1218ce8>] ? trace_hardirqs_off_thunk+0xc/0x14
    	 [<c150fe3b>] ? apic_timer_interrupt+0x2f/0x34
    	 [<c150f56f>] ? _raw_spin_unlock_irqrestore+0x2f/0x60
    	 [<c1041fb5>] ? vprintk+0x145/0x450
    	 [<c1064d62>] ? sched_clock_local+0xd2/0x170
    	 [<c1064f28>] ? sched_clock_cpu+0x128/0x170
    	 [<c150b6a3>] ? printk+0x18/0x1a
    	 [<c107076c>] ? lockdep_rcu_dereference+0x3c/0xb0
    	 [<c10b0697>] ? perf_swevent_enable+0x1e7/0x220
    	 [<c100f7c8>] ? intel_pmu_disable_all+0x68/0xd0
    	 [<c100f9b5>] ? hw_perf_disable+0x45/0x50
    	 [<c10b0aaa>] ? perf_adjust_period+0x3da/0x3f0
    	 [<c10b5f4b>] ? __perf_event_overflow+0x21b/0x260
    	 [<c1008f54>] ? native_sched_clock+0x24/0x90
    	 [<c10b60f4>] ? perf_swevent_overflow+0x164/0x180
    	 [<c10b6193>] ? perf_swevent_add+0x83/0xd0
    	 [<c10b6544>] ? __perf_sw_event+0x1d4/0x290
    	 [<c10b63a6>] ? __perf_sw_event+0x36/0x290
    	 [<c106ebdd>] ? put_lock_stats+0xd/0x30
    	 [<c106fc36>] ? lock_release_holdtime+0xa6/0x1a0
    	 [<c1074b0f>] ? lock_release_non_nested+0x2cf/0x2e0
    	 [<c103388b>] ? get_parent_ip+0xb/0x40
    	 [<c1034c2b>] ? sub_preempt_count+0x7b/0xb0
    	 [<c10cf72a>] ? might_fault+0x5a/0xb0
    	 [<c102778d>] ? do_page_fault+0x25d/0x3b0
    	 [<c1071544>] ? trace_hardirqs_on_caller+0x124/0x170
    	 [<c102766b>] ? do_page_fault+0x13b/0x3b0
    	 [<c10cf770>] ? might_fault+0xa0/0xb0
    	 [<c10cf72a>] ? might_fault+0x5a/0xb0
    	 [<c1219032>] ? copy_to_user+0x32/0x70
    	 [<c1002bfb>] ? sysenter_exit+0xf/0x16
    	 [<c1071544>] ? trace_hardirqs_on_caller+0x124/0x170
    	 [<c1027530>] ? do_page_fault+0x0/0x3b0
    	 [<c1510083>] ? error_code+0x6b/0x70
    	 [<c1027530>] ? do_page_fault+0x0/0x3b0
    
    What happens here is a double pmu->disable() due to a race between
    two perf_adjust_period().
    
    We first overflow a page fault event and then re-adjust the period.
    When we reset the period_left, we stop the pmu by removing the
    perf event from the software event hlist. And just before we
    re-enable it, we are interrupted by a sched tick that also tries to
    re-adjust the period. There we eventually disable the event a second
    time, which leads to a double hlist_del_rcu() that ends up
    dereferencing LIST_POISON2.
    
    In fact, the goal of embracing the reset of the period_left with
    a pmu:stop() and pmu:start() is only relevant to hardware events. We
    want them to reprogram the next period interrupt.
    
    But this is useless for software events. They have their own way to
    handle the period left, and in a non-racy way. They don't need to
    be stopped here.
    
    So, use a new pair of perf_event_stop/start_hwevent that only stop
    and restart hardware events in this path.
    
    The race won't happen with hardware events as sched ticks can't
    happen during nmis.
    
    Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
    Cc: Ingo Molnar <mingo@elte.hu>
    Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
    Cc: Paul Mackerras <paulus@samba.org>
    Cc: Stephane Eranian <eranian@google.com>

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 858f56f..b666d7d 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1510,20 +1510,16 @@ do {					\
 	return div64_u64(dividend, divisor);
 }
 
-static void perf_event_stop(struct perf_event *event)
+static void perf_event_stop_hwevent(struct perf_event *event)
 {
-	if (!event->pmu->stop)
-		return event->pmu->disable(event);
-
-	return event->pmu->stop(event);
+	if (event->pmu->stop && !is_software_event(event))
+		return event->pmu->stop(event);
 }
 
-static int perf_event_start(struct perf_event *event)
+static int perf_event_start_hwevent(struct perf_event *event)
 {
-	if (!event->pmu->start)
-		return event->pmu->enable(event);
-
-	return event->pmu->start(event);
+	if (event->pmu->start && !is_software_event(event))
+		return event->pmu->start(event);
 }
 
 static void perf_adjust_period(struct perf_event *event, u64 nsec, u64 count)
@@ -1546,9 +1542,9 @@ static void perf_adjust_period(struct perf_event *event, u64 nsec, u64 count)
 
 	if (atomic64_read(&hwc->period_left) > 8*sample_period) {
 		perf_disable();
-		perf_event_stop(event);
+		perf_event_stop_hwevent(event);
 		atomic64_set(&hwc->period_left, 0);
-		perf_event_start(event);
+		perf_event_start_hwevent(event);
 		perf_enable();
 	}
 }
