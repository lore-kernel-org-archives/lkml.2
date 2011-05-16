Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558Ab1EPSRg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 14:17:36 -0400
Received: from mail-bw0-f52.google.com ([209.85.214.52]:37249 "EHLO
	mail-bw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab1EPSRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 14:17:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=g2lmkYdrAUNUZccdLfQ1gc3KfjUXdxYbmGxUUKIjFZz9oPX0sYCdFioCO2ENbupJkQ
         RyoIALZLS3Cr/Tmdmt93Ae/xGqNqEyKLCbhD+znz6CIeyqETmA6AVW6XuMZPkC/Avo/T
         HD+LdAK8PGYyT8La8p16XZ/EfDc+6jLDQF4aw=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com
Subject: [PATCHSET ptrace] ptrace: implement PTRACE_SEIZE/INTERRUPT and group stop notification, take#2
Date: Mon, 16 May 2011 20:17:19 +0200
Message-Id: <1305569849-10448-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is the second try at implementing PTRACE_SEIZE/INTERRUPT and
group stop notification.  Notable changes from the first take[1] are,

* Prep patches moved to a separate patchset[2].

* JOBCTL_EVENT_INTERRUPT renamed to JOBCTL_EVENT_STOP and now also
  used for group stop.  This means that PTRACE_GETSIGINFO will always
  return a valid siginfo.  For signal delivery traps, it will contain
  the siginfo for the signal being delivered.  For all other traps, it
  will contain the trap information which includes group stop info.

* JOBCTL_TRAP_STOP trap doesn't carry signo in si_code and the signal
  which initiated the group stop currently in effect can be obtained
  from siginfo.si_signo.

* JOBCTL_INTERRUPT triggers JOBCTL_EVENT_STOP and gets cleared on any
  trap, so the initial trap by JOBCTL_SEIZE is identical to
  JOBCTL_INTERRUPT.

* PTRACE_SETSIGINFO disallows overriding __SI_TRAP siginfo.

* Re-trap delay mechanism added to avoid re-trapping while ptrace
  request is in progress.

So, PTRACE_INTERRUPT simply puts the tracee into the same state as
group stop and this simplifies things a lot.  Trap siginfo is also
accessible during group stop and group stop notification happening
during PTRACE_EVENT_STOP makes sense and there's no awkward careful
sequencing of traps to avoid unnecessary traps.  I think it makes
whole lot more sense this way.

This patchset contains the following ten patches.

  0001-signal-remove-three-noop-tracehooks.patch
  0002-job-control-introduce-JOBCTL_TRAP_STOP-and-use-it-fo.patch
  0003-ptrace-implement-PTRACE_SEIZE.patch
  0004-ptrace-implement-PTRACE_INTERRUPT.patch
  0005-ptrace-restructure-ptrace_getsiginfo.patch
  0006-ptrace-add-siginfo.si_pt_flags.patch
  0007-ptrace-make-group-stop-state-visible-via-PTRACE_GETS.patch
  0008-ptrace-don-t-let-PTRACE_SETSIGINFO-override-__SI_TRA.patch
  0009-ptrace-add-JOBCTL_BLOCK_NOTIFY.patch
  0010-ptrace-implement-group-stop-notification-for-ptracer.patch

0001 removes three signal tracehooks.  Will be moved to the prep
patchset on the next round.

0002 introduces TRAP_STOP and 0003-0004 implement SEIZE and INTERRUPT.

0005-0008 expose group stop info via GETSIGINFO.

0009-0010 implement group stop notification.

This patchset is on top of Oleg's ptrace branch[3] + prep patchset[2]
and available in the following git branch.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git review-ptrace-seize

The HEAD is 8026ce454dd46dc3c8cf6bbc57bcd30f5efa4e55.  If you see
older branch, please retry after a while (korg is still syncing).

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
 include/asm-generic/siginfo.h         |   10 +
 include/linux/ptrace.h                |   13 ++
 include/linux/sched.h                 |    6 
 include/linux/tracehook.h             |   52 --------
 kernel/ptrace.c                       |  202 +++++++++++++++++++++++++++----
 kernel/signal.c                       |  215 +++++++++++++++++++++++-----------
 21 files changed, 452 insertions(+), 147 deletions(-)

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel/1136930
[2] http://thread.gmane.org/gmane.linux.kernel/1139751
[3] git://git.kernel.org/pub/scm/linux/kernel/git/oleg/misc.git
