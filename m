Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526Ab1CGQ0u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 11:26:50 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59252 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab1CGQ0r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 11:26:47 -0500
MIME-Version: 1.0
In-Reply-To: <4D7326B0.6050706@metafoo.de>
References: <1299385050-13674-1-git-send-email-bgat@billgatliff.com>
	<1299385050-13674-2-git-send-email-bgat@billgatliff.com>
	<4D7326B0.6050706@metafoo.de>
Date: Mon, 7 Mar 2011 10:26:47 -0600
Message-ID: <AANLkTimZXSL9swHgqjsOxoCF8VopM8rkdgFjY-Wyi5Kb@mail.gmail.com>
Subject: Re: [PWM v6 1/3] PWM: Implement a generic PWM framework
From: Bill Gatliff <bgat@billgatliff.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lars:

On Sun, Mar 6, 2011 at 12:16 AM, Lars-Peter Clausen <lars@metafoo.de> wrote:
>
> Two minor remarks on the documentation: You are not mentioning the functions
> arguments and there is no documentation on the sysfs interface at all.

Ok, will fix.

>> +static LIST_HEAD(pwm_device_list);
> The list is not used.

Fixed.

> sizeof(name)

Technically, sizeof is an operator and therefore the parentheses are
redundant.  But since everyone hates it when I leave them off, I put
them back.  :)

>> +     if (!p->ops->config_nosleep)
>> +             return -EINVAL;
>
> Would ENOSYS be more appropriate?

Yes.  Fixed.

>> +err:
>> +     dev_dbg(p->dev, "%s: config_mask %lu period_ticks %lu "
>> +             "duty_ticks %lu polarity %d\n",
>> +             __func__, c->config_mask, c->period_ticks,
>> +             c->duty_ticks, c->polarity);
>> +
>> +     if (ret)
>> +             return ret;
>
> This looks a bit confusing. Maybe it would be better to move the dev_dbg at the
> top of the function and the 'err' label at the end of the function.

That code clearly needs refactoring.  Fixed.

>> +     if (!p->ops->synchronize)
>> +             return -EINVAL;
> ENOSYS here too

Fixed.

>> +     if (!p->ops->unsynchronize)
>> +             return -EINVAL;
> and here.

Fixed.


