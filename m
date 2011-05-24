Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189Ab1EXDko (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 23:40:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42171 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756602Ab1EXDkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 23:40:43 -0400
Date: Tue, 24 May 2011 05:40:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, "Huang, Ying" <ying.huang@intel.com>,
        Andi Kleen <andi@firstfloor.org>, Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFC 0/9] mce recovery for Sandy Bridge server
Message-ID: <20110524034023.GB25230@elte.hu>
References: <4ddad79317108eb33d@agluck-desktop.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ddad79317108eb33d@agluck-desktop.sc.intel.com>
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

> Here's a nine-part patch series to implement "AR=1" recovery
> that will be available on high-end Sandy Bridge server processors.

So, the generic comment i have on this is similar to what i wrote to
Huang Ying already: i'd really like to see progress on the proper
RAS / event approach instead of seeing further iterations of the
very limited and isolated severity levels and mcelog approach ...

Also, more integration with EDAC would be required: there is no reason why the 
framework and user/admin appearance of hardware error handling of CPU and 
memory chipset level hardware should be different. In fact the physical 
distinction is largely moot since memory controllers moved into the CPU ...

> In this case the process detects an uncorrectable memory error
> while doing an instruction of data fetch that is about to be
> consumed.  This is in contrast to the recoverable errors on
> Nehalem and Westmere that were out of immediate execution context
> (patrol scrubber and cache line write-back).
> 
> The code is based on work done by Andi last year and published in
> the "mce/action-required" branch of his mce git tree:
> git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-mce-2.6.git
> Thus he gets author credit on 6 out of 9 patches (but I'll take
> the blame for all of them).

Well, did Andi tell you that me and Thomas NAK-ed those bits and what reasons 
we outlined? See:

  http://lkml.org/lkml/2010/2/16/309

We are more than half a year down the road and i do not see much progress on 
those important conceptual points in this RFC patchset either. The technical 
points we made in our original NAK was left largely unaddressed AFAICS.

The two main technical points made there still hold today:

 - Please work on integrating RAS/EDAC with MCE. Both Mauro and Boris has
   made progress there, but frankly, i only saw Andi ignoring/stonewalling
   them.

 - Please work on using a proper event framework for new hardware events,
   we really do not want to extend the mcelog mess, and we want to help
   efforts like unified system event logging and the new RAS daemon.

Now, some of that might be fun and non-trivial infrastructure work - so i'm not 
asking you to implement the world and everything on day 1. But seeing this 
non-progress on the Intel MCE side why should i consider lifting the NAK?

> The first eight patches are mostly cleanups and minor new bits
> that are needed by part 9 where the interesting stuff happens.
> 
> For the "in context" case, we must not return from the machine
> check handler (in the data fetch case we'd re-execute the fetch
> and take another machine check, in the instruction fetch case
> we actually don't have a precise IP to return to).  We use the
> TIF_MCE_NOTIFY task flag bit to ensure that we don't return to
> the user context - but we also need to keep track of the memory
> address where the fault occurred. The h/w only gives us the physical
> address which we must keep track of ... to do so we have added
> "mce_error_pfn" to the task structure - this feels odd, but it
> is an attribute of the task (e.g. this task may be migrated to
> another processor before we get to look at TIF_MCE_NOTIFY and
> head to do_notify_resume() to process it).

There is absolutely *no reason* for the MCE code to hook in to the kernel at 
such a low level and muck with task struct!

The error PFN is a useful event field - use it as a TRACE_EVENT() field. 
Processing events in non-NMI context is something you can do already as well, 
see how perf_event_wakeup() delays a ring-buffer wakeup to post-NMI IRQ 
context.

Creating a callback there would be a good place to do the TIF_MCE work and also 
to extract any events that got queued by other NMIs. Note that more events 
might be queued by further NMIs while we are processing the MCE path - while 
with the task->mce_error_pfn hack we are limited to a single pending event only 
and subsequent NMIs will overwrite this value!

A happy side effect is that the TIF_MCE_NOTIFY hack could go away as well.

Also note that if it's done via events then injection support will naturally 
extend to this capability as well and you can test it by injecting arbitrary 
error-PFNs ...

So my broad take on this is that historically the MCE code started out as a 
limited set of very low level hacks, both on the CPU support side, on the 
logging side and the user ABI side. For years it was only supporting AMD CPUs 
in a serious fashion. This was borderline acceptable because frankly back then 
MCE did not really matter much: boxes died faster than anyone could do anything 
intelligent about it.

But today it matters more. There are more intelligent errors emitted by the 
hardware and less fatal hardware behavior. The boundary between 'hard errors', 
'soft errors' and 'system events' has become fuzzier: so we really want to have 
a generic notion for system events that matter to performance and reliability - 
instead of these isolated islands of weirdly coded functionality that the Intel 
MCE code is today. We want to be able to log all of these event classes, in one 
unified framework, and define policy on them.

So we *really* want to promote this code to a higher level of abstraction. 
Everyone would benefit from doing that: Intel hardware error handling features 
would be enabled much more richly and i suspect they would also be *used* in a 
much more meaningful way - driving the hw cycle as well.

Thanks,

	Ingo
