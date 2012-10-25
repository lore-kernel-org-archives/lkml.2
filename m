Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934287Ab2JYLED (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 07:04:03 -0400
Received: from mail.x86-64.org ([217.9.48.20]:39611 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932913Ab2JYLEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 07:04:00 -0400
Date: Thu, 25 Oct 2012 13:03:53 +0200
From: Borislav Petkov <bp@amd64.org>
To: Daniel J Blueman <daniel@numascale-asia.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v3] Add support for AMD64 EDAC on multiple PCI domains
Message-ID: <20121025110353.GA2623@aftab.osrc.amd.com>
Reply-To: Borislav Petkov <bp@alien8.de>
References: <1351153972-14019-1-git-send-email-daniel@numascale-asia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1351153972-14019-1-git-send-email-daniel@numascale-asia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 04:32:52PM +0800, Daniel J Blueman wrote:
> The AMD Northbridge initialisation code and EDAC assume the Northbridge IDs
> are contiguous, which no longer holds on federated systems with multiple
> HyperTransport fabrics and multiple PCI domains, eg on Numascale's
> Numaconnect systems with NumaChip.
> 
> Address this assumption by searching the Northbridge ID array, rather than
> directly indexing it, using the upper bits for the PCI domain.
> 
> RFC->v2: Correct array initialisation
> v2->v3: Add Boris's neater linked list approach
> 
> Todo:
> 1. fix kobject/sysfs oops (see http://quora.org/2012/16-server-boot.txt later)
> 2. reorder amd64_edac.c or add amd64_per_family_init/pci_get_related_function
>    forward declarations, based on feedback
> 
> Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>

This patch contains code from both of us and thus needs both our SOBs:

Signed-off-by: Borislav Petkov <bp@alien8.de>

> ---
>  arch/x86/include/asm/amd_nb.h            |   63 +++++++++++++++-
>  arch/x86/include/asm/numachip/numachip.h |   22 ++++++
>  arch/x86/kernel/amd_gart_64.c            |    8 +-
>  arch/x86/kernel/amd_nb.c                 |   85 ++++++++++++---------
>  arch/x86/pci/numachip.c                  |  121 ++++++++++++++++++++++++++++++
>  drivers/char/agp/amd64-agp.c             |   12 +--
>  drivers/edac/amd64_edac.c                |   34 +++++----
>  drivers/edac/amd64_edac.h                |    6 --
>  8 files changed, 283 insertions(+), 68 deletions(-)
>  create mode 100644 arch/x86/include/asm/numachip/numachip.h
>  create mode 100644 arch/x86/pci/numachip.c
> 
> diff --git a/arch/x86/include/asm/amd_nb.h b/arch/x86/include/asm/amd_nb.h
> index b3341e9..6a27226 100644
> --- a/arch/x86/include/asm/amd_nb.h
> +++ b/arch/x86/include/asm/amd_nb.h
> @@ -4,6 +4,8 @@
>  #include <linux/ioport.h>
>  #include <linux/pci.h>
>  
> +#define NUM_POSSIBLE_NBS	8
> +
>  struct amd_nb_bus_dev_range {
>  	u8 bus;
>  	u8 dev_base;
> @@ -51,12 +53,22 @@ struct amd_northbridge {
>  	struct pci_dev *link;
>  	struct amd_l3_cache l3_cache;
>  	struct threshold_bank *bank4;
> +	u16 node;
> +	struct list_head nbl;
>  };
>  
>  struct amd_northbridge_info {
>  	u16 num;
>  	u64 flags;
> -	struct amd_northbridge *nb;
> +
> +	/*
> +	 * The first 8 elems are for fast lookup of NB descriptors on single-
> +	 * system setups, i.e. "normal" boxes. The nb_list, OTOH, is list of
> +	 * additional NB descriptors which exist on confederate systems
> +	 * like using Numascale's Numaconnect/NumaChip.
> +	 */
> +	struct amd_northbridge *nbs[NUM_POSSIBLE_NBS];
> +	struct list_head nb_list;
>  };
>  extern struct amd_northbridge_info amd_northbridges;
>  
> @@ -78,7 +90,54 @@ static inline bool amd_nb_has_feature(unsigned feature)
>  
>  static inline struct amd_northbridge *node_to_amd_nb(int node)
>  {
> -	return (node < amd_northbridges.num) ? &amd_northbridges.nb[node] : NULL;
> +	struct amd_northbridge_info *nbi = &amd_northbridges;
> +	struct amd_northbridge *nb;
> +	int i;
> +
> +	/* Quick search for first domain */
> +	if (node < NUM_POSSIBLE_NBS) {
> +		if (node < nbi->num)
> +			return nbi->nbs[node];
> +		else
> +			return NULL;
> +	}

Why change that here from what I had before?

nbi->nbs[node] will either return a valid descriptor or NULL because it
is statically allocated in amd_northbridge_info.

So why add a conditional where you clearly don't need it?

> +	/* Search for NBs from later domains in array */
> +	for (i = 0; i < NUM_POSSIBLE_NBS; i++)
> +		if (nbi->nbs[i]->node == node)
> +			return nbi->nbs[i];

And then this is not needed.

> +
> +	list_for_each_entry(nb, &nbi->nb_list, nbl)
> +		if (node == nb->node)
> +			return nb;

And why change the list_for_each_entry_safe variant? It is not needed
now but who knows what code changes where in the future.

> +
> +	return NULL;
> +}
> +
> +static inline struct amd_northbridge *index_to_amd_nb(int index)
> +{
> +	struct amd_northbridge_info *nbi = &amd_northbridges;
> +	struct amd_northbridge *nb;
> +	int count = NUM_POSSIBLE_NBS;
> +
> +	if (index < NUM_POSSIBLE_NBS) {
> +		if (index < nbi->num)
> +			return nbi->nbs[index];
> +		else
> +			return NULL;
> +	}
> +
> +	list_for_each_entry(nb, &nbi->nb_list, nbl) {
> +		if (count++ == index)
> +			return nb;
> +	}
> +
> +	return NULL;
> +}

Huh, what do we need that function for? node should be equal to index
for the first 8 and then we use the linked list. What's up?

> +
> +static inline u16 amd_get_node_id(struct pci_dev *pdev)
> +{
> +	return (pci_domain_nr(pdev->bus) << 3) | (PCI_SLOT(pdev->devfn) - 0x18);
>  }
>  
>  #else

[ … ]

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
