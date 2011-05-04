Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab1EDSq2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 14:46:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:54367 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327Ab1EDSq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 14:46:27 -0400
X-Authority-Analysis: v=1.1 cv=qyUSAyc82z9xLljZQc9ErY9Tl2GSEfqK/XYZS35I9d8= c=1 sm=0 a=Not3D1qn5yUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=6UWUY8tF8GMePTEpHHMA:9 a=z6tEBe75lkVbQhc-WvsA:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 5/7] seccomp_filter: Document what seccomp_filter is
 and how it works.
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Will Drewry <wad@chromium.org>, Eric Paris <eparis@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        kees.cook@canonical.com, agl@chromium.org, jmorris@namei.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20110504183052.GD1804@nowhere>
References: <20110428070636.GC952@elte.hu>
	 <1304002571.2101.38.camel@localhost.localdomain>
	 <BANLkTi=5NYTM5T2LthVL+8kjQvYWwHSVPg@mail.gmail.com>
	 <20110429131845.GA1768@nowhere>
	 <BANLkTimhWZURqgAXG45=3CG-bNhv+g-Ftg@mail.gmail.com>
	 <20110503012857.GA8399@nowhere>
	 <BANLkTimhugGCnMQ4f2T2HOvwVLrGTREPkg@mail.gmail.com>
	 <BANLkTimPFHwJfqXHShnOt7mBp84NQQNWDw@mail.gmail.com>
	 <20110504175229.GB1804@nowhere>
	 <1304533382.25414.2447.camel@gandalf.stny.rr.com>
	 <20110504183052.GD1804@nowhere>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 04 May 2011 14:46:25 -0400
Message-ID: <1304534785.25414.2452.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-04 at 20:30 +0200, Frederic Weisbecker wrote:
> On Wed, May 04, 2011 at 02:23:02PM -0400, Steven Rostedt wrote:
> > On Wed, 2011-05-04 at 19:52 +0200, Frederic Weisbecker wrote:
> > 
> > > >  It's certainly doable, but it will
> > > > mean that we may be logically storing something like:
> > > > 
> > > > __NR_foo: (a == 1 || a == 2), applied
> > > > __NR_foo: b == 2, not applied
> > > > __NR_foo: c == 3, not applied
> > > > 
> > > > after
> > > > 
> > > > SECCOMP_FILTER_SET, __NR_foo, "a == 1 || a == 2"
> > > > SECCOMP_FILTER_APPLY
> > > > SECCOMP_FILTER_SET, __NR_foo, "b == 2"
> > > > SECCOMP_FILTER_SET, __NR_foo, "c == 3"
> > > 
> > > No, the c == 3 would override b == 2.
> > 
> > I honestly hate the "override" mode. I like that SETs are or'd among
> > each other and an APPLY is a "commit"; meaning that you can only limit
> > it further, but can not extend it (an explicit &&)
> 
> I'm confused with what you just said...
> 
> Somehow I could understand it that way:
> 
> SECCOMP_FILTER_SET, __NR_foo, "a == 1"
> SECCOMP_FILTER_SET, __NR_foo, "a == 2"
> SECCOMP_FILTER_APPLY
> SECCOMP_FILTER_SET, __NR_foo, "b == 1"
> 
> Would produce:
> 
> "(a == 1 || a == 2) && b == 1"

No, it would produce:

 (a == 1 || a == 2)

The b == 1 will not be added until the next apply.

> 
> That makes a pretty confusing behaviour for users I think.


Not really, if it is documented well. Or we can call it:

SECCOMP_FILTER_SET_OR and SECCOMP_FILTER_APPLY_AND

to remove the ambiguity. The reason is actually quite simple. Before you
do an apply, you can modify it to whatever you want. But once you do an
apply, you just limited yourself. An apply can not be reversed.

> 
> > 
> > > 
> > > > In that case, would a call to sys_foo even be tested against the
> > > > non-applied constraints of b==2 or c==3?
> > > 
> > > No, not as long as it's not applied.
> > > 
> > > > Or would the call to set "c
> > > > == 3" replace the "b == 2" entry.  I'm not sure I see that the benefit
> > > > exceeds the ambiguity that might introduce.
> > > 
> > > The rationale behind it is that as long as you haven't applied your filter,
> > > you should be able to override it.
> > 
> > We need a "UNSET" (I like that better than DROP).
> 
> What about a complete erase (RESET) of the temporary filter? Like I explained below
> from my previous mail.

What is a temporary filter? And a RESET could be there too to just
remove all sets that are pending.

I was thinking that we add "SETS" which the kernel can verify are
correct and let the user know at the time of the command if it is valid.
But these sets are not actually implemented until an APPLY is hit.

-- Steve


