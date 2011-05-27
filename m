Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758638Ab1E0B6t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 21:58:49 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60477 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074Ab1E0B6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 21:58:48 -0400
Date: Thu, 26 May 2011 19:58:45 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: David Daney <ddaney@caviumnetworks.com>
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v4 4/6] MIPS: Prune some target specific code out of
 prom.c
Message-ID: <20110527015845.GD5032@ponder.secretlab.ca>
References: <1305930343-31259-1-git-send-email-ddaney@caviumnetworks.com>
 <1305930343-31259-5-git-send-email-ddaney@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305930343-31259-5-git-send-email-ddaney@caviumnetworks.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 03:25:41PM -0700, David Daney wrote:
> This code is not common enough to be in a shared file.  It is also not
> used by any existing boards, so just remove it.
> 
> Signed-off-by: David Daney <ddaney@caviumnetworks.com>
> ---
>  arch/mips/kernel/prom.c |   49 -----------------------------------------------
>  1 files changed, 0 insertions(+), 49 deletions(-)
> 
> diff --git a/arch/mips/kernel/prom.c b/arch/mips/kernel/prom.c
> index a19811e9..a07b6f1 100644
> --- a/arch/mips/kernel/prom.c
> +++ b/arch/mips/kernel/prom.c
> @@ -59,52 +59,3 @@ void __init early_init_dt_setup_initrd_arch(unsigned long start,
>  	initrd_below_start_ok = 1;
>  }
>  #endif
> -
> -/*
> - * irq_create_of_mapping - Hook to resolve OF irq specifier into a Linux irq#
> - *
> - * Currently the mapping mechanism is trivial; simple flat hwirq numbers are
> - * mapped 1:1 onto Linux irq numbers.  Cascaded irq controllers are not
> - * supported.
> - */
> -unsigned int irq_create_of_mapping(struct device_node *controller,
> -				   const u32 *intspec, unsigned int intsize)
> -{
> -	return intspec[0];
> -}
> -EXPORT_SYMBOL_GPL(irq_create_of_mapping);

In $NEXT_KERNEL+1 irq_create_of_mapping will be replaced by common
infrastructure code after irq_domain is merged, so this will become
irrelevant anyway.

> -
> -void __init early_init_devtree(void *params)
> -{
> -	/* Setup flat device-tree pointer */
> -	initial_boot_params = params;
> -
> -	/* Retrieve various informations from the /chosen node of the
> -	 * device-tree, including the platform type, initrd location and
> -	 * size, and more ...
> -	 */
> -	of_scan_flat_dt(early_init_dt_scan_chosen, NULL);
> -
> -	/* Scan memory nodes */
> -	of_scan_flat_dt(early_init_dt_scan_root, NULL);
> -	of_scan_flat_dt(early_init_dt_scan_memory_arch, NULL);
> -}
> -
> -void __init device_tree_init(void)
> -{
> -	unsigned long base, size;
> -
> -	if (!initial_boot_params)
> -		return;
> -
> -	base = virt_to_phys((void *)initial_boot_params);
> -	size = be32_to_cpu(initial_boot_params->totalsize);
> -
> -	/* Before we do anything, lets reserve the dt blob */
> -	reserve_mem_mach(base, size);
> -
> -	unflatten_device_tree();
> -
> -	/* free the space reserved for the dt blob */
> -	free_mem_mach(base, size);
> -}

I'm a little concerned that the MIPS platforms are not sharing the
same DT init code.  This isn't really something that should need to be
customized per-platform.

g.

