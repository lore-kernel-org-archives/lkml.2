Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759235Ab1FARPV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 13:15:21 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65062 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759172Ab1FARPT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 13:15:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=chromium.org; s=google;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mcB6RKABTUB6WBsw8IMGxyMIBnpf/Z1XRkGRSSg6rXNy+ufuYAoFFyg73E+3XPobfb
         quXKPXz7vwbgzXVBVfIwf6L9sifm0i6CP7ATHg+uAiKJHHF6hP1++XCdKlKwZ7+SgYpJ
         wm41O1xtEtyjkbsDLV7DmvVx9ifPpXBku+7v4=
MIME-Version: 1.0
In-Reply-To: <20110601070023.GB27671@elte.hu>
References: <BANLkTimNcag-ZmVTXjUoTyiuJm6jtW0DgA@mail.gmail.com>
	<1306897845-9393-2-git-send-email-wad@chromium.org>
	<20110601070023.GB27671@elte.hu>
Date: Wed, 1 Jun 2011 12:15:17 -0500
Message-ID: <BANLkTimWvddKkVQA1qOc6KhxPUj8j2dWQg@mail.gmail.com>
Subject: Re: [PATCH v3 02/13] tracing: split out syscall_trace_enter construction
From: Will Drewry <wad@chromium.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, kees.cook@canonical.com,
        torvalds@linux-foundation.org, tglx@linutronix.de, rostedt@goodmis.org,
        jmorris@namei.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 1, 2011 at 2:00 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Will Drewry <wad@chromium.org> wrote:
>
>> perf appears to be the primary consumer of the CONFIG_FTRACE_SYSCALLS
>> infrastructure.  As such, many the helpers target at perf can be split
>> into a peerf-focused helper and a generic CONFIG_FTRACE_SYSCALLS
>> consumer interface.
>>
>> This change splits out syscall_trace_enter construction from
>> perf_syscall_enter for current into two helpers:
>> - ftrace_syscall_enter_state
>> - ftrace_syscall_enter_state_size
>>
>> And adds another helper for completeness:
>> - ftrace_syscall_exit_state_size
>>
>> These helpers allow for shared code between perf ftrace events and
>> any other consumers of CONFIG_FTRACE_SYSCALLS events.  The proposed
>> seccomp_filter patches use this code.
>>
>> Signed-off-by: Will Drewry <wad@chromium.org>
>> ---
>>  include/trace/syscall.h       |    4 ++
>>  kernel/trace/trace_syscalls.c |   96 +++++++++++++++++++++++++++++++++++------
>>  2 files changed, 86 insertions(+), 14 deletions(-)
>
> So, looking at the diffstat comparison again:
>
>       bitmask (2009):  6 files changed,  194 insertions(+), 22 deletions(-)
>  filter engine (2010): 18 files changed, 1100 insertions(+), 21 deletions(-)
>  event filters (2011):  5 files changed,   82 insertions(+), 16 deletions(-)
>
> you went back to the middle solution again which is the worst of them
> - why?

In short, design for the future and implement now.  I'll elaborate a
bit more below.

> If you want this to be a stupid, limited hack then go for the v1
> bitmask.

I only aim for the finest!

(bitmasks were bad for the other consumers of this patch series:
socketcall mulitplexing issues and ioctl # filtering).

> If you agree with my observation that filters allow the clean
> user-space implementation of LSM equivalent security solutions (of
> which sandboxes are just a *narrow special case*) then please use the
> main highlevel abstraction we have defined around them: event
> filters.

I agree that LSM-equivalent security solutions can be moved over to an
ftrace based infrastructure.  However, LSMs and seccomp have different
semantics.  Reducing the kernel attack surface in a
"sandboxing"-sort-of-way requires a default-deny interface that is
resilient to kernel changes (like new system calls) without
immediately degrading robustness.  LSMs provide a fail-open mechanism
for taking an active role in kernel-defined pinch points.  It is
possible to implement a default-deny LSM, but it requires a "hook" for
every security event and the addition of a security event results in a
hole in the not-so-default-deny infrastructure.  ftrace + event
filters are the same.

Based on my observations while exploring the code, it appears that the
LSM security_* calls could easily become active trace events and the
LSM infrastructure moved over to use those as tracepoints or via
event_filters.  There will be a need for new predicates for the
various new types (inode *, etc), and so on.  However, the
trace_sys_enter/__secure_computing model will still be a special case.
 Even if they fed into security event subsystem or something like
that, the absence of filters on a traced process would need to
default-deny as well as when there are no active matches.  So while a
brand-new shared ABI may be possible (security_event_open,
active_event_open, ?), there will still be trickiness in making the
behaviors not have implicit side effects and ensure that newly added
system calls, for instance, that lack the macro wrapper don't poke a
hole in the "sandbox" model.  There are a lot of options for designing
it though.  Like making TIF_SECCOMP mean that any security_* filter
failure or match count of 0 == process death.  It's just that
designing this new approach will be incredibly hairy, and we really
lack many of the concrete requirements that would be needed, in my
opinion.

> Now, my observation was not uncontested so let me try to sum up the
> rather large discussion that erupted around it, as i see it.
>
> I saw four main counter arguments:
>
>  - "Sandboxing is special and should stay separate from LSMs."
>
>   I think this is a technically bogus argument, see:
>
>         https://lkml.org/lkml/2011/5/26/85
>
>   That answer of mine went unchallenged.

I may have spoken to this above.  I dunno.

>  - "Events should only be observers."
>
>   Even ignoring the question of why on earth it should be a problem
>   for a willing call-site to use event filtering results sensibly,
>   this argument misses the plain fact that events are *already*
>   active participants, see:
>
>         http://www.spinics.net/lists/mips/msg41075.html
>
>   That answer of mine went unchallenged too.
>
>  - "This feature is too simplistic."
>
>   That's wrong i think, the feature is highly flexible:
>
>         http://www.mail-archive.com/linuxppc-dev@lists.ozlabs.org/msg51387.html
>
>   This reply of mine went unchallenged as well.

Well I did only implement a PoC.  It couldn't handle attack surface
reduction after-the-fact, nor did I add a GET_FILTER call, etc.  The
code was minimal in many ways because the functionality was too.

>  - "Is this feature actually useful enough for applications, does it
>    justify the complexity?"
>
>  This is the *only* valid technical counter-argument i saw, and it's
>  a crutial one that is not fully answered yet. Since i think the feature
>  is an LSM equivalent i think it's at least as useful as any LSM is.
>
>  - [ if i missed any important argument then someone please insert it
>     here. ]
>
> But what you do here is to use the filter engine directly which is
> both a limited hack *and* complex (beyond the linecount it doubles
> our ABI exposure, amongst other things), so i find that approach
> rather counter-productive, now that i've seen the real thing.
>
> Will this feature be just another example of the LSM status quo
> dragging down a newcomer into the mud, until it's just as sucky and
> limited as any existing LSMs? That would be a sad outcome!

I hope not.  I believe it will be easy to move the backend of
seccomp_filter over to a per-task ftrace event filter infrastructure
when that comes in the future.  But for now, I'm trying to meet the
needs of possible consumers now: chromium, qemu, lxc, and lay
groundwork for a ftrace-future.

If this is a total fail, then perhaps we should have a separate
discussion over how we can tackle a lot of these needs.  I was hoping
that we could push some of that off to the LinuxSecuritySummit -- I've
proposed/requested a QA panel on this topic :)  But I'd love to not
wait until then for everything.

> ps. Please start a new discussion thread for the next iteration!
>    This one is *way* too deep already.

Sorry - will do!

thanks!
will
