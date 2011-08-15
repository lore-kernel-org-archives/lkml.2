Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab1HOOzT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 10:55:19 -0400
Received: from mail.skyhub.de ([78.46.96.112]:59270 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753925Ab1HOOzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 10:55:17 -0400
Message-ID: <a5a38901541cbe2805361c1887f2f395.squirrel@www.skyhub.de>
Date: Mon, 15 Aug 2011 16:55:14 +0200 (CEST)
Subject: Re: x86 memcpy performance
From: "Borislav Petkov" <bp@alien8.de>
To: "melwyn lobo" <linux.melwyn@gmail.com>
Cc: "Borislav Petkov" <bp@alien8.de>,
        "Denys Vlasenko" <vda.linux@googlemail.com>,
        "Ingo Molnar" <mingo@elte.hu>, "melwyn lobo" <linux.melwyn@gmail.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Peter Zijlstra" <a.p.zijlstra@chello.nl>, borislav.petkov@amd.com
User-Agent: SquirrelMail/1.4.15
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 August, 2011 3:27 pm, melwyn lobo wrote:
> Hi,
> Was on a vacation for last two days. Thanks for the good insights into
> the issue.
> Ingo, unfortunately the data we have is on a soon to be released
> platform and strictly confidential at this stage.
>
> Boris, thanks for the patch. On seeing your patch:
> +void *__sse_memcpy(void *to, const void *from, size_t len)
> +{
> +       unsigned long src = (unsigned long)from;
> +       unsigned long dst = (unsigned long)to;
> +       void *p = to;
> +       int i;
> +
> +       if (in_interrupt())
> +               return __memcpy(to, from, len)
> So what is the reason we cannot use sse_memcpy in interrupt context.
> (fpu registers not saved ? )

Because, AFAICT, when we handle an #NM exception while running
sse_memcpy in an IRQ handler, we might need to allocate FPU save state
area, which in turn, can sleep. Then, we might get another IRQ while
sleeping and we should be deadlocked.

But let me stress on the "AFAICT" above, someone who actually knows the
FPU code should correct me if I'm missing something.

> My question is still not answered. There are 3 versions of memcpy in
> kernel:
>
> ***********************************arch/x86/include/asm/string_32.h******************************
> 179 #ifndef CONFIG_KMEMCHECK
> 180
> 181 #if (__GNUC__ >= 4)
> 182 #define memcpy(t, f, n) __builtin_memcpy(t, f, n)
> 183 #else
> 184 #define memcpy(t, f, n)                         \
> 185         (__builtin_constant_p((n))              \
> 186          ? __constant_memcpy((t), (f), (n))     \
> 187          : __memcpy((t), (f), (n)))
> 188 #endif
> 189 #else
> 190 /*
> 191  * kmemcheck becomes very happy if we use the REP instructions
> unconditionally,
> 192  * because it means that we know both memory operands in advance.
> 193  */
> 194 #define memcpy(t, f, n) __memcpy((t), (f), (n))
> 195 #endif
> 196
> 197
> ****************************************************************************************.
> I will ignore CONFIG_X86_USE_3DNOW (including mmx_memcpy() ) as this
> is valid only for AMD and not for Atom Z5xx series.
> This means __memcpy, __constant_memcpy, __builtin_memcpy .
> I have a hunch by default we were using  __builtin_memcpy.
> This is because I see my GCC version >=4 and CONFIG_KMEMCHECK
> not defined. Can someone confirm of these 3 which is used, with
> i386_defconfig. Again with i386_defconfig which workloads provide the
> best results with the default implementation.

Yes, on 32-bit you're using the compiler-supplied version
__builtin_memcpy when CONFIG_KMEMCHECK=n and your gcc is of version 4
and above. Reportedly, using __builtin_memcpy generates better code.

Btw, my version of SSE memcpy is 64-bit only.

-- 
Regards/Gruss,
Boris.

