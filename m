Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646Ab1KNKAp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 05:00:45 -0500
Received: from www.linutronix.de ([62.245.132.108]:46010 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab1KNKAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 05:00:44 -0500
Date: Mon, 14 Nov 2011 11:00:42 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tim Sander <tim.sander@hbm.com>
cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.2-rc1-rt1 - Compile errors also for rc1 vanilla
In-Reply-To: <201111141014.06906.tim.sander@hbm.com>
Message-ID: <alpine.LFD.2.02.1111141049420.4902@ionos>
References: <alpine.LFD.2.02.1111132213220.2694@ionos> <201111141014.06906.tim.sander@hbm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim,

On Mon, 14 Nov 2011, Tim Sander wrote:
> When trying to select the rcu in the menuconfig it is not selectable :-(.

Yeah, my bad. !SMP wants TINY_RCU and I excluded that. Fix below along
with various other fixes.

> Will there be still some consolidation for the 3.0 kernel. I really
> was hoping that the rt kernel still remains a little longer on 3.0
> since this seems to be a longer maintained kernel version for
> various groups?

As I said in the 3.0.9-rt25 release mail, 3.0-rt will be now
maintained by Steven Rostedt and will get bugfixes and stable updates.

http://lkml.org/lkml/2011/11/12/61

Thanks,

	tglx

------------->

Index: linux-3.2/include/linux/rcutree.h
===================================================================
--- linux-3.2.orig/include/linux/rcutree.h
+++ linux-3.2/include/linux/rcutree.h
@@ -60,7 +60,7 @@ static inline void exit_rcu(void)
 #ifndef CONFIG_PREEMPT_RT_FULL
 extern void synchronize_rcu_bh(void);
 #else
-# define synchronize_rcu_bh()	synchronize_rcu()
+# define synchronize_rcu_bh	synchronize_rcu
 #endif
 extern void synchronize_sched_expedited(void);
 extern void synchronize_rcu_expedited(void);
Index: linux-3.2/kernel/softirq.c
===================================================================
--- linux-3.2.orig/kernel/softirq.c
+++ linux-3.2/kernel/softirq.c
@@ -447,6 +447,7 @@ int in_serving_softirq(void)
 	preempt_enable();
 	return res;
 }
+EXPORT_SYMBOL(in_serving_softirq);
 
 /*
  * Called with bh and local interrupts disabled. For full RT cpu must
Index: linux-3.2/init/Kconfig
===================================================================
--- linux-3.2.orig/init/Kconfig
+++ linux-3.2/init/Kconfig
@@ -410,7 +410,7 @@ config TINY_RCU
 
 config TINY_PREEMPT_RCU
 	bool "Preemptible UP-only small-memory-footprint RCU"
-	depends on PREEMPT && !SMP && !PREEMPT_RT_FULL
+	depends on PREEMPT && !SMP
 	help
 	  This option selects the RCU implementation that is designed
 	  for real-time UP systems.  This option greatly reduces the
Index: linux-3.2/include/linux/sysctl.h
===================================================================
--- linux-3.2.orig/include/linux/sysctl.h
+++ linux-3.2/include/linux/sysctl.h
@@ -25,6 +25,7 @@
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/compiler.h>
+#include <linux/atomic.h>
 
 struct completion;
 
Index: linux-3.2/kernel/rcutiny.c
===================================================================
--- linux-3.2.orig/kernel/rcutiny.c
+++ linux-3.2/kernel/rcutiny.c
@@ -243,6 +243,7 @@ void call_rcu_sched(struct rcu_head *hea
 }
 EXPORT_SYMBOL_GPL(call_rcu_sched);
 
+#ifndef CONFIG_PREEMPT_RT_FULL
 /*
  * Post an RCU bottom-half callback to be invoked after any subsequent
  * quiescent state.
@@ -252,3 +253,4 @@ void call_rcu_bh(struct rcu_head *head, 
 	__call_rcu(head, func, &rcu_bh_ctrlblk);
 }
 EXPORT_SYMBOL_GPL(call_rcu_bh);
+#endif
