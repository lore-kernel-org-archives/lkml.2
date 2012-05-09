Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759143Ab2EIJeF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 05:34:05 -0400
Received: from mga03.intel.com ([143.182.124.21]:3795 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758933Ab2EIJeD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 05:34:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="98024726"
From: "Tc, Jenny" <jenny.tc@intel.com>
To: Ryan Mallon <rmallon@gmail.com>
CC: "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>,
        "anton.vorontsov@linaro.org" <anton.vorontsov@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "R, Durgadoss" <durgadoss.r@intel.com>
Subject: RE: [PATCH] power_supply: Register battery as a thermal zone
Thread-Topic: [PATCH] power_supply: Register battery as a thermal zone
Thread-Index: AQHNLaeAypD0HzHv1k6+9rfWyo9PeJbAnuaAgAB/LkA=
Date: Wed, 9 May 2012 09:33:57 +0000
Message-ID: <20ADAB092842284E95860F279283C56421D47A@BGSMSX101.gar.corp.intel.com>
References: <1336562318-16096-1-git-send-email-jenny.tc@intel.com>
 <4FAA0BA1.5080004@gmail.com>
In-Reply-To: <4FAA0BA1.5080004@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> > Battery and charger contribute to Thermals in most of the embedded
> > devices. So, it makes sense to identify them as Thermal zones in a
> > particular platform.
> >
> > This patch registers a thermal zone if the power supply is reporting a
> > temperature property. The thermal zone will be used by platform's
> > thermal management solution.
> >
> > Signed-off-by: Jenny TC <jenny.tc@intel.com>
> > ---
> 
> > +#ifdef CONFIG_THERMAL
> > +static int power_supply_read_temp(struct thermal_zone_device *tzd,
> > +		unsigned long *temp)
> > +{
> > +	struct power_supply *psy;
> > +	union power_supply_propval val;
> > +	int ret;
> > +
> > +	WARN_ON(tzd == NULL);
> > +	psy = tzd->devdata;
> > +	WARN_ON(psy == NULL);
> 
> 
> These WARN_ONs seem unnecessary since you will oops if either of them
> are NULL anyway.
> 

Agreed.

> > +	ret = psy->get_property(psy,
> > +				  POWER_SUPPLY_PROP_TEMP, &val);
> > +	if (!ret)
> > +		*temp = val.intval * 100;
> > +	return ret;
> > +}
> 
> 
> <snip>
> 
> >  int power_supply_register(struct device *parent, struct power_supply
> > *psy)  {
> >  	struct device *dev;
> >  	int rc;
> > +#ifdef CONFIG_THERMAL
> > +	int i;
> > +#endif
> >
> >  	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
> >  	if (!dev)
> > @@ -196,7 +223,21 @@ int power_supply_register(struct device *parent,
> struct power_supply *psy)
> >  	rc = device_add(dev);
> >  	if (rc)
> >  		goto device_add_failed;
> > -
> > +#ifdef CONFIG_THERMAL
> > +	/* Register battery zone device psy reports temperature */
> > +	for (i = 0; i < psy->num_properties; i++) {
> > +		if (psy->properties[i] == POWER_SUPPLY_PROP_TEMP) {
> > +			psy->tzd = thermal_zone_device_register(
> > +					(char *)psy->name, 0, psy,
> > +					&psy_tzd_ops, 0, 0, 0, 0);
> > +			if (IS_ERR(psy->tzd)) {
> > +				rc = PTR_ERR(psy->tzd);
> > +				goto therm_zone_reg_failed;
> > +			}
> > +			break;
> > +		}
> > +	}
> > +#endif
> 
> 
> This would be better moved into its own function, so you can minimise the
> amount of ifdefs needed. Having extra ifdefs for variable declarations and
> exit paths is especially ugly :-/. Ideally you can have a single #ifdef
> CONFIG_THERMAL block, and define empty functions for the
> !CONFIG_THERMAL case.
> 

Agreed. I will submit another patch in a few minutes.

> ~Ryan
