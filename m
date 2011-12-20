Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394Ab1LTSmG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 13:42:06 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47499 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557Ab1LTSmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 13:42:01 -0500
Date: Tue, 20 Dec 2011 19:40:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joro@8bytes.org>
Cc: Avi Kivity <avi@redhat.com>, Robert Richter <robert.richter@amd.com>,
        Benjamin Block <bebl@mageta.org>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>, hpa@zytor.com,
        tglx@linutronix.de, suresh.b.siddha@intel.com, eranian@google.com,
        brgerst@gmail.com, Andreas.Herrmann3@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Benjamin Block <benjamin.block@amd.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC 4/5] x86, perf: implements lwp-perf-integration (rc1)
Message-ID: <20111220184004.GE8408@elte.hu>
References: <20111218234309.GA12958@elte.hu>
 <20111219090923.GB16765@erda.amd.com>
 <20111219105429.GC19861@elte.hu>
 <4EEF1C3B.3010307@redhat.com>
 <20111219114023.GB29855@elte.hu>
 <4EEF26F0.1050709@redhat.com>
 <20111220091511.GB3091@elte.hu>
 <4EF05996.8030807@redhat.com>
 <20111220100916.GA20788@elte.hu>
 <20111220152758.GA30127@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111220152758.GA30127@8bytes.org>
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


* Joerg Roedel <joro@8bytes.org> wrote:

> Hi Ingo,
> 
> On Tue, Dec 20, 2011 at 11:09:17AM +0100, Ingo Molnar wrote:
> > >
> > > No, it's worse.  They are ring 3 writeable, and ring 3 
> > > configurable.
> > 
> > Avi, i know that very well.
> 
> So you agree that your ideas presented in this thread of 
> integrating LWP into perf have serious security implications?

No, i do not agree at all - you are drastically misrepresending 
my position.

> > > btw, that means that the intended use case - 
> > > self-monitoring with no kernel support - cannot be done. 
> > > [...]
> > 
> > Arguably many years ago the hardware was designed for 
> > brain-dead instrumentation abstractions.
> 
> The point of LWP design is, that it doesn't require 
> abstractions except for the threshold interrupt.
> 
> I am fine with integrating LWP into perf as long as it makes 
> sense and does not break the intended usage scenario for LWP.

That's the wrong way around - in reality we'll integrate LWP 
upstream only once it makes sense and works well with the 
primary instrumentation abstraction we have in the kernel.

Otherwise my "sorry, it's not convincing enough yet" NAK against 
the new feature stands.

In fact as per Linus's rules about new kernel features, 
maintainers don't even have to justify NAK's by offering an 
implementation roadmap that would make the feature acceptable.

Me or PeterZ could just say "this feature is too limited and not 
convincing enough yet, sorry".

*You* who are pushing the feature have to convince the objecting 
maintainer that the feature is worth integrating.

But i'm being nice and helpful here by giving you a rough 
technical outline of how you could overcome my "sorry, this is 
not convincing in its current form yet" rejection of the current 
LWP patches.

> 	[ Because LWP is a user-space feature and designed as such,
> 	  forcing it into an abstraction makes software that uses LWP
> 	  unportable. ]
> 
> But Ingo, the ideas you presented in this thread are clearly 
> no-gos.

Nonsense.

> Having a shared per-cpu buffer for LWP data that is read by 
> perf obviously has very bad security implications, as Avi 
> already pointed out. [...]

Stop this stupidity already!

There's no "security implications" whatsoever. LWP is a ring-3 
hw feature and it can do nothing that the user-space app could 
not already do ...

> [...] It also destroys the intended use-case for LWP because 
> it disturbs any process that is doing self-profiling with LWP.

Why would it destroy that? Self-profiling can install events 
just fine, the kernel will arbitrate the resource.

The 'intended usecase' is meaningless to me - it was done in 
some closed process apparently not talking to anyone who knows a 
bit about Linux instrumentation. If you want this code upstream 
then you need to convince me that the feature makes sense in the 
general and current scheme of things.

I've outlined the (rather workable) technical roadmap for that.

> > Note that as i said user-space *can* acccess the area if it 
> > thinks it can do it better than the kernel (and we could 
> > export that information in a well defined way - we could do 
> > the same for PEBS as well) - i have no particular strong 
> > feelings about allowing that other than i think it's an 
> > obviously inferior model - *as long* as proper, generic, 
> > usable support is added.
> 
> LWP can't be compared in any serious way with PEBS. The only 
> common thing is the hardware-managed ring-buffer. [...]

