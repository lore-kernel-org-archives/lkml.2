Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932630Ab1ELUXK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 16:23:10 -0400
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:2590 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757573Ab1ELUXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 16:23:08 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: Re: [PATCH] Add VIDEO IN driver for OKI SEMICONDUCTOR ML7213/ML7223 IOHs
Date: Thu, 12 May 2011 22:23:01 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc7-durdane; KDE/4.4.5; x86_64; ; )
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com
References: <1305188164-6372-1-git-send-email-tomoya-linux@dsn.okisemi.com>
In-Reply-To: <1305188164-6372-1-git-send-email-tomoya-linux@dsn.okisemi.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201105122223.01369.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomoya,

This is a pretty big patch and it will take some time to review properly.
However, I can give some high-level comments already based on an initial
scan of the code.

1) New drivers that use controls (G/S_CTRL et al) must use the new control
framework. See Documentation/video4linux/v4l2-controls.txt. We are slowly
converting existing drivers to this framework, and I don't want to add to that
workload :-)

2) The sensor drivers should be named 'ov7620', 'ncm13j', etc. and be
independent of (and not refer to) the IOH driver. After all, these sensor
drivers can be used in other devices as well.

3) ioh_video_in.c is definitely too large with 4704 lines. I would strongly
suggest splitting it in multiple files.

4) There are a bunch of IOH_VIDEO_ private ioctls. I haven't had time to analyse
them, but it would help a lot if you could write some sort of overview of what
they do and why you need them. I suspect that some can be replaced by private
controls, some might already be available in V4L2 and some might need extensions
to V4L2 (I hope not, though).

5) The OH_VIDEO_IN_DMA_CONTIG define makes a mess of the code. Why do you need it?
I have never seen a driver that can support either DMA_CONTIG or VMALLOC and I would
like to know some background information here. BTW, 2.6.39 merges the new videobuf2
framework (the successor to videobuf), which I would recommend that you use. It is
much easier to work with and understand than videobuf.

Regards,

	Hans

On Thursday, May 12, 2011 10:16:04 Tomoya MORINAGA wrote:
> This patch is for Video IN driver of OKI SEMICONDUCTOR ML7213/ML7223 IOHs
> (Input/Output Hub).
> These ML7213/ML7223 IOHs are companion chip for Intel Atom E6xx series.
> ML7213 IOH is for IVI(In-Vehicle Infotainment) use and ML7223 IOH is for
> MP(Media Phone) use.
> 
> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
> ---
>  drivers/media/video/Kconfig                   |   79 +
>  drivers/media/video/Makefile                  |   15 +
>  drivers/media/video/ioh_video_in.c            | 4704 +++++++++++++++++++++++++
>  drivers/media/video/ioh_video_in_main.h       | 1058 ++++++
>  drivers/media/video/ioh_video_in_ml86v76651.c |  620 ++++
>  drivers/media/video/ioh_video_in_ncm13j.c     |  584 +++
>  drivers/media/video/ioh_video_in_ov7620.c     |  637 ++++
>  drivers/media/video/ioh_video_in_ov9653.c     |  818 +++++
>  8 files changed, 8515 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/ioh_video_in.c
>  create mode 100644 drivers/media/video/ioh_video_in_main.h
>  create mode 100644 drivers/media/video/ioh_video_in_ml86v76651.c
>  create mode 100644 drivers/media/video/ioh_video_in_ncm13j.c
>  create mode 100644 drivers/media/video/ioh_video_in_ov7620.c
>  create mode 100644 drivers/media/video/ioh_video_in_ov9653.c
> 
> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> index 00f51dd..11a96a8 100644
> --- a/drivers/media/video/Kconfig
> +++ b/drivers/media/video/Kconfig
> @@ -928,6 +928,85 @@ config VIDEO_MX2
>  	  Interface
>  
>  
> +config IOH_VIDEOIN
> +        tristate "OKI SEMICONDUCTOR ML7213/ML7223 IOH VIDEO IN"
> +        depends on PCI && DMADEVICES
> +	select PCH_DMA
> +        help
> +	  This driver is for Video IN of OKI SEMICONDUCTOR ML7213/ML7223 IOHs
> +	  (Input/Output Hub).
> +	  These ML7213/ML7223 IOHs are companion chip for Intel Atom E6xx
> +	  series.
> +	  ML7213 IOH is for IVI(In-Vehicle Infotainment) use and ML7223 IOH is
> +	  for MP(Media Phone) use.
> +
> +config  IOH_VIDEO_DEVICE_SELECT
> +        boolean
> +
> +choice
> +        prompt "Select IOH VIDEO IN Device"
> +        depends on IOH_VIDEOIN
> +        help
> +           This is a selection of used device of the IOH VIDEO.
> +
> +config IOH_ML86V76651
> +        boolean "IOH VIDEO IN(ML86V76651)"
> +        depends on PCI && IOH_VIDEOIN && I2C_EG20T
> +        help
> +          If you say yes to this option, support will be included for the
> +          IOH VIDEO ON Driver(ML86V76651).
> +
> +config IOH_ML86V76653
> +        boolean "IOH VIDEO IN(ML86V76653)"
> +        depends on PCI && IOH_VIDEOIN && I2C_EG20T
> +        help
> +          If you say yes to this option, support will be included for the
> +          IOH VIDEO ON Driver(ML86V76653).
> +
> +config IOH_OV7620
> +        boolean "IOH VIDEO IN(OV7620)"
> +        depends on PCI && IOH_VIDEOIN && I2C_EG20T
> +        help
> +          If you say yes to this option, support will be included for the
> +          IOH VIDEO ON Driver(OV7620).
> +
> +config IOH_OV9653
> +        boolean "IOH VIDEO IN(OV9653)"
> +        depends on PCI && IOH_VIDEOIN && I2C_EG20T
> +        help
> +          If you say yes to this option, support will be included for the
> +          IOH VIDEO ON Driver(OV9653).
> +
> +config IOH_NCM13J
> +        boolean "IOH VIDEO IN(NCM13-J)"
> +        depends on PCI && IOH_VIDEOIN && I2C_EG20T
> +        help
> +          If you say yes to this option, support will be included for the
> +          IOH VIDEO ON Driver(NCM13-J).
> +endchoice
> +
> +config  IOH_VIDEO_FRAMEWORK_SELECT
> +        boolean
> +
> +choice
> +        prompt "Select IOH VIDEO IN Videobuf Freamework"
> +        depends on IOH_VIDEOIN
> +        help
> +           This is a selection of used the method of video buffer framework.
> +
> +config IOH_VIDEO_IN_VMALLOC
> +        boolean "VMALLOC Framework"
> +	select VIDEOBUF_VMALLOC
> +        help
> +          If you say yes to this option, VMALLOC framework is used.
> +
> +config IOH_VIDEO_IN_DMA_CONTIG
> +        boolean "DMA-CONTIG Framework"
> +	select VIDEOBUF_DMA_CONTIG
> +        help
> +          If you say yes to this option, DMA-CONTIG framework is used.
> +endchoice
> +
