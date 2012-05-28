Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab2E1Mjr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 08:39:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38661 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754580Ab2E1Mjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 08:39:45 -0400
Date: Mon, 28 May 2012 15:39:35 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Alexander Graf <agraf@suse.de>, kvm <kvm@vger.kernel.org>
Subject: Re: [PATCH] PCI: Mark INTx masking support of Chelsio T310 10GbE NIC
 as broken
Message-ID: <20120528123934.GB21778@redhat.com>
References: <4FBF90E5.8030800@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FBF90E5.8030800@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2012 at 11:02:13AM -0300, Jan Kiszka wrote:
> According to Alexey, the T310 does not properly support INTx masking as
> it fails to keep the PCI_STATUS_INTERRUPT bit updated once the interrupt
> is masked. Mark this adapter as broken so that pci_intx_mask_supported
> won't report it as compatible.
> 
> Reported-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> Signed-off-by: Jan Kiszka <jan.kiszka@web.de>


Just a thought: would be nice to have a way to discover
the quirk was activated. Add an attribute so that
userspace can detect and report this properly to users?
Or just log a warning message ...


> ---
> 
> Alexey, please test if this catches your case correctly.
> 
>  drivers/pci/pci.c    |    3 +++
>  drivers/pci/quirks.c |   12 ++++++++++++
>  include/linux/pci.h  |    2 ++
>  3 files changed, 17 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 8f16900..3a1aeb5 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -2876,6 +2876,9 @@ bool pci_intx_mask_supported(struct pci_dev *dev)
>  	bool mask_supported = false;
>  	u16 orig, new;
>  
> +	if (dev->broken_intx_masking)
> +		return false;
> +
>  	pci_cfg_access_lock(dev);
>  
>  	pci_read_config_word(dev, PCI_COMMAND, &orig);
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 2a75216..151e174 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -2929,6 +2929,18 @@ static void __devinit disable_igfx_irq(struct pci_dev *dev)
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x0102, disable_igfx_irq);
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x010a, disable_igfx_irq);
>  
> +/*
> + * Some devices may pass our check in pci_intx_mask_supported if
> + * PCI_COMMAND_INTX_DISABLE works though they actually do not properly
> + * support this feature.
> + */
> +static void __devinit quirk_broken_intx_masking(struct pci_dev *dev)
> +{
> +	dev->broken_intx_masking = 1;
> +}
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_CHELSIO, 0x0010,
> +			quirk_broken_intx_masking);
> +
>  static void pci_do_fixups(struct pci_dev *dev, struct pci_fixup *f,
>  			  struct pci_fixup *end)
>  {
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 17b7b5b..c7cfd73 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -324,6 +324,8 @@ struct pci_dev {
>  	unsigned int    is_hotplug_bridge:1;
>  	unsigned int    __aer_firmware_first_valid:1;
>  	unsigned int	__aer_firmware_first:1;
> +	unsigned int	broken_intx_masking:1;	/* device's INTx masking
> +						   support is not working */
>  	pci_dev_flags_t dev_flags;
>  	atomic_t	enable_cnt;	/* pci_enable_device has been called */
>  
> -- 
> 1.7.3.4
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
