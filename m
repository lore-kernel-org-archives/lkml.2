Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710Ab1L3H6c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Dec 2011 02:58:32 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43702 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab1L3H63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Dec 2011 02:58:29 -0500
Message-ID: <4EFD6F22.5010501@monstr.eu>
Date: Fri, 30 Dec 2011 08:58:26 +0100
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
References: <4EEF42F5.7040002@monstr.eu> <20111219162835.GA24519@google.com> <4EF05316.5050803@monstr.eu> <20111229155836.GB3516@google.com> <4EFC995A.5090904@monstr.eu> <20111229170745.GE3516@google.com>
In-Reply-To: <20111229170745.GE3516@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Hello,
> 
> On Thu, Dec 29, 2011 at 05:46:18PM +0100, Michal Simek wrote:
>> First of all I don't like to use your term "extend range coverages".
>> We don't want to extend any ranges - we just wanted to place memory to the end
>> of address space and be able to work with.
> 
> It is, as long as we use address ranges.  Either we can express length
> of zero or include the last address.
> 
>> It is limitation which should be fixed somehow.
>> And I would expect that PFN_XX(base + size) will be in u32 range.
>>
>> Probably the best solution will be to use PFN macro in one place and
>> do not covert addresses in common code.
>>
>> + change parameters in bootmem code because some arch do
>> free_bootmem_node(..., PFN_PHYS(), ...)
>> and
>> reserve_bootmem_node(..., PFN_PHYS(), ...)
> 
> So now we're talking about a lot of code just for ONE page and
> regardless of the representation in the memblock or other memory
> management code, I think trying to use that page is fundamentally a
> bad idea.  There are a lot of places in the kernel where phys_addr_t
> is used. 

I haven't said to replace phys_addr_t!
My point was something like this (just as example on parisc and free_bootmem_node).
The problematic part is kmemleak code which could be good reason not to change it.

Thanks,
Michal


diff --git a/arch/parisc/mm/init.c b/arch/parisc/mm/init.c
index 82f364e..b83ee32 100644
--- a/arch/parisc/mm/init.c
+++ b/arch/parisc/mm/init.c
@@ -291,8 +291,8 @@ static void __init setup_bootmem(void)
                                                 start_pfn,
                                                 (start_pfn + npages) );
                 free_bootmem_node(NODE_DATA(i),
-                                 (start_pfn << PAGE_SHIFT),
-                                 (npages << PAGE_SHIFT) );
+                                 start_pfn,
+                                 npages);
                 bootmap_pfn += (bootmap_size + PAGE_SIZE - 1) >> PAGE_SHIFT;
                 if ((start_pfn + npages) > max_pfn)
                         max_pfn = start_pfn + npages;



diff --git a/mm/bootmem.c b/mm/bootmem.c
index 45a691a..dfbfc47 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -363,17 +363,12 @@ static int __init mark_bootmem(unsigned long start, unsigned long end,
   *
   * The range must reside completely on the specified node.
   */
-void __init free_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
-                             unsigned long size)
+void __init free_bootmem_node(pg_data_t *pgdat, unsigned long startpfn,
+                             unsigned long endpfn)
  {
-       unsigned long start, end;
-
-       kmemleak_free_part(__va(physaddr), size);
+       kmemleak_free_part(__va(startpfn << PAGE_SHIFT), (endpfn - startpfn) << PAGE_SHIFT);

-       start = PFN_UP(physaddr);
-       end = PFN_DOWN((u64)physaddr + (u64)size);
-
-       mark_bootmem_node(pgdat->bdata, start, end, 0, 0);
+       mark_bootmem_node(pgdat->bdata, startpfn, endpfn, 0, 0);
  }




-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
