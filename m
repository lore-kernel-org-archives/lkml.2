Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207Ab1EDIgO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 04:36:14 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40491 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab1EDIgM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 04:36:12 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1105032339370.24613@xanadu.home>
References: <1304453087-7365-1-git-send-email-per.forlin@linaro.org>
	<alpine.LFD.2.00.1105032339370.24613@xanadu.home>
Date: Wed, 4 May 2011 10:36:11 +0200
Message-ID: <BANLkTim_x28NyWzo-Ug3+ZprgeT=VFwEfQ@mail.gmail.com>
Subject: Re: [PATCH] sdio: optimized SDIO IRQ handling for single function
From: Per Forlin <per.forlin@linaro.org>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        lkml <linux-kernel@vger.kernel.org>, linaro-dev@lists.linaro.org,
        Stefan Nilsson XK <stefan.xk.nilsson@stericsson.com>,
        Ulf HANSSON <ulf.hansson@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 May 2011 05:40, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> On Tue, 3 May 2011, Per Forlin wrote:
>
>> From: Stefan Nilsson XK <stefan.xk.nilsson@stericsson.com>
>>
>> If there is only 1 function registered, and IRQ:s are supported and
>> currently enabled, call the callback handler directly
>> without checking the CCCR registers.
>>
>> Signed-off-by: Stefan Nilsson XK <stefan.xk.nilsson@stericsson.com>
>> Signed-off-by: Per Forlin <per.forlin@linaro.org>
>
> Acked-by: Nicolas Pitre <nicolas.pitre@linaro.org>
>
I am working o a patch version 2 after offline discussion with Ulf Hansson.
Instead of adding this code here.
Add sdio_single_func member in mmc_card. Set and reset this function
in sdio_claim_irq and sdio_release_irq.
process_sdio_pending_irqs would only check if sdio_single_func is !=
null and call it.

This will result in a bigger patch overall but the new code in
process_sdio_pending_irqs will be minimal.

>> ---
>>  drivers/mmc/core/sdio_irq.c |   14 ++++++++++++++
>>  1 files changed, 14 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/mmc/core/sdio_irq.c b/drivers/mmc/core/sdio_irq.c
>> index b300161..25291bf 100644
>> --- a/drivers/mmc/core/sdio_irq.c
>> +++ b/drivers/mmc/core/sdio_irq.c
>> @@ -32,6 +32,20 @@ static int process_sdio_pending_irqs(struct mmc_card *card)
>>       int i, ret, count;
>>       unsigned char pending;
>>
>> +     /*
>> +      * If there is only 1 function registered
>> +      * call irq directly without checking the CCCR registers.
>> +      */
>> +     if ((card->host->caps & MMC_CAP_SDIO_IRQ) &&

>> +         card->host->sdio_irqs && (card->sdio_funcs == 1))
>> +             for (i = 0; i < SDIO_MAX_FUNCS; i++) {
Minor adjustments.
card->sdio_funcs may be > 1 but still only one irq is registered.
No need to iterate more than "sdio_funcs" number of elements.
+ card->host->sdio_irqs == 1)
+             for (i = 0; i < card->sdio_funcs; i++) {

>> +                     struct sdio_func *func = card->sdio_func[i];
>> +                     if (func && func->irq_handler) {
>> +                             func->irq_handler(func);
>> +                             return 1;
>> +                     }
>> +             }
>> +
>>       ret = mmc_io_rw_direct(card, 0, 0, SDIO_CCCR_INTx, 0, &pending);
>>       if (ret) {
>>               printk(KERN_DEBUG "%s: error %d reading SDIO_CCCR_INTx\n",
>> --
>> 1.7.4.1
>>
>>
>> _______________________________________________
>> linaro-dev mailing list
>> linaro-dev@lists.linaro.org
>> http://lists.linaro.org/mailman/listinfo/linaro-dev
>>
>
