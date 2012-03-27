Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030Ab2C0L4i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 07:56:38 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:46060 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab2C0L4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 07:56:37 -0400
Date: Tue, 27 Mar 2012 13:56:32 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Christoph Lameter <cl@linux.com>, LKML <linux-kernel@vger.kernel.org>,
        linaro-sched-sig@lists.linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>, Ingo Molnar <mingo@kernel.org>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Zen Lin <zen@openhuawei.org>
Subject: Re: [PATCH 07/32] cpuset: Set up interface for nohz flag
Message-ID: <20120327115630.GD13196@somewhere>
References: <1332338318-5958-1-git-send-email-fweisbec@gmail.com>
 <1332338318-5958-9-git-send-email-fweisbec@gmail.com>
 <alpine.DEB.2.00.1203210949440.20482@router.home>
 <1332389033.5759.52.camel@marge.simpson.net>
 <20120327112254.GC13196@somewhere>
 <1332849183.7679.21.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332849183.7679.21.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2012 at 01:53:03PM +0200, Mike Galbraith wrote:
> On Tue, 2012-03-27 at 13:22 +0200, Frederic Weisbecker wrote: 
> > On Thu, Mar 22, 2012 at 05:03:53AM +0100, Mike Galbraith wrote:
> > > On Wed, 2012-03-21 at 09:50 -0500, Christoph Lameter wrote: 
> > > > On Wed, 21 Mar 2012, Frederic Weisbecker wrote:
> > > > 
> > > > > Prepare the interface to implement the nohz cpuset flag.
> > > > > This flag, once set, will tell the system to try to
> > > > > shutdown the periodic timer tick when possible.
> > > > >
> > > > > We use here a per cpu refcounter. As long as a CPU
> > > > > is contained into at least one cpuset that has the
> > > > > nohz flag set, it is part of the set of CPUs that
> > > > > run into adaptive nohz mode.
> > > > 
> > > > What are the drawbacks for nohz?
> > > 
> > > For nohz in general, latency.  To make it at all usable for rt loads, I
> > > had to make isolated cores immune from playing load balancer.  Even so,
> > > to achieve target latency, I had to hack up cpusets to let the user
> > > dynamically switch nohz off for specified sets (and the tick has to be
> > > skewed in both cases or you can just forget it).  With nohz, I can't
> > > quite achieve 30us jitter target, turn it off, I get single digit.  Out
> > > of the current box, triple digit for simple synchronized frame timers +
> > > compute worker-bees load on 64 cores.  Patch 4 probably helps that, but
> > > don't _think_ it'll fix it.  If you (currently) ever become balancer,
> > > you're latency target is smoking wreckage.
> > 
> > But this is because of waking up from CPU low power mode, right? If so
> > then busy tickless shouldn't be concerned. We can certainly have
> > configurations where the tick is not stopped in idle but can be elsewhere.
> 
> Boxen are restricted to C1 (even at that Q6600 _sucks rocks_, but more
> modern CPUs don't).  ATM, ticked is cheaper, I can't get there from here
> with nohz.

Ok but there is a difference between idle nohz and busy nohz.
Idle nohz may let the CPU enter into low power mode. busy nohz
(implemented by this patchset) doesn't because it stops the tick
when the CPU runs.
