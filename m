Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148Ab1EEJVK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 05:21:10 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:34819 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab1EEJVI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 05:21:08 -0400
MIME-Version: 1.0
In-Reply-To: <1304534785.25414.2452.camel@gandalf.stny.rr.com>
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
Date: Thu, 5 May 2011 02:21:05 -0700
Message-ID: <BANLkTin2ZS8DCLGZXxV7EN+S-aNRK=B8Sw@mail.gmail.com>
Subject: Re: [PATCH 5/7] seccomp_filter: Document what seccomp_filter is and
 how it works.
From: Will Drewry <wad@chromium.org>
To: Steven Rostedt <rostedt@goodmis.org>
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
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 4, 2011 at 11:46 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Wed, 2011-05-04 at 20:30 +0200, Frederic Weisbecker wrote:
>> On Wed, May 04, 2011 at 02:23:02PM -0400, Steven Rostedt wrote:
>> > On Wed, 2011-05-04 at 19:52 +0200, Frederic Weisbecker wrote:
>> >
>> > > >  It's certainly doable, but it will
>> > > > mean that we may be logically storing something like:
>> > > >
>> > > > __NR_foo: (a == 1 || a == 2), applied
>> > > > __NR_foo: b == 2, not applied
>> > > > __NR_foo: c == 3, not applied
>> > > >
>> > > > after
>> > > >
>> > > > SECCOMP_FILTER_SET, __NR_foo, "a == 1 || a == 2"
>> > > > SECCOMP_FILTER_APPLY
>> > > > SECCOMP_FILTER_SET, __NR_foo, "b == 2"
>> > > > SECCOMP_FILTER_SET, __NR_foo, "c == 3"
>> > >
>> > > No, the c == 3 would override b == 2.
>> >
>> > I honestly hate the "override" mode. I like that SETs are or'd among
>> > each other and an APPLY is a "commit"; meaning that you can only limit
>> > it further, but can not extend it (an explicit &&)
>>
>> I'm confused with what you just said...
>>
>> Somehow I could understand it that way:
>>
>> SECCOMP_FILTER_SET, __NR_foo, "a == 1"
>> SECCOMP_FILTER_SET, __NR_foo, "a == 2"
>> SECCOMP_FILTER_APPLY
>> SECCOMP_FILTER_SET, __NR_foo, "b == 1"
>>
>> Would produce:
>>
>> "(a == 1 || a == 2) && b == 1"
>
> No, it would produce:
>
>  (a == 1 || a == 2)
>
> The b == 1 will not be added until the next apply.
>
>>
>> That makes a pretty confusing behaviour for users I think.
>
>
> Not really, if it is documented well. Or we can call it:
>
> SECCOMP_FILTER_SET_OR and SECCOMP_FILTER_APPLY_AND
>
> to remove the ambiguity. The reason is actually quite simple. Before you
> do an apply, you can modify it to whatever you want. But once you do an
> apply, you just limited yourself. An apply can not be reversed.
>
>>
>> >
>> > >
>> > > > In that case, would a call to sys_foo even be tested against the
>> > > > non-applied constraints of b==2 or c==3?
>> > >
>> > > No, not as long as it's not applied.
>> > >
>> > > > Or would the call to set "c
>> > > > == 3" replace the "b == 2" entry.  I'm not sure I see that the benefit
>> > > > exceeds the ambiguity that might introduce.
>> > >
>> > > The rationale behind it is that as long as you haven't applied your filter,
>> > > you should be able to override it.
>> >
>> > We need a "UNSET" (I like that better than DROP).
>>
>> What about a complete erase (RESET) of the temporary filter? Like I explained below
>> from my previous mail.
>
> What is a temporary filter? And a RESET could be there too to just
> remove all sets that are pending.
>
> I was thinking that we add "SETS" which the kernel can verify are
> correct and let the user know at the time of the command if it is valid.
> But these sets are not actually implemented until an APPLY is hit.
>

