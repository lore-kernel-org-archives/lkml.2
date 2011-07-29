Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755758Ab1G2ODW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 10:03:22 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:58102 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755298Ab1G2ODU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 10:03:20 -0400
Date: Fri, 29 Jul 2011 07:03:07 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [ANNOUNCE] 3.0-rt6
Message-ID: <20110729140307.GB2460@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.LFD.2.02.1107282213000.31246@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1107282213000.31246@ionos>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 28, 2011 at 11:43:16PM +0200, Thomas Gleixner wrote:
> Dear RT Folks,
> 
> I'm pleased to announce the 3.0-rt6 release.
> 
> Changes versus 3.0-rt4 (I pushed out a rt5 w/o announce)
> 
>   * pin_cpu fix (Yong Zhang)
> 
>   * Various compile fixes (Yong Zhang & myself)
> 
>   * Serial fix for omap
> 
>   * Clocksource lockless watchdog reset
> 
>   * Reenabled CONFIG_RCU_BOOST (problem is unreproducible and maybe
>     related to NO_HZ, which is still disabled. Paul is working on it!)

Once I remembered to fill in the CONFIG_INITRAMFS_SOURCE kernel parameter,
-rt6 booted just fine with CONFIG_RCU_BOOST=y and CONFIG_NO_HZ=y.
(Before that, the init process was whining bitterly about life in
general and segmentation faults in particular.)  There are dyntick-idle
periods happening, as can be seen from the first one-third of debugfs's
rcu/rcudata file:

rcu_preempt:
  0 c=225221 g=225222 pq=1 pqc=225221 qp=1 dt=7363/1/0 df=387 of=0 ri=0 ql=2 qs=..W. kt=0/W/0 ktl=96cc b=10 ci=2148054 co=0 ca=0
  1 c=225221 g=225222 pq=1 pqc=225221 qp=1 dt=11677/1/0 df=1381 of=0 ri=0 ql=0 qs=.... kt=0/W/1 ktl=ba97 b=10 ci=1089926 co=0 ca=0

The dt= fields count the number of times the corresponding CPU has
transitioned to and from dyntick-idle mode.  There is also some RCU
priority boosting happening:

0:7 tasks=TN.. kt=W ntb=3 neb=0 nnb=3 j=1182 bt=12fc
     balk: nt=0 egt=1750 bt=37 nb=2 ny=311044 nos=0

The ntb= field tells us that there have been three priority-boost events,
and nnb= tells us that they have all been for normal (as opposed to
expedited) grace periods.  You need CONFIG_RCU_TRACE=y to enable these,
in case you want to see them yourself.

This has survived 45 minutes of rcutorture thus far.

It might well be that a two-CPU 32-bit x86 environment is especially
kind to -rt, but I nevertheless propose the following patch.

							Thanx, Paul

------------------------------------------------------------------------

nohz: Enable CONFIG_NO_HZ in -rt kernel builds

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 Kconfig |    1 -
 1 file changed, 1 deletion(-)

diff -urpNa -X dontdiff linux-3.0-rt5/kernel/time/Kconfig linux-3.0-rt6/kernel/time/Kconfig
--- linux-3.0-rt5/kernel/time/Kconfig	2011-07-28 15:47:04.000000000 -0700
+++ linux-3.0-rt6/kernel/time/Kconfig	2011-07-29 04:31:06.000000000 -0700
@@ -7,7 +7,6 @@ config TICK_ONESHOT
 config NO_HZ
 	bool "Tickless System (Dynamic Ticks)"
 	depends on !ARCH_USES_GETTIMEOFFSET && GENERIC_CLOCKEVENTS
-	depends on !PREEMPT_RT_FULL
 	select TICK_ONESHOT
 	help
 	  This option enables a tickless system: timer interrupts will
