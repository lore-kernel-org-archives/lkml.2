Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084Ab0LBWZd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 17:25:33 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49692 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753059Ab0LBWZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 17:25:31 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH] PCI: Disable ASPM if BIOS asks us to
Date: Thu, 2 Dec 2010 23:24:31 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc4+; KDE/4.4.4; x86_64; ; )
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        jbarnes@virtuousgeek.org
References: <1291326904-14822-1-git-send-email-mjg@redhat.com>
In-Reply-To: <1291326904-14822-1-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201012022324.31760.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 02, 2010, Matthew Garrett wrote:
> We currently refuse to touch the ASPM registers if the BIOS tells us that
> ASPM isn't supported. This can cause problems if the BIOS has (for any
> reason) enabled ASPM on some devices anyway. Change the code such that we
> explicitly clear ASPM if the FADT indicates that ASPM isn't supported,
> and make sure we tidy up appropriately on device removal in order to deal
> with the hotplug case. If ASPM is disabled because the BIOS doesn't hand
> over control then we won't touch the registers.

Good catch, but I'd rather use a separate function pcie_disable_aspm() to handle
the "BIOS tells us there's no ASPM" case and leave pcie_no_aspm() as is.
The, you might avoid a couple of changes.

> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> ---
>  drivers/pci/pci-acpi.c          |    2 +-
>  drivers/pci/pcie/aspm.c         |   20 +++++++++++++++-----
>  drivers/pci/pcie/portdrv_core.c |    2 +-
>  drivers/pci/pcie/portdrv_pci.c  |    2 +-
>  include/linux/pci-aspm.h        |    4 ++--
>  5 files changed, 20 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/pci/pci-acpi.c b/drivers/pci/pci-acpi.c
> index 24e19c5..e2c47cb 100644
> --- a/drivers/pci/pci-acpi.c
> +++ b/drivers/pci/pci-acpi.c
> @@ -399,7 +399,7 @@ static int __init acpi_pci_init(void)
>  
>  	if (acpi_gbl_FADT.boot_flags & ACPI_FADT_NO_ASPM) {
>  		printk(KERN_INFO"ACPI FADT declares the system doesn't support PCIe ASPM, so disable it\n");
> -		pcie_no_aspm();
> +		pcie_no_aspm(true);
>  	}
>  
>  	ret = register_acpi_bus_type(&acpi_pci_bus);
> diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
> index 7122281..08a2232 100644
> --- a/drivers/pci/pcie/aspm.c
> +++ b/drivers/pci/pcie/aspm.c
> @@ -68,7 +68,7 @@ struct pcie_link_state {
>  	struct aspm_latency acceptable[8];
>  };
>  
> -static int aspm_disabled, aspm_force;
> +static int aspm_disabled, aspm_force, aspm_clear_state;
>  static DEFINE_MUTEX(aspm_lock);
>  static LIST_HEAD(link_list);
>  
> @@ -498,6 +498,10 @@ static int pcie_aspm_sanity_check(struct pci_dev *pdev)
>  	struct pci_dev *child;
>  	int pos;
>  	u32 reg32;
> +
> +	if (aspm_clear_state)
> +		return -EINVAL;
> +
>  	/*
>  	 * Some functions in a slot might not all be PCIe functions,
>  	 * very strange. Disable ASPM for the whole slot
> @@ -563,12 +567,15 @@ void pcie_aspm_init_link_state(struct pci_dev *pdev)
>  	struct pcie_link_state *link;
>  	int blacklist = !!pcie_aspm_sanity_check(pdev);
>  
> -	if (aspm_disabled || !pci_is_pcie(pdev) || pdev->link_state)
> +	if (!pci_is_pcie(pdev) || pdev->link_state)
>  		return;
>  	if (pdev->pcie_type != PCI_EXP_TYPE_ROOT_PORT &&
>  	    pdev->pcie_type != PCI_EXP_TYPE_DOWNSTREAM)
>  		return;
>  
> +	if (aspm_disabled && !aspm_clear_state)
> +		return;
> +
>  	/* VIA has a strange chipset, root port is under a bridge */
>  	if (pdev->pcie_type == PCI_EXP_TYPE_ROOT_PORT &&
>  	    pdev->bus->self)
> @@ -641,7 +648,7 @@ void pcie_aspm_exit_link_state(struct pci_dev *pdev)
>  	struct pci_dev *parent = pdev->bus->self;
>  	struct pcie_link_state *link, *root, *parent_link;
>  
> -	if (aspm_disabled || !pci_is_pcie(pdev) ||
> +	if ((aspm_disabled && !aspm_clear_state) || !pci_is_pcie(pdev) ||
>  	    !parent || !parent->link_state)
>  		return;
>  	if ((parent->pcie_type != PCI_EXP_TYPE_ROOT_PORT) &&
> @@ -899,10 +906,13 @@ static int __init pcie_aspm_disable(char *str)
>  
>  __setup("pcie_aspm=", pcie_aspm_disable);
>  
> -void pcie_no_aspm(void)
> +void pcie_no_aspm(bool clear)
>  {
> -	if (!aspm_force)
> +	if (!aspm_force) {
>  		aspm_disabled = 1;
> +		if (clear)
> +			aspm_clear_state = clear;

Well, is the if(clear) really necessary?

> +	}
>  }
>  
>  /**
> diff --git a/drivers/pci/pcie/portdrv_core.c b/drivers/pci/pcie/portdrv_core.c
> index a9c222d..bb0fda1 100644
> --- a/drivers/pci/pcie/portdrv_core.c
> +++ b/drivers/pci/pcie/portdrv_core.c
> @@ -244,7 +244,7 @@ static int get_port_device_capability(struct pci_dev *dev)
>  	err = pcie_port_platform_notify(dev, &cap_mask);
>  	if (pcie_ports_auto) {
>  		if (err) {
> -			pcie_no_aspm();
> +			pcie_no_aspm(false);
>  			return 0;
>  		}
>  	} else {
> diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
> index f9033e1..87f5343 100644
> --- a/drivers/pci/pcie/portdrv_pci.c
> +++ b/drivers/pci/pcie/portdrv_pci.c
> @@ -328,7 +328,7 @@ static int __init pcie_portdrv_init(void)
>  	int retval;
>  
>  	if (pcie_ports_disabled) {
> -		pcie_no_aspm();
> +		pcie_no_aspm(false);
>  		return -EACCES;
>  	}
>  
> diff --git a/include/linux/pci-aspm.h b/include/linux/pci-aspm.h
> index 91ba0b3..c7176a6 100644
> --- a/include/linux/pci-aspm.h
> +++ b/include/linux/pci-aspm.h
> @@ -27,7 +27,7 @@ extern void pcie_aspm_init_link_state(struct pci_dev *pdev);
>  extern void pcie_aspm_exit_link_state(struct pci_dev *pdev);
>  extern void pcie_aspm_pm_state_change(struct pci_dev *pdev);
>  extern void pci_disable_link_state(struct pci_dev *pdev, int state);
> -extern void pcie_no_aspm(void);
> +extern void pcie_no_aspm(bool clear_state);
>  #else
>  static inline void pcie_aspm_init_link_state(struct pci_dev *pdev)
>  {
> @@ -42,7 +42,7 @@ static inline void pci_disable_link_state(struct pci_dev *pdev, int state)
>  {
>  }
>  
> -static inline void pcie_no_aspm(void)
> +static inline void pcie_no_aspm(bool clear_state)
>  {
>  }
>  #endif
> 

