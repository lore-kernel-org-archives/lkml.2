Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934390Ab0HFKLj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 06:11:39 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48338 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933047Ab0HFKLe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 06:11:34 -0400
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
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
In-Reply-To: <20100806014231.GA496@Krystal>
References: <20100714223107.GA2350@Krystal> <20100714224853.GC14533@nowhere>
	 <20100714231117.GA22341@Krystal> <20100714233843.GD14533@nowhere>
	 <20100715162631.GB30989@Krystal> <1280855904.1923.675.camel@laptop>
	 <AANLkTinydcsYG6wj06bj0++EfiWUMQnZk=QvLQp=S8YB@mail.gmail.com>
	 <1280903273.1923.682.camel@laptop> <20100804140605.GA29371@Krystal>
	 <1280933410.1923.1267.camel@laptop>  <20100806014231.GA496@Krystal>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 06 Aug 2010 12:11:11 +0200
Message-ID: <1281089471.1947.399.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-05 at 21:42 -0400, Mathieu Desnoyers wrote:
> * Peter Zijlstra (peterz@infradead.org) wrote:
> > On Wed, 2010-08-04 at 10:06 -0400, Mathieu Desnoyers wrote:
> > 
> > > The first major gain is the ability to implement flight recorder tracing
> > > (overwrite mode), which Perf still lacks.
> > 
> > http://lkml.org/lkml/2009/7/6/178
> > 
> > I've send out something like that several times, but nobody took it
> > (that is, tested it and provided a user). Note how it doesn't require
> > anything like sub-buffers.

> How is the while condition ever be supposed to be true ? I guess nobody took it
> because it simply was not ready for testing.

I know, I never claimed it was, it was always an illustration of how to
accomplish it. But then, nobody found it important enough to finish.

> > > A second major gain: having these sub-buffers lets the trace analyzer seek in
> > > the trace very efficiently by allowing it to perform a binary search for time to
> > > find the appropriate sub-buffer. It becomes immensely useful with large traces.
> > 
> > You can add sync events with a specific magic cookie in. Once you find
> > the cookie you can sync and start reading it reliably
> 
> You need to read the whole trace to find these cookies (even if it is just once
> at the beginning if you create an index).

Depends on what you want to do, you can start reading at any point in
the stream and be guaranteed to find a sync point within sync-distance
+max-event-size.

>  My experience with users have shown me
> that the delay between stopping trace gathering having the data shown to the
> user is very important, because this is repeatedly done while debugging a
> problem, and this is time the user is sitting in front of his screen, waiting.

Yeah, because after having had to wait for 36h for the problem to
trigger that extra minute really kills.

All I can say is that in my experience brain throughput is the limiting
factor in debugging. Not some ability to draw fancy pictures.

> > -- the advantage
> > is that sync events are very easy to have as an option and don't
> > complicate the reserve path.
> 
> Perf, on its reserve/commit fast paths:
> 
> perf_output_begin: 543 bytes
>   (perf_output_get_handle is inlined)
> 
> perf_output_put_handle: 201 bytes
> perf_output_end:         77 bytes
>   calls perf_output_put_handle
> 
> Total for perf:         821 bytes
> 
> Generic Ring Buffer Library reserve/commit fast paths:
> 
> Reserve:                       511 bytes
> Commit:                        266 bytes
> Total for Generic Ring Buffer: 777 bytes
> 
> So the generic ring buffer is not only faster and supports sub-buffers (along
> with all the nice features this brings); its reserve and commit hot paths
> fit in less instructions: it is *less* complicated than Perf's.

All I can say is that less code doesn't equal less complex (nor faster
per-se). Nor have I spend all my time on writing the ring-buffer,
there's more interesting things to do.

And the last time I ran perf on perf, the buffer wasn't the thing that
was taking most time.

And unlike what you claim below, it most certainly can deal with events
larger than a single page.

> > If you worry about the cost of parsing the events, you can amortize that
> > by things like keeping the offset of the first event in every page in
> > the pageframe, or the offset of the next sync event or whatever scheme
> > you want.
> 
> Hrm ? AFAIK, the page-frame is an internal kernel-only data structure. That
> won't be exported to user-space, so how is the parser supposed to see this
> information exactly to help it speeding up parsing ?

Its about the kernel parsing the buffer to push the tail ahead of the
reserve window, so that you have a reliable point to start reading the
trace from -- or didn't you actually get the intent of that patch?


