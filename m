Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757145Ab1FFNRI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 09:17:08 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41874 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048Ab1FFNRF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 09:17:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MAcT7TvHr+o91BHD3Dt+cIpjYEAyV8va2jhOS+RK0Y04i3MX4i+Xii1Yxo5PXK0cCC
         Dg2M6MIZa8QmpnkjDa9rZLBeLzbNsTIJx4MAs3e+IQZ84TOPlSW6H6WI3RzBxp3gbjLC
         2Wj19+n6dm2lrlI/9lMBBukQrAy2ZgyYvreSI=
MIME-Version: 1.0
In-Reply-To: <m31v052nle.fsf@pullcord.laptop.org>
References: <1305128885-21275-1-git-send-email-per.forlin@linaro.org>
	<1305128885-21275-2-git-send-email-per.forlin@linaro.org>
	<m31v052nle.fsf@pullcord.laptop.org>
Date: Mon, 6 Jun 2011 15:17:05 +0200
Message-ID: <BANLkTincsU5=RvrA91Vy3bpSyGfzCvfF-A@mail.gmail.com>
Subject: Re: [PATCH v5] sdio: optimized SDIO IRQ handling for single irq
From: Daniel Mack <zonque@gmail.com>
To: Chris Ball <cjb@laptop.org>
Cc: Per Forlin <per.forlin@linaro.org>, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org,
        Stefan Nilsson XK <stefan.xk.nilsson@stericsson.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 6:45 PM, Chris Ball <cjb@laptop.org> wrote:
> Hi Per,
>
> On Wed, May 11 2011, Per Forlin wrote:
>> From: Stefan Nilsson XK <stefan.xk.nilsson@stericsson.com>
>>
>> If there is only 1 function interrupt registered it is possible to
>> improve performance by directly calling the irq handler
>> and avoiding the overhead of reading the CCCR registers.
>>
>> Signed-off-by: Per Forlin <per.forlin@linaro.org>
>> Acked-by: Ulf Hansson <ulf.hansson@stericsson.com>
>> Reviewed-by: Nicolas Pitre <nicolas.pitre@linaro.org>
>> ---
>>  drivers/mmc/core/sdio_irq.c |   33 ++++++++++++++++++++++++++++++++-
>>  include/linux/mmc/card.h    |    1 +
>>  2 files changed, 33 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/mmc/core/sdio_irq.c b/drivers/mmc/core/sdio_irq.c
>> index bb192f9..a0890ac 100644
>> --- a/drivers/mmc/core/sdio_irq.c
>> +++ b/drivers/mmc/core/sdio_irq.c
>> @@ -31,6 +31,17 @@ static int process_sdio_pending_irqs(struct mmc_card *card)
>>  {
>>       int i, ret, count;
>>       unsigned char pending;
>> +     struct sdio_func *func;
>> +
>> +     /*
>> +      * Optimization, if there is only 1 function interrupt registered
>> +      * call irq handler directly
>> +      */
>> +     func = card->sdio_single_irq;
>> +     if (func) {
>> +             func->irq_handler(func);
>> +             return 1;
>> +     }
>>
>>       ret = mmc_io_rw_direct(card, 0, 0, SDIO_CCCR_INTx, 0, &pending);
>>       if (ret) {
>> @@ -42,7 +53,7 @@ static int process_sdio_pending_irqs(struct mmc_card *card)
>>       count = 0;
>>       for (i = 1; i <= 7; i++) {
>>               if (pending & (1 << i)) {
>> -                     struct sdio_func *func = card->sdio_func[i - 1];
>> +                     func = card->sdio_func[i - 1];
>>                       if (!func) {
>>                               printk(KERN_WARNING "%s: pending IRQ for "
>>                                       "non-existant function\n",
>> @@ -186,6 +197,24 @@ static int sdio_card_irq_put(struct mmc_card *card)
>>       return 0;
>>  }
>>
>> +/* If there is only 1 function registered set sdio_single_irq */
>> +static void sdio_single_irq_set(struct mmc_card *card)
>> +{
>> +     struct sdio_func *func;
>> +     int i;
>> +
>> +     card->sdio_single_irq = NULL;
>> +     if ((card->host->caps & MMC_CAP_SDIO_IRQ) &&
>> +         card->host->sdio_irqs == 1)
>> +             for (i = 0; i < card->sdio_funcs; i++) {
>> +                    func = card->sdio_func[i];
>> +                    if (func && func->irq_handler) {
>> +                            card->sdio_single_irq = func;
>> +                            break;
>> +                    }
>> +            }
>> +}
>> +
>>  /**
>>   *   sdio_claim_irq - claim the IRQ for a SDIO function
>>   *   @func: SDIO function
>> @@ -227,6 +256,7 @@ int sdio_claim_irq(struct sdio_func *func, sdio_irq_handler_t *handler)
>>       ret = sdio_card_irq_get(func->card);
>>       if (ret)
>>               func->irq_handler = NULL;
>> +     sdio_single_irq_set(func->card);
>>
>>       return ret;
>>  }
>> @@ -251,6 +281,7 @@ int sdio_release_irq(struct sdio_func *func)
>>       if (func->irq_handler) {
>>               func->irq_handler = NULL;
>>               sdio_card_irq_put(func->card);
>> +             sdio_single_irq_set(func->card);
>>       }
>>
>>       ret = mmc_io_rw_direct(func->card, 0, 0, SDIO_CCCR_IENx, 0, &reg);
>> diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
>> index d8dffc9..4910dec 100644
>> --- a/include/linux/mmc/card.h
>> +++ b/include/linux/mmc/card.h
>> @@ -191,6 +191,7 @@ struct mmc_card {
>>       struct sdio_cccr        cccr;           /* common card info */
>>       struct sdio_cis         cis;            /* common tuple info */
>>       struct sdio_func        *sdio_func[SDIO_MAX_FUNCS]; /* SDIO functions (devices) */
>> +     struct sdio_func        *sdio_single_irq; /* SDIO function when only one IRQ active */
>>       unsigned                num_info;       /* number of info strings */
>>       const char              **info;         /* info strings */
>>       struct sdio_func_tuple  *tuples;        /* unknown common tuples */
>
> Thanks, looks good now -- pushed to mmc-next for .40.

This patch breaks libertas over SDIO, as the interrupt handler of that
driver is now called even though the hardware didn't signal any
interrupt condition. This is a problem for at least two reasons in
this case:

a) the libertas code is currently structured in a way that it calls
sdio_claim_irq() before everything is fully set up (which wasn't a
problem so far as the hardware has an own register to mask
interrupts). That results in a kernel Ooops as card->priv == NULL.

b) the libertas interrupt handler assumes that a received callback to
its interrupt handler signals activity per se
("card->priv->activty_detected = 1").


I have a patch ready for libertas that works around the first problem,
but I'm unsure if that's not fixing the wrong end. What the driver
really should do is poll the card's CCCR register to find out if there
was any interrupt at all and bail if that's not the case, but then
we're back to the implementation without this patch.

The other option is to revert the patch again.

Any suggestions?

Daniel
