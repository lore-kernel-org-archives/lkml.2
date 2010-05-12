Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab0ELSvO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 14:51:14 -0400
Received: from mail.openrapids.net ([64.15.138.104]:44485 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755189Ab0ELSvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 14:51:13 -0400
Date: Wed, 12 May 2010 14:51:11 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Pierre Tardy <tardyp@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org, arjan@infradead.org,
       ziga.mahkovec@gmail.com, davem <davem@davemloft.net>
Subject: Re: Perf and ftrace [was Re: PyTimechart]
Message-ID: <20100512185111.GH21432@Krystal>
References: <20100512164650.GH5405@nowhere> <1273683624.1626.127.camel@laptop> <20100512170734.GA15953@Krystal> <1273686425.1626.142.camel@laptop> <20100512175305.GB32496@Krystal> <1273687212.1626.147.camel@laptop> <20100512180438.GE15953@Krystal> <1273687712.1626.151.camel@laptop> <20100512183704.GD21432@Krystal> <1273690142.1626.158.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273690142.1626.158.camel@laptop>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 14:50:18 up 109 days, 21:27,  9 users,  load average: 0.28, 0.23,
	0.19
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Wed, 2010-05-12 at 14:37 -0400, Mathieu Desnoyers wrote:
> > * Peter Zijlstra (peterz@infradead.org) wrote:
> > > On Wed, 2010-05-12 at 14:04 -0400, Mathieu Desnoyers wrote:
> > > > Can't we keep multiple references to each page ? (shared page) so it's still in
> > > > the buffer, also accessed by mmap(), and in addition accessed by splice.
> > > 
> > > I'm not sure, the problem seems to be that a splice-consumer might want
> > > to inject the page into a whole different address-space, over-writing
> > > page->mapping/->index etc.
> > 
> > OK, I see. In LTTng, I dropped the mmap() support when I integrated splice(). In
> > both case, I can share the pages between the "output" (mmap or splice) and the
> > ring buffer because my ring buffer does not care about
> > page->mapping/->index/etc, so I never have to swap them.
> > 
> > However, doing mmap() and splice() at the same time on the same pages seems
> > problematic for the reason you point out here (and not very useful anyway).
> > But I think restrictions could be done more transparently than what you propose,
> > e.g.:
> > 
> > 1) create buffer -> return fd
> >    (perform pfn alignment for the architecture worse-case, e.g. support mmap()
> >     on sparc)
> > 
> > 2a) mmap(fd)
> >     return -EBUSY if any of the pages has non-NULL mapping.
> > 3a) munmap(fd)
> > 
> > 2b) splice(fd)
> >     return -EBUSY if any of the pages has non-NULL mapping.
> > 
> > 2c) read(fd)
> >     Could probably be done concurrently with splice() or mmap().
> > 
> > This way we would ensure that only mmap or splice is used on the buffer at a
> > given time without crippling the API.
> > 
> > Thoughts ?
> 
> Right, so the problem is that we now use mmap() to size the buffer. I
> guess we could go adding a size attribute to perf_event_attr, but I
> think its makes more sense to separate the actual event and the output
> buffer objects.

It makes it hard to use splice() or read() if you don't specify the buffer size
at creation time. That alone seems like a pretty good argument for fixing the
size before the mmap() call.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
