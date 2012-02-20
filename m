Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065Ab2BTAI4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 19:08:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57084 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412Ab2BTAIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 19:08:54 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: mingo@kernel.org, tglx@linutronix.de, hpa@zytor.com,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        hjl.tools@gmail.com
Subject: [PATCH 00/30] RFC: x32 support
Date: Sun, 19 Feb 2012 16:07:38 -0800
Message-Id: <1329696488-16970-1-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.7.6.5
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 19 Feb 2012 16:08:45 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an initial RFC patchset for x32 support.  This is largely
complete and should be able to boot an x32 userspace.

The patch authors are assigned to myself and H. J. in a somewhat
haphazard fashion; the kernel side of x32 was very much a
collaborative effort, although H. J. ended up doing most of the latter
coding due to my being occupied with kernel.org in late 2011.

This patchset applies on top of tip:core/types which in turn is based
on v3.3-rc3; there may be some trivially resolved conflicts with -rc4.
I am planning to push this out as tip:x86/x32 after the RFC.

Controversial issue in this patchset:

There are a lot of ABIs that expose "long" or "unsigned long"; the
traditional way to deal with that is compat, but we don't want to use
that in most cases for x32.  As a result, I have introduced
__kernel_[u]long_t as an additional type in posix_types.h.

This type largely duplicates __kernel_[s]size_t, but the latter is
defined as [unsigned] int on a lot of platforms, so changing types
over to __kernel_[s]size_t would have changed the type, if not the
size, on a lot of platforms.  I have personally no strong opinion on
which way is preferrable.

The use of a flag to signal x32 rather than using a completely new set
of system call numbers.  This was discussed back in August.

Incompleteness:

There are a number of (especially) ioctl paths which don't yet handle
a 64-bit time_t in the compat path.  This is necessary because of
Linus' (quite correct) dictat that new ABIs should use a 64-bit
time_t, but this also means this is the first 32-bit ABI with a 64-bit
time_t, and some problems are expected to crop up.

The header-exported ABI is not correct everywhere yet.


The total diffstat is attached.

 arch/x86/Kconfig                       |   21 +-
 arch/x86/ia32/ia32_signal.c            |   12 +-
 arch/x86/ia32/sys_ia32.c               |   40 ---
 arch/x86/include/asm/Kbuild            |    2 +
 arch/x86/include/asm/compat.h          |   39 ++-
 arch/x86/include/asm/elf.h             |   29 ++-
 arch/x86/include/asm/ia32.h            |    9 +
 arch/x86/include/asm/posix_types.h     |    4 +-
 arch/x86/include/asm/posix_types_x32.h |   19 +
 arch/x86/include/asm/processor.h       |   10 +-
 arch/x86/include/asm/ptrace.h          |    1 -
 arch/x86/include/asm/sigcontext.h      |   57 ++--
 arch/x86/include/asm/sigframe.h        |   13 +
 arch/x86/include/asm/sighandling.h     |   24 ++
 arch/x86/include/asm/sys_ia32.h        |    7 +-
 arch/x86/include/asm/syscall.h         |    5 +-
 arch/x86/include/asm/thread_info.h     |    6 +-
 arch/x86/include/asm/unistd.h          |   15 +-
 arch/x86/kernel/asm-offsets_64.c       |    6 +
 arch/x86/kernel/cpu/perf_event.c       |    4 +-
 arch/x86/kernel/entry_64.S             |   44 +++
 arch/x86/kernel/process_64.c           |   25 +-
 arch/x86/kernel/signal.c               |  138 +++++++-
 arch/x86/kernel/sys_x86_64.c           |    6 +-
 arch/x86/kernel/syscall_64.c           |    8 +
 arch/x86/oprofile/backtrace.c          |    2 +-
 arch/x86/syscalls/Makefile             |   19 +-
 arch/x86/syscalls/syscall_32.tbl       |    2 +-
 arch/x86/syscalls/syscall_64.tbl       |  579 +++++++++++++++++---------------
 arch/x86/um/sys_call_table_64.c        |    3 +
 arch/x86/um/user-offsets.c             |    2 +
 arch/x86/vdso/.gitignore               |    2 +
 arch/x86/vdso/Makefile                 |   46 +++-
 arch/x86/vdso/vdso32-setup.c           |    6 +
 arch/x86/vdso/vdsox32.S                |   22 ++
 arch/x86/vdso/vdsox32.lds.S            |   32 ++
 arch/x86/vdso/vma.c                    |   78 ++++-
 drivers/char/lp.c                      |   20 +-
 drivers/input/input-compat.c           |    4 +-
 drivers/input/input-compat.h           |    2 +-
 fs/binfmt_elf.c                        |   24 ++-
 fs/compat.c                            |   26 ++-
 include/asm-generic/posix_types.h      |   23 +-
 include/linux/Kbuild                   |    1 +
 include/linux/aio_abi.h                |    2 +-
 include/linux/compat.h                 |    4 +
 include/linux/kernel.h                 |   21 +-
 include/linux/sysinfo.h                |   24 ++
 net/bluetooth/hci_sock.c               |    3 +-
 49 files changed, 1027 insertions(+), 464 deletions(-)
 
It is probably worth noting that this work directly spawned the
x86/syscall and core/types cleanups:

 33 files changed, 1075 insertions(+), 1978 deletions(-)
 22 files changed, 190 insertions(+), 1588 deletions(-)
