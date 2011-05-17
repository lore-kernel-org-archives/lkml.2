Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561Ab1EQPXF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 11:23:05 -0400
Received: from db3ehsobe004.messaging.microsoft.com ([213.199.154.142]:4794
	"EHLO DB3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755218Ab1EQPXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 11:23:03 -0400
X-SpamScore: -8
X-BigFish: VPS-8(zz1432N98dKzz1202hzzz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LLCIP5-01-1VI-02
X-M-MSG: 
Date: Tue, 17 May 2011 17:22:11 +0200
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "hpa@zytor.com" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Richter, Robert" <robert.richter@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC v3 0/8] x86, xsave: rework of extended state handling, LWP
 support
Message-ID: <20110517152210.GA16336@escobedo.osrc.amd.com>
References: <4D91FA76.1010908@zytor.com>
 <1302018656-586370-1-git-send-email-hans.rosenfeld@amd.com>
 <20110407072305.GA20291@elte.hu>
 <20110516191012.GA575@escobedo.osrc.amd.com>
 <20110517113020.GA13475@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110517113020.GA13475@elte.hu>
Organization: Advanced Micro Devices GmbH, Einsteinring 24, 85609 Dornach b.
 Muenchen; Geschaeftsfuehrer: Andrew Bowd, Alberto Bozzo; Sitz: Dornach,
 Gemeinde Aschheim, Landkreis Muenchen; Registergericht Muenchen, HRB Nr.
 43632
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 07:30:20AM -0400, Ingo Molnar wrote:
> Regarding the LWP bits, that branch was indeed excluded because of that crash, 
> while re-checking the branch today i noticed at least one serious design error 
> in it, which makes me reconsider the whole thing:

If you don't like the patch to enable LWP, you could leave that one out
for now. The other xsave rework patches are necessary for LWP, but they
also make sense in their own right.
 
> - Where is the hardware interrupt that signals the ring-buffer-full condition
>   exposed to user-space and how can user-space wait for ring buffer events?
>   AFAICS this needs to set the LWP_CFG MSR and needs an irq handler, which 
>   needs kernel side support - but that is not included in these
>   patches.

This is not strictly necessary. All that the LWP patch does is enable a
new instruction set that can be used without any support for interrupts.
A user process tracing itself with LWP can always poll the ring buffer.

>   The way we solved this with Intel's BTS (and PEBS) feature is that there's
>   a per task hardware buffer that is coupled with the event ring buffer, so
>   both setup and 'waiting' for the ring-buffer happens automatically and
>   transparently because tools can already wait on the ring-buffer.
> 
>   Considerable effort went into that model on the Intel side before we merged
>   it and i see no reason why an AMD hw-tracing feature should not have this 
>   too...

I don't see how that is related to LWP, which by design only works in
user space and directly logs to user space buffers.

>   [ If that is implemented we can expose LWP to user-space as well (which can
>     choose to utilize it directly and buffer into its own memory area without 
>     irqs and using polling, but i'd generally discourage such crude event 
>     collection methods). ]

Well, thats exactly how LWP is supposed to work. Its all user space. It
works only in user mode and it logs directly to a buffer in virtual
address space of the process being traced. The kernel doesn't have to
care at all about LWP for basic functionality, given that it enables the
instruction set and saving/restoring of the LWP state. Enabling the LWP
interrupt and relaying that as a signal or whatever is completely
optional and can be done later if necessary.

> - LWP is exposed indiscriminately, without giving user-space a chance to 
>   disable it on a per task basis. Security-conscious apps would want to disable
>   access to the LWP instructions - which are all ring 3 and unprivileged! We
>   already allow this for the TSC for example. Right now sandboxed code like
>   seccomp would get access to LWP as well - not good. Some intelligent
>   (optional) control is needed, probably using cr0's lwp-enabled bit.

What exactly is the point here? If a program doesn't want to use LWP for
whatever reason, it doesn't have to. No state is saved/restored by
XSAVE/XRSTOR for LWP if it is unused. A security-conscious app would
also not allow any LD_PRELOADs or anything like that which could use LWP
behind its back. What exactly is gained by disabling it, except for
breaking the specification?

Note that there is only one way to disable LWP, and that is clearing the
LWP bit in the XFEATURE_ENABLED_MASK in XCR0. Messing with that in a
running system will cause a lot of pain.

> There are a couple of other items as well:
> 
> - The LWP_CFG has other features as well, such as the ability to aggregate 
>   events amongst cores. This is not exposed either. This looks like a lower 
>   prio, optional item which could be offered after the first patches went
>   upstream.

I don't see that anywhere in the specification, where did you find that?

> - like we do it for PEBS with the perf_attr.precise attribute, it would be nice 
>   to report not RIP+1 but the real RIP itself. On Intel we use LBR to discover 
>   the previous instruction, this might not be possible on AMD CPUs.
> 
>   One solution would be to disassemble the sampled instruction and approximate 
>   the previous one by assuming that it's the preceding instruction (for 
>   branches and calls this might not be true). If we do this then the event::FUS 
>   bit has to be taken into account - in case the CPU has fused the instruction
>   and we have a two instructions delay in reporting.
> 
>   In any case, this is an optional item too and v1 support can be merged 
>   without trying to implement precise RIP support.
> 
> - there are a few interesting looking event details that we'd want to expose
>   in a generalized manner: branch taken/not taken bit, branch prediction 
>   hit/miss bit, etc.
> 
>   This too is optional.
> 
> - The LWPVAL instruction allows the user-space generation of samples. There
>   needs to be a matching generic event for it, which is then inserted into the 
>   perf ring-buffer. Similarly, LWPINS needs to have a matching generic record 
>   as well, so that user-space can decode it.
> 
>   This too looks optional to me.
> 
> - You'd eventually want to expose the randomization (bits 60-63 in the LWPCB)
>   feature as well, via an attribute bit. Ditto for filtering such as cache
>   latency filtering, which looks the most useful. The low/high IP filter could 
>   be exposed as well. All optional. For remaining featurities if there's no sane
>   way to expose them generally we can expose a raw event field as
>   well and have a raw event configuration space to twiddle these details.
> 
> In general LWP is pretty neat and i agree that we want to offer it, it offers
> access to five top categories of hw events (which we also have generalized):
> 
>  - instructions
>  - branches
>  - the most important types of cache misses
>  - CPU cycles
>  - constant (bus) cycles
> 
>  - user-space generated events/samples
> 
> So it will fit nicely into our existing scheme of how we handle PMU features
> and generalizations.

I don't quite understand what you are proposing here. The LWPCB is
controlled by the user space application that traces itself, so all of
it is already exposed by the hardware. The samples are directly logged to
the user space buffer by the hardware, so there is no work to do for the
kernel here. Any post-processing of the samples (for precise RIP or
such) needs to be done in the user space.

We had some discussions about how to make LWP more accessible to
users. Having LWP support in perf would certainly be nice, but the
implementation would be very much different from that for other PMUs.
LWP does almost everything in hardware that perf does in the kernel.

As I said before, with this patch I'm enabling a new instruction set and
associated extended state. How exactly user programs use it, and how it
might fit into existing PMU APIs and tools is not really that important
now.

> Here are a couple of suggestions to LWP hardware designers:
> 
>  - the fact that LWP cannot count kernel events right now is unfortunate - 
>    there's no reason not to allow privileged user-space to request ring 3
>    events as well - hopefully this misfeature will be fixed in future 
>    iterations of the hardware.
> 
>  - it would be nice to allow the per task masking/unmasking of LWP without
>    having to modify the cr0 (which can be expensive). A third mode
>    implemented in the LWP_CFG MSG would suffice: it would make the LWP
>    instructions privileged, but would otherwise allow LWP event collection
>    to occur even on sandboxed code.
> 
>  - it would be nice to also log the previous retired instruction in the
>    trace entry, to ease decoding of the real instruction that generated
>    an event. (Fused instructions can generate their RIP at the first
>    instruction.)

I will forward this to our hardware designers, but I have my doubts
about the first two of your suggestions. They seem to be orthogonal to
what LWP is supposed to be.


Hans


-- 
%SYSTEM-F-ANARCHISM, The operating system has been overthrown

