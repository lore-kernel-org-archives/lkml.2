Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450Ab0C1Avy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 20:51:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:46122 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754409Ab0C1Avw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 20:51:52 -0400
Message-ID: <4BAEA7BE.1030707@kernel.org>
Date: Sat, 27 Mar 2010 17:50:06 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH -v3] x86: Make sure free_init_pages() free pages in boundary
References: <1269642114-16588-1-git-send-email-yinghai@kernel.org> <1269642114-16588-3-git-send-email-yinghai@kernel.org> <20100326230615.GB29222@cmpxchg.org> <4BAD4734.8020503@kernel.org> <20100327000723.GF29222@cmpxchg.org> <4BAD5D25.5060909@kernel.org> <20100328000306.GA10304@cmpxchg.org>
In-Reply-To: <20100328000306.GA10304@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2010 05:03 PM, Johannes Weiner wrote:
> Hi,
> 
> On Fri, Mar 26, 2010 at 06:19:33PM -0700, Yinghai Lu wrote:
>>
>>
>> When CONFIG_NO_BOOTMEM, it could use memory more effient, or more compact.
>>
>> Example is:
>> Allocated new RAMDISK: 00ec2000 - 0248ce57
>> Move RAMDISK from 000000002ea04000 - 000000002ffcee56 to 00ec2000 - 0248ce56
>>
>> The new RAMDISK's end is not page aligned.
>> Last page could use shared with other user.
>>
>> When free_init_pages are called for initrd or .init, the page could be freed
>> could have chance to corrupt other data.
>>
>> code segment in free_init_pages()
>> |        for (; addr < end; addr += PAGE_SIZE) {
>> |                ClearPageReserved(virt_to_page(addr));
>> |                init_page_count(virt_to_page(addr));
>> |                memset((void *)(addr & ~(PAGE_SIZE-1)),
>> |                        POISON_FREE_INITMEM, PAGE_SIZE);
>> |                free_page(addr);
>> |                totalram_pages++;
>> |        }
>> last half page could be used as one whole free page.
>>
>> Try to make the boundaries to be page aligned.
>>
>> -v2: make the original initramdisk to be aligned, according to Johannes.
>>      otherwise we have chance to lose one page.
>>      we still need to keep initrd_end not aligned, otherwise it could
>>      confuse decompresser.
>> -v3: change to WARN_ON instead according to Johannes.
>>
>> Reported-by: Stanislaw Gruszka <sgruszka@redhat.com>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> Here is what I had in mind when I wrote what you did not read, maybe diff
> works better?
> 
> Main differences:
>   o only fix the area allocation in relocate_initrd(), no need to do
>     copy the alignment bits
>   o keep alignment fixups in free_init_pages() out of line
>   o use PAGE_SIZE(); you might dislike the name, it is still the proper
>     operation here.  if you want to fix it, please do it properly
...
> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
> index e71c5cb..018e793 100644
> --- a/arch/x86/mm/init.c
> +++ b/arch/x86/mm/init.c
> @@ -336,6 +336,11 @@ void free_init_pages(char *what, unsigned long begin, unsigned long end)
>  	if (addr >= end)
>  		return;
>  
> +	if (WARN_ON(addr & ~PAGE_MASK || end & ~PAGE_MASK)) {
> +		addr = PAGE_ALIGN(addr);
> +		end &= PAGE_MASK;
> +	}
> +
>  	/*
>  	 * If debugging page accesses then do not free this memory but
>  	 * mark them not present - any buggy init-section access will
> @@ -355,11 +360,10 @@ void free_init_pages(char *what, unsigned long begin, unsigned long end)
>  
>  	printk(KERN_INFO "Freeing %s: %luk freed\n", what, (end - begin) >> 10);
>  
> -	for (; addr < end; addr += PAGE_SIZE) {
> +	for (; addr != end; addr += PAGE_SIZE) {
>  		ClearPageReserved(virt_to_page(addr));
>  		init_page_count(virt_to_page(addr));
> -		memset((void *)(addr & ~(PAGE_SIZE-1)),
> -			POISON_FREE_INITMEM, PAGE_SIZE);
> +		memset((void *)addr, POISON_FREE_INITMEM, PAGE_SIZE);
>  		free_page(addr);
>  		totalram_pages++;
>  	}
something wrong here, if someone pass (0x10, 0x20), the will be aligned to [0x1000, 0]
you will get dead loop 

will update that.

YH
