Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162Ab0JNVdb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 17:33:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47076 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932081Ab0JNVda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 17:33:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: stefano.stabellini@eu.citrix.com
Subject: Re: [PATCH v4 4/7] acpi: use indirect call to register gsi in different modes
Date: Thu, 14 Oct 2010 23:32:35 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc7-rjw+; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        jeremy@goop.org, konrad.wilk@oracle.com,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
References: <alpine.DEB.2.00.1010121121160.2423@kaball-desktop> <1286901289-8156-4-git-send-email-stefano.stabellini@eu.citrix.com>
In-Reply-To: <1286901289-8156-4-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201010142332.35224.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 12, 2010, stefano.stabellini@eu.citrix.com wrote:
> From: Jeremy Fitzhardinge <jeremy@goop.org>
> 
> Rather than using a tree of conditionals, use function pointer
> for acpi_register_gsi.
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Looks good to me.

Thanks,
Rafael


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
> 

