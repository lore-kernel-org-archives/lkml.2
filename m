Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab0GZW0a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 18:26:30 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:59003 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab0GZW03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 18:26:29 -0400
Date: Tue, 27 Jul 2010 00:26:27 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: sfr@canb.auug.org.au, monstr@monstr.eu, microblaze-uclinux@itee.uq.edu.au,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, benh@kernel.crashing.org,
        sparclinux@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v3] of: Create asm-generic/of.h and provide default
	of_node_to_nid()
Message-ID: <20100726222627.GA23501@merkur.ravnborg.org>
References: <20100726220405.1550.63442.stgit@angua>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100726220405.1550.63442.stgit@angua>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 26, 2010 at 04:04:55PM -0600, Grant Likely wrote:
> of_node_to_nid() is only relevant in a few architectures.  Don't force
> everyone to implement it anyway.  This patch also adds asm-generic/of.h
> which will be used to contain other overrideable symbols.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> ---
> 
> Changes in v3: don't use asm-generic, just keep macros in of.h
> Changes in v2: address comments from sfr, add asm-generic/of.h

The use of asm-generic makes perfect sense.
This is how we usually deal with arch specific stuff.

With v3 of your patch we have a different result depending
on if we do:
#include <linux/of.h>

or we do:
#include <asm/prom.h>

This is undesireable.

I suggest to go back to v2 of your patch where you use asm-generic/of.h.

linux/of.h shall include asm/of.h
Then all archs shall have a of.h that may
include the asm-generic variant.


One patch to introduce of.h all over.
And a second patch to do the of_node_to_nid stuff would be appropriate.


> diff --git a/arch/powerpc/include/asm/prom.h b/arch/powerpc/include/asm/prom.h
> index da7dd63..dca25a5 100644
> --- a/arch/powerpc/include/asm/prom.h
> +++ b/arch/powerpc/include/asm/prom.h
> @@ -103,6 +103,11 @@ struct device_node *of_find_next_cache_node(struct device_node *np);
>  /* Get the MAC address */
>  extern const void *of_get_mac_address(struct device_node *np);
>  

This shall go in asm/of.h
> +#ifdef CONFIG_NUMA
> +extern int of_node_to_nid(struct device_node *device);
> +#define of_node_to_nid of_node_to_nid

This define is used to tell asm-generic/of.h that the arch has
a local definition - OK.

> +#endif
> +
>  /**
>   * of_irq_map_pci - Resolve the interrupt for a PCI device
>   * @pdev:	the device whose interrupt is to be resolved

> diff --git a/include/linux/of.h b/include/linux/of.h
> index b0756f3..cc936ca 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -146,6 +146,11 @@ static inline unsigned long of_read_ulong(const __be32 *cell, int size)
>  
>  #define OF_BAD_ADDR	((u64)-1)
>  
> +#ifndef of_node_to_nid
> +static inline int of_node_to_nid(struct device_node *np) { return 0; }
> +#define of_node_to_nid of_node_to_nid

But I fail to see the purpose of this define.

	Sam
