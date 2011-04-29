Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760865Ab1D2Tf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 15:35:29 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:63047 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab1D2Tf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 15:35:28 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6331"; a="88464802"
Message-ID: <4DBB12EF.9030000@codeaurora.org>
Date: Fri, 29 Apr 2011 12:35:11 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Colin Cross <ccross@google.com>, Kevin Hilman <khilman@ti.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>, Len Brown <lenb@kernel.org>,
        linux-sh@vger.kernel.org, lethal@linux-sh.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@suse.de>
Subject: Re: [Update x2][PATCH 7/9] PM / Runtime: Generic clock manipulation
 rountines for runtime PM (v5)
References: <201104130205.26988.rjw@sisk.pl> <201104280306.13262.rjw@sisk.pl> <201104280333.13730.rjw@sisk.pl> <201104282136.26163.rjw@sisk.pl>
In-Reply-To: <201104282136.26163.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/2011 12:36 PM, Rafael J. Wysocki wrote:
> +/**
> + * pm_runtime_clk_add - Start using a device clock for runtime PM.
> + * @dev: Device whose clock is going to be used for runtime PM.
> + * @con_id: Connection ID of the clock.
> + *
> + * Add the clock represented by @con_id to the list of clocks used for
> + * the runtime PM of @dev.
> + */
> +int pm_runtime_clk_add(struct device *dev, const char *con_id)
> +{
> +	struct pm_runtime_clk_data *prd = __to_prd(dev);
> +	struct pm_clock_entry *ce;
> +
> +	if (!prd)
> +		return -EINVAL;
> +
> +	ce = kzalloc(sizeof(*ce), GFP_KERNEL);
> +	if (!ce) {
> +		dev_err(dev, "Not enough memory for clock entry.\n");
> +		return -ENOMEM;
> +	}
> +
> +	if (con_id) {
> +		ce->con_id = kstrdup(con_id, GFP_KERNEL);
> +		if (!ce->con_id) {
> +			dev_err(dev,
> +				"Not enough memory for clock conection ID.\n");

Missing an 'n' in connection.

> +			kfree(ce);
> +			return -ENOMEM;
> +		}
> +	}
> +
> +	mutex_lock(&prd->lock);
> +	list_add_tail(&ce->node, &prd->clock_list);
> +	mutex_unlock(&prd->lock);
> +	return 0;
> +}
> +
> +/**
> + * __pm_runtime_clk_remove - Destroy runtime PM clock entry.
> + * @ce: Runtime PM clock entry to destroy.
> + *
> + * This routine must be called under the mutex protecting the runtime PM list
> + * of clocks corresponding the the @ce's device.
> + */
> +static void __pm_runtime_clk_remove(struct pm_clock_entry *ce)
> +{
> +	if (!ce)
> +		return;
> +
> +	list_del(&ce->node);
> +
> +	if (!IS_ERR_OR_NULL(ce->clk)) {

NULL is a valid clock so you'll need to figure out some way to handle
that throughout this code.

> +		if (ce->clock_enabled)
> +			clk_disable(ce->clk);
> +
> +		clk_put(ce->clk);
> +	}
> +
> +	if (ce->con_id)
> +		kfree(ce->con_id);
> +
> +	kfree(ce);
> +}
> +

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

