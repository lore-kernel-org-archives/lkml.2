Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033Ab1LUOdN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 09:33:13 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43548 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752973Ab1LUOdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 09:33:11 -0500
Date: Wed, 21 Dec 2011 14:15:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Vince Weaver <vweaver1@eecs.utk.edu>, William Cohen <wcohen@redhat.com>,
        Stephane Eranian <eranian@google.com>, Arun Sharma <asharma@fb.com>,
        Vince Weaver <vince@deater.net>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 0/6] perf: x86 RDPMC and RDTSC support
Message-ID: <20111221131511.GA31186@elte.hu>
References: <20111121145114.049265181@chello.nl>
 <alpine.DEB.2.00.1112161731570.6060@cl320.eecs.utk.edu>
 <1324472337.10752.11.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1324472337.10752.11.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> > I used the mmap_read_self() routine from your example as the 
> > "read" performance that I measured.
> 
> Yeah that's about it, if you want to discard the overload 
> scenario, eg you use pinned counters or so, you can optimize 
> it further by stripping out the tsc and scaling muck.

With the TSC scaling muck it a bit above 50 cycles here.

Without that, by optimizing it further for pinned counters, the 
overhead of mmap_read_self() gets down to 36 cycles on a Nehalem 
box.

A PEBS profile run of it shows that 90% of the overhead is in 
the RDPMC instruction:

    2.92 :          42a919:       lea    -0x1(%rax),%ecx                                          ▒
         :                                                                                        ▒
         :        static u64 rdpmc(unsigned int counter)                                          ▒
         :        {                                                                               ▒
         :                unsigned int low, high;                                                 ▒
         :                                                                                        ▒
         :                asm volatile("rdpmc" : "=a" (low), "=d" (high) : "c" (counter));        ▒
   89.20 :          42a91c:       rdpmc                                                           ▒
         :                        count = pc->offset;                                             ▒
         :                        if (idx)                                                        ▒
         :                                count += rdpmc(idx - 1);                                ▒
         :                                                                                        ▒

So the RDPMC instruction alone is 32 cycles. The perf way of 
reading it adds another 4 cycles to it.

So the measured 'perf overhead' is so ridiculously low that it's 
virtually non-existent.

Here's "pinned events" variant i've measured:

static u64 mmap_read_self(void *addr)
{
        struct perf_event_mmap_page *pc = addr;
        u32 seq, idx;
        u64 count;

        do {
                seq = pc->lock;
                barrier();

                idx = pc->index;
                count = pc->offset;
                if (idx)
                        count += rdpmc(idx - 1);

                barrier();
        } while (pc->lock != seq);

        return count;
}

Thanks,

	Ingo
