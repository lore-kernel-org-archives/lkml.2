Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132Ab1EDXmo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 19:42:44 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51365 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755987Ab1EDXmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 19:42:43 -0400
Date: Thu, 5 May 2011 01:42:41 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>, Dave Kleikamp <dkleikamp@gmail.com>,
        Chris Mason <chris.mason@oracle.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Tim Chen <tim.c.chen@linux.intel.com>, linux-kernel@vger.kernel.org,
        lenb@kernel.org, paulmck@us.ibm.com
Subject: Re: idle issues running sembench on 128 cpus
Message-ID: <20110504234241.GD2925@one.firstfloor.org>
References: <4DC1C95B.4040706@gmail.com> <m2pqnyyva8.fsf@firstfloor.org> <alpine.LFD.2.02.1105050023070.3005@ionos> <20110504230349.GC2925@one.firstfloor.org> <alpine.LFD.2.02.1105050110440.3005@ionos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1105050110440.3005@ionos>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 05, 2011 at 01:29:49AM +0200, Thomas Gleixner wrote:
> > > hierarchical about that. It all boils down on _ONE_ single functional
> > 
> > The mask can be used to see if another thread on this core is still
> > running. If yes you don't need that. Right now Linux doesn't 
> > know that, but it could be taught. The only problem is that once
> > the other guy goes idle too their timeouts have to be merged.
> > 
> > This would cut contention in half.
> 
> That makes sense, but merging the timeouts race free will be a real
> PITA.

For this case one could actually use a spinlock between the siblings.
That shouldn't be a problem as long as it's not a global spinlock.

> 
> > Also if it's HPET you could actually use multiple independent HPET channels.
> > I remember us discussing this a long time ago... Not sure if it's worth
> > it, but it may be a small relief.
> 
> Multiple broadcast devices. That sounds still horrible :)


It would cut contention in half or more at least. Not great,
but sometimes you take everything you can get.

> Might be worth a try. Need some sleep to remember why I discarded that
> idea long ago.

Ok.

Here's a new patch without the raw. Boots on my Westmere.

---

From: Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] Move C3 stop test outside lock

Avoid taking locks in the idle path for systems where the timer
doesn't stop in C3.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index da800ff..9cf0415 100644
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
 
+	cpu = raw_smp_processor_id();
 	bc = tick_broadcast_device.evtdev;
-	cpu = smp_processor_id();
 	td = &per_cpu(tick_cpu_device, cpu);
 	dev = td->evtdev;
 
 	if (!(dev->features & CLOCK_EVT_FEAT_C3STOP))
-		goto out;
+		return;
 
+	raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
 	if (reason == CLOCK_EVT_NOTIFY_BROADCAST_ENTER) {
 		if (!cpumask_test_cpu(cpu, tick_get_broadcast_oneshot_mask())) {
 			cpumask_set_cpu(cpu, tick_get_broadcast_oneshot_mask());
