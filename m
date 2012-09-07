Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757793Ab2IGUxd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 16:53:33 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:63572 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757387Ab2IGUx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 16:53:26 -0400
MIME-Version: 1.0
In-Reply-To: <6a425d611ce5c276ec6949fd6aadf575580e07fe.1346653435.git.agordeev@redhat.com>
References: <cover.1346653435.git.agordeev@redhat.com> <6a425d611ce5c276ec6949fd6aadf575580e07fe.1346653435.git.agordeev@redhat.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 7 Sep 2012 13:53:03 -0700
Message-ID: <CAErSpo6Pd1O_vzhiwrRX_fjjoDs789orX_t+uJoZKbk5XWZa6w@mail.gmail.com>
Subject: Re: [PATCH v2 -tip 4/5] PCI, MSI: Enable multiple MSIs with pci_enable_msi_block_auto()
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Jeff Garzik <jgarzik@pobox.com>,
        Matthew Wilcox <willy@linux.intel.com>, x86@kernel.org,
        linux-pci@vger.kernel.org, linux-ide@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 3, 2012 at 2:19 AM, Alexander Gordeev <agordeev@redhat.com> wrote:
> The new function pci_enable_msi_block_auto() tries to allocate maximum
> possible number of MSIs up to the number the device supports. It
> generalizes a pattern when pci_enable_msi_block() is contiguously called
> until it succeeds or fails.
>
> Opposite to pci_enable_msi_block() which takes the number of MSIs to
> allocate as a input parameter, pci_enable_msi_block_auto() could be used
> by device drivers to obtain the number of assigned MSIs and the number
> of MSIs the device supports.
>
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

I haven't looked at the other patches in this series, but if the
x86/IRQ folks like them, I'm OK with this part.

Since the series is mostly non-PCI, I think it makes the most sense to
keep it all together and merge it through some x86 or IRQ tree,
including this PCI bit.

> ---
>  Documentation/PCI/MSI-HOWTO.txt |   37 ++++++++++++++++++++++++++++++++-----
>  drivers/pci/msi.c               |   26 ++++++++++++++++++++++++++
>  include/linux/pci.h             |    7 +++++++
>  3 files changed, 65 insertions(+), 5 deletions(-)
>
> diff --git a/Documentation/PCI/MSI-HOWTO.txt b/Documentation/PCI/MSI-HOWTO.txt
> index 53e6fca..a091780 100644
> --- a/Documentation/PCI/MSI-HOWTO.txt
> +++ b/Documentation/PCI/MSI-HOWTO.txt
> @@ -127,15 +127,42 @@ on the number of vectors that can be allocated; pci_enable_msi_block()
>  returns as soon as it finds any constraint that doesn't allow the
>  call to succeed.
>
> -4.2.3 pci_disable_msi
> +4.2.3 pci_enable_msi_block_auto
> +
> +int pci_enable_msi_block_auto(struct pci_dev *dev, unsigned int *count)
> +
> +This variation on pci_enable_msi() call allows a device driver to request
> +the maximum possible number of MSIs.  The MSI specification only allows
> +interrupts to be allocated in powers of two, up to a maximum of 2^5 (32).
> +
> +If this function returns a positive number, it indicates that it has
> +succeeded and the returned value is the number of allocated interrupts. In
> +this case, the function enables MSI on this device and updates dev->irq to
> +be the lowest of the new interrupts assigned to it.  The other interrupts
> +assigned to the device are in the range dev->irq to dev->irq + returned
> +value - 1.
> +
> +If this function returns a negative number, it indicates an error and
> +the driver should not attempt to request any more MSI interrupts for
> +this device.
> +
> +If the device driver needs to know the number of interrupts the device
> +supports it can pass the pointer count where that number is stored. The
> +device driver must decide what action to take if pci_enable_msi_block_auto()
> +succeeds, but returns a value less than the number of interrupts supported.
> +If the device driver does not need to know the number of interrupts
> +supported, it can set the pointer count to NULL.
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
> index f0752d1..690b268 100644
> --- a/drivers/pci/msi.c
> +++ b/drivers/pci/msi.c
> @@ -845,6 +845,32 @@ int pci_enable_msi_block(struct pci_dev *dev, unsigned int nvec)
>  }
>  EXPORT_SYMBOL(pci_enable_msi_block);
>
> +int pci_enable_msi_block_auto(struct pci_dev *dev, unsigned int *maxvec)
> +{
> +       int ret, pos, nvec;
> +       u16 msgctl;
> +
> +       pos = pci_find_capability(dev, PCI_CAP_ID_MSI);
> +       if (!pos)
> +               return -EINVAL;
> +
> +       pci_read_config_word(dev, pos + PCI_MSI_FLAGS, &msgctl);
> +       ret = 1 << ((msgctl & PCI_MSI_FLAGS_QMASK) >> 1);
> +
> +       if (maxvec)
> +               *maxvec = ret;
> +
> +       do {
> +               nvec = ret;
> +               ret = pci_enable_msi_block(dev, nvec);
> +       } while (ret > 0);
> +
> +       if (ret < 0)
> +               return ret;
> +       return nvec;
> +}
> +EXPORT_SYMBOL(pci_enable_msi_block_auto);
> +
>  void pci_msi_shutdown(struct pci_dev *dev)
>  {
>         struct msi_desc *desc;
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 5faa831..b8a9454 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -1070,6 +1070,12 @@ static inline int pci_enable_msi_block(struct pci_dev *dev, unsigned int nvec)
>         return -1;
>  }
>
> +static inline int
> +pci_enable_msi_block_auto(struct pci_dev *dev, unsigned int *maxvec)
> +{
> +       return -1;
> +}
> +
>  static inline void pci_msi_shutdown(struct pci_dev *dev)
>  { }
>  static inline void pci_disable_msi(struct pci_dev *dev)
> @@ -1101,6 +1107,7 @@ static inline int pci_msi_enabled(void)
>  }
>  #else
>  extern int pci_enable_msi_block(struct pci_dev *dev, unsigned int nvec);
> +extern int pci_enable_msi_block_auto(struct pci_dev *dev, unsigned int *maxvec);
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
