Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758001Ab1GAVep (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 17:34:45 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45511 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757742Ab1GAVen convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 17:34:43 -0400
MIME-Version: 1.0
In-Reply-To: <20110701210011.GA22171@elte.hu>
References: <BANLkTimtYUyXbZjWhjK61B_1WBXE4MoAeA@mail.gmail.com>
	<alpine.LRH.2.00.1106270919290.30367@tundra.namei.org>
	<BANLkTi=sB2R-gWM30a0KKSGXz5p7OHRfeA@mail.gmail.com>
	<alpine.LRH.2.00.1106301128590.13496@tundra.namei.org>
	<20110701115600.GK20990@elte.hu>
	<BANLkTim8CGx89nOg0HX=S1=arunBU3sEGQ@mail.gmail.com>
	<20110701130705.GG12605@elte.hu>
	<BANLkTimN0nEa2Bog2-vzCv=1XOG5OsJjLA@mail.gmail.com>
	<20110701161027.GA29035@elte.hu>
	<BANLkTikCaACO8o9HkAnkuaTuoKqqQWQrtw@mail.gmail.com>
	<20110701210011.GA22171@elte.hu>
Date: Fri, 1 Jul 2011 16:34:41 -0500
Message-ID: <BANLkTik2YtBbC+T3zyCooK71zZ_z2FdJuQ@mail.gmail.com>
Subject: Re: [PATCH v9 05/13] seccomp_filter: Document what seccomp_filter is
 and how it works.
From: Will Drewry <wad@chromium.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: James Morris <jmorris@namei.org>, Chris Evans <scarybeasts@gmail.com>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>, djm@mindrot.org,
        segoon@openwall.com, kees.cook@canonical.com, rostedt@goodmis.org,
        fweisbec@gmail.com, tglx@linutronix.de,
        Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
        Eric Paris <eparis@redhat.com>, linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 1, 2011 at 4:00 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Will Drewry <wad@chromium.org> wrote:
>
>> On Fri, Jul 1, 2011 at 11:10 AM, Ingo Molnar <mingo@elte.hu> wrote:
>>
>> > But that's exactly my point: i consider it the right way forward
>> > because it maximizes kernel utility in the long run.
>>
>> Not if it never happens.  Which is what happened with the proposals
>> from Adam and from Eric.
>
> Well, that's what my job is as a maintainer: to tell you if i dislike
> a solution and to suggest better solutions - and here this was really
> easy to do, as you already prototyped a solution i consider (far)
> superior.

But other maintainers disagreed.  So as a non-maintainer, I get to
guess as to what happens next.

> I cannot force you to do it like that, but i do have to say 'no'.

It seems like a catch-22.  There's not a perfectly clear path forward,
and anything that looks like the perf-style proof of concept will be
NACK'd by other maintainers.  While I believe we could lift perf up
off its foundation and create a shared location for storing perf
events and ftrace events so that they will be inherited the same way
(currently nack'd by linus) and walked the same way (kinda), the
syscall interface couldn't currently be shared (also nack'd by perf),
and creating a new one is possible modeled on the perf one, but it's
also unclear what the ABI should be for a generic filtering system.
As I mentioned in a prior mail, syscalls should be whitelist only
(default fail), but random function call points in the kernel are more
likely to be fail-open.  And as the policy mechanisms get more
complicated, so does the code that needs to manage them.  I don't know
what the specification would look like or how it should look.  (For
instance, I abused a seccomp mode for the poc to change the match
behavior for syscall events. I imagine that could be folded into the
event handler for the proposed system, but I don't know what we'd do
for any other event subsystems.)

>> > are not some bad side effect or quirk, they are all generic
>> > improvements we want in any case and not just for sandboxing.
>>
>> I didn't say they were bad side effects or quirks.
>
> That's a pretty important point as well.

Well I have very explicit concerns that (new) system calls will slip
through the cracks forever and then a non-system call focused system
for reducing the kernel attack surface will always be incomplete.  The
biggest benefit of creating a highly targeted patch series that
focuses on the kernel syscall ABI is that future additions won't be
able to slip through the cracks without major system-level changes.
Perhaps this is why I am nervous about a generic solution.  I find
that sometimes the specialized solution is the best one even when
there is some additional cost.

>> > You might not be interested in all of those items, you are only
>> > interested in getting the narrow feature-set you are interested
>> > in, but you sure are interested in getting sandboxing versus not
>> > getting anything at all, right?
>>
>> Unfortunately, that isn't the value proposition for me or many
>> other contributors.  The real question is whether I am interested
>> in getting sandboxing in with mainline or if I want to sign up to
>> maintain the patches out of tree until my hair falls out.
>
> Well, if you implement the right solution then why should it stay out
> of tree?

"right" is subjective -- as always.  We each have different value
judgements we make.  Specialized verus generalized solutions.  Shared
code versus duplicated code.  Iterative improvements versus giant
overhauls, etc.   I was just responding to the fact I interpreted the
language in your mail more like code-writing-extortion than working
towards a better Linux kernel.  Perhaps I was reading it too harshly.

> If the code is clean and useful and resolves all the technical
> objections that were raised against it then i will certainly merge it
> - and i hope Linus will chime in if he finds the actual iteration
> unacceptable and the direction harmful, to save us all the trouble.

Any guidance here would certainly be welcomed.  I had thought that
doing a larger more complicated solution had been shot down along with
supporting inheritance or other generic features.  Instead, this patch
series is focused (attack surface reduction) and process-tied so that
could be iteratively improved and moved toward a longer term
shared-infrastructure goal without pulling in all the overhead and
design complexity right away.

I had hoped the current iteration would have been satisfactory from
both a usefulness and a technical quality perspective to potential API
consumers and maintainers alike.

> In the end the 'sandboxing' feature should be a few dozen lines at
> most - all the rest will just be shared infrastructure.

Anytime a powerful feature can be a few lines of code, it's a good
thing.  It seems like we're still a ways away from defining what the
shared infrastructure is that would allow a few dozen lines of code to
be enough.  The bones are there, but there's a large amount of missing
and under-designed work.

Thanks,
will
