Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751809Ab1ITVBH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 17:01:07 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:64359 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab1ITVBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 17:01:05 -0400
Date: Tue, 20 Sep 2011 15:01:01 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Rob Herring <robherring2@gmail.com>,
        Ben Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, marc.zyngier@arm.com,
        thomas.abraham@linaro.org, jamie@jamieiles.com, b-cousson@ti.com,
        shawn.guo@linaro.org, dave.martin@linaro.org, linux@arm.linux.org.uk,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 1/3] of/irq: of_irq_find_parent: check for parent equal
 to child
Message-ID: <20110920210101.GP7781@ponder.secretlab.ca>
References: <1316550244-3655-1-git-send-email-robherring2@gmail.com>
 <1316550244-3655-2-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316550244-3655-2-git-send-email-robherring2@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 20, 2011 at 03:24:02PM -0500, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> An interrupt controller may often implicitly inherit itself from a parent
> node when in fact the controller is the interrupt root controller. Guard
> against the case of child == parent and return NULL in this case.
> 
> This can also be fixed by adding an explicit "interrupt-parent;" to a root
> interrupt controller node.
> 
> Based on code from Grant Likely.
> 
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>

Looks great.

Ben, can you look at this please?  Make sure I've not missed something
about how powerpc expects of_irq_find_parent() to behave.

g.

> ---
>  drivers/of/irq.c |   14 +++++++-------
>  1 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/of/irq.c b/drivers/of/irq.c
> index 9f689f1..6a5b5e7 100644
> --- a/drivers/of/irq.c
> +++ b/drivers/of/irq.c
> @@ -58,27 +58,27 @@ EXPORT_SYMBOL_GPL(irq_of_parse_and_map);
>   */
>  struct device_node *of_irq_find_parent(struct device_node *child)
>  {
> -	struct device_node *p;
> +	struct device_node *p, *c = child;
>  	const __be32 *parp;
>  
> -	if (!of_node_get(child))
> +	if (!of_node_get(c))
>  		return NULL;
>  
>  	do {
> -		parp = of_get_property(child, "interrupt-parent", NULL);
> +		parp = of_get_property(c, "interrupt-parent", NULL);
>  		if (parp == NULL)
> -			p = of_get_parent(child);
> +			p = of_get_parent(c);
>  		else {
>  			if (of_irq_workarounds & OF_IMAP_NO_PHANDLE)
>  				p = of_node_get(of_irq_dflt_pic);
>  			else
>  				p = of_find_node_by_phandle(be32_to_cpup(parp));
>  		}
> -		of_node_put(child);
> -		child = p;
> +		of_node_put(c);
> +		c = p;
>  	} while (p && of_get_property(p, "#interrupt-cells", NULL) == NULL);
>  
> -	return p;
> +	return (p == child) ? NULL : p;
>  }
>  
>  /**
> -- 
> 1.7.5.4
> 
