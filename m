Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932497Ab2EUSCd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 14:02:33 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:19197 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758119Ab2EUSC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 14:02:27 -0400
Date: Mon, 21 May 2012 13:55:10 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: benh@kernel.crashing.org, aik@ozlabs.ru, david@gibson.dropbear.id.au,
        joerg.roedel@amd.com, dwmw2@infradead.org, chrisw@sous-sol.org,
        agraf@suse.de, benve@cisco.com, aafabbri@cisco.com,
        B08248@freescale.com, B07421@freescale.com, avi@redhat.com,
        kvm@vger.kernel.org, qemu-devel@nongnu.org,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        bhelgaas@google.com
Subject: Re: [PATCH 11/13] pci: Create common pcibios_err_to_errno
Message-ID: <20120521175510.GB13990@phenom.dumpdata.com>
References: <20120511222148.30496.68571.stgit@bling.home>
 <20120511225643.30496.36823.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120511225643.30496.36823.stgit@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 04:56:44PM -0600, Alex Williamson wrote:
> For returning errors out to non-PCI code.  Re-name xen's version.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
> 
>  drivers/xen/xen-pciback/conf_space.c |    6 +++---
>  include/linux/pci.h                  |   26 ++++++++++++++++++++++++++
>  2 files changed, 29 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/xen/xen-pciback/conf_space.c b/drivers/xen/xen-pciback/conf_space.c
> index 30d7be0..46ae0f9 100644
> --- a/drivers/xen/xen-pciback/conf_space.c
> +++ b/drivers/xen/xen-pciback/conf_space.c
> @@ -124,7 +124,7 @@ static inline u32 merge_value(u32 val, u32 new_val, u32 new_val_mask,
>  	return val;
>  }
>  
> -static int pcibios_err_to_errno(int err)
> +static int xen_pcibios_err_to_errno(int err)
>  {
>  	switch (err) {
>  	case PCIBIOS_SUCCESSFUL:
> @@ -202,7 +202,7 @@ out:
>  		       pci_name(dev), size, offset, value);
>  
>  	*ret_val = value;
> -	return pcibios_err_to_errno(err);
> +	return xen_pcibios_err_to_errno(err);
>  }
>  
>  int xen_pcibk_config_write(struct pci_dev *dev, int offset, int size, u32 value)
> @@ -290,7 +290,7 @@ int xen_pcibk_config_write(struct pci_dev *dev, int offset, int size, u32 value)
>  		}
>  	}
>  
> -	return pcibios_err_to_errno(err);
> +	return xen_pcibios_err_to_errno(err);
>  }
>  
>  void xen_pcibk_config_free_dyn_fields(struct pci_dev *dev)
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index b437225..20a8f2e 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -467,6 +467,32 @@ static inline bool pci_dev_msi_enabled(struct pci_dev *pci_dev) { return false;
>  #define PCIBIOS_SET_FAILED		0x88
>  #define PCIBIOS_BUFFER_TOO_SMALL	0x89
>  
> +/*
> + * Translate above to generic errno for passing back through non-pci.
> + */
> +static inline int pcibios_err_to_errno(int err)
> +{
> +	if (err <= PCIBIOS_SUCCESSFUL)
> +		return err; /* Assume already errno */
> +
> +	switch (err) {
> +	case PCIBIOS_FUNC_NOT_SUPPORTED:
> +		return -ENOENT;
> +	case PCIBIOS_BAD_VENDOR_ID:
> +		return -EINVAL;
> +	case PCIBIOS_DEVICE_NOT_FOUND:
> +		return -ENODEV;
> +	case PCIBIOS_BAD_REGISTER_NUMBER:
> +		return -EFAULT;
> +	case PCIBIOS_SET_FAILED:
> +		return -EIO;
> +	case PCIBIOS_BUFFER_TOO_SMALL:
> +		return -ENOSPC;
> +	}
> +
> +	return -ENOTTY;
> +}
> +
>  /* Low-level architecture-dependent routines */
>  
>  struct pci_ops {
