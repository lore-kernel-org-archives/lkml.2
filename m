Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751389Ab1A0GfJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 01:35:09 -0500
Received: from smtp-out.google.com ([216.239.44.51]:28827 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab1A0GfI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 01:35:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=e8X6Cved19mJr0B7wX9dksYWpknhWK2d0U+XZt73UpOLtg/O2nW4qHZGjIJqVB2jwz
         mno0ZtmRztsy5TgzffyQ==
MIME-Version: 1.0
In-Reply-To: <AANLkTim2fPySEMFn+ckrVAvJj8ZXEvBoZpgmZAKOWf=9@mail.gmail.com>
References: <1295014231.7901.41.camel@e102109-lin.cambridge.arm.com>
	<20110114154919.GE15996@n2100.arm.linux.org.uk>
	<1295022193.7901.56.camel@e102109-lin.cambridge.arm.com>
	<20110114163520.GH15996@n2100.arm.linux.org.uk>
	<1295024327.7901.70.camel@e102109-lin.cambridge.arm.com>
	<20110114173050.GJ15996@n2100.arm.linux.org.uk>
	<20110114184759.GN15996@n2100.arm.linux.org.uk>
	<AANLkTi=J2A1Qv6NGB1bsMr6d+1VFV26KEBQ=NJ=791s0@mail.gmail.com>
	<AANLkTimd44_FjnJUCNwz412Ned5S_+YcyHjfitus3vLQ@mail.gmail.com>
	<AANLkTimZ9itumf=QZPD55+JA5cUOWKgwuA1_5=XsdPsP@mail.gmail.com>
	<20110126112624.GC2562@n2100.arm.linux.org.uk>
	<AANLkTim2fPySEMFn+ckrVAvJj8ZXEvBoZpgmZAKOWf=9@mail.gmail.com>
Date: Wed, 26 Jan 2011 22:35:03 -0800
X-Google-Sender-Auth: tQt_z0aBRM7U9rwcO5t_RsKpI3E
Message-ID: <AANLkTindtGzxnCRK7XZW1jtXRAeBz9cTshqCtTr3qnL7@mail.gmail.com>
Subject: Re: [PATCH] ARM: vfp: Fix up exception location in Thumb mode
From: Colin Cross <ccross@android.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 10:11 PM, Colin Cross <ccross@android.com> wrote:
> On Wed, Jan 26, 2011 at 3:26 AM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
>> On Tue, Jan 25, 2011 at 03:33:24PM -0800, Colin Cross wrote:
>>> I think there is an additional change needed to
>>> __und_usr_unknown/do_undefinstr.  do_undefinstr, which gets called
>>> directly in __und_usr as well as by mov pc, lr, expects regs->ARM_pc
>>> to be the fault address, and not the next PC, and gets called for 2 or
>>> 4 byte instructions.
>>
>> It expects it to be the next PC:
>>
>> asmlinkage void __exception do_undefinstr(struct pt_regs *regs)
>> {
>>        unsigned int correction = thumb_mode(regs) ? 2 : 4;
>>        unsigned int instr;
>>        siginfo_t info;
>>        void __user *pc;
>>
>>        /*
>>         * According to the ARM ARM, PC is 2 or 4 bytes ahead,
>>         * depending whether we're in Thumb mode or not.
>>         * Correct this offset.
>>         */
>>        regs->ARM_pc -= correction;
>>
>> We expect the PC to be pointing at the next instruction to be executed.
>> This is the value of the PC saved by the CPU when entering the exception.
>> We correct the PC by four bytes for ARM mode to point at the previously
>> executed instruction.
>>
>> For 16-bit Thumb mode, the PC is again pointing at the next instruction
>> to be executed, and this is the value saved by the CPU.  So we correct
>> the PC by two bytes as that is the Thumb instruction size.
>>
>> The problem comes with T2, where we advance the saved PC by two bytes
>> if the instruction was 32-bit such that it again points at the next
>> instruction to be executed.  This is where the problem comes in because
>> we have two different chunks of code with completely different
>> expectations.
>
> All do_undefinstr will do with the correction is subtract it off so
> that pc points to the faulting instruction instead of the next
> instruction, and calls any registered handlers.  VFP_bounce sometimes
> subtracts off 4 (it doesn't care about T2 mode there, because T2 VFP
> instructions are all 32 bit), and sometimes leaves pc pointing at the
> next instruction.  If both were modified to expect the faulting
> instruction's pc, do_undefinstr would leave pc unmodified, and
> VFP_bounce would add 4 in the opposite cases from where it subtracts 4
> now.
>
> iwmmxt_task_enable and crunch_task_enable can also get called from __und_usr.
>
> Currently, iwmmxt_task_enable will either end up in do_undefinstr
> through mov pc, lr, or it will subtract 4 from the pc register value
> and return through ret_from_exception.  With the change above, it
> would not need to modify the pc value at all.
>
> crunch_task_enable is based on iwmmxt_task_enable, and works exactly the same.
>
>> Maybe we need to pass in the correction factor to do_undefinstr instead.
>>
>
> That just makes it even more complicated, the correction factor has to
> be tracked through every code path.
>
> RFC patch to follow.
>

Missed one case.  do_fpe calls into nwfpe_enter (I don't see any other
users of fp_enter), which assumes the PC in the registers on the stack
is faulting PC + 4, ignores r2, and uses r0 as the first instruction
to emulate.  It will need to be slightly modified in my patch.
