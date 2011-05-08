Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab1EHPtW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 11:49:22 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53351 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab1EHPtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 11:49:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=eRdjx7t/WGgMZYZifVSLA/8Jvq3WMTUIm2vezQvUOL8SoWJpO7hXwLid+DP2tK2zuR
         Gft2sPbmg7JZq2DQsLU7l2Usg/NMNb3BJabw+ekcWmmYooTgWqXG7YAJd+i5jIJhEjhC
         0IN2QejOQ84X6iLznTYNm2gqushWqVXqrx5Ms=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: [PATCHSET ptrace] ptrace: implement PTRACE_SEIZE/INTERRUPT and group stop notification
Date: Sun,  8 May 2011 17:48:54 +0200
Message-Id: <1304869745-1073-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset implements new ptrace requests SEIZE and INTERRUPT and
also add group stop notification mechanism for ptracer.  Combined,
this implements "P4. PTRACE_SEIZE" and "P5. ^Z and fg for tracees" of
the ptrace job control improvements proposal[1].

Please note that there are some deviations from the proposal.

* As suggested by Oleg, PTRACE_SEIZE only serves as ATTACH without
  signal/job control side-effects.  After attached, PTRACE_INTERRUPT
  should be used to trap tracee without side effect.

* Group stop notification is implemented as sticky INTERRUPT trap
  which gets cleared on PTRACE_GETSIGINFO and notifies both start and
  end of group stops.

All the arch changse are for adding siginfo.si_pt_flags.  It's tedious
and likely to take some time to be available to userland but I think
it's better this way than adding some hacky flag to si_code or other
already used fields.

PTRACE_SEIZE/INTERRUPT and group stop notification all use INTERRUPT
trap.  The trap doesn't affect signal or job control states and is the
job control mechanism for ptracer in the sense that all it does is
just controlling the execution of tracee.

SEIZE/INTERRUPT behaviors are fairly straight-forward.  For
notification, making group stop state visible to userland via
PTRACE_GETSIGINFO was easy; however, notifying ptracer of the event
was somewhat more involved.  I ended up choosing the followings.

* The trap condition is sticky until GETSIGINFO.  This is necessary
  because generation of the event may race with CONT and ptracer may
  miss the trap.

* If tracee is running, simple trapping is enough.  If tracee is
  already group stop or INTERRUPT trapped, tracee is re-trapped to
  INTERRUPT thus notifying ptracer.  If tracee is in other traps,
  notification won't happen until the trap is finished.  This
  simplifies both implementation and usage of the interface and
  doesn't lose any capability as tracer can always put tracee into
  INTERRUPT trap if it's already in a trap without allowing it to
  return to userland.

* If group stop is pending, it has higher priority than INTERRUPT.
  This doesn't really affect correctness but avoids an extra
  notification trap if tracee is already going for group stop.

Each patch implementing new feature includes test program showing its
functionality.  Notification would probably need a bit more polishing
but all the needed functionalities are there.

This patchset contains the following 11 patches.

  0001-job-control-rename-signal-group_stop-and-flags-to-jo.patch
  0002-ptrace-implement-PTRACE_SEIZE.patch
  0003-ptrace-ptrace_check_attach-rename-kill-to-ignore_sta.patch
  0004-ptrace-implement-PTRACE_INTERRUPT.patch
  0005-ptrace-restructure-ptrace_getsiginfo.patch
  0006-ptrace-make-group-stop-state-visible-via-PTRACE_GETS.patch
  0007-ptrace-add-JOBCTL_TRAPPED.patch
  0008-ptrace-move-fallback-JOBCTL_TRAPPING-clearing-to-get.patch
  0009-job-control-reorganize-wait_task_stopped.patch
  0010-ptrace-move-JOBCTL_TRAPPING-wait-to-wait-2-and-ptrac.patch
  0011-ptrace-implement-group-stop-notification-for-ptracer.patch

and on top of

Oleg's signals-review b013c39924 (signal: cleanup sys_sigprocmask())
+ [2] ptrace: fix signal->wait_chldexit usage in task_clear_group_stop_trapping()
+ [3] ptrace: use GROUP_STOP_TRAPPING for PTRACE_DETACH too

The combined patchset is available in the following git branch.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git review-ptrace-seize

HEAD should be 74b094e53f38691c98ab73499e59eb7d5771dd4c.  If not,
git.korg is tasking some time to sync so please wait a while and try
again, or you can pull from master directly.

  ssh://master.kernel.org/pub/scm/linux/kernel/git/tj/misc.git review-ptrace-seize

diffstat follows.

 arch/ia64/include/asm/siginfo.h       |    7 +
 arch/ia64/kernel/signal.c             |    5 
 arch/mips/include/asm/compat-signal.h |    7 +
 arch/mips/include/asm/siginfo.h       |    7 +
 arch/mips/kernel/signal32.c           |    5 
 arch/parisc/kernel/signal32.c         |    5 
 arch/parisc/kernel/signal32.h         |    7 +
 arch/powerpc/kernel/ppc32.h           |    7 +
 arch/powerpc/kernel/signal_32.c       |    5 
 arch/s390/kernel/compat_linux.h       |    7 +
 arch/s390/kernel/compat_signal.c      |    5 
 arch/sparc/kernel/signal32.c          |   12 +
 arch/tile/kernel/compat_signal.c      |   11 +
 arch/x86/ia32/ia32_signal.c           |    4 
 arch/x86/include/asm/ia32.h           |    7 +
 fs/exec.c                             |    2 
 include/asm-generic/siginfo.h         |   10 +
 include/linux/ptrace.h                |   14 ++
 include/linux/sched.h                 |   26 ++--
 kernel/exit.c                         |   49 ++++++-
 kernel/ptrace.c                       |  193 ++++++++++++++++++++++++++----
 kernel/signal.c                       |  213 +++++++++++++++++++++++++---------
 22 files changed, 506 insertions(+), 102 deletions(-)

Thank you.

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel/1107045
[2] http://thread.gmane.org/gmane.linux.kernel/1136303
[3] http://thread.gmane.org/gmane.linux.kernel/1136915
