Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541Ab2KRBFA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 20:05:00 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:61769 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501Ab2KRBE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 20:04:59 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Anish Kumar <anish198519851985@gmail.com>
Subject: [GIT PULL v2] printk: Make it usable on nohz cpus
Date: Sun, 18 Nov 2012 02:04:43 +0100
Message-Id: <1353200692-6039-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the printk support in dynticks mode patches that can
be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git tags/printk-dynticks-for-mingo-v2

for you to fetch changes up to 74876a98a87a115254b3a66a14b27320b7f0acaa:

  printk: Wake up klogd using irq_work (2012-11-18 01:01:49 +0100)

It is based on v3.7-rc4.

Changes since previous pull request include support for irq work flush
on CPU offlining and acks from Steve. The rest hasn't changed except some
comment fix.

Thanks.

----------------------------------------------------------------
Support for printk in dynticks mode:

* Fix two races in irq work claiming

* Generalize irq_work support to all archs

* Don't stop tick with irq works pending. This
fix is generally useful and concerns archs that
can't raise self IPIs.

* Flush irq works before CPU offlining.

* Introduce "lazy" irq works that can wait for the
next tick to be executed, unless it's stopped.

* Implement klogd wake up using irq work. This
removes the ad-hoc printk_tick()/printk_needs_cpu()
hooks and make it working even in dynticks mode.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

----------------------------------------------------------------
Frederic Weisbecker (7):
      irq_work: Fix racy IRQ_WORK_BUSY flag setting
      irq_work: Fix racy check on work pending flag
      irq_work: Remove CONFIG_HAVE_IRQ_WORK
      nohz: Add API to check tick state
      irq_work: Don't stop the tick with pending works
      irq_work: Make self-IPIs optable
      printk: Wake up klogd using irq_work

Steven Rostedt (2):
      irq_work: Flush work on CPU_DYING
      irq_work: Warn if there's still work on cpu_down

 arch/alpha/Kconfig                  |    1 -
 arch/arm/Kconfig                    |    1 -
 arch/arm64/Kconfig                  |    1 -
 arch/blackfin/Kconfig               |    1 -
 arch/frv/Kconfig                    |    1 -
 arch/hexagon/Kconfig                |    1 -
 arch/mips/Kconfig                   |    1 -
 arch/parisc/Kconfig                 |    1 -
 arch/powerpc/Kconfig                |    1 -
 arch/s390/Kconfig                   |    1 -
 arch/sh/Kconfig                     |    1 -
 arch/sparc/Kconfig                  |    1 -
 arch/x86/Kconfig                    |    1 -
 drivers/staging/iio/trigger/Kconfig |    1 -
 include/linux/irq_work.h            |   20 ++++++
 include/linux/printk.h              |    3 -
 include/linux/tick.h                |   17 ++++-
 init/Kconfig                        |    5 +-
 kernel/irq_work.c                   |  131 ++++++++++++++++++++++++++---------
 kernel/printk.c                     |   36 +++++-----
 kernel/time/tick-sched.c            |    7 +-
 kernel/timer.c                      |    1 -
 22 files changed, 161 insertions(+), 73 deletions(-)
