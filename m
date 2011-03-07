Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130Ab1CGTBA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 14:01:00 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:37445 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753551Ab1CGTA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 14:00:57 -0500
Message-ID: <4D752BAF.4010406@metafoo.de>
Date: Mon, 07 Mar 2011 20:02:07 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: Bill Gatliff <bgat@billgatliff.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PWM v6 1/3] PWM: Implement a generic PWM framework
References: <1299385050-13674-1-git-send-email-bgat@billgatliff.com>	<1299385050-13674-2-git-send-email-bgat@billgatliff.com>	<4D7326B0.6050706@metafoo.de> <AANLkTimZXSL9swHgqjsOxoCF8VopM8rkdgFjY-Wyi5Kb@mail.gmail.com>
In-Reply-To: <AANLkTimZXSL9swHgqjsOxoCF8VopM8rkdgFjY-Wyi5Kb@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2011 05:26 PM, Bill Gatliff wrote:

> 
>> So `cat request` requests the device and `echo > request` frees the device?
>> Thats a bit odd in my opinion.
> 
> Yes, and no.
> 
> For comparison, GPIO pins are exported to userspace like this:
> 
> # echo 160 > /sys/class/gpio/export
> 
> That's convenient when you know the number of the GPIO pin you wish to
> export.  Upon export, a directory /sys/class/gpio/gpio<pin> shows up.
> Prior to the export request, if the directory doesn't exist then you
> know that either nothing in userspace is using the pin.  If the
> directory doesn't exist after the export request, then you know your
> request failed--- probably because the kernel is using the pin.
> 
> The names for PWM devices are more complex.  To prevent needing to
> know the name of the desired PWM channel in advance, the list of all
> available PWM devices is always present in /sys/class/pwm.  Also, it
> isn't an error for an application to want to read the PWM device state
> (to update an instrument panel, for example) even when a kernel driver
> is actively controlling the device itself.  So I can't do things
> exactly how GPIO does them.
> 
> Once you identify the PWM device you are seeking, you read from its
> .../request attribute to ask for permission to use it.  The response
> you get back is either "sysfs" to state that userspace now controls
> the PWM device, or the label provided by the kernel requester to
> indicate that the kernel is using the device.
> 
> As long as (a) I want PWM device names to always be visible under
> /sys/class/pwm, and (b) I want applications to be able to read-only
> monitor PWM state even when the kernel is controlling the device, I
> don't know how to make things work differently than I have implemented
> without making things unnecessarily complicated.
> 
> Suggestions welcome.
> 

I don't see much of a problem with PWM devices being always visible or having
the attributes available read-only, but I see a problem with how a PWM device
is requested by userspace.

You basically turned a read-operation into a modify-operation and thus changed
its semantics. You'd normally not expect a object to change its external
visible state, if the state of the object is read.
Image some berserk running file indexer going through sysfs. You'd suddenly
find yourself with all PWM devices being exported.

I see two alternatives to your implementation:
1) The device is exported by writing a non-empty string to the 'request'
sysfs-attribute. The written string is then used as the label under which the
device is requested.
   To release the device a empty string would be written to the 'request'
sysfs-attribute.

2) Add a another sysfs-attribute called 'export'. Writing a '1' will export the
device, writing a '0' will release it.

I'd prefer the later since it keeps things simple and I'm not sure if anything
is gained making it possible to supply the label when requesting the device
from userspace.

>>> +static struct class pwm_class = {
>>> +     .name = "pwm",
>>> +     .owner = THIS_MODULE,
>>> +
>>> +     .class_attrs = pwm_class_attrs,
>>
>> Just leaving it NULL should work, if you don't want any class attributes.
> 
> Today I don't want any attributes, but I might someday soon.  I don't
> have any immediate plans, though...

You can add it back, if you want to add any class attributes. Just keeping a
list with only an end-of-list element around doesn't make much sense.


>>> +     d = class_find_device(&pwm_class, NULL, (char*)name, pwm_match_name);
>>> +     if (d) {
>>> +             ret = -EEXIST;
>>> +             goto err_found_device;
>>> +     }
>> device_create should fail if a device with the same name already exits, so I'm
>> not sure if it makes sense to do the check here.
> 
> I'm pretty sure you are right.  Fixed.
> 
>>> +     p->dev = device_create(&pwm_class, parent, MKDEV(0, 0), NULL, name);
>> ... NULL, "%s", name);
> 
> I guess things would get ugly with my code if someone passed a name
> that had a "%<something>" in it, no? :)
> 
>> Or you could use device_create_vargs and get rid of that scnprintf in pwm_register.
> 
> Ooh, that sounds interesting.  I'll look at that.

I had a look at the atmel pwm driver in the mean time and since you are using
scnprintf there as well, it seems like a good idea in general to have a method
for registering a PWM device where you can pass a format string.
> 
>>
>>> +     if (IS_ERR(p->dev)) {
>>> +             ret = PTR_ERR(p->dev);
>>> +             goto err_device_create;
>>> +     }
>> I think it would be better to embed the device struct directly into the
>> pwm_device struct. You could also remove the data field of the pwm_device
>> struct and use dev_{get,set}_drvdata for pwm_{get,set}_drvdata.
> 
> Will look at that and follow up.
> 
>>> +     ret = sysfs_create_group(&p->dev->kobj, &pwm_device_attr_group);
>>> +     if (ret)
>>> +             goto err_create_group;
>>
>> It should be possible to use the classes dev_attrs here instead.
> 
> I tinkered with that early on, and ended up with the impression that
> class attributes were applied to the class as a whole, and not each
> member of the class.  Maybe I just messed up somewhere.  Will
> investigate and follow up.

There is both. There is 'class_attrs' which are only created once for the class
and there is 'dev_attrs' which are created on a per device basis.

- Lars
