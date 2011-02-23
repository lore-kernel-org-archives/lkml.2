Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610Ab1BWAgp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 19:36:45 -0500
Received: from ozlabs.org ([203.10.76.45]:58246 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755400Ab1BWAgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 19:36:42 -0500
Date: Wed, 23 Feb 2011 11:16:39 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: David Daney <ddaney@caviumnetworks.com>
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
        devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 06/10] MIPS: Octeon: Initialize and fixup device
 tree.
Message-ID: <20110223001639.GB26300@yookeroo>
Mail-Followup-To: David Gibson <david@gibson.dropbear.id.au>,
	David Daney <ddaney@caviumnetworks.com>, linux-mips@linux-mips.org,
	ralf@linux-mips.org, devicetree-discuss@lists.ozlabs.org,
	grant.likely@secretlab.ca, linux-kernel@vger.kernel.org
References: <1298408274-20856-1-git-send-email-ddaney@caviumnetworks.com>
 <1298408274-20856-7-git-send-email-ddaney@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298408274-20856-7-git-send-email-ddaney@caviumnetworks.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[snip]
> +}
> +
> +static int __init set_mac_addr_prop(struct device_node *n, u64 mac)
> +{
> +	u8 *vp;
> +	struct property *old_p;
> +	struct property *p = kzalloc(sizeof(struct device_node) + 6, GFP_KERNEL);
> +	if (!p)
> +		return -ENOMEM;
> +	/* The value will immediatly follow the node in memory. */
> +	vp = (u8 *)(&p[1]);
> +	p->name = "local-mac-address";
> +	p->length = 6;
> +	p->value = vp;
> +
> +	vp[0] = (mac >> 40) & 0xff;
> +	vp[1] = (mac >> 32) & 0xff;
> +	vp[2] = (mac >> 24) & 0xff;
> +	vp[3] = (mac >> 16) & 0xff;
> +	vp[4] = (mac >> 8) & 0xff;
> +	vp[5] = mac & 0xff;
> +
> +	old_p = of_find_property(n, "local-mac-address", NULL);
> +	if (old_p)
> +		prom_remove_property(n, old_p);
> +	return prom_add_property(n, p);

Hrm, since you entirely remove and replace the local-mac-address
property here, I don't see much point to having the property with a
bogus value in the .dts.

[snip]
> +int __init octeon_prune_device_tree(void)
> +{
> +	int i, p, max_port;
> +	const char *node_path;
> +	char name_buffer[20];
> +	struct device_node *aliases;
> +	struct device_node *pip;
> +	struct device_node *iface;
> +	struct device_node *eth;
> +	struct device_node *node;
> +
> +	aliases = of_find_node_by_path("/aliases");
> +	if (!aliases) {
> +		pr_err("Error: No /aliases node in device tree.");
> +		return -EINVAL;
> +	}

Ok, I think the .dts could do with some more comments indicating that
it will be subject to extensive pruning before use.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
