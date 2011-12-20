Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153Ab1LTJrp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 04:47:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18105 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752806Ab1LTJra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 04:47:30 -0500
Message-ID: <4EF05996.8030807@redhat.com>
Date: Tue, 20 Dec 2011 11:47:02 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Robert Richter <robert.richter@amd.com>, Benjamin Block <bebl@mageta.org>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>, hpa@zytor.com,
        tglx@linutronix.de, suresh.b.siddha@intel.com, eranian@google.com,
        brgerst@gmail.com, Andreas.Herrmann3@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Benjamin Block <benjamin.block@amd.com>
Subject: Re: [RFC 4/5] x86, perf: implements lwp-perf-integration (rc1)
References: <1324051943-21112-1-git-send-email-hans.rosenfeld@amd.com> <1324051943-21112-4-git-send-email-hans.rosenfeld@amd.com> <20111218080443.GB4144@elte.hu> <ae462f089fd4375fe44b09361fb955af@server102.greatnet.de> <20111218234309.GA12958@elte.hu> <20111219090923.GB16765@erda.amd.com> <20111219105429.GC19861@elte.hu> <4EEF1C3B.3010307@redhat.com> <20111219114023.GB29855@elte.hu> <4EEF26F0.1050709@redhat.com> <20111220091511.GB3091@elte.hu>
In-Reply-To: <20111220091511.GB3091@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2011 11:15 AM, Ingo Molnar wrote:
> The LWPCB and the LWP ring-buffer are really just an extension 
> of that concept: per task buffers which are ring 3 visible. 

No, it's worse.  They are ring 3 writeable, and ring 3 configurable.

> Note that user-space does not actually have to know about any of 
> these LWP addresses (but can access them if it wants to - no 
> strong feelings about that) - in the correctly implemented model 
> it's fully kernel managed.

btw, that means that the intended use case - self-monitoring with no
kernel support - cannot be done.  That's not an issue per se, it depends
on the cost of the kernel support and whether any information is lost
(like the records inserted by the explicit LWP instructions).

> In fact the PEBS case had one more complication: there's the BTS 
> branch-tracing feature which we support as well, and which 
> overlaps PEBS use of the DS.

(semi-related: both DS and LWP cannot be used by kvm to monitor a guest
from the host, since they both use virtual addresses)

> All these PMU hardware limitations can be supported, as long as 
> the instrumentation *capability* adds value to the system in one 
> way or another.
>
> > >    System-wide profiling is a small additional variant of 
> > >    this: creating such a user-vmalloc() area for all tasks 
> > >    in the system so that the PMU code has them ready in the 
> > >    context-switch code.
> > 
> > What about security?  Do we want to allow any userspace 
> > process to mess up the buffers?  It can even reprogram the LWP 
> > block, so you're counting different things, or at higher 
> > frequencies, or into other processes ordinary vmas?
>
> In most usecases it's the application messing up its own 
> profiling - don't do that if it hurts.

Not in the system profiling case (not that anything truly bad will
happen, but it's not nice to have the kernel supplying data it can't trust).

> I'd argue that future LWP versions should allow kernel-protected 
> LWP pages, as long as the LWPCB is privileged as well as well. 
> That would be useful for another purpose as well: LWP could be 
> allowed to sample kernel-space execution as well, an obviously 
> useful feature that was left out from LWP for barely explicable 
> reasons.
>
> Granted, LWP was mis-designed to quite a degree, those AMD chip 
> engineers should have talked to people who understand how modern 
> PMU abstractions are added to the OS kernel properly. But this 
> mis-design does not keep us from utilizing this piece of 
> hardware intelligently. PEBS/DS/BTS wasnt a beauty either.

LWP was clearly designed for userspace jits, and clearly designed to
work with minimal kernel support.  For this use case, it wasn't
mis-designed.  Maybe they designed for the wrong requirements and
constraints (for example, it is much harder to get PMU abstractions into
Windows than into Linux), but within those requirements, it appears to
be well done.

I'm worried that shoe-horning LWP into the system profiling role will
result in poor support for that role, *and* prevent its use in the
intended use case.

> > You could rebuild the LWP block on every context switch I 
> > guess, but you need to prevent access to other cpus' LWP 
> > blocks (since they may be running other processes).  I think 
> > this calls for per-cpu cr3, even for threads in the same 
> > process.
>
> Why would we want to rebuild the LWPCB? Just keep one per task 
> and do a lightweight switch to it during switch_to() - like we 
> do it with the PEBS hardware-ring-buffer. It can be in the same 
> single block of memory with the ring-buffer itself. (PEBS has 
> similar characteristics)

If it's in globally visible memory, the user can reprogram the LWP from
another thread to thrash ordinary VMAs.  It has to be process local (at
which point, you can just use do_mmap() to allocate it).

-- 
error compiling committee.c: too many arguments to function

