Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758514Ab2FHE1v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 00:27:51 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:51966 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753230Ab2FHE1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 00:27:36 -0400
Date: Thu, 7 Jun 2012 21:26:32 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: [PATCH tip/core/rcu 0/7] RCU_FAST_NO_HZ changes for 3.6
Message-ID: <20120608042632.GA1250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12060804-6078-0000-0000-00000BDD24AA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This patch series provides more adjustments to the (relatively) new
large-system-safe implementation for RCU_FAST_NO_HZ:

1.	Remove RCU_FAST_NO_HZ dependency on stop_machine() nature of
	CPU hotplug.
2.	Make RCU_FAST_NO_HZ tracing distinguish between short and
	long idle intervals.
3.	Move RCU_FAST_NO_HZ per-CPU state variables to the rcu_dynticks
	per-CPU structure.
4.	Precompute RCU_FAST_NO_HZ timer offsets so that the timers
	will actually be paid attention to.  This fixes the slow-boot
	problem that hit a few people.
5.	Convert ftrace_dump() calls in idle entry and idle exit from
	DUMP_ALL to DUMP_ORIG.
6.	Fix erroneous TINY_PREEMPT_RCU assumption that rcu_preempt_needs_cpu()
	is a quiescent state (it is not).
7.	Round RCU_FAST_NO_HZ lazy timeout to nearest second to conserve
	power on systems with synchronized scheduler-clock interrupts.

I am considering pushing #1-#4 into 3.5 for the slow-boot regression.
If you object, please let me know.

							Thanx, Paul


 b/include/linux/rcupdate.h   |    2 
 b/include/linux/rcutiny.h    |    6 +
 b/include/linux/rcutree.h    |    2 
 b/include/trace/events/rcu.h |    1 
 b/kernel/rcutiny_plugin.h    |    2 
 b/kernel/rcutree.c           |    2 
 b/kernel/rcutree.h           |   14 +++
 b/kernel/rcutree_plugin.h    |    8 +-
 b/kernel/time/tick-sched.c   |    7 +
 kernel/rcutree.c             |    4 -
 kernel/rcutree_plugin.h      |  167 ++++++++++++++++++++++---------------------
 11 files changed, 124 insertions(+), 91 deletions(-)

