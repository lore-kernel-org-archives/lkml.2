Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932962Ab2HPQBJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 12:01:09 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:34209 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932875Ab2HPQBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 12:01:01 -0400
MIME-Version: 1.0
In-Reply-To: <447517b3acece13b7e7ce86fdd4d73abe28d81f4.1345124063.git.agordeev@redhat.com>
References: <cover.1345124063.git.agordeev@redhat.com> <447517b3acece13b7e7ce86fdd4d73abe28d81f4.1345124063.git.agordeev@redhat.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 16 Aug 2012 10:00:39 -0600
Message-ID: <CAErSpo7RVnHQNVok9YQ7PiAAOL=XFTq_PMQmFNgFQhH9tZzy8A@mail.gmail.com>
Subject: Re: [PATCH 4/5] PCI, MSI: Enable multiple MSIs with pci_enable_msi_block_auto()
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Jeff Garzik <jgarzik@pobox.com>,
        Matthew Wilcox <willy@linux.intel.com>, linux-doc@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, linux-ide@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 8:49 AM, Alexander Gordeev <agordeev@redhat.com> wrote:
> The new function pci_enable_msi_block_auto() tries to allocate maximum
> possible number of MSIs up to the number the device supports. It
> generalizes a pattern when pci_enable_msi_block() contiguously called
> until it succeeds or fails.
>
> Opposite to pci_enable_msi_block() which takes the number of MSIs to
> allocate as a input parameter, pci_enable_msi_block_auto() could be used
> by device drivers to obtain the number of assigned MSIs.
>
> The function could also be used by device drivers which do not care
> about the exact number of assigned MSIs.
>
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> ---
>  Documentation/PCI/MSI-HOWTO.txt |   41 ++++++++++++++++++++++++++++++++++----
>  drivers/pci/msi.c               |   29 +++++++++++++++++++++++++++
>  include/linux/pci.h             |    7 ++++++
>  3 files changed, 72 insertions(+), 5 deletions(-)
>
> diff --git a/Documentation/PCI/MSI-HOWTO.txt b/Documentation/PCI/MSI-HOWTO.txt
> index 53e6fca..d5ab6d7 100644
> --- a/Documentation/PCI/MSI-HOWTO.txt
> +++ b/Documentation/PCI/MSI-HOWTO.txt
> @@ -127,15 +127,46 @@ on the number of vectors that can be allocated; pci_enable_msi_block()
>  returns as soon as it finds any constraint that doesn't allow the
>  call to succeed.
>
> -4.2.3 pci_disable_msi
> +4.2.3 pci_enable_msi_block_auto
> +
> +int pci_enable_msi_block_auto(struct pci_dev *dev, int *count)
> +
> +This variation on pci_enable_msi() call allows a device driver to request
> +the maximum possible number of MSIs.  The MSI specification only allows
> +interrupts to be allocated in powers of two, up to a maximum of 2^5 (32).
> +
> +If this function returns 0, it has succeeded in allocating as many
> +interrupts as the device supports.
> +
> +If this function returns a positive number, it indicates that it has
> +succeeded, but the number of allocated interrupts is less than the number
> +of interrupts the device supports. The returned value in this case is the
> +number of allocated interrupts.

Seems like it would be simpler to avoid the special case of returning
zero.  You could return a negative value for failure, otherwise return
the number of interrupts allocated.

Then you could also dispense with the "int *count" argument, because
the caller could just look at the return value.

> +In both cases above, the function enables MSI on this device and updates
> +dev->irq to be the lowest of the new interrupts assigned to it. The other
> +interrupts assigned to the device are in the range dev->irq to dev->irq +
> +number of allocated interrupts - 1.
> +
> +If the device driver needs to know the number of allocated interrupts it
> +can pass the pointer count where that number is stored. If the device driver
> +has other means to obtain that number or does not need it, NULL pointer can
> +be passed instead.
> +
> +If this function returns a negative number, it indicates an error and the
> +driver should not attempt to request any more MSI interrupts for this
> +device.
> +
> +4.2.4 pci_disable_msi
>
>  void pci_disable_msi(struct pci_dev *dev)
>
>  This function should be used to undo the effect of pci_enable_msi() or
> -pci_enable_msi_block().  Calling it restores dev->irq to the pin-based
> -interrupt number and frees the previously allocated message signaled
> -interrupt(s).  The interrupt may subsequently be assigned to another
> -device, so drivers should not cache the value of dev->irq.
> +pci_enable_msi_block() or pci_enable_msi_block_auto().  Calling it restores
> +dev->irq to the pin-based interrupt number and frees the previously
> +allocated message signaled interrupt(s).  The interrupt may subsequently be
> +assigned to another device, so drivers should not cache the value of
> +dev->irq.
>
>  Before calling this function, a device driver must always call free_irq()
>  on any interrupt for which it previously called request_irq().
> diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
> index f0752d1..ef982c1 100644
> --- a/drivers/pci/msi.c
> +++ b/drivers/pci/msi.c
> @@ -845,6 +845,35 @@ int pci_enable_msi_block(struct pci_dev *dev, unsigned int nvec)
>  }
>  EXPORT_SYMBOL(pci_enable_msi_block);
>
> +int pci_enable_msi_block_auto(struct pci_dev *dev, unsigned int *nvec)
> +{
> +       int ret, pos, envec, maxvec;
> +       u16 msgctl;
> +
> +       pos = pci_find_capability(dev, PCI_CAP_ID_MSI);
> +       if (!pos)
> +               return -EINVAL;
> +
> +       pci_read_config_word(dev, pos + PCI_MSI_FLAGS, &msgctl);
> +       maxvec = 1 << ((msgctl & PCI_MSI_FLAGS_QMASK) >> 1);
> +       ret = maxvec;
> +
> +       do {
> +               envec = ret;
> +               ret = pci_enable_msi_block(dev, envec);
> +       } while (ret > 0);
> +
> +       if (ret < 0)
> +               return ret;
> +       if (nvec)
> +               *nvec = envec;
> +       if (envec < maxvec)
> +               return envec;
> +       return 0;
> +
> +}
> +EXPORT_SYMBOL(pci_enable_msi_block_auto);
> +
>  void pci_msi_shutdown(struct pci_dev *dev)
>  {
>         struct msi_desc *desc;
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index d8c379d..14788d0 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -1024,6 +1024,12 @@ static inline int pci_enable_msi_block(struct pci_dev *dev, unsigned int nvec)
>         return -1;
>  }
>
> +static inline int
> +pci_enable_msi_block_auto(struct pci_dev *dev, unsigned int *nvec)
> +{
> +       return -1;
> +}
> +
>  static inline void pci_msi_shutdown(struct pci_dev *dev)
>  { }
>  static inline void pci_disable_msi(struct pci_dev *dev)
> @@ -1055,6 +1061,7 @@ static inline int pci_msi_enabled(void)
>  }
>  #else
>  extern int pci_enable_msi_block(struct pci_dev *dev, unsigned int nvec);
> +extern int pci_enable_msi_block_auto(struct pci_dev *dev, unsigned int *nvec);
>  extern void pci_msi_shutdown(struct pci_dev *dev);
>  extern void pci_disable_msi(struct pci_dev *dev);
>  extern int pci_msix_table_size(struct pci_dev *dev);
> --
> 1.7.7.6
>
>
> --
> Regards,
> Alexander Gordeev
> agordeev@redhat.com
