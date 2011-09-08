Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681Ab1IHPPp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 11:15:45 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:47626 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826Ab1IHPPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 11:15:44 -0400
Date: Thu, 8 Sep 2011 20:45:07 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Turner <pjt@google.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelianov <xemul@parallels.com>
Subject: Re: CFS Bandwidth Control - Test results of cgroups tasks pinned vs
 unpinnede
Message-ID: <20110908151433.GB6587@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <20110607154542.GA2991@linux.vnet.ibm.com>
 <1307529966.4928.8.camel@dhcp-10-30-22-158.sw.ru>
 <20110608163234.GA23031@linux.vnet.ibm.com>
 <BANLkTim7a9uhH_K6sw4YdqWB6frT+HUqqQ@mail.gmail.com>
 <20110610181719.GA30330@linux.vnet.ibm.com>
 <BANLkTimE1b8HP-q4jgsv5jPD5S-dRoUi_g@mail.gmail.com>
 <20110615053716.GA390@linux.vnet.ibm.com>
 <BANLkTi=7S2qdVjbJkDja+GAoD=pNo2gPsTFZMFkB8NWWkO1JVQ@mail.gmail.com>
 <20110907152009.GA3868@linux.vnet.ibm.com>
 <1315423342.11101.25.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1315423342.11101.25.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <a.p.zijlstra@chello.nl> [2011-09-07 21:22:22]:

> On Wed, 2011-09-07 at 20:50 +0530, Srivatsa Vaddagiri wrote:
> > 
> > Fix excessive idle time reported when cgroups are capped. 
> 
> Where from? The whole idea of bandwidth caps is to introduce idle time,
> so what's excessive and where does it come from?

We have setup cgroups and their hard limits so that in theory they should
consume the entire capacity available on machine, leading to 0% idle time.
That's not what we see. A more detailed description of the setup and the problem
is here:

https://lkml.org/lkml/2011/6/7/352

but to quickly summarize it, the machine and the test-case is as below:

Machine : 16-cpus (2 Quad-core w/ HT enabled)
Cgroups : 5 in number (C1-C5), each having {2, 2, 4, 8, 16} tasks respectively.
	  Further, each task is placed in its own (sub-)cgroup with 
	  a capped usage of 50% CPU.

	/C1/C1_1/Task1	-> capped at 50% cpu usage
	/C1/C1_2/Task2	-> capped at 50% cpu usage
	/C2/C2_1/Task3	-> capped at 50% cpu usage
	/C2/C2_2/Task3	-> capped at 50% cpu usage
	/C3/C3_1/Task4	-> capped at 50% cpu usage
	/C3/C3_2/Task4	-> capped at 50% cpu usage
	/C3/C3_3/Task4	-> capped at 50% cpu usage
	/C3/C3_4/Task4	-> capped at 50% cpu usage
	...
	/C5/C5_16/Task32 -> capped at 50% cpu usage

So we have 32 tasks, each capped at 50% CPU usage, run on a 16-CPU
system. One can expect 0% idle time in this scenario, which was found
not to be the case. With early versions of cfs hardlimits, upto ~20%
idle time was seen, though with the current version in tip, we see upto
~10% idle time (when cfs.period = 100ms) which goes down to ~5% when
cfs.period is set to 500ms.

>From what I could find out, the "excess" idle time crops up because
load-balancer is not perfect. For example, there are instances when a
CPU has just 1 task on its runqueue (rather then the ideal number of 2
tasks/cpu). When that lone task exceeds its 50% limit, cpu is forced to
become idle.

> >  The patch introduces the notion of "steal" 
> 
> The virt folks already claimed steal-time and have it mean something
> entirely different. You get to pick a new name.

grace time?

> > (or "grace") time which is the surplus
> > time/bandwidth each cgroup is allowed to consume, subject to a maximum
> > steal time (sched_cfs_max_steal_time_us). Cgroups are allowed this "steal"
> > or "grace" time when the lone task running on a cpu is about to be throttled.
> 
> Ok, so this is a solution to an unstated problem. Why is it a good
> solution?

I am not sure if there are any "good" solutions to this problem! One
possibility is to make the idle load balancer become aggressive in
pulling tasks across sched-domain boundaries i.e when a CPU becomes idle
(after a task got throttled) and invokes the idle load balancer, it
should try "harder" at pulling a task from far-off cpus (across
package/node boundaries)?

> Also, another tunable, yay!

- vatsa
