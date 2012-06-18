Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974Ab2FRS3o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 14:29:44 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:36761 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553Ab2FRS3f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 14:29:35 -0400
MIME-Version: 1.0
In-Reply-To: <4FD066C3.4090008@web.de>
References: <4FBF90E5.8030800@siemens.com> <4FCE19DA.1070802@siemens.com>
 <4FD0389F.7030400@ozlabs.ru> <4FD066C3.4090008@web.de>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 18 Jun 2012 12:29:12 -0600
Message-ID: <CAErSpo7a24UcHQFTTDZvVJ-swP3q6uirkr=Xps5dG6wnBbUqDg@mail.gmail.com>
Subject: Re: [PATCH v2] PCI: Mark INTx masking support of Chelsio T310 10GbE
 NIC as broken
To: Jan Kiszka <jan.kiszka@web.de>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Alexander Graf <agraf@suse.de>, kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 7, 2012 at 2:30 AM, Jan Kiszka <jan.kiszka@web.de> wrote:
> From: Jan Kiszka <jan.kiszka@siemens.com>
>
> According to
>
> http://thread.gmane.org/gmane.comp.emulators.kvm.devel/91388
>
> the T310 does not properly support INTx masking as it fails to keep the
> PCI_STATUS_INTERRUPT bit updated once the interrupt is masked. Mark this
> adapter as broken so that pci_intx_mask_supported won't report it as
> compatible.
>
> Tested-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
> ---
>
> Changes in v2:
>  - Fixed device ID to Alexey's report
>  - Added reference to the original report
>
>  drivers/pci/pci.c    |    3 +++
>  drivers/pci/quirks.c |   12 ++++++++++++
>  include/linux/pci.h  |    2 ++
>  3 files changed, 17 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 447e834..9ae517a 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -2876,6 +2876,9 @@ bool pci_intx_mask_supported(struct pci_dev *dev)
>        bool mask_supported = false;
>        u16 orig, new;
>
> +       if (dev->broken_intx_masking)
> +               return false;
> +
>        pci_cfg_access_lock(dev);
>
>        pci_read_config_word(dev, PCI_COMMAND, &orig);
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 2a75216..28804f4 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -2929,6 +2929,18 @@ static void __devinit disable_igfx_irq(struct pci_dev *dev)
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x0102, disable_igfx_irq);
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x010a, disable_igfx_irq);
>
> +/*
> + * Some devices may pass our check in pci_intx_mask_supported if
> + * PCI_COMMAND_INTX_DISABLE works though they actually do not properly
> + * support this feature.
> + */
> +static void __devinit quirk_broken_intx_masking(struct pci_dev *dev)
> +{
> +       dev->broken_intx_masking = 1;
> +}
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_CHELSIO, 0x0030,
> +                       quirk_broken_intx_masking);
> +
>  static void pci_do_fixups(struct pci_dev *dev, struct pci_fixup *f,
>                          struct pci_fixup *end)
>  {
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index d8c379d..7ea6cf8 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -324,6 +324,8 @@ struct pci_dev {
>        unsigned int    is_hotplug_bridge:1;
>        unsigned int    __aer_firmware_first_valid:1;
>        unsigned int    __aer_firmware_first:1;
> +       unsigned int    broken_intx_masking:1;  /* device's INTx masking
> +                                                  support is not working */
>        pci_dev_flags_t dev_flags;
>        atomic_t        enable_cnt;     /* pci_enable_device has been called */
>
> --
> 1.7.3.4

I applied this to my "next" branch with minor tweaks (split the
infrastructure part from the device-specific quirk, and changed from a
FINAL quirk to a HEADER quirk because FINAL quirks currently aren't
called for hot-added devices).  Let me know if you see anything wrong.

Thanks!

Bjorn
