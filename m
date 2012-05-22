Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab2EVEf3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 00:35:29 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48042 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503Ab2EVEf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 00:35:27 -0400
Date: Tue, 22 May 2012 05:35:25 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [git pull] signals, the first series
Message-ID: <20120522043525.GI11775@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	This is just the first part of the queue (about a half of it);
assorted fixes all over the place in signals' handling.  This one ends
with all sigsuspend() implementations switched to generic one
(->saved_sigmask-based), a bunch of assorted old buglets fixed and most
of the missing bits of NOTIFY_RESUME hookup in place (two more sit in
arm and um trees resp. and there's a couple of broken ones that need
obvious fixes - parisc and avr32 check TIF_NOTIFY_RESUME only on one of
two codepaths; that'll go in the next series).  Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/signal.git for-linus

Shortlog:
Al Viro (35):
      new helper: sigsuspend()
      parisc: resetting ->restart_block.fn needs to be done on rt_sigreturn()
      c6x: ->restart_block.fn needs to be reset on rt_sigreturn
      hexagon: ->restart_block.fn needs to be reset on rt_sigreturn
      microblaze: ->restart_block.fn needs to be reset on rt_sigreturn
      score: ->restart_block.fn needs to be reset on rt_sigreturn
      xtensa: ->restart_block.fn needs to be reset on rt_sigreturn
      avr32: ->restart_block.fn needs to be reset on rt_sigreturn
      xtensa: switch to generic rt_sigsuspend(2)
      sh: switch to saved_sigmask-based sigsuspend()/rt_sigsuspend()
      h8300: don't change blocked signals' mask if setting frame up fails
      h8300: switch to saved_sigmask-based sigsuspend/rt_sigsuspend
      cris: SA_ONESHOT handling is done by get_signal_to_deliver()
      microblaze: bury sys_rt_sigsuspend_wrapper in nommu case too
      avr32: need to clear RESTORE_SIGMASK on successful signal delivery
      blackfin: don't open-code force_sigsegv()
      cris: don't open-code force_sigsegv()
      score: don't open-code force_sigsegv()
      alpha: tidy signal delivery up
      xtensa: xtensa_sigaction doesn't exist
      m32r: struct old_sigaction is never used
      avr32: struct old_sigaction is never used
      sparc: missing checks of __get_user()/__put_user() return values
      sh: missing checks of __get_user()/__put_user() return values
      powerpc: missing checks of __get_user()/__put_user() return values
      cris: missing checks of __get_user()/__put_user() return values
      frv: missing checks of __get_user()/__put_user() return values
      h8300: missing checks of __get_user()/__put_user() return values
      sparc: kill ancient comment in sparc_sigaction()
      m68k: add TIF_NOTIFY_RESUME and handle it.
      score: add handling of NOTIFY_RESUME to do_notify_resume()
      microblaze: handle TIF_NOTIFY_RESUME
      microblaze: drop 'oldset' argument of do_notify_resume()
      xtensa: add handling of TIF_NOTIFY_RESUME
      unicore32: if there's no handler we need to restore sigmask, syscall or no syscall

Matt Fleming (18):
      parisc: use set_current_blocked() and block_sigmask()
      frv: use set_current_blocked() and block_sigmask()
      blackfin: use set_current_blocked() and block_sigmask()
      unicore32: use block_sigmask()
      h8300: use set_current_blocked() and block_sigmask()
      score: don't mask signals if we fail to setup signal stack
      score: use set_current_blocked() and block_sigmask()
      microblaze: don't reimplement force_sigsegv()
      microblaze: no need to reset handler if SA_ONESHOT
      microblaze: fix signal masking
      microblaze: use set_current_blocked() and block_sigmask()
      ia64: use set_current_blocked() and block_sigmask()
      cris: use set_current_blocked() and block_sigmask()
      mn10300: use set_current_blocked() and block_sigmask()
      m32r: use set_current_blocked() and block_sigmask()
      avr32: don't mask signals in the error path
      avr32: use block_sigmask()
      m68k: use set_current_blocked() and block_sigmask()

Oleg Nesterov (2):
      avr32: use set_current_blocked() in handle_signal/sys_rt_sigreturn
      hexagon: do_notify_resume() needs tracehook_notify_resume()

Diffstat:
 arch/alpha/kernel/signal.c            |   80 +++++++--------------
 arch/arm/kernel/signal.c              |   11 +---
 arch/avr32/include/asm/signal.h       |    7 --
 arch/avr32/kernel/signal.c            |   30 +++-----
 arch/blackfin/kernel/signal.c         |   21 ++----
 arch/c6x/kernel/signal.c              |    3 +
 arch/cris/arch-v10/kernel/signal.c    |   50 ++++---------
 arch/cris/arch-v32/kernel/signal.c    |   66 ++++-------------
 arch/frv/kernel/signal.c              |   47 ++++---------
 arch/h8300/include/asm/unistd.h       |    1 +
 arch/h8300/kernel/signal.c            |  122 +++++++++++----------------------
 arch/h8300/kernel/syscalls.S          |    6 --
 arch/hexagon/kernel/signal.c          |    4 +
 arch/ia64/kernel/signal.c             |   15 +----
 arch/m32r/include/asm/signal.h        |    7 --
 arch/m32r/kernel/signal.c             |   12 +---
 arch/m68k/include/asm/thread_info.h   |    1 +
 arch/m68k/kernel/entry_mm.S           |    6 +-
 arch/m68k/kernel/signal.c             |   41 ++++++------
 arch/m68k/platform/68328/entry.S      |    2 +-
 arch/m68k/platform/68360/entry.S      |    2 +-
 arch/m68k/platform/coldfire/entry.S   |    2 +-
 arch/microblaze/kernel/entry-nommu.S  |   20 ++----
 arch/microblaze/kernel/entry.S        |   30 ++++-----
 arch/microblaze/kernel/signal.c       |   85 ++++++++++++-----------
 arch/mips/kernel/signal.c             |   20 +-----
 arch/mips/kernel/signal32.c           |   20 +-----
 arch/mips/kernel/signal_n32.c         |   10 +---
 arch/mn10300/kernel/signal.c          |   35 ++--------
 arch/parisc/kernel/signal.c           |   15 +---
 arch/powerpc/kernel/signal_32.c       |   17 +----
 arch/s390/kernel/signal.c             |    9 +--
 arch/score/kernel/signal.c            |   29 ++++----
 arch/sh/include/asm/syscalls_32.h     |    4 +-
 arch/sh/include/asm/unistd.h          |    4 +-
 arch/sh/kernel/signal_32.c            |   53 ++++++--------
 arch/sh/kernel/signal_64.c            |   84 ++++------------------
 arch/sparc/kernel/signal32.c          |   10 ++-
 arch/sparc/kernel/signal_32.c         |   12 +---
 arch/sparc/kernel/signal_64.c         |   13 +---
 arch/sparc/kernel/sys_sparc_32.c      |   17 ++---
 arch/um/kernel/signal.c               |    9 +--
 arch/unicore32/kernel/signal.c        |   18 ++---
 arch/x86/ia32/ia32_signal.c           |   12 +---
 arch/x86/kernel/signal.c              |   12 +---
 arch/xtensa/include/asm/signal.h      |    7 --
 arch/xtensa/include/asm/syscall.h     |    4 -
 arch/xtensa/include/asm/thread_info.h |    1 +
 arch/xtensa/include/asm/unistd.h      |    2 +-
 arch/xtensa/kernel/entry.S            |    6 +-
 arch/xtensa/kernel/signal.c           |   73 +++++++++-----------
 include/linux/signal.h                |    1 +
 kernel/compat.c                       |   10 +---
 kernel/signal.c                       |   25 ++++---
 54 files changed, 386 insertions(+), 817 deletions(-)
