Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962Ab2JIQIH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 12:08:07 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33928 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab2JIQIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 12:08:04 -0400
Date: Tue, 9 Oct 2012 17:08:02 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] signals.git - part 1
Message-ID: <20121009160802.GT2616@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	This one is mostly kernel_thread/kernel_execve infrastructure +
conversions for arm, x86, um, alpha and s390; all of that has sat in
linux-next for a while.  There are several moderately unpleasant conflicts;
I hadn't rebased that branch, but I'd put proposed conflict resolution into
signal.git#proposed-merge.  Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/signal for-linus

Shortlog:
Al Viro (26):
      x86: get rid of TIF_IRET hackery
      get rid of generic instances of asm/exec.h
      the only place that needs to include asm/exec.h is linux/binfmts.h
      don't bother exporting kernel_execve()
      um: take cleaning singlestep to start_thread()
      um: don't leak floating point state and segment registers on execve()
      um: let signal_delivered() do SIGTRAP on singlestepping into handler
      um: kill thread->forking
      preparation for generic kernel_thread()
      new helper: current_pt_regs()
      generic kernel_execve()
      generic sys_execve()
      arm: split ret_from_fork, simplify kernel_thread() [based on patch by rmk]
      arm: introduce ret_from_kernel_execve(), switch to generic kernel_execve()
      arm: optimized current_pt_regs()
      arm: get rid of execve wrapper, switch to generic execve() implementation
      alpha: switch to generic sys_execve()
      alpha: switch to generic kernel_thread()
      alpha: introduce ret_from_kernel_execve(), switch to generic kernel_execve()
      x86: split ret_from_fork
      x86, um/x86: switch to generic sys_execve and kernel_execve
      um: switch to generic kernel_thread()
      s390: fold execve_tail() into start_thread(), convert to generic sys_execve()
      s390: fold kernel_thread_helper() into ret_from_fork()
      s390: switch to generic kernel_thread()
      s390: convert to generic kernel_execve()

