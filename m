Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329Ab1EDSXI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 14:23:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:40670 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab1EDSXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 14:23:06 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=Not3D1qn5yUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=ci3zlr1uPqGmCe5OAlgA:9 a=TTTv0O0PuGD-gmEZk3YA:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
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
In-Reply-To: <20110504175229.GB1804@nowhere>
References: <1303960136-14298-1-git-send-email-wad@chromium.org>
	 <1303960136-14298-4-git-send-email-wad@chromium.org>
	 <20110428070636.GC952@elte.hu>
	 <1304002571.2101.38.camel@localhost.localdomain>
	 <BANLkTi=5NYTM5T2LthVL+8kjQvYWwHSVPg@mail.gmail.com>
	 <20110429131845.GA1768@nowhere>
	 <BANLkTimhWZURqgAXG45=3CG-bNhv+g-Ftg@mail.gmail.com>
	 <20110503012857.GA8399@nowhere>
	 <BANLkTimhugGCnMQ4f2T2HOvwVLrGTREPkg@mail.gmail.com>
	 <BANLkTimPFHwJfqXHShnOt7mBp84NQQNWDw@mail.gmail.com>
	 <20110504175229.GB1804@nowhere>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 04 May 2011 14:23:02 -0400
Message-ID: <1304533382.25414.2447.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-04 at 19:52 +0200, Frederic Weisbecker wrote:

> >  It's certainly doable, but it will
> > mean that we may be logically storing something like:
> > 
> > __NR_foo: (a == 1 || a == 2), applied
> > __NR_foo: b == 2, not applied
> > __NR_foo: c == 3, not applied
> > 
> > after
> > 
> > SECCOMP_FILTER_SET, __NR_foo, "a == 1 || a == 2"
> > SECCOMP_FILTER_APPLY
> > SECCOMP_FILTER_SET, __NR_foo, "b == 2"
> > SECCOMP_FILTER_SET, __NR_foo, "c == 3"
> 
> No, the c == 3 would override b == 2.

I honestly hate the "override" mode. I like that SETs are or'd among
each other and an APPLY is a "commit"; meaning that you can only limit
it further, but can not extend it (an explicit &&)

> 
> > In that case, would a call to sys_foo even be tested against the
> > non-applied constraints of b==2 or c==3?
> 
> No, not as long as it's not applied.
> 
> > Or would the call to set "c
> > == 3" replace the "b == 2" entry.  I'm not sure I see that the benefit
> > exceeds the ambiguity that might introduce.
> 
> The rationale behind it is that as long as you haven't applied your filter,
> you should be able to override it.

We need a "UNSET" (I like that better than DROP).

> 
> And the simplest way to override it is to do it completely. Remove what
> was there before (that wasn't applied).
> 
> You could opt for a FILTER_DROP.
> Let's take that example:
> 
> SECCOMP_FILTER_SET, __NR_foo, "b == 2"
> SECCOMP_FILTER_SET, __NR_foo, "c == 3"
> 
> Following your logic, we should have "b == 2 && c == 3" after that.
> How are you going to remove only the c == 3 sequence?
> 
> You would need SECCOMP_FILTER_DROP, __NR_foo, "c == 3"
> 
> That said, using a string with a filter expression as an id looks a
> bit odd to me. That doesn't work anymore with "((c == 3))", or "c== 3",
> unless you compare against the resulting tree but that's complicated.

Nah, it should be easy. Actually, in "set" mode (before the apply) we
should keep a link list of "trees" of sets. Then we just find the "tree"
that matches the UNSET and remove it.

> 
> I mean, that works, most of the time you keep your expression
> and pass it as is. But the expression should be identified by its
> meaning, not by some random language layout.
> 
> That also forces you to scatter your filter representation:
> 
> 	SECCOMP_FILTER_SET, __NR_foo, "b == 2"
> 	SECCOMP_FILTER_SET, __NR_foo, "c == 3"
> 
> For me this shouldn't be different than
> 
> 	SECCOMP_FILTER_SET, __NR_foo, "b == 2 && c == 3"
> 
> Still nobody will be able to remove a part of the above expression.

Correct, as the sets will be just link lists of sets. Once we apply it,
it goes into the main tree.

Thus, to find the UNSET set, we would evaluate the tree of that unset,
and search for it. If it is found, remove it, otherwise return EINVAL or
something.

> 
> So, I'm more for having something that removes everything not applied
> than just a part of the non-applied filter.
> 
> Two possibilities I see:
> 
> 	SECCOMP_FILTER_SET, __NR_foo, "b == 2"
> 	SECCOMP_FILTER_SET, __NR_foo, "c == 3"
> 
> 	// And result is "c == 3"
> 
> Or:
> 
> 	SECCOMP_FILTER_SET, __NR_foo, "b == 2"
> 	SECCOMP_FILTER_SET, __NR_foo, "c == 3"
> 
> 	// And result is "b == 2 && c == 3"
> 
> 	SECCOMP_FILTER_RESET, __NR_foo //rewind to filter "0"
> 
> 	SECCOMP_FILTER_SET, __NR_foo, "c == 4"
> 
> 	// And result is "c == 4"
> 
> How does that look?

The thing is, I don't understand where we would use (or want) an
override. I could understand a UNSET, which I described in another
reply. Also, I like the fact that sets can be self contained because
then the user can add wrapper functions for them.

add_filter("foo: c == 4");
add_filter("bar: b < 3");
apply_filter();

That wont work with an override, unless we did the work in userspace to
keep string, and then we need to worry about "string matches" as you
stated if we want to implement a remove_filter("foo: c==4"). (see it
would fail, because this version is missing spaces)

-- Steve


