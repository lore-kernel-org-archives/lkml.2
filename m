Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892Ab1EWCiz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 22:38:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:54800 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754602Ab1EWCiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 22:38:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,254,1304319600"; 
   d="scan'208";a="2800934"
Message-ID: <4DD9C8B9.5070004@intel.com>
Date: Mon, 23 May 2011 10:38:49 +0800
From: Huang Ying <ying.huang@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110402 Iceowl/1.0b2 Icedove/3.1.9
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: huang ying <huang.ying.caritas@gmail.com>, Len Brown <lenb@kernel.org>,
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
References: <1305619719-7480-1-git-send-email-ying.huang@intel.com> <1305619719-7480-6-git-send-email-ying.huang@intel.com> <20110517084622.GE22093@elte.hu> <4DD23750.3030606@intel.com> <20110517092620.GI22093@elte.hu> <4DD31C78.6000209@intel.com> <20110520115614.GH14745@elte.hu> <BANLkTi=5Y0fqsmhsoPm8si=nQBc-tCwtrw@mail.gmail.com> <20110522100021.GA28177@elte.hu> <BANLkTi=VDQMOfWe5tP7nXSv2AEsiUUEteg@mail.gmail.com> <20110522132515.GA13078@elte.hu>
In-Reply-To: <20110522132515.GA13078@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2011 09:25 PM, Ingo Molnar wrote:
>>> The generalization that *would* make sense is not at the irq_work level 
>>> really, instead we could generalize a 'struct event' for kernel internal 
>>> producers and consumers of events that have no explicit PMU connection.
>>>
>>> This new 'struct event' would be slimmer and would only contain the fields 
>>> and features that generic event consumers and producers need. Tracing 
>>> events could be updated to use these kinds of slimmer events.
>>>
>>> It would still plug nicely into existing event ABIs, would work with event 
>>> filters, etc. so the tooling side would remain focused and unified.
>>>
>>> Something like that. It is rather clear by now that splitting out irq_work 
>>> was a mistake. But mistakes can be fixed and some really nice code could 
>>> come out of it! Would you be interested in looking into this?
>>
>> Yes.  This can transfer hardware error data from kernel to user space. Then, 
>> how to do hardware error recovering in this big picture?  IMHO, we will need 
>> to call something like memory_failure_queue() in IRQ context for memory 
>> error.
> 
> That's where 'active filters' come into the picture - see my other mail (that 
> was in the context of unidentified NMI errors/events) where i outlined how they 
> would work in this case and elsewhere. Via active filters we could share most 
> of the code, gain access to the events and still have kernel driven policy 
> action.

Is that something as follow?

- NMI handler run for the hardware error, where hardware error
information is collected and put into perf ring buffer as 'event'.

- Some 'active filters' are run for each 'event' in NMI context.

- Some operations can not be done in NMI handler, so they are delayed to
an IRQ handler (can be done with something like irq_work).

- Some other 'active filters' are run for each 'event' in IRQ context.
(For memory error, we can call memory_failure_queue() here).

Where some 'active filters' are kernel built-in, some 'active filters'
can be customized via kernel command line or by user space.


If my understanding as above is correct, I think this is a general and
complex solution.  It is a little hard for user to understand which
'active filters' are in effect.  He may need some runtime assistant to
understand the code (maybe /sys/events/active_filters, which list all
filters in effect now), because that is hard only by reading the source
code.  Anyway, this is a design style choice.

There are still some issues, I don't know how to solve in above framework.

- If there are two processes request the same type of hardware error
events.  One hardware error event will be copied to two ring buffers
(each for one process),  but the 'active filters' should be run only
once for each hardware error event.

- How to deal with ring-buffer overflow?  For example, there is full of
corrected memory error in ring-buffer, and now a recoverable memory
error occurs but it can not be put into perf ring buffer because of
ring-buffer overflow, how to deal with the recoverable memory error?

Best Regards,
Huang Ying
