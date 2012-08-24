Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647Ab2HXBdt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 21:33:49 -0400
Received: from ozlabs.org ([203.10.76.45]:37952 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754016Ab2HXBdp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 21:33:45 -0400
Message-ID: <1345772029.13865.23.camel@concordia>
Subject: Re: [PATCH v4 2/2] powerpc: Uprobes port to powerpc
From: Michael Ellerman <michael@ellerman.id.au>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: ananth@in.ibm.com, ppcdev <linuxppc-dev@lists.ozlabs.org>,
        lkml <linux-kernel@vger.kernel.org>, benh@kernel.crashing.org,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        peterz@infradead.org, oleg@redhat.com, Ingo Molnar <mingo@elte.hu>
Date: Fri, 24 Aug 2012 11:33:49 +1000
In-Reply-To: <20120823053234.GE25338@linux.vnet.ibm.com>
References: <20120822082205.GA29216@in.ibm.com>
	 <20120822082708.GB29216@in.ibm.com> <1345696100.3338.21.camel@concordia>
	 <20120823053234.GE25338@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-23 at 11:02 +0530, Srikar Dronamraju wrote:
> > 
> > These seem to be duplicated in kprobes.h, can we consolidate them.
> > 
> > > +struct arch_uprobe {
> > > +	u8	insn[MAX_UINSN_BYTES];
> > > +};
> > 
> > Why not uprobe_opcode_t insn ?
> > 
> 
> insn is updated/accessed in the arch independent code. Size of
> uprobe_opcode_t could be different for different archs. uprobe_opcode_t
> represents the size of the smallest breakpoint instruction for an arch.
> 
> Hence u8 works out the best. I know we could still use uprobe_opcode_t
> and achieve the same. In which case, we would have to interpret
> MAX_UINSN_BYTES differently. Do you see any advantages of using
> uprobe_opcode_t instead of u8 across archs?

It's not a big deal, just a bit of a nit.

It just feels a bit messy to have uprobe_opcode_t and also expect the
arch code to use an array.

It seems like if we need uprobe_opcode_t then the generic code should
expect to use that everywhere.

Or, we should get ride of uprobe_opcode_t and use u8 (or void *).


> > >  void do_notify_resume(struct pt_regs *regs, unsigned long thread_info_flags)
> > >  {
> > > +	if (thread_info_flags & _TIF_UPROBE) {
> > > +		clear_thread_flag(TIF_UPROBE);
> > > +		uprobe_notify_resume(regs);
> > > +	}
> > 
> > Presumably this ordering is crucial, ie. uprobes before signals.
> > 
> 
> Yes, we would want uprobes to have a say before do_signal can take a
> look.

A comment would be good IMHO, so in 10 years we don't forget.

> > I am probably missing something, but why do we need to execute out of
> > line?
> 
> The other alternative to execute out of line is the current inline
> singlestepping. In inline singlestepping, we would have to guard other
> tasks from executing the same instruction. 
> 
> Executing out of line solves this problem.

Yeah ignore that, I was forgetting that the original trap is caused by a
patched instruction.

> > > +/**
> > > + * uprobe_get_swbp_addr - compute address of swbp given post-swbp regs
> > > + * @regs: Reflects the saved state of the task after it has hit a breakpoint
> > > + * instruction.
> > > + * Return the address of the breakpoint instruction.
> > > + */
> > > +unsigned long uprobe_get_swbp_addr(struct pt_regs *regs)
> > > +{
> > > +	return instruction_pointer(regs);
> > > +}
> > 
> > This seems like it would be better in asm/uprobes.h as a static inline,
> > but that's not your fault.
> > 
> 
> We want archs to override uprobe_get_swbp_addr() if the default
> uprobe_get_swbp_addr() doesnt suite for a particular arch. Do you have
> better ways to achieve this. Initially we were using arch specific
> callbacks from which we moved to using weak functions based on reviews.

OK, having a default that is weak makes sense if there is one behaviour
that is common across arches, but a few arches need to override it. A
static inline in the arch header is simpler if the behaviour is actually
different across all arches.

The current default implements the x86 behaviour, where the instruction
pointer has moved past the breakpoint instruction.

What does ARM do? ie. is this behaviour actually the right default?

> > > +	/*
> > > +	 * emulate_step() returns 1 if the insn was successfully emulated.
> > > +	 * For all other cases, we need to single-step in hardware.
> > > +	 */
> > > +	ret = emulate_step(regs, insn);
> > > +	if (ret > 0)
> > > +		return true;
> > 
> > This actually emulates the instruction, ie. the contents of regs are
> > changed based on the instruction.
> > 
> > That seems to differ vs x86, where arch_uprobe_skip_sstep() just checks
> > the instruction and returns true/false. Is that because on x86 they are
> > only returning true for nops? ie. there is no emulation to be done?
> > 
> 
> Yes, In x86, we currently support skip for nop instructions, Once we add
> code for skipping other instructions in x86, we could enhance them to
> skip them too.

(and emulating them right?)

> > It's a little surprising that can_skip_sstep() actually emulates the
> > instruction, but again that's not your fault.
> 
> Are you saying its doing more than what the name suggests or to the fact
> that can_skip_step should ideally be called just once?

Yeah just that the name suggests it is just a "checker" function, but it
actually emulates the instruction and changes the task state!

cheers



