Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932940Ab1ERNwR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 09:52:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47670 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932837Ab1ERNwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 09:52:15 -0400
Date: Wed, 18 May 2011 15:51:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hans Rosenfeld <hans.rosenfeld@amd.com>
Cc: "hpa@zytor.com" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Richter, Robert" <robert.richter@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC v3 0/8] x86, xsave: rework of extended state handling, LWP
 support
Message-ID: <20110518135156.GA6405@elte.hu>
References: <4D91FA76.1010908@zytor.com>
 <1302018656-586370-1-git-send-email-hans.rosenfeld@amd.com>
 <20110407072305.GA20291@elte.hu>
 <20110516191012.GA575@escobedo.osrc.amd.com>
 <20110517113020.GA13475@elte.hu>
 <20110517152210.GA16336@escobedo.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110517152210.GA16336@escobedo.osrc.amd.com>
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


* Hans Rosenfeld <hans.rosenfeld@amd.com> wrote:

> On Tue, May 17, 2011 at 07:30:20AM -0400, Ingo Molnar wrote:
> > Regarding the LWP bits, that branch was indeed excluded because of that crash, 
> > while re-checking the branch today i noticed at least one serious design error 
> > in it, which makes me reconsider the whole thing:
> 
> If you don't like the patch to enable LWP, you could leave that one out
> for now. The other xsave rework patches are necessary for LWP, but they
> also make sense in their own right.
>  
> > - Where is the hardware interrupt that signals the ring-buffer-full condition
> >   exposed to user-space and how can user-space wait for ring buffer events?
> >   AFAICS this needs to set the LWP_CFG MSR and needs an irq handler, which 
> >   needs kernel side support - but that is not included in these
> >   patches.
> 
> This is not strictly necessary. All that the LWP patch does is enable a
> new instruction set that can be used without any support for interrupts.
> A user process tracing itself with LWP can always poll the ring buffer.

Only allowing the buffer to be polled is like 1980's technology, we can (and 
must) do better than that to expose useful hardware resources ...

LWP has a threshold interrupt and if you utilize it as i suggested it will 
solve this problem.

> >   The way we solved this with Intel's BTS (and PEBS) feature is that there's
> >   a per task hardware buffer that is coupled with the event ring buffer, so
> >   both setup and 'waiting' for the ring-buffer happens automatically and
> >   transparently because tools can already wait on the ring-buffer.
> > 
> >   Considerable effort went into that model on the Intel side before we merged
> >   it and i see no reason why an AMD hw-tracing feature should not have this 
> >   too...
> 
> I don't see how that is related to LWP, which by design only works in user 
> space and directly logs to user space buffers.

Both PEBS/BTS and LWP hw-logs to a buffer in virtual memory - full stop.

PEBS allows this buffer to be kernel privileged. That does not change the 
fundamental model though: the best way to expose such capabilities is via a 
standardized event interface.

> >   [ If that is implemented we can expose LWP to user-space as well (which can
> >     choose to utilize it directly and buffer into its own memory area without 
> >     irqs and using polling, but i'd generally discourage such crude event 
> >     collection methods). ]
> 
> Well, thats exactly how LWP is supposed to work. Its all user space. It works 
> only in user mode and it logs directly to a buffer in virtual address space 
> of the process being traced. The kernel doesn't have to care at all about LWP 
> for basic functionality, given that it enables the instruction set and 
> saving/restoring of the LWP state. Enabling the LWP interrupt and relaying 
> that as a signal or whatever is completely optional and can be done later if 
> necessary.

This is a very poor model of exposing a useful (and valuable) CPU hardware 
resource to user-space. Especially since we already have working example of how 
to do a proper model via the PEBS/BTS code.

To give an example of where we turn a low level hardware resource into a higher 
level concept: for example USB disks are primarily designed to be throw-away 
containers of user space controlled trash - thus is the right way to expose 
them would be to give the raw USB disk to user-space?

I don't think so, instead what we do is that we have kernel support for USB 
disks which enumerates and organizes them into storage devices and we put 
filesystems on them - so that apps can access an USB stick via standardized 
APIs - without actually tools being particularly USB-aware.

There's still raw USB devices available which you can use if you really want 
(or need) to, but 99% of the usage is via standardized, higher level 
interfaces.
 
I'm sure you'll agree that this kind of standardization and abstraction helps!

We are trying to do something rather similar with PEBS/BTS and want to fit LWP 
into that as well.

> > - LWP is exposed indiscriminately, without giving user-space a chance to 
> >   disable it on a per task basis. Security-conscious apps would want to disable
> >   access to the LWP instructions - which are all ring 3 and unprivileged! We
> >   already allow this for the TSC for example. Right now sandboxed code like
> >   seccomp would get access to LWP as well - not good. Some intelligent
> >   (optional) control is needed, probably using cr0's lwp-enabled bit.
> 
> What exactly is the point here? If a program doesn't want to use LWP for 
> whatever reason, it doesn't have to. [...]

The point is risk (surface of attack) reduction: in Linux there's support for 
heavily sandboxed code, for which today we even turn the RDTSC instruction off. 
(see my mail to Joerg for specific details about seccomp)

There's security models where they want to run untrusted assembly code but want 
to reduce the attack surface as much as possible. Such code wants to be able to 
exclude the LWP instructions from being used by sandboxed code.

