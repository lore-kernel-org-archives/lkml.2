Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932878Ab1ERLAQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 07:00:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39118 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932863Ab1ERLAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 07:00:14 -0400
Date: Wed, 18 May 2011 12:59:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joro@8bytes.org>
Cc: Hans Rosenfeld <hans.rosenfeld@amd.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC v3 0/8] x86, xsave: rework of extended state handling, LWP
 support
Message-ID: <20110518105956.GA16556@elte.hu>
References: <4D91FA76.1010908@zytor.com>
 <1302018656-586370-1-git-send-email-hans.rosenfeld@amd.com>
 <20110407072305.GA20291@elte.hu>
 <20110516191012.GA575@escobedo.osrc.amd.com>
 <20110517113020.GA13475@elte.hu>
 <20110518081653.GA23407@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110518081653.GA23407@8bytes.org>
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


* Joerg Roedel <joro@8bytes.org> wrote:

> Hi Ingo,
> 
> thanks for your thoughts on this. I have some comments below.
> 
> On Tue, May 17, 2011 at 01:30:20PM +0200, Ingo Molnar wrote:
> 
> > - Where is the hardware interrupt that signals the ring-buffer-full condition
> >   exposed to user-space and how can user-space wait for ring buffer events?
> >   AFAICS this needs to set the LWP_CFG MSR and needs an irq handler, which 
> >   needs kernel side support - but that is not included in these patches.
> > 
> >   The way we solved this with Intel's BTS (and PEBS) feature is that there's
> >   a per task hardware buffer that is coupled with the event ring buffer, so
> >   both setup and 'waiting' for the ring-buffer happens automatically and
> >   transparently because tools can already wait on the ring-buffer.
> > 
> >   Considerable effort went into that model on the Intel side before we merged
> >   it and i see no reason why an AMD hw-tracing feature should not have this 
> >   too...
> > 
> >   [ If that is implemented we can expose LWP to user-space as well (which can
> >     choose to utilize it directly and buffer into its own memory area without 
> >     irqs and using polling, but i'd generally discourage such crude event 
> >     collection methods). ]
> 
> If I understand this correctly you suggest to propagate the lwp-events
> through perf into user-space. This is certainly good because it provides
> a unified interface, but it somewhat elimitates the 'lightweight' part
> of LWP because the samples need to be read by the kernel from user-space
> memory (the lwp-ring-buffer needs to be in user-space memory), convert
> it to perf-samples, and copy it back to user-space. The benefit is the
> unified interface but the 'lightweight' and low-impact part vanishes to
> some degree.

I have two arguments here.

1) it does not matter much in practice

Say we have a large amount of samples: a hundred thousand samples for a second 
worth of application execution. This 100 KHz sampling is already 100 times 
larger than the default we use in tools.

100k samples - the 'lightweight' comes from not having to incur the cost of 
100,000 PMU interrupts spread out with 1000+ overhead cycles each - but being 
able to batch it up in groups.

The copying of the 100k samples means the handling of 3.2 MB of data per 
second. The copying itself is *negligible* - this is from an ancient AMD box:

 phoenix:~> perf bench mem memcpy
 # Running mem/memcpy benchmark...
 # Copying 1MB Bytes ...

     727.802038 MB/Sec
       1.949227 GB/Sec (with prefault)

On modern CPUs it ought to be in the 0.1% overhead range. For usual sampling 
rates the copying would be in the 0.001% overhead range.

And for that we get a much better abstraction and much better tooling model. 
The decision is a no-brainer really.

Note that if user-space *really* wants to get rid of even this overhead it can 
use the instructions in a raw way. I expect that to have the fate of 
sendfile(): zero-copy was trumpeted to be a big performance thing but in 
practice it rarely mattered, usability was what kept people on read()/write().

[ and compared to raw LWP instructions the usability disadvantage of sendfile() 
  is almost non-existent. ]

2) there's no contradiction: lightweight access can be supported in the perf 
   abstraction as well

While the PEBS buffer is not exposed to user-space, we can expose the buffer in 
the LWP case and make 'raw collection' possible. As long as the standard 
facilities are used to *configure* profiling and as long as the standard 
facilities are used for the threshold irq functionality, etc. this is not 
something i object to.

And if zero copying matters a lot, then regular tools will use that facility as 
well.

> Also, LWP is somewhat different from the old-style PMU. LWP is designed
> for self-monitoring of applications that want to optimize themself at
> runtime, like JIT compilers (Java, LVMM, ...) or databases. For those
> applications it would be good to keep LWP as lightweight as possible.

