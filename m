Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932861Ab0HDOGL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 10:06:11 -0400
Received: from mail.openrapids.net ([64.15.138.104]:55448 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932823Ab0HDOGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 10:06:09 -0400
Date: Wed, 4 Aug 2010 10:06:05 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Peter Zijlstra <peterz@infradead.org>
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
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
Message-ID: <20100804140605.GA29371@Krystal>
References: <AANLkTilD4aYej_36lOCEvMNCdYc4jBIupi5-77oD9vD2@mail.gmail.com> <20100714221418.GA14533@nowhere> <20100714223107.GA2350@Krystal> <20100714224853.GC14533@nowhere> <20100714231117.GA22341@Krystal> <20100714233843.GD14533@nowhere> <20100715162631.GB30989@Krystal> <1280855904.1923.675.camel@laptop> <AANLkTinydcsYG6wj06bj0++EfiWUMQnZk=QvLQp=S8YB@mail.gmail.com> <1280903273.1923.682.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280903273.1923.682.camel@laptop>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 09:47:48 up 193 days, 16:24,  5 users,  load average: 0.11, 0.10,
	0.03
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Tue, 2010-08-03 at 11:56 -0700, Linus Torvalds wrote:
> > On Tue, Aug 3, 2010 at 10:18 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > >
> > > FWIW I really utterly detest the whole concept of sub-buffers.
> > 
> > I'm not quite sure why. Is it something fundamental, or just an
> > implementation issue?
> 
> The sub-buffer thing that both ftrace and lttng have is creating a large
> buffer from a lot of small buffers, I simply don't see the point of
> doing that. It adds complexity and limitations for very little gain.

The first major gain is the ability to implement flight recorder tracing
(overwrite mode), which Perf still lacks.

A second major gain: having these sub-buffers lets the trace analyzer seek in
the trace very efficiently by allowing it to perform a binary search for time to
find the appropriate sub-buffer. It becomes immensely useful with large traces.

The third major gain: for live streaming of traces, having sub-buffer lets you
"package" the event data you send over the network into sub-buffers. So the
trace analyzer, receiving this information live while the trace is being
recorded, can start using the information when the full sub-buffer is received.
It does not have to play games with the last event (or event header) perhaps
being incompletely sent, which imply that you absolutely _need_ to save the
event size along with each event header (you cannot simply let the analyzer
parse the event payload to determine the size). Here again, space wasted.
Furthermore, this deals with information loss: a trace is still readable even if
a sub-buffer must be discarded.

Making sure events don't cross sub-buffer boundaries simplify a lot of things,
starting with dealing with "overwritten" sub-buffers in flight recorder mode.
Trying to deal with a partially overwritten event is just insane.

> 
> Their benefit is known synchronization points into the stream, you can
> parse each sub-buffer independently, but you can always break up a
> continuous stream into smaller parts or use a transport that includes
> index points or whatever.

I understand that you could perform amortized synchronization without
sub-buffers. I however don't see how flight recorder, efficient seek on multi-GB
traces (without reading the whole event stream), and live streaming can be
achieved.

> Their down side is that you can never have individual events larger than
> the sub-buffer,

True. But with configurable sub-buffer size (can be from 4kB to many MB), I
don't see the problem.

>                 you need to be aware of the sub-buffer when reserving
> space

Only the ring buffer needs to be aware of that. It returns an error if the event
is larger than the sub-buffer size.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
