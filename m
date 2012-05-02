Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242Ab2EBBXU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 21:23:20 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:56102 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757244Ab2EBBXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 21:23:19 -0400
Message-ID: <4FA08B39.60300@marvell.com>
Date: Wed, 2 May 2012 09:17:45 +0800
From: Yilu Mao <ylmao@marvell.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Lu Mao <ylmao@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "Baohua.Song@csr.com" <Baohua.Song@csr.com>,
        "santosh.shilimkar@ti.com" <santosh.shilimkar@ti.com>,
        "robherring2@gmail.com" <robherring2@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4] ARM: cache-l2x0.c: save aux ctrl for resume in case
 l2x0 is enabled before init
References: <1335791786-32377-1-git-send-email-ylmao@marvell.com> <CAHkRjk51pATYdhKhmBb9sWywN+0BgeQLpW9bMfTkRgf_09wydg@mail.gmail.com>
In-Reply-To: <CAHkRjk51pATYdhKhmBb9sWywN+0BgeQLpW9bMfTkRgf_09wydg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2012 09:34 PM, Catalin Marinas wrote:
> On 30 April 2012 14:16, Yilu Mao<ylmao@marvell.com>  wrote:
>> If l2x0 controller has been enabled when calling l2x0_init, the aux ctrl
>> register will not be saved in l2x0_saved_regs. Therefore we can not use
>> l2x0_saved_regs.aux_ctrl for resume later. This patch fixed the problem
>> by saving aux ctrl in l2x0_saved_regs just after it's being read from
>> the register.
>> And in case some bits of aux ctrl register are reserved, re-read and
>> save it properly after set it if l2x0 is disabled before init.
>>
>> Change-Id: I54f3002274ffe9cdc667dba81e36e08f2e121467
>> Signed-off-by: Yilu Mao<ylmao@marvell.com>
>> ---
>>   arch/arm/mm/cache-l2x0.c |    9 +++++++++
>>   1 files changed, 9 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
>> index a53fd2a..9893e58 100644
>> --- a/arch/arm/mm/cache-l2x0.c
>> +++ b/arch/arm/mm/cache-l2x0.c
>> @@ -320,6 +320,13 @@ void __init l2x0_init(void __iomem *base, u32 aux_val, u32 aux_mask)
>>         cache_id = readl_relaxed(l2x0_base + L2X0_CACHE_ID);
>>         aux = readl_relaxed(l2x0_base + L2X0_AUX_CTRL);
>>
>> +       /*
>> +        * In case l2x controller is enabled, the aux ctrl register
>> +        * can't be set. So the original value should be stored in
>> +        * the l2x0_saved_regs for restoring when resume.
>> +        */
>> +       l2x0_saved_regs.aux_ctrl = aux;
>
> Why not move this
>
>> +
>>         aux&= aux_mask;
>>         aux |= aux_val;
>>
>> @@ -364,6 +371,8 @@ void __init l2x0_init(void __iomem *base, u32 aux_val, u32 aux_mask)
>>                 /* l2x0 controller is disabled */
>>                 writel_relaxed(aux, l2x0_base + L2X0_AUX_CTRL);
>>
>> +               /* Re-read it in case some bits are reserved. */
>> +               aux = readl_relaxed(l2x0_base + L2X0_AUX_CTRL);
>
> and this
>
>>                 l2x0_saved_regs.aux_ctrl = aux;
>>
>>                 l2x0_inv_all();
>
> somewhere after the if block and we only read the aux once. The
> comment may no longer make sense though.
>
Hi Catalin,

I want to make it clear before I provide a new patch. :)
We can't only read once because we must read it before handle the 
aux_val and aux_mask arguments.
Do you still want the "l2x0_saved_regs.aux_ctrl = aux;" operation only 
located after the "if"?
If so, I will provide a patch for it.

-- 
Thanks.

Best Wishes,
Yilu Mao
