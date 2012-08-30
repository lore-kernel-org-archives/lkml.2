Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563Ab2H3VGb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 17:06:31 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:37052 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab2H3VG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 17:06:29 -0400
Date: Thu, 30 Aug 2012 14:05:20 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: [PATCH tip/core/rcu 0/26] idle-related changes
Message-ID: <20120830210520.GA2824@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12083021-4242-0000-0000-000002B9F337
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series handles changes to the interaction between RCU and idle,
including adaptive ticks.  Almost all of these patches are courtesy
of Frederic Weisbecker.  The patches are as follows:

1.	Allow non-idle tasks to enter dyntick-idle mode from RCU's
	perspective in order to enable adaptive ticks.
2.	Add rcu_user_enter_irq() and rcu_user_exit_irq() to enable
	switching into and out of dyntick-idle mode in interrupt
	handlers to handle wakeups.
3.	Modify RCU_FAST_NO_HZ to accommodate adaptive ticks.
4.	Add a Kconfig option to enable extended quiescent states while
	in usermode execution.
5.	Allow multiple rcu_user_enter() calls to match an rcu_user_exit().
6.	Introcude runtime control for RCU's classification of user-mode
	execution as an extended quiescent state.
7.	Update adaptive-tick state on context switch in order to handle
	task migration.
8.	On x86, notify RCU of slowpath syscall entry to and exit from
	usermode execution so that RCU can track the resulting extended
	quiescent states.
9.	On c86, notify RCU of exception-path entry to and exit from
	usermode execution so that RCU can again strack the resulting
	extended quiescent states.
10.	Exit RCU extended QS on kernel preemption after irq/exception.
11.	Exit RCU extended QS on user preemption.
12.	On x86, use the new schedule_user API on userspace preemption.
13.	On x86, exit RCU extended QS on notify resumes.
14.	Provide a new RCU_USER_QS_FORCE kconfig option that enables
	userspace RCU extended quiescent states on all CPUs for testing
	purposes.
15-26.	Fix idle-loop breakage introduced on 3.3.  This affects all
	architectures that do not implement NO_HZ.

							Thanx, Paul

------------------------------------------------------------------------

 arch/alpha/kernel/process.c          |    3 
 b/arch/Kconfig                       |   10 +++
 b/arch/alpha/kernel/process.c        |    3 
 b/arch/alpha/kernel/smp.c            |    1 
 b/arch/cris/kernel/process.c         |    3 
 b/arch/frv/kernel/process.c          |    3 
 b/arch/h8300/kernel/process.c        |    3 
 b/arch/ia64/kernel/process.c         |    3 
 b/arch/m32r/kernel/process.c         |    3 
 b/arch/m68k/kernel/process.c         |    3 
 b/arch/mn10300/kernel/process.c      |    3 
 b/arch/parisc/kernel/process.c       |    3 
 b/arch/score/kernel/process.c        |    4 -
 b/arch/um/drivers/mconsole_kern.c    |    1 
 b/arch/x86/Kconfig                   |    1 
 b/arch/x86/include/asm/rcu.h         |   20 ++++++
 b/arch/x86/include/asm/thread_info.h |   10 ++-
 b/arch/x86/kernel/entry_64.S         |    8 +-
 b/arch/x86/kernel/ptrace.c           |    5 +
 b/arch/x86/kernel/signal.c           |    4 +
 b/arch/x86/kernel/traps.c            |   30 ++++++---
 b/arch/x86/mm/fault.c                |   13 +++
 b/arch/xtensa/kernel/process.c       |    3 
 b/include/linux/rcupdate.h           |    2 
 b/include/linux/sched.h              |    8 ++
 b/init/Kconfig                       |   10 +++
 b/kernel/rcutree.c                   |  115 ++++++++++++++++++++++++-----------
 b/kernel/rcutree.h                   |    3 
 b/kernel/rcutree_plugin.h            |   20 ++++++
 b/kernel/sched/core.c                |    1 
 include/linux/rcupdate.h             |   12 +++
 init/Kconfig                         |    8 ++
 kernel/rcutree.c                     |  111 ++++++++++++++++++++++++++++++---
 kernel/rcutree.h                     |    1 
 kernel/sched/core.c                  |    8 ++
 35 files changed, 375 insertions(+), 64 deletions(-)

