Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757670Ab1DHQxE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 12:53:04 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60377 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757654Ab1DHQxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 12:53:02 -0400
Date: Fri, 8 Apr 2011 09:52:52 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Andres Salomon <dilinger@queued.net>
Cc: devicetree-discuss@lists.ozlabs.org, Daniel Drake <dsd@laptop.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] of: rework of_attach_node, removing CONFIG_OF_DYNAMIC
Message-ID: <20110408165252.GB27556@angua.secretlab.ca>
References: <1300408356-15253-1-git-send-email-dilinger@queued.net>
 <1300408356-15253-2-git-send-email-dilinger@queued.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300408356-15253-2-git-send-email-dilinger@queued.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 05:32:33PM -0700, Andres Salomon wrote:
> Remove the OF_DYNAMIC config option, which makes of_attach_node/of_detach_node
> available without a specific config option.  CONFIG_OF_DYNAMIC wasn't actually
> being used by anything, as the drivers which made use of of_attach_node
> weren't depending upon or selecting it.
> 
> This also reworks of_attach_node to honor node ordering by time, rather than
> creating the allnext/sibling list in reverse order.  This has a number of
> ramifications worth mentioning:
> 
>  - 'last_child' is added to the device_node struct, and used to figure out
>    where a node should be added in the tree.  This will take the place of
>    the 'next' field.
>  - 'allnodes' is no longer used.  It is assumed that the parent node is already
>    attached to the tree.  What this really means is a simple assignment of
>    "allnodes = root_node;" prior to calling of_attach_node(root_node).
>  - The sibling list is guaranteed to retain order by insertion (later
>    insertions showing up later in the list).
>  - There are no similar guarantees for the allnext list with respect to
>    parents, their children, and their siblings.  While siblings are
>    guaranteed to be ordered by time, children may come before a sibling,
>    or after.  That is, one ordering of the allnext list may be: "/", "/pci",
>    "/isa", "/pci/foo", "/pci/bar".  Another perfectly valid ordering (and
>    this *will* happen depending upon how insertions are done) is: "/",
>    "/pci", "/pci/foo", "/pci/bar", "/isa".  The only thing that is
>    guaranteed is that the sibling list will be "/pci", "/isa" (if "/isa"
>    is added later), and that "/pci" will come before "/isa" in the allnext
>    list.
> 
> Signed-off-by: Andres Salomon <dilinger@queued.net>

Hi Andres, comment below.

> ---
>  drivers/of/Kconfig |    4 ----
>  drivers/of/base.c  |   47 ++++++++++++++++++++++++++++++++---------------
>  include/linux/of.h |    5 ++---
>  3 files changed, 34 insertions(+), 22 deletions(-)
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
> index 710b53b..9e94267 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -849,27 +849,46 @@ int prom_update_property(struct device_node *np,
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
>  void of_attach_node(struct device_node *np)
>  {
> +	struct device_node *parent;
>  	unsigned long flags;
>  
> +	parent = np->parent;
> +	if (!parent)
> +		return;
> +
>  	write_lock_irqsave(&devtree_lock, flags);
> -	np->sibling = np->parent->child;
> -	np->allnext = allnodes;
> -	np->parent->child = np;
> -	allnodes = np;
> +	if (parent->child) {
> +		/*
> +		 * We have at least 1 sibling, and last_child points to the
> +		 * last one that we've inserted.
> +		 *
> +		 * After insertion, the current node will be the last sibling
> +		 * in the sibling list (maintaining tree order), but will come
> +		 * before any siblings' children in the allnext list.  That
> +		 * holds true so long as the device tree is generated in a
> +		 * depth-first fashion.  Children added later may screw with
> +		 * the allnext ordering, but siblings are always guaranteed to
> +		 * remain in the order in which they were added.
> +		 */
> +		parent->last_child->sibling = np;
> +		np->allnext = parent->last_child->allnext;
> +		parent->last_child->allnext = np;
> +
> +	} else {
> +		/*
> +		 * This node is an only child.  Allnext descends into the
> +		 * child nodes from the parent.
> +		 */
> +		parent->child = np;
> +		np->allnext = parent->allnext;
> +		parent->allnext = np;
> +	}
> +	parent->last_child = np;

Hmmm... this screams to me that it shouldn't be open-coded.  Instead,
it really should be using list_head.  Unfortunately, that is a more
complex change, but I don't think I want to open code a new list
implementation.

blech.  I need to think about that more.

g.

