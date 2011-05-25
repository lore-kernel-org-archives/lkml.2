Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052Ab1EYQkl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 12:40:41 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48528 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756044Ab1EYQkk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 12:40:40 -0400
MIME-Version: 1.0
In-Reply-To: <20110524200815.GD27634@elte.hu>
References: <1305563026.5456.19.camel@gandalf.stny.rr.com>
	<20110516165249.GB10929@elte.hu>
	<1305565422.5456.21.camel@gandalf.stny.rr.com>
	<20110517124212.GB21441@elte.hu>
	<1305637528.5456.723.camel@gandalf.stny.rr.com>
	<20110517131902.GF21441@elte.hu>
	<BANLkTikBK3-KZ10eErQ6Eex_L6Qe2aZang@mail.gmail.com>
	<1305807728.11267.25.camel@gandalf.stny.rr.com>
	<BANLkTiki8aQJbFkKOFC+s6xAEiuVyMM5MQ@mail.gmail.com>
	<BANLkTim9UyYAGhg06vCFLxkYPX18cPymEQ@mail.gmail.com>
	<20110524200815.GD27634@elte.hu>
Date: Wed, 25 May 2011 11:40:37 -0500
Message-ID: <BANLkTi=iR2WhMPepc-Tct10UcF=_is1H8w@mail.gmail.com>
Subject: Re: [PATCH 3/5] v2 seccomp_filters: Enable ftrace-based system call filtering
From: Will Drewry <wad@chromium.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>, kees.cook@canonical.com,
        "Serge E. Hallyn" <serge@hallyn.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[trimmed the cc list to those who've expressed interest or strong opinions]

On Tue, May 24, 2011 at 3:08 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Will Drewry <wad@chromium.org> wrote:
>
>> The change avoids defining a new trace call type or a huge number of internal
>> changes and hides seccomp.mode=2 from ABI-exposure in prctl, but the attack
>> surface is non-trivial to verify, and I'm not sure if this ABI change makes
>> sense. It amounts to:
>>
>>  include/linux/ftrace_event.h  |    4 +-
>>  include/linux/perf_event.h    |   10 +++++---
>>  kernel/perf_event.c           |   49 +++++++++++++++++++++++++++++++++++++---
>>  kernel/seccomp.c              |    8 ++++++
>>  kernel/trace/trace_syscalls.c |   27 +++++++++++++++++-----
>>  5 files changed, 82 insertions(+), 16 deletions(-)
>>
>> And can be found here: http://static.dataspill.org/perf_secure/v1/
>
> Wow, i'm very impressed how few changes you needed to do to support this!

There's definitely a large overlap in the needed infrastructure (event
inheritance, event enabling, event registration) which makes changes
using it pretty small!

> So, firstly, i don't think we should change perf_tp_event() at all - the
> 'observer' codepaths should be unaffected.

Easy enough to do.

> But there could be a perf_tp_event_ret() or perf_tp_event_check() entry that
> code like seccomp which wants to use event results can use.
>
> Also, i'm not sure about the seccomp details and assumptions that were moved
> into the perf core. How about passing in a helper function to
> perf_tp_event_check(), where seccomp would define its seccomp specific helper
> function?

I'm curious how we'd register the seccomp callback and/or know when to
call it.  Would it just be a task-wide callback for task_context
events?  If so, will that mean only one callback_event user will be
able to function at a time (per task)?  [That's fine for seccomp
purposes, of course, but may incur further internal api pain later
unless it uses the list iterator function model that ftrace uses.]

> That looks sufficiently flexible. That helper function could be an 'extra
> filter' kind of thing, right?
>
> Also, regarding the ABI and the attr.err_on_discard and attr.require_secure
> bits, they look a bit too specific as well.
>
> attr.err_on_discard: with the filter helper function passed in this is probably
> not needed anymore, right?
>
> attr.require_secure: this is basically used to *force* the creation of
> security-controlling filters, right? It seems to me that this could be done via
> a seccomp ABI extension as well, without adding this to the perf ABI. That
> seccomp call could check whether the right events are created and move the task
> to mode 2 only if that prereq is met - or something like that.

Yeah - this can all be achieved with 0 changes to the perf path
entirely.  The part that causes me concern is the idea of reusing perf
events for a task that may or may not have been installed by the
caller of prctl(PR_SET_SECCOMP, 2) without any clear demarcation to
the API/ABI consumer.  It seems that to use this interface an
application will need to:
1. via libperf, drop all task-centric traces
2. via libperf, install some perf_events for the "allowed" events
3. call prctl(PR_SET_SECCOMP, 2).

Even then, it isn't necessarily clear to the user which events will
have a security impact and which won't.  It creates an implicit ABI
(if that makes sense) that will be hard to ensure strong security
guarantees for as perf changes.  It'd be possible to still do a
(PR_SET_SECCOMP_FILTER, eventid) approach to indicate which events are
expected, but at that point I'd be tempted to leave libperf out of it
again :)  Regardless, I'll pull together the patch as I understand the
proposal since code can be a bit easier to digest than the discussion.
 It seems to me that it's going to be hard to stay away from explicit
ABI changes, but perhaps I'm misunderstanding the ultimate direction
still.

If I'm way off base, please let me know :)  It'll save some extra patch-churn.

Thanks!
will
