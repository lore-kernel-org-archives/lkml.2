Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079Ab0JAR7p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 13:59:45 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:36350 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab0JAR7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 13:59:44 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH] pci: Reenable the AMD IOMMU if it's mysteriously vanished over suspend
Date: Fri, 1 Oct 2010 11:58:42 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-25-generic; KDE/4.4.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        joerg.roedel@amd.com, jbarnes@virtuousgeek.org
References: <1285861108-24122-1-git-send-email-mjg@redhat.com>
In-Reply-To: <1285861108-24122-1-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201010011158.45746.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 30, 2010 09:38:28 am Matthew Garrett wrote:
> AMD's reference BIOS code had a bug that could result in the firmware
> failing to reenable the iommu on resume. It transpires that this causes
> certain less than desirable behaviour when it comes to PCI accesses, to
> whit them ending up somewhere near Bristol when the more desirable outcome
> was Edinburgh. Sadness ensues, perhaps along with filesystem corruption.
> Let's make sure that it gets turned back on.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> ---
>  drivers/pci/quirks.c |   33 +++++++++++++++++++++++++++++++++
>  1 files changed, 33 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 89ed181..dcf9832 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -2695,6 +2695,39 @@ DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_R5C832,
>  #endif /*CONFIG_MMC_RICOH_MMC*/
>  
>  
> +#ifdef CONFIG_AMD_IOMMU
> +
> +/* Some AMD BIOSes fail to reenable the iommu on resume */
> +
> +static void amd_iommu_reenable(struct pci_dev *dev)
> +{
> +	u32 ioc_feature_control;
> +	struct pci_dev *iommu;
> +
> +	iommu = pci_get_device(PCI_VENDOR_ID_ATI, 0x5a23, NULL);
> +
> +	if (!iommu)
> +		return;
> +
> +	/* Select Northbridge indirect register 0x75 and enable writing */
> +	pci_write_config_dword(dev, 0x60, 0x75 | (1 << 7));
> +	pci_read_config_dword(dev, 0x64, &ioc_feature_control);
> +
> +	/* Enable the iommu if it's vanished */
> +	if (!(ioc_feature_control & 0x1))
> +		pci_write_config_dword(dev, 0x64, ioc_feature_control | 1);

This sounds important and tricky enough that it'd be nice to have a
note in dmesg about what we're doing.

> +	/* Disable writing again */
> +	pci_write_config_dword(dev, 0x60, 0x75);
> +
> +	pci_dev_put(iommu);
> +}
> +
> +DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_ATI, 0x5a10, amd_iommu_reenable);
> +DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_ATI, 0x5a12, amd_iommu_reenable);
> +DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_ATI, 0x5a13, amd_iommu_reenable);
> +#endif
> +
>  static void pci_do_fixups(struct pci_dev *dev, struct pci_fixup *f,
>  			  struct pci_fixup *end)
>  {
> 
