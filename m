Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491Ab1BQQN7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 11:13:59 -0500
Received: from blu0-omc1-s25.blu0.hotmail.com ([65.55.116.36]:5989 "EHLO
	blu0-omc1-s25.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752493Ab1BQQNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 11:13:54 -0500
X-Originating-IP: [174.91.193.52]
X-Originating-Email: [pdumas9@sympatico.ca]
Message-ID: <BLU0-SMTP5778CCCE5F4ABA371FFDC796D50@phx.gbl>
Date: Thu, 17 Feb 2011 11:13:47 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
CC: Will Newton <will.newton@gmail.com>, Will Simoneau <simoneau@ele.uri.edu>,
        David Miller <davem@davemloft.net>, hpa@zytor.com,
        matt@console-pimps.org, peterz@infradead.org, jbaron@redhat.com,
        mingo@elte.hu, tglx@linutronix.de, roland@redhat.com, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org, vapier@gentoo.org, cmetcalf@tilera.com,
        dhowells@redhat.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        benh@kernel.crashing.org
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
References: <4D59B891.8010300@zytor.com> <AANLkTimp9xKbZdDZpONrxDkfMSAiQre0v=SOsJUnnoWA@mail.gmail.com> <20110215211123.GA3094@ele.uri.edu> <20110215.132702.39199169.davem@davemloft.net> <20110215215604.GA3177@ele.uri.edu> <AANLkTikXy+AJ3tdEkEN--xJPefbXJ4-OVS3cg6R7yXzc@mail.gmail.com> <1297858734.23343.138.camel@gandalf.stny.rr.com> <AANLkTinzr6rb=WwFs7QApsvdy5f7PHZ1qS9ZVrncEzZD@mail.gmail.com> <BLU0-SMTP71BCB155CBAE79997EE08D96D20@phx.gbl> <1297913774.23343.905.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1297913774.23343.905.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 11:05:04 up 316 days,  1:54,  6 users,  load average: 2.06, 1.81,
	1.65
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 17 Feb 2011 16:13:52.0984 (UTC) FILETIME=[AB64C580:01CBCEBD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> [ Removed Andi as I believe this is the mysterious thread he was talking
> about. Anyone else want to be removed? ]
> 
> 
> On Wed, 2011-02-16 at 08:24 -0500, Mathieu Desnoyers wrote:
> > * Will Newton (will.newton@gmail.com) wrote:
> 
> > initially:
> > foo = 0
> > bar = 0
> > 
> > CPU A                            CPU B
> > 
> > xchg(&foo, 1);
> >   ll foo
> >   sc foo
> > 
> >   -> interrupt
> > 
> >   if (foo == 1)
> >     xchg(&bar, 1);
> >       ll bar
> >       sc bar
> >       invalidate bar
> > 
> >                                  lbar = bar;
> >                                  smp_mb()
> 
> Question: Does a mb() flush all cache or does it just make sure that
> read/write operations finish before starting new ones?

AFAIK, the Linux kernel memory model semantic only cares about coherent
caches (I'd be interested to learn if I am wrong here). Therefore,
smp_mb() affects ordering of data memory read/writes only, not cache
invalidation -- _however_, it apply only in a memory model where the
underlying accesses are performed on coherent caches.

> 
> >                                  lfoo = foo;
> 
> IOW, will that smp_mb() really make lfoo read the new foo in memory? If
> foo happens to still be in cache and no coherency has been performed to
> flush it, would it just simply read foo straight from the cache?

If we were to deploy the Linux kernel on an architecture without
coherent caches, I think smp_mb() should imply a cacheline invalidation,
otherwise we completely mess up the order of data writes vs their
observability from each invididual core POV.

This is what I do in liburcu actually. I introduced a "smp_mc() (mc for
memory commit)" macro to specify that cache invalidation is required on
non-cache-coherent archs. smp_mb() imply a smp_mc(). (smp_mc() is
therefore weaker than smp_mb(), because the mb imply ordering of memory
operations performed by a given core, while smp_mc only ensures that
the core caches are synchronized with memory)

Thanks,

Mathieu

> 
> -- Steve
> 
> >                                  BUG_ON(lbar == 1 && lfoo == 0);
> >   invalidate foo
> > 
> > It should be valid to expect that every time "bar" read by CPU B is 1,
> > then "foo" is always worth 1. However, in this case, the lack of
> > invalidate on foo is keeping the cacheline from reaching CPU B. There
> > seems to be a problem with interrupts/NMIs coming right between sc and
> > invalidate, as Ingo pointed out.
> > 
> > Thanks,
> > 
> > Mathieu
> > 
> 
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
