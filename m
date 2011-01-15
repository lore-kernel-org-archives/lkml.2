Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745Ab1AOPnk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 10:43:40 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59956 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459Ab1AOPn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 10:43:28 -0500
Date: Sat, 15 Jan 2011 15:43:19 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Colin Cross <ccross@android.com>
Subject: Re: [PATCH] ARM: vfp: Fix up exception location in Thumb mode
Message-ID: <20110115154319.GG15996@n2100.arm.linux.org.uk>
References: <AANLkTimqiqABxCejdeOQWZZ62DVUZW2v-yMpdu1aNDQT@mail.gmail.com> <20110114120229.GA15996@n2100.arm.linux.org.uk> <1295014231.7901.41.camel@e102109-lin.cambridge.arm.com> <20110114154919.GE15996@n2100.arm.linux.org.uk> <1295022193.7901.56.camel@e102109-lin.cambridge.arm.com> <20110114163520.GH15996@n2100.arm.linux.org.uk> <1295024327.7901.70.camel@e102109-lin.cambridge.arm.com> <20110114173050.GJ15996@n2100.arm.linux.org.uk> <20110114184759.GN15996@n2100.arm.linux.org.uk> <AANLkTi=p+f7TO+_g677VXNJkt-mu+8d8c6T9qgt5MVtn@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=p+f7TO+_g677VXNJkt-mu+8d8c6T9qgt5MVtn@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 15, 2011 at 03:38:16PM +0000, Catalin Marinas wrote:
> On 14 January 2011 18:47, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > diff -u b/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
> > --- b/arch/arm/kernel/entry-armv.S
> > +++ b/arch/arm/kernel/entry-armv.S
> > @@ -499,10 +499,11 @@
> >        blo     __und_usr_unknown
> >  3:     ldrht   r0, [r4]
> >        add     r2, r2, #2                      @ r2 is PC + 2, make it PC + 4
> > -       orr     r0, r0, r5, lsl #16
> > +       str     r2, [sp, #S_PC]                 @ it's a 2x16bit instr, update
> > +       orr     r0, r0, r5, lsl #16             @  regs->ARM_pc
> >        @
> >        @ r0 = the two 16-bit Thumb instructions which caused the exception
> > -       @ r2 = PC value for the following Thumb instruction (:= regs->ARM_pc+2)
> > +       @ r2 = PC value for the following Thumb instruction (:= regs->ARM_pc)
> >        @ r4 = PC value for the first 16-bit Thumb instruction
> >        @
> >  #else
> 
> Do we need to modify the VFP entry code to avoit the store to ARM_pc?

The one after the sub #4 instruction?

That's answered by the comments... "retry the instruction" and that
r2 = regs->ARM_pc in every case, and both r2 and regs->ARM_pc point
at the _following_ instruction...

I do hope this isn't a case that _more_ comments are making this more
confusing (which seems to be the way with documentation - the more
words you use, the more questions people have).  Maybe we should get
rid of all the comments instead?