>> +int pwm_set_handler(struct pwm_device *p, pwm_handler_t handler, void *data)
>> +{
>> +     struct pwm_config c;
>> +     int ret;
>> +
>> +     if (handler)
>> +             c.config_mask = BIT(PWM_CONFIG_ENABLE_CALLBACK);
>> +     else
>> +             c.config_mask = BIT(PWM_CONFIG_DISABLE_CALLBACK);
>> +
>> +     ret = pwm_config(p, &c);
>
> There is a chance for a race here. The device could fire, for example due to an
> irq, before the handler has been initalized.

Good catch.  Fixed.

>> +     if (!ret && handler) {
>> +             p->handler_data = data;
>> +             p->handler = handler;
>> +             INIT_WORK(&p->handler_work, pwm_handler);
>
> The INIT_WORK should probably into pwm_device_register.

It could, but it isn't needed unless a handler is used.  So I prefer
to leave it where it is.

>> +static ssize_t pwm_run_store(struct device *dev,
>> +                          struct device_attribute *attr,
>> +                          const char *buf, size_t len)
>> +{
>> +     struct pwm_device *p = dev_get_drvdata(dev);
>> +
>> +     if (!pwm_is_exported(p))
>> +             return -EINVAL;
>
> I'm not sure, but maybe -EPERM is better here.

I think you are probably right.  Fixed.

>> +
>> +     if (sysfs_streq(buf, "1"))
>> +             pwm_start(p);
>> +     else if (sysfs_streq(buf, "0"))
>> +             pwm_stop(p);
> Maybe return -EINVAL if it is neither 0 or 1.

Fixed.

>> +     if (!strict_strtoul(buf, 10, &duty_ns))
>> +             pwm_set_duty_ns(p, duty_ns);
>
> How about returning the error value of strict_strtou if it fails?

Good idea.  Fixed.

> So `cat request` requests the device and `echo > request` frees the device?
> Thats a bit odd in my opinion.

Yes, and no.

For comparison, GPIO pins are exported to userspace like this:

# echo 160 > /sys/class/gpio/export

That's convenient when you know the number of the GPIO pin you wish to
export.  Upon export, a directory /sys/class/gpio/gpio<pin> shows up.
Prior to the export request, if the directory doesn't exist then you
know that either nothing in userspace is using the pin.  If the
directory doesn't exist after the export request, then you know your
request failed--- probably because the kernel is using the pin.

The names for PWM devices are more complex.  To prevent needing to
know the name of the desired PWM channel in advance, the list of all
available PWM devices is always present in /sys/class/pwm.  Also, it
isn't an error for an application to want to read the PWM device state
(to update an instrument panel, for example) even when a kernel driver
is actively controlling the device itself.  So I can't do things
exactly how GPIO does them.

Once you identify the PWM device you are seeking, you read from its
.../request attribute to ask for permission to use it.  The response
you get back is either "sysfs" to state that userspace now controls
the PWM device, or the label provided by the kernel requester to
indicate that the kernel is using the device.

As long as (a) I want PWM device names to always be visible under
/sys/class/pwm, and (b) I want applications to be able to read-only
monitor PWM state even when the kernel is controlling the device, I
don't know how to make things work differently than I have implemented
without making things unnecessarily complicated.

Suggestions welcome.

>> +static struct class pwm_class = {
>> +     .name = "pwm",
>> +     .owner = THIS_MODULE,
>> +
>> +     .class_attrs = pwm_class_attrs,
>
> Just leaving it NULL should work, if you don't want any class attributes.

Today I don't want any attributes, but I might someday soon.  I don't
have any immediate plans, though...

>> +     d = class_find_device(&pwm_class, NULL, (char*)name, pwm_match_name);
>> +     if (d) {
>> +             ret = -EEXIST;
>> +             goto err_found_device;
>> +     }
> device_create should fail if a device with the same name already exits, so I'm
> not sure if it makes sense to do the check here.

I'm pretty sure you are right.  Fixed.

>> +     p->dev = device_create(&pwm_class, parent, MKDEV(0, 0), NULL, name);
> ... NULL, "%s", name);

I guess things would get ugly with my code if someone passed a name
that had a "%<something>" in it, no? :)

> Or you could use device_create_vargs and get rid of that scnprintf in pwm_register.

Ooh, that sounds interesting.  I'll look at that.

>
>> +     if (IS_ERR(p->dev)) {
>> +             ret = PTR_ERR(p->dev);
>> +             goto err_device_create;
>> +     }
> I think it would be better to embedd the device struct directly into the
> pwm_device struct. You could also remove the data field of the pwm_device
> struct and use dev_{get,set}_drvdata for pwm_{get,set}_drvdata.

Will look at that and follow up.

>> +     ret = sysfs_create_group(&p->dev->kobj, &pwm_device_attr_group);
>> +     if (ret)
>> +             goto err_create_group;
>
> It should be possible to use the classes dev_attrs here instead.

I tinkered with that early on, and ended up with the impression that
class attributes were applied to the class as a whole, and not each
member of the class.  Maybe I just messed up somewhere.  Will
investigate and follow up.

>> +     if (pwm_is_running(p) || pwm_is_requested(p)) {
>
> Is it possible that the pwm is running but not requested?

Belt-and-suspenders.  I put it there in case I screwed up the flags
somewhere.  Will take it back out.

>> +     FLAG_REGISTERED         = 0,
> Does the REGISTERED flag makes any sense, I mean are there any usecases for
> pwm_is_registered? Non registered pwm_devices should not be visible to the
> outside world, so if you got an pointer to an pwm_device outside of an
> pwm_device driver it should also be registered. And inside a pwm_device driver
> the driver should know whether it already registered the pwm_device or not.

I have it so that device drivers don't themselves have to keep track
of which of their individual devices failed to register during
initialization.  An example of that used to be in atmel-pwmc.c, but
then I cleaned up the code to make the flag unnecessary.

Will take it out.

>> +
>> +     int active_high;
> In the config you call it polarity, here you call it active_high. A consistent
> naming would be better in my opinion.

Fixed.


>> +struct pwm_device *gpio_pwm_create(int gpio);
>> +int gpio_pwm_destroy(struct pwm_device *p);
>
> These two definitions probably belong to the second patch.

Ok.


Thanks for the review!


b.g.
-- 
Bill Gatliff
bgat@billgatliff.com
