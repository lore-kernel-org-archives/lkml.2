Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab1EDJ3Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 05:29:24 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36242 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643Ab1EDJ3U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 05:29:20 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTimPFHwJfqXHShnOt7mBp84NQQNWDw@mail.gmail.com>
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
Date: Wed, 4 May 2011 02:29:19 -0700
Message-ID: <BANLkTimw8g7GomFC1006F+euYt63zjn4+g@mail.gmail.com>
Subject: Re: [PATCH 5/7] seccomp_filter: Document what seccomp_filter is and
 how it works.
From: Will Drewry <wad@chromium.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
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
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 4, 2011 at 2:15 AM, Will Drewry <wad@chromium.org> wrote:
> On Mon, May 2, 2011 at 6:47 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>> 2011/5/3 Frederic Weisbecker <fweisbec@gmail.com>:
>>> On Fri, Apr 29, 2011 at 11:13:44AM -0500, Will Drewry wrote:
>>>> That said, I have a general interface question :)  Right now I have:
>>>> prctl(PR_SET_SECCOMP, 2, SECCOMP_FILTER_ADD, syscall_nr, filter_string);
>>>> prctl(PR_SET_SECCOMP, 2, SECCOMP_FILTER_DROP, syscall_nr,
>>>> filter_string_or_NULL);
>>>> prctl(PR_SET_SECCOMP, 2, SECCOMP_FILTER_APPLY, apply_flags);
>>>>   (I will change this to default to apply_on_exec and let FILTER_APPLY
>>>> make it apply _now_ exclusively. :)
>>>>
>>>> This can easily be mapped to:
>>>> prctl(PR_SET_SECCOMP
>>>>        PR_SET_SECOMP_FILTER_ADD
>>>>        PR_SET_SECOMP_FILTER_DROP
>>>>        PR_SET_SECOMP_FILTER_APPLY
>>>> if that'd be preferable (to keep it all in the prctl.h world).
>>>>
>>>> Following along the suggestion of reducing custom parsing, it seemed
>>>> to make a lot of sense to make add and drop actions very explicit.
>>>> There is no guesswork so a system call filtered process will only be
>>>> able to perform DROP operations (if prctl is allowed) to reduce the
>>>> allowed system calls.  This also allows more fine grained flexibility
>>>> in addition to the in-kernel complexity reduction.  E.g.,
>>>> Process starts with
>>>>   __NR_read, "fd == 1"
>>>>   __NR_read, "fd == 2"
>>>> later it can call:
>>>>   prctl(PR_SET_SECCOMP, 2, SECCOMP_FILTER_DROP, __NR_read, "fd == 2");
>>>> to drop one of the filters without disabling "fd == 1" reading.  (Or
>>>> it could pass in NULL to drop all filters).
>>>
>>> Hm, but then you don't let the childs be able to restrict further
>>> what you allowed before.
>>>
>>> Say I have foo(int a, int b), and I apply these filters:
>>>
>>>        __NR_foo, "a == 1";
>>>        __NR_foo, "a == 2";
>>>
>>> This is basically "a == 1 || a == 2".
>>>
>>> Now I apply the filters and I fork. How can the child
>>> (or current task after the filter is applied) restrict
>>> further by only allowing "b == 2", such that with the
>>> inherited parent filters we have:
>>>
>>>        "(a == 1 || a == 2) && b == 2"
>>>
>>> So what you propose seems to me too limited. I'd rather have this:
>>>
>>> SECCOMP_FILTER_SET = remove previous filter entirely and set a new one
>>> SECCOMP_FILTER_GET = get the string of the current filter
>>>
>>> The rule would be that you can only set a filter that is intersected
>>> with the one that was previously applied.
>>>
>>> It means that if you set filter A and you apply it. If you want to set
>>> filter B thereafter, it must be:
>>>
>>>        A && B
>>>
>>> OTOH, as long as you haven't applied A, you can override it as you wish.
>>> Like you can have "A || B" instead. Or you can remove it with "1". Of course
>>> if a previous filter was applied before A, then your new filter must be
>>> concatenated: "previous && (A || B)".
>>>
>>> Right? And note in this scheme you can reproduce your DROP trick. If
>>> "A || B" is the current filter applied, then you can restrict B by
>>> doing: "(A || B) && A".
>>>
>>> So the role of SECCOMP_FILTER_GET is to get the string that matches
>>> the current applied filter.
>>>
>>> The effect of this is infinite of course. If you apply A, then apply
>>> B then you need A && B. If later you want to apply C, then you need
>>> A && B && C, etc...
>>>
>>> Does that look sane?
>>>
>>
>> Even better: applying a filter would always automatically be an
>> intersection of the previous one.
>>
>> If you do:
>>
>> SECCOMP_FILTER_SET, __NR_foo, "a == 1 || a == 2"
>> SECCOMP_FILTER_APPLY
>> SECCOMP_FILTER_SET, __NR_foo, "b == 2"
>> SECCOMP_FILTER_APPLY
>> SECCOMP_FILTER_SET, __NR_foo, "c == 3"
>> SECCOMP_FILTER_APPLY
>>
>> The end result is:
>>
>> "(a == 1 || a == 2) && b == 2  && c == 3"
>>
>> So that we don't push the burden in the kernel to compare the applied
>> expression with a new one that may or may not be embraced by parenthesis
>> and other trickies like that. We simply append to the working one.
>>
>> Ah and OTOH this:
>>
>> SECCOMP_FILTER_SET, __NR_foo, "a == 1 || a == 2"
>> SECCOMP_FILTER_APPLY
>> SECCOMP_FILTER_SET, __NR_foo, "b == 2"
>> SECCOMP_FILTER_SET, __NR_foo, "c == 3"
>>
>> has the following end result:
>>
>> "(a == 1 || a == 2) && c == 3"
>>
>> As long as you don't apply the filter, the temporary part is
>> overriden, but still we keep
>> the applied part.
>>
>> Still sane? (or completely nuts?)
>
> Okay - so I *think* I'm following.  I really like the use of SET and
> GET to allow for further constraint based on additional argument
> restrictions instead of purely reducing the filters available.  The
> only part I'm stumbling on is using APPLY on a per-filter basis.  In
> my current implementation, I consider APPLY to be the global enable
> bit.  Whatever filters are set become set in stone and only &&s are
> handled.  I'm not sure I understand why it would make sense to do a
> per-syscall-filter apply call.  It's certainly doable, but it will
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
>
> In that case, would a call to sys_foo even be tested against the
> non-applied constraints of b==2 or c==3? Or would the call to set "c
> == 3" replace the "b == 2" entry.  I'm not sure I see that the benefit
> exceeds the ambiguity that might introduce.  However, if the default
> behavior it to always extend with &&, then a consumer of the interface
> could just do:
>
> SECCOMP_FILTER_SET, __NR_prctl, "option == 2"
> SECCOMP_FILTER_SET, __NR_foo, "a == 1 || a == 2"
> SECCOMP_FILTER_SET, __NR_foo, "b == 2"
> SECCOMP_FILTER_APPLY
>
> This would yield a final filter for foo of "(a == 1 || a == 2) && b ==
> 2".  The call to APPLY would initiate the enforcement of the syscall
> filtering and enforce that no new filters may be added for syscalls
> that aren't already constrained.  So you could still call
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
>
> (since the implicit filter for all syscalls after an APPLY call should
> be "0" and additions would just be "0 && whatever").
>
> Am I missing something?  If that makes sense, then we may even be able
> to reduce the extra directives by one and get a resulting interface
> that looks something like:
>
> /* Appends (&&) a new filter string for a syscall to the current
> filter value. "0" clears the filter. */
> prctl(PR_SET_SECCOMP_FILTER, syscall_nr, filter_string);
> /* Returns the current explicit filter string for a syscall */
> prctl(PR_GET_SECCOMP_FILTER, syscall_nr, buf, buflen);
> /* Transition to a secure computing mode:
>  * 1 - enables traditional seccomp behavior
>  * 2 - enables seccomp filter enforcement and changes the implicit
> filter for syscalls from "1" to "0"
>  */
> prctl(PR_SET_SECCOMP, mode);
>
> I'll set aside the v2 of the patch that uses ADD, DROP, and APPLY and
> work up a version with this interface.  Do you (or anyone else :) feel
> strongly about per-syscall APPLY?  I like the above version, but I'm
> certainly willing to explore the other path.  As is, I'll go through
> my usecases (and tests once I have a new cut of the patch) and see how
> it feels.  At first blush, this appears more succinct _and_ more
> expressive than the prior versions!
>
> ~~
>
> As to the use of apply_on_exec, even if you whitelist: mmap, fstat64,
> brk, uname, open, read, close, set_thread_area, mprotect, munmap, and
> access _just_ to allow a process to be exec'd, it is still a
> significant reduction in kernel attack surface.  Pairing that with a
> LSM, delayed chroot, etc could fill in the gaps with respect to a
> greater sandboxing solution.  I'd certainly take that tradeoff for
> running binaries that I don't control the source for :)  That said,
> LD_PRELOAD, ptrace injection, and other tricks could allow for the
> injection of a very targeted filterset, but I don't think that
> invalidates the on-exec case given the brittleness relying exclusively
> on such tactics.  Does that seem reasonable?

With a little more thinking :), I don't think there's an obvious hook
for "on-exec" bit in the interface proposed above.  I think that might
be a worthwhile tradeoff given how much cleaner it is.   It'd still be
possible to write a launcher to provide a reduced kernel surface, it'd
just also need a filter for the exec syscall.

cheers!
will
