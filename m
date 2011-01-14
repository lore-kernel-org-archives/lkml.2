Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757944Ab1ANQfv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 11:35:51 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49375 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab1ANQfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 11:35:45 -0500
Date: Fri, 14 Jan 2011 16:35:20 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Colin Cross <ccross@android.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: vfp: Fix up exception location in Thumb mode
Message-ID: <20110114163520.GH15996@n2100.arm.linux.org.uk>
References: <1294990949-2729-1-git-send-email-ccross@android.com> <AANLkTimqiqABxCejdeOQWZZ62DVUZW2v-yMpdu1aNDQT@mail.gmail.com> <20110114120229.GA15996@n2100.arm.linux.org.uk> <1295014231.7901.41.camel@e102109-lin.cambridge.arm.com> <20110114154919.GE15996@n2100.arm.linux.org.uk> <1295022193.7901.56.camel@e102109-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295022193.7901.56.camel@e102109-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 04:23:12PM +0000, Catalin Marinas wrote:
> On Fri, 2011-01-14 at 15:49 +0000, Russell King - ARM Linux wrote:
> > On Fri, Jan 14, 2011 at 02:10:31PM +0000, Catalin Marinas wrote:
> > > On Fri, 2011-01-14 at 12:02 +0000, Russell King - ARM Linux wrote:
> > > > I don't think this is correct.  On entry to the undefined instruction
> > > > handler, we get the uncorrected PC value, so PC points to the
> > > > instruction after the faulting instruction.
> > > >
> > > > If it was an ARM instruction, that is located at PC-4.  If it was a
> > > > Thumb instruction, it is located at PC-2.  This PC value is passed
> > > > unmodified to the VFP entry code, and the passed r2 reflect the
> > > > value in regs->ARM_pc.
> > >
> > > The entry-armv.S code adds 2 to the r2 register in case of a 32-bit
> > > Thumb instruction, so it is no longer the same as the ARM_pc.
> > 
> > That's something that should be fixed - the entry conditions should be
> > the same irrespective of thumb or arm encoding.
> 
> But in this case you have to fix the vfphw.S code to check for Thumb and
> subtract 2 rather than 4 from r2.

So is this right for Thumb?  Or does it need to be 2 for thumb and 4 for
ARM?  Maybe it needs documenting to say why 4 is always correct (if that
is the case).

check_for_exception:
        tst     r1, #FPEXC_EX
        bne     process_exception       @ might as well handle the pending
                                        @ exception before retrying branch
                                        @ out before setting an FPEXC that
                                        @ stops us reading stuff
        VFPFMXR FPEXC, r1               @ restore FPEXC last
        sub     r2, r2, #4
        str     r2, [sp, #S_PC]         @ retry the instruction

> > > Since the VFP instructions in Thumb mode are always 32-bit, Colin's
> > > patch made sense to me.
> > 
> > I looked up the VADD instruction in the ARM ARM.  It has both a 16-bit
> > and 32-bit encoding.
> 
> Are you sure? The Thumb encoding is made up of two 16-bit values but it
> is still 32-bit in total.

No, I'm not sure - it looks like it is made up from two 16-bit
instructions.

> > At the moment its just confusing as things stand, as some things are
> > changed in one place and not the other.  Let's kill the pointless
> > addition of 2 in the undefined instruction handler so that in every
> > case we enter handlers with r2 == regs->ARM_pc, and regs->ARM_pc
> > as per the ARM ARM undefined exception entry LR.
> > 
> > Undefined instruction exception handlers can then rely on the meaning
> > of both of these.
> 
> That's an alternative, though we may end up with checking the encoding
> twice. The Undef handler already reads the instruction opcode and it
> needs to know whether it is a 16 or a 32-bit wide instruction.

At the moment we add 2 in one place, take off 4 in another, and now
we're going to add 2 in a completely different place.  This is insane.
It's a big mess, one which it's impossible to tell if anything is
correct or even easy to follow what's going on.

I don't really care what it's replaced with provided its replaced by
something sane, easy to follow and obviously correct.
