Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab1H3OpK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 10:45:10 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36785 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221Ab1H3OpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 10:45:08 -0400
Date: Tue, 30 Aug 2011 16:45:02 +0200
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
Subject: Re: [PATCH 09/32] nohz: Move ts->idle_calls into strict idle logic
Message-ID: <20110830144500.GR9748@somewhere.redhat.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
 <1313423549-27093-10-git-send-email-fweisbec@gmail.com>
 <1314629267.2816.82.camel@twins>
 <20110829173426.GE9748@somewhere.redhat.com>
 <1314640789.2816.122.camel@twins>
 <20110829182354.GH9748@somewhere.redhat.com>
 <1314642803.2816.138.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314642803.2816.138.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 08:33:23PM +0200, Peter Zijlstra wrote:
> On Mon, 2011-08-29 at 20:23 +0200, Frederic Weisbecker wrote:
> 
> > > Well, no, on interrupt return you shouldn't do anything. If you've
> > > stopped the tick it stays stopped until you do something that needs it,
> > > then that action will re-enable it.
> > 
> > Sure, when something needs the tick in this mode, we usually
> > receive an IPI and restart the tick from there but then
> > tick_nohz_stop_sched_tick() handles the cases with *needs_cpu()
> > very well on interrupt return (our IPI return) by doing a kind
> > of "light" HZ mode by logically switching to nohz mode but
> > with the next timer happening in HZ, assuming it's a matter
> > of one tick and we will switch to a real nohz behaviour soon.
> > 
> > I don't see a good reason to duplicate that logic with a pure
> > restart from the IPI.
> 
> That sounds like an optimization, and should thus be done later.

The optimization is already there upstream. I can split the logic for
non-idle case but I'm not sure about the point of that.
 
> > > > That said I wonder if some of the above conditions should restore a periodic
> > > > behaviour on interrupt return...
> > > 
> > > I would expect the tick not to be stopped when tick_nohz_can_stop_tick()
> > > returns false. If it returns true, then I expect anything that needs it
> > > to re-enable it.
> > > 
> > 
> > Yeah. In the case of need_resched() in idle I believe the CPU doesn't
> > really go to sleep later so it should be fine. But for the case of
> > softirq pending or nohz_mode, I'm not sure...
> 
> softirqs shouldn't be pending when you go into nohz mode..

You mean it can't happen or we don't want that to happen?

> 
> That is, I'm really not seeing what's wrong with the very simple:
> 
> 
>   if (tick_nohz_can_stop_tick())
> 	tick_nohz_stop_tick();
> 
> 
> and relying on everybody who invalidates tick_nohz_can_stop_tick(), to
> do:
> 
>   tick_nohz_start_tick();

May be for the non-idle case. But for the idle case I need to ensure
this is necessary somewhere.

> 
> I'm also not quite sure why you always IPI, is that to avoid lock
> inversions?

Exactly! I think I wrote that to some changelog but I'm not sure. I'll
check that.