> [...] No state is saved/restored by XSAVE/XRSTOR for LWP if it is unused. A 
> security-conscious app would also not allow any LD_PRELOADs or anything like 
> that which could use LWP behind its back. What exactly is gained by disabling 
> it, except for breaking the specification?

The gain is to optionally allow it for sandboxing host code to turn off CPU 
resources it does not want to expose. LWP is a whole new set of (rather 
complex) CPU logic.

> Note that there is only one way to disable LWP, and that is clearing the LWP 
> bit in the XFEATURE_ENABLED_MASK in XCR0. Messing with that in a running 
> system will cause a lot of pain.

We already modify cr0 in certain circumstances so it's possible and robust but 
indeed it's not particularly common at the moment - nor will it be the common 
case in the future.

> > There are a couple of other items as well:
> > 
> > - The LWP_CFG has other features as well, such as the ability to aggregate 
> >   events amongst cores. This is not exposed either. This looks like a lower 
> >   prio, optional item which could be offered after the first patches went
> >   upstream.
> 
> I don't see that anywhere in the specification, where did you find that?

There's a COREID field in the LWP_CFG MSR, which the spec says should be 
initialized by the OS to the local APIC ID. I did not see this done in the 
patches: it just enables LWP.

The core ID allows a buffering model where software can use a single target 
buffer with multiple threads logging into it. The CoreID field is then used to 
demultiplex which core the event originated from.

The LWP_CFG::COREID field has a reset value of 0, so with the current patches 
if the BIOS forgets to initalize the MSR (not unheard of) we are left with only 
partially working LWP: all-zeroes events and no ability to demux.

( Furthermore, the COREID has a hardware limit of 256 so any system bigger that 
  256 CPUs should gracefully bail out, should software attempt to set up a 
  shared buffer for say 512 cores. )

(I have looked at the revision 3.08 PDF.)

> > - like we do it for PEBS with the perf_attr.precise attribute, it would be nice 
> >   to report not RIP+1 but the real RIP itself. On Intel we use LBR to discover 
> >   the previous instruction, this might not be possible on AMD CPUs.
> > 
> >   One solution would be to disassemble the sampled instruction and approximate 
> >   the previous one by assuming that it's the preceding instruction (for 
> >   branches and calls this might not be true). If we do this then the event::FUS 
> >   bit has to be taken into account - in case the CPU has fused the instruction
> >   and we have a two instructions delay in reporting.
> > 
> >   In any case, this is an optional item too and v1 support can be merged 
> >   without trying to implement precise RIP support.
> > 
> > - there are a few interesting looking event details that we'd want to expose
> >   in a generalized manner: branch taken/not taken bit, branch prediction 
> >   hit/miss bit, etc.
> > 
> >   This too is optional.
> > 
> > - The LWPVAL instruction allows the user-space generation of samples. There
> >   needs to be a matching generic event for it, which is then inserted into the 
> >   perf ring-buffer. Similarly, LWPINS needs to have a matching generic record 
> >   as well, so that user-space can decode it.
> > 
> >   This too looks optional to me.
> > 
> > - You'd eventually want to expose the randomization (bits 60-63 in the LWPCB)
> >   feature as well, via an attribute bit. Ditto for filtering such as cache
> >   latency filtering, which looks the most useful. The low/high IP filter could 
> >   be exposed as well. All optional. For remaining featurities if there's no sane
> >   way to expose them generally we can expose a raw event field as
> >   well and have a raw event configuration space to twiddle these details.
> > 
> > In general LWP is pretty neat and i agree that we want to offer it, it offers
> > access to five top categories of hw events (which we also have generalized):
> > 
> >  - instructions
> >  - branches
> >  - the most important types of cache misses
> >  - CPU cycles
> >  - constant (bus) cycles
> > 
> >  - user-space generated events/samples
> > 
> > So it will fit nicely into our existing scheme of how we handle PMU features
> > and generalizations.
> 
> I don't quite understand what you are proposing here. [...]

See Joerg's mail and my mail to Joerg, it outlines the model. Check out how we 
support PEBS today, LWP support will look quite similar to it - the main 
difference being how the buffer is allocated (for LWP it's a userspace buffer 
in the target task's mm, shared with the monitoring task (which can be itself 
as well)) and of course the hw specific configuration and parsing of the 
events.

> [...] The LWPCB is controlled by the user space application that traces 
> itself, so all of it is already exposed by the hardware. The samples are 
> directly logged to the user space buffer by the hardware, so there is no work 
> to do for the kernel here. Any post-processing of the samples (for precise 
> RIP or such) needs to be done in the user space.

Yes, this is similar to the PEBS and BTS model: there too the hardware logs 
automatically, and the kernel gets a threshold interrupt (or drains the queue 
explicitly).

> We had some discussions about how to make LWP more accessible to users. 
> Having LWP support in perf would certainly be nice, but the implementation 
> would be very much different from that for other PMUs. LWP does almost 
> everything in hardware that perf does in the kernel.

Yes, it should be supported similarly to how we support PEBS and BTS today. 
This is a problem that has been solved already, the AMD LWP model is a newer 
incarnation of the concept.

> As I said before, with this patch I'm enabling a new instruction set and 
> associated extended state. How exactly user programs use it, and how it might 
> fit into existing PMU APIs and tools is not really that important now.

How support for a new x86 CPU resource is integrated into the kernel is highly 
important and relevant to me both as an x86 maintainer and as a perf/PMU 
maintainer.

Thanks,

	Ingo
