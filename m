Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750868Ab0HOSb0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 14:31:26 -0400
Received: from mail.openrapids.net ([64.15.138.104]:40482 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750795Ab0HOSbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 14:31:25 -0400
Date: Sun, 15 Aug 2010 14:31:21 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Avi Kivity <avi@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
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
Message-ID: <20100815183121.GA6476@Krystal>
References: <20100714231117.GA22341@Krystal> <20100714233843.GD14533@nowhere> <20100715162631.GB30989@Krystal> <1280855904.1923.675.camel@laptop> <AANLkTinydcsYG6wj06bj0++EfiWUMQnZk=QvLQp=S8YB@mail.gmail.com> <1280903273.1923.682.camel@laptop> <1281537273.3058.14.camel@gandalf.stny.rr.com> <4C6816BD.8060101@redhat.com> <20100815164413.GA9990@Krystal> <4C681B03.2050302@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C681B03.2050302@redhat.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 14:14:55 up 204 days, 20:51,  4 users,  load average: 0.05, 0.06,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Avi Kivity (avi@redhat.com) wrote:
>  On 08/15/2010 07:44 PM, Mathieu Desnoyers wrote:
>> * Avi Kivity (avi@redhat.com) wrote:
>>>   On 08/11/2010 05:34 PM, Steven Rostedt wrote:
>>>> So, I want to allocate a 10Meg buffer. I need to make sure the kernel
>>>> has 10megs of memory available. If the memory is quite fragmented, then
>>>> too bad, I lose out.
>>> With memory compaction, the cpu churns for a while, then you have your
>>> buffer.  Of course there's still no guarantee, just a significantly
>>> higher probability of success.
>> The bigger the buffers, the lower the probabilities of success are. My users
>> often allocate buffers as large as a few GB per cpu. Relying on compaction does
>> not seem like a viable solution in this case.
>
> Wow.  Even if you could compact that much memory, it would take quite a  
> bit of time.

Yep.

>
>>>> Oh wait, I could also use vmalloc. But then again, now I'm blasting
>>>> valuable TLB entries for a tracing utility, thus making the tracer have
>>>> a even bigger impact on the entire system.
>>> Most trace entries will occupy much less than a page, and are accessed
>>> sequentially, so I don't think this will have a large impact.
>> You seem to underestimate the frequency at which trace events can be generated.
>> E.g., by the time you run the scheduler once (which we can consider a very hot
>> kernel path), some tracing modes will generate thousands of events, which will
>> touch a very significant amount of TLB entries.
>
> Let's say a trace entry occupies 40 bytes and a TLB miss costs 200  
> cycles on average.  So we have 100 entries per page costing 200 cycles;  
> amortized each entry costs 2 cycles.

A quick test (shown below) gives the cost of a TLB miss on the Intel Xeon E5404:

Number of cycles added over test baseline:

tlb and cache hit:            12.42
tlb hit, l2 hit, l1 miss      17.88
tlb hit,l2+l1 miss            32.34
tlb and cache miss           449.58

So it's closer to 500 per tlb miss.

Also, your analysis does not seem to correctly represent reality of the TLB
trashing cost. On a workload walking over a large number of random pages (e.g. a
large hash table) all the time, eating just a few more TLB entries will impact
the number of misses over the entire workload.

So it's not much the misses that we see at the tracing site that is the problem,
but also the extra misses taken by the application caused by the extra pressure
on TLB. So just a few more TLB entries taken by the tracer will likely hurt
these workloads.

>
> There's an additional cost caused by the need to re-fill the TLB later,  
> but you incur that anyway if the scheduler caused a context switch.

The performance hit is not taken if the scheduler schedules another thread with
the same mapping, only when it schedules a different process.

>
> Of course, my assumptions may be completely off (likely larger entries  
> but smaller miss costs).

Depending on the tracer design, the avg. event size can range from 12 bytes
(lttng is very agressive in event size compaction) to about 40 bytes (perf); so
for this you are mostly right. However, as explained above, the TLB miss cost is
higher than you expected.

>  Has a vmalloc based implementation been  
> tested?  It seems so much easier than the other alternatives.

I tested it in the past, and must admit that I changed from a vmalloc-based
implementation to page-based using software cross-page write primitives based on
feedback from Steven and Ingo. Diminishing TLB trashing seemed like a good
approach, and using vmalloc on 32-bit machines is a pain, because users have to
tweak the vmalloc region size at boot. So all in all, I moved to a vmalloc-less
implementation without much more thought.

If you feel we should test the performance of both approaches, we could do it in
the generic ring buffer library (it allows both type of allocation backends).
However, we'd have to find the right type of TLB-trashing real-world workload to
have meaningful results. This might be the hardest part.

Thanks,

Mathieu

# tlbmiss.c

#include <sys/time.h>
#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>

typedef unsigned long long cycles_t;

#define barrier() __asm__ __volatile__("": : :"memory")

/*
 * Serialize core instruction execution. Also acts as a compiler barrier.
 * On PIC ebx cannot be clobbered
 */
#ifdef __PIC__
#define sync_core()						      \
       asm volatile("push %%ebx; cpuid; pop %%ebx"		       \
		    : : : "memory", "eax", "ecx", "edx");
#endif
#ifndef __PIC__
#define sync_core()						      \
       asm volatile("cpuid" : : : "memory", "eax", "ebx", "ecx", "edx");
#endif

#define mb()	asm volatile("mfence":::"memory")
#define smp_mb()	mb()

#define rdtsc(low,high) \
     __asm__ __volatile__("rdtsc" : "=a" (low), "=d" (high))

#define rdtscl(low) \
     __asm__ __volatile__("rdtsc" : "=a" (low) : : "edx")

#define rdtscll(val) \
     __asm__ __volatile__("rdtsc" : "=A" (val))


#define mb()  asm volatile("mfence":::"memory")

static inline cycles_t get_cycles_sync(void)
{
	unsigned long long ret = 0;

	smp_mb();
	sync_core();
	rdtscll(ret);
	sync_core();
	smp_mb();
	return ret;
}

#define PAGE_SIZE 4096ULL	/* 4k */
#define L1_CACHELINE_SIZE 64
#define L2_CACHELINE_SIZE 128
#define ARRAY_SIZE 262144ULL /* 1 GB */

static char testpage[PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));

