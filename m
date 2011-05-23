Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab1EWLCP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 07:02:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46546 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752229Ab1EWLCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 07:02:11 -0400
Date: Mon, 23 May 2011 13:01:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Huang Ying <ying.huang@intel.com>
Cc: huang ying <huang.ying.caritas@gmail.com>, Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        "Wu, Fengguang" <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 5/9] HWPoison: add memory_failure_queue()
Message-ID: <20110523110151.GD24674@elte.hu>
References: <20110517084622.GE22093@elte.hu>
 <4DD23750.3030606@intel.com>
 <20110517092620.GI22093@elte.hu>
 <4DD31C78.6000209@intel.com>
 <20110520115614.GH14745@elte.hu>
 <BANLkTi=5Y0fqsmhsoPm8si=nQBc-tCwtrw@mail.gmail.com>
 <20110522100021.GA28177@elte.hu>
 <BANLkTi=VDQMOfWe5tP7nXSv2AEsiUUEteg@mail.gmail.com>
 <20110522132515.GA13078@elte.hu>
 <4DD9C8B9.5070004@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DD9C8B9.5070004@intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Huang Ying <ying.huang@intel.com> wrote:

> > That's where 'active filters' come into the picture - see my other mail 
> > (that was in the context of unidentified NMI errors/events) where i 
> > outlined how they would work in this case and elsewhere. Via active filters 
> > we could share most of the code, gain access to the events and still have 
> > kernel driven policy action.
> 
> Is that something as follow?
> 
> - NMI handler run for the hardware error, where hardware error
>   information is collected and put into perf ring buffer as 'event'.

Correct.

Note that for MCE errors we want the 'persistent event' framework Boris has 
posted: we want these events to be buffered up to a point even if there is no 
tool listening in on them:

 - this gives us boot-time MCE error coverage

 - this protects us against a logging daemon being restarted and events
   getting lost

> - Some 'active filters' are run for each 'event' in NMI context.

Yeah. Whether it's a human-ASCII space 'filter' or really just a callback you 
register with that event is secondary - both would work.

> - Some operations can not be done in NMI handler, so they are delayed to
>   an IRQ handler (can be done with something like irq_work).

Yes.

> - Some other 'active filters' are run for each 'event' in IRQ context.
>   (For memory error, we can call memory_failure_queue() here).

Correct.

> Where some 'active filters' are kernel built-in, some 'active filters' can be 
> customized via kernel command line or by user space.

Yes.

> If my understanding as above is correct, I think this is a general and 
> complex solution.  It is a little hard for user to understand which 'active 
> filters' are in effect.  He may need some runtime assistant to understand the 
> code (maybe /sys/events/active_filters, which list all filters in effect 
> now), because that is hard only by reading the source code.  Anyway, this is 
> a design style choice.

I don't think it's complex: the built-in rules are in plain sight (can be in 
the source code or can even be explicitly registered callbacks), the 
configuration/tooling installed rules will be as complex as the admin or tool 
wants them to be.

> There are still some issues, I don't know how to solve in above framework.
> 
> - If there are two processes request the same type of hardware error
>   events.  One hardware error event will be copied to two ring buffers (each 
>   for one process), but the 'active filters' should be run only once for each 
>   hardware error event.

With persistent events 'active filters' should only be attached to the central 
persistent event.

> - How to deal with ring-buffer overflow?  For example, there is full of 
>   corrected memory error in ring-buffer, and now a recoverable memory error 
>   occurs but it can not be put into perf ring buffer because of ring-buffer 
>   overflow, how to deal with the recoverable memory error?

The solution is to make it large enough. With *every* queueing solution there 
will be some sort of queue size limit.

Thanks,

	Ingo
