Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316Ab1GAQnp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 12:43:45 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39065 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757188Ab1GAQnn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 12:43:43 -0400
MIME-Version: 1.0
In-Reply-To: <20110701161027.GA29035@elte.hu>
References: <1308875813-20122-1-git-send-email-wad@chromium.org>
	<1308875813-20122-5-git-send-email-wad@chromium.org>
	<BANLkTimtYUyXbZjWhjK61B_1WBXE4MoAeA@mail.gmail.com>
	<alpine.LRH.2.00.1106270919290.30367@tundra.namei.org>
	<BANLkTi=sB2R-gWM30a0KKSGXz5p7OHRfeA@mail.gmail.com>
	<alpine.LRH.2.00.1106301128590.13496@tundra.namei.org>
	<20110701115600.GK20990@elte.hu>
	<BANLkTim8CGx89nOg0HX=S1=arunBU3sEGQ@mail.gmail.com>
	<20110701130705.GG12605@elte.hu>
	<BANLkTimN0nEa2Bog2-vzCv=1XOG5OsJjLA@mail.gmail.com>
	<20110701161027.GA29035@elte.hu>
Date: Fri, 1 Jul 2011 11:43:41 -0500
Message-ID: <BANLkTikCaACO8o9HkAnkuaTuoKqqQWQrtw@mail.gmail.com>
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

On Fri, Jul 1, 2011 at 11:10 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Will Drewry <wad@chromium.org> wrote:
>
>> From my view, ftrace events are not ready for the job yet - and
>> relying purely on available wrapped events may make it unsuitable
>> for attack surface reduction forever.  As is, there is no compat
>> syscall support.  Many syscalls are not wrapped at present and no
>> one ack'd my earlier patches around wrapping more.  All of perf
>> needs to be overhauled to share per-task infrastructure. A new ABI
>> needs to be proposed if my prctl() changes are not acceptable to
>> handle some of the security-focused behavioral requirements.
>> Performance characteristics need to be better analyzed as the
>> current perf list_head approach may not scale as desired.  The list
>> goes on.  My proof of concept patch for "event filters" was just
>> that - a proof of concept.  To truly share the filter events is a
>> large amount of work that may not be viable, and I believe you know
>> that as well as I do.
>
> But that's exactly my point: i consider it the right way forward
> because it maximizes kernel utility in the long run.

Not if it never happens.  Which is what happened with the proposals
from Adam and from Eric.

> Note that *all* the specific technical items you mention:
>
>  - wrapping more syscalls (i.e. making syscall tracing
>   feature-complete)
>
>  - a clean filtering ABI
>
>  - performance improvements. (Note that this one is already
>   in progress, Thomas has written an IDR implementation that
>   eliminates the list iteration entirely. You could help him
>   finish  it.)

I was thinking specifically about how filter events are stored and
accessed.  But sure, I could try to contribute to any number of
related efforts.

> are not some bad side effect or quirk, they are all generic
> improvements we want in any case and not just for sandboxing.

I didn't say they were bad side effects or quirks.

> You might not be interested in all of those items, you are only
> interested in getting the narrow feature-set you are interested in,
> but you sure are interested in getting sandboxing versus not getting
> anything at all, right?

Unfortunately, that isn't the value proposition for me or many other
contributors.  The real question is whether I am interested in getting
sandboxing in with mainline or if I want to sign up to maintain the
patches out of tree until my hair falls out.

I would much prefer to have a solution that Linux users as a whole can
benefit from and not just a subset of users I affect, but it's not a
hostage situation. I was hoping to work toward a solution that met
needs in the near future while being able to continue to invest in
driving long term changes.  If all the other work is a prerequisite
for system call restriction, I'll be very lucky to see anything this
calendar year assuming I can even write the patches in that time.

> Not doing it right because "it's too much work", especially as the

I'm not averse to work, but I don't necessarily feel that the extra
work is justified.  I also have to deal with my own personal and work
time constraints.

> trivial 'proof of concept' prototype already gave us something very
> promising that worked to a fair degree:
>
>       bitmask (2009):  6 files changed,  194 insertions(+), 22 deletions(-)
>  filter engine (2010): 18 files changed, 1100 insertions(+), 21 deletions(-)
>  event filters (2011):  5 files changed,   82 insertions(+), 16 deletions(-)
>
> are pretty hollow arguments to me. That diffstat sums up my argument
> of proper structure pretty well.

I wrote that code so I know how hollow the diffstats are.  The 82
lines of code do not:
- convince perf maintainers to share per-task events with "event filter" code
- provide reduce-privilege-only semantics
- provide a clean ABI that doesn't stomp all over the perf ABI
- provide compat syscalls
- provide a rewrite of DEFINE_SYSCALL* to support non 'long' syscalls
- provide ptreg syscall support
- provide any sort of blocking guarantees for unhooked system call events
- ...


I'd like to be able to move along security for the platform today and
not in two years, but if my only chance of any form of this being
ACK'd is to write it such that it shares code with perf and has a
shiny new ABI, then I'll queue up the work for when I can start trying
to tackle it.

That said, I still feel that this patch series is the right thing to
do now - not just for my personal reasons but for the kernel too.

Thanks,
will
