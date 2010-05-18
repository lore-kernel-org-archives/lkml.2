Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758563Ab0ERRf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 13:35:26 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:50532 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758532Ab0ERRfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 13:35:22 -0400
Date: Tue, 18 May 2010 19:35:01 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <len.brown@intel.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Matt Reimer <mreimer@vpop.net>, Evgeniy Polyakov <zbr@ioremap.net>,
       Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] power_supply: Use attribute groups
Message-ID: <20100518173501.GI30801@buzzloop.caiaq.de>
References: <20100511175812.GH30801@buzzloop.caiaq.de>
 <20100511182347.GA31831@oksana.dev.rtsoft.ru>
 <20100511222825.GJ30801@buzzloop.caiaq.de>
 <20100512181546.GA4804@oksana.dev.rtsoft.ru>
 <20100512183806.GA28658@suse.de>
 <20100512190814.GA9674@oksana.dev.rtsoft.ru>
 <AANLkTimQq30DklQUDBokPXsLiXKsuiaCUFg_5ddkJbXa@mail.gmail.com>
 <20100512193050.GA14221@oksana.dev.rtsoft.ru>
 <20100513093304.GE30801@buzzloop.caiaq.de>
 <20100517194016.GA12147@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100517194016.GA12147@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anton,

On Mon, May 17, 2010 at 11:40:16PM +0400, Anton Vorontsov wrote:
> This fixes a race between power supply device and initial
> attributes creation, plus makes it possible to implement
> writable properties.

Thanks a lot. This works for me, but I have two minor comments below ...

[...]

> diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
> index 5b6e352..f95d934 100644
> --- a/drivers/power/power_supply_sysfs.c
> +++ b/drivers/power/power_supply_sysfs.c
> @@ -41,6 +41,9 @@ static struct device_attribute power_supply_attrs[];
>  static ssize_t power_supply_show_property(struct device *dev,
>  					  struct device_attribute *attr,
>  					  char *buf) {
> +	static char *type_text[] = {
> +		"Battery", "UPS", "Mains", "USB"
> +	};
>  	static char *status_text[] = {
>  		"Unknown", "Charging", "Discharging", "Not charging", "Full"
>  	};
> @@ -58,12 +61,15 @@ static ssize_t power_supply_show_property(struct device *dev,
>  	static char *capacity_level_text[] = {
>  		"Unknown", "Critical", "Low", "Normal", "High", "Full"
>  	};
> -	ssize_t ret;
> +	ssize_t ret = 0;
>  	struct power_supply *psy = dev_get_drvdata(dev);
>  	const ptrdiff_t off = attr - power_supply_attrs;
>  	union power_supply_propval value;
>  
> -	ret = psy->get_property(psy, off, &value);
> +	if (off == POWER_SUPPLY_PROP_TYPE)
> +		value.intval = psy->type;
> +	else
> +		ret = psy->get_property(psy, off, &value);
>  
>  	if (ret < 0) {
>  		if (ret == -ENODATA)
> @@ -85,10 +91,13 @@ static ssize_t power_supply_show_property(struct device *dev,
>  		return sprintf(buf, "%s\n", technology_text[value.intval]);
>  	else if (off == POWER_SUPPLY_PROP_CAPACITY_LEVEL)
>  		return sprintf(buf, "%s\n", capacity_level_text[value.intval]);
> +	else if (off == POWER_SUPPLY_PROP_TYPE)
> +		return sprintf(buf, "%s\n", type_text[value.intval]);
>  	else if (off >= POWER_SUPPLY_PROP_MODEL_NAME)
>  		return sprintf(buf, "%s\n", value.strval);
>  
>  	return sprintf(buf, "%d\n", value.intval);
> +return 0;

This return is superflous :)

And with this approach, we don't need to initialize the .mode field in
the POWER_SUPPLY_ATTR anmore.

I'll then rebase my patches for writeable properties and resend them.

Thanks,
Daniel
