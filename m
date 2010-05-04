Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758606Ab0EDMll (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 08:41:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:51774 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752824Ab0EDMjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 08:39:17 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, peterz@infradead.org, efault@gmx.de, avi@redhat.com,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org
Subject: [RFC PATCHSET] sched,perf: unify tracers in sched and move perf on top of TP
Date: Tue,  4 May 2010 14:38:32 +0200
Message-Id: <1272976724-14312-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 04 May 2010 12:38:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, all.

This patchset does the following two things.

* 0001-0007: Unify the three tracers (tracepoints, perf_events and
  preempt/sched notifiers) in scheduler.

* 0008-0012: Move perf hooks in sched on top of tracepoints if TPs are
	     enabled.

It probably should be two separate patchsets with the first part on
top of sched/core which then gets pulled into perf branch, on top of
which the second part is applied but in the spirit of RFC I'm posting
it as a single chunk on top of mainline+perf/urgent.

This patchset contains the following 12 patches.

 0001-sched-drop-cpu-argument-from-sched_in-preempt-notifi.patch
 0002-sched-rename-preempt_notifiers-to-sched_notifiers-an.patch
 0003-perf-add-perf_event_task_migrate.patch
 0004-perf-add-rq-to-perf_event_task_sched_out.patch
 0005-perf-move-perf_event_task_sched_in-next-to-fire_sche.patch
 0006-sched-relocate-fire_sched_notifiers_out-and-trace_sc.patch
 0007-sched-coalesce-event-notifiers.patch
 0008-sched-add-switch_in-and-tick-tracepoints.patch
 0009-perf-factor-out-perf_event_switch_clones.patch
 0010-perf-make-nr_events-an-int-and-add-perf_online_mutex.patch
 0011-perf-prepare-to-move-sched-perf-functions-on-top-of-.patch
 0012-perf-move-sched-perf-functions-on-top-of-tracepoints.patch

0001-0006 move tracers in sched around and massage them here and there
to bring the related ones together and make them take the same
arguments.  The only change worth noting would be 0005 where
perf_event_task_sched_in() is moved after finish_lock_switch() which
costs the function a pair of local_irq_disable/enable() when switching
a task context in when there's a context to switch in (the unlikely
path).

0007 implements SCHED_EVENT[_RQ]() macros which can define all or any
subset of the three at once and uses them to replace all trace calls.

0008-0011 prepare to move sched perf functions on top of matching TPs
and make them enabled on demand.

0012 makes all sched perf functions TP probe functions and
enable/disable them on-demand.

The whole patchset is more or less straight forward except that the
on-demand (or rather off-demand?) disabling of perf functions in 0012
is somewhat complicated because the callback which can determine when
to turn it off is called under rq lock while unregistering requires a
thread context.  As rq lock is depended upon by workqueue, tasklet and
timer, none of those can be used directly.  It's worked around by
having a periodic timer polling for completion.

This patchset is available in the following git branch.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git sched-trace

The tree is on top of linus#master + sched/urgent for now.  Diffstat
follows.

 arch/ia64/kvm/Kconfig        |    2 
 arch/powerpc/kvm/Kconfig     |    2 
 arch/s390/kvm/Kconfig        |    2 
 arch/x86/kvm/Kconfig         |    2 
 include/linux/kvm_host.h     |    4 
 include/linux/perf_event.h   |   39 ++++-
 include/linux/preempt.h      |   48 -------
 include/linux/sched.h        |   52 +++++++
 include/trace/events/sched.h |   14 ++
 init/Kconfig                 |    2 
 kernel/perf_event.c          |  288 +++++++++++++++++++++++++++++++++++++------
 kernel/sched.c               |  175 ++++++++++++++------------
 virt/kvm/kvm_main.c          |   28 +---
 13 files changed, 459 insertions(+), 199 deletions(-)

Thanks.

--
tejun
