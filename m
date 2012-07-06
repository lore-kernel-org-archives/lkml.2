Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030333Ab2GFMA2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 08:00:28 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:45267 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030231Ab2GFMA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 08:00:26 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Josh Triplett <josh@joshtriplett.org>, Kevin Hilman <khilman@ti.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [RFC PATCH 0/6] rcu: Userspace RCU extended quiescent state
Date: Fri,  6 Jul 2012 14:00:12 +0200
Message-Id: <1341576018-10721-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Although this feature is useless alone, it is necessary to prepare
our kernel to be more tickless. With this, RCU doesn't need the tick
anymore on a CPU running in userspace.

I've made it a standalone feature because maintaining it on a big
tree like nohz cpusets doesn't scale. I'm trying to integrate the
components piecewise now as much as possible.

Once we have everything in place, this should be merged into
a CONFIG_NO_HZ_FULL option.

So what do you think? The version I use in my nohz cpusets is
doing a bit differently: instead of hooking in entry.S, it hooks
in higher level exception handlers (do_debug(), do_page_fault(), etc...)
and syscall slow path.

This version rather hooks in low level entry code. I'm not sure which is
the best. Both have their pros and cons. This is mostly about details.

I can cook a patchset with hooks on the higher level handlers to show
you if you want.

I also don't know yet if I should keep the previous TIF_NOHZ and use
syscalls slow path or not.

Yeah I'm still a bit brainstorming...

git://github.com/fweisbec/linux-dynticks.git
	rcu/user

Frederic Weisbecker (6):
  rcu: Settle config for userspace extended quiescent state
  rcu: Allow rcu_user_enter()/exit() to nest
  rcu: Exit RCU extended QS on preemption in irq exit
  x86: Use the new schedule_user API on user preemption
  x86: Kernel entry/exit hooks for RCU
  x86: Exit RCU extended QS on notify resume

 arch/Kconfig               |   13 +++++++++++++
 arch/x86/Kconfig           |    1 +
 arch/x86/include/asm/rcu.h |    7 +++++++
 arch/x86/kernel/entry_64.S |   33 +++++++++++++++++++++++++++++----
 arch/x86/kernel/signal.c   |    2 ++
 init/Kconfig               |   10 ++++++++++
 kernel/rcutree.c           |   42 ++++++++++++++++++++++++++++++++++--------
 kernel/sched/core.c        |    7 +++++++
 8 files changed, 103 insertions(+), 12 deletions(-)
 create mode 100644 arch/x86/include/asm/rcu.h

-- 
1.7.5.4

