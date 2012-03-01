Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189Ab2CATDw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 14:03:52 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16741 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756396Ab2CATDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 14:03:47 -0500
X-Authority-Analysis: v=2.0 cv=Z7xu7QtA c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=UBy9sU4F98IA:10 a=gtHglMhDr1sA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=r_TA7aP2bN_L1VJppHYA:9 a=Ac3JJ_KxsaziDvllf30A:7 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120301190344.948157137@goodmis.org>
User-Agent: quilt/0.50-1
Date: Thu, 01 Mar 2012 13:55:28 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>
Subject: [PATCH RT 1/9][RFC] [PATCH 1/9] timer: Fix hotplug for -rt
References: <20120301185527.064629423@goodmis.org>
Content-Disposition: inline; filename=0001-timer-Fix-hotplug-for-rt.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Revert the RT patch:
    Author: Ingo Molnar <mingo@elte.hu>
    Date:   Fri Jul 3 08:30:32 2009 -0500
    timers: fix timer hotplug on -rt

    Here we are in the CPU_DEAD notifier, and we must not sleep nor
    enable interrupts.

There's no problem with sleeping in this notifier.

But the get_cpu_var() had to be converted to a get_local_var().

Replace the previous fix with the get_local_var() convert.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/timer.c |   16 +++++-----------
 1 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index a791a43..c8c88d1 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1743,21 +1743,17 @@ static void __cpuinit migrate_timers(int cpu)
 {
 	struct tvec_base *old_base;
 	struct tvec_base *new_base;
-	unsigned long flags;
 	int i;
 
 	BUG_ON(cpu_online(cpu));
 	old_base = per_cpu(tvec_bases, cpu);
-	new_base = get_cpu_var(tvec_bases);
+	new_base = get_local_var(tvec_bases);
 	/*
 	 * The caller is globally serialized and nobody else
 	 * takes two locks at once, deadlock is not possible.
 	 */
-	local_irq_save(flags);
-	while (!spin_trylock(&new_base->lock))
-		cpu_relax();
-	while (!spin_trylock(&old_base->lock))
-		cpu_relax();
+	spin_lock_irq(&new_base->lock);
+	spin_lock_nested(&old_base->lock, SINGLE_DEPTH_NESTING);
 
 	BUG_ON(old_base->running_timer);
 
@@ -1771,10 +1767,8 @@ static void __cpuinit migrate_timers(int cpu)
 	}
 
 	spin_unlock(&old_base->lock);
-	spin_unlock(&new_base->lock);
-	local_irq_restore(flags);
-
-	put_cpu_var(tvec_bases);
+	spin_unlock_irq(&new_base->lock);
+	put_local_var(tvec_bases);
 }
 #endif /* CONFIG_HOTPLUG_CPU */
 
-- 
1.7.3.4


