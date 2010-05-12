Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925Ab0ELStL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 14:49:11 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60782 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755162Ab0ELStI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 14:49:08 -0400
Subject: Re: Perf and ftrace [was Re: PyTimechart]
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Pierre Tardy <tardyp@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org, arjan@infradead.org,
       ziga.mahkovec@gmail.com, davem <davem@davemloft.net>
In-Reply-To: <20100512183704.GD21432@Krystal>
References: <20100512144811.GA5405@nowhere>
	 <1273678596.27703.30.camel@gandalf.stny.rr.com>
	 <20100512164650.GH5405@nowhere> <1273683624.1626.127.camel@laptop>
	 <20100512170734.GA15953@Krystal> <1273686425.1626.142.camel@laptop>
	 <20100512175305.GB32496@Krystal> <1273687212.1626.147.camel@laptop>
	 <20100512180438.GE15953@Krystal> <1273687712.1626.151.camel@laptop>
	 <20100512183704.GD21432@Krystal>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 May 2010 20:49:02 +0200
Message-ID: <1273690142.1626.158.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-12 at 14:37 -0400, Mathieu Desnoyers wrote:
> * Peter Zijlstra (peterz@infradead.org) wrote:
> > On Wed, 2010-05-12 at 14:04 -0400, Mathieu Desnoyers wrote:
> > > Can't we keep multiple references to each page ? (shared page) so it's still in
> > > the buffer, also accessed by mmap(), and in addition accessed by splice.
> > 
> > I'm not sure, the problem seems to be that a splice-consumer might want
> > to inject the page into a whole different address-space, over-writing
> > page->mapping/->index etc.
> 
> OK, I see. In LTTng, I dropped the mmap() support when I integrated splice(). In
> both case, I can share the pages between the "output" (mmap or splice) and the
> ring buffer because my ring buffer does not care about
> page->mapping/->index/etc, so I never have to swap them.
> 
> However, doing mmap() and splice() at the same time on the same pages seems
> problematic for the reason you point out here (and not very useful anyway).
> But I think restrictions could be done more transparently than what you propose,
> e.g.:
> 
> 1) create buffer -> return fd
>    (perform pfn alignment for the architecture worse-case, e.g. support mmap()
>     on sparc)
> 
> 2a) mmap(fd)
>     return -EBUSY if any of the pages has non-NULL mapping.
> 3a) munmap(fd)
> 
> 2b) splice(fd)
>     return -EBUSY if any of the pages has non-NULL mapping.
> 
> 2c) read(fd)
>     Could probably be done concurrently with splice() or mmap().
> 
> This way we would ensure that only mmap or splice is used on the buffer at a
> given time without crippling the API.
> 
> Thoughts ?

Right, so the problem is that we now use mmap() to size the buffer. I
guess we could go adding a size attribute to perf_event_attr, but I
think its makes more sense to separate the actual event and the output
buffer objects.

