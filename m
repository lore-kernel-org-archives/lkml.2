Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741Ab0EQGMZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 02:12:25 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:56342 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068Ab0EQGMX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 02:12:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:reply-to:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=RBBvoSdBfDOREYkKEue8Z4CYY831VzNND5dzQsSYfWd8iI22XidDMK2Z2GxC+RFpJw
         KX371FDzQNW1vcV/hmyixdLfcPSE+BSu0uq1zeCRrv8MK2+f9IB1VcqdZvOkfcV0al3S
         rwCIQBNRYUKvR0BwqllMDnQoylShNO2FHOL5s=
From: Florian Fainelli <florian@openwrt.org>
Reply-To: Florian Fainelli <florian@openwrt.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: CPU detection for RDC System-on-Chip
Date: Mon, 17 May 2010 08:12:11 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.33-2-686; KDE/4.3.4; i686; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, mingo@elte.hu,
       "linux-kernel" <linux-kernel@vger.kernel.org>, andi@firstfloor.org
References: <201005161455.34100.florian@openwrt.org> <201005161521.47097.florian@openwrt.org> <4BF06CB4.5000909@zytor.com>
In-Reply-To: <4BF06CB4.5000909@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201005170812.12776.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Le lundi 17 mai 2010 00:07:48, H. Peter Anvin a écrit :
> On 05/16/2010 06:21 AM, Florian Fainelli wrote:
> > diff --git a/arch/x86/kernel/cpu/rdc.c b/arch/x86/kernel/cpu/rdc.c
> > new file mode 100644
> > index 0000000..909c2b5
> > --- /dev/null
> > +++ b/arch/x86/kernel/cpu/rdc.c
> > @@ -0,0 +1,71 @@
> > +/*
> > + * See Documentation/x86/rdc.txt
> > + *
> > + * mark@bifferos.com
> > + */
> > +
> > +#include <linux/pci.h>
> > +#include <asm/pci-direct.h>
> > +#include "cpu.h"
> > +
> > +
> > +static void __cpuinit rdc_identify(struct cpuinfo_x86 *c)
> > +{
> > +	u16 vendor, device;
> > +	u32 customer_id;
> > +
> > +	if (!early_pci_allowed())
> > +		return;
> > +
> > +	/* RDC CPU is SoC (system-on-chip), Northbridge is always present */
> > +	vendor = read_pci_config_16(0, 0, 0, PCI_VENDOR_ID);
> > +	device = read_pci_config_16(0, 0, 0, PCI_DEVICE_ID);
> > +
> > +	if (vendor != PCI_VENDOR_ID_RDC || device != PCI_DEVICE_ID_RDC_R6020)
> > +		return;  /* not RDC */
> > +	/*
> > +	 * NB: We could go on and check other devices, e.g. r6040 NIC, but
> > +	 * that's probably overkill
> > +	 */
> > +
> > +	customer_id = read_pci_config(0, 0, 0, 0x90);
> > +
> > +	switch (customer_id) {
> > +		/* id names are from RDC */
> > +	case 0x00321000:
> > +		strcpy(c->x86_model_id, "R3210/R3211");
> > +		break;
> > +	case 0x00321001:
> > +		strcpy(c->x86_model_id, "AMITRISC20000/20010");
> > +		break;
> > +	case 0x00321002:
> > +		strcpy(c->x86_model_id, "R3210X/Edimax");
> > +		break;
> > +	case 0x00321003:
> > +		strcpy(c->x86_model_id, "R3210/Kcodes");
> > +		break;
> > +	case 0x00321004:  /* tested */
> > +		strcpy(c->x86_model_id, "S3282/CodeTek");
> > +		break;
> > +	case 0x00321007:
> > +		strcpy(c->x86_model_id, "R8610");
> > +		break;
> > +	default:
> > +		pr_info("RDC CPU: Unrecognised Customer ID (0x%x) please "
> > +			"report to: linux-kernel@vger.kernel.org\n",
> > +			customer_id);
> > +		break;
> 
> This pr_info() is completely useless... reporting things to LKML is very
> likely to get lost in the din.  If someone (like yourself) wants to be
> the maintainer for it that's one thing, otherwise it's probably better
> to tell them to file a bugzilla... or just report it as "unknown" like
> we do for all other CPU vendors.

Allright, filling a bugzilla entry sounds okay with me.

> 
> > +	}
> > +
> > +	strcpy(c->x86_vendor_id, "RDC");
> > +	c->x86_vendor = X86_VENDOR_RDC;
> > +}
> > +
> > +static const struct cpu_dev __cpuinitconst rdc_cpu_dev = {
> > +	.c_vendor	= "RDC",
> > +	.c_ident	= { "RDC" },
> > +	.c_identify	= rdc_identify,
> > +	.c_x86_vendor	= X86_VENDOR_RDC,
> > +};
> > +
> > +cpu_dev_register(rdc_cpu_dev);
> 
> .c_ident here is bogus: c_ident is supposed to represent the CPUID
> string, but this device apparently doesn't have CPUID.
> 
> This adds at least one PCI reference to every boot on every device.  As
> such, at least please read vendor and device as a single 32-bit
> reference.  Since this identification isn't actually used for any real
> purpose (like workarounds) we could also set it up as a PCI quirk... but
> it's probably better to just keep the same code flow.

More precisely, every device that has X86_RDC321X set in its kernel. I want to
get this merged first before actually using it, but the real purpose is to have 
different board flavors which register platform devices for the various models 
of RDC-based devices. Having this detection logic based on the RDC model is 
imho much cleaner than poking at the first bytes of the NOR flash and check the 
vendor firmware header.

As where to put those board files, this is another topic.
--
Florian
