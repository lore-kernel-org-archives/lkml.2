Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab1LOFlk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 00:41:40 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:34919 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab1LOFlj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 00:41:39 -0500
MIME-Version: 1.0
Reply-To: myungjoo.ham@gmail.com
In-Reply-To: <20111215010108.GA15650@suse.de>
References: <1323858508-27198-1-git-send-email-myungjoo.ham@samsung.com>
	<1323858508-27198-2-git-send-email-myungjoo.ham@samsung.com>
	<20111215010108.GA15650@suse.de>
Date: Thu, 15 Dec 2011 14:41:38 +0900
X-Google-Sender-Auth: q3YiTyGXT0wC4yLtLW43QBIlysk
Message-ID: <CAJ0PZbRRiMoEDEV5vwr9rREfSejA_hqLMDmLMBoUBZKjafYq1g@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] Extcon (external connector): import Android's
 switch class and modify.
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
        Mike Lockwood <lockwood@android.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>, NeilBrown <neilb@suse.de>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 10:01 AM, Greg KH <gregkh@suse.de> wrote:
> On Wed, Dec 14, 2011 at 07:28:26PM +0900, MyungJoo Ham wrote:
>> External connector class (extcon) is based on and an extension of Android
>> kernel's switch class located at linux/drivers/switch/.
>> This patch provides the before-extension switch class moved to the
>> location where the extcon will be located (linux/drivers/extcon/).
>>
>> The before-extension class, switch class of Android kernel, commits
>> imported are:
>>
>> switch: switch class and GPIO drivers.
>> Author: Mike Lockwood <lockwood@android.com>
>>
>> switch: gpio: Don't call request_irq with interrupts disabled
>> Author: Arve Hjønnevåg <arve@android.com>
>>
>> switch: Use device_create instead of device_create_drvdata.
>> Author: Arve Hjønnevåg <arve@android.com>
>>
>> switch_gpio: Add missing #include <linux/interrupt.h>
>> Author: Mike Lockwood <lockwood@android.com>
>>
>> In this patch, upon the commits of Android kernel, we have added:
>> - Relocated and renamed for extcon.
>> - Comments, module name, and author information are updated
>> - Code clean for successing patches
>> - Bugfix: enabling write access without write functions
>
> Nice, but if we accept this, will someone also make the needed changes
> to the Android userspace code to handle the user api changes that this
> causes?

I have no idea about how Android will react to this as I have no
developmental experiences with Android.
However, from the perspective of general userspace, this modification
incurs path changes (/sys/class/switch/.... to /sys/class/extcon/...)
only.

>
>> --- /dev/null
>> +++ b/drivers/extcon/Kconfig
>> @@ -0,0 +1,22 @@
>> +menuconfig EXTCON
>> +     bool "External Connector Class (extcon) support"
>
> Why can't this be a module?
>

I also think this can be a module as well. I'm wondering why I've
changed it to bool from RFC patchset's tristate. ;(

>> +
>> +struct class *extcon_class;
>> +static atomic_t device_count;
>
> this should use the idr subsystem, not just an atomic variable, as you
> aren't properly handling devices being removed (which is something
> overall this core code needs to properly handle.)
>

It seems that I need to rewrite extcon_dev_register/unregister
functions. I was simply reusing that part from android kernel;
however, this time, they do look ugly.

>
>> +
>> +static ssize_t state_show(struct device *dev, struct device_attribute *attr,
>> +             char *buf)
>> +{
>> +     struct extcon_dev *edev = (struct extcon_dev *)
>> +             dev_get_drvdata(dev);
>> +
>> +     if (edev->print_state) {
>> +             int ret = edev->print_state(edev, buf);
>> +
>> +             if (ret >= 0)
>> +                     return ret;
>> +             /* Use default if failed */
>> +     }
>> +     return sprintf(buf, "%u\n", edev->state);
>> +}
>> +
>> +static ssize_t name_show(struct device *dev, struct device_attribute *attr,
>> +             char *buf)
>> +{
>> +     struct extcon_dev *edev = (struct extcon_dev *)
>> +             dev_get_drvdata(dev);
>> +
>> +     if (edev->print_name) {
>> +             int ret = edev->print_name(edev, buf);
>> +             if (ret >= 0)
>> +                     return ret;
>> +     }
>> +     return sprintf(buf, "%s\n", edev->name);
>> +}
>
> Why is the name somehow different from the device name in the first
> place?

