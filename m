Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757941Ab1ANQY7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 11:24:59 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49338 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757692Ab1ANQYz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 11:24:55 -0500
MIME-Version: 1.0
In-Reply-To: <1295014231.7901.41.camel@e102109-lin.cambridge.arm.com>
References: <1294990949-2729-1-git-send-email-ccross@android.com>
	<AANLkTimqiqABxCejdeOQWZZ62DVUZW2v-yMpdu1aNDQT@mail.gmail.com>
	<20110114120229.GA15996@n2100.arm.linux.org.uk>
	<1295014231.7901.41.camel@e102109-lin.cambridge.arm.com>
Date: Fri, 14 Jan 2011 10:24:52 -0600
Message-ID: <AANLkTi=4=c0B3Qo+boguUw-DvEihBej5Zz_d2QWmoucm@mail.gmail.com>
Subject: Re: [PATCH] ARM: vfp: Fix up exception location in Thumb mode
From: Dave Martin <dave.martin@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Colin Cross <ccross@android.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Jan 14, 2011 at 8:10 AM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> On Fri, 2011-01-14 at 12:02 +0000, Russell King - ARM Linux wrote:
>> On Fri, Jan 14, 2011 at 11:43:04AM +0000, Catalin Marinas wrote:
>> > >        pr_debug("VFP: bounce: trigger %08x fpexc %08x\n", trigger, fpexc);
>> > >
>> > >        /*
>> > > +        * If the exception occured in thumb mode, pc is exception location + 2,
>> > > +        * the middle of the 32-bit VFP instruction.  Add 2 to get exception
>> > > +        * location + 4, the same we get in ARM mode.
>> > > +        */
>> > > +#ifdef CONFIG_ARM_THUMB
>> > > +       if (regs->ARM_cpsr & PSR_T_BIT)
>> > > +               regs->ARM_pc += 2;
>> > > +#endif
>> >
>> > You can use "if (thumb_mode(regs))" and avoid the #ifdef entirely.
>>
>> I don't think this is correct.  On entry to the undefined instruction
>> handler, we get the uncorrected PC value, so PC points to the
>> instruction after the faulting instruction.
>>
>> If it was an ARM instruction, that is located at PC-4.  If it was a
>> Thumb instruction, it is located at PC-2.  This PC value is passed
>> unmodified to the VFP entry code, and the passed r2 reflect the
>> value in regs->ARM_pc.
>
> The entry-armv.S code adds 2 to the r2 register in case of a 32-bit
> Thumb instruction, so it is no longer the same as the ARM_pc.
>
> Since the VFP instructions in Thumb mode are always 32-bit, Colin's
> patch made sense to me.

Is the comment preceding __und_usr_unknown causing some confusion here?

/*
 * The FP module is called with these registers set:
 *  r0  = instruction
 *  r2  = PC+4
 ...

That reflects the ARM case only: for Thumb, r2 is always PC+2 (?)

The comment at the start of do_undefinstr() (which receives these
registers) is correct though:

	/*
	 * According to the ARM ARM, PC is 2 or 4 bytes ahead,
	 * depending whether we're in Thumb mode or not.
	 * Correct this offset.

Cheers
---Dave
