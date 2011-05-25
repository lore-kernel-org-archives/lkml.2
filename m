Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757694Ab1EYNor (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 09:44:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45199 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757104Ab1EYNoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 09:44:46 -0400
Date: Wed, 25 May 2011 15:44:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC 0/9] mce recovery for Sandy Bridge server
Message-ID: <20110525134414.GB19118@elte.hu>
References: <4ddad79317108eb33d@agluck-desktop.sc.intel.com>
 <20110524034023.GB25230@elte.hu>
 <987664A83D2D224EAE907B061CE93D5301D5D0595B@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <987664A83D2D224EAE907B061CE93D5301D5D0595B@orsmsx505.amr.corp.intel.com>
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


* Luck, Tony <tony.luck@intel.com> wrote:

> Other points noted - I'll go look at the previous discussion threads
> you gave me links to.
> 
> I do want to comment on this point:
> > Creating a callback there would be a good place to do the TIF_MCE work and also 
> > to extract any events that got queued by other NMIs. Note that more events 
> > might be queued by further NMIs while we are processing the MCE path - while 
> > with the task->mce_error_pfn hack we are limited to a single pending event only 
> > and subsequent NMIs will overwrite this value!
> 
> I wasn't very happy with task->mce_error_pfn either - but being 
> overwritten is not one of its flaws.  The task that stumbled on the 
> error must not be run until the error is dealt with - any other 
> NMIs for other errors must be happening to other tasks (who have 
> their own task->mce_error_pfn).

If that task is running right now you might not have much of a chance 
but to be prepared for a repeat NMI the moment NMIs are enabled again 
after the IRET.

So repeat errors are not just

But yeah, this is not the worst ugliness of it indeed.

> > A happy side effect is that the TIF_MCE_NOTIFY hack could go away 
> > as well.
> 
> We need some way to stop the task that found the error dead in its 
> tracks - if it tripped over a data error, then running it will just 
> trip over the same error again. If it had a memory error during an 
> instruction fetch we have no place to return to.

Well, the primary thing TIF_MCE_NOTIFY does is a roundabout way to 
iterate through repeat calls to memory_failure(), with all pfns that 
got buffered so far.

We already have a generic facility to do such things at 
return-to-userspace: _TIF_USER_RETURN_NOTIFY.

Btw., the SIGKILL logic is probably overcomplicated: when it's clear 
that user-space can not recover why not do a do_exit() and be done 
with it? As long as it's called from a syscall level codepath and no 
locks/resources are held do_exit() can be called.

> So can we talk about this part for a while before returning to the 
> "how to report this" discussion?
> 
> So here's the situation - we are in the NMI handler when we find 
> from looking at the machine check bank registers that we have a 
> recoverable error. We know the physical address, and we know the 
> task (which might have been in user or kernel context). I can 
> package that information into a perf/event ... but then how can I 
> mark the current task as not-fit-for-execution?

Well, you'd queue up a user return notifier, process the ring-buffer 
at that end (as a ring-buffer consumer), call policy action like 
memory_failure() which does its MM specific checks to see whether the 
task is recoverable or not.

The goal is that we wouldnt lose any existing hwpoison functionality 
over what hwpoison does today - we'd *gain* functionality:

 - through the use of enumerated events we would give access to
   *other* users of the same event source as well, not just hwpoison.

 - we'd also eventually remove the mcelog ring-buffer mechanism
   itself.

For this i'd suggest to take a look at Frederic's recent patches on 
lkml which decouple the events code some more:

  Subject: [PATCH v2] hw_breakpoint: Let the user choose not to build it (and perf too)

Those could be compounded with more decoupling of perf events: for 
example right now 'struct perf_event' is pretty big, because it 
carries hw PMU details as well. But those details are not needed for 
non-PMU events so splitting those from struct perf_event would 
streamline this code some more.

Likewise the kernel/events/core.c ring-buffer bits could be split out 
into kernel/events/ring-buffer.c - i think Frederic might be working 
on this one already.

More advanced steps in the MCE area would be to replace the 
'severity' logic (which is really a poor-man's filter) with event 
filters and panic the box (or do other immediate action) if the 
filter matches.

This again would not lose any functionality that the severity bits 
give us today, we'd gain functionality:

 - the conditions in filter expressions are pretty flexible so we 
   could do more than the current stack of severity bitmask ops. For
   example a system could be configured to ignore the first N
   non-fatal messages but panic the box if more than 10 errors were
   generated. If there's a "message_seq_nr" field available in the
   TRACE_EVENT() then this would be a simple "message_seq_nr >= 10" 
   filter condition. With the current severity code this would have 
   to be coded in, the ABI extended, etc. etc.

Although initially it would probably want to match what the severity 
filters do today and install all the default policy.

Thanks,

	Ingo
