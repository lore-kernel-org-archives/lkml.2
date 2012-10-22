Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095Ab2JVS4m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 14:56:42 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47966 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155Ab2JVS4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 14:56:40 -0400
MIME-Version: 1.0
In-Reply-To: <20121022150620.GA22780@phenom.dumpdata.com>
References: <1350593430-24470-1-git-send-email-yinghai@kernel.org>
	<1350593430-24470-10-git-send-email-yinghai@kernel.org>
	<20121022150620.GA22780@phenom.dumpdata.com>
Date: Mon, 22 Oct 2012 11:56:39 -0700
X-Google-Sender-Auth: BJYJx4RWePDvom0_rT6JpHJc44s
Message-ID: <CAE9FiQX00rNK1OKG0DC=e+tt_vnLG4vtWvUQif_zJo_2M9SPJw@mail.gmail.com>
Subject: Re: [PATCH 06/19] x86, mm: setup page table in top-down
From: Yinghai Lu <yinghai@kernel.org>
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 8:06 AM, Konrad Rzeszutek Wilk
<konrad@kernel.org> wrote:
> On Thu, Oct 18, 2012 at 01:50:17PM -0700, Yinghai Lu wrote:
>
> You might want to mention how 'memblock' searches for regions.
> Presumarily it is from top to bottom.

that is not related. Will add explanation about min_pfn_mapped.

>
>
> And also explain the granularity of what the size you are mapping
> _after_ you are done with the PMD_SIZE.

will add reason for step_size
>> +     /* step_size need to be small so pgt_buf from BRK could cover it */
>> +     step_size = PMD_SIZE;
>> +     max_pfn_mapped = 0; /* will get exact value next */
>
> next in the init_rnage_memory_mapping? Might want to spell that out.

the loop and
   init_range_memory_mapping==>init_memory_mapping ==> add_pfn_range_mapped

>
>> +     min_pfn_mapped = real_end >> PAGE_SHIFT;
>> +     last_start = start = real_end;
>
> Might want to add a comment here saying:
>
> "We are looping from the top to the bottom."
>
>> +     while (last_start > ISA_END_ADDRESS) {
>> +             if (last_start > step_size) {
>> +                     start = round_down(last_start - 1, step_size);
>> +                     if (start < ISA_END_ADDRESS)
>> +                             start = ISA_END_ADDRESS;
>> +             } else
>> +                     start = ISA_END_ADDRESS;
>> +             new_mapped_ram_size = init_range_memory_mapping(start,
>> +                                                     last_start);
>> +             last_start = start;
>> +             min_pfn_mapped = last_start >> PAGE_SHIFT;
>> +             if (new_mapped_ram_size > mapped_ram_size)
>> +                     step_size <<= 5;
>
> Should '5' have a #define value?

yes.

>
>> +             mapped_ram_size += new_mapped_ram_size;
>> +     }
>
> It looks like the step_size would keep on increasing on every loop.
> First it would be 2MB, 64MB, then 2GB, and so - until the amount
> of memory that has been mapped is greater then unmapped.
> Is that right?
>
> I am basing that assumption on that the "new_mapped_ram_size"
> would return the size of the newly mapped region (start, last_start)
> in bytes. And the 'mapped_ram_size' is the size of the previously
> mapped region plus all the other ones.
>
> The logic being that  at the start of execution you start with a 2MB,
> compare it to 0, and increase step_size up to 64MB. Then start
> at real_end-2MB-step_size -> real_end-2MB-1. That gets you a 64MB chunk.
>
> Since new_mapped_ram_size (64MB) > mapped_ram_sized (2MB)
> you increase step_size once more.
>
> If so, you should also explain that in the git commit description and
> in the loop logic..

that logic is hard to understand from code?

updated changelog:

---
Get pgt_buf early from BRK, and use it to map PMD_SIZE from top at first.
Then use mapped pages to map more ranges below, and keep looping until
all pages get mapped.

alloc_low_page will use page from BRK at first, after that buffer is used
up, will use memblock to find and reserve pages for page table usage.

Introduce min_pfn_mapped to make sure find new pages from mapped ranges,
that will be updated when lower pages get mapped.

Also add step_size to make sure that don't try to map too big range with
limited mapped pages initially, and increase the step_size when we have
more mapped pages on hand.

At last we can get rid of calculation and find early pgt related code.

---
