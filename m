Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550Ab1BPNYu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 08:24:50 -0500
Received: from blu0-omc1-s13.blu0.hotmail.com ([65.55.116.24]:14865 "EHLO
	blu0-omc1-s13.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751067Ab1BPNYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 08:24:47 -0500
X-Originating-IP: [174.91.193.52]
X-Originating-Email: [pdumas9@sympatico.ca]
Message-ID: <BLU0-SMTP5EDE1BB3410CC9856693096D20@phx.gbl>
Date: Wed, 16 Feb 2011 08:24:38 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Will Newton <will.newton@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Will Simoneau <simoneau@ele.uri.edu>,
        David Miller <davem@davemloft.net>, hpa@zytor.com,
        matt@console-pimps.org, peterz@infradead.org, jbaron@redhat.com,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, sam@ravnborg.org,
        ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org, vapier@gentoo.org, cmetcalf@tilera.com,
        dhowells@redhat.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        benh@kernel.crashing.org
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
References: <4D59B891.8010300@zytor.com> <AANLkTimp9xKbZdDZpONrxDkfMSAiQre0v=SOsJUnnoWA@mail.gmail.com> <20110215211123.GA3094@ele.uri.edu> <20110215.132702.39199169.davem@davemloft.net> <20110215215604.GA3177@ele.uri.edu> <AANLkTikXy+AJ3tdEkEN--xJPefbXJ4-OVS3cg6R7yXzc@mail.gmail.com> <1297858734.23343.138.camel@gandalf.stny.rr.com> <AANLkTinzr6rb=WwFs7QApsvdy5f7PHZ1qS9ZVrncEzZD@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <AANLkTinzr6rb=WwFs7QApsvdy5f7PHZ1qS9ZVrncEzZD@mail.gmail.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 08:09:27 up 314 days, 22:59,  6 users,  load average: 1.28, 1.56,
	1.56
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 16 Feb 2011 13:24:46.0450 (UTC) FILETIME=[E12CCD20:01CBCDDC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Will Newton (will.newton@gmail.com) wrote:
> On Wed, Feb 16, 2011 at 12:18 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > On Wed, 2011-02-16 at 10:15 +0000, Will Newton wrote:
> >
> >> > That's some really crippled hardware... it does seem like *any* loads
> >> > from *any* address updated by an sc would have to be done with ll as
> >> > well, else they may load stale values. One could work this into
> >> > atomic_read(), but surely there are other places that are problems.
> >>
> >> I think it's actually ok, atomics have arch implemented accessors, as
> >> do spinlocks and atomic bitops. Those are the only place we do sc so
> >> we can make sure we always ll or invalidate manually.
> >
> > I'm curious, how is cmpxchg() implemented on this architecture? As there
> > are several places in the kernel that uses this on regular variables
> > without any "accessor" functions.
> 
> We can invalidate the cache manually. The current cpu will see the new
> value (post-cache invalidate) and the other cpus will see either the
> old value or the new value depending on whether they read before or
> after the invalidate, which is racy but I don't think it is
> problematic. Unless I'm missing something...

Assuming the invalidate is specific to a cache-line, I'm concerned about
the failure of a scenario like the following:

initially:
foo = 0
bar = 0

CPU A                            CPU B

xchg(&foo, 1);
  ll foo
  sc foo

  -> interrupt

  if (foo == 1)
    xchg(&bar, 1);
      ll bar
      sc bar
      invalidate bar

                                 lbar = bar;
                                 smp_mb()
                                 lfoo = foo;
                                 BUG_ON(lbar == 1 && lfoo == 0);
  invalidate foo

It should be valid to expect that every time "bar" read by CPU B is 1,
then "foo" is always worth 1. However, in this case, the lack of
invalidate on foo is keeping the cacheline from reaching CPU B. There
seems to be a problem with interrupts/NMIs coming right between sc and
invalidate, as Ingo pointed out.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
