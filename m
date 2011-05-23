Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762Ab1EWBaF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 21:30:05 -0400
Received: from 173-160-34-133-colorado.hfc.comcastbusiness.net ([173.160.34.133]:32311
	"EHLO ether.astekcorp.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752428Ab1EWBaC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 21:30:02 -0400
From: Dave Carroll <dcarroll@astekcorp.com>
To: "'Milton Miller'" <miltonm@bga.com>
CC: Paul Mackerras <paulus@samba.org>, LPPC <linuxppc-dev@lists.ozlabs.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Sun, 22 May 2011 19:29:42 -0600
Subject: RE: [PATCH v3] powerpc: Force page alignment for initrd reserved
 memory
Thread-Topic: [PATCH v3] powerpc: Force page alignment for initrd reserved
 memory
Thread-Index: AcwYxbbt15MAeWseSJm2zlfSwRRrGAAG1xyw
Message-ID: <522F24EF533FC546962ECFA2054FF777373072AB74@MAILSERVER2.cos.astekcorp.com>
In-Reply-To: <initrd-reserve-reply2@mdm.bga.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>On Sun, 22 May 2011 about 15:17, Milton Miller wrote:
>>On Sat, 21 May 2011 about 11:05:27 -0600, Dave Carroll wrote:>
>> When using 64K pages with a separate cpio rootfs, U-Boot will align
>> the rootfs on a 4K page boundary. When the memory is reserved, and
>> subsequent early memblock_alloc is called, it will allocate memory
>> between the 64K page alignment and reserved memory. When the reserved
>> memory is subsequently freed, it is done so by pages, causing the
>> early memblock_alloc requests to be re-used, which in my case, caused
>> the device-tree to be clobbered.
>>
>> This patch forces the reserved memory for initrd to be kernel page
>> aligned, and adds the same range extension when freeing initrd.
>
>Getting better, but
>
>>
>>
>> Signed-off-by: Dave Carroll <dcarroll@astekcorp.com>
>> ---
>>  arch/powerpc/kernel/prom.c |    4 +++-
>>  arch/powerpc/mm/init_32.c  |    3 +++
>>  arch/powerpc/mm/init_64.c  |    3 +++
>>  3 files changed, 9 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
>> index 48aeb55..397d4a0 100644
>> --- a/arch/powerpc/kernel/prom.c
>> +++ b/arch/powerpc/kernel/prom.c
>> @@ -555,7 +555,9 @@ static void __init early_reserve_mem(void)
>>  #ifdef CONFIG_BLK_DEV_INITRD
>>         /* then reserve the initrd, if any */
>>         if (initrd_start && (initrd_end > initrd_start))
>
>Here you test the unaligned values
>
>>  void free_initrd_mem(unsigned long start, unsigned long end)
>>  {
>> +       start = _ALIGN_DOWN(start, PAGE_SIZE);
>> +       end = _ALIGN_UP(end, PAGE_SIZE);
>> +
>>         if (start < end)
>>                 printk ("Freeing initrd memory: %ldk freed\n", (end - start) >> 10);
>
>But here you test the aligned values.  And they are aligned with
>opposite bias.  Which means that if start == end (or is less than,
>but within the same page), a page that wasn't reserved (same
>32 and 64 bit) gets freed.
>

Agreed ... I'll have the but shortly ...

>I thought "what happens if we are within a page of end, could we
>free the last page of bss?", but then I checked vmlinux.lds and we
>align end to page size.  I thought other allocations should be safe,
>but then remembered:
>
>The flattened device tree (of which we continue to use the string
>table after boot) could be a problem.
>

I had previouly looked at free_initrd_mem, and thought the same conditions
should be used to handle the memory release, but as for the explicit alignment
of the release areas, that seemed to be handled by the fact that all of the
releases are specifically page aligned. The remainder of the free_initrd_mem
routine:

        for (; start < end; start += PAGE_SIZE) {
                ClearPageReserved(virt_to_page(start));
                init_page_count(virt_to_page(start));
                free_page(start);
                totalram_pages++;
        }

implicitly aligns down start to a page boundary, and also would implicitly align
up the end address. While I would be a proponent of something like;

        if (start && (start < end)) do { remainder of free_initrd_mem }

I'm not sure of the goal in explicitly attempting to align the addresses in the
routine as you proposed.

As for the FDT, if the FDT is packed contiguous with initrd, and the alignment is on
4K page boundaries, it would have been released before this patch. In my case (U-Boot),
they are not near each other.

Thanks,
-Dave
>
>milton