Which ring-buffer is actually happens to be one of the main 
things that has to be managed ...

> [...] But PEBS is an addition to MSR based performance 
> monitoring resources (for which a kernel abstraction makes a 
> lot of sense) and can only be controlled from ring 0 while LWP 
> is a complete user-space controlled PMU which has no link at 
> all to the MSR-based, ring 0 controlled PMU.

It's a ring-3 controlled PMU feature, not a user-space PMU 
feature. It *can* be controlled by user-space - but it obviously 
can also (and i argue, it should be) - managed by the kernel, 
under Linux.

The kernel is running ring-3 code as well, and it's managing 
ring-3 accessible resources as well, there's nothing new about 
that.

> > From my perspective there's really just one realistic option 
> > to accept this feature: if it's properly fit into existing, 
> > modern instrumentation abstractions. I made that abundantly 
> > clear in my feedback so far.
> 
> The threshold interrupt fits well into the perf-abstraction 
> layer. Even self-monitoring of processes does, and Hans posted 
> patches from Benjamin for that.  What do you think about this 
> approach?

As as i said it's a promising first step - although the 
discussion here convinced me that it needs to be even more 
feature complete, i don't really see that you guys understand 
how such things should be implemented.

You seem to be dead set on supporting a weird special case 
'intended workload' while forgetting the *much* more common 
profilin workloads we have under Linux.

I don't mind supporting weird stuff as well, but you have to 
keep the common case in mind ...

I'd like to see the ring-buffer and the events managed by the 
kernel too, at least so that perf record works fine with this 
PMU feature.

> > User-space can smash it and make it not profile or profile 
> > the wrong thing or into the wrong buffer - but LWP itself 
> > runs with ring3 privileges so it won't do anything the user 
> > couldnt do already.
> 
> The point is, if user-space re-programs LWP it will continue 
> to write its samples to the new ring-buffer virtual-address 
> set up by user-space. It will still use that virtual address 
> in another address-space after a task-switch. This allows 
> processes to corrupt memory of other processes. [...]

That's nonsense. As i said it my previous mail the LWPC should 
be per task and switched on task switch - just like the DS/PEBS 
context is.

> [...] There are ways to hack around that but these have a 
> serious impact on task-switch costs so this is also no way to 
> go.

We are seeing no problems with this approach under PEBS.

> > Lack of protection against self-misconfiguration-damage is a 
> > benign hardware mis-feature - something for LWP v2 to 
> > specify i guess.
> 
> So what you are saying is (not just here, also in other emails 
> in this thread) that every hardware not designed for perf is 
> crap?

No - PMU hardware designed to not allow the profiling of the 
kernel is obviously a crappy aspect of it. Also, PMU hardware 
that does not allow 100% encapsulation by the kernel is 
obviously not very wisely done either.

Those limitations are not a big problem for usable Linux support 
- and future iterations of the LWP hardware can trivially 
address those shortcomings.

> > get_unmapped_area() + install_special_mapping() is probably 
> > better, but yeah.
> 
> get_unmapped_area() only works on current. [...]

Which is a perfectly fine first step to support the
'perf record' inheritance-tree case - which is a very
common profiling method.

> [...] So it can't be used for that purpose too. [...]

Hey, i wrote bits of get_unmapped_area(), way back. I had code 
on my machine that inserted vmas into other tasks's address 
spaces and can confirm that it works. Do you take my word for it 
that it's possible?

Firstly, the perf record case - which is an important, primary 
workflow - can work with the code as-is just fine.

Secondly, for system-wide profiling vmas can be inserted into 
another task's mm context just fine as well: technically we do 
that all the time, when a threaded program is running.

Inserting a vma into another task's mm where that mm is not ours 
is indeed not typical, but not unprecedented either, UML patches 
did that a couple of years ago. (In fact the upcoming uprobes 
patches are doing something far more intrusive.)

The VM modification is trivial AFAICS: an 'mm' parameter has to 
be added to a new do_mmap() variant, that's all - the code is 
already SMP-safe, due to the threaded case.

Otherwise using another task's mm is safe if you acquire it via 
get_task_mm()/mmput().

[ Sidenote: as a bonus this would put infrastructure in place to 
  have user-space accessible trace buffers, insertable via 
  the LWPINS instruction and recoverable via the regular kernel 
  perf event processing facilities. LWP has more potential than
  just self-profiling, if we use the right abstractions... ]

Thanks,

	Ingo
