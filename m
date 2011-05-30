Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105Ab1E3Hqd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 03:46:33 -0400
Received: from cantor.suse.de ([195.135.220.2]:42095 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756014Ab1E3Hqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 03:46:31 -0400
Date: Mon, 30 May 2011 15:47:22 +0800
From: Greg KH <gregkh@suse.de>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com,
        toshiharu-linux@dsn.okisemi.com
Subject: Re: [PATCH] 8250_pci: add -ENODEV code for Intel EG20T PCH
Message-ID: <20110530074722.GA7947@suse.de>
References: <1306741324-4562-1-git-send-email-tomoya-linux@dsn.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306741324-4562-1-git-send-email-tomoya-linux@dsn.okisemi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 04:42:04PM +0900, Tomoya MORINAGA wrote:
> Intel EG20T PCH has UART device which is compatible with 8250.
> Currently, with general configuration, the PCH UART driver is not loaded but 8250 standard driver is loaded.
> Therefore, in case of using PCH UART driver, need to disable 8250 pci function.
> However, this procedure is not best solution.
> 
> This patch, in 8250_pci, if the device is the PCH or the family IOH,
> '-ENODEV' is returned.
> As a result, disabling 8250-pci processing becomes unnecessary.
> 
> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
> ---
>  drivers/tty/serial/8250_pci.c |   13 +++++++++++++
>  1 files changed, 13 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/tty/serial/8250_pci.c b/drivers/tty/serial/8250_pci.c
> index 738cec9..2678d9d 100644
> --- a/drivers/tty/serial/8250_pci.c
> +++ b/drivers/tty/serial/8250_pci.c
> @@ -2559,6 +2559,19 @@ pciserial_init_one(struct pci_dev *dev, const struct pci_device_id *ent)
>  		return -EINVAL;
>  	}
>  
> +#if defined(CONFIG_SERIAL_PCH_UART) || defined(CONFIG_SERIAL_PCH_UART_MODULE)
> +	if ((dev->vendor == PCI_VENDOR_ID_INTEL && dev->device == 0x8811) ||
> +	   (dev->vendor == PCI_VENDOR_ID_INTEL && dev->device == 0x8812) ||
> +	   (dev->vendor == PCI_VENDOR_ID_INTEL && dev->device == 0x8813) ||
> +	   (dev->vendor == PCI_VENDOR_ID_INTEL && dev->device == 0x8814) ||
> +	   (dev->vendor == 0x10DB && dev->device == 0x8027) ||
> +	   (dev->vendor == 0x10DB && dev->device == 0x8028) ||
> +	   (dev->vendor == 0x10DB && dev->device == 0x8029) ||
> +	   (dev->vendor == 0x10DB && dev->device == 0x800C) ||
> +	   (dev->vendor == 0x10DB && dev->device == 0x800D))
> +		return -ENODEV;
> +#endif

Why put this with an #if around it?  Why not just always not bind to
this driver as we have a "correct" driver for the hardware now?

thanks,

greg k-h
