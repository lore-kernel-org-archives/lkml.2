Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745Ab0ESQWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 12:22:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25411 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943Ab0ESQWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 12:22:17 -0400
Date: Wed, 19 May 2010 12:21:42 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
       tglx@linutronix.de, rostedt@goodmis.org, andi@firstfloor.org,
       roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
       fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
       vgoyal@redhat.com
Message-Id: <cover.1274283321.git.jbaron@redhat.com>
Subject: [PATCH 00/13] jump label v8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

updates for -v8:

*converted jump labels to use a numeric key instead of a string to identify
sets of related jump labels. this saves space, since we no longer store all
the strings. It also simplifies the jump label call as:

-# define JUMP_LABEL(tag, label, cond)
+# define JUMP_LABEL(key, label)        

since we can use &cond for as the key value

*added 'dynamic debug' code as another consumer of the jump label code (in
addition to tracepoints). It would be interesting to identify further codepaths
that would benefit from this type of optimization

*added a depends on !CC_OPTIMIZE_FOR_SIZE. When CC_OPTIMIZE_FOR_SIZE is set,
gcc does not always out of line the not taken label path in the same way that
the "if unlikely()" paths are made out of line. Thus, with CC_OPTIMIZE_FOR_SIZE
set, this optimization is not always optimal. This may be solved in subsequent gcc
versions, that allow us to move labels out of line, while still optimizing for
size. In the case of !CC_OPTIMIZE_FOR_SIZE this optimization is seen on high
level benchmarks such as tbench where I can get ~1-2% higher throughput. In
addition we are within .5% of the performance of no tracepoints compiled in
at all.

thanks,

-Jason

David S. Miller (1):
  sparc64: Add jump_label support

Jason Baron (11):
  jump label: base patch
  jump label: x86 support
  jump label: tracepoint support
  jump label: add module support
  jump label: move ftrace_dyn_arch_init to common code
  jump label: sort jump table at build-time
  jump label: initialize workqueue tracepoints *before* they are
    registered
  jump label: jump_label_text_reserved() to reserve our jump points
  jump label: add docs
  jump label: convert jump label to use a key
  jump label: convert dynamic debug to use jump labels.

Mathieu Desnoyers (1):
  jump label: notifier atomic call chain notrace

 Documentation/jump-label.txt        |  143 ++++++++++++
 Makefile                            |    6 +-
 arch/Kconfig                        |    3 +
 arch/sparc/Kconfig                  |    1 +
 arch/sparc/include/asm/jump_entry.h |   18 ++
 arch/sparc/include/asm/jump_label.h |   20 ++
 arch/sparc/kernel/Makefile          |    2 +
 arch/sparc/kernel/jump_label.c      |   38 +++
 arch/sparc/kernel/module.c          |    6 +
 arch/x86/Kconfig                    |    1 +
 arch/x86/include/asm/alternative.h  |   14 ++
 arch/x86/include/asm/jump_entry.h   |   32 +++
 arch/x86/include/asm/jump_label.h   |   22 ++
 arch/x86/kernel/Makefile            |    2 +-
 arch/x86/kernel/alternative.c       |   72 ++++++-
 arch/x86/kernel/ftrace.c            |   70 +------
 arch/x86/kernel/jump_label.c        |   47 ++++
 arch/x86/kernel/kprobes.c           |    3 +-
 arch/x86/kernel/module.c            |    3 +
 arch/x86/kernel/ptrace.c            |    1 +
 arch/x86/kernel/setup.c             |    3 +
 include/asm-generic/vmlinux.lds.h   |   22 ++-
 include/linux/dynamic_debug.h       |   42 ++--
 include/linux/jump_label.h          |   61 +++++
 include/linux/module.h              |    5 +-
 include/linux/tracepoint.h          |   33 ++--
 kernel/Makefile                     |    2 +-
 kernel/jump_label.c                 |  426 +++++++++++++++++++++++++++++++++++
 kernel/kprobes.c                    |    3 +-
 kernel/module.c                     |    7 +
 kernel/notifier.c                   |    6 +-
 kernel/trace/ftrace.c               |   13 +-
 kernel/trace/trace_workqueue.c      |   10 +-
 kernel/tracepoint.c                 |    8 +
 lib/dynamic_debug.c                 |   42 +----
 scripts/Makefile.lib                |   11 +-
 scripts/basic/Makefile              |    2 +-
 scripts/basic/hash.c                |   64 ------
 scripts/mod/Makefile                |    1 +
 scripts/mod/modpost.c               |   61 +++++-
 scripts/mod/modpost.h               |    1 +
 41 files changed, 1077 insertions(+), 250 deletions(-)
 create mode 100644 Documentation/jump-label.txt
 create mode 100644 arch/sparc/include/asm/jump_entry.h
 create mode 100644 arch/sparc/include/asm/jump_label.h
 create mode 100644 arch/sparc/kernel/jump_label.c
 create mode 100644 arch/x86/include/asm/jump_entry.h
 create mode 100644 arch/x86/include/asm/jump_label.h
 create mode 100644 arch/x86/kernel/jump_label.c
 create mode 100644 include/linux/jump_label.h
 create mode 100644 kernel/jump_label.c
 delete mode 100644 scripts/basic/hash.c

