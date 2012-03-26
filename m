Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933218Ab2CZSjf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 14:39:35 -0400
Received: from mail-gx0-f202.google.com ([209.85.161.202]:36863 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932830Ab2CZSjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 14:39:33 -0400
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Cc: David Sharp <dhsharp@google.com>, Justin Teravest <teravest@google.com>,
        Laurent Chavey <chavey@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH 0/6] Enhance and speed up syscall tracing
Date: Mon, 26 Mar 2012 11:39:22 -0700
Message-Id: <1332787168-20457-1-git-send-email-vnagarnaik@google.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tracing syscalls in the kernel adds its own complexity. This patchset
attempts to simplify the code for syscall tracing and speed it up.

It also adds tracing for ia32 compat syscalls.


These patches simplify the syscall tracing macros:
* trace: syscalls.h - cleanup and simplify SYSCALL_METADATA()
* trace: Refactor ftrace syscall macros to make them more readable


These patches add tracing support for compat syscalls:
* trace: add support for 32 bit compat syscalls on x86_64
* trace: raw_syscalls: Mark compat syscalls in the MSB of the syscall
number


This patch reduces syscall tracing latency.
* trace: trace syscall in its handler not from ptrace handler

It changes the way syscall tracing is plumbed. The syscalls tracepoint
was earlier called from ptrace handler which added latency to the
syscall tracing code path because of manipulation required to the stack.
It can be similarly handled by having a little indirection function as
the syscall handler and calling the tracepoints just before the actual
syscall handler.

It decreases latency for all syscall tracepoints.


David Sharp (1):
  trace: raw_syscalls: Mark compat syscalls in the MSB of the syscall
    number

Michael Davidson (3):
  trace: syscalls.h - cleanup and simplify SYSCALL_METADATA()
  trace: add support for 32 bit compat syscalls on x86_64
  trace: get rid of the enabled_*_syscalls bitmaps

Vaibhav Nagarnaik (2):
  trace: Refactor ftrace syscall macros to make them more readable
  trace: trace syscall in its handler not from ptrace handler

 arch/openrisc/include/asm/thread_info.h |    1 -
 arch/powerpc/Kconfig                    |    1 -
 arch/powerpc/include/asm/thread_info.h  |    4 +-
 arch/powerpc/kernel/ptrace.c            |    6 -
 arch/s390/Kconfig                       |    1 -
 arch/s390/include/asm/thread_info.h     |    2 -
 arch/s390/kernel/entry.S                |    3 +-
 arch/s390/kernel/entry64.S              |    3 +-
 arch/s390/kernel/ptrace.c               |    9 -
 arch/sh/Kconfig                         |    1 -
 arch/sh/include/asm/thread_info.h       |    8 +-
 arch/sh/kernel/ptrace_32.c              |    9 -
 arch/sh/kernel/ptrace_64.c              |    9 -
 arch/sparc/Kconfig                      |    1 -
 arch/sparc/include/asm/thread_info_64.h |    2 -
 arch/sparc/kernel/ptrace_64.c           |    9 -
 arch/sparc/kernel/syscalls.S            |   10 +-
 arch/x86/Kconfig                        |    1 -
 arch/x86/ia32/Makefile                  |    2 +
 arch/x86/ia32/ia32_syscall_metadata.c   |  443 +++++++++++++++++++++++++++++++
 arch/x86/include/asm/thread_info.h      |   10 +-
 arch/x86/kernel/ptrace.c                |    9 -
 fs/dcookies.c                           |    2 +-
 fs/open.c                               |    2 +-
 fs/read_write.c                         |    8 +-
 fs/sync.c                               |    8 +-
 include/linux/syscalls.h                |  153 +++++++----
 include/trace/events/syscalls.h         |   38 ++--
 include/trace/syscall.h                 |   18 ++-
 kernel/trace/Kconfig                    |   12 +-
 kernel/trace/trace_syscalls.c           |  153 +++++------
 kernel/tracepoint.c                     |   38 ---
 mm/fadvise.c                            |    5 +-
 mm/filemap.c                            |    2 +-
 34 files changed, 681 insertions(+), 302 deletions(-)
 create mode 100644 arch/x86/ia32/ia32_syscall_metadata.c

-- 
1.7.7.3

