Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218Ab0LVEnh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 23:43:37 -0500
Received: from cantor.suse.de ([195.135.220.2]:39814 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903Ab0LVEng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 23:43:36 -0500
Date: Tue, 21 Dec 2010 20:43:22 -0800
From: Greg KH <gregkh@suse.de>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk, qi.wang@intel.com,
        yong.y.wang@intel.com, joel.clark@intel.com, kok.howg.ewe@intel.com
Subject: Re: [PATCH] pch_phub: add new device ML7213
Message-ID: <20101222044322.GB19006@suse.de>
References: <1292992394-3264-1-git-send-email-tomoya-linux@dsn.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292992394-3264-1-git-send-email-tomoya-linux@dsn.okisemi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 22, 2010 at 01:33:14PM +0900, Tomoya MORINAGA wrote:
> Add ML7213 device information.
> ML7213 is companion chip of Intel Atom E6xx series for IVI(In-Vehicle Infotainment).
> ML7213 is completely compatible for Intel EG20T PCH.
> 
> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
> ---
>  drivers/misc/Kconfig    |    7 ++++-
>  drivers/misc/pch_phub.c |   73 ++++++++++++++++++++++++++++++++++-------------
>  2 files changed, 59 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> index 4d073f1..4852595 100644
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -441,7 +441,7 @@ config BMP085
>  	  module will be called bmp085.
>  
>  config PCH_PHUB
> -	tristate "PCH Packet Hub of Intel Topcliff"
> +	tristate "PCH Packet Hub of Intel Topcliff / OKI SEMICONDUCTOR ML7213"
>  	depends on PCI
>  	help
>  	  This driver is for PCH(Platform controller Hub) PHUB(Packet Hub) of
> @@ -449,6 +449,11 @@ config PCH_PHUB
>  	  processor. The Topcliff has MAC address and Option ROM data in SROM.
>  	  This driver can access MAC address and Option ROM data in SROM.
>  
> +	  This driver also can be used for OKI SEMICONDUCTOR's ML7213 which is
> +	  for IVI(In-Vehicle Infotainment) use.
> +	  ML7213 is companion chip for Intel Atom E6xx series.
> +	  ML7213 is completely compatible for Intel EG20T PCH.
> +
>  	  To compile this driver as a module, choose M here: the module will
>  	  be called pch_phub.
>  
> diff --git a/drivers/misc/pch_phub.c b/drivers/misc/pch_phub.c
> index 744b804..a365e03 100644
> --- a/drivers/misc/pch_phub.c
> +++ b/drivers/misc/pch_phub.c
> @@ -1,5 +1,5 @@
>  /*
> - * Copyright (C) 2010 OKI SEMICONDUCTOR Co., LTD.
> + * Copyright (C) 2010 OKI SEMICONDUCTOR CO., LTD.
>   *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License as published by
> @@ -33,7 +33,12 @@
>  #define PHUB_TIMEOUT 0x05		/* Time out value for Status Register */
>  #define PCH_PHUB_ROM_WRITE_ENABLE 0x01	/* Enabling for writing ROM */
>  #define PCH_PHUB_ROM_WRITE_DISABLE 0x00	/* Disabling for writing ROM */
> -#define PCH_PHUB_ROM_START_ADDR 0x14	/* ROM data area start address offset */
> +#define PCH_PHUB_MAC_START_ADDR 0x20C  /* MAC data area start address offset */
> +#define PCH_PHUB_ROM_START_ADDR_EG20T 0x14 /* ROM data area start address offset
> +					      (Intel EG20T PCH)*/
> +#define PCH_PHUB_ROM_START_ADDR_ML7213 0x400 /* ROM data area start address
> +						offset(OKI SEMICONDUCTOR ML7213)
> +					      */
>  
>  /* MAX number of INT_REDUCE_CONTROL registers */
>  #define MAX_NUM_INT_REDUCE_CONTROL_REG 128
> @@ -42,6 +47,10 @@
>  #define CLKCFG_CAN_50MHZ 0x12000000
>  #define CLKCFG_CANCLK_MASK 0xFF000000
>  
> +/* Macros for ML7213 */
> +#define PCI_VENDOR_ID_ROHM			0x10db
> +#define PCI_DEVICE_ID_ROHM_ML7213_PHUB		0x801A
> +
>  /* SROM ACCESS Macro */
>  #define PCH_WORD_ADDR_MASK (~((1 << 2) - 1))
>  
> @@ -62,6 +71,11 @@
>  
>  #define PCH_PHUB_OROM_SIZE 15360
>  
> +enum pch_phub_type {
> +	PCH_EG20T, /* Intel EG20T PCH */
> +	PCH_ML7213, /* OKI SEMICONDUCTOR ML7213 for IVI */
> +};
> +
>  /**
>   * struct pch_phub_reg - PHUB register structure
>   * @phub_id_reg:			PHUB_ID register val
> @@ -96,6 +110,7 @@ struct pch_phub_reg {
>  	u32 clkcfg_reg;
>  	void __iomem *pch_phub_base_address;
>  	void __iomem *pch_phub_extrom_base_address;
> +	int type;

Shouldn't this be enum pch_phub_type instead of an int?

thanks,

greg k-h
