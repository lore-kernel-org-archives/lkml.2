Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926Ab0LFQ63 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 11:58:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:59714 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753906Ab0LFQ61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 11:58:27 -0500
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, rjw@sisk.pl,
        jan.kratochvil@redhat.com
Subject: [PATCHSET] ptrace,signal: sane interaction between ptrace and job control signals, take#2
Date: Mon,  6 Dec 2010 17:56:48 +0100
Message-Id: <1291654624-6230-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 06 Dec 2010 16:57:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is the second attempt at cleaning up ptrace and signal behaviors,
especially the interaction between ptrace and group stop.  There are
quite some number of problems in the area and the current behavior is
often racy, indeterministic and sometimes outright buggy.  This
patchset aims to clean up the muddy stuff, and define and implement a
clear interaction between ptrace and job control.

Most changes from the last take[L] are to address the problems pointed
out by Oleg.  Let's hope things are less swiss-cheesy this time.  I
considered adding a separate task state tracking which encompasses
ptrace related transitions but it quickly became too redundant and
uglier than the current approach of augmenting the default state
machine with flags for special cases.  So, at least for now, I think
it's better to continue with the current approach.

* Group stop helpers restructured: task_clear_group_stop[_trapping]()
  added and consume_group_stop() replaced with
  task_participate_group_stop().

* 0002-freezer-fix-a-race-during-freezing-of-TASK_STOPPED-t.patch from
  the last posting was taken by Rafael and dropped from this series.

* 0002-signal-fix-CLD_CONTINUED-notification-target.patch added.

* 0004-signal-don-t-notify-parent-if-not-stopping-after-tra.patch
  replaced with 0004-ptrace-kill-tracehook_notify_jctl.patch to
  streamline the conversion.  Whether something similar can or should
  be factored out after conversion is to be determined but I'm quite
  doubtful.

* 0005-ptrace-add-why-to-ptrace_stop.patch repositioned from 0007 to
  0005.

* 0007-signal-use-GROUP_STOP_PENDING-to-stop-once-for-a-sin.patch:
  Fixed the problems pointed out by Oleg.

* 0010-ptrace-don-t-consume-group-count-from-ptrace_stop.patch
  replaced by
  0008-ptrace-participate-in-group-stop-from-ptrace_stop-if.patch.
  This is to ensure that GROUP_STOP_PENDING consumption and transition
  into TASK_TRACED is atomic so that a task doesn't trap for group
  stop with GROUP_STOP_PENDING set.

* 0010-ptrace-clean-transitions-between-TASK_STOPPED-and-TR.patch.
  Fixed group stop bookkeeping bug on retry.  TASK_STOPPED ->
  TASK_TRACED transition is now hidden from userland with the help of
  GROUP_STOP_TRAPPING flag.

* Notification reliability patches restructured so that the
  determination logics now reside in do_notify_parent_cldstop() and
  are executed while holding both tasklist_lock and siglock.

* New patches 0011 and 0015 added.

This patchset contains the following sixteen patches.

 0001-signal-fix-SIGCONT-notification-code.patch
 0002-signal-fix-CLD_CONTINUED-notification-target.patch
 0003-signal-remove-superflous-try_to_freeze-loop-in-do_si.patch
 0004-ptrace-kill-tracehook_notify_jctl.patch
 0005-ptrace-add-why-to-ptrace_stop.patch
 0006-signal-fix-premature-completion-of-group-stop-when-i.patch
 0007-signal-use-GROUP_STOP_PENDING-to-stop-once-for-a-sin.patch
 0008-ptrace-participate-in-group-stop-from-ptrace_stop-if.patch
 0009-ptrace-make-do_signal_stop-use-ptrace_stop-if-the-ta.patch
 0010-ptrace-clean-transitions-between-TASK_STOPPED-and-TR.patch
 0011-signal-prepare-for-CLD_-notification-changes.patch
 0012-ptrace-make-group-stop-notification-reliable-against.patch
 0013-ptrace-reorganize-__ptrace_unlink-and-ptrace_untrace.patch
 0014-ptrace-make-SIGCONT-notification-reliable-against-pt.patch
 0015-ptrace-make-sure-SIGNAL_NOTIFY_CONT-is-checked-after.patch
 0016-ptrace-remove-the-extra-wake_up_process-from-ptrace_.patch

0001-0002 are fixes.  0003-0005 are preparation patches.

0006 prevents a ptraced task from being stopped multiple times for the
same group stop instance.

0007-0010 update the code such that a ptracee always enters and leaves
TASK_TRACED on its own.  ptracer no longer changes tracee's state
underneath it; instead, it tells the tracee to enter the target state.
A TASK_TRACED task is guaranteed to be stopped inside ptrace_stop()
after executing the arch hooks while TASK_STOPPED task is guaranteed
to be stopped in do_signal_stop().

0011-0015 make CLD_STOPPED/CONTINUED notification reliable with
intervening ptrace.  Whether a ptracee owes an notification to its
parent is tracked and the real parent is notified accordingly on
detach.

0016 kills the unnecessary wake_up_process() which is wrong in so many
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

The branch is on top of 2.6.37-rc4 and available in the following git
branch,

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git ptrace

and contains the following changes.

 fs/exec.c                 |    1 
 include/linux/sched.h     |   14 +
 include/linux/tracehook.h |   27 ---
 kernel/ptrace.c           |  139 ++++++++++++++----
 kernel/signal.c           |  345 +++++++++++++++++++++++++++++++++++-----------
 5 files changed, 391 insertions(+), 135 deletions(-)

Thanks.

--
tejun

[L] http://thread.gmane.org/gmane.linux.kernel/1068420
