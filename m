Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993Ab2JTQW7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 12:22:59 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:38940 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058Ab2JTQW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 12:22:56 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [RFC PATCH 0/8] printk: Make it usable on nohz CPUs v2
Date: Sat, 20 Oct 2012 12:22:39 -0400
Message-Id: <1350750167-14263-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

So the design is not quite the same here. Instead of using the ad hoc
printk_tick() in periodic mode and irq_work on nohz mode, printk
is now always using irq_work.

In turn, irq_work subsystem is able to let enqueuers choose between IPI
or lazy tick hook to execute works, and that in order to avoid IPI storm
when we have lots of enqueuing of non-urgent works like klogd wakeup
in short period of time so this keeps the old printk_tick behaviour.

It also teaches irq_work to handle nohz mode.

Warning: only compile tested in x86 for now.

Frederic Weisbecker (8):
  irq_work: Move irq_work_raise() declaration/default definition to
    arch headers
  irq_work: Let the arch tell us about self-IPI support
  x86: Implement arch_irq_work_has_ipi()
  nohz: Add API to check tick state
  irq_work: Make self-IPIs optable
  irq_work: Handle queuing without IPI support in dyntick idle mode
  irq_work: Remove CONFIG_HAVE_IRQ_WORK
  printk: Wake up klogd using irq_work

 arch/alpha/Kconfig                           |    1 -
 arch/alpha/include/asm/irq_work.h            |    9 +++++
 arch/alpha/kernel/time.c                     |    2 +-
 arch/arm/Kconfig                             |    1 -
 arch/arm/include/asm/irq_work.h              |    1 +
 arch/arm64/Kconfig                           |    1 -
 arch/arm64/include/asm/irq_work.h            |    1 +
 arch/blackfin/Kconfig                        |    1 -
 arch/blackfin/include/asm/irq_work.h         |    1 +
 arch/frv/Kconfig                             |    1 -
 arch/frv/include/asm/irq_work.h              |    1 +
 arch/hexagon/Kconfig                         |    1 -
 arch/hexagon/include/asm/irq_work.h          |    1 +
 arch/mips/Kconfig                            |    1 -
 arch/mips/include/asm/irq_work.h             |    1 +
 arch/parisc/Kconfig                          |    1 -
 arch/parisc/include/asm/irq_work.h           |    1 +
 arch/powerpc/Kconfig                         |    1 -
 arch/powerpc/include/asm/irq_work.h          |    8 ++++
 arch/powerpc/kernel/time.c                   |    2 +-
 arch/s390/Kconfig                            |    1 -
 arch/s390/include/asm/irq_work.h             |    1 +
 arch/sh/Kconfig                              |    1 -
 arch/sh/include/asm/irq_work.h               |    1 +
 arch/sparc/Kconfig                           |    1 -
 arch/sparc/include/asm/irq_work.h            |    8 ++++
 arch/sparc/kernel/pcr.c                      |    2 +-
 arch/x86/Kconfig                             |    1 -
 arch/x86/include/asm/irq_work.h              |   15 ++++++++
 arch/x86/kernel/cpu/mcheck/mce.c             |    2 +-
 arch/x86/kernel/irq_work.c                   |    6 ++--
 arch/x86/kvm/pmu.c                           |    2 +-
 drivers/acpi/apei/ghes.c                     |    2 +-
 drivers/staging/iio/trigger/Kconfig          |    1 -
 drivers/staging/iio/trigger/iio-trig-sysfs.c |    2 +-
 include/asm-generic/irq_work.h               |   23 ++++++++++++
 include/linux/irq_work.h                     |    9 ++++-
 include/linux/printk.h                       |    3 --
 include/linux/tick.h                         |   17 ++++++++-
 init/Kconfig                                 |    5 +--
 kernel/events/core.c                         |    4 +-
 kernel/events/ring_buffer.c                  |    2 +-
 kernel/irq_work.c                            |   48 +++++++++++++++++++------
 kernel/printk.c                              |   14 ++++----
 kernel/time/tick-sched.c                     |    6 ++--
 kernel/timer.c                               |    1 -
 46 files changed, 156 insertions(+), 59 deletions(-)
 create mode 100644 arch/alpha/include/asm/irq_work.h
 create mode 100644 arch/arm/include/asm/irq_work.h
 create mode 100644 arch/arm64/include/asm/irq_work.h
 create mode 100644 arch/blackfin/include/asm/irq_work.h
 create mode 100644 arch/frv/include/asm/irq_work.h
 create mode 100644 arch/hexagon/include/asm/irq_work.h
 create mode 100644 arch/mips/include/asm/irq_work.h
 create mode 100644 arch/parisc/include/asm/irq_work.h
 create mode 100644 arch/powerpc/include/asm/irq_work.h
 create mode 100644 arch/s390/include/asm/irq_work.h
 create mode 100644 arch/sh/include/asm/irq_work.h
 create mode 100644 arch/sparc/include/asm/irq_work.h
 create mode 100644 arch/x86/include/asm/irq_work.h
 create mode 100644 include/asm-generic/irq_work.h

-- 
1.7.5.4

