Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053Ab1EDRwj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 13:52:39 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56714 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579Ab1EDRwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 13:52:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RJjkUs9+flBfZ2UeDkkZqq5fXVyTYJQhWZftWIKv3DKcSxyWXvvmrnXKFSoZHe02Ny
         62NnrS0cF/pBdmcDYudwwUuj0XrvUrUNnJ61CG3iXnDfoCNTyX4XCM6T6w6IEiZ7ih0G
         EP4uYQgsYPLG5FhQpSQE24E9WN+7xy2I2Lui8=
Date: Wed, 4 May 2011 19:52:33 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Will Drewry <wad@chromium.org>
Cc: Eric Paris <eparis@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, kees.cook@canonical.com,
        agl@chromium.org, jmorris@namei.org, rostedt@goodmis.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 5/7] seccomp_filter: Document what seccomp_filter is
 and how it works.
Message-ID: <20110504175229.GB1804@nowhere>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimPFHwJfqXHShnOt7mBp84NQQNWDw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 04, 2011 at 02:15:47AM -0700, Will Drewry wrote:
> Okay - so I *think* I'm following.  I really like the use of SET and
> GET to allow for further constraint based on additional argument
> restrictions instead of purely reducing the filters available.  The
> only part I'm stumbling on is using APPLY on a per-filter basis.  In
> my current implementation, I consider APPLY to be the global enable
> bit.  Whatever filters are set become set in stone and only &&s are
> handled.  I'm not sure I understand why it would make sense to do a
> per-syscall-filter apply call.

Nope it's still a global apply..

>  It's certainly doable, but it will
> mean that we may be logically storing something like:
> 
> __NR_foo: (a == 1 || a == 2), applied
> __NR_foo: b == 2, not applied
> __NR_foo: c == 3, not applied
> 
> after
> 
> SECCOMP_FILTER_SET, __NR_foo, "a == 1 || a == 2"
> SECCOMP_FILTER_APPLY
> SECCOMP_FILTER_SET, __NR_foo, "b == 2"
> SECCOMP_FILTER_SET, __NR_foo, "c == 3"

No, the c == 3 would override b == 2.

> In that case, would a call to sys_foo even be tested against the
> non-applied constraints of b==2 or c==3?

No, not as long as it's not applied.

> Or would the call to set "c
> == 3" replace the "b == 2" entry.  I'm not sure I see that the benefit
> exceeds the ambiguity that might introduce.

The rationale behind it is that as long as you haven't applied your filter,
you should be able to override it.

