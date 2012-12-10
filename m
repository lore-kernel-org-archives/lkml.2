Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863Ab2LJO51 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 09:57:27 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:50495 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751490Ab2LJO50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 09:57:26 -0500
Date: Mon, 10 Dec 2012 14:56:58 +0000
From: Will Deacon <will.deacon@arm.com>
To: Jamie Lokier <jamie@shareable.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rabin Vincent <rabin@rab.in>, Ingo Molnar <mingo@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: ftrace: Ensure code modifications are synchronised
 across all cpus
Message-ID: <20121210145658.GE7869@mudshark.cambridge.arm.com>
References: <1354892111.13000.50.camel@linaro1.home>
 <1354894134.17101.44.camel@gandalf.local.home>
 <20121207162346.GW14363@n2100.arm.linux.org.uk>
 <1354898200.17101.50.camel@gandalf.local.home>
 <20121207164530.GX14363@n2100.arm.linux.org.uk>
 <1354900436.17101.58.camel@gandalf.local.home>
 <1354902347.8263.12.camel@linaro1.home>
 <20121210100433.GB6624@mudshark.cambridge.arm.com>
 <1355144537.17101.155.camel@gandalf.local.home>
 <20121210134000.GQ26936@jl-vm1.vm.bytemark.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121210134000.GQ26936@jl-vm1.vm.bytemark.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jamie,

Thanks for summarising the thread so far.

On Mon, Dec 10, 2012 at 01:40:01PM +0000, Jamie Lokier wrote:
> On Fri, 2012-12-07 at 19:02 +0000, Will Deacon wrote:
> > For ARMv7, there are small subsets of instructions for ARM and Thumb which
> > are guaranteed to be atomic wrt concurrent modification and execution of
> > the instruction stream between different processors:
> >
> > Thumb:      The 16-bit encodings of the B, NOP, BKPT, and SVC instructions.
> > ARM:        The B, BL, NOP, BKPT, SVC, HVC, and SMC instructions.
> 
> Thumb 32-bit ftrace call isn't in the above list.
> 
> Questions: does the above concurrent modification guarantee require
> both the old instruction _and_ the new one to be among those listed,
> or is it enough to be just the new one (for example when setting a
> normal software breakpoint, that would be useful)?  Can it be the old
> one and not the new (for example when removing a software breakpoint,
> that would be useful)?  Does that subset mean replacing any of the
> listed instructions by any of the others is ok, or any of the listed
> with another of the same type?

Yes, the target instruction also has to be listed. However,  I only described
the simple cases above... there are a number of exceptions when it comes to
32-bit Thumb-2 encodings of BL (I hinted at one of them before):

	- The two halfwords of a 32-bit BL instruction can each be replaced
	  with the relevant halfword from another BL instruction. This
	  basically means you can change the immediate fields, as I
	  mentioned earlier.

	- The most-significant halfword of a 32-bit BL instruction can be
	  replaced with B, BKPT or SVC (i.e. not NOP).

	- A 16-bit B, BKPT, or SVC instruction can be replaced with the
	  most-significant halfword of a BL instruction.

The latter points mean we can effectively nop out bl instructions, and put
them back again.

> This is what makes me wonder, if it's safe to replace the 32-bit
> mcount call with a 16-bit short jump:
> 
> > On Mon, Dec 10, 2012 at 11:04:05AM +0000, Jon Medhurst (Tixy) wrote:
> > > So this means for things like kprobes which can modify arbitrary kernel
> > > code we are going to need to continue to always use some form of
> > > stop_the_whole_system() function?
> > >
> > > Also, kprobes currently uses patch_text() which only uses stop_machine
> > > for Thumb2 instructions which straddle a word boundary, so this needs
> > > changing?
> 
> Will Deacon replied:
> > Yes; if you're modifying instructions other than those mentioned above, then
> > you'll need to synchronise the CPUs, update the instructions, perform
> > cache-maintenance on the writing CPU and then execute an isb on the
> > executing core (this last bit isn't needed if you're going to go through an
> > exception return to get back to the new code -- depends on how your
> > stop/resume code works).
> 
> If I've understood that exchange, it implies that using patch_text()
> to replace an instruction not in the list of special ones, with a trap
> or jump, isn't ok?  And so it's ok to replace the NOP with a short
> branch (since 16-bit "B" is in the list), but it's not ok to replace
> 16-bit "B" with the 32-bit ftrace call; and the same going the other way?

Well, these restrictions only apply if you want to avoid synchronising the
CPUs. Hopefully my explanation above answers your questions!

Will
