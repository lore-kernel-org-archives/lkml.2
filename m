Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932456Ab0HCRTa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 13:19:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43860 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757229Ab0HCRT2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 13:19:28 -0400
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
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
In-Reply-To: <20100715162631.GB30989@Krystal>
References: <AANLkTinLB3gQNKFk9QRfBS8YEfxL3qxZDFw7vWHDOnmL@mail.gmail.com>
	 <20100714184642.GA9728@elte.hu>
	 <AANLkTil2r3sUcoCC_ktp3TV2JNTSMxbpke8yJMx_8lmm@mail.gmail.com>
	 <20100714193652.GA13630@nowhere>
	 <AANLkTilD4aYej_36lOCEvMNCdYc4jBIupi5-77oD9vD2@mail.gmail.com>
	 <20100714221418.GA14533@nowhere> <20100714223107.GA2350@Krystal>
	 <20100714224853.GC14533@nowhere> <20100714231117.GA22341@Krystal>
	 <20100714233843.GD14533@nowhere>  <20100715162631.GB30989@Krystal>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 03 Aug 2010 19:18:24 +0200
Message-ID: <1280855904.1923.675.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-15 at 12:26 -0400, Mathieu Desnoyers wrote:

> I was more thinking along the lines of making sure a ring buffer has the proper
> support for your use-case. It shares a lot of requirements with a standard ring
> buffer:
> 
> - Need to be lock-less
> - Need to reserve space, write data in a buffer
> 
> By configuring a ring buffer with 4k sub-buffer size (that's configurable
> dynamically), 

FWIW I really utterly detest the whole concept of sub-buffers.

> all we need to add is the ability to squash a previously saved
> record from the buffer. I am confident we can provide a clean API for this that
> would allow discard of previously committed entry as long as we are still on the
> same non-fully-committed sub-buffer. This fits your use-case exactly, so that's
> fine.

squash? truncate you mean? So we can allocate/reserve the largest
possible event size and write the actual event and then truncate to the
actually used size?

I really dislike how that will end up with huge holes in the buffer when
you get nested events.

Also, I think you're forgetting that doing the stack unwind is a very
costly pointer chase, adding a simple linear copy really doesn't seem
like a problem.

Additionally, if you have multiple consumers you can simply copy the
stacktrace again, avoiding the whole pointer chase exercise. While you
could conceivably copy from one ringbuffer into another that will result
in very nasty serialization issues.

> You could have one 4k ring buffer per cpu per execution context. 

Why?

>  I wonder if
> each Linux architecture have support for separated thread vs softirtq vs irq vs
> nmi stacks ? 

Why would that be relevant? We can have NMI inside IRQ inside soft-IRQ
inside task context in general (dismissing the nested IRQ mess). You
don't need to have a separate stack for each context in order to nest
them.

> Even then, given you have only one stack for all shared irqs, you
> need something that is concurrency-aware at the ring buffer level.

I'm failing to see you point. 

> These small stack-like ring buffers could be used to save your temporary stack
> copy. When you really need to save it to a larger ring buffer along with a
> trace, then you just take a snapshot of the stack ring buffers.

OK, why? Your proposal includes the exact same extra copy but introduces
a ton of extra code to effect the same, not a win.

> So you get to use one single ring buffer synchronization and memory allocation
> mechanism, that everyone has reviewed. The advantage is that we would not be
> having this nmi race discussion in the first place: the generic ring buffer uses
> "get page" directly rather than relying on vmalloc, because these bugs have
> already been identified and dealt with years ago.

That's like saying don't use percpu_alloc() but open-code the thing
using kmalloc()/get_pages().. I really don't see any merit in that.


