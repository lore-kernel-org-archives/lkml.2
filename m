Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932720Ab0JDVEK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 17:04:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49690 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932232Ab0JDVEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 17:04:08 -0400
Message-ID: <4CAA4102.3070205@zytor.com>
Date: Mon, 04 Oct 2010 14:02:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, cpu: Fix X86_FEATURE_NOPL
References: <20101003093701.GB3733@liondog.tnic> <4CA89681.8000202@zytor.com> <20101003152212.GA13233@liondog.tnic> <a3fce0e5-e6c5-4bf0-b8c0-4954825a7065@email.android.com> <20101003201139.GA16532@liondog.tnic> <dc1a5ce2-0414-4f15-9e7b-fcfa4435adb5@email.android.com> <20101004073127.GA20305@liondog.tnic> <AANLkTikBs5R2KmGfDSXyi5y-cKuZepZCdr0KOVe5-MX6@mail.gmail.com>
In-Reply-To: <AANLkTikBs5R2KmGfDSXyi5y-cKuZepZCdr0KOVe5-MX6@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2010 01:47 PM, Linus Torvalds wrote:
> On Mon, Oct 4, 2010 at 12:31 AM, Borislav Petkov <bp@alien8.de> wrote:
>>
>> ba0593bf553c450a03dbc5f8c1f0ff58b778a0c8 cleared the aforementioned
>> cpuid bit only on 32-bit due to various problems with Virtual PC. This
>> somehow got lost during the 32- + 64-bit merge so restore the feature
>> bit on 64-bit. For that, set it explicitly for non-constant arguments of
>> cpu_has(). Update comment for future reference.
> 
> I don't think this is right.
> 
> The cpu_has() logic depends not on x86-64, but on X86_P6_NOP.
> 

Actually, cpu_has() depends on:
#if defined(CONFIG_X86_P6_NOP) || defined(CONFIG_X86_64)

Obviously, if we *use* P6 NOPs they better be available on the
processor, but we also are pretty sure that every 64-bit processor
supports then

> Which has
> 
>         depends on X86_64
>         depends on (MCORE2 || MPENTIUM4 || MPSC)
> 
> as its config rules, not just X86_64.

Right; the top clause, of course, was added later, as we found out that
it was unsafe to ever use NOPL on 32 bits, because of Microsoft f*ckups.

CONFIG_X86_P6_NOP was intended to indicate that using NOPL is
*preferred*, whereas the CPUID bit -- cpu_has() -- was (and is) intended
to indicate that NOPL is *supported*, not necessarily preferred.

As such, the code I believe is technically correct for the current
situation (NOPL is always supported on 64 bits, never on 32 bits), but
as you quite correctly point out it is definitely more confusing than is
desirable; this is probably also reflected by the following code in
alternative.c:

static const unsigned char *const *__init_or_module find_nop_table(void)
{
        if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL &&
            boot_cpu_has(X86_FEATURE_NOPL))
                return p6_nops;
        else
                return k8_nops;
}

The vendor check here is really ugly.

The only case where we need CONFIG_X86_P6_NOP as a compile-time check is
for the ASM_NOP* macros; for dynamic code we're of course better off
with a runtime check, but it would be better if that was part of the CPU
routines.  Perhaps X86_FEATURE_FAST_NOPL or something like that.

	-hpa
