Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758559Ab0HORKf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 13:10:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48721 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758090Ab0HORKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 13:10:34 -0400
Message-ID: <4C681B03.2050302@redhat.com>
Date: Sun, 15 Aug 2010 19:51:15 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Frank Ch. Eigler" <fche@redhat.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
References: <20100714223107.GA2350@Krystal> <20100714224853.GC14533@nowhere> <20100714231117.GA22341@Krystal> <20100714233843.GD14533@nowhere> <20100715162631.GB30989@Krystal> <1280855904.1923.675.camel@laptop> <AANLkTinydcsYG6wj06bj0++EfiWUMQnZk=QvLQp=S8YB@mail.gmail.com> <1280903273.1923.682.camel@laptop> <1281537273.3058.14.camel@gandalf.stny.rr.com> <4C6816BD.8060101@redhat.com> <20100815164413.GA9990@Krystal>
In-Reply-To: <20100815164413.GA9990@Krystal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 08/15/2010 07:44 PM, Mathieu Desnoyers wrote:
> * Avi Kivity (avi@redhat.com) wrote:
>>   On 08/11/2010 05:34 PM, Steven Rostedt wrote:
>>> So, I want to allocate a 10Meg buffer. I need to make sure the kernel
>>> has 10megs of memory available. If the memory is quite fragmented, then
>>> too bad, I lose out.
>> With memory compaction, the cpu churns for a while, then you have your
>> buffer.  Of course there's still no guarantee, just a significantly
>> higher probability of success.
> The bigger the buffers, the lower the probabilities of success are. My users
> often allocate buffers as large as a few GB per cpu. Relying on compaction does
> not seem like a viable solution in this case.

Wow.  Even if you could compact that much memory, it would take quite a 
bit of time.

>>> Oh wait, I could also use vmalloc. But then again, now I'm blasting
>>> valuable TLB entries for a tracing utility, thus making the tracer have
>>> a even bigger impact on the entire system.
>> Most trace entries will occupy much less than a page, and are accessed
>> sequentially, so I don't think this will have a large impact.
> You seem to underestimate the frequency at which trace events can be generated.
> E.g., by the time you run the scheduler once (which we can consider a very hot
> kernel path), some tracing modes will generate thousands of events, which will
> touch a very significant amount of TLB entries.

Let's say a trace entry occupies 40 bytes and a TLB miss costs 200 
cycles on average.  So we have 100 entries per page costing 200 cycles; 
amortized each entry costs 2 cycles.

There's an additional cost caused by the need to re-fill the TLB later, 
but you incur that anyway if the scheduler caused a context switch.

Of course, my assumptions may be completely off (likely larger entries 
but smaller miss costs).  Has a vmalloc based implementation been 
tested?  It seems so much easier than the other alternatives.

-- 
error compiling committee.c: too many arguments to function

