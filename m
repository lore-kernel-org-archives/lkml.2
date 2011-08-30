Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368Ab1H3O00 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 10:26:26 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52983 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257Ab1H3O0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 10:26:25 -0400
Date: Tue, 30 Aug 2011 16:26:20 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Menage <menage@google.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: [PATCH 05/32] nohz: Move rcu dynticks idle mode handling to idle
 enter/exit APIs
Message-ID: <20110830142617.GN9748@somewhere.redhat.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
 <1313423549-27093-6-git-send-email-fweisbec@gmail.com>
 <1314627922.2816.65.camel@twins>
 <20110829171155.GD9748@somewhere.redhat.com>
 <1314640155.2816.117.camel@twins>
 <20110829175954.GF9748@somewhere.redhat.com>
 <1314641160.2816.128.camel@twins>
 <20110829233521.GK9748@somewhere.redhat.com>
 <1314703158.2799.3.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314703158.2799.3.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 30, 2011 at 01:19:18PM +0200, Peter Zijlstra wrote:
> On Tue, 2011-08-30 at 01:35 +0200, Frederic Weisbecker wrote:
> > 
> > OTOH it is needed to find non-critical sections when asked to cooperate
> > in a grace period completion. But if no callback have been enqueued on
> > the whole system we are fine. 
> 
> Its that 'whole system' clause that I have a problem with. It would be
> perfectly fine to have a number of cpus very busy generating rcu
> callbacks, however this should not mean our adaptive nohz cpu should be
> bothered to complete grace periods.
> 
> Requiring it to participate in the grace period state machine is a fail,
> plain and simple.

We need those nohz CPUs to participate because they may use read side
critical section themselves. So we need them to delay running grace period
until the end of their running rcu read side critical sections, like any
other CPUs. Otherwise their supposed rcu read side critical section wouldn't
be effective.

Either that or we need to only stop the tick when we are in userspace.
I'm not sure it would be a good idea.

We discussed this problem, I believe the problem mostly resides in rcu sched.
Because finding quiescent states for rcu bh is easy, but rcu sched needs
the tick or context switches. (For rcu preempt I have no idea.)
So for now that's the sanest way we found amongst:

- Having explicit hooks in preempt_disable() and local_irq_restore()
to notice end of rcu sched critical section. So that we don't need the tick
anymore to find quiescent states. But that's going to be costly. And we may
miss some more implicitly non-preemptable code path.

- Rely on context switches only. I believe in practice it should be fine.
But in theory this delays the grace period completion for an unbounded
amount of time.

