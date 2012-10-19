Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030455Ab2JSPuW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 11:50:22 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:47476 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757876Ab2JSPuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 11:50:18 -0400
MIME-Version: 1.0
In-Reply-To: <1350065376-23353-1-git-send-email-fweisbec@gmail.com>
References: <1350065376-23353-1-git-send-email-fweisbec@gmail.com>
Date: Fri, 19 Oct 2012 11:50:17 -0400
Message-ID: <CAFTL4hyH5S5zLkbZMW5jzrRfUWuGha_-jOKFSW-TzC2CzNDgzA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] printk: Make it usable on nohz CPUs
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/12 Frederic Weisbecker <fweisbec@gmail.com>:
> Hi,
>
> So here is a proposition on what we can do to make printk
> correctly working on a tickless CPU.
>
> Although it's targeted to be part of the adaptive tickmess
> implemetation, it's pretty standalone and generic and also
> works for printk() calls in idle.
>
> It is based on latest linus tree.
>
> Waiting for your comments.

I've been thinking about this more and I now think we may want to
actually keep the irq_work_run() call in the sched tick but then
always implement the printk_tick() through an irq_work. This means:

- we can remove the direct call to printk_tick() in the sched tick. So
we have a single consolidated way to call that printk tick.
- we only send an IPI if the tick is stopped. Otherwise we wait for
the next tick to do the job (so we avoid IPI storms in case of
frequent printk calls)
- we remove printk_needs_cpu() and introduce irq_work_needs_cpu()
instead, in case we have pending irq works (not triggered with
self-IPIs) before we stop the tick.

I'm going to do this in the next round of this patchset.

>
> Thanks.
>
> PS: only built-tested for now.
>
> Frederic Weisbecker (5):
>   irq_work: Move irq_work_raise() declaration/default definition to
>     arch headers
>   irq_work: Only run irq_work from tick if arch needs it
>   x86: Implement arch_irq_work_use_tick
>   nohz: Add API to check tick state
>   printk: Wake up klogd with irq_work on nohz CPU
>
>  arch/alpha/include/asm/irq_work.h    |    9 +++++++
>  arch/alpha/kernel/time.c             |    2 +-
>  arch/arm/include/asm/irq_work.h      |    1 +
>  arch/arm64/include/asm/irq_work.h    |    1 +
>  arch/blackfin/include/asm/irq_work.h |    1 +
>  arch/frv/include/asm/irq_work.h      |    1 +
>  arch/hexagon/include/asm/irq_work.h  |    1 +
>  arch/mips/include/asm/irq_work.h     |    1 +
>  arch/parisc/include/asm/irq_work.h   |    1 +
>  arch/powerpc/include/asm/irq_work.h  |    8 ++++++
>  arch/powerpc/kernel/time.c           |    2 +-
>  arch/s390/include/asm/irq_work.h     |    1 +
>  arch/sh/include/asm/irq_work.h       |    1 +
>  arch/sparc/include/asm/irq_work.h    |    8 ++++++
>  arch/sparc/kernel/pcr.c              |    2 +-
>  arch/x86/include/asm/irq_work.h      |   15 ++++++++++++
>  arch/x86/kernel/irq_work.c           |    6 ++--
>  include/asm-generic/irq_work.h       |   22 +++++++++++++++++
>  include/linux/irq_work.h             |    1 +
>  include/linux/tick.h                 |   16 ++++++++++++-
>  kernel/irq_work.c                    |    7 -----
>  kernel/printk.c                      |   42 ++++++++++++++++++++++++++++++++++
>  kernel/time/tick-sched.c             |    2 +-
>  kernel/timer.c                       |    2 +-
>  24 files changed, 137 insertions(+), 16 deletions(-)
>  create mode 100644 arch/alpha/include/asm/irq_work.h
>  create mode 100644 arch/arm/include/asm/irq_work.h
>  create mode 100644 arch/arm64/include/asm/irq_work.h
>  create mode 100644 arch/blackfin/include/asm/irq_work.h
>  create mode 100644 arch/frv/include/asm/irq_work.h
>  create mode 100644 arch/hexagon/include/asm/irq_work.h
>  create mode 100644 arch/mips/include/asm/irq_work.h
>  create mode 100644 arch/parisc/include/asm/irq_work.h
>  create mode 100644 arch/powerpc/include/asm/irq_work.h
>  create mode 100644 arch/s390/include/asm/irq_work.h
>  create mode 100644 arch/sh/include/asm/irq_work.h
>  create mode 100644 arch/sparc/include/asm/irq_work.h
>  create mode 100644 arch/x86/include/asm/irq_work.h
>  create mode 100644 include/asm-generic/irq_work.h
>
> --
> 1.7.5.4
>
