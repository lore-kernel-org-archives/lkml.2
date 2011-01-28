Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318Ab1A1Q6u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 11:58:50 -0500
Received: from claw.goop.org ([74.207.240.146]:43278 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754668Ab1A1Q6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 11:58:49 -0500
Message-ID: <4D42F5C8.8060703@goop.org>
Date: Fri, 28 Jan 2011 08:58:48 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Kees Cook <kees.cook@canonical.com>,
        matthieu castet <castet.matthieu@free.fr>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [BUG] broken ebba638ae723d8a8fc2f7abce5ec18b688b791d7
References: <4D41E86D.8060205@free.fr> <20110127230013.GO4981@outflux.net> <4D4228CE.5090601@zytor.com> <4D423A19.2060201@zytor.com>
In-Reply-To: <4D423A19.2060201@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2011 07:38 PM, H. Peter Anvin wrote:
> [Adding Jeremy]
>
> Jeremy, would this break Xen?  As far as I know, Xen is the main user
> of skipping segment register initialization.

Xen doesn't go through head_*.S at all.

    J

>
>     -hpa
>
>
> On 01/27/2011 06:24 PM, H. Peter Anvin wrote:
>> On 01/27/2011 03:00 PM, Kees Cook wrote:
>>>
>>> Yikes, good catch.
>>>
>>> arch/x86/kernel/trampoline_64.S uses:
>>> movw $(trampoline_stack_end - r_base), %sp
>>>
>>> arch/x86/boot/compressed/head_64.S uses:
>>> movl $boot_stack_end, %eax
>>> addl %ebp, %eax
>>> movl %eax, %esp
>>>
>>> what would be safe for arch/x86/kernel/head_32.S ? It uses
>>> "stack_start",
>>> but later after paging set-up. Is the following sane to solve this?
>>>
>>
>> To run it before paging is set up, you can't use stack, start; you have
>> to use a pointer based on physical address. You have two problems with
>> using stack_start: you're using a linear address to access stack_start,
>> and stack_start itself contains a linear address.
>>
>> It's not entirely clear to me why we don't initialize %ss to __BOOT_DS
>> with the other segment registers, but it would make most sense to me:
>>
>> diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
>> index fc293dc..c10f9ba 100644
>> --- a/arch/x86/kernel/head_32.S
>> +++ b/arch/x86/kernel/head_32.S
>> @@ -99,7 +99,12 @@ ENTRY(startup_32)
>> movl %eax,%es
>> movl %eax,%fs
>> movl %eax,%gs
>> + movl %eax,%ss
>> 2:
>> +/*
>> + * Set up an initial stack
>> + */
>> + movl $pa(init_thread_union+THREAD_SIZE), %esp
>>
>> /*
>> * Clear BSS first so that there are no surprises...
>>
>> -hpa
>

