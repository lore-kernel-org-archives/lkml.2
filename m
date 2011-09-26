Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538Ab1IZU7Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 16:59:24 -0400
Received: from smtp-out.google.com ([216.239.44.51]:28388 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab1IZU7W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 16:59:22 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=LGtZXk4fiyK1N/BSqRifm27FQugvrkFNxq/pas5EnalaawUOr16JADx3PYKQeCCRv
	QPVYHorLSSyOR86EaQ7nw==
MIME-Version: 1.0
In-Reply-To: <1316706551-16138-5-git-send-email-joerg.roedel@amd.com>
References: <1316706551-16138-1-git-send-email-joerg.roedel@amd.com> <1316706551-16138-5-git-send-email-joerg.roedel@amd.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 26 Sep 2011 14:58:58 -0600
Message-ID: <CAErSpo7Vb7avbsP3eG=3huCewW4QBL7oMoXr2TjMCaWEvFgB0Q@mail.gmail.com>
Subject: Re: [PATCH 4/4] PCI: Add support for PASID capability
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 9:49 AM, Joerg Roedel <joerg.roedel@amd.com> wrote:
> Devices supporting the PASID capability can use multiple
> contexts on an IOMMU at the same time. This patch adds
> support to manage that capability.

These all look reasonable to me.

Is there anything else useful you could say in the PASID Kconfig help
text?  I'm guessing it stands for "PCI Address Space ID" or something,
but I have no idea why I might want to enable it.

I didn't coordinate very well with Jesse.  I'm hoping he'll be back
before the 3.2 merge window, but I think we have a few patches queued
up now, and it might be useful to have them in linux-next for a while
before he returns.  I'll look into that.

Bjorn

> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  drivers/pci/Kconfig      |   11 +++++
>  drivers/pci/ats.c        |  113 ++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/pci-ats.h  |   31 +++++++++++++
>  include/linux/pci_regs.h |    8 +++
>  4 files changed, 163 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
> index fb1e9707..ed7c42e 100644
> --- a/drivers/pci/Kconfig
> +++ b/drivers/pci/Kconfig
> @@ -94,6 +94,17 @@ config PCI_PRI
>
>          If unsure, say N.
>
> +config PCI_PASID
> +       bool "PCI PASID support"
> +       depends on PCI
> +       select PCI_ATS
> +       help
> +         Devices supporting PASIDs can access multiple address spaces
> +         on an IOMMU at the same time. This option compiles code for
> +         that capability into the kernel.
> +
> +         If unsure, say N.
> +
>  config PCI_IOAPIC
>        bool
>        depends on PCI
> diff --git a/drivers/pci/ats.c b/drivers/pci/ats.c
> index bf892a0..f727a09 100644
> --- a/drivers/pci/ats.c
> +++ b/drivers/pci/ats.c
> @@ -7,6 +7,7 @@
>  * PCI Express I/O Virtualization (IOV) support.
>  *   Address Translation Service 1.0
>  *   Page Request Interface added by Joerg Roedel <joerg.roedel@amd.com>
> + *   PASID support added by Joerg Roedel <joerg.roedel@amd.com>
>  */
>
>  #include <linux/pci-ats.h>
> @@ -323,3 +324,115 @@ int pci_pri_status(struct pci_dev *pdev)
>  }
>  EXPORT_SYMBOL_GPL(pci_pri_status);
>  #endif /* CONFIG_PCI_PRI */
> +
> +#ifdef CONFIG_PCI_PASID
> +/**
> + * pci_enable_pasid - Enable the PASID capability
> + * @pdev: PCI device structure
> + * @features: Features to enable
> + *
> + * Returns 0 on success, negative value on error. This function checks
> + * whether the features are actually supported by the device and returns
> + * an error if not.
> + */
> +int pci_enable_pasid(struct pci_dev *pdev, int features)
> +{
> +       u16 control, supported;
> +       int pos;
> +
> +       pos = pci_find_ext_capability(pdev, PCI_PASID_CAP);
> +       if (!pos)
> +               return -EINVAL;
> +
> +       pci_read_config_word(pdev, pos + PCI_PASID_CONTROL_OFF, &control);
> +       pci_read_config_word(pdev, pos + PCI_PASID_CAP_OFF,     &supported);
> +
> +       if (!(supported & PCI_PASID_ENABLE))
> +               return -EINVAL;
> +
> +       supported &= PCI_PASID_EXEC | PCI_PASID_PRIV;
> +
> +       /* User wants to enable anything unsupported? */
> +       if ((supported & features) != features)
> +               return -EINVAL;
> +
> +       control = PCI_PASID_ENABLE | features;
> +
> +       pci_write_config_word(pdev, pos + PCI_PASID_CONTROL_OFF, control);
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(pci_enable_pasid);
> +
> +/**
> + * pci_disable_pasid - Disable the PASID capability
> + * @pdev: PCI device structure
> + *
> + */
> +void pci_disable_pasid(struct pci_dev *pdev)
> +{
> +       u16 control = 0;
> +       int pos;
> +
> +       pos = pci_find_ext_capability(pdev, PCI_PASID_CAP);
> +       if (!pos)
> +               return;
> +
> +       pci_write_config_word(pdev, pos + PCI_PASID_CONTROL_OFF, control);
> +}
> +EXPORT_SYMBOL_GPL(pci_disable_pasid);
> +
> +/**
> + * pci_pasid_features - Check which PASID features are supported
> + * @pdev: PCI device structure
> + *
> + * Returns a negative value when no PASI capability is present.
> + * Otherwise is returns a bitmask with supported features. Current
> + * features reported are:
> + * PCI_PASID_ENABLE - PASID capability can be enabled
> + * PCI_PASID_EXEC - Execute permission supported
> + * PCI_PASID_PRIV - Priviledged mode supported
> + */
> +int pci_pasid_features(struct pci_dev *pdev)
> +{
> +       u16 supported;
> +       int pos;
> +
> +       pos = pci_find_ext_capability(pdev, PCI_PASID_CAP);
> +       if (!pos)
> +               return -EINVAL;
> +
> +       pci_read_config_word(pdev, pos + PCI_PASID_CAP_OFF, &supported);
> +
> +       supported &= PCI_PASID_ENABLE | PCI_PASID_EXEC | PCI_PASID_PRIV;
> +
> +       return supported;
> +}
> +EXPORT_SYMBOL_GPL(pci_pasid_features);
> +
> +#define PASID_NUMBER_SHIFT     8
> +#define PASID_NUMBER_MASK      (0x1f << PASID_NUMBER_SHIFT)
> +/**
> + * pci_max_pasid - Get maximum number of PASIDs supported by device
> + * @pdev: PCI device structure
> + *
> + * Returns negative value when PASID capability is not present.
> + * Otherwise it returns the numer of supported PASIDs.
> + */
> +int pci_max_pasids(struct pci_dev *pdev)
> +{
> +       u16 supported;
> +       int pos;
> +
> +       pos = pci_find_ext_capability(pdev, PCI_PASID_CAP);
> +       if (!pos)
> +               return -EINVAL;
> +
> +       pci_read_config_word(pdev, pos + PCI_PASID_CAP_OFF, &supported);
> +
> +       supported = (supported & PASID_NUMBER_MASK) >> PASID_NUMBER_SHIFT;
> +
> +       return (1 << supported);
> +}
> +EXPORT_SYMBOL_GPL(pci_max_pasids);
> +#endif /* CONFIG_PCI_PASID */
> diff --git a/include/linux/pci-ats.h b/include/linux/pci-ats.h
> index 0713952..e3d0b38 100644
> --- a/include/linux/pci-ats.h
> +++ b/include/linux/pci-ats.h
> @@ -93,4 +93,35 @@ static inline int pci_pri_status(struct pci_dev *pdev)
>  }
>  #endif /* CONFIG_PCI_PRI */
>
> +#ifdef CONFIG_PCI_PASID
> +
> +extern int pci_enable_pasid(struct pci_dev *pdev, int features);
> +extern void pci_disable_pasid(struct pci_dev *pdev);
> +extern int pci_pasid_features(struct pci_dev *pdev);
> +extern int pci_max_pasids(struct pci_dev *pdev);
> +
> +#else  /* CONFIG_PCI_PASID */
> +
> +static inline int pci_enable_pasid(struct pci_dev *pdev, int features)
> +{
> +       return -EINVAL;
> +}
> +
> +static inline void pci_disable_pasid(struct pci_dev *pdev)
> +{
> +}
> +
> +static inline int pci_pasid_features(struct pci_dev *pdev)
> +{
> +       return -EINVAL;
> +}
> +
> +static inline int pci_max_pasids(struct pci_dev *pdev)
> +{
> +       return -EINVAL;
> +}
> +
> +#endif /* CONFIG_PCI_PASID */
> +
> +
>  #endif /* LINUX_PCI_ATS_H*/
> diff --git a/include/linux/pci_regs.h b/include/linux/pci_regs.h
> index 7fc32af..b5d9657 100644
> --- a/include/linux/pci_regs.h
> +++ b/include/linux/pci_regs.h
> @@ -675,6 +675,14 @@
>  #define PCI_PRI_MAX_REQ_OFF    0x08    /* Cap offset for max reqs supported */
>  #define PCI_PRI_ALLOC_REQ_OFF  0x0c    /* Cap offset for max reqs allowed */
>
> +/* PASID capability */
> +#define PCI_PASID_CAP          0x1b    /* PASID capability ID */
> +#define PCI_PASID_CAP_OFF      0x04    /* PASID feature register */
> +#define PCI_PASID_CONTROL_OFF   0x06    /* PASID control register */
> +#define PCI_PASID_ENABLE       0x01    /* Enable/Supported bit */
> +#define PCI_PASID_EXEC         0x02    /* Exec permissions Enable/Supported */
> +#define PCI_PASID_PRIV         0x04    /* Priviledge Mode Enable/Support */
> +
>  /* Single Root I/O Virtualization */
>  #define PCI_SRIOV_CAP          0x04    /* SR-IOV Capabilities */
>  #define  PCI_SRIOV_CAP_VFM     0x01    /* VF Migration Capable */
> --
> 1.7.4.1
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
