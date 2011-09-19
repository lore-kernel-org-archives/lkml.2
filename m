Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab1ISHe5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 03:34:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:56877 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011Ab1ISHe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 03:34:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="49985147"
Date: Mon, 19 Sep 2011 10:35:30 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        kirill.shutemov@linux.intel.com, stable@kernel.org
Subject: Re: [PATCH] x86, mrst: use a temporary variable for SFI irq
Message-ID: <20110919073530.GF23578@intel.com>
References: <1315986983-22398-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315986983-22398-1-git-send-email-mika.westerberg@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping. Any possibility to get this to next -rc?

Thanks.

On Wed, Sep 14, 2011 at 10:56:23AM +0300, Mika Westerberg wrote:
> SFI tables reside in RAM and should not be modified once they are written.
> Current code went to set pentry->irq to zero which causes subsequent reads
> to fail with invalid SFI table checksum.
> 
> To fix this we use temporary variable for irq number.
> 
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: stable@kernel.org
> ---
>  arch/x86/platform/mrst/mrst.c |   22 ++++++++++++----------
>  1 files changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/platform/mrst/mrst.c b/arch/x86/platform/mrst/mrst.c
> index 58425ad..fe73276 100644
> --- a/arch/x86/platform/mrst/mrst.c
> +++ b/arch/x86/platform/mrst/mrst.c
> @@ -678,38 +678,40 @@ static int __init sfi_parse_devs(struct sfi_table_header *table)
>  	pentry = (struct sfi_device_table_entry *)sb->pentry;
>  
>  	for (i = 0; i < num; i++, pentry++) {
> -		if (pentry->irq != (u8)0xff) { /* native RTE case */
> +		int irq = pentry->irq;
> +
> +		if (irq != (u8)0xff) { /* native RTE case */
>  			/* these SPI2 devices are not exposed to system as PCI
>  			 * devices, but they have separate RTE entry in IOAPIC
>  			 * so we have to enable them one by one here
>  			 */
> -			ioapic = mp_find_ioapic(pentry->irq);
> +			ioapic = mp_find_ioapic(irq);
>  			irq_attr.ioapic = ioapic;
> -			irq_attr.ioapic_pin = pentry->irq;
> +			irq_attr.ioapic_pin = irq;
>  			irq_attr.trigger = 1;
>  			irq_attr.polarity = 1;
> -			io_apic_set_pci_routing(NULL, pentry->irq, &irq_attr);
> +			io_apic_set_pci_routing(NULL, irq, &irq_attr);
>  		} else
> -			pentry->irq = 0; /* No irq */
> +			irq = 0; /* No irq */
>  
>  		switch (pentry->type) {
>  		case SFI_DEV_TYPE_IPC:
>  			/* ID as IRQ is a hack that will go away */
> -			pdev = platform_device_alloc(pentry->name, pentry->irq);
> +			pdev = platform_device_alloc(pentry->name, irq);
>  			if (pdev == NULL) {
>  				pr_err("out of memory for SFI platform device '%s'.\n",
>  							pentry->name);
>  				continue;
>  			}
> -			install_irq_resource(pdev, pentry->irq);
> +			install_irq_resource(pdev, irq);
>  			pr_debug("info[%2d]: IPC bus, name = %16.16s, "
> -				"irq = 0x%2x\n", i, pentry->name, pentry->irq);
> +				"irq = 0x%2x\n", i, pentry->name, irq);
>  			sfi_handle_ipc_dev(pdev);
>  			break;
>  		case SFI_DEV_TYPE_SPI:
>  			memset(&spi_info, 0, sizeof(spi_info));
>  			strncpy(spi_info.modalias, pentry->name, SFI_NAME_LEN);
> -			spi_info.irq = pentry->irq;
> +			spi_info.irq = irq;
>  			spi_info.bus_num = pentry->host_num;
>  			spi_info.chip_select = pentry->addr;
>  			spi_info.max_speed_hz = pentry->max_freq;
> @@ -726,7 +728,7 @@ static int __init sfi_parse_devs(struct sfi_table_header *table)
>  			memset(&i2c_info, 0, sizeof(i2c_info));
>  			bus = pentry->host_num;
>  			strncpy(i2c_info.type, pentry->name, SFI_NAME_LEN);
> -			i2c_info.irq = pentry->irq;
> +			i2c_info.irq = irq;
>  			i2c_info.addr = pentry->addr;
>  			pr_debug("info[%2d]: I2C bus = %d, name = %16.16s, "
>  				"irq = 0x%2x, addr = 0x%x\n", i, bus,
> -- 
> 1.7.5.4