static unsigned int idx[ARRAY_SIZE];

#define NR_TESTS 100

int main(int argc, char **argv)
{
	struct timeval tv;
	struct timezone tz;
	cycles_t time1, time2;
	double cycles_per_iter;
	unsigned int i, j;
	pid_t pid;
	char *array;
	double baseline;

	printf("number of tests : %lu\n", NR_TESTS);

	srandom(get_cycles_sync());

	array = malloc(sizeof(char) * ARRAY_SIZE * PAGE_SIZE);

	for (i=0; i<ARRAY_SIZE; i++)
		idx[i] = random() % ARRAY_SIZE;

	testpage[0] = 1;

	printf("Nothing (baseline)\n");
	cycles_per_iter = 0.0;
	for (i=0; i<NR_TESTS; i++) {
		for (j=0; j<ARRAY_SIZE; j++)
			array[idx[j] * PAGE_SIZE] = 1;
		testpage[0] = 1;
		time1 = get_cycles_sync();
		time2 = get_cycles_sync();
		cycles_per_iter += (time2 - time1);
	}
	cycles_per_iter /= (double)NR_TESTS;

	baseline = (double) cycles_per_iter;
	printf("Baseline takes %g cycles\n", baseline);

	printf("TLB and caches hit\n");
	cycles_per_iter = 0.0;
	for (i=0; i<NR_TESTS; i++) {
		for (j=0; j<ARRAY_SIZE; j++)
			array[idx[j] * PAGE_SIZE] = 1;
		testpage[0] = 1;
		time1 = get_cycles_sync();
		testpage[0] = 1;
		time2 = get_cycles_sync();
		cycles_per_iter += (time2 - time1);
	}
	cycles_per_iter /= (double)NR_TESTS;

	printf("tlb and cache hit %g cycles (adds %g)\n",
					(double) cycles_per_iter,
					(double) cycles_per_iter - baseline);

	printf("TLB hit, l2 cache hit, l1 cache miss\n");
	cycles_per_iter = 0.0;
	for (i=0; i<NR_TESTS; i++) {
		for (j=0; j<ARRAY_SIZE; j++)
			array[idx[j] * PAGE_SIZE] = 1;
		testpage[0] = 1;
		time1 = get_cycles_sync();
		testpage[L1_CACHELINE_SIZE] = 1;
		time2 = get_cycles_sync();
		cycles_per_iter += (time2 - time1);
	}
	cycles_per_iter /= (double)NR_TESTS;

	printf("tlb hit, l2 hit, l1 miss %g cycles (adds %g)\n",
					(double) cycles_per_iter,
					(double) cycles_per_iter - baseline);

	printf("TLB hit, l2 cache miss, l1 cache miss\n");
	cycles_per_iter = 0.0;
	for (i=0; i<NR_TESTS; i++) {
		for (j=0; j<ARRAY_SIZE; j++)
			array[idx[j] * PAGE_SIZE] = 1;
		testpage[0] = 1;
		time1 = get_cycles_sync();
		testpage[L2_CACHELINE_SIZE] = 1;
		time2 = get_cycles_sync();
		cycles_per_iter += (time2 - time1);
	}
	cycles_per_iter /= (double)NR_TESTS;

	printf("tlb hit,l2+l1 miss %g cycles (adds %g)\n",
					(double) cycles_per_iter,
					(double) cycles_per_iter - baseline);

	printf("TLB and cache miss\n");
	cycles_per_iter = 0.0;
	for (i=0; i<NR_TESTS; i++) {
		for (j=0; j<ARRAY_SIZE; j++)
			array[idx[j] * PAGE_SIZE] = 1;
		time1 = get_cycles_sync();
		testpage[0] = 1;
		time2 = get_cycles_sync();
		cycles_per_iter += (time2 - time1);
	}
	cycles_per_iter /= (double)NR_TESTS;

	printf("tlb and cache miss %g cycles (adds %g)\n",
					(double) cycles_per_iter,
					(double) cycles_per_iter - baseline);
	free(array);

	return 0;
}

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
