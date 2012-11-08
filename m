Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578Ab2KHNPI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 08:15:08 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:58141 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab2KHNPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 08:15:06 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Anish Kumar <anish198519851985@gmail.com>
Subject: [PATCH 0/7] printk: Make it usable on nohz CPUs v4
Date: Thu,  8 Nov 2012 14:14:51 +0100
Message-Id: <1352380498-23132-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There are rough changes in this series, the patchset is much simpler:

* Include the two fixes for SMP-safe irq_work claim [1/7],[2/7] 

* Split the part that prevent to stop the tick with pending work
on the queue, to make the review easier.

* Don't care anymore whether the arch can send self-IPIs or not. The real point
of it is for when we stop the tick outside idle, we'll require the self IPI
support from arch. We'll deal with that later.

* Drop the set_need_resched() hack when we enqueue in dyntick idle mode. I'm
just too worried that printk() calls in idle loop may prevent the tick from ever
beeing stopped, and even the CPU from halting.

* When the work is lazy, just never raise unless the tick is stopped. We don't care
whether the arch has obscure way to raise it or not. In any case, the hook in
update_process_times() can take care of it.

* Don't raise an IPI after queueing if there is a pending one already.

* Use per cpu irq work for printk because the printk_pending flags are per CPU
and thus can't be handled remotely.

* Queue an irq work in case of printk_sched() as well.

You can fetch from:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	nohz/printk-v4

Thanks.

Frederic Weisbecker (7):
  irq_work: Fix racy IRQ_WORK_BUSY flag setting
  irq_work: Fix racy check on work pending flag
  irq_work: Remove CONFIG_HAVE_IRQ_WORK
  nohz: Add API to check tick state
  irq_work: Don't stop the tick with pending works
  irq_work: Make self-IPIs optable
  printk: Wake up klogd using irq_work

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
 include/linux/irq_work.h            |   20 +++++++++
 include/linux/printk.h              |    3 -
 include/linux/tick.h                |   17 +++++++-
 init/Kconfig                        |    5 +--
 kernel/irq_work.c                   |   76 +++++++++++++++++++++++-----------
 kernel/printk.c                     |   36 +++++++++-------
 kernel/time/tick-sched.c            |    7 ++-
 kernel/timer.c                      |    1 -
 22 files changed, 112 insertions(+), 67 deletions(-)

-- 
1.7.5.4

