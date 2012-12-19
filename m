Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796Ab2LSDaK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 22:30:10 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:53626 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569Ab2LSDaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 22:30:07 -0500
MIME-Version: 1.0
In-Reply-To: <20121214105327.GA4966@liondog.tnic>
References: <1355436141-8668-1-git-send-email-yinghai@kernel.org>
	<1355436141-8668-2-git-send-email-yinghai@kernel.org>
	<20121214105327.GA4966@liondog.tnic>
Date: Tue, 18 Dec 2012 19:30:06 -0800
X-Google-Sender-Auth: WjLVZ-7taV7zKo_FG7mUStiHkxo
Message-ID: <CAE9FiQVt9kwrwZysLe_KkEXHF-scRVA1-0UJqqu0NMs1h=jZMg@mail.gmail.com>
Subject: Re: [PATCH v6 01/27] x86, mm: Fix page table early allocation offset checking
From: Yinghai Lu <yinghai@kernel.org>
To: Borislav Petkov <bp@alien8.de>, Yinghai Lu <yinghai@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2012 at 2:53 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Thu, Dec 13, 2012 at 02:01:55PM -0800, Yinghai Lu wrote:
>> During debug load kernel above 4G, found one page if is not used in BRK
>> and it should be with early page allocation.
>
> What does that mean?
>
> I see that this patch adds a change to not use the page at pgt_buf_top
> anymore but why? Is pgt_buf_top the first invalid address we cannot
> reserve anymore?
>
> Generally, can we get this whole deal described in a bit more detail for
> the mere mortals among us, maybe a short ascii art thing showing what
> all those pgt_buf_{start,end,top} mean.
>

change that too:
---
Subject: [PATCH] x86, mm: Fix page table early allocation offset checking

During debug load kernel above 4G, found one page if is not used in BRK
and it should be with early page allocation.

pgt_buf_top is address that can not be used, so should check if then new
end is above than that top, otherwise last page will not used.

Fix that checking and also add print out for every allocation from BRK
---

>>  arch/x86/mm/init.c |    4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
>> index 6f85de8..c4293cf 100644
>> --- a/arch/x86/mm/init.c
>> +++ b/arch/x86/mm/init.c
>> @@ -47,7 +47,7 @@ __ref void *alloc_low_pages(unsigned int num)
>>                                               __GFP_ZERO, order);
>>       }
>>
>> -     if ((pgt_buf_end + num) >= pgt_buf_top) {
>> +     if ((pgt_buf_end + num) > pgt_buf_top) {
>>               unsigned long ret;
>>               if (min_pfn_mapped >= max_pfn_mapped)
>>                       panic("alloc_low_page: ran out of memory");
>> @@ -61,6 +61,8 @@ __ref void *alloc_low_pages(unsigned int num)
>>       } else {
>>               pfn = pgt_buf_end;
>>               pgt_buf_end += num;
>> +             printk(KERN_DEBUG "BRK [%#010lx, %#010lx] PGTABLE\n",
>
>                 pr_debug
>

I really hate pr_debug.

pr_debug is useless. it will not print out anything.

Yinghai
