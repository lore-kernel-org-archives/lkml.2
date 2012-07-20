Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347Ab2GTJyy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 05:54:54 -0400
Received: from mga03.intel.com ([143.182.124.21]:57859 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248Ab2GTJyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 05:54:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="124715423"
From: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] power_supply: Added support for power supply attribute
 sources
Thread-Topic: [PATCH] power_supply: Added support for power supply attribute
 sources
Thread-Index: AQHNYyv6fCGnxML9Ekqw5AEAaOWgeZcx6yvQ
Date: Fri, 20 Jul 2012 09:54:33 +0000
Message-ID: <D854C92F57B1B347B57E531E78D05EAD1B3B5F@BGSMSX102.gar.corp.intel.com>
References: <1340627842-31908-1-git-send-email-ramakrishna.pallala@intel.com>
 <20120716082119.GA26238@lizard>
In-Reply-To: <20120716082119.GA26238@lizard>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q6K9t1cB023060


Hi Anton,

Sorry for replying late. But please find my response below.

> > This patch adds the generic support to register the drivers as power
> > supply attribute(properties) sources and adds an interface to read
> > these attributes from power supply class drivers.
> 
> So, you would add power_supply_attributes_register() calls into ADC drivers?
> This is not right.
> 
> The right approach would be to write a power supply driver that would accept
> ADC device/channel (or just a callback) for getting needed information to report.
> 
> I.e.
> 
> /*
>  * Here I just made up adc_channel struct for simplicity of the
>  * example; For real ADC dev, you really want to use Industrial IO
>  * framework, i.e. include/linux/iio/iio.h.
>  */
> struct adc_channel {
> 	...
> 	int (*get_value)(struct *adc_channel);
> };
> 
> struct adc_power_supply_platform_data {
> 	struct adc_channel *voltage;
> 	struct adc_channel *current;
> };
> 
> And the "adc power supply" driver would then call:
> 
> ...
> case POWER_SUPPLY_PROP_CURRENT:
> 	prop->intval = voltage->get_value(voltage); ...
> 
> Sure, sometimes it's not only ADC, but sensors, regulators and so forth. So pass
> all the devices to the power_supply driver, and teach the driver to work with the
> facilities.

I got your point in IIO framework, but the main reason for submitting this patch was to avoid adding platform level hooks.
If we have 5 such parameters we have to add 5 different hooks to the platform code. With this patch the driver code need not be changed or
Its platform code or data structures.

Also IMO this approach will be functionally and logically correct. We can view the power supply subsystem is collection of power supply classes
and each class is collection of power supply attributes. And these attributes can be provided by same power supply driver or it can get from other drivers
in a generic way through power supply subsystem.

> [..]
> > +struct power_supply_attr_query {
> > +	enum power_supply_property property;
> > +	enum power_supply_type type;
> > +	/* variable to store result */
> > +	union power_supply_propval res;
> > +};
> [...]
> > +extern int power_supply_get_external_attr(
> > +				struct power_supply_attr_query *query);
> 
> And even if we'd consider adding this feature, the interface seems very limited.
> What if there are two, say, batteries?

I thought through point when I was submitting this patch. My initial thought was to add a
name variable in the query structure which will mention the source name. If the data is available
only from this source we get the data otherwise not.
If a user does not provide this name(NULL) we still give whatever is available.
If we have multiple batteries we have to do source selection and this has to go to platform code.

Please let me know your thoughts on it.
If you think  something can be improved in this approach please let me know I would be happy to implement it.

Thanks,
Ram
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
