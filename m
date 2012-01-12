Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125Ab2ALIze (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 03:55:34 -0500
Received: from mail4.comsite.net ([205.238.176.238]:53504 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910Ab2ALIzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 03:55:33 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
From: Milton Miller <miltonm@bga.com>
To: Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>
Cc: <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH] nohz: fix race allowing use of stale jiffies when waking
Message-Id: <nohz-jiffies-update64-race@mdm.bga.com>
Date: Thu, 12 Jan 2012 02:55:28 -0600
X-Originating-IP: 71.22.127.106
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When waking up from nohz mode, all cpus call tick_do_update_jiffies64
regardless of tick_do_timer_cpu as it could be no cpu was assigned.

At the start of the function there is a quick lockless check to
determine if jiffies is current.  The check uses last_jiffies_update,
which is used to calculate when to perform the next increment.
Unfortunately it is updated when how many jiffies to advance the
clock is calculated, before the call to do_timer which actually
updates jiffies.  A second cpu waking up could use the (potentially
very) stale jiffies value during this window.

This patch changes the check to be against tick_next_period, which
is updated after the call to do_timer completes.  It compares the
result of subtraction to zero, but this is safe as ktime_sub returns
ktime_t which is s64, as signed type.

I found this race while trying to track down reports of network adapter
hangs on a large system.  I suspected premature false detection so
I added logging when the locked region determined a multiple jiffie
update would be required.  I noticed that it happened frequently when
tick_do_timer_cpu was NONE (-1), and realized the large update was
when all cpus were previously in nohz.  I then thought about what
would happen if multiple cpus woke up near close to each other in
time and decided the stale jiffies would be used.  (I later found at
least part of the hung adapter reports were due to faulty detection
logic that has since changed upstream.)

Signed-off-by: Milton Miller <miltonm@bga.com>
Cc: stable@vger.kernel.org
--- 
Patch was generated and tested against 2.6.36; I verified it applies
with offset -1 line to next-20120111.

Index: src/kernel/time/tick-sched.c
===================================================================
--- src.orig/kernel/time/tick-sched.c	2011-10-13 17:42:16.000000000 -0500
+++ src/kernel/time/tick-sched.c	2011-10-13 17:45:31.000000000 -0500
@@ -52,8 +52,8 @@ static void tick_do_update_jiffies64(kti
 	/*
 	 * Do a quick check without holding xtime_lock:
 	 */
-	delta = ktime_sub(now, last_jiffies_update);
-	if (delta.tv64 < tick_period.tv64)
+	delta = ktime_sub(now, tick_next_period);
+	if (delta.tv64 < 0)
 		return;
 
 	/* Reevalute with xtime_lock held */
