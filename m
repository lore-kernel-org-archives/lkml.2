Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424Ab0HPKuB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 06:50:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5908 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287Ab0HPKuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 06:50:00 -0400
Message-ID: <4C6917A2.8070508@redhat.com>
Date: Mon, 16 Aug 2010 13:49:06 +0300
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
References: <20100714231117.GA22341@Krystal> <20100714233843.GD14533@nowhere> <20100715162631.GB30989@Krystal> <1280855904.1923.675.camel@laptop> <AANLkTinydcsYG6wj06bj0++EfiWUMQnZk=QvLQp=S8YB@mail.gmail.com> <1280903273.1923.682.camel@laptop> <1281537273.3058.14.camel@gandalf.stny.rr.com> <4C6816BD.8060101@redhat.com> <20100815164413.GA9990@Krystal> <4C681B03.2050302@redhat.com> <20100815183121.GA6476@Krystal>
In-Reply-To: <20100815183121.GA6476@Krystal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 08/15/2010 09:31 PM, Mathieu Desnoyers wrote:
>>>
>>> You seem to underestimate the frequency at which trace events can be generated.
>>> E.g., by the time you run the scheduler once (which we can consider a very hot
>>> kernel path), some tracing modes will generate thousands of events, which will
>>> touch a very significant amount of TLB entries.
>> Let's say a trace entry occupies 40 bytes and a TLB miss costs 200
>> cycles on average.  So we have 100 entries per page costing 200 cycles;
>> amortized each entry costs 2 cycles.
> A quick test (shown below) gives the cost of a TLB miss on the Intel Xeon E5404:
>
> Number of cycles added over test baseline:
>
> tlb and cache hit:            12.42
> tlb hit, l2 hit, l1 miss      17.88
> tlb hit,l2+l1 miss            32.34
> tlb and cache miss           449.58
>
> So it's closer to 500 per tlb miss.

The cache miss would not be avoided if the TLB was hit, so it should not 
be accounted as part of the costs (though a TLB miss will increase cache 
pressure).  Also, your test does not allow the cpu to pipeline anything; 
in reality, different workloads have different TLB miss costs:

- random reads (pointer chasing) incur almost the full impact since the 
processor is stalled
- sequential writes can be completely pipelined and suffer almost no impact

Even taking your numbers, it's still 5 cycles per trace entry.


> Also, your analysis does not seem to correctly represent reality of the TLB
> trashing cost. On a workload walking over a large number of random pages (e.g. a
> large hash table) all the time, eating just a few more TLB entries will impact
> the number of misses over the entire workload.

Let's say this doubles the impact.  So 10 cycles per trace entry.  Will 
a non-vmap solution cost less?


> So it's not much the misses that we see at the tracing site that is the problem,
> but also the extra misses taken by the application caused by the extra pressure
> on TLB. So just a few more TLB entries taken by the tracer will likely hurt
> these workloads.
>

I really think this should be benchmarked.

If the user workload thrashes the TLB, it should use huge pages itself, 
that will make it immune from kernel TLB thrashing and give it a nice 
boost besides.


>> There's an additional cost caused by the need to re-fill the TLB later,
>> but you incur that anyway if the scheduler caused a context switch.
> The performance hit is not taken if the scheduler schedules another thread with
> the same mapping, only when it schedules a different process.

True.

>> Of course, my assumptions may be completely off (likely larger entries
>> but smaller miss costs).
> Depending on the tracer design, the avg. event size can range from 12 bytes
> (lttng is very agressive in event size compaction) to about 40 bytes (perf); so
> for this you are mostly right. However, as explained above, the TLB miss cost is
> higher than you expected.

For the vmalloc area hit, it's lower.  For the user application, it may 
indeed be higher.

>>   Has a vmalloc based implementation been
>> tested?  It seems so much easier than the other alternatives.
> I tested it in the past, and must admit that I changed from a vmalloc-based
> implementation to page-based using software cross-page write primitives based on
> feedback from Steven and Ingo. Diminishing TLB trashing seemed like a good
> approach, and using vmalloc on 32-bit machines is a pain, because users have to
> tweak the vmalloc region size at boot. So all in all, I moved to a vmalloc-less
> implementation without much more thought.
>
> If you feel we should test the performance of both approaches, we could do it in
> the generic ring buffer library (it allows both type of allocation backends).
> However, we'd have to find the right type of TLB-trashing real-world workload to
> have meaningful results. This might be the hardest part.

specJBB is a well known TLB intensive workload, known to benefit greatly 
from large pages.

<snip test>

For a similar test see http://people.redhat.com/akivity/largepage.c.


-- 
error compiling committee.c: too many arguments to function

