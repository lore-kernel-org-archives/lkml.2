Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354Ab2JPMxs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 08:53:48 -0400
Received: from antcom.de ([188.40.178.216]:52826 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753464Ab2JPMxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 08:53:47 -0400
Message-ID: <507D58D9.2040607@antcom.de>
Date: Tue, 16 Oct 2012 14:53:45 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: grant.likely@secretlab.ca, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        w.sang@pengutronix.de, jbe@pengutronix.de, plagnioj@jcrosoft.com,
        highguy@gmail.com, broonie@opensource.wolfsonmicro.com,
        daniel-gl@gmx.net, rmallon@gmail.com
Subject: Re: [PATCH RFC 02/11 v4] gpio: Add sysfs support to block GPIO API
References: <1350343887-7344-1-git-send-email-stigge@antcom.de> <1350343887-7344-3-git-send-email-stigge@antcom.de> <20121015235720.GA3132@kroah.com>
In-Reply-To: <20121015235720.GA3132@kroah.com>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2012 01:57 AM, Greg KH wrote:
> On Tue, Oct 16, 2012 at 01:31:18AM +0200, Roland Stigge wrote:
>> +int gpio_block_export(struct gpio_block *block)
>> +{
>> +	int		status;
>> +	struct device	*dev;
>> +
>> +	/* can't export until sysfs is available ... */
>> +	if (!gpio_class.p) {
>> +		pr_debug("%s: called too early!\n", __func__);
>> +		return -ENOENT;
>> +	}
>> +
>> +	mutex_lock(&sysfs_lock);
>> +	dev = device_create(&gpio_class, NULL, MKDEV(0, 0), block,
>> +			    block->name);
>> +	if (!IS_ERR(dev))
>> +		status = sysfs_create_group(&dev->kobj, &gpio_block_attr_group);
>> +	else
>> +		status = PTR_ERR(dev);
>> +	mutex_unlock(&sysfs_lock);
> 
> You just raced with userspace telling it that the device was present,
> yet the attributes are not there.  Don't do that, use the default class
> attributes for the class and then the driver core will create them
> automagically without needing to this "by hand" at all.

I guess you mean class attributes like gpio_class_attrs[] of gpio_class?
Aren't class attributes specific to a class only (i.e. only one
attribute at the root for all devices)? What I needed above are
attributes for the block itself (of which there can be several). So we
need device attributes for each block, not class attributes here.

Maybe there's some other kind of locking/atomicity available for this task?

Further, current gpio and gpiochip devices are also doing this way:
creating the device and subsequently their attrs, even though there may
be a better way but I'm still wondering how this would be.

Any hint appreciated.

Thanks in advance,

Roland
