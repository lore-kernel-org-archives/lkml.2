Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932988Ab0HOQoR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 12:44:17 -0400
Received: from mail.openrapids.net ([64.15.138.104]:50376 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932582Ab0HOQoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 12:44:16 -0400
Date: Sun, 15 Aug 2010 12:44:14 -0400
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
Message-ID: <20100815164413.GA9990@Krystal>
References: <20100714223107.GA2350@Krystal> <20100714224853.GC14533@nowhere> <20100714231117.GA22341@Krystal> <20100714233843.GD14533@nowhere> <20100715162631.GB30989@Krystal> <1280855904.1923.675.camel@laptop> <AANLkTinydcsYG6wj06bj0++EfiWUMQnZk=QvLQp=S8YB@mail.gmail.com> <1280903273.1923.682.camel@laptop> <1281537273.3058.14.camel@gandalf.stny.rr.com> <4C6816BD.8060101@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C6816BD.8060101@redhat.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 12:37:39 up 204 days, 19:14,  3 users,  load average: 0.02, 0.03,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Avi Kivity (avi@redhat.com) wrote:
>  On 08/11/2010 05:34 PM, Steven Rostedt wrote:
>>
>> So, I want to allocate a 10Meg buffer. I need to make sure the kernel
>> has 10megs of memory available. If the memory is quite fragmented, then
>> too bad, I lose out.
>
> With memory compaction, the cpu churns for a while, then you have your  
> buffer.  Of course there's still no guarantee, just a significantly  
> higher probability of success.

The bigger the buffers, the lower the probabilities of success are. My users
often allocate buffers as large as a few GB per cpu. Relying on compaction does
not seem like a viable solution in this case.

>
>> Oh wait, I could also use vmalloc. But then again, now I'm blasting
>> valuable TLB entries for a tracing utility, thus making the tracer have
>> a even bigger impact on the entire system.
>
> Most trace entries will occupy much less than a page, and are accessed  
> sequentially, so I don't think this will have a large impact.

You seem to underestimate the frequency at which trace events can be generated.
E.g., by the time you run the scheduler once (which we can consider a very hot
kernel path), some tracing modes will generate thousands of events, which will
touch a very significant amount of TLB entries.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
