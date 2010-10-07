Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760250Ab0JGKqn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 06:46:43 -0400
Received: from smtp-out.google.com ([74.125.121.35]:60958 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516Ab0JGKql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 06:46:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=NHUFqeEpo4hpDXi8ceGYSrZbfjEslIbISILbOVcGXBPXOSxeYj0XoXlW8xnagHBZA4
         V2F84Yf5a5LW3l/cca0w==
MIME-Version: 1.0
In-Reply-To: <AANLkTi=T0QmcKeZcgcR+GKk-9OwQUB_x8XdHiNuU7tE_@mail.gmail.com>
References: <1286212172-654419-1-git-send-email-hans.rosenfeld@amd.com>
	<alpine.LFD.2.00.1010042358520.2556@localhost6.localdomain6>
	<20101005145155.GD173@escobedo.osrc.amd.com>
	<alpine.LFD.2.00.1010051730060.2556@localhost6.localdomain6>
	<20101005182739.GE173@escobedo.osrc.amd.com>
	<20101005190501.GA21916@elte.hu>
	<20101006073558.GJ13563@erda.amd.com>
	<AANLkTi=T0QmcKeZcgcR+GKk-9OwQUB_x8XdHiNuU7tE_@mail.gmail.com>
Date: Thu, 7 Oct 2010 12:46:34 +0200
Message-ID: <AANLkTimwVuosF24_gBOTpMydfcj-SQPFyZM4uu=vEPbL@mail.gmail.com>
Subject: Re: [RFC 0/3] Basic support for LWP
From: Stephane Eranian <eranian@google.com>
To: mingo@elte.hu
Cc: Hans.Rosenfeld@amd.com, robert.richter@amd.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, hpa@zytor.com, Andreas.Herrmann3@amd.com,
        peterz@infradead.org, fweisbec@gmail.com, rostedt@goodmis.org,
        acme@redhat.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        eranian@gmail.com
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Some comments on all of this.

First of all LWP adds value because it allows collecting information
which is otherwise unavailable or of lesser quality.

LWP is meant to measure only at the user level (only CPL=3). It is
blind for kernel level execution or even priv level 1, 2.

LWP is ALWAYS precise (that's THE key value add in my mind).
It reports the instruction address of the instruction that caused the
counter to overflow. This is true for all events it can measure, including
cache misses.That precision can be be achieved through HW support.

LWP does not have the data pollution of IBS. It only records instructions
that caused the type of event you want to measure. For instance, if you want
to sample cache misses, it collects only data related to instructions that
generate cache misses unlike IBS. It is a radically different approach.
Don't get me wrong, both are useful, it all depends on what you want to measure.

LWP does allow data normalization. You know how many instances of
the sampling events have been observed unlike IBS.

LWP is lightweight in the sense that the HW records samples for you in
a memory buffer. This is similar to PEBS in that regards. But it does not
capture full machine state. It also has a limited number of events.

LWP allows users to insert their own samples in the buffer. That can be
useful to record other kinds of information. Could be use to make this
work in system-wide mode for instance.

The LWP specs has been out for review by EVERYBODY since 2007.
I remember looking at it back then. So the comments about "nobody was
consulted before this got into silicon" is erroneous. Everybody had a chance
to comment.

LWP operates independently from the regular core PMU. Both can be
active at the same time with no problems.

As for the patch itself, I am not an expert at xsave/xrstor, but it seems to
me you could decouple LWP from FPU. I think  Brian had the same comment.
I suspect this can be done and it will certainly look cleaner.

On the comments about integrating this into perf_events. LWP is designed for
self-monitoring ONLY. It can be controlled entirely from user space (once kernel
enables it and has xsave/xrstor support). Thus, it seems natural, at
first, to implement
this into a library that can be either explicitly called by developers
or also implicitly
used via LD_PRELOAD.

But I suspect it could also be implemented as part of perf_events in a
manner similar to PEBS,
using the precise_ip mode to trigger it. This is assuming that the LWP
instructions work at
priv level 0. Both the LWP control block + LWP buffer would be
allocated by the kernel and
yet be accessible from priv level 3. It would also need its own event
encoding as there isn't
necessarily a 1-to-1 mapping with core PMU events. It would also use
the interrupt mode in
this case. In terms of access control from users, I believe it would
be possible to make LWP
invisible to users by tweaking the LWP_CFG register to report no
support and yet have the
kernel control LWP. You'd have to find a way to copy ALL the
information in each LWP record
into the perf sampling buffer format.

What does this buy us?

An integrated solution with perf and the perf tools, no dedicated
library, finer grain access
control. Possibly precise sampling in per-cpu mode (leverage LWPVAL).

What do we lose?

The lightweight aspect of it. There would be syscalls for
setup/start/stop. You'd have
to copy the data between the LWP record format and the perf sampling buffer.
There would be data copying between the two buffers.

Personally I would have gone with the user level stuff as the first
approach, using
polling mode on the LWP buffer,  to evaluate if LWP delivers on its
promise w.r.t.
high quality data, low overhead. But I also understand the motivation
to integrate
this into perf to provide a uniform interface.

But one thing is clear, LWP adds value and I want to access the LWP data because
it is of higher quality than what we can get today on AMD processors.
It can really
help drive certain optimizations, e.g., in compilers.


On Wed, Oct 6, 2010 at 9:35 AM, Robert Richter <robert.richter@amd.com> wrote:
> On 05.10.10 15:05:01, Ingo Molnar wrote:
>
>> So thoughts need to be made what the point of it all is and how it
>> integrates into perf. If it doesnt integrate, if the whole plan is to
>> just get it to user-space where it can be messed up freely in some CPU
>> specific way then color me thoroughly uninterested. We have a generic
>> instrumentation framework for a reason.
>
> I was looking at how this integrates into the perf syscall. It might
> be a little disappointing, but there is not much to do for the kernel.
> Ring buffer handling is implemented in hardware now, the user land
> sets up address ranges in the task's address space for buffers and
> thus may direct access it. We do not need an interrupt handler to fill
> the buffers. The pmu state is saved and restored during context
> switches in ways that has been proven for the fpu (xsave) and
> virtualization (VMCB like LWPCB). So, overall hardware is now doing
> the job for writing samples into a userland buffer and managing the
> pmu state. This reduces system overhead while profiling a lot
> especially because we don't have to walk through a software stack with
> each sample (this is where the 'lightweight' comes from).
>
> Of course this does not fit into current frameworks because of its
> difference in concept, but in general we want to see it in perf. So
> the main work of integration will leave here to tool and library
> implementation. But for this Linux must implement LWP context switch
> support. This is what Hans did.
>
> We also measured the system impact which comes from the additional
> rdmsrl() if the cpu supports LWP. There is no significant performance
> decrease in a worst case scenario. So, this is how we think it is the
> best to implement it and we need your feedback here.
>
> I think we should consider to apply patch 1/3 as it is unrelated to
> LWP and reworks and improves the code.
>
