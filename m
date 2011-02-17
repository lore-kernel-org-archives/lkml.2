Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505Ab1BQSJz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 13:09:55 -0500
Received: from lechat.rtp-net.org ([88.191.19.38]:58176 "EHLO
	lechat.rtp-net.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756797Ab1BQSJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 13:09:52 -0500
From: Arnaud Patard (Rtp) <arnaud.patard@rtp-net.org>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, Paul Mundt <lethal@linux-sh.org>,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 1/7] Add a mfd IPUv3 driver
Organization: RtpNet
References: <1297865452-32181-1-git-send-email-s.hauer@pengutronix.de>
	<1297865452-32181-2-git-send-email-s.hauer@pengutronix.de>
Date: Thu, 17 Feb 2011 19:10:24 +0100
In-Reply-To: <1297865452-32181-2-git-send-email-s.hauer@pengutronix.de>
	(Sascha Hauer's message of "Wed, 16 Feb 2011 15:10:46 +0100")
Message-ID: <871v36pm5r.fsf@lechat.rtp-net.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sascha Hauer <s.hauer@pengutronix.de> writes:

Hi,

> The IPU is the Image Processing Unit found on i.MX51/53 SoCs. It
> features several units for image processing, this patch adds support
> for the units needed for Framebuffer support, namely:
>
> - Display Controller (dc)
> - Display Interface (di)
> - Display Multi Fifo Controller (dmfc)
> - Display Processor (dp)
> - Image DMA Controller (idmac)
>
> This patch is based on the Freescale driver, but follows a different
> approach. The Freescale code implements logical idmac channels and
> the handling of the subunits is hidden in common idmac code pathes
> in big switch/case statements. This patch instead just provides code
> and resource management for the different subunits. The user, in this
> case the framebuffer driver, decides how the different units play
> together.
>
> The IPU has other units missing in this patch:
>
> - CMOS Sensor Interface (csi)
> - Video Deinterlacer (vdi)
> - Sensor Multi FIFO Controler (smfc)
> - Image Converter (ic)
> - Image Rotator (irt)
>
> So expect more files to come in this directory.
>
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-fbdev@vger.kernel.org
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> ---
>  arch/arm/plat-mxc/include/mach/ipu-v3.h |   49 +++
>  drivers/video/Kconfig                   |    2 +
>  drivers/video/Makefile                  |    1 +
>  drivers/video/imx-ipu-v3/Makefile       |    3 +
>  drivers/video/imx-ipu-v3/ipu-common.c   |  708 +++++++++++++++++++++++++++++++
>  drivers/video/imx-ipu-v3/ipu-cpmem.c    |  612 ++++++++++++++++++++++++++
>  drivers/video/imx-ipu-v3/ipu-dc.c       |  364 ++++++++++++++++
>  drivers/video/imx-ipu-v3/ipu-di.c       |  550 ++++++++++++++++++++++++
>  drivers/video/imx-ipu-v3/ipu-dmfc.c     |  355 ++++++++++++++++
>  drivers/video/imx-ipu-v3/ipu-dp.c       |  476 +++++++++++++++++++++
>  drivers/video/imx-ipu-v3/ipu-prv.h      |  216 ++++++++++
>  include/linux/mfd/imx-ipu-v3.h          |  219 ++++++++++
>  12 files changed, 3555 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/plat-mxc/include/mach/ipu-v3.h
>  create mode 100644 drivers/video/imx-ipu-v3/Makefile
>  create mode 100644 drivers/video/imx-ipu-v3/ipu-common.c
>  create mode 100644 drivers/video/imx-ipu-v3/ipu-cpmem.c
>  create mode 100644 drivers/video/imx-ipu-v3/ipu-dc.c
>  create mode 100644 drivers/video/imx-ipu-v3/ipu-di.c
>  create mode 100644 drivers/video/imx-ipu-v3/ipu-dmfc.c
>  create mode 100644 drivers/video/imx-ipu-v3/ipu-dp.c
>  create mode 100644 drivers/video/imx-ipu-v3/ipu-prv.h
>  create mode 100644 include/linux/mfd/imx-ipu-v3.h

[...]

> diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
> index 6bafb51b..ffdb37a 100644
> --- a/drivers/video/Kconfig
> +++ b/drivers/video/Kconfig
> @@ -26,6 +26,8 @@ source "drivers/gpu/drm/Kconfig"
>  
>  source "drivers/gpu/stub/Kconfig"
>  
> +source "drivers/video/imx-ipu-v3/Kconfig"
> +

I don't see such a Kconfig file in this patch. Got lost while moving
from mfd to video ?

 
>  config VGASTATE
>         tristate
>         default n
> diff --git a/drivers/video/Makefile b/drivers/video/Makefile
> index 8c8fabd..f4921ab 100644
> --- a/drivers/video/Makefile
> +++ b/drivers/video/Makefile
> @@ -153,6 +153,7 @@ obj-$(CONFIG_FB_BFIN_T350MCQB)	  += bfin-t350mcqb-fb.o
>  obj-$(CONFIG_FB_BFIN_7393)        += bfin_adv7393fb.o
>  obj-$(CONFIG_FB_MX3)		  += mx3fb.o
>  obj-$(CONFIG_FB_DA8XX)		  += da8xx-fb.o
> +obj-$(CONFIG_MFD_IMX_IPU_V3)	  += imx-ipu-v3/

Now that files are in drivers/video, do we want to keep MFD in the name ?

Arnaud
