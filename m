Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756378Ab0JWDkT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 23:40:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52754 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755882Ab0JWDkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 23:40:17 -0400
Message-ID: <4CC2590B.5080109@zytor.com>
Date: Fri, 22 Oct 2010 20:39:55 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/fpu] x86-64, asm: Use fxsaveq/fxrestorq in more places
References: <AANLkTi=RKyHLNTq6iomZOXkc6Zw1j9iAgsq8388XmzwN@mail.gmail.com> <tip-fd35fbcdd1b2579a6e00a1545f7124e4005d0474@git.kernel.org> <AANLkTi=KRVMrNh6MyDh5v-ZGB18iEKkqsW+6Eqp27M5X@mail.gmail.com>
In-Reply-To: <AANLkTi=KRVMrNh6MyDh5v-ZGB18iEKkqsW+6Eqp27M5X@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2010 07:11 PM, Linus Torvalds wrote:
> On Fri, Oct 22, 2010 at 6:20 PM, tip-bot for H. Peter Anvin
> <hpa@zytor.com> wrote:
>>
>> Checkin d7acb92fea932ad2e7846480aeacddc2c03c8485 made use of fxsaveq
>> in fpu_fxsave() if the assembler supports it; this adds
>> fxsaveq/fxrstorq to fxrstor_checking() and fxsave_user() as well.
> 
> Hmm. I really think you should be able to do something like this
> 
>   #ifdef CONFIG_AS_FXSAVEQ
>     #define FXSAVEQ_INSN "fxsaveq %[fx]"
>     #define FXRSTORQ_INSN "fxrstorq %[fx]"
>     #define FX_EXTRA(ptr)
>   #else
>     #define FXSAVEQ_INSN "rex64/fxsave (%[fxr])"
>     #define FXRSTORQ_INSN "rex64/fxrstor (%[fxr])"
>     #define FX_EXTRA(ptr)  [fxr] "R" (ptr)
>   #endif
> 
> and then you should be able to write the actual code something like
> 
>    asm volatile(FXSAVEQ_INSN
>       :[fx] "=m" (memory)
>       :FX_EXTRA(&memory))
> 
> and
> 
>   #define __COMMA_CONCAT(x) ,##x
>   #define COMMA_CONCAT(x) __COMMA_CONCAT(x)
>   asm volatile(FXRSTRORQ_INSN
>       : :[fx] "m" (memory) COMMA_CONCAT(FX_EXTRA(&memory)));
> 
> or something like that (obviously you'll need the exception stuff too there).
> 
> With no #ifdef's in the actual code. Hmm?
> 

Well sure, but it is already encapsulated in 3 inlines.  To me, the
above is quite frankly quite a bit harder to read than the broken-out form.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

