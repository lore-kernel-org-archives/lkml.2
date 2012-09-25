Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667Ab2IYPXu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 11:23:50 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:48853 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754594Ab2IYPXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 11:23:48 -0400
MIME-Version: 1.0
In-Reply-To: <CABb+yY1DiWT6-faPe24wVYLwO9vP0W7KswcAyqAWd5VH-JfizA@mail.gmail.com>
References: <1348563456-30569-1-git-send-email-inderpal.singh@linaro.org>
	<1348563456-30569-2-git-send-email-inderpal.singh@linaro.org>
	<CABb+yY1DiWT6-faPe24wVYLwO9vP0W7KswcAyqAWd5VH-JfizA@mail.gmail.com>
Date: Tue, 25 Sep 2012 20:53:47 +0530
Message-ID: <CAG17yqQ3EZ98uWd0apM-205BTLZ7x4wn26__+YdycR5pNCDddQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] DMA: PL330: Free memory allocated for peripheral channels
From: Inderpal Singh <inderpal.singh@linaro.org>
To: Jassi Brar <jassisinghbrar@gmail.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        boojin.kim@samsung.com, vinod.koul@intel.com, patches@linaro.org,
        kgene.kim@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 September 2012 18:17, Jassi Brar <jassisinghbrar@gmail.com> wrote:
> On Tue, Sep 25, 2012 at 2:27 PM, Inderpal Singh
> <inderpal.singh@linaro.org> wrote:
>> The allocated memory for peripheral channels is not being freed upon
>> failure in probe and in module's remove funtion. It will lead to memory
>> leakage. Hence free the allocated memory.
>>
>> Signed-off-by: Inderpal Singh <inderpal.singh@linaro.org>
>> ---
>>  drivers/dma/pl330.c |    5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
>> index 2ebd4cd..10c6b6a 100644
>> --- a/drivers/dma/pl330.c
>> +++ b/drivers/dma/pl330.c
>> @@ -2962,7 +2962,7 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
>>         ret = dma_async_device_register(pd);
>>         if (ret) {
>>                 dev_err(&adev->dev, "unable to register DMAC\n");
>> -               goto probe_err4;
>> +               goto probe_err5;
>>         }
>>
> Sorry this patch seems malformed. Against which tree did you prepare it ?
>
This patch depends on "61c6e7531d3b66b3 ........DMA: PL330: Check the
pointer returned by kzalloc" which is on vinod's slave-dma's "fixes"
branch. So I merged slave-dma's "next" and "fixes" branches. Now after
merging, build error occurs due to some conflict so I had to apply the
patch sent by Sachin at [1]

Same had been mentioned in the cover letter.

[1] http://permalink.gmane.org/gmane.linux.kernel.next/24274

Thanks,
Inder

> -jassi
>
>
>
>>         dev_info(&adev->dev,
>> @@ -2975,6 +2975,8 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
>>
>>         return 0;
>>
>> +probe_err5:
>> +       kfree(pdmac->peripherals);
>>  probe_err4:
>>         pl330_del(pi);
>>  probe_err3:
>> @@ -3025,6 +3027,7 @@ static int __devexit pl330_remove(struct amba_device *adev)
>>         res = &adev->res;
>>         release_mem_region(res->start, resource_size(res));
>>
>> +       kfree(pdmac->peripherals);
>>         kfree(pdmac);
>>
>>         return 0;
>> --
>> 1.7.9.5
>>
