Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494Ab1KQNJ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 08:09:59 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:4426 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756345Ab1KQNJ6 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Thu, 17 Nov 2011 08:09:58 -0500
Message-Id: <4EC515B40200007800061921@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Thu, 17 Nov 2011 13:09:56 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Mathias Krause" <minipli@googlemail.com>
Cc: <herbert@gondor.hengli.com.au>, <linux-kernel@vger.kernel.org>
Subject: Re: your patch "crypto: sha1 - SSSE3 based SHA1 implementation
 for x86-64" vs xsave
References: <4EC4F0FD0200007800061840@nat28.tlf.novell.com>
 <CA+rthh-1WxhWPeKE-Aqa5NCatxVoKu9=KHhLygkT1A6K35CBDA@mail.gmail.com>
In-Reply-To: <CA+rthh-1WxhWPeKE-Aqa5NCatxVoKu9=KHhLygkT1A6K35CBDA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 17.11.11 at 13:36, Mathias Krause <minipli@googlemail.com> wrote:
> On Thu, Nov 17, 2011 at 11:33 AM, Jan Beulich <JBeulich@suse.com> wrote:
>> Mathias,
>>
>> in avx_usable() you use cpu_has_osxsave to determine whether AVX can
>> actually be used, but I can't see how that conditional would ever evaluate
>> to true.
> 
> Well, it does, at least in my setup, a Core i7-2620M:
> 
>   [   44.902613] sha1_ssse3: Using AVX optimized SHA-1 implementation
> 
>> Checking CPUID.OSXSAVE is actually a user land requirement,
>> whereas in the kernel you should really look at kernel internal variables
>> to determine whether xsave was enabled
> 
> That's a valid point. I actually ported the check from the initial
> assembler implementation which was written with userland code in mind.
> Albeit this test can also be used in kernel code because the kernel
> only sets this flag after xsave was enabled in
> arch/x86/kernel/xsave.c:xstate_enable_boot_cpu/xstate_enable

Indeed, I got this the wrong way round.

>> (or, if you really want to stay
>> with using cpu_has_osxsave you'd have to force re-execution of
>> get_cpu_cap() after xsave got enabled on individual CPUs), namely
>> mmu_cr4_features having X86_CR4_OSXSAVE set.
> 
> I don't see where X86_CR4_OSXSAVE would get reset after xsave init.
> Can you give me a pointer to that code?

I didn't say it would get cleared. I said it should be used in favor of
cpu_has_osxsave.

>> Additionally, under a hypervisor, CPUID.OSXSAVE may be set (due to
>> the hypervisor having enabled xsave), while the kernel may be running
>> with xsave disabled (e.g. due to a command line option saying so).
> 
> When noxsave is given on the kernel command line, X86_FEATURE_XSAVE
> will be cleared and xsave_init() won't call xstate_enable(), so not
> setting X86_CR4_OSXSAVE. All fine.

But you're not looking at this bit, you're looking at cpu_has_osxsave,
which is a CPUID bit (not a CR4 one).

Jan

