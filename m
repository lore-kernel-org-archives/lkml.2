Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314Ab2BTGRl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 01:17:41 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45870 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933Ab2BTGRk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 01:17:40 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of myungjoo.ham@gmail.com designates 10.42.157.68 as permitted sender) smtp.mail=myungjoo.ham@gmail.com; dkim=pass header.i=myungjoo.ham@gmail.com
MIME-Version: 1.0
Reply-To: myungjoo.ham@gmail.com
In-Reply-To: <20120220015400.GD3194@opensource.wolfsonmicro.com>
References: <1327021317-10222-1-git-send-email-myungjoo.ham@samsung.com>
	<1328856038-21912-1-git-send-email-myungjoo.ham@samsung.com>
	<1328856038-21912-2-git-send-email-myungjoo.ham@samsung.com>
	<20120220015400.GD3194@opensource.wolfsonmicro.com>
Date: Mon, 20 Feb 2012 15:17:39 +0900
X-Google-Sender-Auth: GdexOXU3kT1WIkmYChvF88OH34I
Message-ID: <CAJ0PZbQjRt0-3+eUUdKkxrK=Jrv-_Q0i3aUx7JHJ9XsNUFLf8w@mail.gmail.com>
Subject: Re: [PATCH v5 1/5] Extcon (external connector): import Android's
 switch class and modify.
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, NeilBrown <neilb@suse.de>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Mike Lockwood <lockwood@android.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnevag?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>, Greg KH <gregkh@suse.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        John Stultz <john.stultz@linaro.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 20, 2012 at 10:54 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Fri, Feb 10, 2012 at 03:40:34PM +0900, MyungJoo Ham wrote:
>> External connector class (extcon) is based on and an extension of Android
>> kernel's switch class located at linux/drivers/switch/.
>
> This looks good though I've skipped some bits as it's taken me far too
> long to get round to reviewing, it'd be really good if we could get it
> into 3.4 at least in staging if not in fully.  I don't know if arm-soc
> might be a good route if there's some concerns?  A few things below but
> they're relatively minor.

Yeah. I guess arm-soc would be fine. I'll send thru arm-soc as well next time.

>
> One thing I'd suggest is splitting the GPIO implementation into a
> separate patch, mostly just to reduce the size of the initial patch for
> ease of review.

Ok, I've splitted gpio implementation for the next iteration.

>
>> +     if (edev->state != state) {
>> +             edev->state = state;
>> +
>> +             prop_buf = (char *)get_zeroed_page(GFP_KERNEL);
>> +             if (prop_buf) {
>
> Is the cast really needed here?

Unless we have that cast, we get:
drivers/extcon/extcon_class.c:89:12: warning: assignment makes pointer
from integer without a cast

>
>> +static int create_extcon_class(void)
>> +{
>> +     if (!extcon_class) {
>> +             extcon_class = class_create(THIS_MODULE, "extcon");
>> +             if (IS_ERR(extcon_class))
>> +                     return PTR_ERR(extcon_class);
>> +             extcon_class->dev_attrs = extcon_attrs;
>
> I thought we were trying to remove classes, though I'm not sure if we're
> actually at the point where that's happening yet?  Greg?
>

Hmm.. I remember I was recommended to use classes some time ago (just
a few months ago) especially for adding sysfs entries. Things have
been changed already?

>> +static int create_extcon_class_for_android(void)
>> +{
>> +     if (!extcon_class_for_android) {
>> +             extcon_class_for_android = class_create(THIS_MODULE, "switch");
>> +             if (IS_ERR(extcon_class_for_android))
>> +                     return PTR_ERR(extcon_class_for_android);
>> +             extcon_class_for_android->dev_attrs = extcon_attrs;
>> +     }
>> +     return 0;
>> +}
>
> Might be better to put this as a separate Kconfig option or just leave
> it as an out of tree patch (given how trivial it is).  We're going to
> end up renaming a bunch of the classes anyway I expect...

Then, would it be proper to put "for-android" features surrounded by
#ifdef CONFIG_ANDROID ?

>
>> +static int __init extcon_class_init(void)
>> +{
>> +     return create_extcon_class();
>> +}
>> +
>> +static void __exit extcon_class_exit(void)
>> +{
>> +     class_destroy(extcon_class);
>> +
>> +     if (extcon_class_for_android)
>> +             class_destroy(extcon_class_for_android);
>> +}
>> +
>> +module_init(extcon_class_init);
>> +module_exit(extcon_class_exit);
>
> Ideally these should go next to the functions.

Yes..

>
>> +static irqreturn_t gpio_irq_handler(int irq, void *dev_id)
>> +{
>> +     struct gpio_extcon_data *extcon_data =
>> +         (struct gpio_extcon_data *)dev_id;
>> +
>> +     schedule_work(&extcon_data->work);
>> +     return IRQ_HANDLED;
>> +}
>
> Given that all this does is schedule some work it'd seem useful to make
> this a threaded IRQ and just do the work directly in the interrupt
> handler.  Though on the other hand we don't have any debounce here so
> perhaps it's even better to allow the user to specify a debunce time in
> the platform data and change this to schedule_delayed_work() to
> implement it?

I looks like adding a debounce time would be useful. I'll let it use
delayed_work.
I'll do the same for adc_jack, too, though I'm thinking about
submitting adc_jack later seperatedly from this patchset.


>
>> +static ssize_t extcon_gpio_print_state(struct extcon_dev *edev, char *buf)
>> +{
>> +     struct gpio_extcon_data *extcon_data =
>> +             container_of(edev, struct gpio_extcon_data, edev);
>> +     const char *state;
>> +     if (extcon_get_state(edev))
>> +             state = extcon_data->state_on;
>> +     else
>> +             state = extcon_data->state_off;
>> +
>> +     if (state)
>> +             return sprintf(buf, "%s\n", state);
>> +     return -1;
>
> -EINVAL or something?

I'll use -EINVAL and add NULL check at probe function.

>
>> +     extcon_data = kzalloc(sizeof(struct gpio_extcon_data), GFP_KERNEL);
>> +     if (!extcon_data)
>> +             return -ENOMEM;
>
> devm_kzalloc().

I'll try devm_kzalloc and devm_kfree.

>
>> +     ret = request_irq(extcon_data->irq, gpio_irq_handler,
>> +                       IRQF_TRIGGER_LOW, pdev->name, extcon_data);
>> +     if (ret < 0)
>> +             goto err_request_irq;
>
> request_any_context_irq() would allow use with any GPIO - sometimes the
> GPIOs for accessory detection are on GPIO expanders which need threaded
> context and there's nothing in the code that minds.  It would also be a
> good idea if the user could specify the triggers, lots of circuits need
> edge triggers for example.

Letting users specify flags looks much better than fixing the flag as
IRQF_TRIGGER_LOW. And I'll replease request_irq with
request_any_context_irq as you've mentioned.

>
>> +static int __init gpio_extcon_init(void)
>> +{
>> +     return platform_driver_register(&gpio_extcon_driver);
>> +}
>> +
>> +static void __exit gpio_extcon_exit(void)
>> +{
>> +     platform_driver_unregister(&gpio_extcon_driver);
>> +}
>> +
>> +module_init(gpio_extcon_init);
>> +module_exit(gpio_extcon_exit);
>
> module_platform_driver().

Oh.. yes, another modern idiom. :)



Thanks so much!

Cheers!
MyungJoo.

-- 
MyungJoo Ham, Ph.D.
Mobile Software Platform Lab, DMC Business, Samsung Electronics
