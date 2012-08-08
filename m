Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030189Ab2HHJlP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 05:41:15 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40122 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757951Ab2HHJlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 05:41:13 -0400
Date: Wed, 8 Aug 2012 02:38:58 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] max17042_battery: add support for battery STATUS and
 CHARGE_TYPE
Message-ID: <20120808093857.GA1402@lizard>
References: <1343408181-21988-1-git-send-email-ramakrishna.pallala@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1343408181-21988-1-git-send-email-ramakrishna.pallala@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 10:26:21PM +0530, Ramakrishna Pallala wrote:
> This patch adds the support to report the battery power supply attributes
> STATUS and CHARGE_TYPE. This patch makes use of power_supply_get_external_attr()
> API to get these attributes through power supply core.
> 
> Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
> ---
[...]
>  	switch (psp) {
> +	case POWER_SUPPLY_PROP_STATUS:
> +		ret = power_supply_get_external_attr(&query);
> +		if (ret < 0)
> +			return ret;
> +		val->intval = query.res.intval;
> +		break;

First of, thanks a lot for your work. And sorry that it took me quite
a while to review it, but these are fundamental changes, so I had to
thoughtfully consider all this.

This exact code clearly shows that it is not battery's property. Battery
itself cannot report it, right? OK, here is what
Documentation/power/power_supply_class.txt says:

A: Most likely, no. This class is designed to export properties which are
   directly measurable by the specific hardware available.

   Inferring not available properties using some heuristics or mathematical
   model is not subject of work for a battery driver. Such functionality
   should be factored out

So, you basically try to infer battery's properties from the charger hw.
This is surely doable, but no, I think we should not do this. Instead,
what we want is to make use of "supplied_to" mechanism of the power
supply class, and export it via sysfs. Then userland can see all the
power supply hierarchy, and thus see which hardware provides which data.

See my thoughts about exporting "supplied_to" to the sysfs:

	http://lkml.org/lkml/2011/6/22/258

So, we'll have:

/sys/
   class/
      power_supply/
         charger/
            supplied_to/battery -> ../../battery
         battery/

Sure, we'll have to teach userland to operate on this scheme, i.e.
it must be aware that batteries might be connected to an external
charger, and if so, userland must query* charging status from the
charger.

Do you see any problem with this approach?

Thanks!

p.s.

Actually, once userland read all the hierarchy, it can get properties
pretty easy, e.g. recursively walking the tree (pseudo code):

get_prop(psy, prop, *val)
{
	if (prop_exists(psy, prop))
		return psy->get_property(psy, prop, val);
	if (psy->supplier)
		return get_prop(psy->parent, prop, val);
	return ENODATA;
}

Note that the pseudo-code above is for the userland, not for the kernel.
(We can surely implement a similar function in the kernel, it just that
we don't need it, at least now. But the function would do the similar
thing you're trying to accomplish: get parent's properties.)

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
