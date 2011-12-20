Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655Ab1LTKLT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 05:11:19 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59757 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982Ab1LTKLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 05:11:10 -0500
Date: Tue, 20 Dec 2011 11:09:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Robert Richter <robert.richter@amd.com>, Benjamin Block <bebl@mageta.org>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>, hpa@zytor.com,
        tglx@linutronix.de, suresh.b.siddha@intel.com, eranian@google.com,
        brgerst@gmail.com, Andreas.Herrmann3@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Benjamin Block <benjamin.block@amd.com>
Subject: Re: [RFC 4/5] x86, perf: implements lwp-perf-integration (rc1)
Message-ID: <20111220100916.GA20788@elte.hu>
References: <20111218080443.GB4144@elte.hu>
 <ae462f089fd4375fe44b09361fb955af@server102.greatnet.de>
 <20111218234309.GA12958@elte.hu>
 <20111219090923.GB16765@erda.amd.com>
 <20111219105429.GC19861@elte.hu>
 <4EEF1C3B.3010307@redhat.com>
 <20111219114023.GB29855@elte.hu>
 <4EEF26F0.1050709@redhat.com>
 <20111220091511.GB3091@elte.hu>
 <4EF05996.8030807@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EF05996.8030807@redhat.com>
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

> On 12/20/2011 11:15 AM, Ingo Molnar wrote:
>
> > The LWPCB and the LWP ring-buffer are really just an 
> > extension of that concept: per task buffers which are ring 3 
> > visible.
> 
> No, it's worse.  They are ring 3 writeable, and ring 3 
> configurable.

Avi, i know that very well.

> > Note that user-space does not actually have to know about 
> > any of these LWP addresses (but can access them if it wants 
> > to - no strong feelings about that) - in the correctly 
> > implemented model it's fully kernel managed.
> 
> btw, that means that the intended use case - self-monitoring 
> with no kernel support - cannot be done. [...]

Arguably many years ago the hardware was designed for brain-dead 
instrumentation abstractions.

Note that as i said user-space *can* acccess the area if it 
thinks it can do it better than the kernel (and we could export 
that information in a well defined way - we could do the same 
for PEBS as well) - i have no particular strong feelings about 
allowing that other than i think it's an obviously inferior 
model - *as long* as proper, generic, usable support is added.

>From my perspective there's really just one realistic option to 
accept this feature: if it's properly fit into existing, modern 
instrumentation abstractions. I made that abundantly clear in my 
feedback so far.

It can obviously be done, alongside the suggestions i've given.

That was the condition for Intel PEBS/DS/BTS support as well - 
which is hardware that has at least as many brain-dead 
constraints and roadblocks as LWP.

> > > You could rebuild the LWP block on every context switch I 
> > > guess, but you need to prevent access to other cpus' LWP 
> > > blocks (since they may be running other processes).  I 
> > > think this calls for per-cpu cr3, even for threads in the 
> > > same process.
> >
> > Why would we want to rebuild the LWPCB? Just keep one per 
> > task and do a lightweight switch to it during switch_to() - 
> > like we do it with the PEBS hardware-ring-buffer. It can be 
> > in the same single block of memory with the ring-buffer 
> > itself. (PEBS has similar characteristics)
> 
> If it's in globally visible memory, the user can reprogram the 
> LWP from another thread to thrash ordinary VMAs. [...]

User-space can smash it and make it not profile or profile the 
wrong thing or into the wrong buffer - but LWP itself runs with 
ring3 privileges so it won't do anything the user couldnt do 
already.

Lack of protection against self-misconfiguration-damage is a 
benign hardware mis-feature - something for LWP v2 to specify i 
guess.

But i don't want to reject this feature based on this 
mis-feature alone - it's a pretty harmless limitation and the 
precise, skid-less profiling that LWP offers is obviously 
useful.

> [...]  It has to be process local (at which point, you can 
> just use do_mmap() to allocate it).

get_unmapped_area() + install_special_mapping() is probably 
better, but yeah.

Thanks,

	Ingo
