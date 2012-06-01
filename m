Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933568Ab2FASST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 14:18:19 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34384 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932690Ab2FASSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 14:18:17 -0400
Date: Fri, 1 Jun 2012 19:18:15 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [git pull] signals, part 3
Message-ID: <20120601181815.GL30000@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This time it's mostly helpers and conversions to them; there's a lot of
stuff remaining in the tree, but that'll either go in -rc2 (isolated bug
fixes, ideally via arch maintainers' trees) or will sit there until the
next cycle.  Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/signal for-linus

Shortlog:
Al Viro (16):
      HAVE_RESTORE_SIGMASK is defined on all architectures now
      new helpers: {clear,test,test_and_clear}_restore_sigmask()
      new helper: restore_saved_sigmask()
      new helper: sigmask_to_save()
      openrisc: tracehook_signal_handler() is supposed to be called on success
      sh64: failure to build sigframe != signal without handler
      pull clearing RESTORE_SIGMASK into block_sigmask()
      don't call try_to_freeze() from do_signal()
      TIF_RESTORE_SIGMASK can be set only when TIF_SIGPENDING is set
      set_restore_sigmask() is never called without SIGPENDING (and never should be)
      most of set_current_blocked() callers want SIGKILL/SIGSTOP removed from set
      powerpc: get rid of restore_sigmask()
      new helper: signal_delivered()
      whack-a-mole with TIF_FREEZE
      blackfin: check __get_user() return value
      x86: get rid of calling do_notify_resume() when returning to kernel mode

David Howells (3):
      FRV: Prevent syscall exit tracing and notify_resume at end of kernel exceptions
      FRV: Shrink TIF_WORK_MASK [ver #2]
      FRV: Optimise the system call exit path in entry.S [ver #2]

Diffstat:
 arch/alpha/kernel/signal.c                |   18 +------
 arch/arm/kernel/signal.c                  |   47 +++-----------------
 arch/avr32/kernel/entry-avr32b.S          |    4 +-
 arch/avr32/kernel/signal.c                |   41 ++++++------------
 arch/blackfin/include/asm/thread_info.h   |    2 -
 arch/blackfin/kernel/signal.c             |   67 ++++++++--------------------
 arch/blackfin/mach-common/entry.S         |    2 -
 arch/c6x/kernel/signal.c                  |   43 +++---------------
 arch/cris/arch-v10/kernel/signal.c        |   34 +++------------
 arch/cris/arch-v32/kernel/signal.c        |   36 +++-------------
 arch/frv/include/asm/thread_info.h        |   16 +++++--
 arch/frv/kernel/entry.S                   |   29 ++++++-------
 arch/frv/kernel/signal.c                  |   57 ++++--------------------
 arch/h8300/kernel/signal.c                |   28 +++---------
 arch/hexagon/kernel/signal.c              |   48 +++-----------------
 arch/ia64/include/asm/thread_info.h       |   18 +++++++-
 arch/ia64/kernel/signal.c                 |   34 ++------------
 arch/m32r/kernel/signal.c                 |   32 +++-----------
 arch/m68k/kernel/signal.c                 |   24 ++--------
 arch/microblaze/include/asm/thread_info.h |   18 +++++++-
 arch/microblaze/kernel/signal.c           |   36 +++------------
 arch/mips/kernel/signal-common.h          |    2 -
 arch/mips/kernel/signal.c                 |   38 +++-------------
 arch/mips/kernel/signal32.c               |    2 -
 arch/mips/kernel/signal_n32.c             |    1 -
 arch/mn10300/kernel/signal.c              |   39 ++++-------------
 arch/openrisc/kernel/signal.c             |   40 +++--------------
 arch/parisc/include/asm/thread_info.h     |    2 +-
 arch/parisc/kernel/entry.S                |    4 +-
 arch/parisc/kernel/signal.c               |   47 +++++---------------
 arch/parisc/kernel/signal32.c             |    2 -
 arch/powerpc/include/asm/thread_info.h    |   18 +++++++-
 arch/powerpc/kernel/signal.c              |   36 +--------------
 arch/powerpc/kernel/signal.h              |    3 -
 arch/powerpc/kernel/signal_32.c           |    4 +-
 arch/powerpc/kernel/signal_64.c           |    4 +-
 arch/s390/kernel/compat_signal.c          |   12 ++---
 arch/s390/kernel/entry.h                  |    2 +-
 arch/s390/kernel/signal.c                 |   47 ++++----------------
 arch/score/kernel/signal.c                |   40 +++--------------
 arch/sh/include/asm/thread_info.h         |   19 ++++++++-
 arch/sh/kernel/signal_32.c                |   43 ++++---------------
 arch/sh/kernel/signal_64.c                |   47 +++++---------------
 arch/sparc/include/asm/thread_info_32.h   |    3 +-
 arch/sparc/include/asm/thread_info_64.h   |   18 +++++++-
 arch/sparc/kernel/signal32.c              |   27 ++---------
 arch/sparc/kernel/signal_32.c             |   39 +++-------------
 arch/sparc/kernel/signal_64.c             |   34 +++------------
 arch/tile/include/asm/thread_info.h       |   18 +++++++-
 arch/tile/kernel/compat_signal.c          |    3 -
 arch/tile/kernel/signal.c                 |   42 +++---------------
 arch/um/include/shared/frame_kern.h       |    3 -
 arch/um/kernel/signal.c                   |   37 +++-------------
 arch/unicore32/kernel/signal.c            |   47 +++-----------------
 arch/x86/ia32/ia32_signal.c               |    2 -
 arch/x86/include/asm/sighandling.h        |    2 -
 arch/x86/include/asm/thread_info.h        |   18 +++++++-
 arch/x86/kernel/entry_32.S                |   13 ++++-
 arch/x86/kernel/signal.c                  |   60 ++++++--------------------
 arch/x86/um/signal.c                      |    2 -
 arch/xtensa/kernel/signal.c               |   21 +--------
 fs/compat.c                               |    4 --
 fs/eventpoll.c                            |    4 --
 fs/select.c                               |    4 --
 include/linux/sched.h                     |   14 ++++++
 include/linux/signal.h                    |    5 +-
 include/linux/thread_info.h               |   19 ++++++++-
 kernel/signal.c                           |   48 +++++++++++++-------
 68 files changed, 482 insertions(+), 1091 deletions(-)
