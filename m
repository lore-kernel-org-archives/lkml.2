Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149Ab2BCLQ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 06:16:57 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:36532 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756051Ab2BCLQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 06:16:56 -0500
X-AntiVirus: Checked by Dr.Web [version: 6.0.3.08040, engine: 6.0.200.12050, virus records: 2607051, updated:  3.02.2012]
Message-ID: <4F2BC1E1.2080702@ru.mvista.com>
Date: Fri, 03 Feb 2012 15:15:45 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Nicolas Pitre <nico@fluxnic.net>
CC: Stephen Boyd <sboyd@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: cache-v7: Disable preemption when reading CCSIDR
References: <1328234629-32735-1-git-send-email-sboyd@codeaurora.org> <alpine.LFD.2.02.1202022110080.2759@xanadu.home> <4F2B4873.5030808@codeaurora.org> <alpine.LFD.2.02.1202022202470.2759@xanadu.home>
In-Reply-To: <alpine.LFD.2.02.1202022202470.2759@xanadu.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 03-02-2012 7:04, Nicolas Pitre wrote:

>>>>> If you simply disable/restore IRQs around the critical region then you
>>>>> don't have to worry about __v7_setup.  Plus this will allow for
>>>>> v7_flush_dcache_all to still be callable from atomic context.
>>>> Ok. Here's a patch. I still need to test it. I'll send another patch
>>>> series to cleanup the get_thread_info stuff (there's two of them?).
>>>>
>>>>   arch/arm/mm/cache-v7.S |    6 ++++++
>>>>   1 files changed, 6 insertions(+), 0 deletions(-)
>>>>
>>>> diff --git a/arch/arm/mm/cache-v7.S b/arch/arm/mm/cache-v7.S
>>>> index 07c4bc8..654a5fc 100644
>>>> --- a/arch/arm/mm/cache-v7.S
>>>> +++ b/arch/arm/mm/cache-v7.S
>>>> @@ -54,9 +54,15 @@ loop1:
>>>>   	and	r1, r1, #7			@ mask of the bits for current cache only
>>>>   	cmp	r1, #2				@ see what cache we have at this level
>>>>   	blt	skip				@ skip if no cache, or just i-cache
>>>> +#ifdef CONFIG_PREEMPT
>>>> +	save_and_disable_irqs r9		@ make cssr&csidr read atomic
>>>> +#endif
>>>>   	mcr	p15, 2, r10, c0, c0, 0		@ select current cache level in cssr
>>>>   	isb					@ isb to sych the new cssr&csidr
>>>>   	mrc	p15, 1, r1, c0, c0, 0		@ read the new csidr
>>>> +#ifdef CONFIG_PREEMPT
>>>> +	restore_irqs r9
>>>> +#endif

>>> I'd suggest using restore_irqs_notrace instead.  The IRQ-off period is
>>> so small that there is no point tracing it.

>> Thanks. I'll make sure to do that before uploading to the patch tracker.

> Might be worth flagging this for the stable kernels as well
> (CC: stable@kernel.org).

    The new address is stable@vger.kernel.org as Greg KH wrote.

WBR, Sergei
