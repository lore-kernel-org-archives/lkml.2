Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761242Ab2CPMlK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 08:41:10 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47266 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490Ab2CPMlI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 08:41:08 -0400
MIME-Version: 1.0
In-Reply-To: <1331539663-29641-1-git-send-email-mla@apm.com>
References: <1331539663-29641-1-git-send-email-mla@apm.com>
Date: Fri, 16 Mar 2012 08:41:07 -0400
Message-ID: <CA+5PVA7K66kKwKHUsNRjw9GLjvKBWgovmKPR4uOMMNFtiWfrzw@mail.gmail.com>
Subject: Re: [PATCH 1/2] [v3] powerpc/44x: Fix PCI MSI support for Maui
 APM821xx SoC and Bluestone board
From: Josh Boyer <jwboyer@gmail.com>
To: Mai La <mla@apm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Josh Boyer <jwboyer@linux.vnet.ibm.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Tirumala R Marri <tmarri@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Michael Neuling <mikey@neuling.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Anton Blanchard <anton@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, open-source-review@apm.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 4:07 AM, Mai La <mla@apm.com> wrote:
> diff --git a/arch/powerpc/sysdev/ppc4xx_msi.c b/arch/powerpc/sysdev/ppc4xx_msi.c
> index 1c2d7af..63989d0 100644
> --- a/arch/powerpc/sysdev/ppc4xx_msi.c
> +++ b/arch/powerpc/sysdev/ppc4xx_msi.c
> @@ -28,10 +28,11 @@
>  #include <linux/of_platform.h>
>  #include <linux/interrupt.h>
>  #include <linux/export.h>
> +#include <linux/kernel.h>
>  #include <asm/prom.h>
>  #include <asm/hw_irq.h>
>  #include <asm/ppc-pci.h>
> -#include <boot/dcr.h>
> +#include <asm/dcr.h>
>  #include <asm/dcr-regs.h>
>  #include <asm/msi_bitmap.h>
>
> @@ -43,13 +44,14 @@
>  #define PEIH_FLUSH0    0x30
>  #define PEIH_FLUSH1    0x38
>  #define PEIH_CNTRST    0x48
> -#define NR_MSI_IRQS    4
> +
> +int msi_irqs;

This should be static.

>  struct ppc4xx_msi {
>        u32 msi_addr_lo;
>        u32 msi_addr_hi;
>        void __iomem *msi_regs;
> -       int msi_virqs[NR_MSI_IRQS];
> +       int *msi_virqs;
>        struct msi_bitmap bitmap;
>        struct device_node *msi_dev;
>  };
> @@ -61,7 +63,7 @@ static int ppc4xx_msi_init_allocator(struct platform_device *dev,
>  {
>        int err;
>
> -       err = msi_bitmap_alloc(&msi_data->bitmap, NR_MSI_IRQS,
> +       err = msi_bitmap_alloc(&msi_data->bitmap, msi_irqs,
>                              dev->dev.of_node);
>        if (err)
>                return err;
> @@ -83,6 +85,9 @@ static int ppc4xx_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
>        struct msi_desc *entry;
>        struct ppc4xx_msi *msi_data = &ppc4xx_msi;
>
> +       msi_data->msi_virqs = kmalloc((msi_irqs) * sizeof(int),
> +                                           GFP_KERNEL);
> +

What happens if this allocation fails?  Unlikely perhaps, but we should still
probably try and handle the error.

>        list_for_each_entry(entry, &dev->msi_list, list) {
>                int_no = msi_bitmap_alloc_hwirqs(&msi_data->bitmap, 1);
>                if (int_no >= 0)

<snip>

> @@ -234,6 +241,10 @@ static int __devinit ppc4xx_msi_probe(struct platform_device *dev)
>                goto error_out;
>        }
>
> +       msi_irqs = of_irq_count(dev->dev.of_node);
> +       if (!msi_irqs)
> +               return -1;
> +

Maybe return -ENODEV here instead of -1?  It probably doesn't matter at the
moment, but if anything actually checked why the probe function failed, that
would be more descriptive.

josh
