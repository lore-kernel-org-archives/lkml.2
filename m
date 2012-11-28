Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932288Ab2K1UQU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 15:16:20 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35334 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932136Ab2K1UQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 15:16:18 -0500
MIME-Version: 1.0
In-Reply-To: <20121128175007.GN21266@phenom.dumpdata.com>
References: <1353123563-3103-1-git-send-email-yinghai@kernel.org>
	<1353123563-3103-22-git-send-email-yinghai@kernel.org>
	<20121128175007.GN21266@phenom.dumpdata.com>
Date: Wed, 28 Nov 2012 12:16:16 -0800
X-Google-Sender-Auth: x_lvEpVHKWpUMrL3WHlEbkzzP4o
Message-ID: <CAE9FiQWVL3mq7dCP1g_euK_7PK2gUE+1XXNoZPsqt+wnFdtFhw@mail.gmail.com>
Subject: Re: [PATCH v8 21/46] x86, mm: setup page table in top-down
From: Yinghai Lu <yinghai@kernel.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 9:50 AM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
>>  /*
>> - * Iterate through E820 memory map and create direct mappings for only E820_RAM
>> - * regions. We cannot simply create direct mappings for all pfns from
>> - * [0 to max_low_pfn) and [4GB to max_pfn) because of possible memory holes in
>> - * high addresses that cannot be marked as UC by fixed/variable range MTRRs.
>> - * Depending on the alignment of E820 ranges, this may possibly result in using
>> - * smaller size (i.e. 4K instead of 2M or 1G) page tables.
>> + * would have hole in the middle or ends, and only ram parts will be mapped.
>
>
> What? What is the 'would' refering to? Why remove a good comment that explains
> the function. Why not just modify it a bit please?
>

==> update to

/*
 * We need to iterate through E820 memory map and create direct mappings
 * for only E820_RAM and E820_KERN_RESERVED regions. We cannot simply
 * create direct mappings for all pfns from [0 to max_low_pfn) and
 * [4GB to max_pfn) because of possible memory holes in high addresses
 * that cannot be marked as UC by fixed/variable range MTRRs.
 * Depending on the alignment of E820 ranges, this may possibly result
 * in using smaller size (i.e. 4K instead of 2M or 1G) page tables.
 *
 * init_mem_mapping call init_range_memory_mapping with big range.
 * That range would have hole in the middle or ends, and only ram parts
 * will be mapped in init_range_memory_mapping.
 */



>> -     max_pfn_mapped = 0; /* will get exact value next */
>>       /* the ISA range is always mapped regardless of memory holes */
>>       init_memory_mapping(0, ISA_END_ADDRESS);
>> -     init_range_memory_mapping(ISA_END_ADDRESS, end);
>> +
>> +     /* xen has big range in reserved near end of ram, skip it at first */
>
> I am not seeing the logic for doing it? The loop is quite generic
> in doing it in reverse order, and the memblock_find_in_range
> gets a nice PMD_SIZE region from the end of the memory.
>
> If the memory at the end is reserved, then it looks like it won't
> be even considered in the loop, but it does get included in the fallback:
>
>         if (real_end < end)
>                 init_range_memory_mapping(real_end, end);

that reserved in in memblock.reserved and it is not in e820.

so memblock.memory will have that range too. then if we use all of
first 2M to map

those reserved range, we would not have enough mapped pages to be used
as new page tables.

>
>
>
>> +     addr = memblock_find_in_range(ISA_END_ADDRESS, end, PMD_SIZE,
>> +                      PAGE_SIZE);
>> +     real_end = addr + PMD_SIZE;
>> +
>> +     /* step_size need to be small so pgt_buf from BRK could cover it */
>> +     step_size = PMD_SIZE;
>> +     max_pfn_mapped = 0; /* will get exact value next */
>> +     min_pfn_mapped = real_end >> PAGE_SHIFT;
>> +     last_start = start = real_end;
>
> Everytime I look at this loop, I keep on forgetting that it goes in reverse.
> I am not sure if it is just me, but it might be useful for other
> folks who are going to look at this in a year or so to have
> a little hint:
>
> N.B. We start from the top (end of memory) and go to the bottom. The
> memblock_find_in_range gets us a block of RAM from the end
> of RAM.

put the that in the comments.
