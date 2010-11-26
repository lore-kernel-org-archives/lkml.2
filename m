Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964Ab0KZKua (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 05:50:30 -0500
Received: from hera.kernel.org ([140.211.167.34]:42315 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754635Ab0KZKuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 05:50:24 -0500
From: Tejun Heo <tj@kernel.org>
To: roland@redhat.com, oleg@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        "rjw@sisk.plpavel"@ucw.cz
Subject: [PATCHSET RFC] ptrace,signal: sane interaction between ptrace and job control signals
Date: Fri, 26 Nov 2010 11:49:15 +0100
Message-Id: <1290768569-16224-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Nov 2010 10:49:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset is an attempt at cleaning up ptrace and signal
behaviors, especially the interaction between ptrace and group stop.
There are quite some number of problems in the area and the current
behavior is often racy, indeterministic and sometimes outright buggy.
This patchset aims to clean up the muddy stuff, and define and
implement a clear interaction between ptrace and job control.

This patchset contains the following fourteen patches.

 0001-signal-fix-SIGCONT-notification-code.patch
 0002-freezer-fix-a-race-during-freezing-of-TASK_STOPPED-t.patch
 0003-freezer-remove-superflous-try_to_freeze-loop-in-do_s.patch
 0004-signal-don-t-notify-parent-if-not-stopping-after-tra.patch
 0005-signal-fix-premature-completion-of-group-stop-when-i.patch
 0006-signal-use-GROUP_STOP_PENDING-to-avoid-stopping-mult.patch
 0007-ptrace-add-why-to-ptrace_stop.patch
 0008-ptrace-make-do_signal_stop-use-ptrace_stop-if-the-ta.patch
 0009-ptrace-clean-transitions-between-TASK_STOPPED-and-TR.patch
 0010-ptrace-don-t-consume-group-count-from-ptrace_stop.patch
 0011-ptrace-make-group-stop-notification-reliable-against.patch
 0012-ptrace-reorganize-__ptrace_unlink-and-ptrace_untrace.patch
 0013-ptrace-make-SIGCONT-notification-reliable-against-pt.patch
 0014-ptrace-remove-the-extra-wake_up_process-from-ptrace_.patch

0001-0002 are self-contained fixes.  0003-0004 are preparation
patches.

0005 fixes over-consumption of group_stop_count by ptraced tasks which
can lead to premature completion of group stop with some of the tasks
in the group still running.

0006 prevents a ptraced task from being stopped multiple times for the
same group stop instance.

0007-0009 updates the code such that a ptracee always enters and
leaves TASK_TRACED on its own.  ptracer no longer changes tracee's
state underneath it; instead, it tells the tracee to enter the target
state.  A TASK_TRACED task is guaranteed to be stopped inside
ptrace_stop() after executing the arch hooks while TASK_STOPPED task
is guaranteed to be stopped in do_signal_stop().

0010-0013 makes CLD_STOPPED/CONTINUED notification reliable with
intervening ptrace.  Whether a ptracee owes an notification to its
parent is tracked and the real parent is notified accordingly on
detach.

0014 kills the unnecessary wake_up_process() which is wrong in so many
ways including the possibility of abruptly waking up a task in an
uninterruptible sleep.  Now that ptrace / job control interaction is
cleaned up, this really should go.

After the patchset, the interaction between ptrace and job control is
defined as,

* Regardless of ptrace, job control signals control the process-wide
  stopped state.  A ptracee receives and handles job control signals
  the same as before but no matter what ptrace does the global state
  isn't affected.

* On ptrace detach, the task is put into the state which matches the
  process-wide stopped state.  If necessary, notification to the real
  parent is reinstated.

Due to the implicit sending of SIGSTOP on PTRACE_ATTACH, ptrace
attach/detach are still not transparent w.r.t. job control but these
changes lay the base for (almost) transparent ptracing.

The branch is on top of 2.6.37-rc3 and available in the following git
branch,

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git ptrace

and contains the following changes.

 include/linux/sched.h  |   11 +++
 kernel/freezer.c       |    9 ++-
 kernel/power/process.c |    6 ++
 kernel/ptrace.c        |  105 +++++++++++++++++++++++++-----------
 kernel/signal.c        |  140 +++++++++++++++++++++++++++++++++----------------
 5 files changed, 194 insertions(+), 77 deletions(-)

Thanks.

--
tejun
