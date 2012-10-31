Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935488Ab2JaMDV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 08:03:21 -0400
Received: from mail.skyhub.de ([78.46.96.112]:59292 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791Ab2JaMDQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 08:03:16 -0400
Date: Wed, 31 Oct 2012 13:03:13 +0100
From: Borislav Petkov <bp@alien8.de>
To: Daniel J Blueman <daniel@numascale-asia.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>, Steffen Persvold <sp@numascale.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4, v4] AMD64 EDAC: Add multi-domain support to AMD EDAC
Message-ID: <20121031120313.GA19027@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Daniel J Blueman <daniel@numascale-asia.com>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
	Steffen Persvold <sp@numascale.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org
References: <1351662932-22279-1-git-send-email-daniel@numascale-asia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1351662932-22279-1-git-send-email-daniel@numascale-asia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 01:55:29PM +0800, Daniel J Blueman wrote:
> Fix the handling of memory controller detection to index the array
> of detected Northbridges, allowing memory controllers over multiple
> PCI domains in federated systems eg using Numascale's NumaConnect/
> NumaChip.
> 
> v4: Generate linear Northbridge ID by indexing detected Northbridges
> 
> Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>
> ---
>  arch/x86/include/asm/amd_nb.h |   12 ++++++++++++
>  drivers/edac/amd64_edac.c     |   18 ++++++++++++++----
>  drivers/edac/amd64_edac.h     |    6 ------
>  3 files changed, 26 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/include/asm/amd_nb.h b/arch/x86/include/asm/amd_nb.h
> index b3341e9..b88fc7a 100644
> --- a/arch/x86/include/asm/amd_nb.h
> +++ b/arch/x86/include/asm/amd_nb.h
> @@ -81,6 +81,19 @@ static inline struct amd_northbridge *node_to_amd_nb(int node)
>  	return (node < amd_northbridges.num) ? &amd_northbridges.nb[node] : NULL;
>  }
>  
> +static inline u16 get_node_id(struct pci_dev *pdev)

I'm guessing this'll be used in other code too, so rename it to belong
to the AMD namespace: amd_get_node_id.

> +{
> +	int i;
> +
> +	for (i = 0; i != amd_nb_num(); i++)
> +		if (pci_domain_nr(node_to_amd_nb(i)->misc->bus) == pci_domain_nr(pdev->bus) &&
> +		    PCI_SLOT(node_to_amd_nb(i)->misc->devfn) == PCI_SLOT(pdev->devfn))
> +			return i;

Ok, this relies on the fact that we always have the ->misc devices, i.e.
PCI F3. I guess that's ok.

> +
> +	WARN(1, "Unable to find AMD Northbridge identifier\n");

	WARN(1, "Unable to find AMD Northbridge identifier for %s\n", pci_name(pdev););

> +	return 0;
> +}
> +
>  #else
>  
>  #define amd_nb_num(x)		0
> diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
> index cc8e7c7..18d404a 100644
> --- a/drivers/edac/amd64_edac.c
> +++ b/drivers/edac/amd64_edac.c
> @@ -982,6 +982,9 @@ static u64 get_error_address(struct mce *m)
>  	return addr;
>  }
>  
> +static struct amd64_family_type *amd64_per_family_init(struct amd64_pvt *pvt);
> +static struct pci_dev *pci_get_related_function(unsigned int vendor, unsigned int device, struct pci_dev *related);
> +
>  static void read_dram_base_limit_regs(struct amd64_pvt *pvt, unsigned range)
>  {
>  	struct cpuinfo_x86 *c = &boot_cpu_data;
> @@ -1001,11 +1004,17 @@ static void read_dram_base_limit_regs(struct amd64_pvt *pvt, unsigned range)
>  
>  	/* Factor in CC6 save area by reading dst node's limit reg */
>  	if (c->x86 == 0x15) {
> -		struct pci_dev *f1 = NULL;
> -		u8 nid = dram_dst_node(pvt, range);
> +		struct pci_dev *misc, *f1 = NULL;
> +		struct amd64_family_type *fam_type;
> +		u16 nid = dram_dst_node(pvt, range);
>  		u32 llim;
>  
> -		f1 = pci_get_domain_bus_and_slot(0, 0, PCI_DEVFN(0x18 + nid, 1));
> +		misc = node_to_amd_nb(nid)->misc;
> +		fam_type = amd64_per_family_init(pvt);

No need for fam_type here since this is F15h-only code, simply use
PCI_DEVICE_ID_AMD_15H_NB_F1 in the function below.

> +		if (WARN_ON(!f1))
> +			return;
> +
> +		f1 = pci_get_related_function(misc->vendor, fam_type->f1_id, misc);
>  		if (WARN_ON(!f1))
>  			return;
>  
> @@ -1720,7 +1729,8 @@ static struct pci_dev *pci_get_related_function(unsigned int vendor,
>  
>  	dev = pci_get_device(vendor, device, dev);
>  	while (dev) {
> -		if ((dev->bus->number == related->bus->number) &&
> +		if (pci_domain_nr(dev->bus) == pci_domain_nr(related->bus) &&
> +		    (dev->bus->number == related->bus->number) &&
>  		    (PCI_SLOT(dev->devfn) == PCI_SLOT(related->devfn)))
>  			break;
>  		dev = pci_get_device(vendor, device, dev);
> diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
> index 8d48047..90cae61 100644
> --- a/drivers/edac/amd64_edac.h
> +++ b/drivers/edac/amd64_edac.h
> @@ -290,12 +290,6 @@
>  /* MSRs */
>  #define MSR_MCGCTL_NBE			BIT(4)
>  
> -/* AMD sets the first MC device at device ID 0x18. */
> -static inline u8 get_node_id(struct pci_dev *pdev)
> -{
> -	return PCI_SLOT(pdev->devfn) - 0x18;
> -}
> -
>  enum amd_families {
>  	K8_CPUS = 0,
>  	F10_CPUS,
> -- 
> 1.7.9.5
> 
> 

-- 
Regards/Gruss,
    Boris.
