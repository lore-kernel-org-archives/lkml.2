Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab2JVQ4F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 12:56:05 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57984 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755443Ab2JVQ4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 12:56:03 -0400
MIME-Version: 1.0
In-Reply-To: <20121022142814.GD14193@konrad-lan.dumpdata.com>
References: <1350593430-24470-1-git-send-email-yinghai@kernel.org>
	<1350593430-24470-7-git-send-email-yinghai@kernel.org>
	<20121022142814.GD14193@konrad-lan.dumpdata.com>
Date: Mon, 22 Oct 2012 09:56:01 -0700
X-Google-Sender-Auth: A26rz1hXRITwwFwdeTdo2x0DSYo
Message-ID: <CAE9FiQXc7SPmTyX_jkJteO+3UU5+ifDviXNK+DD_1ryH0EsQOQ@mail.gmail.com>
Subject: Re: [PATCH 03/19] x86, mm: Don't clear page table if range is ram
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

On Mon, Oct 22, 2012 at 7:28 AM, Konrad Rzeszutek Wilk
<konrad@kernel.org> wrote:
> On Thu, Oct 18, 2012 at 01:50:14PM -0700, Yinghai Lu wrote:
>> After we add code use buffer in BRK to pre-map page table,
>                    ^- to
>
> So .. which patch is that? Can you include the title of the
> patch here?
>
>> it should be safe to remove early_memmap for page table accessing.
>> Instead we get panic with that.
>>
>> It turns out we clear the initial page table wrongly for next range that is
>               ^- that
>
>> separated by holes.
>> And it only happens when we are trying to map range one by one range separately.
>                                                      ^-s
>
>>
>> We need to check if the range is ram before clearing page table.
>
> Ok, so that sounds like a bug-fix... but
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> ---
>>  arch/x86/mm/init_64.c |   37 ++++++++++++++++---------------------
>>  1 files changed, 16 insertions(+), 21 deletions(-)
>>
>> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
>> index f40f383..61b3c44 100644
>> --- a/arch/x86/mm/init_64.c
>> +++ b/arch/x86/mm/init_64.c
>> @@ -363,20 +363,19 @@ static unsigned long __meminit
>>  phys_pte_init(pte_t *pte_page, unsigned long addr, unsigned long end,
>>             pgprot_t prot)
>>  {
>> -     unsigned pages = 0;
>> +     unsigned long pages = 0, next;
>>       unsigned long last_map_addr = end;
>>       int i;
>>
>>       pte_t *pte = pte_page + pte_index(addr);
>>
>> -     for(i = pte_index(addr); i < PTRS_PER_PTE; i++, addr += PAGE_SIZE, pte++) {
>> -
>> +     for (i = pte_index(addr); i < PTRS_PER_PTE; i++, addr = next, pte++) {
>> +             next = (addr & PAGE_MASK) + PAGE_SIZE;
>>               if (addr >= end) {
>> -                     if (!after_bootmem) {
>> -                             for(; i < PTRS_PER_PTE; i++, pte++)
>> -                                     set_pte(pte, __pte(0));
>> -                     }
>> -                     break;
>> +                     if (!after_bootmem &&
>> +                         !e820_any_mapped(addr & PAGE_MASK, next, 0))
>> +                             set_pte(pte, __pte(0));
>> +                     continue;
>
> .. Interestingly, you also removed the extra loop. How come? Why not
> retain the little loop? (which could call e820_any_mapped?) Is that
> an improvement and cleanup? If so, I would think you should at least
> explain in the git commit:

Merge that loop to top loop, and we need to use "next" from the top loop.

>
> "And while we are at it, also axe the extra loop and instead depend on
> the top loop which we can safely piggyback on."


update commit change log to:

---
After we add code use buffer in BRK to pre-map buf for page table in
following patch:
        x86, mm: setup page table in top-down
it should be safe to remove early_memmap for page table accessing.
Instead we get panic with that.

It turns out that we clear the initial page table wrongly for next range
that is separated by holes.
And it only happens when we are trying to map ram range one by one.

We need to check if the range is ram before clearing page table.

We change the loop structure to remove the extra little loop and use
one loop only, and in that loop will caculate next at first, and check if
[addr,next) is covered by E820_RAM.
---
