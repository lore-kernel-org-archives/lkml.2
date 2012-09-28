Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab2I1Edo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 00:33:44 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:54411 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753577Ab2I1Edk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 00:33:40 -0400
MIME-Version: 1.0
In-Reply-To: <CABb+yY1qbs_s7a-rb91wehEUbO1Azax+-PCaH2QQ=gr+Mc5ioA@mail.gmail.com>
References: <1348563456-30569-1-git-send-email-inderpal.singh@linaro.org>
	<1348563456-30569-4-git-send-email-inderpal.singh@linaro.org>
	<CABb+yY3TcVr=0Po0N7TLCkQ9TmMJuvQhKJj3aQ1bP9+68T+Ogw@mail.gmail.com>
	<CAG17yqSOWhg_4KrQNojdYcpygkznvrzO74qnh8yasK=UH1f05Q@mail.gmail.com>
	<1348739292.1648.15.camel@vkoul-udesk3>
	<CAG17yqRxZFsKpx+gpEGoZTbs4x7ijmqywX39=ezq2+RZkvk=TA@mail.gmail.com>
	<CABb+yY1qbs_s7a-rb91wehEUbO1Azax+-PCaH2QQ=gr+Mc5ioA@mail.gmail.com>
Date: Fri, 28 Sep 2012 10:03:39 +0530
Message-ID: <CAG17yqTSj4wg0f-9kuzqYDicpD50mjZ2vuWCm+s4vfCTcQs_1g@mail.gmail.com>
Subject: Re: [PATCH 3/3] DMA: PL330: Balance module remove function with probe
From: Inderpal Singh <inderpal.singh@linaro.org>
To: Jassi Brar <jassisinghbrar@gmail.com>
Cc: Vinod Koul <vinod.koul@linux.intel.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, boojin.kim@samsung.com,
        patches@linaro.org, kgene.kim@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 September 2012 21:36, Jassi Brar <jassisinghbrar@gmail.com> wrote:
> On Thu, Sep 27, 2012 at 9:11 PM, Inderpal Singh
> <inderpal.singh@linaro.org> wrote:
>> On 27 September 2012 15:18, Vinod Koul <vinod.koul@linux.intel.com> wrote:
>>> On Wed, 2012-09-26 at 12:11 +0530, Inderpal Singh wrote:
>>>> If we fail pl330_remove while some client is queued, the force unload
>>>> will fail and the
>>>> force unload will lose its purpose.
>>>> How about conditionally DMA_TERMINATE_ALL and free resources like
>>>> below ?
>>> Why would you want to remove the driver when it is doing something
>>> useful? You have to ensure driver is not doing anything.
>>>
>>> What is point here?
>>>
>> As mentioned by jassi,  if the pl330 module is forced unloaded while
>> some client is queued, we have to manually do DMA_TERMINATE_ALL.
>>
> I meant that in the current situation. Not ideally.
>
>> If failing remove is a better option in case some client is queued, we
>> can do away with DMA_TERMINATE_ALL and free_chan_resources and simply
>> return a suitable error code from remove.
>>
> That was exactly what I suggested as an alternative.

Yes, but our discussion went about continue doing DMA_TERMINATE_ALL and freeing.

Now, if we have to check if any client is using the channel and then
decide. We will have to traverse the channel list twice once to check
the usage and second time to delete the nodes from the list if we go
ahead with remove.
The remove will look like below:

@@ -3008,18 +3008,19 @@ static int __devexit pl330_remove(struct
amba_device *adev)
        if (!pdmac)
                return 0;

+       /* check if any client is using any channel */
+       list_for_each_entry_safe(pch, _p, &pdmac->ddma.channels,
+                       chan.device_node) {
+
+               if (pch->chan.client_count)
+                       return -EBUSY;
+       }
+
        amba_set_drvdata(adev, NULL);

-       /* Idle the DMAC */
        list_for_each_entry_safe(pch, _p, &pdmac->ddma.channels,
                        chan.device_node) {

                /* Remove the channel */
                list_del(&pch->chan.device_node);
-
-               /* Flush the channel */
-               pl330_control(&pch->chan, DMA_TERMINATE_ALL, 0);
-               pl330_free_chan_resources(&pch->chan);
        }

Please suggest if there is any better way to do it.

Thanks,
Inder
