Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab2ALJtV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 04:49:21 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:64925 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752859Ab2ALJtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 04:49:20 -0500
Message-ID: <1326361755.2950.1.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: [PATCH] nohz: fix race allowing use of stale jiffies when waking
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Milton Miller <miltonm@bga.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>,
        linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Thu, 12 Jan 2012 10:49:15 +0100
In-Reply-To: <nohz-jiffies-update64-race@mdm.bga.com>
References: <nohz-jiffies-update64-race@mdm.bga.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 12 janvier 2012 à 02:55 -0600, Milton Miller a écrit :
> When waking up from nohz mode, all cpus call tick_do_update_jiffies64
> regardless of tick_do_timer_cpu as it could be no cpu was assigned.
> 
> At the start of the function there is a quick lockless check to
> determine if jiffies is current.  The check uses last_jiffies_update,
> which is used to calculate when to perform the next increment.
> Unfortunately it is updated when how many jiffies to advance the
> clock is calculated, before the call to do_timer which actually
> updates jiffies.  A second cpu waking up could use the (potentially
> very) stale jiffies value during this window.
> 
> This patch changes the check to be against tick_next_period, which
> is updated after the call to do_timer completes.  It compares the
> result of subtraction to zero, but this is safe as ktime_sub returns
> ktime_t which is s64, as signed type.
> 
> I found this race while trying to track down reports of network adapter
> hangs on a large system.  I suspected premature false detection so
> I added logging when the locked region determined a multiple jiffie
> update would be required.  I noticed that it happened frequently when
> tick_do_timer_cpu was NONE (-1), and realized the large update was
> when all cpus were previously in nohz.  I then thought about what
> would happen if multiple cpus woke up near close to each other in
> time and decided the stale jiffies would be used.  (I later found at
> least part of the hung adapter reports were due to faulty detection
> logic that has since changed upstream.)
> 
> Signed-off-by: Milton Miller <miltonm@bga.com>
> Cc: stable@vger.kernel.org
> --- 
> Patch was generated and tested against 2.6.36; I verified it applies
> with offset -1 line to next-20120111.
> 
> Index: src/kernel/time/tick-sched.c
> ===================================================================
> --- src.orig/kernel/time/tick-sched.c	2011-10-13 17:42:16.000000000 -0500
> +++ src/kernel/time/tick-sched.c	2011-10-13 17:45:31.000000000 -0500
> @@ -52,8 +52,8 @@ static void tick_do_update_jiffies64(kti
>  	/*
>  	 * Do a quick check without holding xtime_lock:
>  	 */
> -	delta = ktime_sub(now, last_jiffies_update);
> -	if (delta.tv64 < tick_period.tv64)
> +	delta = ktime_sub(now, tick_next_period);
> +	if (delta.tv64 < 0)
>  		return;
>  

Given ktime_t on 32bit arches is not an atomic type, I wonder how safe
is this anyway...



