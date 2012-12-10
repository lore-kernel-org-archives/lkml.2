Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007Ab2LJNkL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 08:40:11 -0500
Received: from mail2.shareable.org ([80.68.89.115]:52421 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284Ab2LJNkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 08:40:10 -0500
Date: Mon, 10 Dec 2012 13:40:01 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Will Deacon <will.deacon@arm.com>, "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rabin Vincent <rabin@rab.in>, Ingo Molnar <mingo@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: ftrace: Ensure code modifications are synchronised
 across all cpus
Message-ID: <20121210134000.GQ26936@jl-vm1.vm.bytemark.co.uk>
References: <1354888985.17101.41.camel@gandalf.local.home>
 <1354892111.13000.50.camel@linaro1.home>
 <1354894134.17101.44.camel@gandalf.local.home>
 <20121207162346.GW14363@n2100.arm.linux.org.uk>
 <1354898200.17101.50.camel@gandalf.local.home>
 <20121207164530.GX14363@n2100.arm.linux.org.uk>
 <1354900436.17101.58.camel@gandalf.local.home>
 <1354902347.8263.12.camel@linaro1.home>
 <20121210100433.GB6624@mudshark.cambridge.arm.com>
 <1355144537.17101.155.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355144537.17101.155.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> > Yes, and I think if you do use two 16-bit nops, you can even get rid of all
> > the intermediate `sync' operations (I guess you might want one at the end if
> > you want the call to become visible at a particular point).
> 
> Wont work. We are replacing a 32bit call with a nop. That nop must also
> be 32bits, because we could eventually replace the nop(s) with a 32bit
> call. Basically, we can never allow the second 16bit part ever be the
> next instruction. If the first 16bit nop is executed, and then the task
> gets preempted. The nops get converted to a 32bit call. The task gets
> scheduled again and now is executing the second 16bits of the 32bit call
> and we get unexpected (probably crashing) results.
> 
> By having either a 16bit breakpoint whose handler returns after the
> second 16bit part, or a 16bit jump that simply jumps over the second
> half, then all this should work. When the CPU processes a 32bit
> instruction, it either processes all or non of it, correct?

Sounds good, except what Will wrote a few days ago:

On Fri, 2012-12-07 at 19:02 +0000, Will Deacon wrote:
> For ARMv7, there are small subsets of instructions for ARM and Thumb which
> are guaranteed to be atomic wrt concurrent modification and execution of
> the instruction stream between different processors:
>
> Thumb:      The 16-bit encodings of the B, NOP, BKPT, and SVC instructions.
> ARM:        The B, BL, NOP, BKPT, SVC, HVC, and SMC instructions.

Thumb 32-bit ftrace call isn't in the above list.

Questions: does the above concurrent modification guarantee require
both the old instruction _and_ the new one to be among those listed,
or is it enough to be just the new one (for example when setting a
normal software breakpoint, that would be useful)?  Can it be the old
one and not the new (for example when removing a software breakpoint,
that would be useful)?  Does that subset mean replacing any of the
listed instructions by any of the others is ok, or any of the listed
with another of the same type?

(I guess as a matter of architecture design, it makes sense to
guarantee only a short list, because of occasions when the hardware,
or a software emulation through traps, or a simulation, might read the
instruction memory more than once.)

This is what makes me wonder, if it's safe to replace the 32-bit
mcount call with a 16-bit short jump:

> On Mon, Dec 10, 2012 at 11:04:05AM +0000, Jon Medhurst (Tixy) wrote:
> > So this means for things like kprobes which can modify arbitrary kernel
> > code we are going to need to continue to always use some form of
> > stop_the_whole_system() function?
> >
> > Also, kprobes currently uses patch_text() which only uses stop_machine
> > for Thumb2 instructions which straddle a word boundary, so this needs
> > changing?

Will Deacon replied:
> Yes; if you're modifying instructions other than those mentioned above, then
> you'll need to synchronise the CPUs, update the instructions, perform
> cache-maintenance on the writing CPU and then execute an isb on the
> executing core (this last bit isn't needed if you're going to go through an
> exception return to get back to the new code -- depends on how your
> stop/resume code works).

If I've understood that exchange, it implies that using patch_text()
to replace an instruction not in the list of special ones, with a trap
or jump, isn't ok?  And so it's ok to replace the NOP with a short
branch (since 16-bit "B" is in the list), but it's not ok to replace
16-bit "B" with the 32-bit ftrace call; and the same going the other way?

Best,
-- Jamie
