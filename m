Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab2LKQEB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 11:04:01 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:38146 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab2LKQD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 11:03:58 -0500
Date: Tue, 11 Dec 2012 16:03:57 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [git pull] execve/kernel_thread/fork unification series
Message-ID: <20121211160356.GJ4939@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	* kernel_thread()/kernel_execve()/sys_execve() redesign.
We don't do syscalls from kernel anymore for either kernel_thread() or
kernel_execve(); kernel_thread() is essentially clone(2) with callback
run before we return to userland, the callbacks either never return or
do successful do_execve() before returning.  kernel_execve() is a wrapper
for do_execve() - it doesn't need to do transition to user mode anymore.
kernel_thread() and kernel_execve() are arch-independent now - they
live in kernel/fork.c and fs/exec.c resp.  sys_execve() is also in fs/exec.c
and it's completely architecture-independent.
	* daemonize() is gone, along with its parts in fs/*.c
	* struct pt_regs * is no longer passed to do_fork/copy_process/
copy_thread/do_execve/search_binary_handler/->load_binary/do_coredump.
	* sys_fork()/sys_vfork()/sys_clone() unified; some architectures
still need wrappers (ones with callee-saved registers not saved in pt_regs
on syscall entry), but the main part of those suckers is in kernel/fork.c
now.
	All architectures are converted to new model.  Quite a bit of
that stuff is actually shared with architecture trees; in such cases
it's literally shared branch pulled by both, not a cherry-pick.

	A lot of ugliness and black magic is gone (-3KLoC total in this
one).  Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/signal for-linus

Shortlog:
Al Viro (107):
      sparc64: clear syscall_noerror on the entry to syscall, not on the exit
      sparc64: switch to generic kernel_thread()
      sparc64: take fprs_write() and friends to start_thread()
      sparc64: switch to generic kernel_execve()
      mips: switch to generic kernel_thread()
      ia64: clone() had been unused since 2004
      ia64: dead code in copy_thread() since 2004
      ia64: don't mess with ar_bspstore in kernel_thread()
      powerpc: switch to saner kernel_execve() semantics
      powerpc: don't mess with r2 in copy_thread() and friends
      parisc: switch to generic kernel_thread()
      parisc: switch to generic kernel_execve()
      parisc: switch to generic sys_execve()
      parisc: optimizations in copy_thread() and friends
      h8300: generic kernel_thread()
      h8300: generic kernel_execve()
      h8300: generic sys_execve()
      mn10300: switch to saner kernel_execve() semantics
      blackfin: convert kernel_thread() and kernel_execve() to generic ones
      blackfin: switch to generic sys_execve()
      cris: switch to generic kernel_thread()
      cris: switch to generic kernel_execve/sys_execve
      avr32: switch to generic kernel_thread()/kernel_execve()
      avr32: switch to generic sys_execve()
      c6x: switch to saner kernel_execve() semantics
      score: switch to generic kernel_thread()/kernel_execve()
      score: switch to generic sys_execve()
      mips: switch to saner kernel_execve() semantics
      sparc64: convert to generic execve
      sparc32: bury the remnants of LOWSYS tricks
      sparc32: switch to generic kernel_thread()
      sparc32: switch to generic kernel_execve()
      sparc32: switch to generic sys_execve()
      m68k: switch to saner kernel_execve() semantics
      ia64: switch to generic kernel_thread()/kernel_execve()
      ia64: switch to generic sys_execve()
      Drop struct pt_regs * argument in compat_sys_execve()
      powerpc: take dereferencing to ret_from_kernel_thread()
      powerpc: don't bother with zero-extending arguments in sys_clone()
      powerpc: don't bother with CHECK_FULL_REGS in sys_fork() et.al.
      powerpc: put the "zero usp means using parent's stack pointer" to copy_thread()
      powerpc: make fork_idle() take the common "kernel thread" path in copy_thread()
      parisc: switch to saner kernel_execve() semantics
      arm64: get rid of fork/vfork/clone wrappers
      sh: switch to generic kernel_thread()/kernel_execve()
      sh: convert to generic sys_execve()
      tile: switch to generic sys_execve()
      hexagon: kernel_thread()/kernel_execve() conversion
      hexagon: switch to generic sys_execve()
      tile: sanitize copy_thread()
      s390: switch to saner kernel_execve() semantics
      m32r: switch to generic kernel_thread()/kernel_execve()
      m32r: switch to generic sys_execve()
      microblaze: switch to generic kernel_thread()
      microblaze: switch to generic kernel_execve()
      microblaze: switch to generic sys_execve()
      tile: compat rt_sigreturn gets too enthusiastic about sigaltstack errors
      kill daemonize()
      um: don't bother with passing sp to do_fork() for fork(2)/vfork(2)
      um: don't bother looking at regs in copy_thread() - current_pt_regs() is what we'll get
      alpha: simplify fork and friends
      alpha: don't pass useless arguments to do_{,rt_},sigreturn()
      alpha: reorganize copy_process(), prepare to saner fork_idle()
      generic sys_fork / sys_vfork / sys_clone
      consolidate sys_execve() prototype
      audit: no nested contexts anymore...
      kill stray kernel_thread() garbage
      make compat_do_execve() static, lose pt_regs argument
      get rid of pt_regs argument of do_execve()
      get rid of pt_regs argument of do_execve_common()
      get rid of pt_regs argument of search_binary_handler()
      get rid of pt_regs argument of ->load_binary()
      x86, um: switch to generic fork/vfork/clone
      arm: switch to generic fork/vfork/clone
      powerpc: switch to generic fork/clone/vfork
      frv: switch to generic fork/vfork/clone
      arm64: sanitize copy_thread(), switch to generic fork/vfork/clone
      avr32: sanitize copy_thread(), switch to generic fork/vfork/clone, kill wrappers
      cris: switch to generic fork/vfork/clone
      m32r: switch to generic fork/vfork/clone
      parisc: switch to generic fork/vfork/clone
      sh: switch to generic fork/vfork/clone
      hexagon: switch to generic clone()
      microblaze: switch to generic fork/vfork/clone
      s390: switch to generic fork/vfork/clone
      alpha: switch to generic fork/vfork/clone
      m68k: sanitize copy_thread(), fork/vfork/clone wrappers, switch to generic fork/vfork
      tile: switch to generic clone()
      h8300: switch to generic fork/vfork/clone
      mn10300: switch to generic fork/vfork/clone
      take sys_fork/sys_vfork/sys_clone prototypes to linux/syscalls.h
      c6x: sanitize copy_thread(), get rid of clone(2) wrapper, switch to generic clone()
      score: switch to generic fork/vfork/clone
      unicore32: switch to generic clone(2)
      openrisc: switch to use of generic fork and clone
      xtensa: switch to generic clone()
      bfin: switch to generic vfork, get rid of pointless wrappers
      flagday: don't pass regs to copy_thread()
      don't pass regs to copy_process()
      death to idle_regs()
      flagday: kill pt_regs argument of do_fork()
      unify default ptrace_signal_deliver
      new helper: signal_pt_regs()
      get rid of ptrace_signal_deliver() arguments
      ptrace_signal(): get rid of unused arguments
      print_fatal_signal(): get rid of pt_regs argument
      do_coredump(): get rid of pt_regs argument

Catalin Marinas (3):
      arm64: Use generic kernel_thread() implementation
      arm64: Use generic kernel_execve() implementation
      arm64: Use generic sys_execve() implementation

Chris Metcalf (2):
      tile: support GENERIC_KERNEL_THREAD and GENERIC_KERNEL_EXECVE
      arch/tile: eliminate pt_regs trampolines for syscalls

Jonas Bonn (3):
      openrisc: pass correct arg to schedule_tail
      openrisc: use generic kernel_thread/kernel_execve
      openrisc: use generic sys_execve

Michal Simek (1):
      microblaze: Fix bug with schedule_tail

Ralf Baechle (1):
      MIPS: Switch over to generic sys_execve and kernel_execve.

Diffstat:
 arch/Kconfig                             |   14 ++
 arch/alpha/include/asm/ptrace.h          |    1 +
 arch/alpha/include/asm/signal.h          |    3 -
 arch/alpha/include/asm/unistd.h          |    3 +
 arch/alpha/kernel/binfmt_loader.c        |    4 +-
 arch/alpha/kernel/entry.S                |   51 ++-----
 arch/alpha/kernel/process.c              |   62 ++------
 arch/alpha/kernel/signal.c               |   16 +-
 arch/alpha/kernel/systbls.S              |    6 +-
 arch/arm/Kconfig                         |    1 +
 arch/arm/include/asm/signal.h            |    1 -
 arch/arm/include/asm/unistd.h            |    3 +
 arch/arm/kernel/calls.S                  |    6 +-
 arch/arm/kernel/entry-common.S           |   16 --
 arch/arm/kernel/process.c                |   11 +-
 arch/arm/kernel/sys_arm.c                |   31 ----
 arch/arm64/Kconfig                       |    3 +
 arch/arm64/include/asm/processor.h       |    5 -
 arch/arm64/include/asm/syscalls.h        |    8 -
 arch/arm64/include/asm/unistd.h          |    4 +
 arch/arm64/include/asm/unistd32.h        |    8 +-
 arch/arm64/kernel/entry.S                |   17 +--
 arch/arm64/kernel/process.c              |   86 ++++-------
 arch/arm64/kernel/sys.c                  |   81 ----------
 arch/arm64/kernel/sys32.S                |   19 ---
 arch/arm64/kernel/sys_compat.c           |   39 -----
 arch/avr32/Kconfig                       |    2 +
 arch/avr32/include/asm/processor.h       |    3 -
 arch/avr32/include/asm/signal.h          |    2 -
 arch/avr32/include/asm/unistd.h          |    4 +
 arch/avr32/kernel/Makefile               |    2 +-
 arch/avr32/kernel/entry-avr32b.S         |   14 +-
 arch/avr32/kernel/process.c              |  115 +++------------
 arch/avr32/kernel/sys_avr32.c            |   24 ---
 arch/avr32/kernel/syscall-stubs.S        |   24 ---
 arch/avr32/kernel/syscall_table.S        |    8 +-
 arch/blackfin/Kconfig                    |    2 +
 arch/blackfin/include/asm/processor.h    |    2 -
 arch/blackfin/include/asm/unistd.h       |    2 +
 arch/blackfin/kernel/entry.S             |   55 +------
 arch/blackfin/kernel/process.c           |   98 +++----------
 arch/blackfin/kernel/signal.c            |    4 +-
 arch/blackfin/mach-common/entry.S        |   57 +-------
 arch/c6x/Kconfig                         |    1 +
 arch/c6x/include/asm/syscalls.h          |    4 -
 arch/c6x/include/uapi/asm/unistd.h       |    2 +-
 arch/c6x/kernel/entry.S                  |   24 +---
 arch/c6x/kernel/process.c                |   25 +---
 arch/cris/Kconfig                        |    3 +
 arch/cris/arch-v10/kernel/entry.S        |   17 +-
 arch/cris/arch-v10/kernel/process.c      |  121 +++-------------
 arch/cris/arch-v32/kernel/entry.S        |   22 ++-
 arch/cris/arch-v32/kernel/process.c      |  118 +++------------
 arch/cris/include/asm/processor.h        |    2 -
 arch/cris/include/asm/signal.h           |    6 -
 arch/cris/include/asm/unistd.h           |    4 +
 arch/cris/kernel/crisksyms.c             |    1 -
 arch/frv/include/asm/unistd.h            |    3 +
 arch/frv/kernel/process.c                |   45 +-----
 arch/h8300/Kconfig                       |    2 +
 arch/h8300/include/asm/processor.h       |    2 -
 arch/h8300/include/asm/ptrace.h          |    3 +
 arch/h8300/include/asm/signal.h          |    2 -
 arch/h8300/include/asm/unistd.h          |    4 +
 arch/h8300/kernel/entry.S                |    9 +
 arch/h8300/kernel/h8300_ksyms.c          |    1 -
 arch/h8300/kernel/process.c              |  100 ++-----------
 arch/h8300/kernel/sys_h8300.c            |   26 ----
 arch/h8300/kernel/syscalls.S             |    9 -
 arch/hexagon/Kconfig                     |    2 +
 arch/hexagon/include/asm/processor.h     |    1 -
 arch/hexagon/include/asm/syscall.h       |    8 -
 arch/hexagon/include/uapi/asm/ptrace.h   |    4 +
 arch/hexagon/include/uapi/asm/unistd.h   |    2 +
 arch/hexagon/kernel/Makefile             |    3 +-
 arch/hexagon/kernel/process.c            |  100 ++++---------
 arch/hexagon/kernel/signal.c             |    4 +-
 arch/hexagon/kernel/syscall.c            |   89 -----------
 arch/hexagon/kernel/vm_entry.S           |    4 +
 arch/ia64/Kconfig                        |    2 +
 arch/ia64/include/asm/processor.h        |   16 --
 arch/ia64/include/asm/signal.h           |    2 -
 arch/ia64/include/asm/unistd.h           |    1 +
 arch/ia64/kernel/entry.S                 |   53 ++++---
 arch/ia64/kernel/head.S                  |   13 --
 arch/ia64/kernel/process.c               |  161 ++++++++-------------
 arch/ia64/kernel/smpboot.c               |    5 -
 arch/m32r/Kconfig                        |    2 +
 arch/m32r/include/asm/processor.h        |    5 -
 arch/m32r/include/asm/ptrace.h           |    2 +
 arch/m32r/include/asm/signal.h           |    4 -
 arch/m32r/include/asm/unistd.h           |    4 +
 arch/m32r/kernel/entry.S                 |    9 +
 arch/m32r/kernel/m32r_ksyms.c            |    1 -
 arch/m32r/kernel/process.c               |  126 ++--------------
 arch/m32r/kernel/sys_m32r.c              |   21 ---
 arch/m68k/Kconfig                        |    1 +
 arch/m68k/include/asm/signal.h           |    8 +-
 arch/m68k/include/asm/unistd.h           |    3 +-
 arch/m68k/kernel/entry.S                 |   30 +---
 arch/m68k/kernel/process.c               |   87 ++++-------
 arch/m68k/kernel/signal.c                |    3 +-
 arch/m68k/kernel/syscalltable.S          |    6 +-
 arch/microblaze/Kconfig                  |    3 +
 arch/microblaze/include/asm/Kbuild       |    1 +
 arch/microblaze/include/asm/processor.h  |    8 +-
 arch/microblaze/include/asm/syscalls.h   |   16 --
 arch/microblaze/include/asm/unistd.h     |    6 +
 arch/microblaze/kernel/entry-nommu.S     |   20 +--
 arch/microblaze/kernel/entry.S           |   57 +------
 arch/microblaze/kernel/process.c         |   75 +++-------
 arch/microblaze/kernel/sys_microblaze.c  |   53 -------
 arch/microblaze/kernel/syscall_table.S   |    6 +-
 arch/mips/Kconfig                        |    2 +
 arch/mips/include/asm/processor.h        |    2 -
 arch/mips/include/asm/ptrace.h           |    6 +
 arch/mips/include/asm/signal.h           |    2 -
 arch/mips/include/asm/unistd.h           |    1 +
 arch/mips/kernel/entry.S                 |    6 +
 arch/mips/kernel/linux32.c               |   23 +---
 arch/mips/kernel/mips_ksyms.c            |    2 -
 arch/mips/kernel/process.c               |   64 +++-----
 arch/mips/kernel/scall64-n32.S           |    2 +-
 arch/mips/kernel/scall64-o32.S           |    2 +-
 arch/mips/kernel/syscall.c               |   57 +-------
 arch/mn10300/Kconfig                     |    1 +
 arch/mn10300/include/asm/signal.h        |    4 -
 arch/mn10300/include/asm/unistd.h        |    4 +-
 arch/mn10300/kernel/entry.S              |    7 +-
 arch/mn10300/kernel/process.c            |   33 +----
 arch/openrisc/Kconfig                    |    2 +
 arch/openrisc/include/asm/processor.h    |    2 -
 arch/openrisc/include/asm/syscalls.h     |    7 +
 arch/openrisc/include/uapi/asm/unistd.h  |    4 +
 arch/openrisc/kernel/Makefile            |    2 +-
 arch/openrisc/kernel/entry.S             |   55 +++----
 arch/openrisc/kernel/process.c           |  164 +++++++-------------
 arch/openrisc/kernel/sys_or32.c          |   57 -------
 arch/parisc/Kconfig                      |    3 +
 arch/parisc/include/asm/processor.h      |    1 -
 arch/parisc/include/asm/signal.h         |    2 -
 arch/parisc/include/asm/unistd.h         |    4 +
 arch/parisc/kernel/entry.S               |  241 +++---------------------------
 arch/parisc/kernel/process.c             |  142 +++---------------
 arch/parisc/kernel/sys_parisc32.c        |   22 ---
 arch/parisc/kernel/syscall_table.S       |    2 +-
 arch/powerpc/Kconfig                     |    2 +
 arch/powerpc/include/asm/signal.h        |    2 -
 arch/powerpc/include/asm/syscalls.h      |    9 -
 arch/powerpc/include/asm/unistd.h        |    4 +-
 arch/powerpc/kernel/entry_32.S           |    5 -
 arch/powerpc/kernel/entry_64.S           |    8 +-
 arch/powerpc/kernel/process.c            |   64 +-------
 arch/s390/Kconfig                        |    2 +
 arch/s390/include/asm/signal.h           |    2 -
 arch/s390/include/asm/unistd.h           |    4 +-
 arch/s390/kernel/entry.S                 |   32 +----
 arch/s390/kernel/entry.h                 |    4 -
 arch/s390/kernel/entry64.S               |   26 +---
 arch/s390/kernel/process.c               |   53 ++------
 arch/score/Kconfig                       |    3 +
 arch/score/include/asm/processor.h       |    1 -
 arch/score/include/asm/syscalls.h        |    2 -
 arch/score/include/asm/unistd.h          |    4 +
 arch/score/kernel/entry.S                |   30 +---
 arch/score/kernel/process.c              |   57 ++-----
 arch/score/kernel/sys_score.c            |   89 -----------
 arch/sh/Kconfig                          |    2 +
 arch/sh/include/asm/processor_32.h       |    5 -
 arch/sh/include/asm/processor_64.h       |    5 -
 arch/sh/include/asm/syscalls_32.h        |   14 --
 arch/sh/include/asm/syscalls_64.h        |   17 --
 arch/sh/include/asm/unistd.h             |    4 +
 arch/sh/kernel/Makefile                  |    3 +-
 arch/sh/kernel/cpu/sh5/entry.S           |   19 +++
 arch/sh/kernel/entry-common.S            |   13 ++
 arch/sh/kernel/process_32.c              |  134 +++--------------
 arch/sh/kernel/process_64.c              |  127 +++-------------
 arch/sh/kernel/sys_sh32.c                |   24 ---
 arch/sh/kernel/sys_sh64.c                |   50 ------
 arch/sparc/Kconfig                       |    2 +
 arch/sparc/include/asm/processor_32.h    |    1 -
 arch/sparc/include/asm/processor_64.h    |   11 +-
 arch/sparc/include/asm/ptrace.h          |   10 +-
 arch/sparc/include/asm/signal.h          |    2 -
 arch/sparc/include/asm/switch_to_64.h    |    2 +-
 arch/sparc/include/asm/syscalls.h        |    2 -
 arch/sparc/include/asm/thread_info_64.h  |   25 ++--
 arch/sparc/include/asm/uaccess_64.h      |    4 +-
 arch/sparc/include/asm/unistd.h          |    1 +
 arch/sparc/kernel/entry.S                |   51 +++----
 arch/sparc/kernel/etrap_64.S             |    8 +-
 arch/sparc/kernel/process_32.c           |  158 ++++++--------------
 arch/sparc/kernel/process_64.c           |  148 ++++--------------
 arch/sparc/kernel/sys_sparc32.c          |   36 -----
 arch/sparc/kernel/sys_sparc_32.c         |   24 ---
 arch/sparc/kernel/sys_sparc_64.c         |   22 ---
 arch/sparc/kernel/syscalls.S             |   30 ++--
 arch/sparc/kernel/systbls_64.S           |    2 +-
 arch/sparc/kernel/traps_64.c             |    4 +-
 arch/sparc/mm/init_64.c                  |    2 +-
 arch/tile/Kconfig                        |    2 +
 arch/tile/include/asm/compat.h           |   15 +--
 arch/tile/include/asm/elf.h              |    1 +
 arch/tile/include/asm/processor.h        |    6 +-
 arch/tile/include/asm/switch_to.h        |    5 +-
 arch/tile/include/asm/syscalls.h         |   13 +-
 arch/tile/include/asm/unistd.h           |    2 +
 arch/tile/kernel/compat.c                |    4 +-
 arch/tile/kernel/compat_signal.c         |   10 +-
 arch/tile/kernel/entry.S                 |   11 --
 arch/tile/kernel/intvec_32.S             |   29 ++--
 arch/tile/kernel/intvec_64.S             |   30 ++--
 arch/tile/kernel/process.c               |  171 ++++++----------------
 arch/tile/kernel/signal.c                |    9 +-
 arch/tile/kernel/sys.c                   |    8 +-
 arch/tile/mm/fault.c                     |    5 +-
 arch/um/kernel/process.c                 |    5 +-
 arch/um/kernel/syscall.c                 |   23 ---
 arch/unicore32/include/uapi/asm/unistd.h |    1 +
 arch/unicore32/kernel/entry.S            |    6 -
 arch/unicore32/kernel/process.c          |   11 +-
 arch/unicore32/kernel/sys.c              |   14 --
 arch/x86/Kconfig                         |    1 +
 arch/x86/ia32/ia32_aout.c                |    5 +-
 arch/x86/ia32/ia32entry.S                |    7 +-
 arch/x86/ia32/sys_ia32.c                 |   11 --
 arch/x86/include/asm/processor.h         |    2 -
 arch/x86/include/asm/signal.h            |    2 -
 arch/x86/include/asm/sys_ia32.h          |    2 -
 arch/x86/include/asm/syscalls.h          |    9 -
 arch/x86/include/asm/unistd.h            |    3 +
 arch/x86/kernel/cpu/common.c             |    9 -
 arch/x86/kernel/entry_32.S               |   18 ---
 arch/x86/kernel/entry_64.S               |   22 +++-
 arch/x86/kernel/process.c                |   30 ----
 arch/x86/kernel/process_32.c             |   12 +-
 arch/x86/kernel/process_64.c             |   10 +-
 arch/x86/syscalls/syscall_32.tbl         |    6 +-
 arch/x86/um/Kconfig                      |    1 +
 arch/x86/um/shared/sysdep/syscalls.h     |    2 -
 arch/x86/um/sys_call_table_32.c          |    3 -
 arch/x86/um/syscalls_32.c                |   15 --
 arch/xtensa/Kconfig                      |    1 +
 arch/xtensa/include/asm/signal.h         |    1 -
 arch/xtensa/include/asm/syscall.h        |    2 -
 arch/xtensa/include/asm/unistd.h         |    1 +
 arch/xtensa/include/uapi/asm/unistd.h    |    2 +-
 arch/xtensa/kernel/process.c             |   12 +--
 drivers/staging/gdm72xx/gdm_usb.c        |    4 +-
 fs/binfmt_aout.c                         |    5 +-
 fs/binfmt_elf.c                          |    5 +-
 fs/binfmt_elf_fdpic.c                    |    6 +-
 fs/binfmt_em86.c                         |    4 +-
 fs/binfmt_flat.c                         |    5 +-
 fs/binfmt_misc.c                         |    4 +-
 fs/binfmt_script.c                       |    4 +-
 fs/binfmt_som.c                          |    5 +-
 fs/coredump.c                            |    4 +-
 fs/exec.c                                |   37 ++---
 fs/file.c                                |    6 -
 fs/fs_struct.c                           |   24 ---
 include/asm-generic/signal.h             |    2 -
 include/asm-generic/syscalls.h           |   20 ---
 include/linux/binfmts.h                  |    4 +-
 include/linux/compat.h                   |    4 -
 include/linux/coredump.h                 |    4 +-
 include/linux/fdtable.h                  |    1 -
 include/linux/fs_struct.h                |    1 -
 include/linux/ptrace.h                   |   13 ++
 include/linux/sched.h                    |    7 +-
 include/linux/syscalls.h                 |   16 ++-
 kernel/auditsc.c                         |  102 +++----------
 kernel/exit.c                            |   92 -----------
 kernel/fork.c                            |   64 ++++++--
 kernel/signal.c                          |   15 +-
 276 files changed, 1412 insertions(+), 4409 deletions(-)
 delete mode 100644 arch/avr32/kernel/sys_avr32.c
 delete mode 100644 arch/hexagon/kernel/syscall.c
 delete mode 100644 arch/microblaze/include/asm/syscalls.h
 delete mode 100644 arch/openrisc/kernel/sys_or32.c
 delete mode 100644 arch/sh/kernel/sys_sh64.c
