Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488Ab2HVTzV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 15:55:21 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:53015 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752184Ab2HVTzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 15:55:14 -0400
Date: Wed, 22 Aug 2012 21:55:12 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Len Brown <len.brown@intel.com>, Feng Tang <feng.tang@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaron Sierra <asierra@xes-inc.com>, Bob Moore <robert.moore@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH] lpc_ich: Fix a 3.5 kernel regression for iTCO_wdt driver
Message-ID: <20120822195512.GI27604@spo001.leaseweb.com>
References: <1344959772-23018-1-git-send-email-feng.tang@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344959772-23018-1-git-send-email-feng.tang@intel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

Cc-ing Samuel and Guenter also.

> There are many reports (including 2 of my machines) that iTCO_wdt watchdog
> driver fails to be initialized in 3.5 kernel with error message like:
> 
> [    5.265175] ACPI Warning: 0x00001060-0x0000107f SystemIO conflicts with Region \_SB_.PCI0.LPCB.TCOI 1 (20120320/utaddress-251)
> [    5.265192] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
> [    5.265206] lpc_ich: Resource conflict(s) found affecting iTCO_wdt
> 
> The root cause the iTCO_wdt driver in 3.4 probes the HW IO resource from
> LPC's PCI config space, while in 3.5 kernel it relies on lpc_ich driver
> for the probe, which adds a new acpi_check_resource_conflict() check, and
> give up the probe if there is any conflict with ACPI.
> 
> Fix it by removing all the checks for iTCO_wdt to keep the same behavior as
> 3.4 kernel.
> https://bugzilla.kernel.org/show_bug.cgi?id=44991
> 
> Actually the same check could be removed for the gpio-ich in lpc_ich.c,
> but I'm not sure if it will cause problems.
> 
> Signed-off-by: Feng Tang <feng.tang@intel.com>
> Cc: Aaron Sierra <asierra@xes-inc.com>
> Cc: Wim Van Sebroeck <wim@iguana.be>
> Cc: Len Brown <len.brown@intel.com>
> Cc: Bob Moore <robert.moore@intel.com>
> ---
>  drivers/mfd/lpc_ich.c |   20 +-------------------
>  1 files changed, 1 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/mfd/lpc_ich.c b/drivers/mfd/lpc_ich.c
> index 027cc8f..a05fdfc 100644
> --- a/drivers/mfd/lpc_ich.c
> +++ b/drivers/mfd/lpc_ich.c
> @@ -765,7 +765,6 @@ static int __devinit lpc_ich_init_wdt(struct pci_dev *dev,
>  	u32 base_addr_cfg;
>  	u32 base_addr;
>  	int ret;
> -	bool acpi_conflict = false;
>  	struct resource *res;
>  
>  	/* Setup power management base register */
> @@ -780,20 +779,11 @@ static int __devinit lpc_ich_init_wdt(struct pci_dev *dev,
>  	res = wdt_io_res(ICH_RES_IO_TCO);
>  	res->start = base_addr + ACPIBASE_TCO_OFF;
>  	res->end = base_addr + ACPIBASE_TCO_END;
> -	ret = acpi_check_resource_conflict(res);
> -	if (ret) {
> -		acpi_conflict = true;
> -		goto wdt_done;
> -	}
>  
>  	res = wdt_io_res(ICH_RES_IO_SMI);
>  	res->start = base_addr + ACPIBASE_SMI_OFF;
>  	res->end = base_addr + ACPIBASE_SMI_END;
> -	ret = acpi_check_resource_conflict(res);
> -	if (ret) {
> -		acpi_conflict = true;
> -		goto wdt_done;
> -	}
> +
>  	lpc_ich_enable_acpi_space(dev);
>  
>  	/*
> @@ -813,11 +803,6 @@ static int __devinit lpc_ich_init_wdt(struct pci_dev *dev,
>  		res = wdt_mem_res(ICH_RES_MEM_GCS);
>  		res->start = base_addr + ACPIBASE_GCS_OFF;
>  		res->end = base_addr + ACPIBASE_GCS_END;
> -		ret = acpi_check_resource_conflict(res);
> -		if (ret) {
> -			acpi_conflict = true;
> -			goto wdt_done;
> -		}
>  	}
>  
>  	lpc_ich_finalize_cell(&lpc_ich_cells[LPC_WDT], id);
> @@ -825,9 +810,6 @@ static int __devinit lpc_ich_init_wdt(struct pci_dev *dev,
>  				1, NULL, 0);
>  
>  wdt_done:
> -	if (acpi_conflict)
> -		pr_warn("Resource conflict(s) found affecting %s\n",
> -				lpc_ich_cells[LPC_WDT].name);
>  	return ret;
>  }
>  

Hi Len,

Any idea why the acpi_check_resource_conflict() check gives a conflict?

Thanks in advance,
Wim.

