Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886Ab0J3Gcp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 02:32:45 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37706 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab0J3Gcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 02:32:42 -0400
Date: Sat, 30 Oct 2010 07:32:37 +0100
From: Grant Likely <grant.likely@secretlab.ca>
To: David Daney <ddaney@caviumnetworks.com>
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dan Carpenter <error27@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] of: of_mdio: Fix some endianness problems.
Message-ID: <20101030063237.GC2456@angua.secretlab.ca>
References: <1288227827-5447-1-git-send-email-ddaney@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288227827-5447-1-git-send-email-ddaney@caviumnetworks.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 06:03:47PM -0700, David Daney wrote:
> In of_mdiobus_register(), the __be32 *addr variable is dereferenced.
> This will not work on little-endian targets.  Also since it is
> unsigned, checking for less than zero is redundant.
> 
> Fix these two issues.
> 
> Signed-off-by: David Daney <ddaney@caviumnetworks.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Jeremy Kerr <jeremy.kerr@canonical.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Dan Carpenter <error27@gmail.com>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> ---
>  drivers/of/of_mdio.c |   23 ++++++++++++++---------
>  1 files changed, 14 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/of/of_mdio.c b/drivers/of/of_mdio.c
> index 1fce00e..b370306 100644
> --- a/drivers/of/of_mdio.c
> +++ b/drivers/of/of_mdio.c
> @@ -52,27 +52,32 @@ int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
>  
>  	/* Loop over the child nodes and register a phy_device for each one */
>  	for_each_child_of_node(np, child) {
> -		const __be32 *addr;
> +		const __be32 *paddr;
> +		u32 addr;
>  		int len;
>  
>  		/* A PHY must have a reg property in the range [0-31] */
> -		addr = of_get_property(child, "reg", &len);
> -		if (!addr || len < sizeof(*addr) || *addr >= 32 || *addr < 0) {
> +		paddr = of_get_property(child, "reg", &len);
> +		if (!paddr || len < sizeof(*paddr)) {
> +addr_err:
>  			dev_err(&mdio->dev, "%s has invalid PHY address\n",
>  				child->full_name);
>  			continue;
>  		}
> +		addr = be32_to_cpup(paddr);
> +		if (addr >= 32)
> +			goto addr_err;

goto's are fine for jumping to the end of a function to unwind
allocations, but please don't use it in this manner.  The original
structure will actually work just fine if you do it thusly:

		if (!paddr || len < sizeof(*paddr) ||
		    *(addr = be32_to_cpup(paddr)) >= 32) {
			dev_err(&mdio->dev, "%s has invalid PHY address\n",
				child->full_name);
			continue;
		}

Otherwise this patch looks good. After you've reworked and retested
I'll pick it up for 2.6.37 (or dave will).

g.


>  
>  		if (mdio->irq) {
> -			mdio->irq[*addr] = irq_of_parse_and_map(child, 0);
> -			if (!mdio->irq[*addr])
> -				mdio->irq[*addr] = PHY_POLL;
> +			mdio->irq[addr] = irq_of_parse_and_map(child, 0);
> +			if (!mdio->irq[addr])
> +				mdio->irq[addr] = PHY_POLL;
>  		}
>  
> -		phy = get_phy_device(mdio, be32_to_cpup(addr));
> +		phy = get_phy_device(mdio, addr);
>  		if (!phy || IS_ERR(phy)) {
>  			dev_err(&mdio->dev, "error probing PHY at address %i\n",
> -				*addr);
> +				addr);
>  			continue;
>  		}
>  		phy_scan_fixups(phy);
> @@ -91,7 +96,7 @@ int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
>  		}
>  
>  		dev_dbg(&mdio->dev, "registered phy %s at address %i\n",
> -			child->name, *addr);
> +			child->name, addr);
>  	}
>  
>  	return 0;
> -- 
> 1.7.2.3
> 
