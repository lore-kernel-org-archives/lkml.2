Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab1H2Sea (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 14:34:30 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50889 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512Ab1H2Se2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 14:34:28 -0400
Subject: Re: [PATCH 09/32] nohz: Move ts->idle_calls into strict idle logic
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
Date: Mon, 29 Aug 2011 20:33:23 +0200
In-Reply-To: <20110829182354.GH9748@somewhere.redhat.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
	 <1313423549-27093-10-git-send-email-fweisbec@gmail.com>
	 <1314629267.2816.82.camel@twins>
	 <20110829173426.GE9748@somewhere.redhat.com>
	 <1314640789.2816.122.camel@twins>
	 <20110829182354.GH9748@somewhere.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314642803.2816.138.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-29 at 20:23 +0200, Frederic Weisbecker wrote:

> > Well, no, on interrupt return you shouldn't do anything. If you've
> > stopped the tick it stays stopped until you do something that needs it,
> > then that action will re-enable it.
> 
> Sure, when something needs the tick in this mode, we usually
> receive an IPI and restart the tick from there but then
> tick_nohz_stop_sched_tick() handles the cases with *needs_cpu()
> very well on interrupt return (our IPI return) by doing a kind
> of "light" HZ mode by logically switching to nohz mode but
> with the next timer happening in HZ, assuming it's a matter
> of one tick and we will switch to a real nohz behaviour soon.
> 
> I don't see a good reason to duplicate that logic with a pure
> restart from the IPI.

That sounds like an optimization, and should thus be done later.

> > > That said I wonder if some of the above conditions should restore a periodic
> > > behaviour on interrupt return...
> > 
> > I would expect the tick not to be stopped when tick_nohz_can_stop_tick()
> > returns false. If it returns true, then I expect anything that needs it
> > to re-enable it.
> > 
> 
> Yeah. In the case of need_resched() in idle I believe the CPU doesn't
> really go to sleep later so it should be fine. But for the case of
> softirq pending or nohz_mode, I'm not sure...

softirqs shouldn't be pending when you go into nohz mode..

That is, I'm really not seeing what's wrong with the very simple:


  if (tick_nohz_can_stop_tick())
	tick_nohz_stop_tick();


and relying on everybody who invalidates tick_nohz_can_stop_tick(), to
do:

  tick_nohz_start_tick();

I'm also not quite sure why you always IPI, is that to avoid lock
inversions?
