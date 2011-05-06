Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207Ab1EFLx3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 07:53:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:53544 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab1EFLx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 07:53:27 -0400
X-Authority-Analysis: v=1.1 cv=ZtuXOl23UuD1yoJUTgnZ6i6Z5VPlPhPMWCeUNtN8OGA= c=1 sm=0 a=Not3D1qn5yUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=siikddU-Ll2xhr7IKbQA:9 a=gkpJSY3_r8wCo2W3Yt8A:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 5/7] seccomp_filter: Document what seccomp_filter is
 and how it works.
From: Steven Rostedt <rostedt@goodmis.org>
To: Will Drewry <wad@chromium.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Eric Paris <eparis@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        kees.cook@canonical.com, agl@chromium.org, jmorris@namei.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <BANLkTin2ZS8DCLGZXxV7EN+S-aNRK=B8Sw@mail.gmail.com>
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
	 <1304534785.25414.2452.camel@gandalf.stny.rr.com>
	 <BANLkTin2ZS8DCLGZXxV7EN+S-aNRK=B8Sw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 06 May 2011 07:53:23 -0400
Message-ID: <1304682803.25414.2520.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-05 at 02:21 -0700, Will Drewry wrote:

> In particular, if the userspace code wants to stage some filters and
> apply them all at once, when ready, I'm not sure that it makes sense
> to me to put that complexity in the kernel itself.  For instance,
> Eric's second sample showed a call that took an array of ints and
> coalesced them into "fd == %d || ...".  That simple example shows that
> we could easily get by with a pretty minimal kernel-supported
> interface as long as the richer behavior could live userspace side --
> even if just in a simple helper library.  It'd be pretty easy to
> implement a userspace library that exposed add_filter(syscall_nr,
> filter) and apply_filters() such that it could manage building the
> final filter string for a given syscall and pushing it to prctl on
> apply.

I'm fine with a single kernel call and the "temporary filter" be done in
userspace. Making the kernel code less complex is better :)

> 
> I think that could also help simplify the primitives.  For instance,
> if any separate SET called on a system call resulting in an &&
> operation, then the behavior could be consistent prior to enforcement
> of the filtering and after.  E.g.,
>   SET, __NR_read, "fd == 1"
>   SET, __NR_read, "len < 4097"
> would result in an evaluated "fd == 1 && len < 4097".  It would do so
> after a single APPLY call too:
>   SET, __NR_read, "1"
>   APPLY
>   SET, __NR_read, "fd == 1"
>   SET, __NR_read, "len < 4097"
> Results in: "1 && fd == 1 && len < 4097", and SET, nr, "0" would
> nullify the syscall filter in total.

Only that that was not applied? We can't let tasks nullify their
restrictions once they have been applied. This keeps the kernel code
simpler.

>   It seems like that would be
> enough to build the SET-SET-...-APPLY, SET-SET-...-SET-APPLY logic
> into a userspace library so that all temporary unapplied state doesn't
> have to be explicitly managed by the kernel.

Thus, the SETs are done in the userspace library that does not need to
interact with the kernel (besides perhaps allocating memory). Then the
apply would send all the filters to the kernel which would restrict the
task (or the task on exec) further.

> 
> While I completely agree with the comment around ease-of-use as being
> key to security, I also find that the more the state diagram explodes,
> the harder it is to feel confident that a solution is actually secure.
>  To try to achieve both objectives, I'd like to limit the kernel
> interface to the bare minimum of primitives and build any API
> fanciness into userspace.

Fair enough.

> 
> Does it seem that the tradeoff isn't worth it, or are there some
> specific behaviors that aren't addressed using that model?
> 
> While writing that, another option occurred to me that touches on the
> other proposals but makes the behaviors much more explicit.
> A prctl prototype could be provided:
>  prctl(<SET|GET>, <AND|OR>, <syscall_nr>, <filter string>)
> e.g.,
>  prctl(PR_SET_SECCOMP_FILTER, PR_SECCOMP_FILTER_OR, __NR_read, "fd == 2");
> 
> The explicit prctl argument list would allow the filter strings to be
> self-referential and allow the userspace app to decide what behaviors
> are allowed and when. If we followed that route, all implicit filters
> would be "0" and the initial call to get things started might be:
>    #define SET 33
>    #define OR 0
>    #define AND 1
>    SET, OR, __NR_prctl, "option == 33 && (arg1 == 0 || arg1 == 1)"
>    prctl(PR_SET_SECCOMP, 2);
> 
> So now the "locked down" binary can call prctl to set an OR or AND
> filter for any syscall.  A subsequent call could change that:
>   SET, OR, __NR_read, "fd == 2"  /* => "0 || fd == 2" */
>   SET, AND, __NR_prctl, "(arg2 != 63 || arg1 != 0)"  /* __NR_read == 63 */
> 
> This would OR in a __NR_read filter, then disallow a future call to
> prctl to OR in more NR_read filters, but for other syscalls ANDing and
> ORing is still possible until you pass in something like:
> 
>   SET, AND, __NR_prctl, "arg1 == 1"
> 
> which would lock down all future prctl calls to only ANDing filters
> in.  (The numbers in the examples could then be properly managed in a
> userspace library to ensure platform correctness.)

I don't know about this. It seems to be starting to get too complex, and
thus error prone. Is there any reason we should allow an OR to the task?
Why would we want to restrict a task where the task could easily
unrestrict itself?

> 
> While this would reduce the primitives a bit further, I'm not sure if
> this would be the right approach either, but it would open the door to
> pushing even more down to userspace very explicitly and further
> removing magic policy logic from the kernel-side.  Is this vaguely
> interesting or just another layer of confusing-ness?

I'm confused, thus I must have hit that layer ;)

-- Steve


