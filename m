Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935566Ab2JYLXv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 07:23:51 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:63417 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934799Ab2JYLXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 07:23:49 -0400
MIME-Version: 1.0
In-Reply-To: <1351052091.5263.19.camel@vkoul-udesk3>
References: <1349432276-22919-1-git-send-email-inderpal.singh@linaro.org>
	<1349432276-22919-4-git-send-email-inderpal.singh@linaro.org>
	<1351052091.5263.19.camel@vkoul-udesk3>
Date: Thu, 25 Oct 2012 16:53:49 +0530
Message-ID: <CAG17yqQBep4Y3YOGVFr6s_apX9f0YeTC7dxDcTQM7ahxnr1B4w@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] DMA: PL330: Balance module remove function with probe
From: Inderpal Singh <inderpal.singh@linaro.org>
To: Vinod Koul <vkoul@infradead.org>
Cc: vinod.koul@intel.com, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, jassisinghbrar@gmail.com,
        boojin.kim@samsung.com, patches@linaro.org, kgene.kim@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vinod,

On 24 October 2012 09:44, Vinod Koul <vkoul@infradead.org> wrote:
> On Fri, 2012-10-05 at 15:47 +0530, Inderpal Singh wrote:
>> Since peripheral channel resources are not being allocated at probe,
>> no need to flush the channels and free the resources in remove function.
>> In case, the channel is in use by some client, return EBUSY.
>>
>> Signed-off-by: Inderpal Singh <inderpal.singh@linaro.org>
>> ---
>>  drivers/dma/pl330.c |   13 ++++++++-----
>>  1 file changed, 8 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
>> index bf71ff7..4b7a34d 100644
>> --- a/drivers/dma/pl330.c
>> +++ b/drivers/dma/pl330.c
>> @@ -3009,18 +3009,21 @@ static int __devexit pl330_remove(struct amba_device *adev)
>>       if (!pdmac)
>>               return 0;
>>
>> +     /* check if any client is using any channel */
>> +     list_for_each_entry(pch, &pdmac->ddma.channels,
>> +                     chan.device_node) {
>> +
>> +             if (pch->chan.client_count)
>> +                     return -EBUSY;
>> +     }
>> +
>>       while (!list_empty(&pdmac->desc_pool)) {
>
> Did you get this code executed?
> I think No.
>
> The dmaengine holds the reference to channels, so if they are in use and
> not freed by client your remove wont be called. So this check is
> redundant
>

This code will get executed only in case of force removal of the
module which was discussed in the first version of the patch at [1].
Now, if we do not have to think about force removal then this patch
will go back to the first version.

Let me know your view.

[1] https://patchwork.kernel.org/patch/1503171/

Regards,
Inder
> --
> Vinod Koul
> Intel Corp.
>
