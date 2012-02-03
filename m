Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722Ab2BCChl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 21:37:41 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:6771 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177Ab2BCChk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 21:37:40 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6608"; a="157861473"
Message-ID: <4F2B4873.5030808@codeaurora.org>
Date: Thu, 02 Feb 2012 18:37:39 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Thunderbird/3.1.16
MIME-Version: 1.0
To: Nicolas Pitre <nico@fluxnic.net>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] ARM: cache-v7: Disable preemption when reading CCSIDR
References: <1328234629-32735-1-git-send-email-sboyd@codeaurora.org> <alpine.LFD.2.02.1202022110080.2759@xanadu.home>
In-Reply-To: <alpine.LFD.2.02.1202022110080.2759@xanadu.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/12 18:35, Nicolas Pitre wrote:
> On Thu, 2 Feb 2012, Stephen Boyd wrote:
>> On 02/02/12 17:18, Nicolas Pitre wrote:
>>> If you simply disable/restore IRQs around the critical region then you 
>>> don't have to worry about __v7_setup.  Plus this will allow for 
>>> v7_flush_dcache_all to still be callable from atomic context.
>> Ok. Here's a patch. I still need to test it. I'll send another patch
>> series to cleanup the get_thread_info stuff (there's two of them?).
>>
>>  arch/arm/mm/cache-v7.S |    6 ++++++
>>  1 files changed, 6 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/arm/mm/cache-v7.S b/arch/arm/mm/cache-v7.S
>> index 07c4bc8..654a5fc 100644
>> --- a/arch/arm/mm/cache-v7.S
>> +++ b/arch/arm/mm/cache-v7.S
>> @@ -54,9 +54,15 @@ loop1:
>>  	and	r1, r1, #7			@ mask of the bits for current cache only
>>  	cmp	r1, #2				@ see what cache we have at this level
>>  	blt	skip				@ skip if no cache, or just i-cache
>> +#ifdef CONFIG_PREEMPT
>> +	save_and_disable_irqs r9		@ make cssr&csidr read atomic
>> +#endif
>>  	mcr	p15, 2, r10, c0, c0, 0		@ select current cache level in cssr
>>  	isb					@ isb to sych the new cssr&csidr
>>  	mrc	p15, 1, r1, c0, c0, 0		@ read the new csidr
>> +#ifdef CONFIG_PREEMPT
>> +	restore_irqs r9
>> +#endif
> I'd suggest using restore_irqs_notrace instead.  The IRQ-off period is 
> so small that there is no point tracing it.

Thanks. I'll make sure to do that before uploading to the patch tracker.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

