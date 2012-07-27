Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909Ab2G0Pko (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 11:40:44 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37559 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673Ab2G0Pkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 11:40:41 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@ti.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC PATCH 0/5] cputime: Generic virtual based cputime accounting
Date: Fri, 27 Jul 2012 17:40:29 +0200
Message-Id: <1343403634-31555-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So,

This is a proposition to handle the cputime accounting without the
tick to prepare for stopping the tick further idle.

I have managed to reuse and generalize the kernel/user boundary
hooks used by RCU. This way we can minimize the changes in archs
that don't support virtual cputime and we can also switch between
vtime and tick based accounting to minimize the overhead depending
on the tick behaviour.

This is based on top of rcu/idle branch in Paul's tree and my
vtime consolidation series: https://lkml.org/lkml/2012/6/20/762
(still waiting to be picked btw).

You, adventurer, can pull from:

git://github.com/fweisbec/linux-dynticks.git
	vtime/generic


Frederic Weisbecker (5):
  user_hooks: New user hooks subsystem
  cputime: Don't allow virtual and irq finegrained cputime accounting
    simultaneously
  cputime: Allow dynamic switch between tick/virtual based cputime
    accounting
  cputime: Rename account_system_vtime to account_vtime
  cputime: Generic on-demand virtual cputime accounting

 arch/Kconfig                                 |   10 +-
 arch/ia64/include/asm/cputime.h              |    5 +
 arch/ia64/kernel/time.c                      |    6 +-
 arch/powerpc/include/asm/cputime.h           |    5 +
 arch/powerpc/kernel/time.c                   |   10 +-
 arch/s390/include/asm/cputime.h              |    5 +
 arch/s390/kernel/vtime.c                     |    6 +-
 arch/x86/Kconfig                             |    2 +-
 arch/x86/include/asm/{rcu.h => user_hooks.h} |   12 +-
 arch/x86/kernel/ptrace.c                     |    6 +-
 arch/x86/kernel/signal.c                     |    5 +-
 arch/x86/kernel/traps.c                      |    2 +-
 arch/x86/mm/fault.c                          |    2 +-
 include/asm-generic/cputime.h                |    7 +
 include/linux/hardirq.h                      |    8 +-
 include/linux/kernel_stat.h                  |   13 ++
 include/linux/kvm_host.h                     |    4 +-
 include/linux/rcupdate.h                     |    2 -
 include/linux/sched.h                        |   13 +--
 include/linux/user_hooks.h                   |   36 ++++++
 init/Kconfig                                 |   35 ++++--
 kernel/Makefile                              |    1 +
 kernel/fork.c                                |    3 +-
 kernel/rcutree.c                             |   42 +-------
 kernel/sched/core.c                          |    9 +-
 kernel/sched/cputime.c                       |  159 +++++++++++++++++++++----
 kernel/softirq.c                             |    6 +-
 kernel/time/tick-sched.c                     |   28 ++---
 kernel/user_hooks.c                          |   56 +++++++++
 29 files changed, 348 insertions(+), 150 deletions(-)
 rename arch/x86/include/asm/{rcu.h => user_hooks.h} (56%)
 create mode 100644 include/linux/user_hooks.h
 create mode 100644 kernel/user_hooks.c

-- 
1.7.5.4

