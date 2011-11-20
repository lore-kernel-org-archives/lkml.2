Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234Ab1KTKzw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 05:55:52 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50769 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990Ab1KTKzv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 05:55:51 -0500
MIME-Version: 1.0
In-Reply-To: <20111120084111.GM9581@n2100.arm.linux.org.uk>
References: <CAHkRjk6Ynfh9+UbTuAtyiXCOF-yDbTNxi0ikF5ttwHViisZRZA@mail.gmail.com>
 <1321751070-7932-1-git-send-email-stepanm@codeaurora.org> <20111120084111.GM9581@n2100.arm.linux.org.uk>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Sun, 20 Nov 2011 10:55:28 +0000
X-Google-Sender-Auth: suHTGRGAOo7W3_2oTF-PpcCkYmQ
Message-ID: <CAHkRjk4QZxoVmCsB1A3DVb5_WCUvN5NfbYz8PNL_7np7+wHGzQ@mail.gmail.com>
Subject: Re: [PATCH] arm: Add condition code check to SWP emulator
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Stepan Moskovchenko <stepanm@codeaurora.org>, linux-kernel@vger.kernel.org,
        bryanh@codeaurora.org, David Brown <davidb@codeaurora.org>,
        Leif Lindholm <leif.lindholm@arm.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 November 2011 08:41, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Sat, Nov 19, 2011 at 05:04:30PM -0800, Stepan Moskovchenko wrote:
>> +static int check_condition(struct pt_regs *regs, unsigned int insn)
>> +{
>> +     unsigned int base_cond, neg, cond = 0;
>> +     unsigned int cpsr_z, cpsr_c, cpsr_n, cpsr_v;
>> +
>> +     cpsr_n = (regs->ARM_cpsr & PSR_N_BIT) ? 1 : 0;
>> +     cpsr_z = (regs->ARM_cpsr & PSR_Z_BIT) ? 1 : 0;
>> +     cpsr_c = (regs->ARM_cpsr & PSR_C_BIT) ? 1 : 0;
>> +     cpsr_v = (regs->ARM_cpsr & PSR_V_BIT) ? 1 : 0;
>> +
>> +     /* Upper 3 bits indicate condition, lower bit incicates negation */
>> +     base_cond = insn >> 29;
>> +     neg = insn & BIT(28) ? 1 : 0;
>> +
>> +     switch (base_cond) {
>> +     case 0x0:       /* equal */
>> +             cond = cpsr_z;
>> +             break;
>> +
>> +     case 0x1:       /* carry set */
>> +             cond = cpsr_c;
>> +             break;
>> +
>> +     case 0x2:       /* minus / negative */
>> +             cond = cpsr_n;
>> +             break;
>> +
>> +     case 0x3:       /* overflow */
>> +             cond = cpsr_v;
>> +             break;
>> +
>> +     case 0x4:       /* unsigned higher */
>> +             cond = (cpsr_c == 1) && (cpsr_z == 0);
>> +             break;
>> +
>> +     case 0x5:       /* signed greater / equal */
>> +             cond = (cpsr_n == cpsr_v);
>> +             break;
>> +
>> +     case 0x6:       /* signed greater */
>> +             cond = (cpsr_z == 0) && (cpsr_n == cpsr_v);
>> +             break;
>> +
>> +     case 0x7:       /* always */
>> +             cond = 1;
>> +             break;
>> +     };
>> +
>> +     return cond && !neg;
>
> There's a much better algorithm to check this.  See the bottom of
> arch/arm/nwfpe/fpopcode.c.
>
> It would probably be best for there to be a common function for doing
> this kind of check, rather than having several implementations of it
> scattered around the kernel.

That's what Leif started doing.

-- 
Catalin
