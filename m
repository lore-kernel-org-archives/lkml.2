Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613Ab2BGIdO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 03:33:14 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43989 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754411Ab2BGIdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 03:33:13 -0500
Date: Tue, 7 Feb 2012 09:32:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Venki Pallipadi <venki@google.com>
Cc: Borislav Petkov <bp@amd64.org>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        acme@redhat.com, robert.richter@amd.com, eric.dumazet@gmail.com,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [BUG] perf: perf sched warning possibly due to clock granularity
 on AMD
Message-ID: <20120207083253.GC12821@elte.hu>
References: <20120206132546.GA30854@quad>
 <1328538403.2482.4.camel@laptop>
 <20120206153408.GA31237@aftab>
 <1328546246.2482.10.camel@laptop>
 <20120206164626.GA31704@aftab>
 <1328547259.2482.11.camel@laptop>
 <20120206202722.GA556@aftab>
 <1328560293.2482.24.camel@laptop>
 <20120206203738.GB556@aftab>
 <CABeCy1ZH_BQhoSegeyBnY0XkjL9afm5=onKrmt9SApufCWgs3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABeCy1ZH_BQhoSegeyBnY0XkjL9afm5=onKrmt9SApufCWgs3A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Venki Pallipadi <venki@google.com> wrote:

> On Mon, Feb 6, 2012 at 12:37 PM, Borislav Petkov <bp@amd64.org> wrote:
> > On Mon, Feb 06, 2012 at 09:31:33PM +0100, Peter Zijlstra wrote:
> >> On Mon, 2012-02-06 at 21:27 +0100, Borislav Petkov wrote:
> >> > On Mon, Feb 06, 2012 at 05:54:19PM +0100, Peter Zijlstra wrote:
> >> > > On Mon, 2012-02-06 at 17:46 +0100, Borislav Petkov wrote:
> >> > > > > across all CPUs in the entire system.
> >> > > >
> >> > > > Right, by the "entire system" you mean consistent across cores and
> >> > > > sockets but not necessarily across cabinets, as in the comment above,
> >> > > > correct?
> >> > > >
> >> > > > If so, let me ask around if this holds true too.
> >> > >
> >> > > Every CPU available to the kernel. So if you run a single system image
> >> > > across your cabinets, then yes those too.
> >> >
> >> > Ok, but what about that sentence "(but not across cabinets - we turn
> >> > it off in that case explicitly.)" - I don't see any place where it is
> >> > turned off explicitly... Maybe a stale comment?
> >>
> >> I suspect it might be the sched_clock_stable = 0 in mark_tsc_unstable(),
> >> but lets ask Venki, IIRC he wrote all that.
> >
> > Yeah, I was looking at the code further and on Intel it does:
> >
> >        if (c->x86_power & (1 << 8)) {
> >                set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
> >                set_cpu_cap(c, X86_FEATURE_NONSTOP_TSC);
> >                if (!check_tsc_unstable())
> >                        sched_clock_stable = 1;
> >        }
> >
> > while on AMD, in early_init_amd() we do:
> >
> >        if (c->x86_power & (1 << 8)) {
> >                set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
> >                set_cpu_cap(c, X86_FEATURE_NONSTOP_TSC);
> >        }
> >
> > and having in mind that tsc_unstable is set on generic x86 paths,
> > nothing stops us to do the same on AMD too, and as a result, set
> > sched_clock_stable too.
> >
> > But yeah, let's see what Venki has to say first.
> >
> 
> Looks like cabinet comment came from Ingo (commit 83ce4009) in 
> reference to
>     (We will turn this off in DMI quirks for multi-chassis 
>     systems)
> 
> Yes. If these two flags are set, TSC should be consistent and 
> sched_clock_stable could be set and it will be reset if there 
> is a call to mark_tsc_unstable().

Most of the details swapped out from my brain meanwhile, but I 
have some vague memories of a DMI quirk for some high-end system 
that just did a sched_clock_stable = 0 or such.

So if the common case is that the TSC is entirely synchronized 
across CPUs, then we can default to that and rely on platform 
initialization code or DMI quirks setting the few large-NUMA 
systems to an unstable TSC.

Thanks,

	Ingo
