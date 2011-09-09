Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759797Ab1IITHe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 15:07:34 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37071 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759704Ab1IITHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 15:07:33 -0400
Date: Fri, 9 Sep 2011 20:06:57 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mans Rullgard <mans.rullgard@linaro.org>
Cc: linux-omap@vger.kernel.org, linaro-dev@lists.linaro.org,
        Tony Lindgren <tony@atomide.com>, Jarkko Nikula <jhnikula@gmail.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH v3] ASoC: omap: convert per-board modules to platform
	drivers
Message-ID: <20110909190657.GC14520@n2100.arm.linux.org.uk>
References: <1315568332-10224-1-git-send-email-mans.rullgard@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315568332-10224-1-git-send-email-mans.rullgard@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 09, 2011 at 12:38:51PM +0100, Mans Rullgard wrote:
> This converts the per-board modules to platform drivers for a
> device created by in main platform setup.  These drivers call
> snd_soc_register_card() directly instead of going via a "soc-audio"
> device and the corresponding driver in soc-core.
> 
> Signed-off-by: Mans Rullgard <mans.rullgard@linaro.org>
> ---
> This version uses a table to assign the device name in omap_init_audio().
> It is certainly less ugly than the previous patch.
> 
> Again, tested only on Beagle.
> ---
>  arch/arm/mach-omap2/devices.c |   34 +++++++++++++++++++
>  sound/soc/omap/am3517evm.c    |   55 +++++++++++++++++++-----------
>  sound/soc/omap/igep0020.c     |   52 +++++++++++++++++++----------
>  sound/soc/omap/n810.c         |   73 ++++++++++++++++++++++++++---------------
>  sound/soc/omap/omap3beagle.c  |   55 +++++++++++++++++++-----------
>  sound/soc/omap/omap3evm.c     |   56 ++++++++++++++++++++-----------
>  sound/soc/omap/omap3pandora.c |   70 ++++++++++++++++++++++++---------------
>  sound/soc/omap/overo.c        |   56 +++++++++++++++++++------------
>  sound/soc/omap/rx51.c         |   55 +++++++++++++++++++++----------
>  sound/soc/omap/sdp3430.c      |   65 ++++++++++++++++++++++--------------
>  sound/soc/omap/sdp4430.c      |   60 +++++++++++++++++++++------------
>  sound/soc/omap/zoom2.c        |   68 +++++++++++++++++++++++++-------------
>  12 files changed, 458 insertions(+), 241 deletions(-)

I don't think this is an improvement.  Just look at the diffstat - it almost
doubles the number of lines of code.

One thing here which is utterly silly is:

> +static struct {
> +	int machine;
> +	const char *name;
> +} soc_device_names[] = {
> +	{ MACH_TYPE_OMAP3517EVM,	"am3517evm-soc-audio"	},
> +	{ MACH_TYPE_IGEP0020,		"igep2-soc-audio"	},
> +	{ MACH_TYPE_NOKIA_N810,		"n8x1-soc-audio"	},
> +	{ MACH_TYPE_NOKIA_N810_WIMAX,	"n8x1-soc-audio"	},
> +	{ MACH_TYPE_OMAP3_BEAGLE,	"omap3beagle-soc-audio"	},
> +	{ MACH_TYPE_DEVKIT8000,		"omap3beagle-soc-audio"	},
> +	{ MACH_TYPE_OMAP3EVM,		"omap3evm-soc-audio"	},
> +	{ MACH_TYPE_OMAP3_PANDORA,	"pandora-soc-audio"	},
> +	{ MACH_TYPE_OVERO,		"overo-soc-audio",	},
> +	{ MACH_TYPE_CM_T35,		"overo-soc-audio",	},
> +	{ MACH_TYPE_NOKIA_RX51,		"rx51-soc-audio",	},
> +	{ MACH_TYPE_OMAP_3430SDP,	"sdp3430-soc-audio",	},
> +	{ MACH_TYPE_OMAP_4430SDP,	"sdp4430-soc-audio",	},
> +	{ MACH_TYPE_OMAP_ZOOM2,		"zoom2-soc-audio",	},
> +};

So you're using the machine ID to select the name of the device.
(That's not really DT compatible.)

> +static int __init am3517evm_soc_init(void)
> +{
> +	if (!machine_is_omap3517evm())
> +		return -ENODEV;

But then you conditionalize the registration of the drivers on the
platform as well.  Why?  It's pointless.  If you don't have the core
code register the struct device for this platform then this driver
won't be bound to a device, and therefore the probe function won't be
called.
