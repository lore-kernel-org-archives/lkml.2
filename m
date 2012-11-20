Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab2KTPBX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 10:01:23 -0500
Received: from mail.skyhub.de ([78.46.96.112]:43547 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858Ab2KTPBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 10:01:21 -0500
Date: Tue, 20 Nov 2012 16:01:15 +0100
From: Borislav Petkov <bp@alien8.de>
To: Daniel J Blueman <daniel@numascale-asia.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>, Steffen Persvold <sp@numascale.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3, v6] AMD64 EDAC: Add muli-domain support
Message-ID: <20121120150114.GC28594@x1.alien8.de>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Daniel J Blueman <daniel@numascale-asia.com>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
	Steffen Persvold <sp@numascale.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org
References: <1353319368-9179-1-git-send-email-daniel@numascale-asia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1353319368-9179-1-git-send-email-daniel@numascale-asia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2012 at 06:02:46PM +0800, Daniel J Blueman wrote:
> Fix the handling of memory controller detection to index the array
> of detected Northbridges, allowing memory controllers over multiple
> PCI domains in federated systems eg using Numascale's NumaConnect/
> NumaChip.
> 
> v4: Generate linear Northbridge ID by indexing detected Northbridges
> v5: Reorder functions to prevent extra function declaration; merge 4th
>     patch; simplify Fam15h code; add detail to warning
> v6: Remove unused variable after simplification
> 
> Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>

Ok, let's do this right:

> ---
>  arch/x86/include/asm/amd_nb.h |   13 +++++++++++
>  drivers/edac/amd64_edac.c     |   48 +++++++++++++++++++++--------------------
>  drivers/edac/amd64_edac.h     |    6 ------
>  3 files changed, 38 insertions(+), 29 deletions(-)
> 
> diff --git a/arch/x86/include/asm/amd_nb.h b/arch/x86/include/asm/amd_nb.h
> index b3341e9..9f5532a 100644
> --- a/arch/x86/include/asm/amd_nb.h
> +++ b/arch/x86/include/asm/amd_nb.h
> @@ -81,6 +81,19 @@ static inline struct amd_northbridge *node_to_amd_nb(int node)
>  	return (node < amd_northbridges.num) ? &amd_northbridges.nb[node] : NULL;
>  }
>  
> +static inline u16 amd_get_node_id(struct pci_dev *pdev)
> +{
> +	int i;
> +
> +	for (i = 0; i != amd_nb_num(); i++)
> +		if (pci_domain_nr(node_to_amd_nb(i)->misc->bus) == pci_domain_nr(pdev->bus) &&
> +		    PCI_SLOT(node_to_amd_nb(i)->misc->devfn) == PCI_SLOT(pdev->devfn))
> +			return i;
> +
> +	WARN(1, "Unable to find AMD Northbridge identifier for %s\n", pci_name(pdev));
> +	return 0;
> +}
> +

This patch should be split into the changes adding amd_get_node_id and related
to it and the rest of them.

Btw, those lines above stick needlessly beyond 80 cols so you could do
something like:

