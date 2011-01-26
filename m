Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751223Ab1AZFrU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 00:47:20 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:37062 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab1AZFrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 00:47:19 -0500
Date: Wed, 26 Jan 2011 14:47:09 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: devicetree-discuss@lists.ozlabs.org, jeremy.kerr@canonical.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        nicolas.pitre@linaro.org
Subject: Re: [RFC PATCH 3/5] of: add clock providers
Message-ID: <20110126054709.GC19428@linux-sh.org>
References: <20110126043338.16410.75019.stgit@localhost6.localdomain6> <20110126044422.16410.78703.stgit@localhost6.localdomain6> <20110126043338.16410.75019.stgit@localhost6.localdomain6> <20110126044416.16410.68942.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110126044422.16410.78703.stgit@localhost6.localdomain6> <20110126044416.16410.68942.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 09:44:17PM -0700, Grant Likely wrote:
> +struct clk *of_clk_get(struct device *dev, const char *id)
> +{
...
> +	snprintf(prop_name, 32, "%s-clock", id ? id : "bus");
> +	prop = of_get_property(dev->of_node, prop_name, &sz);
> +	if (!prop || sz < 4)
> +		return NULL;
...
> +	 * size of the property. */
> +	if (strlen(prop) + 1 > sz)
> +		return NULL;
> +
> +	/* Find the clock provider node; check if it is registered as a
> +	 * provider, and ask it for the relevant clk structure */
> +	provnode = of_find_node_by_phandle(provhandle);
> +	if (!provnode) {
> +		pr_warn("%s: %s property in node %s references invalid phandle",
> +			__func__, prop_name, dev->of_node->full_name);
> +		return NULL;
...

> +	return clk;
> +}

On Tue, Jan 25, 2011 at 09:44:22PM -0700, Grant Likely wrote:
> @@ -79,6 +81,11 @@ EXPORT_SYMBOL(clk_get_sys);
>  struct clk *clk_get(struct device *dev, const char *con_id)
>  {
>  	const char *dev_id = dev ? dev_name(dev) : NULL;
> +	struct clk *clk;
> +
> +	clk = of_clk_get(dev, con_id);
> +	if (clk && __clk_get(clk))
> +		return clk;
>  
>  	return clk_get_sys(dev_id, con_id);
>  }
> 

The return value for clk_get() by almost all users is checked for
specifically with IS_ERR() rather than an IS_ERR_OR_NULL(), so you're
going to want to change your of_clk_get() error paths to return
ERR_PTR()'s directly, or wrap it up like clk_get_sys() does.

Given that there are multiple reasons why of_clk_get() can fail however,
it's probably worth handing down the actual error rather than simply
chomping it in to an -ENOENT.
