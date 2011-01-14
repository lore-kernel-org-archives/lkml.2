Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757835Ab1ANQ7D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 11:59:03 -0500
Received: from service87.mimecast.com ([94.185.240.25]:45546 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752339Ab1ANQ6z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 11:58:55 -0500
Subject: Re: [PATCH] ARM: vfp: Fix up exception location in Thumb mode
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Colin Cross <ccross@android.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110114163520.GH15996@n2100.arm.linux.org.uk>
References: <1294990949-2729-1-git-send-email-ccross@android.com>
	 <AANLkTimqiqABxCejdeOQWZZ62DVUZW2v-yMpdu1aNDQT@mail.gmail.com>
	 <20110114120229.GA15996@n2100.arm.linux.org.uk>
	 <1295014231.7901.41.camel@e102109-lin.cambridge.arm.com>
	 <20110114154919.GE15996@n2100.arm.linux.org.uk>
	 <1295022193.7901.56.camel@e102109-lin.cambridge.arm.com>
	 <20110114163520.GH15996@n2100.arm.linux.org.uk>
Organization: ARM Limited
Date: Fri, 14 Jan 2011 16:58:47 +0000
Message-ID: <1295024327.7901.70.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 14 Jan 2011 16:58:48.0279 (UTC) FILETIME=[4FDEA670:01CBB40C]
X-MC-Unique: 111011416585200701
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-14 at 16:35 +0000, Russell King - ARM Linux wrote:
> On Fri, Jan 14, 2011 at 04:23:12PM +0000, Catalin Marinas wrote:
> > On Fri, 2011-01-14 at 15:49 +0000, Russell King - ARM Linux wrote:
> > > On Fri, Jan 14, 2011 at 02:10:31PM +0000, Catalin Marinas wrote:
> > > > On Fri, 2011-01-14 at 12:02 +0000, Russell King - ARM Linux wrote:
> > > > > I don't think this is correct.  On entry to the undefined instruction
> > > > > handler, we get the uncorrected PC value, so PC points to the
> > > > > instruction after the faulting instruction.
> > > > >
> > > > > If it was an ARM instruction, that is located at PC-4.  If it was a
> > > > > Thumb instruction, it is located at PC-2.  This PC value is passed
> > > > > unmodified to the VFP entry code, and the passed r2 reflect the
> > > > > value in regs->ARM_pc.
> > > >
> > > > The entry-armv.S code adds 2 to the r2 register in case of a 32-bit
> > > > Thumb instruction, so it is no longer the same as the ARM_pc.
> > >
> > > That's something that should be fixed - the entry conditions should be
> > > the same irrespective of thumb or arm encoding.
> >
> > But in this case you have to fix the vfphw.S code to check for Thumb and
> > subtract 2 rather than 4 from r2.
> 
> So is this right for Thumb?  Or does it need to be 2 for thumb and 4 for
> ARM?  Maybe it needs documenting to say why 4 is always correct (if that
> is the case).
> 
> check_for_exception:
>         tst     r1, #FPEXC_EX
>         bne     process_exception       @ might as well handle the pending
>                                         @ exception before retrying branch
>                                         @ out before setting an FPEXC that
>                                         @ stops us reading stuff
>         VFPFMXR FPEXC, r1               @ restore FPEXC last
>         sub     r2, r2, #4
>         str     r2, [sp, #S_PC]         @ retry the instruction

If we don't touch r2 in __und_usr, than in vfphw.S we would need to
subtract 2 for Thumb and 4 for ARM. But since we did +2 in __und_usr, we
always subtracted 4 here (confusingly though).

> > > At the moment its just confusing as things stand, as some things are
> > > changed in one place and not the other.  Let's kill the pointless
> > > addition of 2 in the undefined instruction handler so that in every
> > > case we enter handlers with r2 == regs->ARM_pc, and regs->ARM_pc
> > > as per the ARM ARM undefined exception entry LR.
> > >
> > > Undefined instruction exception handlers can then rely on the meaning
> > > of both of these.
> >
> > That's an alternative, though we may end up with checking the encoding
> > twice. The Undef handler already reads the instruction opcode and it
> > needs to know whether it is a 16 or a 32-bit wide instruction.
> 
> At the moment we add 2 in one place, take off 4 in another, and now
> we're going to add 2 in a completely different place.  This is insane.
> It's a big mess, one which it's impossible to tell if anything is
> correct or even easy to follow what's going on.

I agree, this code needs some clean-up. Maybe for Undef we could unify
the ARM and Thumb-2 offsets so that they are both 4 (it may confuse the
breakpoint code, I haven't checked).

Otherwise just let the code handling the undef deal with the ARM/Thumb
difference. For SVC, it makes sense to have different offsets as we
always return to the next instruction.

-- 
Catalin


