Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968Ab1GVRff (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 13:35:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20969 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753084Ab1GVRfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 13:35:34 -0400
Date: Fri, 22 Jul 2011 19:32:37 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, Tejun Heo <tj@kernel.org>,
        Vladimir Zapolskiy <vzapolskiy@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] ptrace changes for v3.1
Message-ID: <20110722173237.GA16787@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

	git://git.kernel.org/pub/scm/linux/kernel/git/oleg/misc.git ptrace

More ptrace/jobctl fixes plus PTRACE_SEIZE/PTRACE_LISTEN functionality
from Tejun.

Note:

	- f701e5b7 "connector: add an event for monitoring process tracers" is
	  a bit off-topic, it was routed via ptrace branch because it textually
	  depends on the changes in tracehook/ptrace_attach code.

	- a288eecc "ptrace: kill trivial tracehooks" has the simple conflicts
	  with 248bed4b "[S390] use siginfo for sigtrap signals" pending in s390
	  tree, hopefully this is trivial to resolve.

	  Assuming you didn't pulled s390 yet: s390 version supercedes, only

	  	- tracehook_consider_fatal_signal
	  	+ current->ptrace

	  chunk in arch/s390/kernel/traps.c should be dropped because this was
	  already done by a288eecc

Denys Vlasenko (1):
      ptrace: make former thread ID available via PTRACE_GETEVENTMSG after PTRACE_EVENT_EXEC stop

Oleg Nesterov (17):
      make do_notify_parent() return bool
      kill tracehook_notify_death()
      __ptrace_detach: avoid task_detached(), check do_notify_parent()
      make do_notify_parent() __must_check, update the callers
      reparent_leader: check EXIT_DEAD instead of task_detached()
      kill task_detached()
      do not change dead_task->exit_signal
      redefine thread_group_leader() as exit_signal >= 0
      ptrace: ptrace_reparented() should check same_thread_group()
      ptrace: kill real_parent_is_ptracer() in in favor of ptrace_reparented()
      ptrace: wait_consider_task: s/same_thread_group/ptrace_reparented/
      has_stopped_jobs: s/task_is_stopped/SIGNAL_STOP_STOPPED/
      ptrace_init_task: initialize child->jobctl explicitly
      ptrace: mv send-SIGSTOP from do_fork() to ptrace_init_task()
      ptrace: dont send SIGSTOP on auto-attach if PT_SEIZED
      ptrace: fix ptrace_signal() && STOP_DEQUEUED interaction
      ptrace: do_wait(traced_leader_killed_by_mt_exec) can block forever

Tejun Heo (20):
      ptrace: remove silly wait_trap variable from ptrace_attach()
      job control: rename signal->group_stop and flags to jobctl and update them
      ptrace: ptrace_check_attach(): rename @kill to @ignore_state and add comments
      ptrace: relocate set_current_state(TASK_TRACED) in ptrace_stop()
      job control: introduce JOBCTL_PENDING_MASK and task_clear_jobctl_pending()
      job control: make task_clear_jobctl_pending() clear TRAPPING automatically
      job control: introduce task_set_jobctl_pending()
      ptrace: use bit_waitqueue for TRAPPING instead of wait_chldexit
      signal: remove three noop tracehooks
      job control: introduce JOBCTL_TRAP_STOP and use it for group stop trap
      ptrace: implement PTRACE_SEIZE
      ptrace: implement PTRACE_INTERRUPT
      ptrace: implement TRAP_NOTIFY and use it for group stop events
      ptrace: implement PTRACE_LISTEN
      ptrace: kill task_ptrace()
      ptrace: introduce ptrace_event_enabled() and simplify ptrace_event() and tracehook_prepare_clone()
      ptrace: move SIGTRAP on exec(2) logic to ptrace_event()
      ptrace: kill trivial tracehooks
      ptrace: kill clone/exec tracehooks
      ptrace: s/tracehook_tracer_task()/ptrace_parent()/

Vladimir Zapolskiy (1):
      connector: add an event for monitoring process tracers

 arch/s390/kernel/traps.c    |    4 +-
 drivers/connector/cn_proc.c |   35 ++++
 fs/exec.c                   |   27 +++-
 fs/proc/array.c             |    2 +-
 fs/proc/base.c              |    2 +-
 include/linux/cn_proc.h     |   13 ++
 include/linux/ptrace.h      |  104 ++++++++---
 include/linux/sched.h       |   52 ++++--
 include/linux/tracehook.h   |  385 +--------------------------------------
 kernel/exit.c               |   91 ++++-----
 kernel/fork.c               |   33 +++-
 kernel/ptrace.c             |  197 ++++++++++++++++----
 kernel/signal.c             |  425 +++++++++++++++++++++++++++----------------
 mm/nommu.c                  |    3 +-
 mm/oom_kill.c               |    3 +-
 security/apparmor/domain.c  |    2 +-
 security/selinux/hooks.c    |    4 +-
 17 files changed, 674 insertions(+), 708 deletions(-)

