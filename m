Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365Ab2KAEUr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 00:20:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35159 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750946Ab2KAEUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 00:20:46 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <88DC34334CA3444C85D647DBFA962C270FD7EF68@SHSMSX102.ccr.corp.intel.com>
References: <88DC34334CA3444C85D647DBFA962C270FD7EAD3@SHSMSX102.ccr.corp.intel.com> <50909120.3040101@zytor.com> <88DC34334CA3444C85D647DBFA962C270FD7EB0B@SHSMSX102.ccr.corp.intel.com> <5090AB3C.5050405@zytor.com> <88DC34334CA3444C85D647DBFA962C270FD7EB3A@SHSMSX102.ccr.corp.intel.com> <5090B966.4040605@zytor.com> <88DC34334CA3444C85D647DBFA962C270FD7EF68@SHSMSX102.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: RE: [PATCH] To crash dump, we need keep other memory type except E820_RAM, because other type come from BIOS or firmware is used by other code(for example: PCI_MMCONFIG).
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 31 Oct 2012 21:20:23 -0700
To: "Zhang, Jun" <jun.zhang@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Fleming, Matt" <matt.fleming@intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <c6a025f9-0ac5-45d7-bda9-7f9bc8eaf9ab@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2) would make most sense to me, but I'd be okay with 3) as well.

"Zhang, Jun" <jun.zhang@intel.com> wrote:

>Hello, Anvin
>
>I want to explain why I modify in this place. In kexec, it pass three
>parameters, memmap=exactmap memmap=544K@64K memmap=64964K@32768K
>I think my patch modify the least code. 
>Actually, there are some choise to fix it. 
>1)  my patch.
>2)  modify kexec, only pass two parameters -- memmap=544K@64K
>memmap=64964K@32768K, in kernel setup_memory_map, we can remove RAM
>range.
>3)  add extra optional, like memmap=REMOVERAM
>
>Which one do you like? Maybe you have better solution, please share it.
>Thanks!
>
>Best Regards!
>
>Jun Zhang
>Inet: 8821-4273
>Dir.Tel: 86-21-6116-4273
>Email: jun.zhang@intel.com
>
>-----Original Message-----
>From: H. Peter Anvin [mailto:hpa@zytor.com] 
>Sent: Wednesday, October 31, 2012 1:39 PM
>To: Zhang, Jun
>Cc: Thomas Gleixner; Ingo Molnar; x86@kernel.org; Andrew Morton;
>Fleming, Matt; Paul Gortmaker; linux-kernel@vger.kernel.org
>Subject: Re: [PATCH] To crash dump, we need keep other memory type
>except E820_RAM, because other type come from BIOS or firmware is used
>by other code(for example: PCI_MMCONFIG).
>
>On 10/30/2012 10:22 PM, Zhang, Jun wrote:
>> Hello, Anvin
>>    You are right. Thanks!
>>
>> Hello, All
>>    Please review it again. Thanks!
>>
>>  From bf7506ac7e9ce0df0b915164dbb7a6d858ef2e40 Mon Sep 17 00:00:00 
>> 2001
>> From: jzha144 <jun.zhang@intel.com>
>> Date: Wed, 31 Oct 2012 08:51:18 +0800
>> Subject: [PATCH] When we are doing a crash dump, we still need
>non-E820_RAM
>>   memory type address information in order to do I/O. so only
>>   remove all RAM ranges which need to be dumped.
>>
>> Signed-off-by: jzha144 <jun.zhang@intel.com>
>> ---
>>   arch/x86/kernel/e820.c |    9 +++++++++
>>   1 files changed, 9 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c index 
>> df06ade..77be839 100644
>> --- a/arch/x86/kernel/e820.c
>> +++ b/arch/x86/kernel/e820.c
>> @@ -851,6 +851,15 @@ static int __init parse_memmap_opt(char *p)
>>   		 * reset.
>>   		 */
>>   		saved_max_pfn = e820_end_of_ram_pfn();
>> +
>> +		/*
>> +		 * We are doing a crash dump, so remove all RAM ranges
>> +		 * as they are the ones that need to be dumped.
>> +		 * We still need all non-RAM information in order to do I/O.
>> +		 */
>> +		e820_remove_range(0, ULLONG_MAX, E820_RAM, 1);
>> +		userdef = 1;
>> +		return 0;
>>   #endif
>>   		e820.nr_map = 0;
>>   		userdef = 1;
>>
>
>The code is still wrong...
>
>	-hpa
>
>
>--
>H. Peter Anvin, Intel Open Source Technology Center I work for Intel. 
>I don't speak on their behalf.

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
