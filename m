Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412Ab1EDRAM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 13:00:12 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63858 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab1EDRAK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 13:00:10 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTi=LsmSepyUMbO7q2hG5-HWbRduO+Q@mail.gmail.com>
References: <1304525161-14448-1-git-send-email-per.forlin@linaro.org>
	<1304525161-14448-2-git-send-email-per.forlin@linaro.org>
	<BANLkTi=LsmSepyUMbO7q2hG5-HWbRduO+Q@mail.gmail.com>
Date: Wed, 4 May 2011 19:00:10 +0200
Message-ID: <BANLkTinptOJrpdwbLOF_Th-Jz9gKj5Y6dQ@mail.gmail.com>
Subject: Re: [PATCH v2] sdio: optimized SDIO IRQ handling for single irq
From: Per Forlin <per.forlin@linaro.org>
To: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>
Cc: linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        Chris Ball <cjb@laptop.org>,
        Stefan Nilsson XK <stefan.xk.nilsson@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/4 Micha³ Miros³aw <mirqus@gmail.com>:
> 2011/5/4 Per Forlin <per.forlin@linaro.org>:
>> From: Stefan Nilsson XK <stefan.xk.nilsson@stericsson.com>
>>
>> If there is only 1 function registered it is possible to
>> improve performance by directly calling the irq handler
>> and avoiding the overhead of reading the CCCR registers.
>>
> [...]
>> --- a/drivers/mmc/core/sdio_irq.c
>> +++ b/drivers/mmc/core/sdio_irq.c
>> @@ -32,6 +32,16 @@ static int process_sdio_pending_irqs(struct mmc_card *card)
>>        int i, ret, count;
>>        unsigned char pending;
>>
>> +       /*
>> +        * Optimization, if there is only 1 function registered
>> +        * call irq handler directly
>> +        */
>> +       if (card->sdio_single_irq && card->sdio_single_irq->irq_handler) {
>> +               struct sdio_func *func = card->sdio_single_irq;
>> +               func->irq_handler(func);
>> +               return 1;
>> +       }
> [...]
>
> The second condition can be avoided:
>
> in process_sdio_pending_irqs():
>
> if (card->sdio_irq_func)
>   call handler and return
>
I added the second condition as a sanity check. Same check is used in
the main for loop
>	ret = -EINVAL;
>			} else if (func->irq_handler) {
>				func->irq_handler(func);
Is the second check necessary here?

> in sdio_claim_irq():
>
>  card->func->irq_handler = ...
>  if (host->sdio_irqs == 1)
>    card->sdio_irq_func = func;
>  else
>    card->sdio_irq_func = NULL;
I wanted to keep it simple and use same function in claim and release.
Your code looks nice.
Is if safe to not check the condition "(card->host->caps &
MMC_CAP_SDIO_IRQ)". What happens if the SDIO is in polling mode?

>
> in sdio_release_irq():
>
>  card->sdio_irq_func = NULL;
>  card->func->irq_handler = ...
>  sdio_card_irq_put();
>  if (host->sdio_irqs == 1)
>    sdio_single_irq_set(func->card);
This works for me.

>
> in struct mmc_card:
>  struct sdio_func        *sdio_irq_func;
The name sdio_single_irq indicates it is only used for single irq.
"sdio_irq_func" is too generic I think. But the your name is shorter
and makes the indentation look nicer.
Not a big deal really.

I will wait until tomorrow to post patch v3. This will give time for
other to comment as well.

> Best Regards,
> Micha³ Miros³aw
>
Thanks for your feedback,
Per
