Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316Ab2ENGhL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 02:37:11 -0400
Received: from webbox1416.server-home.net ([77.236.96.61]:48476 "EHLO
	webbox1416.server-home.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753659Ab2ENGhJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 02:37:09 -0400
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: =?ISO-8859-1?Q?Jean=2DFran=E7ois?= Dagenais 
	<jeff.dagenais@gmail.com>
Cc: sameo@linux.intel.com, denis@compulab.co.il, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: lpc_sch - tolerate f/w disabled WDT
Date: Mon, 14 May 2012 08:37:06 +0200
Message-ID: <267400469.LKDqnsFUgu@ws-stein>
User-Agent: KMail/4.8.0 (Linux/3.2.12-gentoo; KDE/4.8.1; x86_64; ; )
In-Reply-To: <1336763722-11535-1-git-send-email-jeff.dagenais@gmail.com>
References: <1336763722-11535-1-git-send-email-jeff.dagenais@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 May 2012 15:15:22, Jean-François Dagenais wrote:
> (Observed while running on Kontron nano-TT module.)
> 
> Certain BIOS/boot firmware may disable the tunnelcreek watchdog. Perhaps
> because the mainboard or module provides it's own watchdog mechanism. In these
> cases, lpc_sch should just go on and still provide the rest of the cells
> it declares (GPIO and SMBus). The same logic could be applied to the other
> resources, but I'll leave it to others to decide that.
> 
> This change makes the probe function tolerate the I/O range being disabled,
> but not if the base address inside the register is not configured.
> 
> Cc: Alexander Stein <alexander.stein@systec-electronic.com>
> Cc: Denis Turischev <denis@compulab.co.il>
> Signed-off-by: Jean-François Dagenais <jeff.dagenais@gmail.com>
> ---
>  drivers/mfd/lpc_sch.c |   39 ++++++++++++++++++++-------------------
>  1 files changed, 20 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/mfd/lpc_sch.c b/drivers/mfd/lpc_sch.c
> index ea1169b..6621cd3 100644
> --- a/drivers/mfd/lpc_sch.c
> +++ b/drivers/mfd/lpc_sch.c
> @@ -127,26 +127,27 @@ static int __devinit lpc_sch_probe(struct pci_dev *dev,
>  
>  	if (id->device == PCI_DEVICE_ID_INTEL_ITC_LPC) {
>  		pci_read_config_dword(dev, WDTBASE, &base_addr_cfg);
> -		if (!(base_addr_cfg & (1 << 31))) {
> -			dev_err(&dev->dev, "Decode of the WDT I/O range disabled\n");
> -			ret = -ENODEV;
> -			goto out_dev;
> +		if (base_addr_cfg & (1 << 31)) {
> +			base_addr = (unsigned short)base_addr_cfg;
> +			if (base_addr == 0) {
> +				dev_err(&dev->dev,
> +					"I/O space for WDT uninitialized\n");
> +				ret = -ENODEV;
> +				goto out_dev;
> +			}
> +
> +			wdt_sch_resource.start = base_addr;
> +			wdt_sch_resource.end = base_addr + WDT_IO_SIZE - 1;
> +
> +			for (i = 0; i < ARRAY_SIZE(tunnelcreek_cells); i++)
> +				tunnelcreek_cells[i].id = id->device;
> +
> +			ret = mfd_add_devices(&dev->dev, 0, tunnelcreek_cells,
> +				ARRAY_SIZE(tunnelcreek_cells), NULL, 0);
> +		} else {
> +			dev_warn(&dev->dev, "Decode of the WDT I/O range disabled, tunnelcreek watchdog timer maybe disabled by firmware or BIOS");
> +			return 0;

Are you sure this is return is correct? I think as long as the watchdog is the last device in this probe it should be fine.
But not if any other device is added below later.

>  		}
> -		base_addr = (unsigned short)base_addr_cfg;
> -		if (base_addr == 0) {
> -			dev_err(&dev->dev, "I/O space for WDT uninitialized\n");
> -			ret = -ENODEV;
> -			goto out_dev;
> -		}
> -
> -		wdt_sch_resource.start = base_addr;
> -		wdt_sch_resource.end = base_addr + WDT_IO_SIZE - 1;
> -
> -		for (i = 0; i < ARRAY_SIZE(tunnelcreek_cells); i++)
> -			tunnelcreek_cells[i].id = id->device;
> -
> -		ret = mfd_add_devices(&dev->dev, 0, tunnelcreek_cells,
> -			ARRAY_SIZE(tunnelcreek_cells), NULL, 0);
>  	}
>  
>  	return ret;
> 

Despite that:
Acked-By: Alexander Stein <alexander.stein@systec-electronic.com>

Regards,
Alexander
-- 
Dipl.-Inf. Alexander Stein

SYS TEC electronic GmbH
August-Bebel-Str. 29
D-07973 Greiz

Tel: +49-3661-6279-0, Fax: +49-3661-6279-99
eMail:    Alexander.Stein@systec-electronic.com
Internet: http://www.systec-electronic.com

Managing Director: Dipl.-Phys. Siegmar Schmidt
Commercial registry: Amtsgericht Jena, HRB 205563