I'll let dev_get_name() return what "name_show" wants. I guess I'll
keep name_show sysfs entry to be compatible with Android kernel
(except for the path) and keep the optional "print_name" callback.


>
>> +/**
>> + * extcon_set_state() - Set the cable attach states of the extcon device.
>> + * @edev:    the extcon device
>> + * @state:   new cable attach status for @edev
>> + */
>> +void extcon_set_state(struct extcon_dev *edev, u32 state)
>> +{
>> +     char name_buf[120];
>> +     char state_buf[120];
>> +     char *prop_buf;
>> +     char *envp[3];
>> +     int env_offset = 0;
>> +     int length;
>> +
>> +     if (edev->state != state) {
>> +             edev->state = state;
>> +
>> +             prop_buf = (char *)get_zeroed_page(GFP_KERNEL);
>> +             if (prop_buf) {
>> +                     length = name_show(edev->dev, NULL, prop_buf);
>
> Heh, nice hack, but wouldn't it just be simpler to call the
> evdev->print_name() function directly here?

I didn't do so because print_name callback is optional.

>
>> +                     if (length > 0) {
>> +                             if (prop_buf[length - 1] == '\n')
>> +                                     prop_buf[length - 1] = 0;
>> +                             snprintf(name_buf, sizeof(name_buf),
>> +                                     "SWITCH_NAME=%s", prop_buf);
>> +                             envp[env_offset++] = name_buf;
>> +                     }
>> +                     length = state_show(edev->dev, NULL, prop_buf);
>
> Same here.

Same here. print_state is also optional. (and I expect many won't use
these optional callbacks at least including MAX8997, MAX77693, and
FSA9480)

>> +                     printk(KERN_ERR "out of memory in extcon_set_state\n");
>
> dev_err()?

Yes, that looks better.

>
>> +                     kobject_uevent(&edev->dev->kobj, KOBJ_CHANGE);
>
> I really dislike using uevents, what is listening for them?  Are you
> hooked into udev's event chain in userspace to properly handle this?  If
> not, what is the point of sending them?

It is to let userspace processes get notified for the events in extcon.
Do you think sysfs_notify() would be better for this purpose?

>
>> +
>> +     ret = device_create_file(edev->dev, &dev_attr_state);
>> +     if (ret < 0)
>> +             goto err_create_file_1;
>> +     ret = device_create_file(edev->dev, &dev_attr_name);
>> +     if (ret < 0)
>> +             goto err_create_file_2;
>
> Why not use default attributes for the class?  That makes this code go
> away, and solves the error handling issues as well.

Thanks for the remind! I'll use extcon_class->dev_attrs.

>> + */
>> +void extcon_dev_unregister(struct extcon_dev *edev)
>> +{
>> +     device_remove_file(edev->dev, &dev_attr_name);
>> +     device_remove_file(edev->dev, &dev_attr_state);
>> +     device_destroy(extcon_class, MKDEV(0, edev->index));
>> +     dev_set_drvdata(edev->dev, NULL);
>> +}
>> +EXPORT_SYMBOL_GPL(extcon_dev_unregister);
>
> As stated before, you forgot to decrement the count, but use the idr
> subsystem and remember to decrement it here also.
>

Sure, I'll revise unregister function.


Thank you so much.


Cheers!
MyungJoo

-- 
MyungJoo Ham, Ph.D.
Mobile Software Platform Lab, DMC Business, Samsung Electronics
