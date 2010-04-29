Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933409Ab0D3Rfi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:35:38 -0400
Received: from legolas.restena.lu ([158.64.1.34]:40954 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933406Ab0D3RfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:35:09 -0400
Date: Thu, 29 Apr 2010 19:16:24 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-kernel@vger.kernel.org, Harald Welte <laforge@gnumonks.org>,
       linux-fbdev@vger.kernel.org, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: Re: [PATCH 24/30] viafb: Add a driver for the video capture engine
Message-ID: <20100429191624.30cd67e0@neptune.home>
In-Reply-To: <1272493051-25380-25-git-send-email-corbet@lwn.net>
References: <1272493051-25380-1-git-send-email-corbet@lwn.net>
	<1272493051-25380-25-git-send-email-corbet@lwn.net>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonathan,

Seems a bit confusing to me to have viafb-camera/ show up under the
PCI device when built with !CONFIG_FB_VIA_CAMERA.

On Wed, 28 April 2010 Jonathan Corbet <corbet@lwn.net> wrote:
> diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
> index 22c1662..a969f76 100644
> --- a/drivers/video/Kconfig
> +++ b/drivers/video/Kconfig
> @@ -1516,12 +1516,21 @@ config FB_VIA
>  	  This is the frame buffer device driver for Graphics chips of VIA
>  	  UniChrome (Pro) Family (CLE266,PM800/CN400,P4M800CE/P4M800Pro/
>  	  CN700/VN800,CX700/VX700,P4M890) and Chrome9 Family (K8M890,CN896
> - 	  /P4M900,VX800)
> + 	  /P4M900,VX800,VX855)
>  	  Say Y if you have a VIA UniChrome graphics board.
>  
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called viafb.
>  
> +config FB_VIA_CAMERA
> +	tristate "VIAFB camera controller support"
> +	depends on FB_VIA
> +	select VIDEOBUF_DMA_SG
> +	help
> +	   Driver support for the integrated camera controller in VIA
> +	   Chrome9 chipsets.  Currently only tested on OLPC xo-1.5 systems
> +	   with ov7670 sensors.
> +
>  config FB_NEOMAGIC
>  	tristate "NeoMagic display support"
>  	depends on FB && PCI
> diff --git a/drivers/video/via/Makefile b/drivers/video/via/Makefile
> index 2751cb2..05401b6 100644
> --- a/drivers/video/via/Makefile
> +++ b/drivers/video/via/Makefile
> @@ -3,6 +3,7 @@
>  #
>  
>  obj-$(CONFIG_FB_VIA) += viafb.o 
> +obj-$(CONFIG_FB_VIA_CAMERA) += via-camera.o
>  
>  viafb-y	:=viafbdev.o hw.o via_i2c.o dvi.o lcd.o ioctl.o accel.o \
>  	via_utility.o vt1636.o global.o tblDPASetting.o viamode.o tbl1636.o \

<snip>

> diff --git a/drivers/video/via/via-core.c b/drivers/video/via/via-core.c
> index 83a8d34..58256d0 100644
> --- a/drivers/video/via/via-core.c
> +++ b/drivers/video/via/via-core.c
> @@ -493,7 +493,10 @@ static struct viafb_subdev_info {
>  	},
>  	{
>  		.name = "viafb-i2c",
> -	}
> +	},
> +	{
> +		.name = "viafb-camera",
> +	},
>  };
>  #define N_SUBDEVS ARRAY_SIZE(viafb_subdevs)
>  

I think the extra 'viafb-camera' entry should be wrapped into a

#if defined(CONFIG_FB_VIA_CAMERA) || defined(CONFIG_FB_VIA_CAMERA_MODULE)

or probably better be dynamically added when camera module is loaded
and/or detects/probes the camera sub-device.

Thanks,
Bruno
