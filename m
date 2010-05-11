Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789Ab0EKR6c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 13:58:32 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:56893 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab0EKR6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 13:58:31 -0400
Date: Tue, 11 May 2010 19:58:12 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <len.brown@intel.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Matt Reimer <mreimer@vpop.net>, Evgeniy Polyakov <zbr@ioremap.net>,
       Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/3] pda_power: add support for writeable properties
Message-ID: <20100511175812.GH30801@buzzloop.caiaq.de>
References: <1273595926-26249-1-git-send-email-daniel@caiaq.de>
 <20100511174708.GA26777@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100511174708.GA26777@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 11, 2010 at 09:47:08PM +0400, Anton Vorontsov wrote:
> On Tue, May 11, 2010 at 06:38:44PM +0200, Daniel Mack wrote:
> > A power supply implementation must implement two new function calls in
> > order to use that feature:
> > 
> >   int set_property(struct power_supply *psy,
> >                    enum power_supply_property psp,
> >                    const union power_supply_propval *val);
> > 
> >   int property_is_writeable(struct power_supply *psy,
> 
> I'm not a native English speaker, but I think this should be
> 'writable'.

Me neither, but I looked it up, and it's in fact both allowed ;)

> > +static ssize_t power_supply_store_property(struct device *dev,
> > +					   struct device_attribute *attr,
> > +					   const char *buf, size_t count) {
> > +	ssize_t ret;
> > +	struct power_supply *psy = dev_get_drvdata(dev);
> > +	const ptrdiff_t off = attr - power_supply_attrs;
> > +	union power_supply_propval value;
> > +	long long_val;
> > +
> > +	/* TODO: support other types than int */
> > +	ret = strict_strtol(buf, 10, &long_val);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	value.intval = long_val;
> > +
> > +	return psy->set_property(psy, off, &value);
> > +}
> > +
> >  /* Must be in the same order as POWER_SUPPLY_PROP_* */
> >  static struct device_attribute power_supply_attrs[] = {
> >  	/* Properties of type `int' */
> > @@ -164,6 +183,14 @@ int power_supply_create_attrs(struct power_supply *psy)
> >  	}
> >  
> >  	for (j = 0; j < psy->num_properties; j++) {
> > +		mode_t mode = S_IRUSR | S_IRGRP | S_IROTH;
> > +
> > +		if (psy->property_is_writeable &&
> > +		    psy->property_is_writeable(psy, psy->properties[j]) > 0)
> > +			mode |= S_IWUSR;
> > +
> > +		power_supply_attrs[psy->properties[j]].attr.mode = mode;
> 
> This is dangerous. You're changing the attr mode for all power
> supplies, including already registered. I have no idea how attr
> handling core will cope with that, but we'd better not check
> this. :-)

Hmm, no. The code defaults to (S_IRUSR | S_IRGRP | S_IROTH) which is
0444, just like it was before. So there shouldn't be any regression. The
mode is only changed if the psy defines a property_is_writeable()
callback which returns 1. Or do I miss your point?

> Instead, change the mode to '0644' unconditionally,
> and in power_supply_store_property() do something like this:
> {
> 	if (!psy->set_property)
> 		return -EINVAL; (or EPERM, not sure which is better).
> 	....
> 	return psy->set_property(psy, off, &value);
> 	/* ^^^here set_property() should -EPERM if some property
> 	 * is read-only.
> 	 */
> }
> 
> Plus, that way you don't need is_writable().

Ugh, really? I would _much_ prefer to actually _see_ which property is
writeable, just from looking at the file attributes in sysfs.

Thanks,
Daniel
