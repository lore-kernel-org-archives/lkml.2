Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565Ab0EKRrS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 13:47:18 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:47785 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216Ab0EKRrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 13:47:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=of2Ql0YN08r/8P0tgoLbCeNiio5qRAGu7B2lfcWPctWX4MGSlbxiZROMmtI+ZCkxiU
         9dCZ3+u+xVOSiMG2iZY2IJgKSJ2pXYFRJUihA7LZuOpIQe8hNXkwphGZGcxOHojfqArX
         BH+p8NrNO1wWxsHPP83rbb/HWv/vO8IrwDixU=
Date: Tue, 11 May 2010 21:47:08 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
       Andres Salomon <dilinger@collabora.co.uk>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <len.brown@intel.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Matt Reimer <mreimer@vpop.net>, Evgeniy Polyakov <zbr@ioremap.net>,
       Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/3] pda_power: add support for writeable properties
Message-ID: <20100511174708.GA26777@oksana.dev.rtsoft.ru>
References: <1273595926-26249-1-git-send-email-daniel@caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1273595926-26249-1-git-send-email-daniel@caiaq.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 11, 2010 at 06:38:44PM +0200, Daniel Mack wrote:
> This patch adds support for writeable power supply properties and
> exposes them as writeable to sysfs.

A long-awaited feature! Thanks!

> 
> A power supply implementation must implement two new function calls in
> order to use that feature:
> 
>   int set_property(struct power_supply *psy,
>                    enum power_supply_property psp,
>                    const union power_supply_propval *val);
> 
>   int property_is_writeable(struct power_supply *psy,

I'm not a native English speaker, but I think this should be
'writable'.

>                             enum power_supply_property psp);
[...]
>  #define POWER_SUPPLY_ATTR(_name)					\
>  {									\
> -	.attr = { .name = #_name, .mode = 0444 },	\
> +	.attr = { .name = #_name },					\
>  	.show = power_supply_show_property,				\
> -	.store = NULL,							\
> +	.store = power_supply_store_property,				\
>  }
>  
>  static struct device_attribute power_supply_attrs[];
> @@ -91,6 +91,25 @@ static ssize_t power_supply_show_property(struct device *dev,
>  	return sprintf(buf, "%d\n", value.intval);
>  }
>  
> +static ssize_t power_supply_store_property(struct device *dev,
> +					   struct device_attribute *attr,
> +					   const char *buf, size_t count) {
> +	ssize_t ret;
> +	struct power_supply *psy = dev_get_drvdata(dev);
> +	const ptrdiff_t off = attr - power_supply_attrs;
> +	union power_supply_propval value;
> +	long long_val;
> +
> +	/* TODO: support other types than int */
> +	ret = strict_strtol(buf, 10, &long_val);
> +	if (ret < 0)
> +		return ret;
> +
> +	value.intval = long_val;
> +
> +	return psy->set_property(psy, off, &value);
> +}
> +
>  /* Must be in the same order as POWER_SUPPLY_PROP_* */
>  static struct device_attribute power_supply_attrs[] = {
>  	/* Properties of type `int' */
> @@ -164,6 +183,14 @@ int power_supply_create_attrs(struct power_supply *psy)
>  	}
>  
>  	for (j = 0; j < psy->num_properties; j++) {
> +		mode_t mode = S_IRUSR | S_IRGRP | S_IROTH;
> +
> +		if (psy->property_is_writeable &&
> +		    psy->property_is_writeable(psy, psy->properties[j]) > 0)
> +			mode |= S_IWUSR;
> +
> +		power_supply_attrs[psy->properties[j]].attr.mode = mode;

This is dangerous. You're changing the attr mode for all power
supplies, including already registered. I have no idea how attr
handling core will cope with that, but we'd better not check
this. :-)

Instead, change the mode to '0644' unconditionally,
and in power_supply_store_property() do something like this:
{
	if (!psy->set_property)
		return -EINVAL; (or EPERM, not sure which is better).
	....
	return psy->set_property(psy, off, &value);
	/* ^^^here set_property() should -EPERM if some property
	 * is read-only.
	 */
}

Plus, that way you don't need is_writable().

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
