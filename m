Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab1EGB6U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 21:58:20 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45057 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265Ab1EGB6T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 21:58:19 -0400
MIME-Version: 1.0
In-Reply-To: <1304682803.25414.2520.camel@gandalf.stny.rr.com>
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
	<1304682803.25414.2520.camel@gandalf.stny.rr.com>
Date: Fri, 6 May 2011 18:58:17 -0700
Message-ID: <BANLkTim16KCwq__L=3OEsDkvQe3yojtc5Q@mail.gmail.com>
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

On Fri, May 6, 2011 at 4:53 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Thu, 2011-05-05 at 02:21 -0700, Will Drewry wrote:
>
>> In particular, if the userspace code wants to stage some filters and
>> apply them all at once, when ready, I'm not sure that it makes sense
>> to me to put that complexity in the kernel itself.  For instance,
>> Eric's second sample showed a call that took an array of ints and
>> coalesced them into "fd == %d || ...".  That simple example shows that
>> we could easily get by with a pretty minimal kernel-supported
>> interface as long as the richer behavior could live userspace side --
>> even if just in a simple helper library.  It'd be pretty easy to
>> implement a userspace library that exposed add_filter(syscall_nr,
>> filter) and apply_filters() such that it could manage building the
>> final filter string for a given syscall and pushing it to prctl on
>> apply.
>
> I'm fine with a single kernel call and the "temporary filter" be done in
> userspace. Making the kernel code less complex is better :)
>
>>
>> I think that could also help simplify the primitives.  For instance,
>> if any separate SET called on a system call resulting in an &&
>> operation, then the behavior could be consistent prior to enforcement
>> of the filtering and after.  E.g.,
>>   SET, __NR_read, "fd == 1"
>>   SET, __NR_read, "len < 4097"
>> would result in an evaluated "fd == 1 && len < 4097".  It would do so
>> after a single APPLY call too:
>>   SET, __NR_read, "1"
>>   APPLY
>>   SET, __NR_read, "fd == 1"
>>   SET, __NR_read, "len < 4097"
>> Results in: "1 && fd == 1 && len < 4097", and SET, nr, "0" would
>> nullify the syscall filter in total.
>
> Only that that was not applied? We can't let tasks nullify their
> restrictions once they have been applied. This keeps the kernel code
> simpler.

Ah - so I really need to be more explicit when discussing these
things!  In the "simplification" effort, I was thinking any syscall
with no entry has a "0" rule.  So if if nullify it, it becomes a
complete block and if you can't OR, then you can't add permissions.

>>   It seems like that would be
>> enough to build the SET-SET-...-APPLY, SET-SET-...-SET-APPLY logic
>> into a userspace library so that all temporary unapplied state doesn't
>> have to be explicitly managed by the kernel.
>
> Thus, the SETs are done in the userspace library that does not need to
> interact with the kernel (besides perhaps allocating memory). Then the
> apply would send all the filters to the kernel which would restrict the
> task (or the task on exec) further.

Exactly. Smaller patch and less state per-filter entry (I hope!).


>>
>> While I completely agree with the comment around ease-of-use as being
>> key to security, I also find that the more the state diagram explodes,
>> the harder it is to feel confident that a solution is actually secure.
>>  To try to achieve both objectives, I'd like to limit the kernel
>> interface to the bare minimum of primitives and build any API
>> fanciness into userspace.
>
> Fair enough.
>
>>
>> Does it seem that the tradeoff isn't worth it, or are there some
>> specific behaviors that aren't addressed using that model?
>>
>> While writing that, another option occurred to me that touches on the
>> other proposals but makes the behaviors much more explicit.
>> A prctl prototype could be provided:
>>  prctl(<SET|GET>, <AND|OR>, <syscall_nr>, <filter string>)
>> e.g.,
>>  prctl(PR_SET_SECCOMP_FILTER, PR_SECCOMP_FILTER_OR, __NR_read, "fd == 2");
>>
>> The explicit prctl argument list would allow the filter strings to be
>> self-referential and allow the userspace app to decide what behaviors
>> are allowed and when. If we followed that route, all implicit filters
>> would be "0" and the initial call to get things started might be:
>>    #define SET 33
>>    #define OR 0
>>    #define AND 1
>>    SET, OR, __NR_prctl, "option == 33 && (arg1 == 0 || arg1 == 1)"
>>    prctl(PR_SET_SECCOMP, 2);
>>
>> So now the "locked down" binary can call prctl to set an OR or AND
>> filter for any syscall.  A subsequent call could change that:
>>   SET, OR, __NR_read, "fd == 2"  /* => "0 || fd == 2" */
>>   SET, AND, __NR_prctl, "(arg2 != 63 || arg1 != 0)"  /* __NR_read == 63 */
>>
>> This would OR in a __NR_read filter, then disallow a future call to
>> prctl to OR in more NR_read filters, but for other syscalls ANDing and
>> ORing is still possible until you pass in something like:
>>
>>   SET, AND, __NR_prctl, "arg1 == 1"
>>
>> which would lock down all future prctl calls to only ANDing filters
>> in.  (The numbers in the examples could then be properly managed in a
>> userspace library to ensure platform correctness.)
>
> I don't know about this. It seems to be starting to get too complex, and
> thus error prone. Is there any reason we should allow an OR to the task?
> Why would we want to restrict a task where the task could easily
> unrestrict itself?

No idea!  I can't think of any good examples where you'd want to do
it, just contrived ones.  In general, I think the above approach would
rarely be used since I expect that something like 80% of the places
where this will be used will just be one-time, upfront filter installs
without any surface reduction after the fact.

That said, if there's no reason to support OR after the fact, then the
interface can just _only_ support &&s and leave the installation to
userspace.  It might makes the multiple-fd-ORing case less fun in
userspace, but it should work for most cases I think.

>>
>> While this would reduce the primitives a bit further, I'm not sure if
>> this would be the right approach either, but it would open the door to
>> pushing even more down to userspace very explicitly and further
>> removing magic policy logic from the kernel-side.  Is this vaguely
>> interesting or just another layer of confusing-ness?
>
> I'm confused, thus I must have hit that layer ;)

Sounds like it.  I'm always a sucker for self-referential mechanisms.
I've been travelling a bit recently so my code output has been a bit
low, but I'll pull together the most minimal approach that I think
we've been iterating toward and hopefully post something in the not
too distant future.

thanks!
