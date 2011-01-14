Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296Ab1ANOKp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 09:10:45 -0500
Received: from service87.mimecast.com ([94.185.240.25]:40905 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751923Ab1ANOKj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 09:10:39 -0500
Subject: Re: [PATCH] ARM: vfp: Fix up exception location in Thumb mode
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Colin Cross <ccross@android.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110114120229.GA15996@n2100.arm.linux.org.uk>
References: <1294990949-2729-1-git-send-email-ccross@android.com>
	 <AANLkTimqiqABxCejdeOQWZZ62DVUZW2v-yMpdu1aNDQT@mail.gmail.com>
	 <20110114120229.GA15996@n2100.arm.linux.org.uk>
Organization: ARM Limited
Date: Fri, 14 Jan 2011 14:10:31 +0000
Message-ID: <1295014231.7901.41.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 14 Jan 2011 14:10:32.0463 (UTC) FILETIME=[CE4B61F0:01CBB3F4]
X-MC-Unique: 111011414103505201
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-14 at 12:02 +0000, Russell King - ARM Linux wrote:
> On Fri, Jan 14, 2011 at 11:43:04AM +0000, Catalin Marinas wrote:
> > >        pr_debug("VFP: bounce: trigger %08x fpexc %08x\n", trigger, fpexc);
> > >
> > >        /*
> > > +        * If the exception occured in thumb mode, pc is exception location + 2,
> > > +        * the middle of the 32-bit VFP instruction.  Add 2 to get exception
> > > +        * location + 4, the same we get in ARM mode.
> > > +        */
> > > +#ifdef CONFIG_ARM_THUMB
> > > +       if (regs->ARM_cpsr & PSR_T_BIT)
> > > +               regs->ARM_pc += 2;
> > > +#endif
> >
> > You can use "if (thumb_mode(regs))" and avoid the #ifdef entirely.
> 
> I don't think this is correct.  On entry to the undefined instruction
> handler, we get the uncorrected PC value, so PC points to the
> instruction after the faulting instruction.
> 
> If it was an ARM instruction, that is located at PC-4.  If it was a
> Thumb instruction, it is located at PC-2.  This PC value is passed
> unmodified to the VFP entry code, and the passed r2 reflect the
> value in regs->ARM_pc.

The entry-armv.S code adds 2 to the r2 register in case of a 32-bit
Thumb instruction, so it is no longer the same as the ARM_pc.

Since the VFP instructions in Thumb mode are always 32-bit, Colin's
patch made sense to me.

> I think that the undefined instruction handling needs reworking for
> Thumb entirely as we could be dealing with a 16-bit or 32-bit thumb
> instruction, and we have no way of knowing without repeatedly
> decoding that instruction.

We already handle the r2 for in __und_usr. We don't deal with ARM_pc but
we could either do it in __und_usr or let the code handling the undef
fix it up.

-- 
Catalin


