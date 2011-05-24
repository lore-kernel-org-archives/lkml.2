Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932813Ab1EXShu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 14:37:50 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60946 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932775Ab1EXSht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 14:37:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=CPKedE3V4CGSPw3X9ZkoN1xo0/CMAHDiBWEGZBInAYVSazL3dtnlCK3INUSfnzU+FV
         heoDAdAswkivj0sL8JVhoUjECrpBtKI4U4MFqEteKxZmbMBPr26eHpL1o4WlHhZsE54S
         GNnEIv9ihHfNeEtK1aCUSq+3xtHzIE3ZhXiWg=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com
Cc: vda.linux@googlemail.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com,
        pedro@codesourcery.com
Subject: [PATCHSET ptrace] ptrace: implement PTRACE_SEIZE/INTERRUPT and group stop notification, take#3
Date: Tue, 24 May 2011 20:37:20 +0200
Message-Id: <1306262259-7285-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is the third try at implementing PTRACE_SEIZE/INTERRUPT and group
stop notification.  This patchset contains both the prep and the
actual implementation patches.  Changes from the second take[1][2]
are,

- 0008-ptrace-move-JOBCTL_TRAPPING-wait-to-wait-2-and-ptrac.patch:

  wait_task_stopped() syscall restart fixed such that -ERESTARTSYS is
  used for !WNOHANG waits.

- 0006-job-control-introduce-task_set_jobctl_pending.patch:

  Added to address Oleg's concern that setting trap conditions on
  dying task may make it unkillable.  task_set_jobctl_pending() is
  always used when raising stop/trap conditions and becomes noop if
  target task is dying.  0011, 0013 and 0019 updated to use
  task_set_jobctl_pending().

- 0012-ptrace-implement-PTRACE_SEIZE.patch:

  PTRACE_SEIZE no longer traps the tracee automatically as suggested
  by Jan Kratochvil.  If tracee is running, it's left running.

- 0016-ptrace-make-group-stop-state-visible-via-PTRACE_GETS.patch:
- 0018-ptrace-add-JOBCTL_BLOCK_NOTIFY.patch:-v2:

  Cosmetic updates as per review.

This patchset contains the following 19 patches.

  0001-job-control-rename-signal-group_stop-and-flags-to-jo.patch
  0002-ptrace-ptrace_check_attach-rename-kill-to-ignore_sta.patch
  0003-ptrace-relocate-set_current_state-TASK_TRACED-in-ptr.patch
  0004-job-control-introduce-JOBCTL_PENDING_MASK-and-task_c.patch
  0005-job-control-make-task_clear_jobctl_pending-clear-TRA.patch
  0006-job-control-introduce-task_set_jobctl_pending.patch
  0007-ptrace-use-bit_waitqueue-for-TRAPPING-instead-of-wai.patch
  0008-ptrace-move-JOBCTL_TRAPPING-wait-to-wait-2-and-ptrac.patch
  0009-ptrace-make-TRAPPING-wait-interruptible.patch
  0010-signal-remove-three-noop-tracehooks.patch
  0011-job-control-introduce-JOBCTL_TRAP_STOP-and-use-it-fo.patch
  0012-ptrace-implement-PTRACE_SEIZE.patch
  0013-ptrace-implement-PTRACE_INTERRUPT.patch
  0014-ptrace-restructure-ptrace_getsiginfo.patch
  0015-ptrace-add-siginfo.si_pt_flags.patch
  0016-ptrace-make-group-stop-state-visible-via-PTRACE_GETS.patch
  0017-ptrace-don-t-let-PTRACE_SETSIGINFO-override-__SI_TRA.patch
  0018-ptrace-add-JOBCTL_BLOCK_NOTIFY.patch
  0019-ptrace-implement-group-stop-notification-for-ptracer.patch

and available in the following git branch.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git review-ptrace-seize

The HEAD is 6e3eb3ab5f (ptrace: implement group stop notification for
ptracer).  If you see older branch, please retry after a while (korg
is still syncing).

The patchset is on top of today's (20110524) mainline -
d762f438310 (Merge branch 'sh-latest' of
git://git.kernel.org/pub/scm/linux/kernel/git/lethal/sh-2.6).

diffstat follows.

 arch/ia64/include/asm/siginfo.h       |    7 
 arch/ia64/kernel/signal.c             |    5 
 arch/mips/include/asm/compat-signal.h |    7 
 arch/mips/include/asm/siginfo.h       |    7 
 arch/mips/kernel/signal32.c           |    5 
 arch/parisc/kernel/signal32.c         |    5 
 arch/parisc/kernel/signal32.h         |    7 
 arch/powerpc/kernel/ppc32.h           |    7 
 arch/powerpc/kernel/signal_32.c       |    5 
 arch/s390/kernel/compat_linux.h       |    7 
 arch/s390/kernel/compat_signal.c      |    5 
 arch/sparc/kernel/signal32.c          |   12 +
 arch/tile/kernel/compat_signal.c      |   11 +
 arch/x86/ia32/ia32_signal.c           |    4 
 arch/x86/include/asm/ia32.h           |    7 
 fs/exec.c                             |    2 
 include/asm-generic/siginfo.h         |   10 
 include/linux/ptrace.h                |   16 +
 include/linux/sched.h                 |   28 +-
 include/linux/tracehook.h             |   52 ----
 kernel/exit.c                         |   27 ++
 kernel/ptrace.c                       |  302 +++++++++++++++++++++++----
 kernel/signal.c                       |  370 ++++++++++++++++++++++------------
 23 files changed, 672 insertions(+), 236 deletions(-)

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel/1139751
[2] http://thread.gmane.org/gmane.linux.kernel/1140778
