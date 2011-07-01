Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674Ab1GAPq3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 11:46:29 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51819 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264Ab1GAPq0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 11:46:26 -0400
MIME-Version: 1.0
In-Reply-To: <20110701130705.GG12605@elte.hu>
References: <1308875813-20122-1-git-send-email-wad@chromium.org>
	<1308875813-20122-5-git-send-email-wad@chromium.org>
	<BANLkTimtYUyXbZjWhjK61B_1WBXE4MoAeA@mail.gmail.com>
	<alpine.LRH.2.00.1106270919290.30367@tundra.namei.org>
	<BANLkTi=sB2R-gWM30a0KKSGXz5p7OHRfeA@mail.gmail.com>
	<alpine.LRH.2.00.1106301128590.13496@tundra.namei.org>
	<20110701115600.GK20990@elte.hu>
	<BANLkTim8CGx89nOg0HX=S1=arunBU3sEGQ@mail.gmail.com>
	<20110701130705.GG12605@elte.hu>
Date: Fri, 1 Jul 2011 10:46:24 -0500
Message-ID: <BANLkTimN0nEa2Bog2-vzCv=1XOG5OsJjLA@mail.gmail.com>
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

On Fri, Jul 1, 2011 at 8:07 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Will Drewry <wad@chromium.org> wrote:
>
>> On Fri, Jul 1, 2011 at 6:56 AM, Ingo Molnar <mingo@elte.hu> wrote:
>> >
>> > * James Morris <jmorris@namei.org> wrote:
>> >
>> >> On Wed, 29 Jun 2011, Will Drewry wrote:
>> >>
>> >> > Since it seems that there'll be consumers (openssh, vsftpd,
>> >> > kvm/qemu, chromium, chromium os) and feedback quieted down, what
>> >> > are the next steps to get this to a pull/no-pull decision points
>> >> > (or at least some Ack's or Nack's)?  I know this patch series
>> >> > crosses a number of maintainers, and I never know exactly what's
>> >> > next when the feedback slows down.
>> >>
>> >> Are there any outstanding objections to this approach?  How do the
>> >> tracing folk feel about it?
>> >
>> > I think i outlined my objections a couple of times and haven't seen
>> > them addressed.
>>
>> After our last discussion, I suggested changes which I then undertook
>> and reposted.  Those changes have been posted for over two weeks.
>
> Have you addressed my basic objection of why we should go for a more
> complex and less capable variant over a shared yet more capable
> facility:
>
>  http://lkml.kernel.org/r/20110526091518.GE26775@elte.hu
>
> ?

I withheld a fair number of comments because of the other participants
addressed some of them, but I believe I've laid out my thoughts at
least twice.  Perhaps not clearly, though.  I can post links if you
like, but they were all direct responses to your posts.

> You are pushing the 'filter engine' approach currently, not the
> (much) more unified 'event filters' approach.

In short, it is a large amount of work that will provide an incomplete
solution.  As is, this patch series has been in process for over 8
weeks. I've rewritten it about twice as many times as the 'v9' label
indicates.  After doing that, I do not believe your proposed solution
is simpler or more reasonable in the near term (<= 2 years).  Perhaps
the issue is just that someone who is more skilled and more
comfortable in the kernel could propose a better patch series - I
don't know.



>From my view, ftrace events are not ready for the job yet - and
relying purely on available wrapped events may make it unsuitable for
attack surface reduction forever.  As is, there is no compat syscall
support.  Many syscalls are not wrapped at present and no one ack'd my
earlier patches around wrapping more.  All of perf needs to be
overhauled to share per-task infrastructure. A new ABI needs to be
proposed if my prctl() changes are not acceptable to handle some of
the security-focused behavioral requirements.  Performance
characteristics need to be better analyzed as the current perf
list_head approach may not scale as desired.  The list goes on.  My
proof of concept patch for "event filters" was just that - a proof of
concept.  To truly share the filter events is a large amount of work
that may not be viable, and I believe you know that as well as I do.

That said, I did attempt to internalize all of your feedback, the
feedback from potential consumers, Linus' feedback, and that from
Steve and Frederic, along with the other people who were so kind as to
provide excellent feedback.  The current patch series is forward
portable to an "event filters" model and nearly all of its per-task
management complexity could be folded into shared code if it is
possible to create such infrastructure (for perf, event filters, ?).
Alternatively, this interface could become the entry point until such
time as it outgrows a per-process only experience.

Based on the support from potential API consumers, I believe there is
interest in this patch series, and I worry that just like with the
last two attempts in the last two years, this series will be relegated
to the lwn archives in anticipation of a future solution that uses
infrastructure that isn't quite ready.  I'm trying to approach a
problem that can be addressed today in a flexible, future-friendly
way, rather than try to open up a larger cross-kernel impacting patch
series that I'm unsure of exactly how to integrate sanely and don't
know that I can commit to doing.  And I don't see anyone else jumping
up to write the patch series to do it either :/



Anyway, that's where I am.  I'd really like to be able to offer this
functionality for all Linux users of Chromium and I'd be thrilled to
see it helping enhance the privilege separation code in OpenSSH, among
the other projects that have come forward (qemu, etc).

If you still think this patch series is a "stupid, limited hack" even
my attempts to balance the present with a possible future, then I'm
not sure what the practical next steps are.  And even if it is such a
hack, it is isolated to a very specific purpose and does not impact
those who don't care about it.  I don't think there's an attainable,
perfect solution, and when it comes to attack surface reduction, it's
hard to be hooking the syscalls very explicitly.

Thanks again for the continued feedback,
will
