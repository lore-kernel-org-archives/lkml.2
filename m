Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab2LLOlq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 09:41:46 -0500
Received: from mail.skyhub.de ([78.46.96.112]:50707 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753920Ab2LLOlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 09:41:45 -0500
Date: Wed, 12 Dec 2012 15:41:40 +0100
From: Borislav Petkov <bp@alien8.de>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Alex Shi <alex.shi@intel.com>, Alex Shi <lkml.alex@gmail.com>,
        rob@landley.net, mingo@redhat.com, peterz@infradead.org,
        gregkh@linuxfoundation.org, andre.przywara@amd.com, rjw@sisk.pl,
        paul.gortmaker@windriver.com, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        pjt@google.com, vincent.guittot@linaro.org,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/18] sched: simplified fork, enable load average into LB
 and power awareness scheduling
Message-ID: <20121212144140.GD8760@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Arjan van de Ven <arjan@linux.intel.com>,
	Alex Shi <alex.shi@intel.com>, Alex Shi <lkml.alex@gmail.com>,
	rob@landley.net, mingo@redhat.com, peterz@infradead.org,
	gregkh@linuxfoundation.org, andre.przywara@amd.com, rjw@sisk.pl,
	paul.gortmaker@windriver.com, akpm@linux-foundation.org,
	paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
	pjt@google.com, vincent.guittot@linaro.org,
	Preeti U Murthy <preeti@linux.vnet.ibm.com>
References: <1355127754-8444-1-git-send-email-alex.shi@intel.com>
 <CAGjg+kGAokK0oOAOJL=apkcyi_deqtHHsaJCViCz9tOMKG56bw@mail.gmail.com>
 <50C722AC.3080806@intel.com>
 <20121211154819.GC8873@liondog.tnic>
 <50C75935.1040004@linux.intel.com>
 <20121211161320.GA28827@liondog.tnic>
 <50C76208.107@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50C76208.107@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 08:40:40AM -0800, Arjan van de Ven wrote:

> >Let me try to understand what this means: so "performance" above with
> >8 threads means that those threads are spread out across more than one
> >socket, no?
> >
> >If so, this would mean that you have a smaller amount of tasks on each
> >socket, thus the smaller wattage.
> >
> >The "powersaving" method OTOH fills up the one socket up to the brim,
> >thus the slightly higher consumption due to all threads being occupied.
> >
> >Is that it?
>
> not sure.
>
> by and large, power efficiency is the same as performance efficiency,
> with some twists. or to reword that to be more clear if you waste
> performance due to something that becomes inefficient, you're wasting
> power as well. now, you might have some hardware effects that can
> then save you power... but those effects then first need to overcome
> the waste from the performance inefficiency... and that almost never
> happens.
>
> for example, if you have two workloads that each fit barely inside
> the last level cache... it's much more efficient to spread these over
> two sockets... where each has its own full LLC to use. If you'd group
> these together, both would thrash the cache all the time and run
> inefficient --> bad for power.

Hmm, are you saying that powering up the second socket so that the
working set fully fits in the LLC is still less power used than the cost
of going up to memory and bringing those lines back in?

I'd say there's breakeven point depending on the workload duration, no?

Which means that we need to be able to look into the future in order to
know what to do... ;-/

> now, on the other hand, if you have two threads of a process that
> share a bunch of data structures, and you'd spread these over 2
> sockets, you end up bouncing data between the two sockets a lot,
> running inefficient --> bad for power.

Yeah, that should be addressed by the NUMA patches people are working on
right now.

> having said all this, if you have to tasks that don't have such
> cache effects, the most efficient way of running things will be on 2
> hyperthreading halves... it's very hard to beat the power efficiency
> of that. But this assumes the tasks don't compete with resources much
> on the HT level, and achieve good scaling. and this still has to
> compete with "race to halt", because if you're done quicker, you can
> put the memory in self refresh quicker.

Right, how are we addressing the breakeven in that case? AFAIK, we
do schedule them now on two different cores (not HT threads, i.e. no
resource sharing besides L2) so that we get done faster, i.e. race to
idle in the performance case. And in the powersavings' case we leave
them as tightly packed as possible.

> none of this stuff is easy for humans or computer programs to
> determine ahead of time... or sometimes even afterwards. heck, even
> for just performance it's really really hard already, never mind
> adding power.
>
> my personal gut feeling is that we should just optimize this scheduler
> stuff for performance, and that we're going to be doing quite well on
> power already if we achieve that.

Probably. I wonder if there is a way to measure power consumption of
different workloads in perf and then run those with different scheduling
policies.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