That goal does not contradict the sane resource management and synchronization 
requirements i outlined.

> The missing support for interupts is certainly a problem here which 
> significantly limits the usefulness of the feature for now. [...]

Yes, that's the key observation.

> [...] My idea was to expose the interupt-event through perf to user-space so 
> that the application can wait on that event to read out the LWP ring-buffer.

The (much) better thing (which you seem to realize later in your mail) is to 
just integrate the buffer and teach the kernel to parse it.

Then *all* tools will be able to utilize this (useful looking) hardware feature 
straight away, with very little modifications needed - the advantage of 
standardized kernel interfaces.

If the CPU guys give us a 'measure kernel mode' bit it as well in the future 
then it will be even more useful all around.

So this is not just about the current first generation hardware, it's also 
about what LWP could very well turn out to look like in the future, using 
obvious extensions.

By making it a limited user-space hack just because LWP *can* be used as such a 
hack we would really risk condemning a very valuable piece of silicon to that 
stupid role forever. It does not have to be used as such a hack and it does not 
have to be condemned to that role.

> But to come back to your idea, it probably could be done in a way to
> enable profiling of other applications using LWP. The kernel needs to
> allocate the lwp ring-buffer and setup lwp itself. [...]

Yes.

> [...] The problem is that the buffer needs to be user-accessible and where to 
> map this buffer:
> 
> 	a) On the kernel-part of the address space. Problematic because
> 	   every process can read the buffer of other tasks. So this is
> 	   a no-go from a security point-of-view.

No, the hardware buffer can (and should) be in user memory. We also want to 
expose it (see raw decoding above), just like we expose raw events.

> 	b) Change the address space layout in a comatible way to allow
> 	   the kernel to map it (e.g. make a small part of the
> 	   kernel-address space per-process). Somewhat intrusive to
> 	   current x86 code, also not sure this feature is worth it.

There's nothing wrong with allocating user memory on behalf of the task, if it 
asks for it (or if the parent or some other controlling task wants to profile 
the task) - we do it in a couple of places in the kernel - the perf subsystem 
itself does it.

> 	c) Some way to let userspace setup such a buffer and give the
> 	   address to the kernel, or we mmap it directly into user
> 	   address space. But that may cause other problems with
> 	   applications that have strict requirements for their
> 	   address-space layout.

A buffer has to be allocated no matter who does it.

> Bottom-line is, we need a good and secure way to setup a user-accessible
> buffer per-process in the kernel. [...]

Correct. It can either be a do_mmap() call, or if we want to handle any aspect 
of it ourselves then it can be done like arch/x86/vdso/vma.c::init_vdso_vars() 
sets up the vdso vma.

We also obviously want to mlock this area (within the perf page-locking 
limits). While the LWP hardware is robust enough to not crash on a not present 
(paged out or not yet paged in) page, spuriously losing samples is not good.

> [...] If we have that we can use LWP to monitor other applications (unless 
> the application decides to use LWP of its own).

Yes!

That's not surprising: the hw feature itself looks pretty decently done, except 
the few things i noted in my first mail which limit its utility needlessly.
[ They could ask us next time around they add a feature like this. ]

> I like the idea, but we should also make sure that we don't prevent the
> low-impact self-monitoring use-case for applications that want it.

Yes, while i dont find that a too interesting usecase i see no problem with 
exposing this 'raw' area to apps that want to parse it directly (in fact the hw 
forces that, because the area has to be ring 3 writable) - as long as the whole 
resource infrastructure of creating and managing it is sane.

The kernel is a resource manager and this is a useful CPU resource.

> > - LWP is exposed indiscriminately, without giving user-space a chance to 
> >   disable it on a per task basis. Security-conscious apps would want to disable
> >   access to the LWP instructions - which are all ring 3 and unprivileged! We
> >   already allow this for the TSC for example. Right now sandboxed code like
> >   seccomp would get access to LWP as well - not good. Some intelligent
> >   (optional) control is needed, probably using cr0's lwp-enabled bit.
> 
> That could certainly be done, but requires an xcr0 write at
> context-switch. JFI, how can the tsc be disabled for a task from
> userspace?

See prctl_set_seccomp()'s disable_TSC call. The scheduler notices the TIF_NOTSC 
flag and twiddles CR4::TSD. TSC disablement is implicit in the seccomp 
execution model.

Here there should be a TIF_NOLWP, tied into seccomp by default and twiddling 
xcr0 at context-switch.

This will be zero overhead by default.

Thanks,

	Ingo
