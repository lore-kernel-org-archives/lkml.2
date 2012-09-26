Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739Ab2IZGlL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 02:41:11 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:58626 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab2IZGlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 02:41:06 -0400
MIME-Version: 1.0
In-Reply-To: <CABb+yY3TcVr=0Po0N7TLCkQ9TmMJuvQhKJj3aQ1bP9+68T+Ogw@mail.gmail.com>
References: <1348563456-30569-1-git-send-email-inderpal.singh@linaro.org>
	<1348563456-30569-4-git-send-email-inderpal.singh@linaro.org>
	<CABb+yY3TcVr=0Po0N7TLCkQ9TmMJuvQhKJj3aQ1bP9+68T+Ogw@mail.gmail.com>
Date: Wed, 26 Sep 2012 12:11:05 +0530
Message-ID: <CAG17yqSOWhg_4KrQNojdYcpygkznvrzO74qnh8yasK=UH1f05Q@mail.gmail.com>
Subject: Re: [PATCH 3/3] DMA: PL330: Balance module remove function with probe
From: Inderpal Singh <inderpal.singh@linaro.org>
To: Jassi Brar <jassisinghbrar@gmail.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        boojin.kim@samsung.com, vinod.koul@intel.com, patches@linaro.org,
        kgene.kim@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 September 2012 18:47, Jassi Brar <jassisinghbrar@gmail.com> wrote:
> On Tue, Sep 25, 2012 at 2:27 PM, Inderpal Singh
> <inderpal.singh@linaro.org> wrote:
>> Since peripheral channel resources are not being allocated at probe,
>> no need to flush the channels and free the resources in remove function.
>>
>> Signed-off-by: Inderpal Singh <inderpal.singh@linaro.org>
>> ---
>>  drivers/dma/pl330.c |    8 +-------
>>  1 file changed, 1 insertion(+), 7 deletions(-)
>>
>> diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
>> index 04d83e6..6f06080 100644
>> --- a/drivers/dma/pl330.c
>> +++ b/drivers/dma/pl330.c
>> @@ -3012,16 +3012,10 @@ static int __devexit pl330_remove(struct amba_device *adev)
>>
>>         /* Idle the DMAC */
>>         list_for_each_entry_safe(pch, _p, &pdmac->ddma.channels,
>> -                       chan.device_node) {
>> -
>> +                       chan.device_node)
>>                 /* Remove the channel */
>>                 list_del(&pch->chan.device_node);
>>
>> -               /* Flush the channel */
>> -               pl330_control(&pch->chan, DMA_TERMINATE_ALL, 0);
>> -               pl330_free_chan_resources(&pch->chan);
>> -       }
>> -
>>         while (!list_empty(&pdmac->desc_pool)) {
>>                 desc = list_entry(pdmac->desc_pool.next,
>>                                 struct dma_pl330_desc, node);
>
> I am not sure about this patch. The DMA_TERMINATE_ALL is only called
> by the client and if the pl330 module is forced unloaded while some
> client is queued, we have to manually do DMA_TERMINATE_ALL.
> A better option could be to simply fail pl330_remove if some client is
> queued on the DMAC.
>
If we fail pl330_remove while some client is queued, the force unload
will fail and the
force unload will lose its purpose.
How about conditionally DMA_TERMINATE_ALL and free resources like below ?

@@ -3017,9 +3017,11 @@ static int __devexit pl330_remove(struct
amba_device *adev)
                /* Remove the channel */
                list_del(&pch->chan.device_node);

-               /* Flush the channel */
-               pl330_control(&pch->chan, DMA_TERMINATE_ALL, 0);
-               pl330_free_chan_resources(&pch->chan);
+               if (pch->chan.client_count != 0) {
+                       /* Flush the channel */
+                       pl330_control(&pch->chan, DMA_TERMINATE_ALL, 0);
+                       pl330_free_chan_resources(&pch->chan);
+               }
        }

        while (!list_empty(&pdmac->desc_pool)) {


Thanks,
Inder


> -jassi
