Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760233Ab2C3BfK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 21:35:10 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:54324 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759454Ab2C3BfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 21:35:05 -0400
Date: Fri, 30 Mar 2012 03:34:55 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org,
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
        Thomas Gleixner <tglx@linutronix.de>, Zen Lin <zen@openhuawei.org>,
        Dimitri Sivanich <sivanich@sgi.com>
Subject: Re: [PATCH 08/32] nohz: Try not to give the timekeeping duty to an
 adaptive tickless cpu
Message-ID: <20120330013453.GC2571@somewhere.redhat.com>
References: <1332338318-5958-1-git-send-email-fweisbec@gmail.com>
 <1332338318-5958-10-git-send-email-fweisbec@gmail.com>
 <alpine.DEB.2.00.1203210950500.20482@router.home>
 <20120327105034.GA13196@somewhere>
 <alpine.DEB.2.00.1203271106130.1170@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1203271106130.1170@router.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2012 at 11:08:05AM -0500, Christoph Lameter wrote:
> On Tue, 27 Mar 2012, Frederic Weisbecker wrote:
> 
> > > Any way to manually specify which cpu? We f.e. always "sacrifice" cpu 0
> > > for OS activities. We would like to have all Os processing things
> > > restricted to cpu 0 so that the rest of the processors do not experience
> > > the OS noise.
> >
> > Somebody tries to do this: https://lkml.org/lkml/2011/11/8/346
> >
> > But in the case of nohz cpusets there is a problem to solve:
> >
> > What if every CPUs are tickless (idle or busy), who must take
> > the timekeeping duty? Should we pick one of the busy CPUs? Or
> > keep one CPU with the tick even if it's idle? How do we choose
> > this CPU?
> 
> Then its the users fault because he specified the processor to use. There
> is no picking if its manually assigned.

If you can only tune the timekeeping binding to a single CPU, what happens when
that CPU goes idle and it's the only CPU that is not in a nohz cpuset? If there
are other CPUs that are busy but tickless, they need the timekeeping to be
maintained. This means we need to keep the periodic tick on the CPU where we
binded the timekeeping, even if that CPU is idle. That's not good for powersaving.

Let's put the example above with a practical example. We have 4 CPUs.
CPU 0, 2 and 3 are in a nohz cpuset. CPU 1 is "normal". As long as CPU 1
is busy we are fine and we can give it the timekeeping duty. Now it runs
idle and the other CPUs (0, 2, 3) are busy and they run without the tick.

We have the choice between:

1) Keep the periodic tick on CPU 1, even if it's idle, and let the timekeeping
duty be handled there.

2) Pick either CPU 0, 2 or 3 and restart the tick in one of them to handle
the timekeeping duty.

I think both propositions are relevant, it just depends on what the user
wants. 1) will consume more power because the periodic tick prevents CPU 1
from entering low power mode. But this is good if you want to ensure isolation
on CPU 0, 2 and 3.
2) is good if you want powersaving and you don't care about isolation: you just
want to run tickless when possible but no big deal if we can't.

If you can tune the timekeeping binding to only one CPU you can't make
such finegrained decision. You rather need this timekeeping duty to be
defined on a set of CPUs. And cpuset is of course a very good candidate
to define properties on a set of CPUs ;)
