Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544Ab1CGLuh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 06:50:37 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:45412 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831Ab1CGLuf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 06:50:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=ji8YbLXhLRiK7L2weFi5b9hy33g02VXbDOptW721BLBsnJeNNpuZsNoWYh2cPC0Obk
         RTwDnsIx1o3cyTZSf+i5De7UP12e4XPdeyvdx49R/Qm7DsM8wEnbI25MDh+BumBJaLrn
         SPOjYc4Fj3zA2B9BYXqGs4jYco2o+9wjdwFqA=
MIME-Version: 1.0
In-Reply-To: <20110307114142.GB13471@opensource.wolfsonmicro.com>
References: <1299460302-15392-1-git-send-email-cliff.cai@analog.com> <20110307114142.GB13471@opensource.wolfsonmicro.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 7 Mar 2011 06:50:15 -0500
Message-ID: <AANLkTikynw7vCsqqyNZW-LFuGUKKQEtG3s4YCZjpOvko@mail.gmail.com>
Subject: Re: [Device-drivers-devel] [PATCH] Add driver for Analog Devices
 ADAU1701 SigmaDSP
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: cliff.cai@analog.com, device-drivers-devel@blackfin.uclinux.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, lrg@slimlogic.co.uk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 7, 2011 at 06:41, Mark Brown wrote:
> On Mon, Mar 07, 2011 at 09:11:42AM +0800, cliff.cai@analog.com wrote:
>> From: Cliff Cai <cliff.cai@analog.com>
>> It needs to include "linux/sigma.h" which is still in Andrew Morton's
>> tree.
>
> Is this needed by other trees?

no

> I can't apply this driver until it's merged into ASoC via some means

and andrew has been holding off on merging the firmware driver until
something in mainline needs it.  once a driver gets to the point where
you're fine with merging it, we can bug akpm to push the sigma
firmware loader to linus.

>>       select SND_SOC_PCM3008
>>       select SND_SOC_SPDIF
>>       select SND_SOC_SSM2602 if I2C
>> +     select SND_SOC_ADAU1701 if I2C
>>       select SND_SOC_STAC9766 if SND_SOC_AC97_BUS
>>       select SND_SOC_TLV320AIC23 if I2C
>
> This presumably also needs to select the DSP API otherwise it's not
> going to build.

by "DSP API" i'm guessing you mean the Sigma firmware loader

>> +static ssize_t adau1371_dsp_load(struct device *dev,
>> +                               struct device_attribute *attr,
>> +                               const char *buf, size_t count)
>> +{
>> +     int ret = 0;
>> +     struct adau1701_priv *adau1701 = dev_get_drvdata(dev);
>> +     struct snd_soc_codec *codec = adau1701->codec;
>> +     ret = adau1701_setprogram(codec);
>> +     if (ret)
>> +             return ret;
>> +     else
>> +             return count;
>> +}
>> +static DEVICE_ATTR(dsp, 0644, NULL, adau1371_dsp_load);
>
> You're marking the file as supporting both read and write but only
> providing write functionality, and the write functionality totally
> ignores the written data.
>
> More generally this doesn't seem like a great interface - apparently the
> device requries that firmware be loaded but the whole firmware load
> process isn't at all joined up with the driver code meaning that the
> application layer has to figure out when firmware needs to be reloaded,
> there's no understanding on the part of the driver of what the firmware
> on the device is doing or how it's glued into the audio subsystem.

the API should allow for userspace to specify the firmware name, but
that's about it.  it is up to the userspace application to arbitrarily
load different firmware files on the fly into the codec without the
codec caring what's going into it.  often times the firmware is DSP
code to do different post processing on the audio stream (cleanup or
whatever).
-mike
