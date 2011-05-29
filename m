Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546Ab1E2XMu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 19:12:50 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53557 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab1E2XMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 19:12:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=xeDrmsBUqV3FBLO0SHxl122lod3INmwQGGpSwD9pbnC8PR3td5Rnjjx9d/2XDkr+BS
         k5wzL/e8tuSXiZj++SjPIiczxkvuP7ZSBdqtkfdQU+HtC5oYHZtwn+pjHdYcigUx/Bbu
         OdVMwlpILbHEivBf3lpeBDiEHSrLGd7gpEL50=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com
Cc: vda.linux@googlemail.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com,
        pedro@codesourcery.com
Subject: [PATCHSET ptrace] ptrace: implement PTRACE_SEIZE/INTERRUPT and group stop notification, take#4
Date: Mon, 30 May 2011 01:12:23 +0200
Message-Id: <1306710760-16440-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is the fourth take of PTRACE_SEIZE/INTERRUPT and group stop
notification patchset.  This patchset contains both the prep and the
actual implementation patches.

I'm traveling from tomorrow and wanted to send out the revised version
before leaving, so I didn't spend enough time testing the notification
part.  I haven't tested things like INTERRUPT cancelling listening or
immediate re-trap triggering on LISTEN.  But the basics are tested and
it should be enough to decide on direction.  BTW, Oleg, nice
suggestions.  I much prefer this over the TRAPPING one. :)

Notable changes from the third take[1] are,

* PTRACE_TRAP_NOTIFY is now cleared on the next STOP trap instead of
  PTRACE_GETSIGINFO as suggested by Oleg.

* PTRACE_LISTEN added.  This puts tracee into quasi-active state where
  wait(2) and sync ptrace requests fail and tracee is allowed to
  re-trap into STOP to notify an async event.  This makes re-trapping
  protection with TRAPPING unnecessary and makes the implementation
  noticeably simpler.  Also suggested by Oleg.

Per patch changes:

* The following patches are dropped.

  0008-ptrace-move-JOBCTL_TRAPPING-wait-to-wait-2-and-ptrac.patch
  0009-ptrace-make-TRAPPING-wait-interruptible.patch
  0014-ptrace-restructure-ptrace_getsiginfo.patch
  0018-ptrace-add-JOBCTL_BLOCK_NOTIFY.patch
  0019-ptrace-implement-group-stop-notification-for-ptracer.patch

* The following patches are added
  
  0001-ptrace-remove-silly-wait_trap-variable-from-ptrace_a.patch
  0016-ptrace-implement-TRAP_NOTIFY-and-use-it-for-group-st.patch
  0017-ptrace-implement-PTRACE_LISTEN.patch

* 0002-job-control-rename-signal-group_stop-and-flags-to-jo.patch

  JOBCTL_*_BIT macros defined to replace ilog2() usage as suggested by
  Linus.

* 0010-job-control-introduce-JOBCTL_TRAP_STOP-and-use-it-fo.patch

  PTRACE_TRAP_MASK handling in get_signal_delivery() is relocated
  after group stop participation inside for(;;) and do_signal_stop()
  now returns %false after scheduling STOP trap without releasing
  siglock.  This removes the extra re-locking and also avoids taking
  consecutive traps by consuming group stop first.

* 0014-ptrace-make-group-stop-state-visible-via-PTRACE_GETS.patch

  si_pt_flags and si_signo are set while taking trap instead of on
  PTRACE_GETSIGINFO.  Accordingly, NOTIFY is also cleared on STOP
  trap.

This patchset contains the following 17 patches.

  0001-ptrace-remove-silly-wait_trap-variable-from-ptrace_a.patch
  0002-job-control-rename-signal-group_stop-and-flags-to-jo.patch
  0003-ptrace-ptrace_check_attach-rename-kill-to-ignore_sta.patch
  0004-ptrace-relocate-set_current_state-TASK_TRACED-in-ptr.patch
  0005-job-control-introduce-JOBCTL_PENDING_MASK-and-task_c.patch
  0006-job-control-make-task_clear_jobctl_pending-clear-TRA.patch
  0007-job-control-introduce-task_set_jobctl_pending.patch
  0008-ptrace-use-bit_waitqueue-for-TRAPPING-instead-of-wai.patch
  0009-signal-remove-three-noop-tracehooks.patch
  0010-job-control-introduce-JOBCTL_TRAP_STOP-and-use-it-fo.patch
  0011-ptrace-implement-PTRACE_SEIZE.patch
  0012-ptrace-implement-PTRACE_INTERRUPT.patch
  0013-ptrace-add-siginfo.si_pt_flags.patch
  0014-ptrace-make-group-stop-state-visible-via-PTRACE_GETS.patch
  0015-ptrace-don-t-let-PTRACE_SETSIGINFO-override-__SI_TRA.patch
  0016-ptrace-implement-TRAP_NOTIFY-and-use-it-for-group-st.patch
  0017-ptrace-implement-PTRACE_LISTEN.patch

and available in the following git branch.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git review-ptrace-seize

The HEAD is a48ca3deab (ptrace: implement PTRACE_LISTEN).  If you see
older branch, please retry after a while (korg is still syncing).

The patchset is on top of today's (20110530) mainline - 139f37f5e1
(Merge branch 'for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/vapier/blackfin).

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
 include/linux/sched.h                 |   37 ++-
 include/linux/tracehook.h             |   52 -----
 kernel/exit.c                         |    2 
 kernel/ptrace.c                       |  190 +++++++++++++++---
 kernel/signal.c                       |  351 ++++++++++++++++++++++------------
 23 files changed, 543 insertions(+), 218 deletions(-)

Thanks.

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel/1144997
