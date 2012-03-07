Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965306Ab2CGBaH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 20:30:07 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47396 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756654Ab2CGBaG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 20:30:06 -0500
MIME-Version: 1.0
In-Reply-To: <20120306115246.GD19635@opensource.wolfsonmicro.com>
References: <1329976011-2251-1-git-send-email-tomoya.rohm@gmail.com>
	<1329976011-2251-2-git-send-email-tomoya.rohm@gmail.com>
	<20120302163915.GD6056@opensource.wolfsonmicro.com>
	<CANKRQni8hPoHEsV2VecbgKBdfS5+rit0-jXzz_d8F_nY5-dN3g@mail.gmail.com>
	<20120306115246.GD19635@opensource.wolfsonmicro.com>
Date: Wed, 7 Mar 2012 10:30:05 +0900
Message-ID: <CANKRQngg+8LJvb-+Byv6XPqqWFyCU1U+-hppuxo_=CM1qLUF_Q@mail.gmail.com>
Subject: Re: [PATCH v3] sound/soc/lapis: add platform driver for ML7213
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 6, 2012 at 8:52 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
>> > I just merged Lars-Peter's dmaengine library code which has been on the
>> > list for a week or so - this should be updated to use that next time
>> > it's posted.  That should save a lot of code from the driver and make
>> > sure it's following best practices for dmaengine use.
>> Sorry, we can't use this library.
> This sort of response really isn't on.  Do you have some reason for
> saying this?  Flat out refusing to do things with no reason is not
> useful.

Current Intel's dma driver (pch_dma) doesn't work on this library.
Because the library uses function which pch_dma doesn't support.
e.g. device_prep_dma_cyclic
So, we can't use this library.

>> >> +static struct ioh_i2s_data *i2s_data;
>> >> +static struct ioh_i2s_dma dmadata[MAX_I2S_CH];
>> > Why are these needed, aren't they dynamically allocated by the driver?
>> You mean ASoC driver can't use global variable ?
> In general no Linux driver should be using a global variable except for
> things like this.

I see. I'll use dynamic allocation.

>> >> +     case SNDRV_PCM_FORMAT_S32_LE:
>> >> +             byte = 24;
>> >> +             break;
>> > That looks wrong...  are you sure you don't support S24_LE or something?
>> This is correct.
>> Because maximum transmit size of ML7213's I2S hw is 24bit.
> Note we often lay out 24 bit audio in 32 bit blocks.

24bit data doesn't work on our system.
So, we don't support S24_LE.

>> >> +static struct platform_driver ioh_i2s_driver_plat = {
>> >
>> >> +static struct platform_driver ioh_dai_driver_plat = {
>> >
>> >> +static int ioh_i2s_pci_probe(struct pci_dev *pdev,
>> >> +                          const struct pci_device_id *id)
>> > Why are you creating these platform devices?  I don't understand the
>> > function they serve.  The code handling them looks to have quite a few
>> > problems but I'm not clear they should be there in the first place.
>> if these platform devices aren't used, device detection doesn't work correctly.
>> So, I added these.
> You've not actually mentioned the problem you were seeing...

I saw mapping problem between machine driver and platform driver.
e.g.  cpu_dai_name "ml7213ioh"

>> >> +     rv = request_irq(pdev->irq, ioh_i2s_irq, IRQF_SHARED, "ml7213_ioh",
>> >> +                      pdev);
>> >> +     if (rv != 0) {
>> >> +             printk(KERN_ERR "Failed to allocate irq\n");
>> >> +             goto out_irq;
>> >> +     }
>> > Are you *sure* you're ready to handle interrupts at this point?
>> This is just registering interrupt handler.
>> As long as interrupt register is not enabled, the interrupt handler is
>> not called.
>> This is common request_irq description.
>> What's is your concern ?
> Apart from anything else you've got the interrupt requested as
> IRQF_SHARED so the interrupt could get called at any time.  It's also
> not clear that you've got the hardware in a known good state.

Do you mean request_irq should move to somewhere, like open() or
hw_params() or ... ?

thanks.

-- 
ROHM Co., Ltd.
tomoya
