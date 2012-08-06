Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab2HFUkN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 16:40:13 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:37190 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755991Ab2HFUkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 16:40:11 -0400
MIME-Version: 1.0
In-Reply-To: <20120806201609.GX25644@pengutronix.de>
References: <20120805230238.GA1663@lizard> <1344207819-3415-4-git-send-email-anton.vorontsov@linaro.org>
 <CAKGA1bkiHj=zMJXSzoGp3fpLS3POnFXSV5y7sYYFAikqoUT9tQ@mail.gmail.com>
 <20120806154951.GQ16861@opensource.wolfsonmicro.com> <CAKGA1b=_AOub_pEJJGBTb6Y7wLZaSYKQjFTyMVFSr_=9VX4wpg@mail.gmail.com>
 <20120806193734.GA16199@opensource.wolfsonmicro.com> <20120806201609.GX25644@pengutronix.de>
From: Matt Sealey <matt@genesi-usa.com>
Date: Mon, 6 Aug 2012 15:39:50 -0500
Message-ID: <CAKGA1bmMqyL4gyLYcanEH=R=HuBjRCNRLjUEWCj8wmpi3HuL0g@mail.gmail.com>
Subject: Re: [PATCH 4/9] ASoC: imx: Don't use {en,dis}able_fiq() calls
To: Robert Schwebel <r.schwebel@pengutronix.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        Sascha Hauer <kernel@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 6, 2012 at 3:16 PM, Robert Schwebel
<r.schwebel@pengutronix.de> wrote:
> On Mon, Aug 06, 2012 at 08:37:34PM +0100, Mark Brown wrote:
>> As far as I can tell nobody's really running much up to date mainline
>> on older i.MX processors, all the work is going on the new stuff and
>> most of the board are on either vendor BSPs or older kernels.
>
> That's not true; we still run MX25, MX27, MX35, MX28 on mainline in
> active projects.

I think Shawn Guo (FSL/Linaro) would also disagree, since he's just
posted a large amount of MXS patches to fix up the board for device
trees, and Arnd is pulling them.

Work is ongoing, it would be awful to delete something people really
relied on or were in progress fixing (ahem). If they get up to audio
in the near future the audio FIQ stuff would just end up being
resubmitted almost verbatim... that seems like unnecessary churn.

As far as I know, the FIQ usage is quite valid for the processor it
needs to run on (MX21/27/28, right?) in the modes it runs in (AC97 on
these processors, and maybe MX35 too), and I'm just trying to figure
out what the steps are for

* making sure it doesn't get built for architectures/variants it's
certainly NOT required on (imx_v6_v7_defconfig, if it actually enabled
audio, that is - in fact, audio should be enabled as more one of the
boards supported defines it in the device tree) which would amount to
two seperate patches, one for the defconfig, one for the CONFIG item.

I did note that SND_SOC_EUKREA_TLV320 enables FIQ but it also depends
on MX51 which makes me think this need to be split, too, so that MX51
boards don't have it but MX2/MX3 do.

* if it is built then it's built as ARM code (redundant, as previously
stated, but would have stopped me from swearing at my build box when I
hit the issue yet again) which could be a patch or could be ignored.
I'd rather discuss this here than clutter the ML with several respins
of a patch, let's get an opinion first - to .arm or no to .arm?

* make sure there's no weird FIQ stuff floating around that has so far
relied on SND_SOC_IMX_PCM_FIQ doing select FIQ before I make it not
compile in for other boards (since otherwise no i.MX processor selects
FIQ if they're not using that driver, it could be simply coincidence
nobody noticed). I don't want to be the one submitting a patch I can't
test which mysteriously breaks every MX28 on the planet (since Rob,
Shawn, Sascha might be the ones swearing at me instead)

* making sure someone's actually testing audio as above... and
where/if/when the MX28 audio stuff is going in the future und so
weiter..

I guess I need Sascha to pipe up and tell me what the code is needed
for exactly again.. and someone to test the result of the changes..

-- 
Matt Sealey <matt@genesi-usa.com>
Product Development Analyst, Genesi USA, Inc.
