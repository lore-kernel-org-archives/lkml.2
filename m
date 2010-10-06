Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759419Ab0JFQ7z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 12:59:55 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:42261 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757239Ab0JFQ7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 12:59:54 -0400
X-IronPort-AV: E=Sophos;i="4.57,290,1283731200"; 
   d="scan'208";a="2219634"
Date: Wed, 6 Oct 2010 18:00:15 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: "H. Peter Anvin" <hpa@zytor.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, "jeremy@goop.org" <jeremy@goop.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
Subject: Re: [PATCH 4/7] acpi: use indirect call to register gsi in different
 modes
In-Reply-To: <1283167276-7364-4-git-send-email-stefano.stabellini@eu.citrix.com>
Message-ID: <alpine.DEB.2.00.1010061749110.2440@kaball-desktop>
References: <alpine.DEB.2.00.1008301134160.2545@kaball-desktop> <1283167276-7364-4-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,
I sent this patch a while back as part of the "PV on HVM: receive
interrupts as xen events" series (that it is based upon Konrad's
pcifront series, he sent another version to the list yesterday).

Do you think that this is a reasonble approach?

If you want to give a look at the whole series you can find it here:

http://lkml.org/lkml/2010/8/30/170

everything else is Xen specific stuff.

Thanks in advance,

Stefano


On Mon, 30 Aug 2010, stefano.stabellini@eu.citrix.com wrote:
> From: Jeremy Fitzhardinge <jeremy@goop.org>
> 
> Rather than using a tree of conditionals, use function pointer
> for acpi_register_gsi.
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  arch/x86/kernel/acpi/boot.c |   59 ++++++++++++++++++++++++++++++------------
>  1 files changed, 42 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
> index c05872a..031f0c2 100644
> --- a/arch/x86/kernel/acpi/boot.c
> +++ b/arch/x86/kernel/acpi/boot.c
> @@ -513,35 +513,61 @@ int acpi_isa_irq_to_gsi(unsigned isa_irq, u32 *gsi)
>  	return 0;
>  }
>  
> -/*
> - * success: return IRQ number (>=0)
> - * failure: return < 0
> - */
> -int acpi_register_gsi(struct device *dev, u32 gsi, int trigger, int polarity)
> +static int acpi_register_gsi_pic(struct device *dev, u32 gsi,
> +				 int trigger, int polarity)
>  {
> -	unsigned int irq;
> -	unsigned int plat_gsi = gsi;
> -
>  #ifdef CONFIG_PCI
>  	/*
>  	 * Make sure all (legacy) PCI IRQs are set as level-triggered.
>  	 */
> -	if (acpi_irq_model == ACPI_IRQ_MODEL_PIC) {
> -		if (trigger == ACPI_LEVEL_SENSITIVE)
> -			eisa_set_level_irq(gsi);
> -	}
> +	if (trigger == ACPI_LEVEL_SENSITIVE)
> +		eisa_set_level_irq(gsi);
>  #endif
>  
> +	return gsi;
> +}
> +
> +static int acpi_register_gsi_ioapic(struct device *dev, u32 gsi,
> +				    int trigger, int polarity)
> +{
>  #ifdef CONFIG_X86_IO_APIC
> -	if (acpi_irq_model == ACPI_IRQ_MODEL_IOAPIC) {
> -		plat_gsi = mp_register_gsi(dev, gsi, trigger, polarity);
> -	}
> +	gsi = mp_register_gsi(dev, gsi, trigger, polarity);
>  #endif
> +
> +	return gsi;
> +}
> +
> +static int (*__acpi_register_gsi)(struct device *dev, u32 gsi, int trigger, int polarity) = acpi_register_gsi_pic;
> +
> +/*
> + * success: return IRQ number (>=0)
> + * failure: return < 0
> + */
> +int acpi_register_gsi(struct device *dev, u32 gsi, int trigger, int polarity)
> +{
> +	unsigned int irq;
> +	unsigned int plat_gsi = gsi;
> +
> +	plat_gsi = (*__acpi_register_gsi)(dev, gsi, trigger, polarity);
>  	irq = gsi_to_irq(plat_gsi);
>  
>  	return irq;
>  }
>  
> +void __init acpi_set_irq_model_pic(void)
> +{
> +	acpi_irq_model = ACPI_IRQ_MODEL_PIC;
> +	__acpi_register_gsi = acpi_register_gsi_pic;
> +	acpi_ioapic = 0;
> +}
> +
> +void __init acpi_set_irq_model_ioapic(void)
> +{
> +	acpi_irq_model = ACPI_IRQ_MODEL_IOAPIC;
> +	__acpi_register_gsi = acpi_register_gsi_ioapic;
> +	acpi_ioapic = 1;
> +}
> +
>  /*
>   *  ACPI based hotplug support for CPU
>   */
> @@ -1259,8 +1285,7 @@ static void __init acpi_process_madt(void)
>  			 */
>  			error = acpi_parse_madt_ioapic_entries();
>  			if (!error) {
> -				acpi_irq_model = ACPI_IRQ_MODEL_IOAPIC;
> -				acpi_ioapic = 1;
> +				acpi_set_irq_model_ioapic();
>  
>  				smp_found_config = 1;
>  			}
> -- 
> 1.5.6.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
