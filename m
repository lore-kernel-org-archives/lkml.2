Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015Ab1CLJAr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 04:00:47 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64384 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352Ab1CLJAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 04:00:46 -0500
Date: Sat, 12 Mar 2011 02:00:43 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Andres Salomon <dilinger@queued.net>
Cc: devicetree-discuss@lists.ozlabs.org, Daniel Drake <dsd@laptop.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] of: remove OF_DYNAMIC config option
Message-ID: <20110312090043.GF9347@angua.secretlab.ca>
References: <1299716167-9656-1-git-send-email-dilinger@queued.net>
 <1299716167-9656-2-git-send-email-dilinger@queued.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299716167-9656-2-git-send-email-dilinger@queued.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 09, 2011 at 04:16:05PM -0800, Andres Salomon wrote:
> Make of_attach_node/of_detach_node available without a specific config option.
> CONFIG_OF_DYNAMIC wasn't actually set by anything; the drivers that use
> of_attach_node (in arch/powerpc/platforms/) didn't actually depend upon
> or select CONFIG_OF_DYNAMIC.
> 
> While we're at it, make of_attach_node safe to call with the node's parent
> being NULL; the only time this should happen is with the root node.  Later
> patches will be using of_attach_node to link the root node.
> 
> Signed-off-by: Andres Salomon <dilinger@queued.net>

Looks good to me.

g.

> ---
>  drivers/of/Kconfig |    4 ----
>  drivers/of/base.c  |   17 ++++-------------
>  include/linux/of.h |    4 +---
>  3 files changed, 5 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
> index d06a637..ba90122 100644
> --- a/drivers/of/Kconfig
> +++ b/drivers/of/Kconfig
> @@ -26,10 +26,6 @@ config OF_EARLY_FLATTREE
>  config OF_PROMTREE
>  	bool
>  
> -config OF_DYNAMIC
> -	def_bool y
> -	depends on PPC_OF
> -
>  config OF_ADDRESS
>  	def_bool y
>  	depends on !SPARC
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index 710b53b..825e6d1 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -849,15 +849,6 @@ int prom_update_property(struct device_node *np,
>  	return 0;
>  }
>  
> -#if defined(CONFIG_OF_DYNAMIC)
> -/*
> - * Support for dynamic device trees.
> - *
> - * On some platforms, the device tree can be manipulated at runtime.
> - * The routines in this section support adding, removing and changing
> - * device tree nodes.
> - */
> -
>  /**
>   * of_attach_node - Plug a device node into the tree and global list.
>   */
> @@ -866,9 +857,11 @@ void of_attach_node(struct device_node *np)
>  	unsigned long flags;
>  
>  	write_lock_irqsave(&devtree_lock, flags);
> -	np->sibling = np->parent->child;
> +	if (np->parent) {
> +		np->sibling = np->parent->child;
> +		np->parent->child = np;
> +	}
>  	np->allnext = allnodes;
> -	np->parent->child = np;
>  	allnodes = np;
>  	write_unlock_irqrestore(&devtree_lock, flags);
>  }
> @@ -917,5 +910,3 @@ void of_detach_node(struct device_node *np)
>  out_unlock:
>  	write_unlock_irqrestore(&devtree_lock, flags);
>  }
> -#endif /* defined(CONFIG_OF_DYNAMIC) */
> -
> diff --git a/include/linux/of.h b/include/linux/of.h
> index bfc0ed1..bb36473 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -221,11 +221,9 @@ extern int prom_update_property(struct device_node *np,
>  				struct property *newprop,
>  				struct property *oldprop);
>  
> -#if defined(CONFIG_OF_DYNAMIC)
> -/* For updating the device tree at runtime */
> +/* For updating the device tree */
>  extern void of_attach_node(struct device_node *);
>  extern void of_detach_node(struct device_node *);
> -#endif
>  
>  #else
>  
> -- 
> 1.7.2.3
> 
