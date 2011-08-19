Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023Ab1HSQrR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 12:47:17 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:57220 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751127Ab1HSQrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 12:47:14 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2 00/43] signal: set_current_blocked() and block_sigmask()
Date: Fri, 19 Aug 2011 17:46:16 +0100
Message-Id: <1313772419-21951-1-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

Hi Oleg,

This v2 includes block_sigmask(). You'll have to take the "Use
set_current_blocked() and block_sigmask()" patches in your tree once
the architecture maintainers have Acked them because they all now
depend on the first patch in the series "signal: Add block_sigmask()
for adding sigmask to current->blocked", so if arch maintainers were
to take them in their separate trees they'd introduce compiler
breakage. In fact, it's probably worth just taking this entire series
into one tree. Also, because I can't Cc all the maintainers in this
one email (I counted 45 different email addresses!) I've included
information in their patches.

If you need help with the git tree stuff just let me know, or I can
gather all the ACKs and then send you a pull request. We'll work
something out.

I did a tree wide scan of all the code that modifies current->blocked
without using the set_current_blocked() accessor. This patch series is
the result of the conversion to the new accessor functions.

This series also helps to reduce the complexity of my signal
scalability patches that I posted in April, because we now have much
fewer callers of recalc_sigpending() (the signal scalability patches
introduce a new lock that needs to be held when calling
recalc_sigpending()).

This series is available in the 'oleg/set-current-blocked-v2' branch at,

    git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/linux-2.6.git

P.S I've punted on fully converting ia64 to set_current_blocked()
because bits of the signal code are written in asm. I'll follow up
with a later patch that does the conversion once I've improved my ia64
foo (or coerced Tony Luck into doing it ;).

Matt Fleming (42):
  signal: Add block_sigmask() for adding sigmask to current->blocked
  alpha: Use set_current_blocked() and block_sigmask()
  arm: Use set_current_blocked() and block_sigmask()
  avr32: Don't mask signals in the error path
  avr32: Use block_sigmask()
  blackfin: Use set_current_blocked() and block_sigmask()
  cris: Use set_current_blocked() and block_sigmask()
  frv: Use set_current_blocked() and block_sigmask()
  h8300: Use set_current_blocked() and block_sigmask()
  ia64: Use set_current_blocked() and block_sigmask()
  m32r: Use set_current_blocked() and block_sigmask()
  m68k: Use set_current_blocked() and block_sigmask()
  microblaze: Don't reimplement force_sigsegv()
  microblaze: No need to reset handler if SA_ONESHOT
  microblaze: Fix signal masking
  microblaze: Use set_current_blocked() and block_sigmask()
  MIPS: Use set_current_blocked() and block_sigmask()
  mn10300: Use set_current_blocked() and block_sigmask()
  OpenRISC: Don't reimplement force_sigsegv()
  OpenRISC: No need to reset handler if SA_ONESHOT
  OpenRISC: Don't mask signals if we fail to setup signal stack
  OpenRISC: Use set_current_blocked() and block_sigmask()
  parisc: Use set_current_blocked() and block_sigmask()
  powerpc: Use set_current_blocked() and block_sigmask()
  [S390]: Use block_sigmask()
  score: Don't mask signals if we fail to setup signal stack
  score: Use set_current_blocked() and block_sigmask()
  sh: No need to reset handler if SA_ONESHOT
  sh: Use set_current_blocked() and block_sigmask()
  sparc: Use set_current_blocked() and block_sigmask()
  tile: Use set_current_blocked() and block_sigmask()
  um: Use set_current_blocked() and block_sigmask()
  um: Don't restore current->blocked on error
  unicore32: Use set_current_blocked() and block_sigmask()
  xtensa: Don't reimplement force_sigsegv()
  xtensa: No need to reset handler if SA_ONESHOT
  xtensa: Don't mask signals if we fail to setup signal stack
  xtensa: Use set_current_blocked() and block_sigmask()
  autofs4: Use set_current_blocked()
  coda: Use set_current_blocked()
  dlm: Remove another superfluous call to recalc_sigpending()
  ncpfs: Use set_current_blocked()

Oleg Nesterov (1):
  avr32: use set_current_blocked() in handle_signal/sys_rt_sigreturn

 arch/alpha/kernel/signal.c         |   31 ++++++++----------------
 arch/arm/kernel/signal.c           |   24 ++++++------------
 arch/avr32/kernel/signal.c         |   26 ++++++--------------
 arch/blackfin/kernel/signal.c      |   17 +++----------
 arch/cris/arch-v10/kernel/signal.c |   34 +++++++++-----------------
 arch/cris/arch-v32/kernel/signal.c |   37 ++++++++--------------------
 arch/frv/kernel/signal.c           |   32 ++++++++-----------------
 arch/h8300/kernel/signal.c         |   33 +++++++-------------------
 arch/ia64/kernel/signal.c          |   15 +----------
 arch/m32r/kernel/signal.c          |   12 +--------
 arch/m68k/kernel/signal_mm.c       |   22 +++++++----------
 arch/m68k/kernel/signal_no.c       |   28 +++++++---------------
 arch/microblaze/kernel/signal.c    |   42 +++++++++++++--------------------
 arch/mips/kernel/signal.c          |   27 ++++-----------------
 arch/mips/kernel/signal32.c        |   20 +++------------
 arch/mips/kernel/signal_n32.c      |   10 +------
 arch/mn10300/kernel/signal.c       |   32 ++++++++-----------------
 arch/openrisc/kernel/signal.c      |   45 +++++++++++++++--------------------
 arch/parisc/kernel/signal.c        |   12 +--------
 arch/powerpc/kernel/signal.c       |   13 +--------
 arch/powerpc/kernel/signal_32.c    |   11 ++++----
 arch/s390/kernel/compat_signal.c   |    6 +----
 arch/s390/kernel/signal.c          |    6 +----
 arch/score/kernel/signal.c         |   13 ++--------
 arch/sh/kernel/signal_32.c         |   35 ++++++++--------------------
 arch/sh/kernel/signal_64.c         |   40 ++++++++------------------------
 arch/sparc/kernel/signal32.c       |   17 ++-----------
 arch/sparc/kernel/signal_32.c      |   28 +++++++---------------
 arch/sparc/kernel/signal_64.c      |   29 ++++++++---------------
 arch/tile/kernel/compat_signal.c   |    5 +---
 arch/tile/kernel/signal.c          |   13 +--------
 arch/um/kernel/signal.c            |   28 +++++++---------------
 arch/um/sys-i386/signal.c          |   12 +--------
 arch/um/sys-x86_64/signal.c        |    6 +----
 arch/unicore32/kernel/signal.c     |   13 +--------
 arch/x86/kernel/signal.c           |    6 +----
 arch/xtensa/kernel/signal.c        |   35 ++++++++-------------------
 fs/autofs4/waitq.c                 |   13 +++-------
 fs/coda/upcall.c                   |   19 ++++++--------
 fs/dlm/user.c                      |    1 -
 fs/ncpfs/sock.c                    |   15 ++++--------
 include/linux/signal.h             |    1 +
 kernel/signal.c                    |   21 ++++++++++++++++
 43 files changed, 276 insertions(+), 609 deletions(-)

-- 
1.7.4.4

