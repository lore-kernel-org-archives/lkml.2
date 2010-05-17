Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab0EQItW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 04:49:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55016 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631Ab0EQItU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 04:49:20 -0400
Subject: Re: commit e9e9250b: sync wakeup bustage when waker is an RT task
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1274071120.15000.10.camel@marge.simson.net>
References: <1273924628.10630.24.camel@marge.simson.net>
	 <1273925052.1674.138.camel@laptop>
	 <1273943222.8752.7.camel@marge.simson.net>
	 <1273994510.7873.10.camel@marge.simson.net>
	 <1274071120.15000.10.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 17 May 2010 10:49:00 +0200
Message-ID: <1274086140.5605.3719.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-17 at 06:38 +0200, Mike Galbraith wrote:
> What would be the harm/consequence of restoring RT tasks to rq->load so
> the wake_affine()::sync logic just worked as before without hackery?

Well, you'd have to constantly adjust the task weight of RT tasks to
reflect their actual consumption. Not really feasible.

So the proportional stuff works like:

 slice_i = w_i / (\Sum_j w_j) * dt

Giving a RT task a sensible weight we'd have to reverse that:

 w_i = slice_i/dt * (\Sum_j w_j)

which is something that depends on the rq->load, so every time you
change the rq->load you'd have to recompute the weight of all the RT
tasks, which again changes the rq->load (got a head-ache already? :-)

> The weight is a more or less random number, but looking around, with
> them excluded, avg_load_per_task is lowered when RT tasks enter the
> system, and rq->load[] misses their weight.  (Dunno what effect it has
> on tg shares). 

Well, those things are more or less a 'good' thing, it makes it purely
about sched_fair.

So the thing to do I think is to teach wake_affine about cpu_power,
because that is what includes the RT tasks.

The proper comparison of rq weights (like the regular load balancer
already does) is:

  A->load / A->cpu_power ~ B->load / B->cpu_power

The lower the cpu_power of a particular cpu, the less processing
capacity it has, the smaller its share of the total weight should be to
provide equal work for each task.


