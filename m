Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759094Ab2AGAF2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 19:05:28 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:58638 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752940Ab2AGAF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 19:05:26 -0500
Message-ID: <1325894723.12292.13.camel@joe2Laptop>
Subject: Re: [PATCH 4/6] x86: initial support for sta2x11
From: Joe Perches <joe@perches.com>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 06 Jan 2012 16:05:23 -0800
In-Reply-To: <1446410617.668.1325893939253.JavaMail.mail@webmail05>
References: <3bffc0889fba822f58b5f8607fa5247c6f50649c.1325852059.git.rubini@gnudd.com>
	 <1446410617.668.1325893939253.JavaMail.mail@webmail05>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-01-06 at 13:33 +0100, Alessandro Rubini wrote:
> The "ConneXt" sta2x11 I/O Hub is a bridge from PCIe to AMBA, and is
> used as main chipset in some Atom boards.  The set of peripherals it
> exports live in an AMBA bus internal to the chip, so a custom
> remapping of addresses is needed. This is implemented by fixup calls
> for the PCI deivices, based on CONFIG_X86_DEV_DMA_OPS and
> CONFIG_X86_DMA_REMAP .

trivia:

> diff --git a/arch/x86/pci/sta2x11-fixup.c b/arch/x86/pci/sta2x11-fixup.c
[]
> +++ b/arch/x86/pci/sta2x11-fixup.c
> @@ -0,0 +1,403 @@

#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

> +#include <linux/pci.h>
> +#include <linux/export.h>

> +static void sta2x11_new_instance(struct pci_dev *pdev)
> +{
> +	struct sta2x11_instance *instance;
> +
> +	instance = kzalloc(sizeof(*instance), GFP_ATOMIC);
> +	if (!instance)
> +		return;
> +	/* This has a subordindate bridge, with 4 more-subordinate ones */

typo: s/subordindate/subordinate/

> +	instance->bus0 = pdev->subordinate->number + 1;
> +
> +	if (list_empty(&sta2x11_instance_list)) {
> +		int size = STA2X11_SWIOTLB_SIZE;
> +		/* First instance: register your own swiotlb area */
> +		dev_info(&pdev->dev, "sta2x11: Using SWIOTLB (size %i)\n",

It's probably not necessary to prefix with "sta2x11: "

> +			 size);
> +		if (swiotlb_late_init_with_default_size(size))
> +			dev_emerg(&pdev->dev, "%s: init swiotlb(%i) failed\n",
> +				  __func__, size);

or __func__

[]
> +static void set_platform_data(struct pci_dev *pdev)
> +{
> +	void *data = sta2x11_get_platform_data(pdev);
> +	if (data)
> +		printk(KERN_INFO "sta2x11: setting platform data for device "
> +		       "%04x:%04x\n", pdev->vendor, pdev->device);

		pr_info("setting platform data for device %04x:%04x\n",
			pdev->vendor, pdev->device);


> +/* Print STA2X11 version, for diagnostic information */
> +static void sta2x11_print_version(struct pci_dev *pdev)
> +{
> +	uint32_t v[2]; /* used as a string... */

less than pretty.

> +	void __iomem *base;
> +
> +	base = ioremap(pci_resource_start(pdev, 1), pci_resource_len(pdev, 1));
> +	if (!base) {
> +		dev_err(&pdev->dev, " Can't ioreamp BAR 1\n");
> +		return;
> +	}
> +	v[0] = readl(base + 0x7fec); /* STA2X11_ROM_VERSION_OFFSET */
> +	v[1] = 0;
> +	printk("STA2X11: detected version %s (%s)\n", (char *)v,
> +	       v[0] == 0x30303276 ? "good" : "UNSUPPORTED");
(yeah, it's x86, but...)
and
	pr_info("detected version %s (%s)\n", etc.


