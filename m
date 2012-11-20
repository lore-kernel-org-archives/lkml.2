Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860Ab2KTJKn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 04:10:43 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:38740 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300Ab2KTJKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 04:10:40 -0500
Message-ID: <50AB48FE.1090101@ti.com>
Date: Tue, 20 Nov 2012 14:40:22 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: LMML <linux-media@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Prabhakar Lad <prabhakar.lad@ti.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        LAK <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] davinci: vpbe: pass different platform names to handle
 different ip's
References: <1353331080-26056-1-git-send-email-prabhakar.lad@ti.com>
In-Reply-To: <1353331080-26056-1-git-send-email-prabhakar.lad@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 11/19/2012 6:48 PM, Prabhakar Lad wrote:
> From: Lad, Prabhakar <prabhakar.lad@ti.com>
> 
> The vpbe driver can handle different platforms DM644X, DM36X and
> DM355. To differentiate between this platforms venc_type/vpbe_type
> was passed as part of platform data which was incorrect. The correct
> way to differentiate to handle this case is by passing different
> platform names.
> 
> This patch creates platform_device_id[] array supporting different
> platforms and assigns id_table to the platform driver, and finally
> in the probe gets the actual device by using platform_get_device_id()
> and gets the appropriate driver data for that platform.
> 
> Taking this approach will also make the DT transition easier.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>

Looks good to me except some comments below. After addressing those,
please feel free to add my:

Acked-by: Sekhar Nori <nsekhar@ti.com>

I assume you want to merge this from media tree to manage dependencies?

