Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab1I1OEP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 10:04:15 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42206 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145Ab1I1OEO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 10:04:14 -0400
Subject: Re: [RFC] Introduce greedy hrtimer walk on idle
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Venki Pallipadi <venki@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 28 Sep 2011 16:03:33 +0200
In-Reply-To: <4E8328A2.3070806@linux.intel.com>
References: <1316804080-6396-1-git-send-email-venki@google.com>
	  <1316808181.9084.49.camel@twins>
	  <CABeCy1bng31kBhDT+=xumez0hjsXVi2V2ysqtDgUH=Y+3JRpuA@mail.gmail.com>
	 <1317216203.24040.18.camel@twins> <4E8328A2.3070806@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317218613.24040.22.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-28 at 07:01 -0700, Arjan van de Ven wrote:
> On 9/28/2011 6:23 AM, Peter Zijlstra wrote:
> > On Fri, 2011-09-23 at 16:47 -0700, Venki Pallipadi wrote:
> >> On Fri, Sep 23, 2011 at 1:03 PM, Peter Zijlstra<peterz@infradead.org>  wrote:
> >>> On Fri, 2011-09-23 at 11:54 -0700, Venkatesh Pallipadi wrote:
> >>>> Comments?
> >>> Looks to be a possible IRQ latency issue as well, that can be a lot of
> >>> timers to run..
> >>>
> >> We could add some rate limit on how many timers we service this way
> >> and/or interrupt/disable-enable in the inner loop.
> >> But, this would be a problem with current hrtimer as well. When
> >> sched_tick timer is not around, we may end up servicing lot of timers
> >> depending on number of them and slack. No?
> > Right, still something to consider. We might just have to push down on
> > slack for -rt or so when it becomes a problem.
> 
> that might not be the right answer ;-)
> Slack gives you freedom to schedule these guys; without slack you can 
> still get bursts of timers, but with no freedom to punt some for RT 
> behavior.
> with slack, you can run the mandatory ones first, and then the optionals 
> until you hit some RT limit.. the optionals you do run are not going
> to bunch up to you at the time they become mandatory.

Fair enough.. so far it has not been a problem yet, mostly because we
have to run all timers from softirq due to other wreckage (which makes
the whole thing preemptible etc..). But once we can actually get away
with running timers from hardirq again we'll have to sort something out.