The past few mails have proposed quite a few interesting variants, but
I wonder if Eric's code samples show something useful about the
not-yet-applied filters in addition to the behavioral differences
between changing implicit operations (&& versus ||).

In particular, if the userspace code wants to stage some filters and
apply them all at once, when ready, I'm not sure that it makes sense
to me to put that complexity in the kernel itself.  For instance,
Eric's second sample showed a call that took an array of ints and
coalesced them into "fd == %d || ...".  That simple example shows that
we could easily get by with a pretty minimal kernel-supported
interface as long as the richer behavior could live userspace side --
even if just in a simple helper library.  It'd be pretty easy to
implement a userspace library that exposed add_filter(syscall_nr,
filter) and apply_filters() such that it could manage building the
final filter string for a given syscall and pushing it to prctl on
apply.

I think that could also help simplify the primitives.  For instance,
if any separate SET called on a system call resulting in an &&
operation, then the behavior could be consistent prior to enforcement
of the filtering and after.  E.g.,
  SET, __NR_read, "fd == 1"
  SET, __NR_read, "len < 4097"
would result in an evaluated "fd == 1 && len < 4097".  It would do so
after a single APPLY call too:
  SET, __NR_read, "1"
  APPLY
  SET, __NR_read, "fd == 1"
  SET, __NR_read, "len < 4097"
Results in: "1 && fd == 1 && len < 4097", and SET, nr, "0" would
nullify the syscall filter in total.  It seems like that would be
enough to build the SET-SET-...-APPLY, SET-SET-...-SET-APPLY logic
into a userspace library so that all temporary unapplied state doesn't
have to be explicitly managed by the kernel.

While I completely agree with the comment around ease-of-use as being
key to security, I also find that the more the state diagram explodes,
the harder it is to feel confident that a solution is actually secure.
 To try to achieve both objectives, I'd like to limit the kernel
interface to the bare minimum of primitives and build any API
fanciness into userspace.

Does it seem that the tradeoff isn't worth it, or are there some
specific behaviors that aren't addressed using that model?

While writing that, another option occurred to me that touches on the
other proposals but makes the behaviors much more explicit.
A prctl prototype could be provided:
 prctl(<SET|GET>, <AND|OR>, <syscall_nr>, <filter string>)
e.g.,
 prctl(PR_SET_SECCOMP_FILTER, PR_SECCOMP_FILTER_OR, __NR_read, "fd == 2");

The explicit prctl argument list would allow the filter strings to be
self-referential and allow the userspace app to decide what behaviors
are allowed and when. If we followed that route, all implicit filters
would be "0" and the initial call to get things started might be:
   #define SET 33
   #define OR 0
   #define AND 1
   SET, OR, __NR_prctl, "option == 33 && (arg1 == 0 || arg1 == 1)"
   prctl(PR_SET_SECCOMP, 2);

So now the "locked down" binary can call prctl to set an OR or AND
filter for any syscall.  A subsequent call could change that:
  SET, OR, __NR_read, "fd == 2"  /* => "0 || fd == 2" */
  SET, AND, __NR_prctl, "(arg2 != 63 || arg1 != 0)"  /* __NR_read == 63 */

This would OR in a __NR_read filter, then disallow a future call to
prctl to OR in more NR_read filters, but for other syscalls ANDing and
ORing is still possible until you pass in something like:

  SET, AND, __NR_prctl, "arg1 == 1"

which would lock down all future prctl calls to only ANDing filters
in.  (The numbers in the examples could then be properly managed in a
userspace library to ensure platform correctness.)

While this would reduce the primitives a bit further, I'm not sure if
this would be the right approach either, but it would open the door to
pushing even more down to userspace very explicitly and further
removing magic policy logic from the kernel-side.  Is this vaguely
interesting or just another layer of confusing-ness?


I'll follow Eric's lead and try out a few different interfaces
proposed earlier and the ones I laid out above and see if it seems to
come out any clearer (for me at least).  I'd love to know if anyone
else thinks we can get away with less primitives and put more of the
complex/delayed logic in userspace exclusively.

thanks!
will
