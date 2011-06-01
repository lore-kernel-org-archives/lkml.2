Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab1FAHAn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 03:00:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58352 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753235Ab1FAHAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 03:00:42 -0400
Date: Wed, 1 Jun 2011 09:00:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, kees.cook@canonical.com,
        torvalds@linux-foundation.org, tglx@linutronix.de, rostedt@goodmis.org,
        jmorris@namei.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v3 02/13] tracing: split out syscall_trace_enter
 construction
Message-ID: <20110601070023.GB27671@elte.hu>
References: <BANLkTimNcag-ZmVTXjUoTyiuJm6jtW0DgA@mail.gmail.com>
 <1306897845-9393-2-git-send-email-wad@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306897845-9393-2-git-send-email-wad@chromium.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Will Drewry <wad@chromium.org> wrote:

> perf appears to be the primary consumer of the CONFIG_FTRACE_SYSCALLS
> infrastructure.  As such, many the helpers target at perf can be split
> into a peerf-focused helper and a generic CONFIG_FTRACE_SYSCALLS
> consumer interface.
> 
> This change splits out syscall_trace_enter construction from
> perf_syscall_enter for current into two helpers:
> - ftrace_syscall_enter_state
> - ftrace_syscall_enter_state_size
> 
> And adds another helper for completeness:
> - ftrace_syscall_exit_state_size
> 
> These helpers allow for shared code between perf ftrace events and
> any other consumers of CONFIG_FTRACE_SYSCALLS events.  The proposed
> seccomp_filter patches use this code.
> 
> Signed-off-by: Will Drewry <wad@chromium.org>
> ---
>  include/trace/syscall.h       |    4 ++
>  kernel/trace/trace_syscalls.c |   96 +++++++++++++++++++++++++++++++++++------
>  2 files changed, 86 insertions(+), 14 deletions(-)

So, looking at the diffstat comparison again:

       bitmask (2009):  6 files changed,  194 insertions(+), 22 deletions(-)
 filter engine (2010): 18 files changed, 1100 insertions(+), 21 deletions(-)
 event filters (2011):  5 files changed,   82 insertions(+), 16 deletions(-)

you went back to the middle solution again which is the worst of them 
- why?

If you want this to be a stupid, limited hack then go for the v1 
bitmask.

If you agree with my observation that filters allow the clean 
user-space implementation of LSM equivalent security solutions (of 
which sandboxes are just a *narrow special case*) then please use the 
main highlevel abstraction we have defined around them: event 
filters.

Now, my observation was not uncontested so let me try to sum up the
rather large discussion that erupted around it, as i see it.

I saw four main counter arguments:

 - "Sandboxing is special and should stay separate from LSMs."

   I think this is a technically bogus argument, see:

         https://lkml.org/lkml/2011/5/26/85

   That answer of mine went unchallenged.

 - "Events should only be observers."

   Even ignoring the question of why on earth it should be a problem 
   for a willing call-site to use event filtering results sensibly, 
   this argument misses the plain fact that events are *already* 
   active participants, see:

         http://www.spinics.net/lists/mips/msg41075.html

   That answer of mine went unchallenged too.

 - "This feature is too simplistic."

   That's wrong i think, the feature is highly flexible:

         http://www.mail-archive.com/linuxppc-dev@lists.ozlabs.org/msg51387.html

   This reply of mine went unchallenged as well.

 - "Is this feature actually useful enough for applications, does it 
    justify the complexity?"

  This is the *only* valid technical counter-argument i saw, and it's 
  a crutial one that is not fully answered yet. Since i think the feature
  is an LSM equivalent i think it's at least as useful as any LSM is.

 - [ if i missed any important argument then someone please insert it 
     here. ]

But what you do here is to use the filter engine directly which is 
both a limited hack *and* complex (beyond the linecount it doubles 
our ABI exposure, amongst other things), so i find that approach 
rather counter-productive, now that i've seen the real thing.

Will this feature be just another example of the LSM status quo 
dragging down a newcomer into the mud, until it's just as sucky and 
limited as any existing LSMs? That would be a sad outcome!

Thanks,

	Ingo

ps. Please start a new discussion thread for the next iteration!
    This one is *way* too deep already.
