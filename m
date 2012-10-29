Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757116Ab2J2N2Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 09:28:24 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44308 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756606Ab2J2N2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 09:28:23 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [RFC PATCH 0/9] printk: Make it usable on nohz CPUs v3
Date: Mon, 29 Oct 2012 14:28:07 +0100
Message-Id: <1351517296-9173-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Changes since v2:

* Use an irq_work flag instead of a queue parameter to define whether
we want an IPI or not. This way it becomes a work property that can't
change during its lifecyle. It more simple that way.

* Fix some build errors reported by Wu Fengguang.

* Send an IPI even on non-empty queues, in case it's only filled with lazy
works.

* Fix a race when claiming is concurrent with another CPU.

Only boot-tested on x86 for now.

Testing can be made by pulling:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
 	nohz/printk-v3

Thanks.

Frederic Weisbecker (9):
  irq_work: Fix racy check on work pending flag
  irq_work: Remove CONFIG_HAVE_IRQ_WORK
  irq_work: Move irq_work_raise() declaration/default definition to
    arch headers
  irq_work: Let the arch tell us about self-IPI support
  x86: Implement arch_irq_work_has_ipi()
  nohz: Add API to check tick state
  irq_work: Make self-IPIs optable
  irq_work: Handle queuing without IPI support in dyntick idle mode
  printk: Wake up klogd using irq_work

 arch/alpha/Kconfig                     |    1 -
 arch/alpha/include/asm/irq_work.h      |    9 +++
 arch/alpha/kernel/time.c               |    2 +-
 arch/arm/Kconfig                       |    1 -
 arch/arm/include/asm/irq_work.h        |    1 +
 arch/arm64/Kconfig                     |    1 -
 arch/arm64/include/asm/irq_work.h      |    1 +
 arch/avr32/include/asm/irq_work.h      |    1 +
 arch/blackfin/Kconfig                  |    1 -
 arch/blackfin/include/asm/irq_work.h   |    1 +
 arch/c6x/include/asm/irq_work.h        |    1 +
 arch/cris/include/asm/irq_work.h       |    1 +
 arch/frv/Kconfig                       |    1 -
 arch/frv/include/asm/irq_work.h        |    1 +
 arch/h8300/include/asm/irq_work.h      |    1 +
 arch/hexagon/Kconfig                   |    1 -
 arch/hexagon/include/asm/irq_work.h    |    1 +
 arch/ia64/include/asm/irq_work.h       |    1 +
 arch/m32r/include/asm/irq_work.h       |    1 +
 arch/m68k/include/asm/irq_work.h       |    1 +
 arch/microblaze/include/asm/irq_work.h |    1 +
 arch/mips/Kconfig                      |    1 -
 arch/mips/include/asm/irq_work.h       |    1 +
 arch/mn10300/include/asm/irq_work.h    |    1 +
 arch/openrisc/include/asm/irq_work.h   |    1 +
 arch/parisc/Kconfig                    |    1 -
 arch/parisc/include/asm/irq_work.h     |    1 +
 arch/powerpc/Kconfig                   |    1 -
 arch/powerpc/include/asm/irq_work.h    |    8 +++
 arch/powerpc/kernel/time.c             |    2 +-
 arch/s390/Kconfig                      |    1 -
 arch/s390/include/asm/irq_work.h       |    1 +
 arch/score/include/asm/irq_work.h      |    1 +
 arch/sh/Kconfig                        |    1 -
 arch/sh/include/asm/irq_work.h         |    1 +
 arch/sparc/Kconfig                     |    1 -
 arch/sparc/include/asm/irq_work.h      |    8 +++
 arch/sparc/kernel/pcr.c                |    2 +-
 arch/tile/include/asm/irq_work.h       |    1 +
 arch/um/include/asm/irq_work.h         |    1 +
 arch/unicore32/include/asm/irq_work.h  |    1 +
 arch/x86/Kconfig                       |    1 -
 arch/x86/include/asm/irq_work.h        |   15 +++++
 arch/x86/kernel/irq_work.c             |    6 +-
 arch/xtensa/include/asm/irq_work.h     |    1 +
 drivers/staging/iio/trigger/Kconfig    |    1 -
 include/asm-generic/irq_work.h         |   23 ++++++++
 include/linux/irq_work.h               |   32 ++++++++++++
 include/linux/printk.h                 |    3 -
 include/linux/tick.h                   |   17 ++++++-
 init/Kconfig                           |    5 +--
 kernel/irq_work.c                      |   88 ++++++++++++++++++++++----------
 kernel/printk.c                        |   12 ++---
 kernel/time/tick-sched.c               |    7 ++-
 kernel/timer.c                         |    1 -
 55 files changed, 211 insertions(+), 67 deletions(-)
 create mode 100644 arch/alpha/include/asm/irq_work.h
 create mode 100644 arch/arm/include/asm/irq_work.h
 create mode 100644 arch/arm64/include/asm/irq_work.h
 create mode 100644 arch/avr32/include/asm/irq_work.h
 create mode 100644 arch/blackfin/include/asm/irq_work.h
 create mode 100644 arch/c6x/include/asm/irq_work.h
 create mode 100644 arch/cris/include/asm/irq_work.h
 create mode 100644 arch/frv/include/asm/irq_work.h
 create mode 100644 arch/h8300/include/asm/irq_work.h
 create mode 100644 arch/hexagon/include/asm/irq_work.h
 create mode 100644 arch/ia64/include/asm/irq_work.h
 create mode 100644 arch/m32r/include/asm/irq_work.h
 create mode 100644 arch/m68k/include/asm/irq_work.h
 create mode 100644 arch/microblaze/include/asm/irq_work.h
 create mode 100644 arch/mips/include/asm/irq_work.h
 create mode 100644 arch/mn10300/include/asm/irq_work.h
 create mode 100644 arch/openrisc/include/asm/irq_work.h
 create mode 100644 arch/parisc/include/asm/irq_work.h
 create mode 100644 arch/powerpc/include/asm/irq_work.h
 create mode 100644 arch/s390/include/asm/irq_work.h
 create mode 100644 arch/score/include/asm/irq_work.h
 create mode 100644 arch/sh/include/asm/irq_work.h
 create mode 100644 arch/sparc/include/asm/irq_work.h
 create mode 100644 arch/tile/include/asm/irq_work.h
 create mode 100644 arch/um/include/asm/irq_work.h
 create mode 100644 arch/unicore32/include/asm/irq_work.h
 create mode 100644 arch/x86/include/asm/irq_work.h
 create mode 100644 arch/xtensa/include/asm/irq_work.h
 create mode 100644 include/asm-generic/irq_work.h

-- 
1.7.5.4

