Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab2DZFSs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 01:18:48 -0400
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:59176 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752165Ab2DZFSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 01:18:45 -0400
Message-ID: <4F98D659.4030709@marvell.com>
Date: Thu, 26 Apr 2012 13:00:09 +0800
From: Yilu Mao <ylmao@marvell.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Yilu Mao <ylmao@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "Baohua.Song@csr.com" <Baohua.Song@csr.com>,
        "santosh.shilimkar@ti.com" <santosh.shilimkar@ti.com>,
        "robherring2@gmail.com" <robherring2@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: cache-l2x0.c: save aux ctrl for resume in case that
 l2x0 is enabled before init
References: <1335235280-25148-1-git-send-email-ylmao@marvell.com> <20120424082810.GA9367@arm.com>
In-Reply-To: <20120424082810.GA9367@arm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2012 04:28 PM, Catalin Marinas wrote:
> On Tue, Apr 24, 2012 at 03:41:20AM +0100, Yilu Mao wrote:
>> If l2x0 controller has been enabled when calling l2x0_init, the aux ctrl
>> register will not be saved in l2x0_saved_regs. Therefore we can not use
>> l2x0_saved_regs.aux_ctrl for resume later. This patch fixed the problem
>> by saving aux ctrl in l2x0_saved_regs just after it's being read from
>> the register.
>>
>> Signed-off-by: Yilu Mao<ylmao@marvell.com>
>> ---
>>   arch/arm/mm/cache-l2x0.c |    6 ++++++
>>   1 files changed, 6 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
>> index a53fd2a..3034b06 100644
>> --- a/arch/arm/mm/cache-l2x0.c
>> +++ b/arch/arm/mm/cache-l2x0.c
>> @@ -320,6 +320,12 @@ void __init l2x0_init(void __iomem *base, u32 aux_val, u32 aux_mask)
>>   	cache_id = readl_relaxed(l2x0_base + L2X0_CACHE_ID);
>>   	aux = readl_relaxed(l2x0_base + L2X0_AUX_CTRL);
>>
>> +	/* In case l2x controller is enabled, the aux ctrl register
>> +	 * can't be set. So the original value should be stored in
>> +	 * the l2x0_saved_regs for restoring when resume.
>> +	 */
>
> Even better like this ;)
>
> +	/*
> +	 * In case l2x controller is enabled, the aux ctrl register
> +	 * can't be set. So the original value should be stored in
> +	 * the l2x0_saved_regs for restoring when resume.
> +	 */
>
>
>> +	l2x0_saved_regs.aux_ctrl = aux;
>> +
>>   	aux&= aux_mask;
>>   	aux |= aux_val;
>
> I think that's the wrong place to save it, it should be after the
> masking was done.
>
> Anyway, if we cannot write this register in l2x0_init() because the L2
> was enabled, do we expect the L2 to be disabled during resume?
>
Sorry, I don't think so.
This is the right place to save it because we must make sure the saved 
aux_ctrl is the same as what it is set.
If we save it after masking was done, the saved value will be different 
because we can't actually change the real setting.

What do you think?

-- 
Thanks.

Best Wishes,
Yilu Mao