And the simplest way to override it is to do it completely. Remove what
was there before (that wasn't applied).

You could opt for a FILTER_DROP.
Let's take that example:

SECCOMP_FILTER_SET, __NR_foo, "b == 2"
SECCOMP_FILTER_SET, __NR_foo, "c == 3"

Following your logic, we should have "b == 2 && c == 3" after that.
How are you going to remove only the c == 3 sequence?

You would need SECCOMP_FILTER_DROP, __NR_foo, "c == 3"

That said, using a string with a filter expression as an id looks a
bit odd to me. That doesn't work anymore with "((c == 3))", or "c== 3",
unless you compare against the resulting tree but that's complicated.

I mean, that works, most of the time you keep your expression
and pass it as is. But the expression should be identified by its
meaning, not by some random language layout.

That also forces you to scatter your filter representation:

	SECCOMP_FILTER_SET, __NR_foo, "b == 2"
	SECCOMP_FILTER_SET, __NR_foo, "c == 3"

For me this shouldn't be different than

	SECCOMP_FILTER_SET, __NR_foo, "b == 2 && c == 3"

Still nobody will be able to remove a part of the above expression.

So, I'm more for having something that removes everything not applied
than just a part of the non-applied filter.

Two possibilities I see:

	SECCOMP_FILTER_SET, __NR_foo, "b == 2"
	SECCOMP_FILTER_SET, __NR_foo, "c == 3"

	// And result is "c == 3"

Or:

	SECCOMP_FILTER_SET, __NR_foo, "b == 2"
	SECCOMP_FILTER_SET, __NR_foo, "c == 3"

	// And result is "b == 2 && c == 3"

	SECCOMP_FILTER_RESET, __NR_foo //rewind to filter "0"

	SECCOMP_FILTER_SET, __NR_foo, "c == 4"

	// And result is "c == 4"

How does that look?
	


> However, if the default
> behavior it to always extend with &&, then a consumer of the interface
> could just do:
> 
> SECCOMP_FILTER_SET, __NR_prctl, "option == 2"
> SECCOMP_FILTER_SET, __NR_foo, "a == 1 || a == 2"
> SECCOMP_FILTER_SET, __NR_foo, "b == 2"
> SECCOMP_FILTER_APPLY
> 
> This would yield a final filter for foo of "(a == 1 || a == 2) && b ==
> 2".  The call to APPLY would initiate the enforcement of the syscall
> filtering and enforce that no new filters may be added for syscalls
> that aren't already constrained.  So you could still call
> 
> SECCOMP_FILTER_SET, __NR_foo, "0"
> 
> which is logically "((a == 1 || a == 2) && b == 2) && 0" and would be
> interpreted as just a DROP. But you could not do,
> 
> SECCOMP_FILTER_SET, __NR_foo, "0"
> SECCOMP_FILTER_SET, __NR_foo, "1"
> or
> SECCOMP_FILTER_SET, __NR_read, "1"

Why?

"((a == 1 || a == 2) && b == 2) && 0 && 1"

or

"((a == 1 || a == 2) && b == 2) && 1"

does still follow our previous constraints.

> 
> (since the implicit filter for all syscalls after an APPLY call should
> be "0" and additions would just be "0 && whatever").

If the default filter is 0 after apply, setting whatever afterward is
not an issue. You'll have "0 && whatever" which still means 0, that's fine.

> 
> Am I missing something?  If that makes sense, then we may even be able
> to reduce the extra directives by one and get a resulting interface
> that looks something like:
> 
> /* Appends (&&) a new filter string for a syscall to the current
> filter value. "0" clears the filter. */
> prctl(PR_SET_SECCOMP_FILTER, syscall_nr, filter_string);
> /* Returns the current explicit filter string for a syscall */
> prctl(PR_GET_SECCOMP_FILTER, syscall_nr, buf, buflen);

So GET is eventually optional here, as a new filter automatically
append to the previous applied one.

But if a process needs some information about current filter, this
makes sense.

> /* Transition to a secure computing mode:
>  * 1 - enables traditional seccomp behavior
>  * 2 - enables seccomp filter enforcement and changes the implicit
> filter for syscalls from "1" to "0"
>  */
> prctl(PR_SET_SECCOMP, mode);
> 
> I'll set aside the v2 of the patch that uses ADD, DROP, and APPLY and
> work up a version with this interface.  Do you (or anyone else :) feel
> strongly about per-syscall APPLY?

I'm still not sure what you meant by per syscall APPLY :)

> ~~
> 
> As to the use of apply_on_exec, even if you whitelist: mmap, fstat64,
> brk, uname, open, read, close, set_thread_area, mprotect, munmap, and
> access _just_ to allow a process to be exec'd, it is still a
> significant reduction in kernel attack surface.  Pairing that with a
> LSM, delayed chroot, etc could fill in the gaps with respect to a
> greater sandboxing solution.  I'd certainly take that tradeoff for
> running binaries that I don't control the source for :)  That said,
> LD_PRELOAD, ptrace injection, and other tricks could allow for the
> injection of a very targeted filterset, but I don't think that
> invalidates the on-exec case given the brittleness relying exclusively
> on such tactics.  Does that seem reasonable?

Right. But then, does a default enable_on_exec behaviour really matches your
needs? Given your description, it seems that applying it on the next
fork would work too, as a random example.