Diffstat:
 arch/Kconfig                            |    3 +
 arch/alpha/Kconfig                      |    1 +
 arch/alpha/include/asm/Kbuild           |    1 +
 arch/alpha/include/asm/exec.h           |    6 --
 arch/alpha/include/asm/processor.h      |    3 -
 arch/alpha/include/asm/unistd.h         |    2 +
 arch/alpha/kernel/alpha_ksyms.c         |    3 -
 arch/alpha/kernel/entry.S               |   69 +++++---------------
 arch/alpha/kernel/process.c             |   79 ++++++-----------------
 arch/arm/Kconfig                        |    1 +
 arch/arm/include/asm/Kbuild             |    1 +
 arch/arm/include/asm/exec.h             |    6 --
 arch/arm/include/asm/processor.h        |    5 --
 arch/arm/include/asm/ptrace.h           |    5 ++
 arch/arm/include/asm/system.h           |    1 -
 arch/arm/include/asm/unistd.h           |    2 +
 arch/arm/kernel/calls.S                 |    2 +-
 arch/arm/kernel/entry-common.S          |   29 +++++++--
 arch/arm/kernel/process.c               |   75 ++++------------------
 arch/arm/kernel/sys_arm.c               |   63 ------------------
 arch/avr32/include/asm/Kbuild           |    1 +
 arch/avr32/include/asm/exec.h           |   13 ----
 arch/c6x/include/asm/Kbuild             |    1 +
 arch/c6x/include/asm/exec.h             |    6 --
 arch/cris/include/asm/Kbuild            |    2 +
 arch/cris/include/asm/exec.h            |    6 --
 arch/frv/include/asm/Kbuild             |    1 +
 arch/frv/include/asm/exec.h             |   17 -----
 arch/h8300/include/asm/Kbuild           |    1 +
 arch/h8300/include/asm/exec.h           |    6 --
 arch/hexagon/kernel/syscall.c           |    1 -
 arch/ia64/include/asm/Kbuild            |    1 +
 arch/ia64/include/asm/exec.h            |   14 ----
 arch/m32r/include/asm/Kbuild            |    2 +
 arch/m32r/include/asm/exec.h            |   14 ----
 arch/m68k/include/asm/Kbuild            |    1 +
 arch/m68k/include/asm/exec.h            |    6 --
 arch/microblaze/include/asm/Kbuild      |    1 +
 arch/microblaze/include/asm/exec.h      |   14 ----
 arch/mn10300/include/asm/Kbuild         |    2 +
 arch/mn10300/include/asm/exec.h         |   16 -----
 arch/parisc/include/asm/Kbuild          |    1 +
 arch/parisc/include/asm/exec.h          |    6 --
 arch/s390/Kconfig                       |    1 +
 arch/s390/include/asm/processor.h       |    4 +-
 arch/s390/include/asm/unistd.h          |    2 +
 arch/s390/kernel/compat_linux.c         |   26 --------
 arch/s390/kernel/compat_linux.h         |    2 -
 arch/s390/kernel/compat_wrapper.S       |    2 +-
 arch/s390/kernel/entry.S                |   51 ++++++---------
 arch/s390/kernel/entry.h                |    3 -
 arch/s390/kernel/entry64.S              |   50 ++++++---------
 arch/s390/kernel/process.c              |  107 ++++++++++---------------------
 arch/sh/include/asm/Kbuild              |    1 +
 arch/sh/include/asm/exec.h              |   10 ---
 arch/sparc/include/asm/Kbuild           |    1 +
 arch/sparc/include/asm/exec.h           |    6 --
 arch/tile/include/asm/Kbuild            |    1 +
 arch/tile/include/asm/exec.h            |   20 ------
 arch/um/include/asm/processor-generic.h |   11 ---
 arch/um/kernel/exec.c                   |   46 ++------------
 arch/um/kernel/internal.h               |    1 -
 arch/um/kernel/process.c                |   25 ++-----
 arch/um/kernel/signal.c                 |    6 ++-
 arch/um/kernel/syscall.c                |   41 ++++--------
 arch/unicore32/include/asm/Kbuild       |    1 +
 arch/unicore32/include/asm/exec.h       |   15 ----
 arch/unicore32/kernel/sys.c             |    1 -
 arch/x86/Kconfig                        |    1 +
 arch/x86/ia32/ia32entry.S               |    2 +-
 arch/x86/ia32/sys_ia32.c                |   15 ----
 arch/x86/include/asm/processor.h        |    5 --
 arch/x86/include/asm/sys_ia32.h         |    2 -
 arch/x86/include/asm/syscalls.h         |    2 +-
 arch/x86/include/asm/thread_info.h      |    2 -
 arch/x86/include/asm/unistd.h           |    2 +
 arch/x86/kernel/Makefile                |    2 +-
 arch/x86/kernel/asm-offsets.c           |    3 +
 arch/x86/kernel/entry_32.S              |   26 +++++--
 arch/x86/kernel/entry_64.S              |   74 +++++++--------------
 arch/x86/kernel/process.c               |   65 -------------------
 arch/x86/kernel/process_32.c            |   37 +++++++++--
 arch/x86/kernel/process_64.c            |   35 ++++++----
 arch/x86/kernel/signal.c                |    4 -
 arch/x86/kernel/sys_i386_32.c           |   40 ------------
 arch/x86/kernel/vm86_32.c               |    6 +-
 arch/x86/syscalls/syscall_32.tbl        |    2 +-
 arch/x86/um/Kconfig                     |    1 +
 arch/x86/um/shared/sysdep/syscalls.h    |    2 +
 arch/x86/um/signal.c                    |    6 --
 arch/x86/um/sys_call_table_32.c         |    3 +-
 arch/x86/um/syscalls_32.c               |   27 ++------
 arch/x86/um/syscalls_64.c               |   23 +------
 arch/xtensa/include/asm/Kbuild          |    2 +
 arch/xtensa/include/asm/exec.h          |   14 ----
 fs/binfmt_elf.c                         |    1 -
 fs/binfmt_elf_fdpic.c                   |    1 -
 fs/exec.c                               |   61 ++++++++++++++++--
 include/linux/binfmts.h                 |    6 ++
 include/linux/compat.h                  |    8 ++-
 include/linux/ptrace.h                  |    4 +
 include/linux/sched.h                   |    3 +
 kernel/fork.c                           |   13 ++++-
 103 files changed, 431 insertions(+), 993 deletions(-)
 delete mode 100644 arch/alpha/include/asm/exec.h
 delete mode 100644 arch/arm/include/asm/exec.h
 delete mode 100644 arch/avr32/include/asm/exec.h
 delete mode 100644 arch/c6x/include/asm/exec.h
 delete mode 100644 arch/cris/include/asm/exec.h
 delete mode 100644 arch/frv/include/asm/exec.h
 delete mode 100644 arch/h8300/include/asm/exec.h
 delete mode 100644 arch/ia64/include/asm/exec.h
 delete mode 100644 arch/m32r/include/asm/exec.h
 delete mode 100644 arch/m68k/include/asm/exec.h
 delete mode 100644 arch/microblaze/include/asm/exec.h
 delete mode 100644 arch/mn10300/include/asm/exec.h
 delete mode 100644 arch/parisc/include/asm/exec.h
 delete mode 100644 arch/sh/include/asm/exec.h
 delete mode 100644 arch/sparc/include/asm/exec.h
 delete mode 100644 arch/tile/include/asm/exec.h
 delete mode 100644 arch/um/kernel/internal.h
 delete mode 100644 arch/unicore32/include/asm/exec.h
 delete mode 100644 arch/x86/kernel/sys_i386_32.c
 delete mode 100644 arch/xtensa/include/asm/exec.h
