Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036Ab1LVIK3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 03:10:29 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59656 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627Ab1LVIKZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 03:10:25 -0500
MIME-Version: 1.0
In-Reply-To: <20111222005816.GB27144@opensource.wolfsonmicro.com>
References: <1324349144-12784-1-git-send-email-tomoya.rohm@gmail.com>
	<1324349144-12784-3-git-send-email-tomoya.rohm@gmail.com>
	<20111220132314.GQ2866@opensource.wolfsonmicro.com>
	<CANKRQng8N3oS2o17HPUZeonXB3KLBK9oNQj-zd9+aUUvWcTo0A@mail.gmail.com>
	<20111222005816.GB27144@opensource.wolfsonmicro.com>
Date: Thu, 22 Dec 2011 17:10:24 +0900
Message-ID: <CANKRQnjCTAX02wJt7StjB0rXkg3Q6bPBRYCbkgq6vS5NFd97Fg@mail.gmail.com>
Subject: Re: [PATCH 3/3 v2] sound/soc/lapis: add platform driver for ML7213
 IOH I2S
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Mike Frysinger <vapier@gentoo.org>, Daniel Mack <zonque@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/12/22 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Wed, Dec 21, 2011 at 08:22:56PM +0900, Tomoya MORINAGA wrote:
>> 2011/12/20 Mark Brown <broonie@opensource.wolfsonmicro.com>:
>> > On Tue, Dec 20, 2011 at 11:45:44AM +0900, Tomoya MORINAGA wrote:
>
>> >> +     iowrite32(I2S_TX_FINT | I2S_TX_AFINT | I2S_TX_EINT | I2S_TX_AEINT,
>> >> +             i2s_data->iobase + I2SISTTX_OFFSET + offset);
>
>> > This appears to unconditionally acknowledge all interrupts, generally
>> > you should only acknowledge interrupts that have been handled.
>> > Otherwise it's possible that interrupts may be dropped if they're
>> > flagged between the status read and acknowledgement write.
>
>> I can understand your saying.
>> If following your saying, only called by i2s_dma_tx_complete is enough.
>
>> However I think adding clearing interrupt status at both before and
>> after i2s communicating start/finish is better.
>
> No, the issue is that you're acknowleding a hard coded set of
> interrupts, not the interrupts that were actually handled.  The ordering
> isn't really the issue, the issue is that you could acknowledge things
> that weren't handled.  For example:
>
>   1. ISR runs, reads status A
>   2. Condition B happens
>   3. ISR handles condition A.
>   4. ISR acknowledges both A and B.
>
> would mean that B would just get ignored.
I can understand your saying.
However, in case of Tx interrupt, only ALMOST-EMPTY occurs. in case of
Rx, only Rx ALMOST-FULL occurs.
So as long as a user uses ML7213 I2S, your mentioned behavior is never happened.


>
>> >> +static bool filter(struct dma_chan *chan, void *slave)
>
>> > This needs a better name.  It's not namespaced and it's not clear what
>> > it's filtering.
>
>> In case of using Linux standard DMA API, function "filter" is the most
>> popular name.
>> Almost drivers which use standard use "filter".
>
> I suspect they may have the filter immediately next to the code that
> uses it, which certainly isn't the case here.
They have the "filter" function immediately next to the code uses
"dma_request_channel".
Anyway, if you want me to change the name, I can change the name.
Please decide it.

>
>> >> +ioh_i2s_write(struct snd_pcm_substream *substream, const void *data, int len)
>> >> +{
>> >> +     int rem1;
>> >> +     int rem2;
>
>> > What is this supposed to do?  There's an awful lot of it, and it looks
>> > like it's supposed to be rewriting the data format for some reason which
>> > isn't something that a driver ought to be doing (apart from anything
>> > else it does rather defeat the point of DMA).
>
>> This driver has buffer which is for preventing noisy sound  by jitter
>> So, this buffer is variable.
>
> You're implementing some sort of custom buffering in your driver?  That
> sounds terribly unidiomatic - pretty much all DMA drivers are very thin
> and manage to work well, I'd expect this is masking some problems in the
> code rather than anything else.  Can you provide more detail on what
> this is working around?
Not sorted but queuing only.
In sound/voice control system, queuing is not rare, I think.
If necessary, though this method is very common, I can send the method
of the queue.

>
>> >> +     num = ((int)dma->tx_avail) / (I2S_AEMPTY_THRESH * 4);
>
>> > That case looks *very* suspect.
>
>> This is correct.
>> Why do you think so ?
>
> I can't tell what it's supposed to do, and casting that isn't super
> clear especially casting to integer types tends to be a big red flag.

Currently, "tx_avail" is "int" type. So, "(int)" is redundant.
Maybe, once type of "tx_avail" is not "int" but something pointer type.
I'll modify like below.
num = dma->tx_avail / (I2S_AEMPTY_THRESH * 4);


thanks,
tomoya
