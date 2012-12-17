Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159Ab2LQOmJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 09:42:09 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:50047 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559Ab2LQOmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 09:42:08 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC GIT PULL] printk: Full dynticks support for 3.8
Date: Mon, 17 Dec 2012 15:42:01 +0100
Message-Id: <1355755321-25493-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

We are currently working on extending the dynticks mode to broader contexts than just idle.
Under some conditions on a busy CPU, the tick can be avoided (no need of preemption for one
task running, no need of RCU state machine maintainance in userspace, etc...).

The most popular application of this is the implementation of CPU isolation. On HPC
workloads, where people run one task per-CPU in order to maximize the CPU performances,
the kernel sets itself too much on the way with these often unnecessary interrupts.

The result is a performance loss due to stolen CPU time and cache trashing of
the userspace workset.

Now CPU isolation is the most famous user. I expect more. For example we should be able
to avoid the tick when we run in guest mode. And more generally this may be a win
for most CPU-bound workloads.

So in order to implement this full dynticks mode, we need to find alternatives to
handle the many maintainance operations performed periodically and turn them to
more one-shot event driven solutions.

printk() is part of the problem. It must be safely callable from most places and for
that purpose it performs an asynchronous wake up of the readers by probing on the tick for
pending messages and readers through printk_tick().

Of course if we use printk while the tick is stopped, the pending readers may not be woken
up for a while. So a solution to make printk() working even if the CPU is in dynticks mode
is to use the irq_work subsystem. This subsystem is typically able to fire self-IPIs.
So when printk() is called, it now enqueues an irq_work that does the asynchronous wakeup:

* If the tick is stopped, it raises a self-IPI
* If the tick is running periodically then don't fire a self-IPI but wait for the next tick
to handle that instead (irq work probes on the timer tick). This avoids self-IPIs storm in
case of frequent printk() in short periods of time.

I know this is a sensitive area. We want printk() to stay minimal and not rely too much
on other subsystems that add complications and that may use printk themselves.
That's why we chose irq_work because:

- It's pretty small and self-contained
- It's lockless
- It handles most recursivity cases (if it uses printk() itself from the IPI path, this won't
fire another IPI)

But because it's sensitive, I'm proposing it as an RFC pull request.

So if you're ok with that, please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	tags/printk-dynticks-for-linus

HEAD: 74876a98a87a115254b3a66a14b27320b7f0acaa "printk: Wake up klogd using irq_work"

It has been in linux-next.

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
 include/linux/irq_work.h            |   20 +++++
 include/linux/printk.h              |    3 -
 include/linux/tick.h                |   17 ++++-
 init/Kconfig                        |    5 +-
 kernel/irq_work.c                   |  131 ++++++++++++++++++++++++++--------
 kernel/printk.c                     |   36 +++++----
 kernel/time/tick-sched.c            |    7 +-
 kernel/timer.c                      |    1 -
 22 files changed, 161 insertions(+), 73 deletions(-)

-- 
1.7.5.4

