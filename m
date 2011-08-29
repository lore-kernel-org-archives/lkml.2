Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668Ab1H2SG3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 14:06:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:36992 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754526Ab1H2SGW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 14:06:22 -0400
Subject: Re: [PATCH 05/32] nohz: Move rcu dynticks idle mode handling to
 idle enter/exit APIs
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Menage <menage@google.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Date: Mon, 29 Aug 2011 20:06:00 +0200
In-Reply-To: <20110829175954.GF9748@somewhere.redhat.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
	 <1313423549-27093-6-git-send-email-fweisbec@gmail.com>
	 <1314627922.2816.65.camel@twins>
	 <20110829171155.GD9748@somewhere.redhat.com>
	 <1314640155.2816.117.camel@twins>
	 <20110829175954.GF9748@somewhere.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314641160.2816.128.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-29 at 19:59 +0200, Frederic Weisbecker wrote:
> On Mon, Aug 29, 2011 at 07:49:15PM +0200, Peter Zijlstra wrote:
> > On Mon, 2011-08-29 at 19:11 +0200, Frederic Weisbecker wrote:
> > > On Mon, Aug 29, 2011 at 04:25:22PM +0200, Peter Zijlstra wrote:
> > > > On Mon, 2011-08-15 at 17:52 +0200, Frederic Weisbecker wrote:
> > > > > To prepare for nohz / idle logic split, pull out the rcu dynticks
> > > > > idle mode switching to strict idle entry/exit areas.
> > > > > 
> > > > > So we make the dyntick mode possible without always involving rcu
> > > > > extended quiescent state. 
> > > > 
> > > > Why is this a good thing? I would be thinking that if we're a userspace
> > > > bound task and we disable the tick rcu would be finished on this cpu and
> > > > thus the extended quiescent state is just what we want?
> > > 
> > > But we can stop the tick from the kernel, not just userspace.
> > 
> > Humm!? I'm confused, I thought the idea was to only stop the tick when
> > we're 'stuck' in a user bound task. Now I get that we have to stop the
> > tick from kernel space (as in the interrupt will clearly run in kernel
> > space), but assuming the normal return from interrupt path doesn't use
> > rcu, and using rcu (as per a later patch) re-enables the tick again, it
> > doesn't matter, right?
> 
> Yeah. Either the interrupt returns to userspace and then we call
> rcu_enter_nohz() or we return to kernel space and then a further
> use of rcu will restart the tick.
> 
> Now this is not any use of rcu. Uses of rcu read side critical section
> don't need the tick. 

But but but, then how is it going to stop a grace period from happening?
The grace period state is per-cpu and the whole state machine is tick
driven.

Now some of the new RCU things go kick cpus with IPIs to push grace
periods along, but I would expect you don't want that to happen either,
the whole purpose here is to leave a cpu alone, unperturbed.

That means it has to be in an extended grace period when we stop the
tick.

> But we need it as long as there is an RCU callback
> enqueued on some CPU.

Well, no, only if there's one enqueued on this cpu because then we can't
enter the extended grace period.

> > Also, RCU needs the tick to drive the state machine, so how can you stop
> > the tick and not also stop the RCU state machine?
> 
> This is why we have rcu_needs_cpu() and rcu_pending() checks before
> stopping the tick.
> 
> rcu_needs_cpu() checks we have no local callback enqueued, in which
> case the local CPU is responsible of the RCU state machine.
> 
> rcu_pending() is there to know if another CPU started a grace period
> so we need the tick to complete it.

Hence the extended grace period, so we don't need to complete grace
periods.
