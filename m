Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322Ab2CESEP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 13:04:15 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:46273 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757256Ab2CESEA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 13:04:00 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of bhelgaas@google.com designates 10.152.124.77 as permitted sender) smtp.mail=bhelgaas@google.com; dkim=pass header.i=bhelgaas@google.com
MIME-Version: 1.0
In-Reply-To: <4f548ed1.4o6PhHmCeKTSPZXU%tadeusz.struk@intel.com>
References: <4f548ed1.4o6PhHmCeKTSPZXU%tadeusz.struk@intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 5 Mar 2012 11:03:38 -0700
Message-ID: <CAErSpo4yiMrBcBPSV5MLKYsLQwhBA4L-fOHr4ocHDO9NwBpG7Q@mail.gmail.com>
Subject: Re: [PATCH 1/1 v3] PCI: Device specific reset function
To: Tadeusz Struk <tadeusz.struk@intel.com>
Cc: jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 5, 2012 at 3:00 AM, Tadeusz Struk <tadeusz.struk@intel.com> wrote:
>
> ---
>  drivers/pci/pci.h    |    1 +
>  drivers/pci/quirks.c |   33 +++++++++++++++++++++++++++------
>  include/linux/pci.h  |    1 +
>  3 files changed, 29 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
> index 1009a5e..4d10479 100644
> --- a/drivers/pci/pci.h
> +++ b/drivers/pci/pci.h
> @@ -315,6 +315,7 @@ struct pci_dev_reset_methods {
>        u16 vendor;
>        u16 device;
>        int (*reset)(struct pci_dev *dev, int probe);
> +       struct list_head list;
>  };
>
>  #ifdef CONFIG_PCI_QUIRKS
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 6476547..f423d2f 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -3070,26 +3070,47 @@ static int reset_intel_82599_sfp_virtfn(struct pci_dev *dev, int probe)
>  }
>
>  #define PCI_DEVICE_ID_INTEL_82599_SFP_VF   0x10ed
> -
> -static const struct pci_dev_reset_methods pci_dev_reset_methods[] = {
> +static struct pci_dev_reset_methods pci_dev_reset_methods[] = {
>        { PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82599_SFP_VF,
> -                reset_intel_82599_sfp_virtfn },
> +               reset_intel_82599_sfp_virtfn },
>        { PCI_VENDOR_ID_INTEL, PCI_ANY_ID,
>                reset_intel_generic_dev },
> -       { 0 }
>  };
>
> +static LIST_HEAD(reset_list);
> +
> +void pci_dev_specific_reset_add(struct pci_dev_reset_methods *reset_method)
> +{
> +       INIT_LIST_HEAD(&reset_method->list);
> +       list_add(&reset_method->list, &reset_list);
> +}
> +
> +static int __init pci_dev_specific_reset_init(void)
> +{
> +       int i;
> +
> +       for (i = 0; i < ARRAY_SIZE(pci_dev_reset_methods); i++) {
> +               pci_dev_specific_reset_add(&pci_dev_reset_methods[i]);
> +       }
> +       return 0;
> +}
> +
> +late_initcall(pci_dev_specific_reset_init);
> +
>  int pci_dev_specific_reset(struct pci_dev *dev, int probe)
>  {
>        const struct pci_dev_reset_methods *i;
> +       struct pci_driver *drv = dev->driver;
> +
> +       if (drv && drv->reset)
> +               return drv->reset(dev, probe);
>
> -       for (i = pci_dev_reset_methods; i->reset; i++) {
> +       list_for_each_entry(i, &reset_list, list) {
>                if ((i->vendor == dev->vendor ||
>                     i->vendor == (u16)PCI_ANY_ID) &&
>                    (i->device == dev->device ||
>                     i->device == (u16)PCI_ANY_ID))
>                        return i->reset(dev, probe);
>        }
> -
>        return -ENOTTY;
>  }
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index a16b1df..a3a0bc5 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -560,6 +560,7 @@ struct pci_driver {
>        int  (*resume_early) (struct pci_dev *dev);
>        int  (*resume) (struct pci_dev *dev);                   /* Device woken up */
>        void (*shutdown) (struct pci_dev *dev);
> +       int  (*reset) (struct pci_dev *dev, int probe); /* Device specific reset */
>        struct pci_error_handlers *err_handler;
>        struct device_driver    driver;
>        struct pci_dynids dynids;

This patch now consists of two pieces:
  1) Convert the reset method table to a list, and
  2) Add the "reset" function pointer in struct pci_driver and the "if
(drv && drv->reset)" block.

These should be split into two patches.

After you split them, I don't think you even need part 1, so you
should probably just drop it.

Common practice would be to also include your driver patch that
actually uses the pci_driver.reset pointer as an additional patch in
the same series.  That gives us more confidence that this solution
actually works and will be used.

Bjorn
