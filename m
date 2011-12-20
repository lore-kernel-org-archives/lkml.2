Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701Ab1LTP2F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 10:28:05 -0500
Received: from 8bytes.org ([88.198.83.132]:52941 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318Ab1LTP2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 10:28:00 -0500
Date: Tue, 20 Dec 2011 16:27:59 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@redhat.com>, Robert Richter <robert.richter@amd.com>,
        Benjamin Block <bebl@mageta.org>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>, hpa@zytor.com,
        tglx@linutronix.de, suresh.b.siddha@intel.com, eranian@google.com,
        brgerst@gmail.com, Andreas.Herrmann3@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Benjamin Block <benjamin.block@amd.com>
Subject: Re: [RFC 4/5] x86, perf: implements lwp-perf-integration (rc1)
Message-ID: <20111220152758.GA30127@8bytes.org>
References: <ae462f089fd4375fe44b09361fb955af@server102.greatnet.de> <20111218234309.GA12958@elte.hu> <20111219090923.GB16765@erda.amd.com> <20111219105429.GC19861@elte.hu> <4EEF1C3B.3010307@redhat.com> <20111219114023.GB29855@elte.hu> <4EEF26F0.1050709@redhat.com> <20111220091511.GB3091@elte.hu> <4EF05996.8030807@redhat.com> <20111220100916.GA20788@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111220100916.GA20788@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Tue, Dec 20, 2011 at 11:09:17AM +0100, Ingo Molnar wrote:
> > No, it's worse.  They are ring 3 writeable, and ring 3 
> > configurable.
> 
> Avi, i know that very well.

So you agree that your ideas presented in this thread of integrating LWP
into perf have serious security implications?

> > btw, that means that the intended use case - self-monitoring 
> > with no kernel support - cannot be done. [...]
> 
> Arguably many years ago the hardware was designed for brain-dead 
> instrumentation abstractions.

The point of LWP design is, that it doesn't require abstractions except
for the threshold interrupt.

I am fine with integrating LWP into perf as long as it makes sense and
does not break the intended usage scenario for LWP.

	[ Because LWP is a user-space feature and designed as such,
	  forcing it into an abstraction makes software that uses LWP
	  unportable. ]

But Ingo, the ideas you presented in this thread are clearly no-gos.
Having a shared per-cpu buffer for LWP data that is read by perf
obviously has very bad security implications, as Avi already pointed
out. It also destroys the intended use-case for LWP because it disturbs
any process that is doing self-profiling with LWP.

> Note that as i said user-space *can* acccess the area if it 
> thinks it can do it better than the kernel (and we could export 
> that information in a well defined way - we could do the same 
> for PEBS as well) - i have no particular strong feelings about 
> allowing that other than i think it's an obviously inferior 
> model - *as long* as proper, generic, usable support is added.

LWP can't be compared in any serious way with PEBS. The only common
thing is the hardware-managed ring-buffer. But PEBS is an addition to
MSR based performance monitoring resources (for which a kernel
abstraction makes a lot of sense) and can only be controlled from ring 0
while LWP is a complete user-space controlled PMU which has no link at
all to the MSR-based, ring 0 controlled PMU.

> From my perspective there's really just one realistic option to 
> accept this feature: if it's properly fit into existing, modern 
> instrumentation abstractions. I made that abundantly clear in my 
> feedback so far.

The threshold interrupt fits well into the perf-abstraction layer. Even
self-monitoring of processes does, and Hans posted patches from Benjamin
for that.  What do you think about this approach?

> User-space can smash it and make it not profile or profile the 
> wrong thing or into the wrong buffer - but LWP itself runs with 
> ring3 privileges so it won't do anything the user couldnt do 
> already.

The point is, if user-space re-programs LWP it will continue to write
its samples to the new ring-buffer virtual-address set up by user-space.
It will still use that virtual address in another address-space after a
task-switch. This allows processes to corrupt memory of other processes.
There are ways to hack around that but these have a serious impact on
task-switch costs so this is also no way to go.

> Lack of protection against self-misconfiguration-damage is a 
> benign hardware mis-feature - something for LWP v2 to specify i 
> guess.

So what you are saying is (not just here, also in other emails in this
thread) that every hardware not designed for perf is crap?

> get_unmapped_area() + install_special_mapping() is probably 
> better, but yeah.

get_unmapped_area() only works on current. So it can't be used for
that purpose too. Please believe me, we considered and evaluated a lot
of ways to install a mapping into a different process, but none of them
worked out. It is clearly not possible in a sane way without major
changes to the VMM code. Feel free to show us a sane way if you disagree
with that.

So okay, where are we now? We have patches from Hans that make LWP
mostly usable in the way it is intended for. There are already a lot of
people waiting for this to support LWP in the kernel (and they want to
use it in the intended way, not via perf). And we have patches from
Benjamin adding the missing threshold interrupt and a self-monitoring
abstraction of LWP for perf. Monitoring other processes using perf is
not possible because we can't reliably install a mapping into another
process. System wide monitoring has bad security implications and
destroys the intended use-cases. So as I see it, the only abstraction
for integrating LWP into perf that is feasible is posted in this thread.
Can we agree to focus on the posted approach?


Thanks,

	Joerg

