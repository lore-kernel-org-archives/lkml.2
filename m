Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810Ab0DBTnj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 15:43:39 -0400
Received: from mail.gmx.net ([213.165.64.20]:46740 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751090Ab0DBTnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 15:43:32 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/F7uF5qafFosGzEc8hr9olEk5X9NdlJscqPvJw2w
	0eFB22oRebHasa
Subject: Re: [patch v2 1/2] sched: check for prev_cpu == this_cpu before
 calling wake_affine()
From: Mike Galbraith <efault@gmx.de>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@linux.jf.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Yanmin Zhang <yanmin_zhang@linux.jf.intel.com>,
       Gautham R Shenoy <ego@in.ibm.com>
In-Reply-To: <1270227925.2870.49.camel@sbs-t61.sc.intel.com>
References: <20100308221946.842728363@sbs-t61.sc.intel.com>
	 <1270031119.5003.93.camel@laptop>
	 <1270079265.7835.8.camel@sbs-t61.sc.intel.com>
	 <1270099940.6707.148.camel@marge.simson.net>
	 <1270155872.2762.310.camel@sbs-t61.sc.intel.com>
	 <1270189239.6513.78.camel@marge.simson.net>
	 <1270227925.2870.49.camel@sbs-t61.sc.intel.com>
Content-Type: text/plain
Date: Fri, 02 Apr 2010 21:43:27 +0200
Message-Id: <1270237407.6316.19.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.56999999999999995
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-04-02 at 10:05 -0700, Suresh Siddha wrote:
> On Thu, 2010-04-01 at 23:20 -0700, Mike Galbraith wrote:
> > Yes, if task A and task B are more or less unrelated, you'd want them to
> > stay in separate domains, you'd not want some random event to pull.  The
> > other side of the coin is tasks which fork off partners that they will
> > talk to at high frequency.  They land just as far away, and desperately
> > need to move into a shared cache domain.  There's currently no
> > discriminator, so while always asking wake_affine() may reduce the risk
> > of moving a task with a large footprint, it also increases the risk of
> > leaving buddies jabbering cross cache.
> 
> Mike, Apart from this small tweak that you added in wake_up() path there
> is no extra logic that keeps buddies together for long.

The wakeup logic is the only thing that keeps buddies together.

>  As I was saying,
> fork/exec balance starts apart and in the partial loaded case (i.e.,
> when # of running tasks <= # of sockets or # of total cores) the default
> load balancer policy also tries to distribute the load equally among
> sockets/cores (for peak cache/memory controller bw etc). While the
> wakeup() may keep the buddies on SMT siblings, next load balancing event
> will move them far away. If we need to keep buddies together we need
> more changes than this small tweak.

We very definitely need to keep buddies cache affine.  Yes, maybe some
additional logic is needed, as there is a conflict between load types.
A kbuild spreading to the four winds is fine, while netperf jabbering
cross cache is horrible.

> > Do you have a compute load bouncing painfully which this patch cures?
> > 
> > I have no strong objections, and the result is certainly easier on the
> > eye.  If I were making the decision, I'd want to see some numbers.
> 
> All I saw in the changelog when you added this new tweak was:
> 
> commit 8b911acdf08477c059d1c36c21113ab1696c612b
> Author: Mike Galbraith <efault@gmx.de>
> Date:   Thu Mar 11 17:17:16 2010 +0100
> 
>     sched: Fix select_idle_sibling()
>     
>     Don't bother with selection when the current cpu is idle. ....
> 
> Is it me or you who need to provide the data for justification for your
> new tweak that changes the current behavior ;)
> 
> I will run some workloads aswell!

Whoa.  It was a simple question, no need to get defensive.  You need not
provide anything.  Forget I even asked, it's not my decision.

	-Mike

