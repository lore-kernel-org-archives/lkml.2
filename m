Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab0LXOBH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 09:01:07 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62333 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281Ab0LXOBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 09:01:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:message-id:x-mailer;
        b=u0THYRpStwAeo3HfN3FEBcAuKlHDTCnhfWzbxQJ+pIfkX9bYMBrmWBhjytwtvafONM
         oNMrGIEAMUa2h/fXVD+fe7flxEC0X6I+cFewn1S3xTM7ktel0cDJJl5nOBgHY82TSpT0
         HNuV5IMANOiCm8NMcFEpZZxn7ZTOFONwhllhs=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, roland@redhat.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: [PATCHSET RFC] ptrace,signal: clean transition between STOPPED and TRACED
Date: Fri, 24 Dec 2010 15:00:50 +0100
Message-Id: <1293199257-11255-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset is spun off from "ptrace,signal: sane interaction
between ptrace and job control signals, take#2" patchset[1].  From the
series, four fix and cleanup patches were put into git branch
ptrace-reviewed[2].  This patchset is the subset which tries to fix
problems with the actual group stop mechanism and make the transition
between STOPPED and TRACED clean.

These changes haven't been agreed upon yet and require more
discussion.  I'm posting this series so that the already pointed out
problems don't hinder in the discussion and we can separate this part
from the SIGCHLD notification changes.

Most changes are to reflect Oleg's review on the original patchset.

* 0001 is added to remove the deprecated CLONE_STOPPED.

* 0002-0005 only received changes for minor issues pointed out during
  review.

* 0006 description updated to note the user visible behavior changes.

* 0007 now uses signal->wait_chldexit instead of waiting on bit.
  Oleg, I kept TASK_UNINTERRUPTIBLE wait for now.  I tried to switch
  to TASK_KILLABLE but it makes things more subtle down the line.  The
  child can be left in the middle of transition and may end up
  continuing running while the rest are stopped, which in itself is
  okay but adds another layer of complexity on top of an already very
  complex set of behaviors.  As the transition is well defined and
  lock-stepped, I think it would be better to just get it right and
  remove the variable there.

* 0007 also waits for trapping on attach instead of the next ptrace
  operation such that an immediately following WNOHANG(2) wait from
  the ptracer would always succeed if the ptracee was already stopped.

* Comments added and other misc updates to 0007.

Most behavior differences caused by this series is mostly caused by
tracees stopping in TRACED instead of STOPPED when trapping for a
group stop.  The two most notable ones are

1. When attaching to a STOPPED task or a traced task stops for group
   stop, the tracee now enters TRACED instead of STOPPED.  This is
   visible via fs/proc but, more importantly, SIGCONT is ignored if a
   task is TRACED.

   The behavior before the change was quite erratic.  The first ptrace
   operation after the tracee enters STOPPED would silently transit
   its state to TRACED behind its back bypassing arch_ptrace_stop().
   This means that SIGCONT is honored until the first following ptrace
   operation but ignored after that.

   This may, for example, affect the operation of strace but given how
   strace always need to issue further ptrace operations on trap to
   determine what's going on, I doubt it would actually be worse.

2. The transition between STOPPED and TRACED involves a short window
   of RUNNING inbetween.  On attach, the transition is hidden from the
   tracer using GROUP_STOP_TRAPPING but it still is visible to other
   threads in the tracer's group.  IOW, if another thread performs
   WNOHANG wait(2) on the tracee while attach is in progress, the
   wait(2) may fail even if the tracee is known to be in stopped state
   before.

   The same problem exists the other direction during detach.
   Currently, the code doesn't try to hide this transition even from
   the tracer.  IOW, if the tracer attaches to a stopped task,
   detaches, reattaches and then performs WNOHANG wait(2), the wait(2)
   may fail.  However, given the previous behavior where the tracee is
   always woken up by wake_up_process() on detach, this is highly
   unlikely to cause any problem.

This patchset contains the following seven patches.

 0001-clone-kill-CLONE_STOPPED.patch
 0002-ptrace-add-why-to-ptrace_stop.patch
 0003-signal-fix-premature-completion-of-group-stop-when-i.patch
 0004-signal-use-GROUP_STOP_PENDING-to-stop-once-for-a-sin.patch
 0005-ptrace-participate-in-group-stop-from-ptrace_stop-if.patch
 0006-ptrace-make-do_signal_stop-use-ptrace_stop-if-the-ta.patch
 0007-ptrace-clean-transitions-between-TASK_STOPPED-and-TR.patch

and is available in the following git tree.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git ptrace-clean-transition

diffstat follows.

 fs/exec.c             |    1 
 include/linux/sched.h |   12 ++-
 kernel/fork.c         |   28 -------
 kernel/ptrace.c       |   49 +++++++++++-
 kernel/signal.c       |  192 +++++++++++++++++++++++++++++++++++++++-----------
 5 files changed, 208 insertions(+), 74 deletions(-)

Thanks.

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel/1072474
[2] git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git ptrace-reviewed
