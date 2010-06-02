Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933265Ab0FBW20 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 18:28:26 -0400
Received: from mga03.intel.com ([143.182.124.21]:13425 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933230Ab0FBW2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 18:28:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,349,1272870000"; 
   d="scan'208";a="284289718"
Subject: Re: [patch 4/7] sched: Change nohz ilb logic from pull to push
 model
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "svaidy@linux.vnet.ibm.com" <svaidy@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@linux.jf.intel.com>,
       Venkatesh Pallipadi <venki@google.com>,
       "ego@in.ibm.com" <ego@in.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Nigel Cunningham <ncunningham@crca.org.au>
In-Reply-To: <20100601234719.GC7764@dirshya.in.ibm.com>
References: <20100517182726.089700767@sbs-t61.sc.intel.com>
	 <20100517184027.862696498@sbs-t61.sc.intel.com>
	 <20100601234719.GC7764@dirshya.in.ibm.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Wed, 02 Jun 2010 15:27:31 -0700
Message-Id: <1275517651.2913.302.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-01 at 16:47 -0700, Vaidyanathan Srinivasan wrote:
> * Suresh Siddha <suresh.b.siddha@intel.com> [2010-05-17 11:27:30]:
> 
> > From: Venkatesh Pallipadi <venki@google.com>
> > Subject: sched: Change nohz ilb logic from pull to push model
> >
> > In the new push model, all idle CPUs indeed go into nohz mode. There is
> > still the concept of idle load balancer. Busy CPU kicks the nohz
> > balancer when any of the nohz CPUs need idle load balancing.
> > The kickee CPU does the idle load balancing on behalf of all idle CPUs
> > instead of the normal idle balance.
> >
> > This addresses the below two problems with the current nohz ilb logic:
> > * the balancer will continue to have periodic ticks and wakeup
> >   frequently, even though it may not have any rebalancing to do on
> >   behalf of any of the idle CPUs.
> > * On x86 and CPUs that have APIC timer stoppage on idle CPUs, this
> >   periodic wakeup can result in an additional interrupt on a CPU
> >   doing the timer broadcast.
> 
> How do we select the timer broadcast cpu today?  Is it changes at all
> at run time?  Maybe that CPU should be a good target for the timer
> migration so that additional CPU are not wokenup from idle states.

It is based on who handles irq 0. Anyways, newer generation of cpu's
doesn't have apic timer stoppage issue. If you want to do more
intelligent timer migrations, then its better to address with a
mechanism that works efficiently for all platforms.

> Can you please give more explanation on how the combination of
> first_pick_cpu and second_pick_cpu works.  We need to kick an idle CPU
> whenever our cpu or group becomes overloaded right.

With this change, the need for idle load balancing(/kicking an idle cpu
to do idle load balancing on behalf of all idle cpus) is determined when
there is only one cpu busy with more than 1 task or more than one cpu
busy.

sched group is relevant only if we are balancing at a particular domain.
Traversing all the groups and finding out the group load vs capacity
from the busy cpu will add more overhead to the busy cpu.

We need more intelligence of when to do idle load balancing and when to
stop it. Current proposal is a simple fix to address the idle core in a
semi-idle laptop/netbooks to not have periodic ticks in idle.

>  We will have to
> prefer cores of other packages when more tasks become ready to run.
> So a notion of group overload is needed to kick new cpus.  Also new
> idle CPUs that are kicked should come form other cores and packages
> instead or nearest sibling.

Kicked cpu can be nearest idle core to the busy core. This can do idle
load balancing and the actual load can move the far away core (for perf
policy) or nearest core (for power-savings policy). Any intelligent
heuristics to do this with minimal disturbance to busy cpu's are
welcome.

> 
> As per the current implementation a sibling thread may be kicked but
> it will not pull the task as the load balancer will be run on behalf
> of all idle cores in the system and then a appropriate idle core will
> pull the new task... correct?

Yes.

thanks,
suresh

