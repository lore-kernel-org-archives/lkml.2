Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab0EPWIr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 18:08:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58123 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751962Ab0EPWIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 18:08:45 -0400
Message-ID: <4BF06CB4.5000909@zytor.com>
Date: Sun, 16 May 2010 15:07:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Florian Fainelli <florian@openwrt.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, mingo@elte.hu,
       linux-kernel <linux-kernel@vger.kernel.org>, andi@firstfloor.org
Subject: Re: [PATCH] x86: CPU detection for RDC System-on-Chip
References: <201005161455.34100.florian@openwrt.org> <20100516141917.0d2e69e2@lxorguk.ukuu.org.uk> <201005161521.47097.florian@openwrt.org>
In-Reply-To: <201005161521.47097.florian@openwrt.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2010 06:21 AM, Florian Fainelli wrote:
>  
> diff --git a/arch/x86/kernel/cpu/rdc.c b/arch/x86/kernel/cpu/rdc.c
> new file mode 100644
> index 0000000..909c2b5
> --- /dev/null
> +++ b/arch/x86/kernel/cpu/rdc.c
> @@ -0,0 +1,71 @@
> +/*
> + * See Documentation/x86/rdc.txt
> + *
> + * mark@bifferos.com
> + */
> +
> +#include <linux/pci.h>
> +#include <asm/pci-direct.h>
> +#include "cpu.h"
> +
> +
> +static void __cpuinit rdc_identify(struct cpuinfo_x86 *c)
> +{
> +	u16 vendor, device;
> +	u32 customer_id;
> +
> +	if (!early_pci_allowed())
> +		return;
> +
> +	/* RDC CPU is SoC (system-on-chip), Northbridge is always present */
> +	vendor = read_pci_config_16(0, 0, 0, PCI_VENDOR_ID);
> +	device = read_pci_config_16(0, 0, 0, PCI_DEVICE_ID);
> +
> +	if (vendor != PCI_VENDOR_ID_RDC || device != PCI_DEVICE_ID_RDC_R6020)
> +		return;  /* not RDC */
> +	/*
> +	 * NB: We could go on and check other devices, e.g. r6040 NIC, but
> +	 * that's probably overkill
> +	 */
> +
> +	customer_id = read_pci_config(0, 0, 0, 0x90);
> +
> +	switch (customer_id) {
> +		/* id names are from RDC */
> +	case 0x00321000:
> +		strcpy(c->x86_model_id, "R3210/R3211");
> +		break;
> +	case 0x00321001:
> +		strcpy(c->x86_model_id, "AMITRISC20000/20010");
> +		break;
> +	case 0x00321002:
> +		strcpy(c->x86_model_id, "R3210X/Edimax");
> +		break;
> +	case 0x00321003:
> +		strcpy(c->x86_model_id, "R3210/Kcodes");
> +		break;
> +	case 0x00321004:  /* tested */
> +		strcpy(c->x86_model_id, "S3282/CodeTek");
> +		break;
> +	case 0x00321007:
> +		strcpy(c->x86_model_id, "R8610");
> +		break;
> +	default:
> +		pr_info("RDC CPU: Unrecognised Customer ID (0x%x) please "
> +			"report to: linux-kernel@vger.kernel.org\n",
> +			customer_id);
> +		break;

This pr_info() is completely useless... reporting things to LKML is very
likely to get lost in the din.  If someone (like yourself) wants to be
the maintainer for it that's one thing, otherwise it's probably better
to tell them to file a bugzilla... or just report it as "unknown" like
we do for all other CPU vendors.

> +	}
> +
> +	strcpy(c->x86_vendor_id, "RDC");
> +	c->x86_vendor = X86_VENDOR_RDC;
> +}
> +
> +static const struct cpu_dev __cpuinitconst rdc_cpu_dev = {
> +	.c_vendor	= "RDC",
> +	.c_ident	= { "RDC" },
> +	.c_identify	= rdc_identify,
> +	.c_x86_vendor	= X86_VENDOR_RDC,
> +};
> +
> +cpu_dev_register(rdc_cpu_dev);

.c_ident here is bogus: c_ident is supposed to represent the CPUID
string, but this device apparently doesn't have CPUID.

This adds at least one PCI reference to every boot on every device.  As
such, at least please read vendor and device as a single 32-bit
reference.  Since this identification isn't actually used for any real
purpose (like workarounds) we could also set it up as a PCI quirk... but
it's probably better to just keep the same code flow.

	-hpa



-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

