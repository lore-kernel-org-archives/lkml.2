Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894Ab1I1JAN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 05:00:13 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46923 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab1I1JAK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 05:00:10 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdZesKGuPGmUifLj4puN_e=kYAb4WyuQs+xERn9q7036rg@mail.gmail.com>
References: <1317189007-23033-1-git-send-email-alim.akhtar@samsung.com>
 <1317189007-23033-2-git-send-email-alim.akhtar@samsung.com> <CACRpkdZesKGuPGmUifLj4puN_e=kYAb4WyuQs+xERn9q7036rg@mail.gmail.com>
From: Alim Akhtar <alim.akhtar@gmail.com>
Date: Wed, 28 Sep 2011 14:29:30 +0530
Message-ID: <CAGOxZ53Yu3fi7rNOMJ2BiT-vsFn2R9aGBTUc9s53AJsKa=AMBA@mail.gmail.com>
Subject: Re: [PATCH V2 1/1] dmaengine/amba-pl08x: Add support for s3c64xx DMAC
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux@arm.linux.org.uk, vinod.koul@intel.com,
        linux-kernel@vger.kernel.org, kgene.kim@samsung.com,
        dan.j.williams@intel.com, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI Linus,
Thanks for reviewing again.

On Wed, Sep 28, 2011 at 1:31 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> Sorry if I missed a few nitpicks last time, anyway it's looking much better now:
>
> On Wed, Sep 28, 2011 at 7:50 AM, Alim Akhtar <alim.akhtar@samsung.com> wrote:
>> +       /*
>> +        * Samsung pl080 DMAC has one exrta control register
>
> s/exrta/exstra
>
I will correct this.
>> +       if (pl08x->vd->is_pl080_s3c) {
>> +               writel(txd->ccfg, phychan->base + PL080S_CH_CONFIG);
>> +               writel(lli->cctl1, phychan->base + PL080S_CH_CONTROL2);
>> +       } else
>> +               writel(txd->ccfg, phychan->base + PL080_CH_CONFIG);
>
> What do you think about adding a field to the struct pl08x
> like
>
> u32 config_reg
>
> that we set to the proper config register (PL080S_CH_CONFIG or
> PL080_CH_CONFIG in probe(), so the above
> becomes the simpler variant:
>
> writel(txd->ccfg, phychan->base + pl08x->config_reg);
> if (pl08x->vd->is_pl080_s3c)
>    writel(lli->cctl1, phychan->base + PL080S_CH_CONTROL2);
>
I will try implement this way or as viresh has pointed out to remove
the code duplications.

>> +       if (pl08x->vd->is_pl080_s3c) {
>> +               val = readl(phychan->base + PL080S_CH_CONFIG);
>> +               while ((val & PL080_CONFIG_ACTIVE) ||
>> +                       (val & PL080_CONFIG_ENABLE))
>> +                       val = readl(phychan->base + PL080S_CH_CONFIG);
>> +
>> +               writel(val | PL080_CONFIG_ENABLE,
>> +                       phychan->base + PL080S_CH_CONFIG);
>> +       } else {
>>                val = readl(phychan->base + PL080_CH_CONFIG);
>> +                       while ((val & PL080_CONFIG_ACTIVE) ||
>> +                               (val & PL080_CONFIG_ENABLE))
>> +                               val = readl(phychan->base + PL080_CH_CONFIG);
>>
>> -       writel(val | PL080_CONFIG_ENABLE, phychan->base + PL080_CH_CONFIG);
>> +               writel(val | PL080_CONFIG_ENABLE,
>> +                       phychan->base + PL080_CH_CONFIG);
>> +       }
>
> This would also become much simpler with that approach I think...
>
OK, i will do that.
>>        /* Set the HALT bit and wait for the FIFO to drain */
>> -       val = readl(ch->base + PL080_CH_CONFIG);
>> -       val |= PL080_CONFIG_HALT;
>> -       writel(val, ch->base + PL080_CH_CONFIG);
>> -
>> +       if (pl08x->vd->is_pl080_s3c) {
>> +               val = readl(ch->base + PL080S_CH_CONFIG);
>> +               val |= PL080_CONFIG_HALT;
>> +               writel(val, ch->base + PL080S_CH_CONFIG);
>> +       } else {
>> +               val = readl(ch->base + PL080_CH_CONFIG);
>> +               val |= PL080_CONFIG_HALT;
>> +               writel(val, ch->base + PL080_CH_CONFIG);
>> +       }
>
> This would become simply:
>
> val = readl(ch->base + pl08x->config_reg);
> val |= PL080_CONFIG_HALT;
> writel(val, ch->base + pl08x->config_reg);
>
>
ok, i will do that.
>>        /* Clear the HALT bit */
>> -       val = readl(ch->base + PL080_CH_CONFIG);
>> -       val &= ~PL080_CONFIG_HALT;
>> -       writel(val, ch->base + PL080_CH_CONFIG);
>> +       if (pl08x->vd->is_pl080_s3c) {
>> +               val = readl(ch->base + PL080S_CH_CONFIG);
>> +               val &= ~PL080_CONFIG_HALT;
>> +               writel(val, ch->base + PL080S_CH_CONFIG);
>> +       } else {
>> +               val = readl(ch->base + PL080_CH_CONFIG);
>> +               val &= ~PL080_CONFIG_HALT;
>> +               writel(val, ch->base + PL080_CH_CONFIG);
>> +       }
>
> This would get rid of the if/else clauses
>
ok, understand
>> +       if (pl08x->vd->is_pl080_s3c) {
>> +               u32 val = readl(ch->base + PL080S_CH_CONFIG);
>> +               val &= ~(PL080_CONFIG_ENABLE | PL080_CONFIG_ERR_IRQ_MASK |
>> +                               PL080_CONFIG_TC_IRQ_MASK);
>> +               writel(val, ch->base + PL080S_CH_CONFIG);
>> +       } else {
>> +               u32 val = readl(ch->base + PL080_CH_CONFIG);
>> +               val &= ~(PL080_CONFIG_ENABLE | PL080_CONFIG_ERR_IRQ_MASK |
>> +                               PL080_CONFIG_TC_IRQ_MASK);
>> +               writel(val, ch->base + PL080_CH_CONFIG);
>> +       }
>
> As would this...
>
>> +       /* Samsung DMAC is PL080 variant*/
>> +       {
>> +               .id     = 0x00041082,
>> +               .mask   = 0x000fffff,
>> +               .data   = &vendor_pl080_s3c,
>
> Does the hardware realy have this primecell number or is it something that is
> hardcoded from the board/device tree?
>
It is a hardcoded value as s3c64xx does not have Identification registers.

> If it is hardcoded then no objections.
>
> In the latter case, replace 0x41 (= 'A', ARM) with something like
> 0x55 'U' for Samsung or so. Or 0x51 'S'. Or whatever you like.
>
> Then add that to include/linux/amba/bus.h as
> AMBA_VENDOR_SAMSUNG = 0x55,
> so we have this under some kind of control.
>
> Yours,
> Linus Walleij
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>



-- 
aLim akHtaR
mAin hUn nA :-)
