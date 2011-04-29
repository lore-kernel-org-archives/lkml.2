Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933785Ab1D2U31 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 16:29:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37075 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932307Ab1D2U3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 16:29:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [Update x2][PATCH 7/9] PM / Runtime: Generic clock manipulation rountines for runtime PM (v5)
Date: Fri, 29 Apr 2011 22:29:56 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Colin Cross <ccross@google.com>, Kevin Hilman <khilman@ti.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>, Len Brown <lenb@kernel.org>,
        linux-sh@vger.kernel.org, lethal@linux-sh.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@suse.de>
References: <201104130205.26988.rjw@sisk.pl> <201104282136.26163.rjw@sisk.pl> <4DBB12EF.9030000@codeaurora.org>
In-Reply-To: <4DBB12EF.9030000@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104292229.56518.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, April 29, 2011, Stephen Boyd wrote:
> On 04/28/2011 12:36 PM, Rafael J. Wysocki wrote:
> > +/**
> > + * pm_runtime_clk_add - Start using a device clock for runtime PM.
> > + * @dev: Device whose clock is going to be used for runtime PM.
> > + * @con_id: Connection ID of the clock.
> > + *
> > + * Add the clock represented by @con_id to the list of clocks used for
> > + * the runtime PM of @dev.
> > + */
> > +int pm_runtime_clk_add(struct device *dev, const char *con_id)
> > +{
> > +	struct pm_runtime_clk_data *prd = __to_prd(dev);
> > +	struct pm_clock_entry *ce;
> > +
> > +	if (!prd)
> > +		return -EINVAL;
> > +
> > +	ce = kzalloc(sizeof(*ce), GFP_KERNEL);
> > +	if (!ce) {
> > +		dev_err(dev, "Not enough memory for clock entry.\n");
> > +		return -ENOMEM;
> > +	}
> > +
> > +	if (con_id) {
> > +		ce->con_id = kstrdup(con_id, GFP_KERNEL);
> > +		if (!ce->con_id) {
> > +			dev_err(dev,
> > +				"Not enough memory for clock conection ID.\n");
> 
> Missing an 'n' in connection.

Right, thanks!

> > +			kfree(ce);
> > +			return -ENOMEM;
> > +		}
> > +	}
> > +
> > +	mutex_lock(&prd->lock);
> > +	list_add_tail(&ce->node, &prd->clock_list);
> > +	mutex_unlock(&prd->lock);
> > +	return 0;
> > +}
> > +
> > +/**
> > + * __pm_runtime_clk_remove - Destroy runtime PM clock entry.
> > + * @ce: Runtime PM clock entry to destroy.
> > + *
> > + * This routine must be called under the mutex protecting the runtime PM list
> > + * of clocks corresponding the the @ce's device.
> > + */
> > +static void __pm_runtime_clk_remove(struct pm_clock_entry *ce)
> > +{
> > +	if (!ce)
> > +		return;
> > +
> > +	list_del(&ce->node);
> > +
> > +	if (!IS_ERR_OR_NULL(ce->clk)) {
> 
> NULL is a valid clock so you'll need to figure out some way to handle
> that throughout this code.

Well, I didn't know that, thanks!  I'll need to add the "active" flag
back, then, after all.  In addition to that, I'll need to distinguish between
the "clk == NULL because it's not initialized" and "clk == NULL becuase it's
a valid clock" cases. 

I guess I'll use combinations of two flags.

Thanks,
Rafael
