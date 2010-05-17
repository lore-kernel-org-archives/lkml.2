Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134Ab0EQWHk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 18:07:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52353 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753538Ab0EQWHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 18:07:23 -0400
Message-ID: <4BF1BDDE.3060305@zytor.com>
Date: Mon, 17 May 2010 15:06:22 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Borislav Petkov <petkovbb@googlemail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] core/hweight changes for v2.6.35
References: <20100517212138.GA21629@elte.hu> <alpine.LFD.2.00.1005171443060.4195@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1005171443060.4195@i5.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2010 02:46 PM, Linus Torvalds wrote:
> 
> 
> On Mon, 17 May 2010, Ingo Molnar wrote:
>>
>> +#ifdef CONFIG_64BIT
>> +/* popcnt %rdi, %rax */
>> +#define POPCNT ".byte 0xf3,0x48,0x0f,0xb8,0xc7"
>> +#define REG_IN "D"
>> +#define REG_OUT "a"
> ...
>> +/*
>> + * __sw_hweightXX are called from within the alternatives below
>> + * and callee-clobbered registers need to be taken care of. See
>> + * ARCH_HWEIGHT_CFLAGS in <arch/x86/Kconfig> for the respective
>> + * compiler switches.
>> + */
>> +static inline unsigned int __arch_hweight32(unsigned int w)
>> +{
>> +	unsigned int res = 0;
>> +
>> +	asm (ALTERNATIVE("call __sw_hweight32", POPCNT, X86_FEATURE_POPCNT)
>> +		     : "="REG_OUT (res)
>> +		     : REG_IN (w));
>> +
>> +	return res;
>> +}
> 
> I do not believe this is correct.
> 
> On x86-64, you are using a 64-bit instruction, but
> 
> 	REG_IN (w)
> 
> does _not_ guarantee that the register is zero in the high bits.
> 
> Yes, yes, in practice it _probably_ is, because the register almost 
> certainly got loaded with some kind of zero-extending mov instruction. But 
> as far as I can tell, the code is buggy. You're telling gcc that you are 
> using a 32-bit register, but you're actually counting bits in the full 64 
> bits.
> 
> Am I missing something?
> 

No, you're absolutely right; the input can be any value including
sign-extended.  The best fix for this is probably to use a 32-bit
instruction in this case -- I will check in such a patch and update the
pull branch.  If that's okay with you we'll send you a new pull request
in a bit.

The embarrassing part is I think I spotted this problem at one point,
but forgot about it in dealing with a conflict between this and another
patchset.

	-hpa

