Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244Ab0HPTbo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 15:31:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:37582 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756101Ab0HPTbm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 15:31:42 -0400
Subject: Re: [patch 3/3] sched: move sched_avg_update() to update_cpu_load()
From: Peter Zijlstra <peterz@infradead.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "mingo@elte.hu" <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "chris@frostnet.net" <chris@frostnet.net>,
        "debian00@aliceadsl.fr" <debian00@aliceadsl.fr>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jonathan.protzenko@gmail.com" <jonathan.protzenko@gmail.com>,
        "mans@mansr.com" <mans@mansr.com>,
        "psastudio@mail.ru" <psastudio@mail.ru>, "rjw@sisk.pl" <rjw@sisk.pl>,
        "stephan.eicher@web.de" <stephan.eicher@web.de>,
        "sxxe@gmx.de" <sxxe@gmx.de>,
        "thomas@archlinux.org" <thomas@archlinux.org>,
        "venki@google.com" <venki@google.com>,
        "wonghow@gmail.com" <wonghow@gmail.com>
In-Reply-To: <1281980769.2676.33.camel@sbsiddha-MOBL3.sc.intel.com>
References: <20100813190539.410550989@sbsiddha-MOBL3.sc.intel.com>
	 <20100813193911.999833492@sbsiddha-MOBL3.sc.intel.com>
	 <1281945634.1926.968.camel@laptop>
	 <1281980769.2676.33.camel@sbsiddha-MOBL3.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 16 Aug 2010 21:31:26 +0200
Message-ID: <1281987086.1926.1890.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-16 at 10:46 -0700, Suresh Siddha wrote:

> There is no guarantee that the original cpu won't be doing this in
> parallel with nohz idle load balancing cpu.

Hmm, true.. bugger.

> > > Fix it by moving the sched_avg_update() to more appropriate update_cpu_load()
> > > where the CFS load gets updated aswell.
> > 
> > Right, except it breaks things a bit, at the very least you really need
> > that update right before reading it, otherwise you can end up with >100%
> > fractions, which are odd indeed ;-)
> 
> with the patch, the update always happens before reading it. isn't it?
> 
> update now happens during the scheduler tick (or during nohz load
> balancing tick). And the load balancer gets triggered with the tick.
> So the update (at the tick) should happen before reading it (used by
> load balancing triggered by the tick). Am I missing something?

We run the load-balancer in softirq context, on -rt that's a task, and
we could have ran other (more important) RT tasks between the hardirq
and the softirq running, which would increase the rt_avg and could thus
result in >100%.

But I think we can simply retain the sched_avg_update(rq) in
sched_rt_avg_update(), that is ran with rq->lock held and should be
enough to avoid that case.

We can retain the other bit of you patch, moving sched_avg_update() from
scale_rt_power() to update_cpu_load(), since that is only concerned with
lowering the average when there is no actual activity.


