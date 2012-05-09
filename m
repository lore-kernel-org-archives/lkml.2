Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869Ab2EIDan (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 23:30:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63239 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753588Ab2EIDal (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 23:30:41 -0400
Date: Tue, 8 May 2012 23:30:05 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: torvalds@linux-foundation.org, Peter Zijlstra <peterz@infradead.org>
cc: Stepan Moskovchenko <stepanm@codeaurora.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Signed-off-by:;
Subject: [PATCH] 5fbd036b552f633abb394a319f7c62a5c86a9cd7 breaks PA-RISC boot
In-Reply-To: <1336250006.2463.139.camel@laptop>
Message-ID: <Pine.LNX.4.64.1205082323020.21169@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1205042305250.18896@file.rdu.redhat.com>
 <1336250006.2463.139.camel@laptop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 5 May 2012, Peter Zijlstra wrote:

> On Fri, 2012-05-04 at 23:26 -0400, Mikulas Patocka wrote:
> > Your patch 5fbd036b552f633abb394a319f7c62a5c86a9cd7 breaks PA-RISC boot. I 
> > have a dual-core PA-8800. With the patch applied, the kernel crashes with 
> > these messages. The timer structures are apparently corrupted, as the 
> > timer sees a negative amount of delayed cycles: 
> 
> You'll find:
> 
>   http://marc.info/?l=linux-parisc&m=133241790810604&w=2
> 
> will probably fix the issue.

I confirm that the patch fixes the problem.

So let's send it to Linus so that 3.4 will boot on PA-RISC.

Mikulas

---

The scheduler depends on receiving the CPU_STARTING notification, without
which we end up into a lot of trouble. So add the missing call to
notify_cpu_starting() in the bringup code.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Acked-by: Mikulas Patocka <mpatocka@redhat.com>
---

 arch/parisc/kernel/smp.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: linux-3.4-rc6-fast/arch/parisc/kernel/smp.c
===================================================================
--- linux-3.4-rc6-fast.orig/arch/parisc/kernel/smp.c	2012-05-09 04:54:35.000000000 +0200
+++ linux-3.4-rc6-fast/arch/parisc/kernel/smp.c	2012-05-09 04:55:24.000000000 +0200
@@ -295,8 +295,13 @@ smp_cpu_init(int cpunum)
 
 		printk(KERN_CRIT "CPU#%d already initialized!\n", cpunum);
 		machine_halt();
-	}  
+	}
+
+	notify_cpu_starting(cpunum);
+
+	ipi_call_lock();
 	set_cpu_online(cpunum, true);
+	ipi_call_unlock();
 
 	/* Initialise the idle task for this CPU */
 	atomic_inc(&init_mm.mm_count);
