Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075Ab0FNNji (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 09:39:38 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56094 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203Ab0FNNjg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 09:39:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KayJZS1Lstf14cs8xg2FSJcYAVeKCh/L8/J6QEdLv3BpXJNmom2S5mjEF61Dtpw8to
         q2cy9wd+a3UF9vI23QzRyRICUJ53/KPc72sH/JuXFsie1habjGiE5Umd+Vuz5C3wchnr
         q+DXVI+iKu3feuS0rGLpvG0v9lEHAGK9o4lSU=
MIME-Version: 1.0
In-Reply-To: <4C15C60E.6080404@st.com>
References: <1276270031-1607-1-git-send-email-linus.walleij@stericsson.com>
	<4C15C60E.6080404@st.com>
Date: Mon, 14 Jun 2010 15:39:33 +0200
Message-ID: <AANLkTim9n-p-Pw6FWvzQMBiAuB3h9ILq1Ya6XWk_0l-c@mail.gmail.com>
Subject: Re: [PATCH 06/13] DMAENGINE: driver for the ARM PL080/PL081 
	PrimeCells
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Viresh KUMAR <viresh.kumar@st.com>
Cc: Linus WALLEIJ <linus.walleij@stericsson.com>,
       Dan Williams <dan.j.williams@intel.com>,
       linux-arm-kernel@lists.infradead.org, yuanyabin1978@sina.com,
       linux-kernel@vger.kernel.org, Peter Pearse <peter.pearse@arm.com>,
       Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
       Alessandro Rubini <rubini@unipv.it>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh, thanks a lot for reviewing this and I'd be *very* happy if
you could give it a spin on
the SPEAr as well!

2010/6/14 Viresh KUMAR <viresh.kumar@st.com>:
>> diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
>> (...)
>> + * For peripherals with a FIFO:
>> + * Source      burst size == half the depth of the peripheral FIFO
>> + * Destination burst size == width of the peripheral FIFO
>> + *
>
> I didn't get it completely, why burst depends upon width of peripheral FIFO.

I think this is just the wrong word, it should be "depth".

>> + * (Bursts are irrelevant for mem to mem transfers - there are no burst
>> + * signals)
>
> I agree that there are no request lines from memories but still we can program
> them with burst in order to faster the transfer. This burst feature is
> automatically handled by DMA.

Actually in the example platform data I set this to the maxburst size
256 Bytes, however if I read the manual correctly this is simply ignored
when you do mem2mem transfers.

It will simply AHB master the bus until the transaction is finished. That
is why the manual states:

"You must program memory-to-memory transfers with a low channel
priority, otherwise:
•    other DMA channels cannot access the bus until the
memory-to-memory transfer
     has finished
•    other AHB masters cannot perform any transaction."

>> + * @max_num_llis: maximum number of LLIs, i.e. longest linked transfer
>> + * length, submitted so far
>
> What is the significance of this field? What it is used for?

Statistics in Peters original implementation. I'll remove it.

>> +static void pl08x_set_cregs(struct pl08x_driver_data *pl08x,
>> +                         struct pl08x_phy_chan *ch)
>> +{
>> +     u32 val;
>> +
>> +     /* Wait for channel inactive */
>> +     val = readl(ch->base + PL080_CH_CONFIG);
>> +     while (val & PL080_CONFIG_ACTIVE)
>> +             val = readl(ch->base + PL080_CH_CONFIG);
>
> can we use pl08x_phy_channel_busy() instead of above code?

Fixed.

>> +     /*
>> +      * Do not access config register until channel shows as inactive
>> +      */
>> +     val = readl(ch->base + PL080_CH_CONFIG);
>> +     while ((val & PL080_CONFIG_ACTIVE) || (val & PL080_CONFIG_ENABLE))
>> +             val = readl(ch->base + PL080_CH_CONFIG);
>
> above 3 fns are always called in order, i.e. pl08x_enable_phy_chan will
> be called after pl08x_set_cregs, so we may not require these checks
> here. Is my understanding correct??

The previous check if the channel is active before proceeding, this check also
checks the enable bit, this behaviour comes straight from the manual and is
required to avoid hardware races, so I don't dare to touch it really...

>> +     /* Wait for channel inactive */
>> +     val = readl(ch->base + PL080_CH_CONFIG);
>> +     while (val & PL080_CONFIG_ACTIVE)
>> +             val = readl(ch->base + PL080_CH_CONFIG);
>
> can we use pl08x_phy_channel_busy() instead of above code?
> Please check everywhere.

It's just these two places. Fixed this one as well.

>> +
>> +     mb();
>> +
>> +     return;
>
> return not required!!

Fixed.

>> +static void pl08x_resume_phy_chan(struct pl08x_phy_chan *ch)
>
> can these small fns be made inline???

Probably but the compiler will do that anyway if there some
point. I'm afraid of violating chapter 15 of CodingStyle...

>> +/* Stops the channel */
>> +static void pl08x_stop_phy_chan(struct pl08x_phy_chan *ch)
>> +{
>> +     u32 val;
>> +
>> +     pl08x_pause_phy_chan(ch);
>> +
>> +     /* Disable channel */
>> +     val = readl(ch->base + PL080_CH_CONFIG);
>> +     val &= ~PL080_CONFIG_ENABLE;
>> +     writel(val, ch->base + PL080_CH_CONFIG);
>> +     mb();
>> +
>> +     return;
>
> same here. return not required.

Fixed all these.

>> +static inline u32 get_bytes_in_cctl(u32 cctl)
>> +{
>> +     /* The source width defines the number of bytes */
>> +     u32 bytes = cctl & PL080_CONTROL_TRANSFER_SIZE_MASK;
>> +
>> +     switch ((cctl >> 18) & 3) {
>
> better to use Macros instead of magic numbers here!!!

Fixed.

>> +static inline u32 pl08x_cctl_bits(u32 cctl,
>> +                               u8 srcwidth,
>> +                               u8 dstwidth,
>> +                               u32 tsize)
>
> Not sure, if we should write above function prototype in just 2 lines,
> or is it okay to write it the way it is written.

Whatever, I made it two lines instead.

>> +struct dma_device dmac_slave = {
>
> they must be marked static.

Fixed.

>> +     .device_alloc_chan_resources    = pl08x_alloc_chan_resources,
>> +     .device_free_chan_resources     = pl08x_free_chan_resources,
>> +     .device_prep_dma_xor            = NULL,
>> +     .device_prep_dma_memset         = NULL,
>> +     .device_prep_dma_interrupt      = pl08x_prep_dma_interrupt,
>> +     .device_tx_status               = pl08x_dma_tx_status,
>> +     .device_issue_pending           = pl08x_issue_pending,
>> +     .device_prep_slave_sg           = pl08x_prep_slave_sg,
>> +     .device_control                 = pl08x_control,
>> +};
>> +
>
> One more thing linus, why do we need to create this separation between
> channels. i.e. few are for memcpy and few for slave_sg. Why don't all
> channels support everything and this is resolved at runtime.

This is done in all in-tree drivers, the reason is (I think) that for example
the dmatest.c test client will look for:

	if (dma_has_cap(DMA_MEMCPY, dma_dev->cap_mask)) {
		cnt = dmatest_add_threads(dtc, DMA_MEMCPY);
		thread_count += cnt > 0 ? cnt : 0;

So if you want to partition some channels for device I/O (typically some
which are hard-coded to some devices) and others for memcpy() you create
a slave instance for the former and a memcpy() instance for the latter.

In this case we multiplex the memcpy and slave transfers on the few
physical channels we have, but I haven't finally decided how to handle this:
perhaps we should always set on physical channel aside for memcpy
so this won't ever fail, and then this special memcpy device entry will help.

Ideas? Use cases?

>> +/*
>> + * Initialise the DMAC slave channels.
>> + * Make a local wrapper to hold required data
>> + */
>> +static int pl08x_dma_init_slave_channels(struct pl08x_driver_data *pl08x,
>> +                                             struct dma_device *slave)
>
> above 2 functions are almost exactly same, can we have single function
> instead of two.

OK Fixed.

>> +     /* A DMA memory pool for LLIs, align on 1-byte boundary */
>> +     pl08x->pool = dma_pool_create(DRIVER_NAME, &pl08x->adev->dev,
>> +                     PL08X_LLI_TSFR_SIZE, PL08X_ALIGN, 0);
>> +     if (!pl08x->pool) {
>> +             ret = -ENOMEM;
>> +             goto out_no_lli_pool;
>> +     }
>> +     pl08x->pool_ctr = 0;
>> +     pl08x->max_num_llis = 0;
>
> they are already 0.

OK deleted.

>> +     ret = request_irq(adev->irq[0], pl08x_irq, IRQF_DISABLED,
>> +                       vd->name, pl08x);
>> +     if (ret) {
>> +             dev_err(&adev->dev, "%s failed to request "
>> +                     "interrupt %d\n",
>> +                     __func__, adev->irq[0]);
>
> can be written in 2 lines only.

Fixed.

>> +     /* Get the platform data */
>> +     pl08x->pd = (struct pl08x_platform_data *)(adev->dev.platform_data);
>
> better to use dev_get_platdata, also no need of typecasting as
> platform_data is of type void*.

Fixed.

>> +/* PL080 has 8 channels and the PL080 have just 2 */
>
> "PL080 or PL081 have just 2"?? You mentioned at the beginning of this
> file, that PL081 has 16 channels. Am i missing something??

Wrong words again, this is one of the most confusing things about PL080/PL081,
it has 2 or 8 *channels* but always 16 *signals*.

Almost all other interrupt controllers have a 1-to-1 correspondence between the
number of incoming signals and the number of available slave channels.
Not the PL08x... it has less channels than signals.

I will underscore it again... if it confuses both me and you it will invariably
confuse everybody else too.

Thanks!

Yours,
Linus Walleij
