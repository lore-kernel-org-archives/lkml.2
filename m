Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421Ab1EQPV5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 11:21:57 -0400
Received: from 64-198-47-7.ip.mcleodusa.net ([64.198.47.7]:47931 "EHLO
	mail02.indesign-llc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755225Ab1EQPV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 11:21:56 -0400
From: "Barnes, Clifton A." <cabarnes@indesign-llc.com>
To: Ryan Mallon <ryan@bluewatersys.com>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "haojian.zhuang@marvell.com" <haojian.zhuang@marvell.com>,
        "johnpol@2ka.mipt.ru" <johnpol@2ka.mipt.ru>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] w1: Add Maxim/Dallas DS2780 Stand-Alone Fuel Gauge
 IC support.
Thread-Topic: [PATCH v2] w1: Add Maxim/Dallas DS2780 Stand-Alone Fuel Gauge
 IC support.
Thread-Index: AQHMECFgMlmGYp5qvkOXxU1o2McCXJSRIlFA
Date: Tue, 17 May 2011 15:21:54 +0000
Message-ID: <A8DC7EA93EFCBD4498E3857AFE65E5F13A3DCC35@IND07.indesign.net>
References: <4DCACAA1.902@indesign-llc.com>
 <4DCAFDD0.9060707@bluewatersys.com>
In-Reply-To: <4DCAFDD0.9060707@bluewatersys.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p4HFM74u030908

On Wednesday, May 11, 2011 Ryan Mallon wrote:

> > +	if ((new_setting != 0) && (new_setting != 1)) {

> Don't need the inner parens.

Unless it's a common convention, I'd rather leave them because I think
it helps readability.

> > +	ret = kstrtou8(buf, 10, &new_setting);

> Might be worth allowing people to write register values in hex also.

If I'm reading the code correctly, I change the base to 0 to achieve
this, correct?

> > +static ssize_t ds2780_get_user_eeprom(struct device *dev,
> > +	struct device_attribute *attr,
> > +	char *buf)
> > +{
> > +	int ret;
> > +	struct power_supply *psy = to_power_supply(dev);
> > +	struct ds2780_device_info *dev_info = to_ds2780_device_info(psy);
> > +
> > +	ret = w1_ds2780_read(dev_info->w1_dev, buf, DS2780_EEPROM_BLOCK0_START,
> > +				DS2780_USER_EEPROM_SIZE);
> > +	if (ret < 0)
> > +		return ret;

> Not sure that this is really obeying the rules of sysfs which state that
> files should only contain a single value. There is the firmware
> subsystem, but I'm not sure that is really what you want either. Perhaps
> somebody else can suggest an alternative.

It looks like other EEPROMs use bin_attribute. I'll change it to use that
unless there's a better approach.

> > +config W1_SLAVE_DS2780
> > +	tristate "Dallas 2780 battery monitor chip"
> > +	depends on W1
> > +	help
> > +	  If you enable this you will have the DS2780 battery monitor
> > +	  chip support.
> > +
> > +	  The battery monitor chip is used in many batteries/devices
> > +	  as the one who is responsible for charging/discharging/monitoring
> > +	  Li+ batteries.
> > +
> > +	  If you are unsure, say N.
> > +

> This should just be:
> 
> 	config W1_SLAVE_DS2780:
> 	tristate
>
> since CONFIG_BATTERY_DS2780 selects this there is never any need for it
> to be a visible config option.

I did this the same way as the DS2760.  Should this be different?

> > +static ssize_t w1_ds2780_read_bin(struct file *filp, struct kobject *kobj,
> > +				  struct bin_attribute *bin_attr,
> > +				  char *buf, loff_t off, size_t count)
> > +{
> > +	struct device *dev = container_of(kobj, struct device, kobj);
> > +	return w1_ds2780_read(dev, buf, off, count);
> > +}

> What is this for?

It reads raw registers from the device.  It was implemented in the w1_ds2760.c 
file so I kept it.  I suppose you could use this driver without the battery
interface and read the registers that way.

> > +static int new_bat_id(void)
> > +{
> > +	int ret;
> > +
> > +	while (1) {
> > +		int id;
> > +
> > +		ret = idr_pre_get(&bat_idr, GFP_KERNEL);
> > +		if (ret == 0)
> > +			return -ENOMEM;
> > +
> > +		mutex_lock(&bat_idr_lock);
> > +		ret = idr_get_new(&bat_idr, NULL, &id);
> > +		mutex_unlock(&bat_idr_lock);
> > +
> > +		if (ret == 0) {
> > +			ret = id & MAX_ID_MASK;
> > +			break;
> > +		} else if (ret == -EAGAIN) {
> > +			continue;
> > +		} else {
> > +			break;
> > +		}
> > +	}

> Is it common to do this in a while loop? In my experience if the
> idr_get_new fails an error should be returned.

Again, this came from the w1_ds2760.c driver.  If it's more common to
error out, I can change it.

I'm in the process of making the other changes that were suggested.
How should I submit the changes?  A new patch v3 or a patch to v2?
If a patch to v2, how should that be indicated?

-Clif
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
