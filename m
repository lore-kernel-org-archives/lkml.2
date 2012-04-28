Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306Ab2D1JLT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 05:11:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44439 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298Ab2D1JLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 05:11:14 -0400
Date: Sat, 28 Apr 2012 02:10:53 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-3b0132ce4fff68b30abdfcb74cffc283af711076@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rusty@rustcorp.com.au, peterz@infradead.org,
        srivatsa.bhat@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, rkuo@codeaurora.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, peterz@infradead.org,
        srivatsa.bhat@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, rkuo@codeaurora.org
In-Reply-To: <20120420124557.581762105@linutronix.de>
References: <20120420124557.581762105@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] hexagon: Use generic idle thread allocation
Git-Commit-ID: 3b0132ce4fff68b30abdfcb74cffc283af711076
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 28 Apr 2012 02:10:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3b0132ce4fff68b30abdfcb74cffc283af711076
Gitweb:     http://git.kernel.org/tip/3b0132ce4fff68b30abdfcb74cffc283af711076
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Fri, 20 Apr 2012 13:05:51 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 26 Apr 2012 12:06:11 +0200

hexagon: Use generic idle thread allocation

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Acked-and-tested-by: Richard Kuo <rkuo@codeaurora.org>
Link: http://lkml.kernel.org/r/20120420124557.581762105@linutronix.de
---
 arch/hexagon/Kconfig      |    1 +
 arch/hexagon/kernel/smp.c |   11 ++---------
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/arch/hexagon/Kconfig b/arch/hexagon/Kconfig
index 9059e39..d2e4a33 100644
--- a/arch/hexagon/Kconfig
+++ b/arch/hexagon/Kconfig
@@ -27,6 +27,7 @@ config HEXAGON
 	select HAVE_ARCH_TRACEHOOK
 	select NO_IOPORT
 	select GENERIC_IOMAP
+	select GENERIC_SMP_IDLE_THREAD
 	# mostly generic routines, with some accelerated ones
 	---help---
 	  Qualcomm Hexagon is a processor architecture designed for high
diff --git a/arch/hexagon/kernel/smp.c b/arch/hexagon/kernel/smp.c
index 93e77e2..f726462 100644
--- a/arch/hexagon/kernel/smp.c
+++ b/arch/hexagon/kernel/smp.c
@@ -196,18 +196,11 @@ void __cpuinit start_secondary(void)
  * maintains control until "cpu_online(cpu)" is set.
  */
 
-int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *tidle)
+int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *idle)
 {
-	struct task_struct *idle;
-	struct thread_info *thread;
+	struct thread_info *thread = (struct thread_info *)idle->stack;
 	void *stack_start;
 
-	/*  Create new init task for the CPU  */
-	idle = fork_idle(cpu);
-	if (IS_ERR(idle))
-		panic(KERN_ERR "fork_idle failed\n");
-
-	thread = (struct thread_info *)idle->stack;
 	thread->cpu = cpu;
 
 	/*  Boot to the head.  */
