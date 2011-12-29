Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703Ab1L2QqY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 11:46:24 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34966 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571Ab1L2QqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 11:46:22 -0500
Message-ID: <4EFC995A.5090904@monstr.eu>
Date: Thu, 29 Dec 2011 17:46:18 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Yinghai Lu <yinghai@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Sam Ravnborg <sam@ravnborg.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: memblock and bootmem problems if start + size = 4GB
References: <4EEF42F5.7040002@monstr.eu> <20111219162835.GA24519@google.com> <4EF05316.5050803@monstr.eu> <20111229155836.GB3516@google.com>
In-Reply-To: <20111229155836.GB3516@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Hello,
> 
> On Tue, Dec 20, 2011 at 10:19:18AM +0100, Michal Simek wrote:
>>> Yeah, that's an inherent problem in using [) ranges but I think
>>> chopping off the last page probably is simpler and more robust
>>> solution.  Currently, memblock_add_region() would simply ignore if
>>> address range overflows but making it just ignore the last page is
>>> several lines of addition.  Wouldn't that be effective enough while
>>> staying very simple?
>> The main problem is with PFN_DOWN/UP macros and it is in __init section.
>> The result will be definitely u32 type (for 32bit archs) anyway and seems to me
>> better solution than ignoring the last page.
> 
> Other than being able to use one more 4k page, is there any other
> benefit? Maybe others had different experiences but in my exprience
> trying to extend range coverages - be it stack top/end pointers,
> address ranges or whatnot - using [] ranges or special flag usually
> ended up adding complexity while adding almost nothing tangible.

First of all I don't like to use your term "extend range coverages".
We don't want to extend any ranges - we just wanted to place memory to the end
of address space and be able to work with. It is limitation which should be fixed somehow.
And I would expect that PFN_XX(base + size) will be in u32 range.

Probably the best solution will be to use PFN macro in one place and do not covert
addresses in common code.

+ change parameters in bootmem code because some arch do
free_bootmem_node(..., PFN_PHYS(), ...)
and
reserve_bootmem_node(..., PFN_PHYS(), ...)

and then in that functions(free/reseve_bootmem_code) are used PFN_DOWN/PFN_UP macros.
If alignment is handled by architecture code (which I believe is) then should be possible to change parameters.

For example:
void __init free_bootmem_node(pg_data_t *pgdat, unsigned long start_pfn,
			      unsigned long end_pfn)

int __init reserve_bootmem_node(pg_data_t *pgdat, unsigned long start_pfn,
				 unsigned long end_pfn, int flags)

Is there any reason to use use physical addresses instead of pfns in bootmem code?

 >  On
> extreme cases, people even carry separate valid flag to use %NULL as
> valid address, which is pretty silly, IMHO.  So, unless there's some
> benefit that I'm missing, I still think it's an overkill.  It's more
> complex and difficult to test and verify.  Why bother for a single
> page?

Where do you think this page should be placed? In common code or in architecture memory
code where one page from the top of 4G should be subtract?

Thanks,
Michal


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
