Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758975Ab2HHRdC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 13:33:02 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:35467 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755812Ab2HHRdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 13:33:00 -0400
MIME-Version: 1.0
In-Reply-To: <20120808065502.GI1451@pengutronix.de>
References: <1344379514-30076-1-git-send-email-matt@genesi-usa.com>
 <1344379514-30076-2-git-send-email-matt@genesi-usa.com> <20120808065502.GI1451@pengutronix.de>
From: Matt Sealey <matt@genesi-usa.com>
Date: Wed, 8 Aug 2012 12:32:39 -0500
Message-ID: <CAKGA1bmUuSZuWDM4QPTxmNR0+=uQ1RbFhw4u-sb9KaSPYwQiVw@mail.gmail.com>
Subject: Re: [PATCH 1/2] ARM: build ssi-fiq.S in ARM mode to prevent
 CONFIG_THUMB2_KERNEL build breakage
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Steev Klimaszewski <steev@genesi-usa.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>, Dave Martin <dave.martin@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Sascha Hauer <kernel@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 8, 2012 at 1:55 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
>>               .text
>> +             .arm
>>               .global imx_ssi_fiq_start
>>               .global imx_ssi_fiq_end
>>               .global imx_ssi_fiq_base
>
> I think it would be better to add a depends on !THUMB2_KERNEL to
> SND_IMX_SOC_PCM_FIQ. The above may result in broken code in a thumb2
> kernel, so I'd rather keep the compile error instead.

I'm curious as to how/why would it result in broken code? It's not
possible that the processors relying on
the imx_ssi_fiq_* stuff cannot run ARM code (unless Freescale shipped
a weird version) so it should
magically enter and exit. I wonder if it needs some thumb-interworking
stuff wrapped around it though.
You'd know better than me..

I'm a little worried that making it !CONFIG_THUMB2_KERNEL would
basically make more than
one of the boards in imx_v6_v7_defconfig suddenly lose audio support
for no other reason.. I don't
like things just disappearing from the kernel by dependency magic.
That said, a crash would be worse.

I guess the eukrea tlv320 audio support should also be split, or
looked at. This is the snippet that
confuses me the most;

config SND_SOC_EUKREA_TLV320
        tristate "Eukrea TLV320"
        depends on MACH_EUKREA_MBIMX27_BASEBOARD \
                || MACH_EUKREA_MBIMXSD25_BASEBOARD \
                || MACH_EUKREA_MBIMXSD35_BASEBOARD \
                || MACH_EUKREA_MBIMXSD51_BASEBOARD
        depends on I2C
        select SND_SOC_TLV320AIC23
        select SND_SOC_IMX_PCM_FIQ
        select SND_SOC_IMX_AUDMUX
        select SND_SOC_IMX_SSI
        help
          Enable I2S based access to the TLV320AIC23B codec attached
          to the SSI interface

.. Since you said I2S support doesn't require it, only AC97, this alone seems
redundant, but since I wasn't the one to write it, test it, have no
access to this
board I have no idea. Mark's assertion that it's just not required now DMA works
properly, could be true and this can be ditched, but I don't want to
patch something
I can't actually test.. my primary concern was fixing the build breakage.

If that gets fixed, then the only dependencies are the WM1131_EV1 board
which isn't in imx_v6_v7_defconfig, and the phyCORE support which needs it
for AC97. That's one of your customers, right? I wouldn't want to disable a
board, but I can justify to myself disabling the audio for *one* board based if
it's just a caveat of a Thumb2 kernel.

I'm going to do a trapse through and find where Russell nacked Dave's
thumb-aware
rewrite.. would you mind if you have any of these boards seeing if it
really DOES
cause broken code? The moment we noticed this was broken we quit designing
with AC97 codecs, so there's no Genesi board of similar pedigree
around that ever
got to a PCB..

-- 
Matt Sealey <matt@genesi-usa.com>
Product Development Analyst, Genesi USA, Inc.