static inline u16 amd_get_node_id(struct pci_dev *pdev)
{
	struct pci_dev *misc;
	int i;

	for (i = 0; i != amd_nb_num(); i++) {
		misc = node_to_amd_nb(i)->misc;

		if (pci_domain_nr(misc->bus) == pci_domain_nr(pdev->bus) &&
		    PCI_SLOT(misc->devfn) == PCI_SLOT(pdev->devfn))
			return i;
	}

to fix that.

>  #else
>  
>  #define amd_nb_num(x)		0
> diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
> index cc8e7c7..8de8873 100644
> --- a/drivers/edac/amd64_edac.c
> +++ b/drivers/edac/amd64_edac.c
> @@ -982,6 +982,24 @@ static u64 get_error_address(struct mce *m)
>  	return addr;
>  }
>  
> +static struct pci_dev *pci_get_related_function(unsigned int vendor,
> +						unsigned int device,
> +						struct pci_dev *related)
> +{
> +	struct pci_dev *dev = NULL;
> +
> +	dev = pci_get_device(vendor, device, dev);
> +	while (dev) {
> +		if (pci_domain_nr(dev->bus) == pci_domain_nr(related->bus) &&
> +		    (dev->bus->number == related->bus->number) &&
> +		    (PCI_SLOT(dev->devfn) == PCI_SLOT(related->devfn)))
> +			break;
> +		dev = pci_get_device(vendor, device, dev);
> +	}
> +
> +	return dev;
> +}
> +
>  static void read_dram_base_limit_regs(struct amd64_pvt *pvt, unsigned range)
>  {
>  	struct cpuinfo_x86 *c = &boot_cpu_data;
> @@ -1001,11 +1019,12 @@ static void read_dram_base_limit_regs(struct amd64_pvt *pvt, unsigned range)
>  
>  	/* Factor in CC6 save area by reading dst node's limit reg */
>  	if (c->x86 == 0x15) {
> -		struct pci_dev *f1 = NULL;
> -		u8 nid = dram_dst_node(pvt, range);
> +		struct pci_dev *misc, *f1 = NULL;
> +		u16 nid = dram_dst_node(pvt, range);
>  		u32 llim;
>  
> -		f1 = pci_get_domain_bus_and_slot(0, 0, PCI_DEVFN(0x18 + nid, 1));
> +		misc = node_to_amd_nb(nid)->misc;
> +		f1 = pci_get_related_function(misc->vendor, PCI_DEVICE_ID_AMD_15H_NB_F1, misc);
>  		if (WARN_ON(!f1))
>  			return;

This hunk and the one above changing pci_get_related_function should be
a separate patch.

Also, btw, you're changing node_to_amd_nb to receive u16 in patch 3/3
but adjusting the 'nid' argument here.

For clarity, please do the change to the function argument and its call
sites in one patch.

> -static struct pci_dev *pci_get_related_function(unsigned int vendor,
> -						unsigned int device,
> -						struct pci_dev *related)
> -{
> -	struct pci_dev *dev = NULL;
> -
> -	dev = pci_get_device(vendor, device, dev);
> -	while (dev) {
> -		if ((dev->bus->number == related->bus->number) &&
> -		    (PCI_SLOT(dev->devfn) == PCI_SLOT(related->devfn)))
> -			break;
> -		dev = pci_get_device(vendor, device, dev);
> -	}
> -
> -	return dev;
> -}
> -
>  /*
>   * These are tables of eigenvectors (one per line) which can be used for the
>   * construction of the syndrome tables. The modified syndrome search algorithm
> @@ -2546,7 +2548,7 @@ static int amd64_init_one_instance(struct pci_dev *F2)
>  	struct mem_ctl_info *mci = NULL;
>  	struct edac_mc_layer layers[2];
>  	int err = 0, ret;
> -	u8 nid = get_node_id(F2);
> +	u8 nid = amd_get_node_id(F2);

this should be u16 now, right?

>  
>  	ret = -ENOMEM;
>  	pvt = kzalloc(sizeof(struct amd64_pvt), GFP_KERNEL);
> @@ -2637,7 +2639,7 @@ err_ret:
>  static int __devinit amd64_probe_one_instance(struct pci_dev *pdev,
>  					     const struct pci_device_id *mc_type)
>  {
> -	u8 nid = get_node_id(pdev);
> +	u8 nid = amd_get_node_id(pdev);

ditto.

>  	struct pci_dev *F3 = node_to_amd_nb(nid)->misc;
>  	struct ecc_settings *s;
>  	int ret = 0;
> @@ -2687,7 +2689,7 @@ static void __devexit amd64_remove_one_instance(struct pci_dev *pdev)
>  {
>  	struct mem_ctl_info *mci;
>  	struct amd64_pvt *pvt;
> -	u8 nid = get_node_id(pdev);
> +	u8 nid = amd_get_node_id(pdev);

ditto.

>  	struct pci_dev *F3 = node_to_amd_nb(nid)->misc;
>  	struct ecc_settings *s = ecc_stngs[nid];
>  
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

Thanks.

-- 
Regards/Gruss,
Boris.
