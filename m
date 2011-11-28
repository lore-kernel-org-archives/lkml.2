Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab1K1Xzc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 18:55:32 -0500
Received: from mga01.intel.com ([192.55.52.88]:37284 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494Ab1K1Xzb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 18:55:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,587,1315206000"; 
   d="scan'208";a="89973130"
Subject: Re: [patch 1/6] sched, nohz: introduce nohz_flags in the struct rq
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Tim Chen <tim.c.chen@linux.jf.intel.com>,
        "Shi, Alex" <alex.shi@intel.com>
Date: Mon, 28 Nov 2011 15:59:09 -0800
In-Reply-To: <1322130279.2921.7.camel@twins>
References: <20111118230323.592022417@sbsiddha-desk.sc.intel.com>
	 <20111118230553.882444396@sbsiddha-desk.sc.intel.com>
	 <1322130279.2921.7.camel@twins>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1322524749.21329.70.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-24 at 02:24 -0800, Peter Zijlstra wrote:
> On Fri, 2011-11-18 at 15:03 -0800, Suresh Siddha wrote:
> > plain text document attachment (introduce_rq_nohz_flags.patch)
> > Introduce nohz_flags in the struct rq, which will track two flags for now.
> > 
> > NOHZ_TICK_STOPPED will convey the stop tick status that gets set when
> > the tick is stopped and cleared during the first busy tick after the tick
> > is restarted.
> > 
> > NOHZ_BALANCE_KICK will track the need for nohz idle load balance
> > on this rq.
> 
> The changelog is missing the crucial part: Why are we doing this? :-)

We already had nohz_balance_kick in the rq, which was not being updated
atomically. So it is quite possible that two cpu's can simultaneously
kick the idle load balancing cpu. NOHZ_BALANCE_KICK bit of the
nohz_flags will track the need for nohz idle load balance on this rq and
will be updated atomically.

When the rq is ready to run a task when coming out of tickless idle,
tick is restarted and data structures used for nohz idle load balancing
are updated immediately. This will result in too many nohz idle load
balancer status updates, if the rq comes out of tickless for running one
(or very few) short running tasks before going back to tickless idle.
This is resulting in scalability issues especially if there are lot of
logical cpu's that enters and exit idle often. There is no need to
update the nohz idle load balancer data structures for the semi-idle cpu
so often (as the information for the need of the idle load balancing and
who needs to be kicked is needed only at the busy cpu's tick).
NOHZ_TICK_STOPPED in rq's nohz_flags is introduced to keep track of the
tick stopped status that gets set when the tick is stopped. It will be
used to update the nohz idle load balancer data structures during the
first busy tick after the tick is restarted. At this first busy tick
after tickless idle, NOHZ_TICK_STOPPED flag will be reset.

I will include this info in the next update.

thanks,
suresh

