Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071Ab1LTJRO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 04:17:14 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55107 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667Ab1LTJRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 04:17:08 -0500
Date: Tue, 20 Dec 2011 10:15:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Robert Richter <robert.richter@amd.com>, Benjamin Block <bebl@mageta.org>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>, hpa@zytor.com,
        tglx@linutronix.de, suresh.b.siddha@intel.com, eranian@google.com,
        brgerst@gmail.com, Andreas.Herrmann3@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Benjamin Block <benjamin.block@amd.com>
Subject: Re: [RFC 4/5] x86, perf: implements lwp-perf-integration (rc1)
Message-ID: <20111220091511.GB3091@elte.hu>
References: <1324051943-21112-1-git-send-email-hans.rosenfeld@amd.com>
 <1324051943-21112-4-git-send-email-hans.rosenfeld@amd.com>
 <20111218080443.GB4144@elte.hu>
 <ae462f089fd4375fe44b09361fb955af@server102.greatnet.de>
 <20111218234309.GA12958@elte.hu>
 <20111219090923.GB16765@erda.amd.com>
 <20111219105429.GC19861@elte.hu>
 <4EEF1C3B.3010307@redhat.com>
 <20111219114023.GB29855@elte.hu>
 <4EEF26F0.1050709@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EEF26F0.1050709@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
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

* Avi Kivity <avi@redhat.com> wrote:

> On 12/19/2011 01:40 PM, Ingo Molnar wrote:
> >
> > 2) the proper solution: creating a 'user-space vmalloc()' that 
> >    is per mm and that gets inherited transparently, across 
> >    fork() and exec(), and which lies outside the regular vma
> >    spaces. On 64-bit this should be straightforward.
> 
> That probably has uses outside perf too, but I can see mm nacks piling up.

This can be done in arch/x86/ code if it's too x86 specific - 
the platform controls the VM layout and can (and does) use 
special per CPU VM areas.

> >    These vmas are not actually 'known' to user-space 
> >    normally - the kernel PMU code knows about it and does 
> >    what we do with PEBS: flushes it when necessary and puts 
> >    it into the regular perf event channels.
> >
> >    This solves the inherited perf record workflow 
> >    immediately: the parent task just creates the buffer, 
> >    which gets inherited across exec() and fork(), into every 
> >    portion of the workload.
> 
> The buffer still needs to be managed. [...]

Of course, like we manage the DS buffer for PEBS.

> [...]  While you may be able to juggle different threads on 
> the same cpu using different events, threads on other cpus 
> need to use separate LWP contexts and buffers.

Yes, like different threads on different CPUs have different DS 
buffers, *here and today*.

Try this on (most) modern Intel CPUs:

  perf top -e cycles:pp

That will activate that exact mechanism.

The LWPCB and the LWP ring-buffer are really just an extension 
of that concept: per task buffers which are ring 3 visible. 

Note that user-space does not actually have to know about any of 
these LWP addresses (but can access them if it wants to - no 
strong feelings about that) - in the correctly implemented model 
it's fully kernel managed.

In fact the PEBS case had one more complication: there's the BTS 
branch-tracing feature which we support as well, and which 
overlaps PEBS use of the DS.

All these PMU hardware limitations can be supported, as long as 
the instrumentation *capability* adds value to the system in one 
way or another.

> >    System-wide profiling is a small additional variant of 
> >    this: creating such a user-vmalloc() area for all tasks 
> >    in the system so that the PMU code has them ready in the 
> >    context-switch code.
> 
> What about security?  Do we want to allow any userspace 
> process to mess up the buffers?  It can even reprogram the LWP 
> block, so you're counting different things, or at higher 
> frequencies, or into other processes ordinary vmas?

In most usecases it's the application messing up its own 
profiling - don't do that if it hurts.

I'd argue that future LWP versions should allow kernel-protected 
LWP pages, as long as the LWPCB is privileged as well as well. 
That would be useful for another purpose as well: LWP could be 
allowed to sample kernel-space execution as well, an obviously 
useful feature that was left out from LWP for barely explicable 
reasons.

Granted, LWP was mis-designed to quite a degree, those AMD chip 
engineers should have talked to people who understand how modern 
PMU abstractions are added to the OS kernel properly. But this 
mis-design does not keep us from utilizing this piece of 
hardware intelligently. PEBS/DS/BTS wasnt a beauty either.

> You could rebuild the LWP block on every context switch I 
> guess, but you need to prevent access to other cpus' LWP 
> blocks (since they may be running other processes).  I think 
> this calls for per-cpu cr3, even for threads in the same 
> process.

Why would we want to rebuild the LWPCB? Just keep one per task 
and do a lightweight switch to it during switch_to() - like we 
do it with the PEBS hardware-ring-buffer. It can be in the same 
single block of memory with the ring-buffer itself. (PEBS has 
similar characteristics)

Thanks,

	Ingo