> ---
>  arch/arm/mach-davinci/board-dm644x-evm.c      |    8 ++--
>  arch/arm/mach-davinci/dm644x.c                |    7 +--
>  drivers/media/platform/davinci/vpbe.c         |    9 +++-
>  drivers/media/platform/davinci/vpbe_display.c |    4 +-
>  drivers/media/platform/davinci/vpbe_osd.c     |   27 +++++++++-
>  drivers/media/platform/davinci/vpbe_venc.c    |   67 +++++++++++++++++--------
>  include/media/davinci/vpbe_osd.h              |    5 +-
>  include/media/davinci/vpbe_venc.h             |    5 +-
>  8 files changed, 94 insertions(+), 38 deletions(-)
> 
> diff --git a/arch/arm/mach-davinci/board-dm644x-evm.c b/arch/arm/mach-davinci/board-dm644x-evm.c
> index f22572ce..b00ade4 100644
> --- a/arch/arm/mach-davinci/board-dm644x-evm.c
> +++ b/arch/arm/mach-davinci/board-dm644x-evm.c
> @@ -689,7 +689,7 @@ static struct vpbe_output dm644xevm_vpbe_outputs[] = {
>  			.std		= VENC_STD_ALL,
>  			.capabilities	= V4L2_OUT_CAP_STD,
>  		},
> -		.subdev_name	= VPBE_VENC_SUBDEV_NAME,
> +		.subdev_name	= DM644X_VPBE_VENC_SUBDEV_NAME,
>  		.default_mode	= "ntsc",
>  		.num_modes	= ARRAY_SIZE(dm644xevm_enc_std_timing),
>  		.modes		= dm644xevm_enc_std_timing,
> @@ -701,7 +701,7 @@ static struct vpbe_output dm644xevm_vpbe_outputs[] = {
>  			.type		= V4L2_OUTPUT_TYPE_ANALOG,
>  			.capabilities	= V4L2_OUT_CAP_DV_TIMINGS,
>  		},
> -		.subdev_name	= VPBE_VENC_SUBDEV_NAME,
> +		.subdev_name	= DM644X_VPBE_VENC_SUBDEV_NAME,
>  		.default_mode	= "480p59_94",
>  		.num_modes	= ARRAY_SIZE(dm644xevm_enc_preset_timing),
>  		.modes		= dm644xevm_enc_preset_timing,
> @@ -712,10 +712,10 @@ static struct vpbe_config dm644xevm_display_cfg = {
>  	.module_name	= "dm644x-vpbe-display",
>  	.i2c_adapter_id	= 1,
>  	.osd		= {
> -		.module_name	= VPBE_OSD_SUBDEV_NAME,
> +		.module_name	= DM644X_VPBE_OSD_SUBDEV_NAME,
>  	},
>  	.venc		= {
> -		.module_name	= VPBE_VENC_SUBDEV_NAME,
> +		.module_name	= DM644X_VPBE_VENC_SUBDEV_NAME,
>  	},
>  	.num_outputs	= ARRAY_SIZE(dm644xevm_vpbe_outputs),
>  	.outputs	= dm644xevm_vpbe_outputs,
> diff --git a/arch/arm/mach-davinci/dm644x.c b/arch/arm/mach-davinci/dm644x.c
> index cd0c8b1..7b785ec 100644
> --- a/arch/arm/mach-davinci/dm644x.c
> +++ b/arch/arm/mach-davinci/dm644x.c
> @@ -670,11 +670,11 @@ static struct resource dm644x_osd_resources[] = {
>  };
>  
>  static struct osd_platform_data dm644x_osd_data = {
> -	.vpbe_type     = VPBE_VERSION_1,
> +	.field_inv_wa_enable = 0,

Stray change in the patch? You anyway do not need to zero initialize.

>  };
>  
>  static struct platform_device dm644x_osd_dev = {
> -	.name		= VPBE_OSD_SUBDEV_NAME,
> +	.name		= DM644X_VPBE_OSD_SUBDEV_NAME,
>  	.id		= -1,
>  	.num_resources	= ARRAY_SIZE(dm644x_osd_resources),
>  	.resource	= dm644x_osd_resources,
> @@ -752,12 +752,11 @@ static struct platform_device dm644x_vpbe_display = {
>  };
>  
>  static struct venc_platform_data dm644x_venc_pdata = {
> -	.venc_type	= VPBE_VERSION_1,
>  	.setup_clock	= dm644x_venc_setup_clock,
>  };
>  
>  static struct platform_device dm644x_venc_dev = {
> -	.name		= VPBE_VENC_SUBDEV_NAME,
> +	.name		= DM644X_VPBE_VENC_SUBDEV_NAME,
>  	.id		= -1,
>  	.num_resources	= ARRAY_SIZE(dm644x_venc_resources),
>  	.resource	= dm644x_venc_resources,
> diff --git a/drivers/media/platform/davinci/vpbe.c b/drivers/media/platform/davinci/vpbe.c
> index 7f5cf9b..0dd3c62 100644
> --- a/drivers/media/platform/davinci/vpbe.c
> +++ b/drivers/media/platform/davinci/vpbe.c
> @@ -558,9 +558,14 @@ static int platform_device_get(struct device *dev, void *data)
>  	struct platform_device *pdev = to_platform_device(dev);
>  	struct vpbe_device *vpbe_dev = data;
>  
> -	if (strcmp("vpbe-osd", pdev->name) == 0)
> +	if (!strcmp(DM644X_VPBE_OSD_SUBDEV_NAME, pdev->name) ||
> +	    !strcmp(DM365_VPBE_OSD_SUBDEV_NAME, pdev->name) ||
> +	    !strcmp(DM355_VPBE_OSD_SUBDEV_NAME, pdev->name))

How about using strstr("vpbe-osd", pdev->name) != NULL instead? Here and
in multiple other places in the patch.

> @@ -341,8 +356,8 @@ static int venc_set_576p50(struct v4l2_subdev *sd)
>  
>  	v4l2_dbg(debug, 2, sd, "venc_set_576p50\n");
>  
> -	if ((pdata->venc_type != VPBE_VERSION_1) &&
> -	  (pdata->venc_type != VPBE_VERSION_2))
> +	if ((venc->venc_type != VPBE_VERSION_1) &&
> +	  (venc->venc_type != VPBE_VERSION_2))

The broken line should be aligned correctly.

Thanks,
Sekhar

