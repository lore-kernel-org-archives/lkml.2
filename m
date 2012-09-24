Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab2IXMBI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 08:01:08 -0400
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2889 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877Ab2IXMBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 08:01:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Prabhakar <prabhakar.csengg@gmail.com>
Subject: Re: [PATCH v2] media: davinci: vpif: display: separate out subdev from output
Date: Mon, 24 Sep 2012 13:59:09 +0200
User-Agent: KMail/1.13.7 (Linux/3.6.0-rc3-durdane; KDE/4.8.4; x86_64; ; )
Cc: LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Sekhar Nori <nsekhar@ti.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        VGER <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
References: <1348483451-20668-1-git-send-email-prabhakar.lad@ti.com> <201209241259.11570.hverkuil@xs4all.nl> <201209241350.00893.hverkuil@xs4all.nl>
In-Reply-To: <201209241350.00893.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201209241359.09089.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon September 24 2012 13:50:00 Hans Verkuil wrote:
> On Mon September 24 2012 12:59:11 Hans Verkuil wrote:
> > On Mon September 24 2012 12:44:11 Prabhakar wrote:
> > > From: Lad, Prabhakar <prabhakar.lad@ti.com>
> > > 
> > > vpif_display relied on a 1-1 mapping of output and subdev. This is not
> > > necessarily the case. Separate the two. So there is a list of subdevs
> > > and a list of outputs. Each output refers to a subdev and has routing
> > > information. An output does not have to have a subdev.
> > > 
> > > The initial output for each channel is set to the fist output.
> > > 
> > > Currently missing is support for associating multiple subdevs with
> > > an output.
> > > 
> > > Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
> > > Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> > > Cc: Hans Verkuil <hans.verkuil@cisco.com>
> > > Cc: Sekhar Nori <nsekhar@ti.com>
> > 
> > Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> I'm retracting this Ack. I did see something that wasn't right but I thought
> it was harmless, but after thinking some more I believe it should be fixed.
> Luckily, it's easy to fix. See below. Since we need a new version anyway I
> also added a comment to a few minor issues that can be fixed at the same time.
> 
> > 
> > Regards,
> > 
> > 	Hans
> > 
> > > ---
> > >  This patch is dependent on the patch series from Hans
> > >  (http://www.mail-archive.com/linux-media@vger.kernel.org/msg52270.html)
> > > 
> > >  Changes for V2:
> > >  1: Changed v4l2_device_call_until_err() call to v4l2_subdev_call() for
> > >     s_routing, since this call is for specific subdev, pointed out by Hans.
> > > 
> > >  arch/arm/mach-davinci/board-da850-evm.c       |   29 +++++-
> > >  arch/arm/mach-davinci/board-dm646x-evm.c      |   39 ++++++-
> > >  drivers/media/platform/davinci/vpif_display.c |  136 ++++++++++++++++++++-----
> > >  include/media/davinci/vpif_types.h            |   20 +++-
> > >  4 files changed, 183 insertions(+), 41 deletions(-)
> > > 
> > > diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
> > > index 3081ea4..23a7012 100644
> > > --- a/arch/arm/mach-davinci/board-da850-evm.c
> > > +++ b/arch/arm/mach-davinci/board-da850-evm.c
> > > @@ -46,6 +46,7 @@
> > >  #include <mach/spi.h>
> > >  
> > >  #include <media/tvp514x.h>
> > > +#include <media/adv7343.h>
> > >  
> > >  #define DA850_EVM_PHY_ID		"davinci_mdio-0:00"
> > >  #define DA850_LCD_PWR_PIN		GPIO_TO_PIN(2, 8)
> > > @@ -1257,16 +1258,34 @@ static struct vpif_subdev_info da850_vpif_subdev[] = {
> > >  	},
> > >  };
> > >  
> > > -static const char const *vpif_output[] = {
> > > -		"Composite",
> > > -		"S-Video",
> > > +static const struct vpif_output da850_ch0_outputs[] = {
> > > +	{
> > > +		.output = {
> > > +			.index = 0,
> > > +			.name = "Composite",
> > > +			.type = V4L2_OUTPUT_TYPE_ANALOG,
> > > +		},
> > > +		.subdev_name = "adv7343",
> > > +		.output_route = ADV7343_COMPOSITE_ID,
> > > +	},
> > > +	{
> > > +		.output = {
> > > +			.index = 1,
> > > +			.name = "S-Video",
> > > +			.type = V4L2_OUTPUT_TYPE_ANALOG,
> > > +		},
> > > +		.subdev_name = "adv7343",
> > > +		.output_route = ADV7343_SVIDEO_ID,
> > > +	},
> > >  };
> > >  
> > >  static struct vpif_display_config da850_vpif_display_config = {
> > >  	.subdevinfo   = da850_vpif_subdev,
> > >  	.subdev_count = ARRAY_SIZE(da850_vpif_subdev),
> > > -	.output       = vpif_output,
> > > -	.output_count = ARRAY_SIZE(vpif_output),
> > > +	.chan_config[0] = {
> > > +		.outputs = da850_ch0_outputs,
> > > +		.output_count = ARRAY_SIZE(da850_ch0_outputs),
> > > +	},
> > >  	.card_name    = "DA850/OMAP-L138 Video Display",
> > >  };
> > >  
> > > diff --git a/arch/arm/mach-davinci/board-dm646x-evm.c b/arch/arm/mach-davinci/board-dm646x-evm.c
> > > index ad249c7..c206768 100644
> > > --- a/arch/arm/mach-davinci/board-dm646x-evm.c
> > > +++ b/arch/arm/mach-davinci/board-dm646x-evm.c
> > > @@ -26,6 +26,7 @@
> > >  #include <linux/i2c/pcf857x.h>
> > >  
> > >  #include <media/tvp514x.h>
> > > +#include <media/adv7343.h>
> > >  
> > >  #include <linux/mtd/mtd.h>
> > >  #include <linux/mtd/nand.h>
> > > @@ -496,18 +497,44 @@ static struct vpif_subdev_info dm646x_vpif_subdev[] = {
> > >  	},
> > >  };
> > >  
> > > -static const char *output[] = {
> > > -	"Composite",
> > > -	"Component",
> > > -	"S-Video",
> > > +static const struct vpif_output dm6467_ch0_outputs[] = {
> > > +	{
> > > +		.output = {
> > > +			.index = 0,
> > > +			.name = "Composite",
> > > +			.type = V4L2_OUTPUT_TYPE_ANALOG,
> > > +		},
> > > +		.subdev_name = "adv7343",
> > > +		.output_route = ADV7343_COMPOSITE_ID,
> > > +	},
> > > +	{
> > > +		.output = {
> > > +			.index = 1,
> > > +			.name = "Component",
> > > +			.type = V4L2_OUTPUT_TYPE_ANALOG,
> > > +		},
> > > +		.subdev_name = "adv7343",
> > > +		.output_route = ADV7343_COMPONENT_ID,
> > > +	},
> > > +	{
> > > +		.output = {
> > > +			.index = 2,
> > > +			.name = "S-Video",
> > > +			.type = V4L2_OUTPUT_TYPE_ANALOG,
> > > +		},
> > > +		.subdev_name = "adv7343",
> > > +		.output_route = ADV7343_SVIDEO_ID,
> > > +	},
> > >  };

Oops, and another thing: for both struct v4l2_input and struct v4l2_output
you should also fill in the capabilities field in the board files.

This should be either V4L2_IN_CAP_STD (SDTV) or V4L2_IN_CAP_CUSTOM_TIMINGS
(HDTV) for input and the V4L2_OUT_ variants for v4l2_output.

Regards,

	Hans
