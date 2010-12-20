Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757664Ab0LTPYh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 10:24:37 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:63472 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754249Ab0LTPYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 10:24:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=D7UGUKg+LyWV8VmBwG7OBewGA8moCC05uITpTl9JKLt5ChW1i+ZzkgpUmTx1e78wRO
         YDVLZTdkcKeZNXjyo9Q0zirLvzb9YDrS1YrRZxsPeszEgt60ROmnEVNBXSZoEnfF9FmS
         jpd2LlaTgdnm4TneSNuyjOA/k7A7qDw0B5Srw=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: [RFC PATCH 00/15] Nohz task support
Date: Mon, 20 Dec 2010 16:24:07 +0100
Message-Id: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The timer interrupt handles several things like preemption,
timekeeping, rcu, etc...

However it appears that sometimes it is simply useless like
when a task runs alone and even more when it is in userspace
as RCU doesn't need it at all in such case.

It appears that HPC workload would get some win of such timer
deactivation, and perhaps also the Real Time world as this
minimizes the critical sections due to way less interrupts to
handle.

It works through the procfs interface:

echo 1 > /proc/self/nohz

With the following constraints:

- A cpu can have only one nohz task
- A nohz task must be affine to a single CPU. That affinity can't
change while the task is in this mode
- This must be written in /proc/self only, however further
plans to allow than to be set from another task should be
possible.

You need to migrate irqs manually from userspace, same
for tasks. If a non nohz task is running on the same cpu
than a nohz task, the tick can't be stopped.

I can provide you the tools I'm using to test it if you
want.

Note this depends on the rcu spurious softirq fixes in Paul's
queue for .38

I'm also using a hack to make init affine to the first CPU
on boot so that all userspace tasks end up to the first CPU
except kernel threads and tasks that change their affinity
explicitly (this is not sched isolation). This avoids any
task to set up timers to random CPUs on which we'll later
want to run a nohz task. But probably this can be fixed
with another way, like unbinding these timers or so. This
probably require a detailed audit.

Any comments are welcome.

You can fetch from:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	sched/nohz-task

Frederic Weisbecker (15):
  nohz_task: New mask for cpus having nohz task
  nohz_task: Avoid nohz task cpu as non-idle timer target
  nohz_task: Make tick stop and restart callable outside idle
  nohz_task: Stop the tick when the nohz task runs alone
  nohz_task: Restart the tick when another task compete on the cpu
  nohz_task: Keep the tick if rcu needs it
  nohz_task: Restart tick when RCU forces nohz task cpu quiescent state
  smp: Don't warn if irq are disabled but we don't wait for the ipi
  rcu: Make rcu_enter,exit_nohz() callable from irq
  nohz_task: Enter in extended quiescent state when in userspace
  x86: Nohz task support
  clocksource: Ignore nohz task cpu in clocksource watchdog
  sched: Protect nohz task cpu affinity
  nohz_task: Clear nohz task attribute on exit()
  nohz_task: Procfs interface

 arch/Kconfig                       |    7 ++
 arch/x86/Kconfig                   |    1 +
 arch/x86/include/asm/thread_info.h |   10 ++-
 arch/x86/kernel/ptrace.c           |   10 +++
 arch/x86/kernel/traps.c            |   22 ++++--
 arch/x86/mm/fault.c                |   13 +++-
 fs/proc/base.c                     |   80 +++++++++++++++++++++
 include/linux/cpumask.h            |    8 ++
 include/linux/rcupdate.h           |    1 +
 include/linux/sched.h              |    9 +++
 include/linux/tick.h               |   26 +++++++-
 kernel/cpu.c                       |   15 ++++
 kernel/exit.c                      |    3 +
 kernel/rcutree.c                   |  127 +++++++++++++++------------------
 kernel/rcutree.h                   |   12 ++--
 kernel/sched.c                     |  135 ++++++++++++++++++++++++++++++++++-
 kernel/smp.c                       |    2 +-
 kernel/softirq.c                   |    4 +-
 kernel/time/Kconfig                |    7 ++
 kernel/time/clocksource.c          |   10 ++-
 kernel/time/tick-sched.c           |  138 +++++++++++++++++++++++++++++++++--
 21 files changed, 535 insertions(+), 105 deletions(-)

-- 
1.7.3.2

