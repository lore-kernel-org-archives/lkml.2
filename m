Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216Ab2I0ENQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 00:13:16 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:57122 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab2I0ENO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 00:13:14 -0400
MIME-Version: 1.0
In-Reply-To: <CABb+yY0dvtOZoa=T+gyTeWy3XyAictXJnqSkbF39E=peHSXDuQ@mail.gmail.com>
References: <1348563456-30569-1-git-send-email-inderpal.singh@linaro.org>
	<1348563456-30569-4-git-send-email-inderpal.singh@linaro.org>
	<CABb+yY3TcVr=0Po0N7TLCkQ9TmMJuvQhKJj3aQ1bP9+68T+Ogw@mail.gmail.com>
	<CAG17yqSOWhg_4KrQNojdYcpygkznvrzO74qnh8yasK=UH1f05Q@mail.gmail.com>
	<CABb+yY36pQ7oXC1OKEQ-1V55c2SZurcTAPaZ=_PWugqxdL2rgg@mail.gmail.com>
	<CAG17yqQ5NDr4sLvWbA85q5y079j2M2OV-uRjXSSL=OFPfCw3Zg@mail.gmail.com>
	<CABb+yY0dvtOZoa=T+gyTeWy3XyAictXJnqSkbF39E=peHSXDuQ@mail.gmail.com>
Date: Thu, 27 Sep 2012 09:43:13 +0530
Message-ID: <CAG17yqQbRMaaEFyTBngMwdiKVBsGaOit1ufv3t5TdwLBgSKmfw@mail.gmail.com>
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

On 26 September 2012 22:19, Jassi Brar <jassisinghbrar@gmail.com> wrote:
> On Wed, Sep 26, 2012 at 4:25 PM, Inderpal Singh
> <inderpal.singh@linaro.org> wrote:
>> On 26 September 2012 15:02, Jassi Brar <jassisinghbrar@gmail.com> wrote:
>>> On Wed, Sep 26, 2012 at 12:11 PM, Inderpal Singh
>>> <inderpal.singh@linaro.org> wrote:
>>>
>>>> How about conditionally DMA_TERMINATE_ALL and free resources like below ?
>>>>
>>>> @@ -3017,9 +3017,11 @@ static int __devexit pl330_remove(struct
>>>> amba_device *adev)
>>>>                 /* Remove the channel */
>>>>                 list_del(&pch->chan.device_node);
>>>>
>>>> -               /* Flush the channel */
>>>> -               pl330_control(&pch->chan, DMA_TERMINATE_ALL, 0);
>>>> -               pl330_free_chan_resources(&pch->chan);
>>>> +               if (pch->chan.client_count != 0) {
>>>> +                       /* Flush the channel */
>>>> +                       pl330_control(&pch->chan, DMA_TERMINATE_ALL, 0);
>>>> +                       pl330_free_chan_resources(&pch->chan);
>>>> +               }
>>>>         }
>>>>
>>> It is perfectly safe to flush the channels that have client_count == 0
>>> as well. Which is already the case.
>>
>> As per my understanding, if client_count ==0, It may mean following:
>>
>> 1. This channel was never allocated to any client. Hence
>> alloc_chan_resources was not done for it.
>> So, no need to flush and free resources if it was never allocated at
>> the first place. If we free_chan_resources, it will not be balanced
>> against alloc_chan_resources. Scenario: insmod and then rmmod.
>>
>> Or,
>>
>> 2. The channel was allocated to some client, alloc_chan_resource was
>> done, the work for the client is completed and free_chan_resources was
>> performed. Now  since resources have already been freed, no need to
>> flush and free_chan_resources again in remove.
>>
>> The whole idea of this patch is to balance alloc_chan_resources and
>> free_chan_resources.
>>
> Do you see any issue with channels that have zero client_count ?

As I explained in my previous mail, If the client_count is zero,
either the alloc_chan_resources is not done(or failed) for that
channel or the free_chan_resource have already been done. Please refer
below code from dmaengine.c

static void dma_chan_put(struct dma_chan *chan)
{
        if (!chan->client_count)
                return; /* this channel failed alloc_chan_resources */
        chan->client_count--;
        module_put(dma_chan_to_owner(chan));
        if (chan->client_count == 0)
                chan->device->device_free_chan_resources(chan);
}

As you mentioned channel flush is needed if some client is queued and
force unload happens.
I am not against flushing and freeing channels. I am __only__
suggesting to flush and free channels for which alloc_chan_resource
was successful, which can be decided by "chan->client_count" as being
done in above function.

Don't you think free_chan_resource should be done __only if__
alloc_chan_resource was successful ?

Thanks,
Inder

> AFAIU there are already enough checks in the path to weed out unused
> channels, so let us please not uglify the code by adding new
> unnecessary checks.
>
> thanks.
