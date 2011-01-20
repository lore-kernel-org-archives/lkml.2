Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab1ATHVT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 02:21:19 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:37074 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab1ATHVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 02:21:17 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6231"; a="71197564"
Message-ID: <4D37E265.9060304@codeaurora.org>
Date: Thu, 20 Jan 2011 12:51:09 +0530
From: Trilok Soni <tsoni@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: riyer@nvidia.com
CC: dmitry.torokhov@gmail.com, pavel@ucw.cz, shubhrajyoti@ti.com,
        ccross@android.com, konkers@android.com, olof@lixom.net,
        achew@nvidia.com, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH v7] input: tegra-kbc - Add tegra keyboard driver
References: <1295485917-21278-1-git-send-email-riyer@nvidia.com>
In-Reply-To: <1295485917-21278-1-git-send-email-riyer@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rakesh,

On 1/20/2011 6:41 AM, riyer@nvidia.com wrote:
> From: Rakesh Iyer <riyer@nvidia.com>
> 
> This patch adds support for the internal matrix keyboard controller for
> Nvidia Tegra platforms.
> 
> Signed-off-by: Rakesh Iyer <riyer@nvidia.com>
> ---
> Fixed the stupid loop variable change.
> Fixed some code styling problems reported by checkpatch.pl.
> 

Thanks a ton for creating quick revisions :)

>  arch/arm/mach-tegra/include/mach/kbc.h |   61 +++
>  drivers/input/keyboard/Kconfig         |   10 +
>  drivers/input/keyboard/Makefile        |    1 +
>  drivers/input/keyboard/tegra-kbc.c     |  727 ++++++++++++++++++++++++++++++++
>  4 files changed, 799 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/mach-tegra/include/mach/kbc.h
>  create mode 100644 drivers/input/keyboard/tegra-kbc.c
> 
> diff --git a/arch/arm/mach-tegra/include/mach/kbc.h b/arch/arm/mach-tegra/include/mach/kbc.h
> new file mode 100644
> index 0000000..60d646c
> --- /dev/null
> +++ b/arch/arm/mach-tegra/include/mach/kbc.h
> @@ -0,0 +1,61 @@
> +/*
> + * Platform definitions for tegra-kbc keyboard input driver
> + *
> + * Copyright (c) 2010, NVIDIA Corporation.

Wearing my legal hat. You might want to do 2010-2011 ?

> diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
> index 9cc488d..8be47da 100644
> --- a/drivers/input/keyboard/Kconfig
> +++ b/drivers/input/keyboard/Kconfig
> @@ -327,6 +327,16 @@ config KEYBOARD_NEWTON
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called newtonkbd.
>  
> +config KEYBOARD_TEGRA
> +	tristate "NVIDIA Tegra internal matrix keyboard controller support"
> +	depends on ARCH_TEGRA
> +	help
> +	  Say Y here if you want to use a matrix keyboard connected directly
> +	  to the internal keyboard controller on Tegra SoCs.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called tegra-kbc.
> +
>  config KEYBOARD_OPENCORES
>  	tristate "OpenCores Keyboard Controller"
>  	help
> diff --git a/drivers/input/keyboard/Makefile b/drivers/input/keyboard/Makefile
> index 504b591..ac0dcb9 100644
> --- a/drivers/input/keyboard/Makefile
> +++ b/drivers/input/keyboard/Makefile
> @@ -38,6 +38,7 @@ obj-$(CONFIG_KEYBOARD_SH_KEYSC)		+= sh_keysc.o
>  obj-$(CONFIG_KEYBOARD_STMPE)		+= stmpe-keypad.o
>  obj-$(CONFIG_KEYBOARD_STOWAWAY)		+= stowaway.o
>  obj-$(CONFIG_KEYBOARD_SUNKBD)		+= sunkbd.o
> +obj-$(CONFIG_KEYBOARD_TEGRA)		+= tegra-kbc.o
>  obj-$(CONFIG_KEYBOARD_TWL4030)		+= twl4030_keypad.o
>  obj-$(CONFIG_KEYBOARD_XTKBD)		+= xtkbd.o
>  obj-$(CONFIG_KEYBOARD_W90P910)		+= w90p910_keypad.o
> diff --git a/drivers/input/keyboard/tegra-kbc.c b/drivers/input/keyboard/tegra-kbc.c
> new file mode 100644
> index 0000000..33ac315
> --- /dev/null
> +++ b/drivers/input/keyboard/tegra-kbc.c
> @@ -0,0 +1,727 @@
> +/*
> + * Keyboard class input driver for the NVIDIA Tegra SoC internal matrix
> + * keyboard controller
> + *
> + * Copyright (c) 2009-2010, NVIDIA Corporation.

2009-2011

> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along
> + * with this program; if not, write to the Free Software Foundation, Inc.,
> + * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
> + */

---Trilok Soni

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
