Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921Ab2JMAxh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 20:53:37 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:37222 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828Ab2JMAxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 20:53:36 -0400
Date: Sat, 13 Oct 2012 01:53:34 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [git pull] signals pile 3
Message-ID: <20121013005334.GM2616@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The last bits of infrastructure for kernel_thread() et.al., with alpha/arm/x86
use of those.  Plus sanitizing the asm glue and do_notify_resume() on alpha,
fixing the "disabled irq while running task_work stuff" breakage there.

At that point the rest of kernel_thread/kernel_execve/sys_execve work can
be done independently for different architectures.  The only pending bits
that do depend on having all architectures converted are restrictred to
fs/* and kernel/* - that'll obviously have to wait for the next cycle.
I thought we'd have to wait for all of them done before we start eliminating
the longjump-style insanity in kernel_execve(), but it turned out there's
a very simple way to do that without flagday-style changes.

Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/signal for-linus

Shortlog:
Al Viro (12):
      alpha: simplify TIF_NEED_RESCHED handling
      alpha: take SIGPENDING/NOTIFY_RESUME loop into signal.c
      alpha: don't bother passing switch_stack separately from regs
      alpha: get rid of switch_stack argument of do_work_pending()
      don't bother with kernel_thread/kernel_execve for launching linuxrc
      ppc: eeh_event should just use kthread_run()
      make sure that we always have a return path from kernel_execve()
      make sure that kernel_thread() callbacks call do_exit() themselves
      infrastructure for saner ret_from_kernel_thread semantics
      x86, um: convert to saner kernel_execve() semantics
      arm: switch to saner kernel_execve() semantics
      alpha: switch to saner kernel_execve() semantics

Diffstat:
 arch/Kconfig                               |    3 +
 arch/alpha/Kconfig                         |    1 +
 arch/alpha/include/asm/unistd.h            |    1 -
 arch/alpha/kernel/entry.S                  |   87 +++++++++-------------------
 arch/alpha/kernel/signal.c                 |   48 +++++++++------
 arch/arm/Kconfig                           |    1 +
 arch/arm/include/asm/unistd.h              |    1 -
 arch/arm/kernel/entry-common.S             |   29 +--------
 arch/arm/kernel/process.c                  |    5 +-
 arch/powerpc/platforms/pseries/eeh_event.c |    5 +-
 arch/um/include/asm/processor-generic.h    |    2 -
 arch/um/include/shared/os.h                |    1 -
 arch/um/kernel/exec.c                      |    5 --
 arch/um/kernel/process.c                   |   10 +--
 arch/um/os-Linux/process.c                 |   13 ----
 arch/x86/Kconfig                           |    1 +
 arch/x86/include/asm/unistd.h              |    1 -
 arch/x86/kernel/entry_32.S                 |   31 ++++------
 arch/x86/kernel/entry_64.S                 |   24 +------
 arch/x86/um/Kconfig                        |    1 +
 include/linux/syscalls.h                   |    8 +++
 init/do_mounts_initrd.c                    |   41 +++++--------
 init/main.c                                |   33 ++++++-----
 kernel/kmod.c                              |    7 ++-
 kernel/kthread.c                           |    1 +
 25 files changed, 137 insertions(+), 223 deletions(-)
