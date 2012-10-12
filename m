Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab2JLBKH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 21:10:07 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60317 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049Ab2JLBKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 21:10:03 -0400
Date: Fri, 12 Oct 2012 02:09:58 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        linux-arch@vger.kernel.org, David Miller <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [git pull] signal.git, pile 2 (was Re: [RFC][CFT][CFReview] execve
 and kernel_thread unification work)
Message-ID: <20121012010958.GG2616@ZenIV.linux.org.uk>
References: <20121001213809.GA31155@ZenIV.linux.org.uk>
 <20121011090023.GA28427@bloggs.ozlabs.ibm.com>
 <20121011125306.GF2616@ZenIV.linux.org.uk>
 <20121012001633.GA29883@bloggs.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121012001633.GA29883@bloggs.ozlabs.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2012 at 11:16:33AM +1100, Paul Mackerras wrote:
> On Thu, Oct 11, 2012 at 01:53:06PM +0100, Al Viro wrote:
> 
> > 	Umm...  Maybe, but let's do that as subsequent cleanup.  Again,
> > we almost certainly don't need to mess with TOC at all - the callbacks
> > are in the main kernel, there are very few of them and they really are
> > low-level details of exported mechanisms (i.e. kthread_create/run/etc.
> > in kthread.h and call_usermode... in kmod.h).  Again, we are talking
> > about out-of-tree modules, they had better mechanism for at least
> > 6 years and conversion to it is bloody trivial.  Hell, it was even
> > in late unlamented feature-removal-schedule.txt - since 2006.  If that's
> > not enough to retire an export, what is?
> 
> OK... yes we can fix things up in a subsequent cleanup.
> 
> We will need to fix the TOC handling when we go to using multiple TOCs
> in the main kernel, with the linker managing the transitions between
> TOCs.  Our toolchain guys have been pushing us to do that for years,
> because it should make things run faster, but first we'll have to stop
> using ld -r to combine objects in subdirectories.

How granular are you planning to make that?  I mean, we are talking about
3 objects here - init/main.o, kernel/kthread.o and kernel/kmod.o.  Do they
get TOC separate from that of arch/powerpc/kernel/entry_64.o?

Anyway, if ppc folks can live with that stuff in its current form for now,
here's the second signal.git pull request.  Stuff in there: kernel_thread/
kernel_execve/sys_execve conversions for several more architectures plus
assorted signal fixes and cleanups.  There'll be more (in particular, real
fixes for alpha do_notify_resume() irq mess)...  Linus, could you pull that
queue?  It's in the usual place -
git://git.kernel.org/pub/scm/linux/kernel/git/viro/signal for-linus

Shortlog:
Al Viro (38):
      powerpc: split ret_from_fork
      powerpc: switch to generic sys_execve()/kernel_execve()
      m68k: split ret_from_fork(), simplify kernel_thread()
      m68k: switch to generic sys_execve()/kernel_execve()
      frv: split ret_from_fork, simplify kernel_thread() a lot
      frv: switch to generic sys_execve()
      frv: switch to generic kernel_execve
      frv: switch to generic kernel_thread()
      mn10300: split ret_from_fork, simplify kernel_thread()
      mn10300: switch to generic sys_execve()
      mn10300: switch to generic kernel_execve()
      mn10300: convert to generic kernel_thread()
      c6x: switch to generic kernel_thread()
      xtensa: can't get to do_notify_resume() when user_mode(regs) is not true
      mn10300: get rid of calling do_notify_resume() when returning to kernel mode
      score: fix bogus restarts on sigreturn()
      ia64: can't reach do_signal() when returning to kernel mode
      mips: prevent hitting do_notify_resume() with !user_mode(regs)
      mips: unobfuscate _TIF..._MASK
      mips: merge the identical "return from syscall" per-ABI code
      mips: NOTIFY_RESUME is not needed in TIF masks
      unicore32: unobfuscate _TIF_WORK_MASK
      bury _TIF_RESTORE_SIGMASK
      sanitize tsk_is_polling()
      bury the rest of TIF_IRET
      parisc: fix double restarts
      parisc: don't bother looping in do_signal()
      parisc: decide whether to go to slow path (tracesys) based on thread flags
      h8300: trim _TIF_WORK_MASK
      unicore32: remove pointless test
      x86: get rid of duplicate code in case of CONFIG_VM86
      frv: no need to raise SIGTRAP in setup_frame()
      mn10300: don't bother with SIGTRAP in setup_frame()
      microblaze: don't bother with SIGTRAP in setup_rt_frame()
      tile: don't bother with SIGTRAP in setup_frame
      avr32: trim masks
      m32r: trim masks
      alpha: don't open-code trace_report_syscall_{enter,exit}

