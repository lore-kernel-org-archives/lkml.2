Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773Ab2JVQbj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 12:31:39 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49718 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755443Ab2JVQbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 12:31:06 -0400
MIME-Version: 1.0
In-Reply-To: <20121022141633.GB14193@konrad-lan.dumpdata.com>
References: <1350593430-24470-1-git-send-email-yinghai@kernel.org>
	<1350593430-24470-3-git-send-email-yinghai@kernel.org>
	<20121022141633.GB14193@konrad-lan.dumpdata.com>
Date: Mon, 22 Oct 2012 09:31:05 -0700
X-Google-Sender-Auth: 7S1BKV1Dm5xkpg1Irw3k6I_YfeA
Message-ID: <CAE9FiQWG48oqBvD09NVTWqrMGj9SfbgRAAbgGq+qn=_7yvOnHA@mail.gmail.com>
Subject: Re: [PATCH 01/19] x86, mm: Align start address to correct big page size
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

On Mon, Oct 22, 2012 at 7:16 AM, Konrad Rzeszutek Wilk
<konrad@kernel.org> wrote:
>>On Thu, Oct 18, 2012 at 01:50:10PM -0700, Yinghai Lu wrote:
>
>
> I am pretty sure I gave you some ideas of how to fix up the commit
> description in earlier reviews, but it looks like you missed them.
>
> Let me write them here once more.
>
>> We are going to use buffer in BRK to pre-map page table buffer.
>
> What buffer? Is buffer the same thing as page table?
>>
>> Page table buffer could be only page aligned, but range around it are
>
> .. ranges
>> ram too, we could use bigger page to map it to avoid small pages.
>>
>> We will adjust page_size_mask in next patch to use big page size for
>
> Instead of saying "next patch" - include the title of the patch
> so that one can search for it.
>
>> small ram range.
>>
>> Before that, this patch will make start address to be aligned down
>
> s/will make/made/
>
>> according to bigger page size, otherwise entry in page page will
>> not have correct value.
>
>
> I would structure this git commit description to first introduce
> the problem.
>
> Say at the start of the patch:
>
> "Before this patch, the start address was aligned down according
> to bigger a page size (1GB, 2MB). This is a problem b/c an
> entry in the page table will not have correct value. "
>
> Here can you explain why it does not have the correct value?
>> +                             pfn_pte((address & PMD_MASK) >> PAGE_SHIFT,
>>                                       __pgprot(pgprot_val(prot) | _PAGE_PSE)));
>>                       spin_unlock(&init_mm.page_table_lock);
>>                       last_map_addr = next;
>> @@ -536,7 +536,8 @@ phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end,
>>                       pages++;
>>                       spin_lock(&init_mm.page_table_lock);
>>                       set_pte((pte_t *)pud,
>> -                             pfn_pte(addr >> PAGE_SHIFT, PAGE_KERNEL_LARGE));
>> +                             pfn_pte((addr & PUD_MASK) >> PAGE_SHIFT,
>> +                                     PAGE_KERNEL_LARGE));
>>                       spin_unlock(&init_mm.page_table_lock);
>>                       last_map_addr = next;
>>                       continue;
>> --

will update commit log to:

----
We are going to use buffer in BRK to map small range just under memory top,
and use those new mapped ram to map low ram range under it.

The ram range that will be mapped at fist could be only page aligned,
but ranges around it are ram too, we could use bigger page to map it to
avoid small pages.

We will adjust page_size_mask in following patch:
        x86, mm: Use big page size for small memory range
to use big page size for small ram range.

Before that patch, this patch will make sure start address to be
aligned down according to bigger page size, otherwise entry in page
page will not have correct value.

---
