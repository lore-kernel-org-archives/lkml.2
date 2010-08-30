Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843Ab0H3F4n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 01:56:43 -0400
Received: from freeflow.nu ([178.79.134.28]:44277 "EHLO freeflow.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751920Ab0H3F4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 01:56:42 -0400
Message-ID: <4C7B4818.1090106@kernel.org>
Date: Mon, 30 Aug 2010 08:56:40 +0300
From: Pekka Enberg <penberg@kernel.org>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/11] x86-64: Simplify constraints for fxsave/fxtstor
References: <1283011478-27237-1-git-send-email-brgerst@gmail.com>	<1283011478-27237-8-git-send-email-brgerst@gmail.com>	<AANLkTi=+cEywooPp-ERx2+7GL3fs_d-xQ_fX9A7pc9St@mail.gmail.com> <AANLkTim1-nFHQNjiAtcBObz9nX5T=oMQWjN-3m6bt+Ur@mail.gmail.com>
In-Reply-To: <AANLkTim1-nFHQNjiAtcBObz9nX5T=oMQWjN-3m6bt+Ur@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 8/30/10 2:44 AM, Brian Gerst wrote:
> On Sun, Aug 29, 2010 at 2:45 PM, Pekka Enberg<penberg@kernel.org>  wrote:
>> On Sat, Aug 28, 2010 at 7:04 PM, Brian Gerst<brgerst@gmail.com>  wrote:
>>> Use the "R" constraint (legacy register) instead of listing all the
>>> possible registers.  Clean up the comments as well.
>>>
>>> Signed-off-by: Brian Gerst<brgerst@gmail.com>
>>> ---
>>>   arch/x86/include/asm/i387.h |   44 ++++++++++++++++--------------------------
>>>   1 files changed, 17 insertions(+), 27 deletions(-)
>>>
>>> diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
>>> index 8b40a83..768fcb2 100644
>>> --- a/arch/x86/include/asm/i387.h
>>> +++ b/arch/x86/include/asm/i387.h
>>> @@ -81,6 +81,7 @@ static inline int fxrstor_checking(struct i387_fxsave_struct *fx)
>>>   {
>>>         int err;
>>>
>>> +       /* See comment in fxsave() below. */
>>>         asm volatile("1:  rex64/fxrstor (%[fx])\n\t"
>>>                      "2:\n"
>>>                      ".section .fixup,\"ax\"\n"
>>> @@ -89,11 +90,7 @@ static inline int fxrstor_checking(struct i387_fxsave_struct *fx)
>>>                      ".previous\n"
>>>                      _ASM_EXTABLE(1b, 3b)
>>>                      : [err] "=r" (err)
>>> -#if 0 /* See comment in fxsave() below. */
>>> -                    : [fx] "r" (fx), "m" (*fx), "0" (0));
>>> -#else
>>> -                    : [fx] "cdaSDb" (fx), "m" (*fx), "0" (0));
>>> -#endif
>>> +                    : [fx] "R" (fx), "m" (*fx), "0" (0));
>> Please correct me if I'm wrong but "legacy registers" also include bp
>> and sp that are not part of the original constraints:
>>
>> http://gcc.gnu.org/onlinedocs/gcc/Machine-Constraints.html
>>
>> So why is it OK to use "R" here?
> There is no constraint to explicitly request %bp (or %sp), but there
> is no reason it could not be used.  The compiler would never choose
> %sp for "R" for the same reason it wouldn't for "r": it's not
> available as a general purpose register.
Yeah, if I try to force GCC to use bp or sp, it will complain that it 
runs out of legacy registers:

error: can't find a register in class `LEGACY_REGS' while reloading `asm'

which makes sense as it knows that sp and bp are used by the function 
that contains the inline asm.

Acked-by: Pekka Enberg <penberg@kernel.org>

             Pekka
