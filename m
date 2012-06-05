Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531Ab2FEPui (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 11:50:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56885 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294Ab2FEPug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 11:50:36 -0400
Date: Tue, 5 Jun 2012 08:49:42 -0700
From: tip-bot for Yong Zhang <yong.zhang0@gmail.com>
Message-ID: <tip-bc6833009583bd5b096ef7aa2bb006854a5a2dce@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        yong.zhang0@gmail.com, tglx@linutronix.de, davem@davemloft.net
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, yong.zhang0@gmail.com,
        srivatsa.bhat@linux.vnet.ibm.com, davem@davemloft.net
In-Reply-To: <20120529082732.GA4250@zhy>
References: <20120529082732.GA4250@zhy>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] SPARC: SMP: Remove call to ipi_call_lock_irq()/
 ipi_call_unlock_irq()
Git-Commit-ID: bc6833009583bd5b096ef7aa2bb006854a5a2dce
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 05 Jun 2012 08:49:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bc6833009583bd5b096ef7aa2bb006854a5a2dce
Gitweb:     http://git.kernel.org/tip/bc6833009583bd5b096ef7aa2bb006854a5a2dce
Author:     Yong Zhang <yong.zhang0@gmail.com>
AuthorDate: Tue, 29 May 2012 16:27:33 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 5 Jun 2012 17:27:13 +0200

SPARC: SMP: Remove call to ipi_call_lock_irq()/ipi_call_unlock_irq()

ipi_call_lock/unlock() lock resp. unlock call_function.lock. This lock
protects only the call_function data structure itself, but it's
completely unrelated to cpu_online_mask. The mask to which the IPIs
are sent is calculated before call_function.lock is taken in
smp_call_function_many(), so the locking around set_cpu_online() is
pointless and can be removed.

Delay irq enable to after set_cpu_online().

[ tglx: Massaged changelog ]

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: ralf@linux-mips.org
Cc: sshtylyov@mvista.com
Cc: david.daney@cavium.com
Cc: nikunj@linux.vnet.ibm.com
Cc: paulmck@linux.vnet.ibm.com
Cc: axboe@kernel.dk
Cc: peterz@infradead.org
Cc: sparclinux@vger.kernel.org
Link: http://lkml.kernel.org/r/20120529082732.GA4250@zhy
Acked-by: "David S. Miller" <davem@davemloft.net>
Acked-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/sparc/kernel/smp_64.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/arch/sparc/kernel/smp_64.c b/arch/sparc/kernel/smp_64.c
index f591598..781bcb1 100644
--- a/arch/sparc/kernel/smp_64.c
+++ b/arch/sparc/kernel/smp_64.c
@@ -103,8 +103,6 @@ void __cpuinit smp_callin(void)
 	if (cheetah_pcache_forced_on)
 		cheetah_enable_pcache();
 
-	local_irq_enable();
-
 	callin_flag = 1;
 	__asm__ __volatile__("membar #Sync\n\t"
 			     "flush  %%g6" : : : "memory");
@@ -124,9 +122,8 @@ void __cpuinit smp_callin(void)
 	while (!cpumask_test_cpu(cpuid, &smp_commenced_mask))
 		rmb();
 
-	ipi_call_lock_irq();
 	set_cpu_online(cpuid, true);
-	ipi_call_unlock_irq();
+	local_irq_enable();
 
 	/* idle thread is expected to have preempt disabled */
 	preempt_disable();
@@ -1308,9 +1305,7 @@ int __cpu_disable(void)
 	mdelay(1);
 	local_irq_disable();
 
-	ipi_call_lock();
 	set_cpu_online(cpu, false);
-	ipi_call_unlock();
 
 	cpu_map_rebuild();
 
