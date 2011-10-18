Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab1JRLMq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 07:12:46 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48115 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab1JRLMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 07:12:45 -0400
Message-ID: <4E9D5F29.1070303@linaro.org>
Date: Tue, 18 Oct 2011 12:12:41 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, jamie@jamieiles.com, arnd@arndb.de
Subject: Re: [PATCH 2/6] drivers/base: add bus for System-on-Chip devices
References: <1318852378-14180-1-git-send-email-lee.jones@linaro.org> <1318852378-14180-3-git-send-email-lee.jones@linaro.org> <20111017161616.GA5108@suse.de>
In-Reply-To: <20111017161616.GA5108@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/10/11 17:16, Greg KH wrote:
> On Mon, Oct 17, 2011 at 12:52:54PM +0100, Lee Jones wrote:
>> Traditionally, any System-on-Chip based platform creates a flat list
>> of platform_devices directly under /sys/devices/platform.
>>
>> In order to give these some better structure, this introduces a new
>> bus type for soc_devices that are registered with the new
>> soc_device_register() function.  All devices that are on the same
>> chip should then be registered as child devices of the soc device.
>>
>> The soc bus also exports a few standardised device attributes which
>> allow user space to query the specific type of soc.
>>
>> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> The code is much better, and smaller, but there's still some issues with
> it:

I'll attempt to address them.

>> +static ssize_t soc_info_get(struct device *dev,
>> +			    struct device_attribute *attr,
>> +			    char *buf);
>> +
>> +static DEVICE_ATTR(machine,  S_IRUGO, soc_info_get,  NULL);
>> +static DEVICE_ATTR(family,   S_IRUGO, soc_info_get,  NULL);
>> +static DEVICE_ATTR(soc_id,   S_IRUGO, soc_info_get,  NULL);
>> +static DEVICE_ATTR(revision, S_IRUGO, soc_info_get,  NULL);
>> +
>> +static ssize_t soc_info_get(struct device *dev,
>> +			    struct device_attribute *attr,
>> +			    char *buf)
>> +{
>> +	struct soc_device *soc_dev =
>> +		container_of(dev, struct soc_device, dev);
>> +
>> +	if (attr == &dev_attr_machine)
>> +		return sprintf(buf, "%s\n", soc_dev->attr->machine);
>> +	if (attr == &dev_attr_family)
>> +		return sprintf(buf, "%s\n", soc_dev->attr->family);
>> +	if (attr == &dev_attr_revision)
>> +		return sprintf(buf, "%s\n", soc_dev->attr->revision);
>> +	if (attr == &dev_attr_soc_id)
>> +		return sprintf(buf, "%s\n", soc_dev->attr->soc_id);
>> +
>> +	return -EINVAL;
>> +
>> +}
> 
> If you move around things a bit here, you can save 4 lines of code,
> please do so.

Telepathy has never been my Forté. Would you mind alluding to which
lines I can trim please?

If you mean the placing the DEVICE_ATTR's after soc_info_get and
removing its prototype; I had that already, but I was told to do it this
way as it would make the binary smaller.

>> +
>> +struct bus_type soc_bus_type = {
>> +	.name  = "soc",
>> +};
>> +
>> +static int __init soc_bus_register(void)
>> +{
>> +	return bus_register(&soc_bus_type);
>> +}
>> +core_initcall(soc_bus_register);
> 
> No unregister?

The unregister is contained in soc_device_unregister, but as you point
out in your other email this should be removed. I'm guessing we should
either count the number of SoCs and unregister as the last one leaves,
or not unregister at all?

>> +struct attribute *soc_attr[] = {
>> +	&dev_attr_machine.attr,
>> +	&dev_attr_family.attr,
>> +	&dev_attr_soc_id.attr,
>> +	&dev_attr_revision.attr,
>> +	NULL,
>> +};
>> +
>> +struct attribute_group soc_attr_group = {
>> +	.attrs = soc_attr,
>> +};
>> +
>> +struct device *soc_device_register(struct soc_device_attribute *soc_dev_attr)
>> +{
>> +	struct soc_device *soc_dev;
>> +	static atomic_t soc_device_num = ATOMIC_INIT(0);
> 
> No, please don't do this, use the proper kernel interface to dynamically
> handle numbering devices (hint, if you unload a SOC device, you will
> never reclaim that device number, which isn't that nice.)

Again, some help would really be appreciated here. I searched the kernel
last time you mentioned numbering, but this is all I came up with.

>> +struct soc_device_attribute {
>> +	const char *machine;
>> +	const char *family;
>> +	const char *revision;
>> +	const char *soc_id;
>> +};
> 
> What happens if one of these attributes is NULL?  Please check for that
> when you create the attributes so that you don't create an attribute you
> don't want to.

By shifting around "struct attribute *soc_attr[]"?

If one of them is NULL the file will just be empty, is that such a bad
thing?

>> +
>> +struct soc_device {
>> +	struct device dev;
>> +	struct soc_device_attribute *attr;
>> +};
> 
> Why is this needed to be defined here?  It should be in the .c file as
> no external code needs to know what it looks like.

If you want me to pass back a "struct soc_device" instead of a "raw"
struct device, the calling code will need to know how to separate out
"struct device dev" won't it?

> thanks,

No, thank you.

Kind regards,
Lee
