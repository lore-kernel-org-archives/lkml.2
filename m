Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317Ab1E3OvI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 10:51:08 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:35913 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753658Ab1E3OvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 10:51:05 -0400
X-Sasl-enc: 8vphcRwivEluDOeabwGQKsxbGJ5TuIQnH0UvhQSxo6vr 1306767064
Date: Mon, 30 May 2011 22:50:02 +0800
From: Greg KH <greg@kroah.com>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: Alan Cox <alan@linux.intel.com>, gregkh@suse.de,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com
Subject: Re: [PATCH v2] 8250_pci: add -ENODEV code for Intel EG20T PCH
Message-ID: <20110530145002.GC2689@kroah.com>
References: <1306754776-8077-1-git-send-email-tomoya-linux@dsn.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306754776-8077-1-git-send-email-tomoya-linux@dsn.okisemi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 08:26:16PM +0900, Tomoya MORINAGA wrote:
> Intel EG20T PCH has UART device which is compatible with 8250.
> Currently, with general configuration, the PCH UART driver is not loaded but
> 8250 standard driver is loaded.
> Therefore, in case of using PCH UART driver, need to disable 8250 pci function.
> However, this procedure is not best solution.
> 
> This patch, in 8250_pci, if the device is the PCH or the family IOH,
> '-ENODEV' is returned.
> As a result, disabling 8250-pci processing becomes unnecessary.
> 
> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
> ---
> V2: Delete #ifdef CONFIG_SERIAL_PCH_UART ~ #endif
>     Use quirk table structure
> ---
>  drivers/tty/serial/8250_pci.c |   54 +++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 54 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/tty/serial/8250_pci.c b/drivers/tty/serial/8250_pci.c
> index 738cec9..39c0d62 100644
> --- a/drivers/tty/serial/8250_pci.c
> +++ b/drivers/tty/serial/8250_pci.c
> @@ -2541,6 +2541,53 @@ void pciserial_resume_ports(struct serial_private *priv)
>  }
>  EXPORT_SYMBOL_GPL(pciserial_resume_ports);
>  
> +static struct pci_serial_quirk eg20t_pch_uart[] __refdata = {
> +	{
> +		.vendor         = PCI_VENDOR_ID_INTEL,
> +		.device         = 0x8811,
> +	},

<snip>

No, you can do this easier with your own init() function that just
returns -ENODEV so the driver doesn't bind to it.

try that, it will get rid of this type of code:

> +	for (i = 0; eg20t_pch_uart[i].vendor != PCI_ANY_ID; i++) {
> +		if (dev->vendor == eg20t_pch_uart[i].vendor &&
> +		    dev->device == eg20t_pch_uart[i].device)
> +			return -ENODEV;
> +	}
> +

Which shouldn't be needed and it should make the patch smaller.

thanks,

greg k-h
