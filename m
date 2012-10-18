Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab2JRKHr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 06:07:47 -0400
Received: from antcom.de ([188.40.178.216]:52803 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752998Ab2JRKHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 06:07:46 -0400
Message-ID: <507FD4EB.1080204@antcom.de>
Date: Thu, 18 Oct 2012 12:07:39 +0200
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
Subject: Re: [PATCH RFC 02/15 v5] gpio: Add sysfs support to block GPIO API
References: <1350477107-26512-1-git-send-email-stigge@antcom.de> <1350477107-26512-3-git-send-email-stigge@antcom.de> <20121017190520.GC25996@kroah.com>
In-Reply-To: <20121017190520.GC25996@kroah.com>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2012 09:05 PM, Greg KH wrote:
>> +static int gpio_block_value_unexport(struct gpio_block *block)
>> +{
>> +	struct device	*dev;
>> +	int		i;
>> +
>> +	dev = class_find_device(&gpio_block_class, NULL, block, match_export);
>> +	if (!dev)
>> +		return -ENODEV;
>> +
>> +	for (i = 0; i < block->ngpio; i++)
>> +		gpio_free(block->gpio[i]);
>> +
>> +	device_remove_file(dev, &dev_attr_block_value);
>> +
>> +	return 0;
>> +}
> 
> Wait, what?  You are removing a sysfs file in this function, from within
> a sysfs write:

Yes, exactly:

>> +static ssize_t gpio_block_exported_store(struct device *dev,
>> +					 struct device_attribute *attr,
>> +					 const char *buf, size_t size)
>> +{
>> +	long	value;
>> +	int	status;
>> +	struct	gpio_block *block = dev_get_drvdata(dev);
>> +	int	exported = gpio_block_value_is_exported(block);
>> +
>> +	status = kstrtoul(buf, 0, &value);
>> +	if (status < 0)
>> +		goto err;
>> +
>> +	if (value != exported) {
>> +		if (value)
>> +			status = gpio_block_value_export(block);
>> +		else
>> +			status = gpio_block_value_unexport(block);
> 
> That looks like a recipie for disaster.  Why do you allow userspace to
> do this?

Exporting for gpio blocks is done as follows: writing "1" to the
"exported" _device_ attribute of the gpio block creates the "values"
attribute and at the same time requests the whole block (including all
of its gpios) as "sysfs".

This admittedly deviates from the exporting of gpios (with the "export"
and "unexport" _class_ attributes) because blocks are not numbered. In
contrast, they are registered in a list (as was requested). Now, I
already had the idea of also having an "export" and "unexport" _class_
attribute for blocks also, but from a userspace perspective you only see
the presence and name of the gpio block if it is already being in sysfs
(even if not exported yet). If it wouldn't be this way, a user couldn't
guess how the required gpio block is called (or numbered), wouldn't even
know about its presence.

Just for understanding your strong desire for the device attribute
("value") being always present (in contrast to being created and removed
dynamically) - can you please give me any hint how the dynamic approach
would lead to disaster?

One possibility would be to always have "value" as a default device
attribute, but then it wouldn't be so obvious that it's useless until
"exported" is "1".

What do you think?

For now, I would elaborate about my terse "only available if /exported
is 1" like this:

"
Block GPIO devices are visible in sysfs as soon as they are registered
(e.g. via devicetree definition). For actual I/O use, their "exported"
boolean attribute must be set to "1". Then, the attribute "values" is
created and at the same time, the GPIOs in the block are requested for
exclusive use by sysfs.
"

Thanks in advance,

Roland
