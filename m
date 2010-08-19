Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828Ab0HSARO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 20:17:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40751 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751543Ab0HSARK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 20:17:10 -0400
Date: Wed, 18 Aug 2010 17:16:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Olof Johansson <olof@lixom.net>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc: make number of mmcblk minors configurable
Message-Id: <20100818171636.0625b668.akpm@linux-foundation.org>
In-Reply-To: <20100818041333.GA14149@lixom.net>
References: <20100818041333.GA14149@lixom.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Aug 2010 23:13:33 -0500
Olof Johansson <olof@lixom.net> wrote:

> The old limit of number of minor numbers per mmcblk device was hardcoded
> at 8. This isn't enough for some of the more elaborate partitioning
> schemes, for example those used by Chrome OS.
> 
> Since there might be a bunch of systems out there with static /dev
> contents that relies on the old numbering scheme, let's make it a
> build-time option with the default set to the previous 8.
> 

How does the numbering scheme change?  What's the user-visible effect
of setting CONFIG_MMC_BLOCK_MINORS to, say, 16?

> ---
>  drivers/mmc/card/Kconfig |   10 ++++++++++
>  drivers/mmc/card/block.c |   20 ++++++++------------
>  2 files changed, 18 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/mmc/card/Kconfig b/drivers/mmc/card/Kconfig
> index 3f2a912..e939dcf 100644
> --- a/drivers/mmc/card/Kconfig
> +++ b/drivers/mmc/card/Kconfig
> @@ -14,6 +14,16 @@ config MMC_BLOCK
>  	  mount the filesystem. Almost everyone wishing MMC support
>  	  should say Y or M here.
>  
> +config MMC_BLOCK_MINORS
> +	int "Number of minors per block device"
> +	range 4 32
> +	default 8
> +	help
> +	  Number of minors per block device. One is needed for every
> +	  partition (plus one for the whole device).
> +	  Default is 8 to be backwards compatible with previous
> +	  hardcoded device numbering.

If possible it would be better to do this with a kernel boot (or
modprobe) parameter.  That permits vendors to ship packaged kernels
with full functionality, etc.  Possible?  The default value of the
runtime-settable parameter could be Kconfigurable is there's a real
need for that.


>  config MMC_BLOCK_BOUNCE
>  	bool "Use bounce buffer for simple hosts"
>  	depends on MMC_BLOCK
> diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
> index d545f79..524e232 100644
> --- a/drivers/mmc/card/block.c
> +++ b/drivers/mmc/card/block.c
> @@ -45,13 +45,9 @@
>  
>  MODULE_ALIAS("mmc:block");
>  
> -/*
> - * max 8 partitions per card
> - */
> -#define MMC_SHIFT	3
> -#define MMC_NUM_MINORS	(256 >> MMC_SHIFT)
> +#define MMC_MAX_DEVICES	((255 + CONFIG_MMC_BLOCK_MINORS) / CONFIG_MMC_BLOCK_MINORS)

So if I increase CONFIG_MMC_BLOCK_MINORS, I can no longer support as
many devices?  That'd be worth mentioning somewhere?

fwiw, the above could use DIV_ROUND_UP().


