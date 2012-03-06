Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784Ab2CFFsI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 00:48:08 -0500
Received: from mail-pz0-f52.google.com ([209.85.210.52]:60138 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab2CFFsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 00:48:06 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of tomoya.rohm@gmail.com designates 10.68.203.74 as permitted sender) smtp.mail=tomoya.rohm@gmail.com; dkim=pass header.i=tomoya.rohm@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120302163915.GD6056@opensource.wolfsonmicro.com>
References: <1329976011-2251-1-git-send-email-tomoya.rohm@gmail.com>
	<1329976011-2251-2-git-send-email-tomoya.rohm@gmail.com>
	<20120302163915.GD6056@opensource.wolfsonmicro.com>
Date: Tue, 6 Mar 2012 14:48:05 +0900
Message-ID: <CANKRQni8hPoHEsV2VecbgKBdfS5+rit0-jXzz_d8F_nY5-dN3g@mail.gmail.com>
Subject: Re: [PATCH v3] sound/soc/lapis: add platform driver for ML7213
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012年3月3日1:39 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Thu, Feb 23, 2012 at 02:46:50PM +0900, Tomoya MORINAGA wrote:
>> This driver is for LAPIS Semiconductor ML7213 IOH I2S.
>
> I just merged Lars-Peter's dmaengine library code which has been on the
> list for a week or so - this should be updated to use that next time
> it's posted.  That should save a lot of code from the driver and make
> sure it's following best practices for dmaengine use.
Sorry, we can't use this library.

>> +static struct ioh_i2s_data *i2s_data;
>> +static struct ioh_i2s_dma dmadata[MAX_I2S_CH];
>
> Why are these needed, aren't they dynamically allocated by the driver?

You mean ASoC driver can't use global variable ?

>> +     case SNDRV_PCM_STREAM_CAPTURE:
>> +             offset =\
>> +                 ioh_rtd->dma->rx_cur_period * ioh_rtd->dma->period_bytes;
>
> Drop the continuations, line breaks are just whitespace in C outside of
> macros and strings.
I see.

>
>> +     case SNDRV_PCM_FORMAT_S32_LE:
>> +             byte = 24;
>> +             break;
>
> That looks wrong...  are you sure you don't support S24_LE or something?
This is correct.
Because maximum transmit size of ML7213's I2S hw is 24bit.

>> +             switch (fmt & SND_SOC_DAIFMT_INV_MASK) {
>> +             case SND_SOC_DAIFMT_NB_NF:
>> +                     cmn_reg[i] &= ~ML7213I2S_BCLKPOL;
>> +                     break;
>> +             default:
>> +                     return -EINVAL;
>
> Looking at that code I suspect at least IB_NF is supported too...
Yes, our ML7213 I2s looks supporting IB_NF.
I'll add.


>> +static int ml7213i2s_dai_set_clkdiv(struct snd_soc_dai *dai,
>> +                               int div_id, int div)
>> +{
>
>> +     switch (div_id) {
>> +     case ML7213IOH_BCLKFS0:
>
> This all looks like BCLK/sample calculations that the driver should
> really be able to figure out for itself rather than forcing every user
> to replicate the code to do the calculation, calculation in hw_params
> would be more normal.

OK, this will move to hw_params().
and will delete snd_soc_dai_set_clkdiv() of machine driver.

>
>> +#ifdef CONFIG_PM
>> +static void ioh_i2s_save_reg_conf(void)
>
> This stuff has exactly one caller, just inline it.  It's also *very*
> suspicious that it's not taking an argument specifying the device...

I see.
I'll open these codes.

>
>> +#else
>> +#define ml7213i2s_soc_suspend NULL
>> +#define spdif_soc_resume NULL
>
> Hrm?
Ah, I'll modify it to ml7213i2s_soc_resume .

>
>> +#ifdef CONFIG_PM
>> +     .suspend = ml7213i2s_soc_suspend,
>> +     .resume = ml7213i2s_soc_resume,
>> +#endif
>
> The whole point with defining the functions to NULL above is to avoid
> the ifdef here.
I'll delete this "#ifdef".

>
>> +static struct platform_driver ioh_i2s_driver_plat = {
>
>> +static struct platform_driver ioh_dai_driver_plat = {
>
>> +static int ioh_i2s_pci_probe(struct pci_dev *pdev,
>> +                          const struct pci_device_id *id)
>
> Why are you creating these platform devices?  I don't understand the
> function they serve.  The code handling them looks to have quite a few
> problems but I'm not clear they should be there in the first place.
>
if these platform devices aren't used, device detection doesn't work correctly.
So, I added these.
I don't know other way.
Can you show other way ?

>> +     rv = request_irq(pdev->irq, ioh_i2s_irq, IRQF_SHARED, "ml7213_ioh",
>> +                      pdev);
>> +     if (rv != 0) {
>> +             printk(KERN_ERR "Failed to allocate irq\n");
>> +             goto out_irq;
>> +     }
>
> Are you *sure* you're ready to handle interrupts at this point?

This is just registering interrupt handler.
As long as interrupt register is not enabled, the interrupt handler is
not called.
This is common request_irq description.
What's is your concern ?

thanks,
-- 
ROHM Co., Ltd.
tomoya
