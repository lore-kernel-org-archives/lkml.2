Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601Ab0JRSCJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 14:02:09 -0400
Received: from smarthost02.mail.zen.net.uk ([212.23.3.141]:60895 "EHLO
	smarthost02.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754809Ab0JRSCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 14:02:07 -0400
Message-ID: <4CBC8B99.60806@cyconix.com>
Date: Mon, 18 Oct 2010 19:02:01 +0100
From: Tom Brown <sa212+emis@cyconix.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Yong Zhang <yong.zhang@windriver.com>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: Question: how to copy to user space from a tasklet
References: <4CB6DEC4.4040408@cyconix.com> <4CB7ED67.2000407@s5r6.in-berlin.de> <4CBC6BA0.60507@cyconix.com> <4CBC7D62.6040408@s5r6.in-berlin.de>
In-Reply-To: <4CBC7D62.6040408@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-Smarthost02-IP: [82.70.243.134]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/10/2010 18:01, Stefan Richter wrote:
> Tom Brown wrote:
>> Thanks, think I'm there:
>>
>> 1 - The user calls mmap() with a specific offset to flag that he wants a
>> DMA buffer
>>
>> 2 - I then 'vmalloc' the buffer, and call 'setPageReserved' for each page
>>
>> I then step over each page, and:
>>
>> 3 - call 'vmalloc_to_pfn' to get a PFN for each page, and then
>>
>> 4 - call 'remap_page_range' for that page (I instead call
>> 'remap_pfn_range' for kernels>= 2.6.10, but I'm on 2.6.9)
>>
>> This gives me the buffer, and the interrupt handler then just uses
>> 'memcpy' to copy data to the user.
>
> I would have thought of a bunch of alloc_page() and vm_insert_page() but I
> don't know if vm_insert_page exists in 2.6.9 and if it honors user limits.

It turns out that I'm getting occasional

"BUG: unable to handle kernel paging request at virtual address 
...[buffer address]"

oops when the driver attempts to 'memcpy' to the buffer, so I think 
'setPageReserved' is probably not the right thing to do.  This is 
strange - it's almost as if 'setPageReserved' stops the page being 
swapped out, but the kernel doesn't know this.

I'll look into alloc_page/vm_insert_page instead.

Thanks -

Tom
