Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460Ab2JIGd7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 02:33:59 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34959 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab2JIGdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 02:33:55 -0400
MIME-Version: 1.0
In-Reply-To: <5073C05E.5020402@zytor.com>
References: <1349757558-10856-1-git-send-email-yinghai@kernel.org>
	<1349757558-10856-9-git-send-email-yinghai@kernel.org>
	<5073C05E.5020402@zytor.com>
Date: Mon, 8 Oct 2012 23:33:54 -0700
X-Google-Sender-Auth: iC-7ZPfulD2eGfim3u8CGO1cGmw
Message-ID: <CAE9FiQXa9fqLOyqzap6o_0HA=oBRKqkcWm9bdpK9M6R5cQMU-A@mail.gmail.com>
Subject: Re: [PATCH 08/10] x86, xen, mm: fix mapping_pagetable_reserve logic
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Jacob Shin <jacob.shin@amd.com>, Tejun Heo <tj@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 8, 2012 at 11:12 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 10/09/2012 12:39 PM, Yinghai Lu wrote:
>>   */
>>  struct x86_init_mapping {
>> -     void (*pagetable_reserve)(u64 start, u64 end);
>> +     void (*make_range_readwrite)(u64 start, u64 end);
>>  };
>>
>
> Here you go from one misleading name to another.  Another classic case
> of "why hooks suck."

Run out of idea to have name for it.

>
> make_range_readwrite is particularly toxic, though, because it makes it
> sound like it something along the lines of set_memory_rw(), which it
> most distinctly is not.

it just change some page range from RO back to RW.

so how about update_range_ro_to_rw?

>
> Furthermore, the naming makes me really puzzled why it is there at all.
>  It makes me suspect, but because the patchset is so messy, it is hard
> for me to immediately prove, that you're still missing something important.
>
> However, for example:
>
>> unsigned long __initdata pgt_buf_start;
>>  unsigned long __meminitdata pgt_buf_end;
>>  unsigned long __meminitdata pgt_buf_top;
>> +unsigned long __initdata early_pgt_buf_start;
>> +unsigned long __meminitdata early_pgt_buf_end;
>> +unsigned long __meminitdata early_pgt_buf_top;
>>
>>  bool __init is_pfn_in_early_pgt_buf(unsigned long pfn)
>>  {
>> -     return pfn >= pgt_buf_start && pfn < pgt_buf_top;
>> +     return (pfn >= early_pgt_buf_start && pfn < early_pgt_buf_top) ||
>> +            (pfn >= pgt_buf_start && pfn < pgt_buf_top);
>>  }
>
> Magic variables augmented with more magic variables.  Why?  This also
> seems to assume that we still do all the kernel page tables in one
> chunk, which is exactly what we don't want to do.

for 64bit, page table will be three parts
1. initial page table from arch/x86/kernel/head_64.S
2. page table from BRK.
3. page near end of RAM.

verified from /sys/kernel/debug/kernel_page_tables

only range E820_RAM is mapped.

all initial page table for hole between [0, 1G) get cleared too.

Thanks

Yinghai
