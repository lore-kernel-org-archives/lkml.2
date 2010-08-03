Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932468Ab0HCTCa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 15:02:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38566 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757556Ab0HCTC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 15:02:28 -0400
MIME-Version: 1.0
In-Reply-To: <1280855904.1923.675.camel@laptop>
References: <AANLkTinLB3gQNKFk9QRfBS8YEfxL3qxZDFw7vWHDOnmL@mail.gmail.com> 
	<20100714184642.GA9728@elte.hu> <AANLkTil2r3sUcoCC_ktp3TV2JNTSMxbpke8yJMx_8lmm@mail.gmail.com> 
	<20100714193652.GA13630@nowhere> <AANLkTilD4aYej_36lOCEvMNCdYc4jBIupi5-77oD9vD2@mail.gmail.com> 
	<20100714221418.GA14533@nowhere> <20100714223107.GA2350@Krystal> 
	<20100714224853.GC14533@nowhere> <20100714231117.GA22341@Krystal> 
	<20100714233843.GD14533@nowhere> <20100715162631.GB30989@Krystal> 
	<1280855904.1923.675.camel@laptop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 3 Aug 2010 11:56:11 -0700
Message-ID: <AANLkTinydcsYG6wj06bj0++EfiWUMQnZk=QvLQp=S8YB@mail.gmail.com>
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Steven Rostedt <rostedt@rostedt.homelinux.com>,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 3, 2010 at 10:18 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> FWIW I really utterly detest the whole concept of sub-buffers.

I'm not quite sure why. Is it something fundamental, or just an
implementation issue?

One thing that I think could easily make sense in a _lot_ of buffering
areas is the notion of a "continuation" buffer. We know we have cases
where we want to attach a lot of data to one particular event, but the
buffering itself is inevitably always going to have some limits on
atomicity etc. And quite often, the event that _generates_ the data is
not necessarily going to have all that data in one contiguous region,
and doing a scatter-gather memcpy to get it that way is not good
either.

At the same time, I do _not_ believe that the kernel ring-buffer code
should handle pointers to sub-buffers etc, or worry about iovec-like
arrays of smaller ranges. So if _that_ is what you mean by "concept of
sub-buffers", then I agree with you.

But what I do think might make a lot of sense is to allow buffer
fragments, and just teach user space to do de-fragmentation. Where it
would be important that the de-fragmentation really is all in user
space, and not really ever visible to the ring-buffer implementation
itself (and there would not, for example, be any guarantees that the
fragments would be contiguous - there could be other events in the
buffer in between fragments).  Maybe we could even say that fragments
might be across different CPU ring-buffers, and user-space needs to
sort it out if it wants to (where "sort it out" literally would mean
having to sort and re-attach them in the right order, since there
wouldn't be any ordering between them).

>From a kernel perspective, the only thing you need for fragment
handling would be to have a buffer entry that just says "I'm fragment
number X of event ID Y". Nothing more. Everything else would be up to
the parser in user space to work out.

In other words - if you have something like the current situation,
where you want to save a whole back-trace, INSTEAD of allocating a
large max-sized buffer for it and "linearizing" the back-trace in
order to then create a backtrace ring event, maybe we could just fill
the ring buffer with lots of small fragments, and do the whole
linearizing in the code that reads it in user space. No temporary
allocations in kernel space at all, no memcpy, let user space sort it
out. Each stack level would just add its own event, and increment the
fragment count it uses.

It's going to be a fairly rare case, so some user space parsers might
just decide to ignore fragmented packets, because they know they
aren't interested in such "complex" events.

I dunno. This thread has kind of devolved into many different details,
and I reacted to just one very small fragment of it. Maybe not even a
very interesting fragment.

               Linus
