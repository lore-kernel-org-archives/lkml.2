Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932776Ab1EMPq2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 11:46:28 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47953 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932618Ab1EMPqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 11:46:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=h3Da8kReXkl20nr6PqwpuIR5TxFrZUSNpApE4iHeElmSwYM+WINhDJtElMO9yma/ya
         QfdqtiuazbotZ0EBCUFMWcQIuud9ZqlsgQanhEZOy9lCcgpDK2reokSvc+/Fae50jSZi
         G5WAr0lEgj6bjX09nRCl/Bl8qBIvaNpDwnkVM=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com
Subject: [PATCHSET ptrace] ptrace: prepare for PTRACE_SEIZE/INTERRUPT
Date: Fri, 13 May 2011 17:46:11 +0200
Message-Id: <1305301580-9924-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset is extension of preparation patches extracted from
"ptrace: implement PTRACE_SEIZE/INTERRUPT and group stop notification"
patchset[1].

Trivial and reviewed ones are collected at the beginning so that they
can be applied to the ptrace tree.  The latter half concentrates on
improving TRAPPING handling without actually implementing any new
ptrace request.

This patchset makes the following changes to TRAPPING wait.

* TRAPPING is cleared when an action which requires cancellation
  happens and the fallback clearing at the end of do_signal_stop() is
  removed.  This doesn't require adding any extra callsite to
  clear_trapping() explicitly.  Jobctl flag clearing automatically
  handles cancellation of TRAPPING.

* Instead of signal->wait_chldexit, bit waitqueue is used.  This
  removes the unnecessary complexity and dependency on parent/child
  hierarchy of TRAPPING wait.  Note that this removes the wrong wait
  queue bug Oleg pointed out in wait_trapping().

* TRAPPING wait is moved from PTRACE_ATTACH to wait_task_stopped() and
  ptrace_check_attach().  In both cases, TRAPPING uses
  restart_syscall() to retry.  This simplifies the code and combined
  with the next change makes TRAPPING much safer.

* TRAPPING now uses interruptible sleep.  This makes it way safer even
  if we get something wrong - at least, the tracer can be easily
  killed no matter what.  Also, this makes TRAPPING wait behave just
  like other syscall retries and mixing TRAPPING waits with freezing
  becomes much easier.

Other than making the transient TASK_RUNNING during TRAPPING visible
through /proc and using automatically restarted interruptible sleep,
this patchset doesn't make userland visible changes.

This patchset contains the following nine patches.

  0001-job-control-reorganize-wait_task_stopped.patch
  0002-job-control-rename-signal-group_stop-and-flags-to-jo.patch
  0003-ptrace-ptrace_check_attach-rename-kill-to-ignore_sta.patch
  0004-ptrace-relocate-set_current_state-TASK_TRACED-in-ptr.patch
  0005-job-control-introduce-JOBCTL_PENDING_MASK-and-task_c.patch
  0006-job-control-make-task_clear_jobctl_pending-clear-TRA.patch
  0007-ptrace-use-bit_waitqueue-for-TRAPPING-instead-of-wai.patch
  0008-ptrace-move-JOBCTL_TRAPPING-wait-to-wait-2-and-ptrac.patch
  0009-ptrace-make-TRAPPING-wait-interruptible.patch

0001-0004 are reviewed or mostly trivial prep patches.

0005-0006 move clearing of TRAPPING to the actions requiring it.

0007 makes TRAPPING wait use bit waitqueue.

0008-0009 moves TRAPPING wait to wait(2) and ptrace_check_attach() and
makes it interruptible.

This patchset is on top of the current ptrace branch[2] - 40ae717d1e
"ptrace: fix signal->wait_chldexit usage in
task_clear_group_stop_trapping()" and is availble in the following git
branch.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git review-ptrace-seize-prep

diffstat follows.

 fs/exec.c              |    2 
 include/linux/ptrace.h |    3 -
 include/linux/sched.h  |   19 ++++--
 kernel/exit.c          |   46 +++++++++++++---
 kernel/ptrace.c        |   92 ++++++++++++++++++++++++++++-----
 kernel/signal.c        |  134 +++++++++++++++++++++++++------------------------
 6 files changed, 200 insertions(+), 96 deletions(-)

Thanks.

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel/1136930
[2] git://git.kernel.org/pub/scm/linux/kernel/git/oleg/misc.git ptrace
