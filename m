Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab2LLWpn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 17:45:43 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:49775 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343Ab2LLWpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 17:45:42 -0500
Message-ID: <50C90935.5050404@ti.com>
Date: Wed, 12 Dec 2012 23:46:13 +0100
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
CC: <linux-kernel@vger.kernel.org>, <r.sricharan@ti.com>,
        <rmk+kernel@arm.linux.org.uk>,
        ARM PORT <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: decompressor: Flush tlb before swiching domain 0
 to client mode
References: <1355276466-18295-1-git-send-email-arve@android.com> <50C85807.2000609@ti.com> <CAMP5Xgdj_w_Kdek2WY-k73Od9DRfMpwnBuTfu9WKJFJnQ3VARQ@mail.gmail.com>
In-Reply-To: <CAMP5Xgdj_w_Kdek2WY-k73Od9DRfMpwnBuTfu9WKJFJnQ3VARQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 December 2012 11:27 PM, Arve Hjønnevåg wrote:
> On Wed, Dec 12, 2012 at 2:10 AM, Santosh Shilimkar
> <santosh.shilimkar@ti.com> wrote:
>> On Wednesday 12 December 2012 02:41 AM, Arve Hjønnevåg wrote:
>>>
>>> If the bootloader used a page table that is incompatible with domain 0
>>> in client mode, then swithing domain 0 to client mode causes a fault
>>> if we don't flush the tlb after updating the page table pointer.
>>>
>>> Signed-off-by: Arve Hjønnevåg <arve@android.com>
>>> ---
>>>    arch/arm/boot/compressed/head.S |    1 +
>>>    1 files changed, 1 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/arch/arm/boot/compressed/head.S
>>> b/arch/arm/boot/compressed/head.S
>>> index 90275f0..9c8034c 100644
>>> --- a/arch/arm/boot/compressed/head.S
>>> +++ b/arch/arm/boot/compressed/head.S
>>> @@ -704,6 +704,7 @@ __armv7_mmu_cache_on:
>>>                  bic     r6, r6, #1 << 31        @ 32-bit translation
>>> system
>>>                  bic     r6, r6, #3 << 0         @ use only ttbr0
>>>                  mcrne   p15, 0, r3, c2, c0, 0   @ load page table pointer
>>> +               mcrne   p15, 0, r0, c8, c7, 0   @ flush I,D TLBs
>>>                  mcrne   p15, 0, r1, c3, c0, 0   @ load domain access
>>> control
>>>                  mcrne   p15, 0, r6, c2, c0, 2   @ load ttb control
>>>    #endif
>>>
>> The TLB's are already flushed few lines above so above patching
>> shouldn't help if it was really dirty TLB entry issue. I suspect that
>> your boot-loader clean-up [1] function may not be taking care of
>> flushing caches which could potetially lead to the issue.
>>
>> Have you checked that ?
>>
>
> No, the problem is that the mmu is on when that first tlb flush
> happens so the tlb entry for the code that is executing gets reloaded
> from the old page table. This is probably a bootloader bug, but I
> don't have the bootloader source and 3.4 boots with the same
> bootloader.
>
Yes. The MMU is suppose to be turned off by boot-loader before jumping
to the kernel. That explains the problem. No need to patch
the kernel here.

Regards
Santosh
