Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648Ab1ANMCv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 07:02:51 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46119 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447Ab1ANMCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 07:02:46 -0500
Date: Fri, 14 Jan 2011 12:02:29 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Colin Cross <ccross@android.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: vfp: Fix up exception location in Thumb mode
Message-ID: <20110114120229.GA15996@n2100.arm.linux.org.uk>
References: <1294990949-2729-1-git-send-email-ccross@android.com> <AANLkTimqiqABxCejdeOQWZZ62DVUZW2v-yMpdu1aNDQT@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimqiqABxCejdeOQWZZ62DVUZW2v-yMpdu1aNDQT@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 11:43:04AM +0000, Catalin Marinas wrote:
> >        pr_debug("VFP: bounce: trigger %08x fpexc %08x\n", trigger, fpexc);
> >
> >        /*
> > +        * If the exception occured in thumb mode, pc is exception location + 2,
> > +        * the middle of the 32-bit VFP instruction.  Add 2 to get exception
> > +        * location + 4, the same we get in ARM mode.
> > +        */
> > +#ifdef CONFIG_ARM_THUMB
> > +       if (regs->ARM_cpsr & PSR_T_BIT)
> > +               regs->ARM_pc += 2;
> > +#endif
> 
> You can use "if (thumb_mode(regs))" and avoid the #ifdef entirely.

I don't think this is correct.  On entry to the undefined instruction
handler, we get the uncorrected PC value, so PC points to the
instruction after the faulting instruction.

If it was an ARM instruction, that is located at PC-4.  If it was a
Thumb instruction, it is located at PC-2.  This PC value is passed
unmodified to the VFP entry code, and the passed r2 reflect the
value in regs->ARM_pc.

The VFP entry assembly doesn't touch the PC value, except when it
wants to retry an instruction:

        sub     r2, r2, #4
        str     r2, [sp, #S_PC]         @ retry the instruction

So I think that 2 to the PC when in thumb mode is incorrect, as that'll
cause us to skip the instruction following the faulted one.

I think that the undefined instruction handling needs reworking for
Thumb entirely as we could be dealing with a 16-bit or 32-bit thumb
instruction, and we have no way of knowing without repeatedly
decoding that instruction.
