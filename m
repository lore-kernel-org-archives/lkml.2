Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664Ab0EQVtJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 17:49:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49262 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754035Ab0EQVtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 17:49:07 -0400
Date: Mon, 17 May 2010 14:46:05 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Borislav Petkov <petkovbb@googlemail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] core/hweight changes for v2.6.35
In-Reply-To: <20100517212138.GA21629@elte.hu>
Message-ID: <alpine.LFD.2.00.1005171443060.4195@i5.linux-foundation.org>
References: <20100517212138.GA21629@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 17 May 2010, Ingo Molnar wrote:
>
> +#ifdef CONFIG_64BIT
> +/* popcnt %rdi, %rax */
> +#define POPCNT ".byte 0xf3,0x48,0x0f,0xb8,0xc7"
> +#define REG_IN "D"
> +#define REG_OUT "a"
...
> +/*
> + * __sw_hweightXX are called from within the alternatives below
> + * and callee-clobbered registers need to be taken care of. See
> + * ARCH_HWEIGHT_CFLAGS in <arch/x86/Kconfig> for the respective
> + * compiler switches.
> + */
> +static inline unsigned int __arch_hweight32(unsigned int w)
> +{
> +	unsigned int res = 0;
> +
> +	asm (ALTERNATIVE("call __sw_hweight32", POPCNT, X86_FEATURE_POPCNT)
> +		     : "="REG_OUT (res)
> +		     : REG_IN (w));
> +
> +	return res;
> +}

I do not believe this is correct.

On x86-64, you are using a 64-bit instruction, but

	REG_IN (w)

does _not_ guarantee that the register is zero in the high bits.

Yes, yes, in practice it _probably_ is, because the register almost 
certainly got loaded with some kind of zero-extending mov instruction. But 
as far as I can tell, the code is buggy. You're telling gcc that you are 
using a 32-bit register, but you're actually counting bits in the full 64 
bits.

Am I missing something?

		Linus
