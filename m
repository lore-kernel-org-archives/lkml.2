Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000Ab0DPPYh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 11:24:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12455 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757123Ab0DPPYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 11:24:36 -0400
Date: Fri, 16 Apr 2010 11:24:10 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
       tglx@linutronix.de, rostedt@goodmis.org, andi@firstfloor.org,
       roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
       fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
       vgoyal@redhat.com
Message-Id: <cover.1271427118.git.jbaron@redhat.com>
Subject: [PATCH 00/11] jump label v7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Based on David Miller's suggestion this version re-works the architecture
interfaces for jump labels. I have also added a documentation file, and
re-freshed the patchset against the latest -tip tree.

The new architecture interface (quoting from the docs file), is as follows:

"
4) architecture interface

There are a few functions and macros which arches must implement in order to
take advantage of this optimization. As previously mentioned, if there is no
architecture support we simply fall back to a traditional, load, test, and
jump sequence.

* add "HAVE_ARCH_JUMP_LABEL" to arch/<arch>/Kconfig to indicate support

* #define JUMP_LABEL_NOP_SIZE, arch/x86/include/asm/jump_label.h

* #define "JUMP_LABEL(tag, label, cond)", arch/x86/include/asm/jump_label.h

* add: void arch_jump_label_transform(struct jump_entry *entry, enum jump_label_type type)
                                and
       const u8 *arch_get_jump_label_nop(void)

        see: arch/x86/kernel/jump_label.c

* finally add a definition for "struct jump_entry". This must be done in a
  separate .h file, b/c the modpost.c code uses this definition to sort the
  the jump label tabel in the vmlinux, so that it does not have to be sorted at
  runtime. see: arch/x86/include/asm/jump_entry.h
"

David, I re-worked the sparc64 to match the updated interfaces. The code should
hopefully compile now, although I did not test the sparc bits.

thanks,

-Jason

David S. Miller (1):
  sparc64: Add jump_label support

Jason Baron (9):
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

Mathieu Desnoyers (1):
  jump label: notifier atomic call chain notrace

 Documentation/jump-label.txt        |  140 +++++++++++
 Makefile                            |    6 +-
 arch/Kconfig                        |    3 +
 arch/sparc/Kconfig                  |    1 +
 arch/sparc/include/asm/jump_entry.h |   16 ++
 arch/sparc/include/asm/jump_label.h |   21 ++
 arch/sparc/kernel/Makefile          |    2 +
 arch/sparc/kernel/jump_label.c      |   38 +++
 arch/sparc/kernel/module.c          |    6 +
 arch/x86/Kconfig                    |    1 +
 arch/x86/include/asm/alternative.h  |   14 ++
 arch/x86/include/asm/jump_entry.h   |   28 +++
 arch/x86/include/asm/jump_label.h   |   23 ++
 arch/x86/kernel/Makefile            |    2 +-
 arch/x86/kernel/alternative.c       |   71 ++++++-
 arch/x86/kernel/ftrace.c            |   70 +------
 arch/x86/kernel/jump_label.c        |   47 ++++
 arch/x86/kernel/kprobes.c           |    3 +-
 arch/x86/kernel/module.c            |    3 +
 arch/x86/kernel/ptrace.c            |    1 +
 arch/x86/kernel/setup.c             |    3 +
 include/asm-generic/vmlinux.lds.h   |   22 ++-
 include/linux/jump_label.h          |   75 ++++++
 include/linux/module.h              |    5 +-
 include/linux/tracepoint.h          |   34 ++--
 kernel/Makefile                     |    2 +-
 kernel/jump_label.c                 |  431 +++++++++++++++++++++++++++++++++++
 kernel/kprobes.c                    |    3 +-
 kernel/module.c                     |    7 +
 kernel/notifier.c                   |    6 +-
 kernel/trace/ftrace.c               |   13 +-
 kernel/trace/trace_workqueue.c      |   10 +-
 kernel/tracepoint.c                 |    8 +
 scripts/mod/Makefile                |    1 +
 scripts/mod/modpost.c               |   71 ++++++-
 scripts/mod/modpost.h               |    2 +
 36 files changed, 1073 insertions(+), 116 deletions(-)
 create mode 100644 Documentation/jump-label.txt
 create mode 100644 arch/sparc/include/asm/jump_entry.h
 create mode 100644 arch/sparc/include/asm/jump_label.h
 create mode 100644 arch/sparc/kernel/jump_label.c
 create mode 100644 arch/x86/include/asm/jump_entry.h
 create mode 100644 arch/x86/include/asm/jump_label.h
 create mode 100644 arch/x86/kernel/jump_label.c
 create mode 100644 include/linux/jump_label.h
 create mode 100644 kernel/jump_label.c

