Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285Ab1KUTQK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 14:16:10 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56160 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432Ab1KUTQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 14:16:07 -0500
Message-ID: <4ECAA374.2040102@gmail.com>
Date: Mon, 21 Nov 2011 11:16:04 -0800
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>
CC: linux-mips@linux-mips.org, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-embedded@vger.kernel.org, x86@kernel.org,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH RFC 1/5] scripts: Add sortextable to sort the kernel's
 exception table.
References: <1321645068-20475-1-git-send-email-ddaney.cavm@gmail.com> <201111201822.13614.vapier@gentoo.org> <4ECA97A0.3090005@gmail.com> <201111211350.58916.vapier@gentoo.org>
In-Reply-To: <201111211350.58916.vapier@gentoo.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2011 10:50 AM, Mike Frysinger wrote:
> On Monday 21 November 2011 13:25:36 David Daney wrote:
>> On 11/20/2011 03:22 PM, Mike Frysinger wrote:
>>> On Friday 18 November 2011 14:37:44 David Daney wrote:
>>>> +	switch (w2(ehdr->e_machine)) {
>>>> +	default:
>>>> +		fprintf(stderr, "unrecognized e_machine %d %s\n",
>>>> +			w2(ehdr->e_machine), fname);
>>>> +		fail_file();
>>>> +		break;
>>>> +	case EM_386:
>>>> +	case EM_MIPS:
>>>> +	case EM_X86_64:
>>>> +		break;
>>>> +	}  /* end switch */
>>>
>>> unlike recordmcount, this file doesn't do anything arch specific.  so
>>> let's just delete this and be done.
>>
>> Not really true at this point.  We don't know the size or layout of the
>> architecture specific exception table entries, likewise for
>> CONFIG_ARCH_HAS_SORT_EXTABLE, we don't even know how to do the comparison.
>
> all of your code that i could see is based on "is it 32bit or is it 64bit".
> there is no code that says "if it's x86, we need to do XXX".

At this point there is no need.  MIPS, i386 and x86_64 all store the key 
in the first word of a two word structure.

If there were some architecture that didn't fit this model, we would 
have to create a special sorting function and select it (and perhaps 
other parameters as well) in that switch statement.


>
> when i look in the kernel, we have common code behind ARCH_HAS_SORT_EXTABLE.
> so you could easily do the same thing:
>
> scripts/sortextable.c:
> 	#ifdef ARCH_HAS_SORT_EXTABLE
> 		switch (w2(ehdr->e_machine)) {
> 		default:
> 			fprintf(stderr, "unrecognized e_machine %d %s\n",
> 				w2(ehdr->e_machine), fname);
> 			... return a unique exit code like 77 ...
> 			break;
> 		/* add arch sorting info here */
> 		}  /* end switch */
> 	#endif
>
> kernel/extable.c:
> 	#if defined(ARCH_HAS_SORT_EXTABLE)&&  !defined(ARCH_HAS_SORTED_EXTABLE)
> 	void __init sort_main_extable(void)
> 	{
> 		sort_extable(__start___ex_table, __stop___ex_table);
> 	}
> 	#endif
>


Yes, I am familiar with that code.  One thing to keep in mind is that 
the compiler has access to struct exception_table_entry, and can easily 
figure out both how big the structure is *and* where the insn field is 
within the structure.

This is not the case for the author of sortextable.  Except for MIPS, 
MIPS64, i386 and x86_64, I know neither the size of struct 
exception_table_entry, nor the offset of its insn field.

For those with knowledge of the inner working of other architectures, it 
may be as simple as a two line patch to add support, but it isn't 
something that I want to take responsibility for at this point

> this way all the people not doing unique stuff work out of the box.  only the
> people who are doing funky stuff need to extend things.

I didn't want to include something like this that I cannot test.  An 
unsorted (or improperly sorted) exception table is not necessarily 
something that will be noticeable by simply booting the kernel.  Your 
only indication may be a panic or OOPS under rarely encountered conditions.

David Daney
