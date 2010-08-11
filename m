Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212Ab0HKOek (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 10:34:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:47845 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900Ab0HKOej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 10:34:39 -0400
X-Authority-Analysis: v=1.1 cv=puNM1lMKksHKE6hmMqMstpyRmqXf+M/teYaxpNq+S3U= c=1 sm=0 a=ZI5MULQygNwA:10 a=Q9fys5e9bTEA:10 a=IXo+6rlC6z1XzBFn1RNpIA==:17 a=JfrnYn6hAAAA:8 a=Vy4FboG_WeEbehAfOJQA:9 a=PjkqfWS4DmHlp_U8SkatsCugp4sA:4 a=PUjeQqilurYA:10 a=3Rfx1nUSh_UA:10 a=IXo+6rlC6z1XzBFn1RNpIA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.87.39
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
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
In-Reply-To: <1280903273.1923.682.camel@laptop>
References: <AANLkTinLB3gQNKFk9QRfBS8YEfxL3qxZDFw7vWHDOnmL@mail.gmail.com>
	 <20100714184642.GA9728@elte.hu>
	 <AANLkTil2r3sUcoCC_ktp3TV2JNTSMxbpke8yJMx_8lmm@mail.gmail.com>
	 <20100714193652.GA13630@nowhere>
	 <AANLkTilD4aYej_36lOCEvMNCdYc4jBIupi5-77oD9vD2@mail.gmail.com>
	 <20100714221418.GA14533@nowhere> <20100714223107.GA2350@Krystal>
	 <20100714224853.GC14533@nowhere> <20100714231117.GA22341@Krystal>
	 <20100714233843.GD14533@nowhere> <20100715162631.GB30989@Krystal>
	 <1280855904.1923.675.camel@laptop>
	 <AANLkTinydcsYG6wj06bj0++EfiWUMQnZk=QvLQp=S8YB@mail.gmail.com>
	 <1280903273.1923.682.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 11 Aug 2010 10:34:33 -0400
Message-ID: <1281537273.3058.14.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Egad! Go on vacation and the world falls apart.

On Wed, 2010-08-04 at 08:27 +0200, Peter Zijlstra wrote:
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

So, I want to allocate a 10Meg buffer. I need to make sure the kernel
has 10megs of memory available. If the memory is quite fragmented, then
too bad, I lose out.

Oh wait, I could also use vmalloc. But then again, now I'm blasting
valuable TLB entries for a tracing utility, thus making the tracer have
a even bigger impact on the entire system.

BAH!

I originally wanted to go with the continuous buffer, but I was
convinced after trying to implement it, that it was a bad choice.
Specifically, because of needing to 1) get large amounts of memory that
is continuous, or 2) eating up TLB entries and causing the system to
perform poorer.

I chose page size "sub-buffers" to solve the above. It also made
implementing splice trivial. OK, I admit, I never thought about mmapping
the buffers, just because I figured splice was faster. But I do have
patches that allow a user to mmap the entire ring buffer, but only in a
"producer/consumer" mode.

Note, I use page size sub-buffers, but the design could work with any
size sub-buffers. I just never implemented that (even though, when I
wrote the code it was secretly on my todo list).


> 
> Their benefit is known synchronization points into the stream, you can
> parse each sub-buffer independently, but you can always break up a
> continuous stream into smaller parts or use a transport that includes
> index points or whatever.
> 
> Their down side is that you can never have individual events larger than
> the sub-buffer, you need to be aware of the sub-buffer when reserving
> space etc..

The answer to that is to make a macro to do the assignment of the event,
and add a new API.

	event = ring_buffer_reserve_unlimited();

	ring_buffer_assign(event, data1);
	ring_buffer_assign(event, data2);

	ring_buffer_commit(event);

The ring_buffer_reserve_unlimited() could reserve a bunch of space
beyond one ring buffer. It could reserve data in fragments. Then the
ring_buffer_assgin() could either copy directly to the event (if the
event exists on one sub buffer) or do a copy the space was fragmented.

Of course, userspace would need to know how to read it. And it can get
complex due to interrupts coming in and also reserving between
fragments, or what happens if a partial fragment is overwritten. But all
these are not impossible to solve.

-- Steve



