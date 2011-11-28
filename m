Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191Ab1K1XyQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 18:54:16 -0500
Received: from mga09.intel.com ([134.134.136.24]:11766 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752283Ab1K1XyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 18:54:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="80874645"
Subject: Re: [patch 3/6] sched, nohz: sched group, domain aware nohz idle
 load balancing
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Tim Chen <tim.c.chen@linux.jf.intel.com>,
        "Shi, Alex" <alex.shi@intel.com>
Date: Mon, 28 Nov 2011 15:58:12 -0800
In-Reply-To: <1322135629.2921.13.camel@twins>
References: <20111118230323.592022417@sbsiddha-desk.sc.intel.com>
	 <20111118230553.995756330@sbsiddha-desk.sc.intel.com>
	 <1322135629.2921.13.camel@twins>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1322524692.21329.69.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-24 at 03:53 -0800, Peter Zijlstra wrote:
> On Fri, 2011-11-18 at 15:03 -0800, Suresh Siddha wrote:
> > Make nohz idle load balancing more scalabale by using the nr_busy_cpus in
> > the struct sched_group_power.
> > 
> > Idle load balance is kicked on one of the idle cpu's when there is atleast
> > one idle cpu and
> > 
> >  - a busy rq having more than one task or
> > 
> >  - a busy scheduler group having multiple busy cpus that exceed the sched group
> >    power or
> > 
> >  - for the SD_ASYM_PACKING domain, if the lower numbered cpu's in that
> >    domain are idle compared to the busy ones.
> > 
> > This will help in kicking the idle load balancing request only when
> > there is a real imbalance. And once it is mostly balanced, these kicks will
> > be minimized.
> > 
> > These changes helped improve the workload that is context switch intensive
> > between number of task pairs by 2x on a 8 socket NHM-EX based system.
> 
> OK, but the nohz idle balance will still iterate the whole machine
> instead of smaller parts, right?

In the current series, yes. one idle cpu spending a bit more time doing
idle load balancing might be better compared to waking up multiple idle
cpu's from deep c-states.

But if needed, we can easily partition the nohz idle load balancer load
to multiple idle cpu's. But we need a balance between the right
partition size vs how many idle cpu's we need to bring out of tickless
mode to do this idle load balancing.

Current proposed series already has the infrastructure to identify
which scheduler domain has the imbalance. Perhaps we can use that to do
the nohz idle load balancing only for that domain.

For now, I am trying to do better than what mainline has.

thanks,
suresh

