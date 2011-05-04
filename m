Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab1EDXsJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 19:48:09 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44034 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755647Ab1EDXsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 19:48:07 -0400
Date: Thu, 5 May 2011 01:48:06 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Dave Kleikamp <dkleikamp@gmail.com>,
        Chris Mason <chris.mason@oracle.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Tim Chen <tim.c.chen@linux.intel.com>, linux-kernel@vger.kernel.org,
        lenb@kernel.org, paulmck@us.ibm.com
Subject: Re: idle issues running sembench on 128 cpus II
Message-ID: <20110504234806.GF2925@one.firstfloor.org>
References: <4DC1C95B.4040706@gmail.com> <m2pqnyyva8.fsf@firstfloor.org> <alpine.LFD.2.02.1105050023070.3005@ionos> <20110504230349.GC2925@one.firstfloor.org> <alpine.LFD.2.02.1105050110440.3005@ionos> <20110504234241.GD2925@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110504234241.GD2925@one.firstfloor.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Here's a new patch without the raw. Boots on my Westmere.

Sorry appended the old patch. Here's really the new version.

From: Andi Kleen <ak@linux.intel.com>
Date: Wed, 4 May 2011 15:09:27 -0700
Subject: [PATCH] Move C3 stop test outside lock

Avoid taking locks in the idle path for systems where the timer
doesn't stop in C3.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index da800ff..7f565b7 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -456,23 +456,22 @@ void tick_broadcast_oneshot_control(unsigned long reason)
 	unsigned long flags;
 	int cpu;
 
-	raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
-
 	/*
 	 * Periodic mode does not care about the enter/exit of power
 	 * states
 	 */
 	if (tick_broadcast_device.mode == TICKDEV_MODE_PERIODIC)
-		goto out;
+		return;
 
-	bc = tick_broadcast_device.evtdev;
 	cpu = smp_processor_id();
+	bc = tick_broadcast_device.evtdev;
 	td = &per_cpu(tick_cpu_device, cpu);
 	dev = td->evtdev;
 
 	if (!(dev->features & CLOCK_EVT_FEAT_C3STOP))
-		goto out;
+		return;
 
+	raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
 	if (reason == CLOCK_EVT_NOTIFY_BROADCAST_ENTER) {
 		if (!cpumask_test_cpu(cpu, tick_get_broadcast_oneshot_mask())) {
 			cpumask_set_cpu(cpu, tick_get_broadcast_oneshot_mask());