Greg Ungerer (1):
      m68k: always set stack frame format for ColdFire on thread start

Mark Salter (3):
      c6x: add ret_from_kernel_thread(), simplify kernel_thread()
      c6x: switch to generic kernel_execve
      c6x: switch to generic sys_execve

Richard Weinberger (1):
      Uninclude linux/freezer.h

Diffstat:
 arch/alpha/include/asm/thread_info.h      |    3 +-
 arch/alpha/kernel/entry.S                 |   13 ++--
 arch/alpha/kernel/ptrace.c                |   32 ++++-----
 arch/arm/include/asm/thread_info.h        |    2 -
 arch/arm/kernel/signal.c                  |    1 -
 arch/avr32/include/asm/thread_info.h      |   18 ++---
 arch/avr32/kernel/signal.c                |    1 -
 arch/blackfin/include/asm/thread_info.h   |    4 -
 arch/blackfin/kernel/signal.c             |    1 -
 arch/c6x/Kconfig                          |    1 +
 arch/c6x/include/asm/processor.h          |    2 -
 arch/c6x/include/asm/syscalls.h           |    5 --
 arch/c6x/include/asm/thread_info.h        |    1 -
 arch/c6x/include/asm/unistd.h             |    3 +
 arch/c6x/kernel/asm-offsets.c             |    1 -
 arch/c6x/kernel/entry.S                   |   56 +++++++--------
 arch/c6x/kernel/process.c                 |   72 +++-----------------
 arch/cris/include/asm/thread_info.h       |    3 -
 arch/frv/Kconfig                          |    1 +
 arch/frv/include/asm/processor.h          |    9 +--
 arch/frv/include/asm/ptrace.h             |    1 +
 arch/frv/include/asm/thread_info.h        |    3 -
 arch/frv/include/asm/unistd.h             |    2 +
 arch/frv/kernel/Makefile                  |    4 +-
 arch/frv/kernel/entry.S                   |   13 ++++
 arch/frv/kernel/frv_ksyms.c               |    1 -
 arch/frv/kernel/kernel_execve.S           |   33 ---------
 arch/frv/kernel/kernel_thread.S           |   77 ---------------------
 arch/frv/kernel/process.c                 |   66 ++++++------------
 arch/frv/kernel/signal.c                  |    9 ---
 arch/h8300/include/asm/thread_info.h      |    7 +--
 arch/h8300/kernel/signal.c                |    1 -
 arch/hexagon/include/asm/thread_info.h    |    5 --
 arch/hexagon/kernel/signal.c              |    1 -
 arch/ia64/include/asm/thread_info.h       |    2 -
 arch/ia64/kernel/signal.c                 |    8 --
 arch/m32r/include/asm/thread_info.h       |    9 +--
 arch/m32r/kernel/signal.c                 |    3 -
 arch/m68k/Kconfig                         |    1 +
 arch/m68k/include/asm/processor.h         |   25 +++----
 arch/m68k/include/asm/ptrace.h            |    2 +
 arch/m68k/include/asm/unistd.h            |    2 +
 arch/m68k/kernel/entry.S                  |   16 +++++
 arch/m68k/kernel/process.c                |  104 +++++++----------------------
 arch/m68k/kernel/sys_m68k.c               |   17 -----
 arch/microblaze/include/asm/thread_info.h |    3 +-
 arch/microblaze/kernel/signal.c           |    7 +--
 arch/mips/include/asm/thread_info.h       |    9 +--
 arch/mips/kernel/entry.S                  |   15 +++-
 arch/mips/kernel/scall32-o32.S            |   13 +---
 arch/mips/kernel/scall64-64.S             |   13 +---
 arch/mips/kernel/scall64-n32.S            |   13 +---
 arch/mips/kernel/scall64-o32.S            |   13 +---
 arch/mips/kernel/signal.c                 |    8 --
 arch/mn10300/Kconfig                      |    1 +
 arch/mn10300/include/asm/frame.inc        |    2 +-
 arch/mn10300/include/asm/processor.h      |   18 +----
 arch/mn10300/include/asm/ptrace.h         |    1 +
 arch/mn10300/include/asm/thread_info.h    |    3 +-
 arch/mn10300/include/asm/unistd.h         |    2 +
 arch/mn10300/kernel/Makefile              |    4 +-
 arch/mn10300/kernel/entry.S               |   18 +++++
 arch/mn10300/kernel/internal.h            |    6 +--
 arch/mn10300/kernel/kernel_execve.S       |   37 ----------
 arch/mn10300/kernel/kthread.S             |   31 ---------
 arch/mn10300/kernel/process.c             |   91 ++++++-------------------
 arch/mn10300/kernel/signal.c              |   13 ----
 arch/openrisc/include/asm/thread_info.h   |    3 +-
 arch/parisc/hpux/gate.S                   |    2 +-
 arch/parisc/include/asm/thread_info.h     |    5 +-
 arch/parisc/kernel/signal.c               |   45 ++++--------
 arch/parisc/kernel/syscall.S              |    9 ++-
 arch/powerpc/Kconfig                      |    1 +
 arch/powerpc/include/asm/processor.h      |    3 -
 arch/powerpc/include/asm/ptrace.h         |    2 +
 arch/powerpc/include/asm/syscalls.h       |    3 -
 arch/powerpc/include/asm/thread_info.h    |    2 +
 arch/powerpc/include/asm/unistd.h         |    2 +
 arch/powerpc/kernel/entry_32.S            |   16 +++++
 arch/powerpc/kernel/entry_64.S            |   16 +++++
 arch/powerpc/kernel/misc.S                |    7 --
 arch/powerpc/kernel/misc_32.S             |   33 ---------
 arch/powerpc/kernel/misc_64.S             |   34 ---------
 arch/powerpc/kernel/ppc_ksyms.c           |    1 -
 arch/powerpc/kernel/process.c             |   59 ++++++++---------
 arch/powerpc/kernel/signal_32.c           |    1 -
 arch/powerpc/kernel/sys_ppc32.c           |   22 ------
 arch/s390/include/asm/thread_info.h       |    4 -
 arch/score/include/asm/thread_info.h      |    4 -
 arch/score/kernel/signal.c                |    1 +
 arch/sh/include/asm/thread_info.h         |    3 +
 arch/sh/kernel/signal_32.c                |    1 -
 arch/sh/kernel/signal_64.c                |    1 -
 arch/sparc/include/asm/thread_info_32.h   |    3 +-
 arch/sparc/include/asm/thread_info_64.h   |    3 +
 arch/tile/kernel/compat_signal.c          |    9 ---
 arch/tile/kernel/signal.c                 |   12 +---
 arch/um/include/asm/thread_info.h         |    3 -
 arch/unicore32/include/asm/thread_info.h  |    4 +-
 arch/unicore32/kernel/entry.S             |    2 -
 arch/unicore32/kernel/signal.c            |    1 -
 arch/x86/kernel/entry_32.S                |   17 ++---
 arch/xtensa/include/asm/thread_info.h     |    5 --
 arch/xtensa/kernel/signal.c               |    4 -
 kernel/sched/core.c                       |    2 +-
 105 files changed, 363 insertions(+), 944 deletions(-)
 delete mode 100644 arch/frv/kernel/kernel_execve.S
 delete mode 100644 arch/frv/kernel/kernel_thread.S
 delete mode 100644 arch/mn10300/kernel/kernel_execve.S
 delete mode 100644 arch/mn10300/kernel/kthread.S
