Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207Ab1L2NoZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 08:44:25 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43601 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036Ab1L2NoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 08:44:24 -0500
Message-ID: <4EFC6EB3.3010905@monstr.eu>
Date: Thu, 29 Dec 2011 14:44:19 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
CC: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Sam Ravnborg <sam@ravnborg.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: memblock and bootmem problems if start + size = 4GB
References: <4EEF42F5.7040002@monstr.eu> <20111219162835.GA24519@google.com> <4EF05316.5050803@monstr.eu>
In-Reply-To: <4EF05316.5050803@monstr.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Simek wrote:
> Hi Tejun,
> 
>> On Mon, Dec 19, 2011 at 02:58:13PM +0100, Michal Simek wrote:
>>> I have reached some problems with memblock and bootmem code for some 
>>> configurations.
>>> We can completely setup the whole system and all addresses in it.
>>> The problem happens if we place main memory to the end of address 
>>> space when
>>> mem_start + size reach 4GB limit.
>>>
>>> For example:
>>> mem_start      0xF000 0000
>>> mem_size       0x1000 0000 (or better lowmem size)
>>> mem_end        0xFFFF FFFF
>>> start + size 0x1 0000 0000 (u32 limit reached).
>>>
>>> I have done some patches which completely remove start + size values 
>>> from architecture specific
>>> code but I have found some problem in generic code too.
>>>
>>> For example in bootmem code where are three places where physaddr + 
>>> size is used.
>>> I would prefer to retype it to u64 because baseaddr and size don't 
>>> need to be 2^n.
>>>
>>> Is it correct solution? If yes, I will create proper patch.
>>
>> Yeah, that's an inherent problem in using [) ranges but I think
>> chopping off the last page probably is simpler and more robust
>> solution.  Currently, memblock_add_region() would simply ignore if
>> address range overflows but making it just ignore the last page is
>> several lines of addition.  Wouldn't that be effective enough while
>> staying very simple?
> 
> The main problem is with PFN_DOWN/UP macros and it is in __init section.
> The result will be definitely u32 type (for 32bit archs) anyway and 
> seems to me
> better solution than ignoring the last page.
> 
> Is there any internal kernel test code to test all pages - try to 
> allocate/use/test it?
> It will be especially good to do so on the last page to see if there is 
> any problem or not.
> 
> That two conditions in memblock should be ok.

Tejun and Andrew: any other comment?

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
