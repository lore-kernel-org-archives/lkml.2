Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372Ab2GXO7h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 10:59:37 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:47102 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753447Ab2GXO7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 10:59:36 -0400
Message-ID: <500EB845.3020600@ti.com>
Date: Tue, 24 Jul 2012 10:59:17 -0400
From: Cyril Chemparathy <cyril@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <nico@linaro.org>, <will.deacon@arm.com>, <catalin.marinas@arm.com>,
        Vitaly Andrianov <vitalya@ti.com>
Subject: Re: [RFC 23/23] ARM: keystone: add switch over to high physical address
 range
References: <1343092165-9470-1-git-send-email-cyril@ti.com> <1343092165-9470-24-git-send-email-cyril@ti.com> <201207241439.25314.arnd@arndb.de>
In-Reply-To: <201207241439.25314.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-15"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/24/2012 10:39 AM, Arnd Bergmann wrote:
> On Tuesday 24 July 2012, Cyril Chemparathy wrote:
>> Keystone platforms have their physical memory mapped at an address outside the
>> 32-bit physical range.  A Keystone machine with 16G of RAM would find its
>> memory at 0x0800000000 - 0x0bffffffff.
>>
>> For boot purposes, the interconnect supports a limited alias of some of this
>> memory within the 32-bit addressable space (0x80000000 - 0xffffffff).  This
>> aliasing is implemented in hardware, and is not intended to be used much
>> beyond boot.  For instance, DMA coherence does not work when running out of
>> this aliased address space.
>>
>> Therefore, we've taken the approach of booting out of the low physical address
>> range, and subsequently we switch over to the high range once we're safely
>> inside machine specific territory.  This patch implements this switch over
>> mechanism, which involves rewiring the TTBRs and page tables to point to the
>> new physical address space.
>>
>> Signed-off-by: Vitaly Andrianov <vitalya@ti.com>
>> Signed-off-by: Cyril Chemparathy <cyril@ti.com>
>
> I think this needs some more explanations. Why is not not possible
> to use this the larger area from the start when we first enable
> paging?

By enable paging, I assume you refer to the head.S init.  For this the 
boot code needs to get the "real physical address" from somewhere 
instead of having to deduce it from the program counter.  We could do 
this by parsing DTB in the decompressor, and passing in a 64-bit physmem 
pointer into the kernel startup code.

We'd considered this approach (at least briefly), but then balked at (a) 
having to change the entry conditions into head.S code, and (b) baking 
in dependencies on the decompressor.

> Also, the code does not really look platform specific, so I could
> imagine that if you need it, other similar platforms will need the
> same thing, and it should be put into common code and enabled
> all the time when using LPAE.
>

Absolutely agreed.  Vitaly and I have been trying to work it out this 
way, and we hope to have something more common in the next version of 
this series.

> 	Arnd
>

-- 
Thanks
- Cyril
