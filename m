Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab2BNCWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 21:22:18 -0500
Received: from mail-lpp01m020-f174.google.com ([209.85.217.174]:58244 "EHLO
	mail-lpp01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751515Ab2BNCWQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 21:22:16 -0500
MIME-Version: 1.0
Reply-To: myungjoo.ham@gmail.com
In-Reply-To: <20120210162512.GF6472@opensource.wolfsonmicro.com>
References: <1327021317-10222-1-git-send-email-myungjoo.ham@samsung.com>
	<1328856038-21912-1-git-send-email-myungjoo.ham@samsung.com>
	<1328856038-21912-6-git-send-email-myungjoo.ham@samsung.com>
	<20120210162512.GF6472@opensource.wolfsonmicro.com>
Date: Tue, 14 Feb 2012 11:22:14 +0900
X-Google-Sender-Auth: 7WxZ3Ew3AfWjWveA0eYzyHGLEOU
Message-ID: <CAJ0PZbQNBFT0WS6o_NokXhtif0K8KBez+asDgP=0RDeizfGokg@mail.gmail.com>
Subject: Re: [PATCH v5 5/5] Extcon: adc-jack driver to support 3.5 pi or
 simliar devices
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

On Sat, Feb 11, 2012 at 1:25 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Fri, Feb 10, 2012 at 03:40:38PM +0900, MyungJoo Ham wrote:
>> External connector devices that decides connection information based on
>> ADC values may use adc-jack device driver. The user simply needs to
>> provide a table of adc range and connection states. Then, extcon
>> framework will automatically notify others.
>
> This really should be done in terms of the IIO in-kernel framework.

The ADC part may be done in IIO. However, the intention of this device
driver is to provide extcon interface to any ADC drivers, not
providing an ADC device driver. If we are going to implement this in
the ADC driver in IIO, we will need to write the given code in every
ADC driver used for analog ports.

>
>> +     /* Check the length of array and set num_cables */
>> +     for (i = 0; data->edev.supported_cable[i]; i++)
>> +             ;
>> +     if (i == 0 || i > SUPPORTED_CABLE_MAX) {
>
> Can we not avoid the hard limit?

Without that limit, we won't be able to easily express binary cable
status (u32) with the extcon framework. At least, we will need to
forget about setting the status with u32 values.

Anyway, I can remove the checking SUPPORT_CABLE_MAX part at probe.

>
>> +     /* Check the length of array and set num_conditions */
>> +     for (i = 0; data->adc_condition[i].state; i++)
>> +             ;
>> +     data->num_conditions = i;
>
> It'd seem nicer to just specify the length in the parameters, less error
> prone.

Whether to put a NULL at the end or to provide a size variable seems
quite confusing in Linux kernel. Some use the former, some use the
latter. Which one is sort of "standard" now? I felt that the former is
being more popular these days, anyway.

>
>> +     if (pdata->irq) {
>> +             data->irq = pdata->irq;
>> +
>> +             err = request_threaded_irq(data->irq, NULL,
>> +                                        adc_jack_irq_thread,
>> +                                        pdata->irq_flags, pdata->name,
>> +                                        data);
>
> Since all this does is schedule a delayed work there's no reason to
> bother with a threaded IRQ and this could be request_any_context_irq().

Thanks. I'll update it.

>
>> +     err = extcon_dev_register(&data->edev, &pdev->dev);
>> +     if (err)
>> +             goto err_irq;
>
> What happens if the interrupt fires prior to this...
>
>> +     data->ready = true;
>
> ...ah, that's what this is about.  It'd seem cleaner to just reverse the
> request and registration.

If it goes to err_irq, it reverses the request of IRQ. data->ready is
there not to react to a fired IRQ before free-ing the IRQ.

>
>> +     goto out;
>
> More idiomatic to have a return statement here.

Yup.

>
>> +static int __devexit adc_jack_remove(struct platform_device *pdev)
>> +{
>> +     struct adc_jack_data *data = platform_get_drvdata(pdev);
>> +
>> +     extcon_dev_unregister(&data->edev);
>> +     if (data->irq)
>> +             free_irq(data->irq, data);
>
> The interrupt needs to be freed prior to the device unregistration
> otherwise they may race.

Yes. Thanks.

>
>> +static int __init adc_jack_init(void)
>> +{
>> +     return platform_driver_register(&adc_jack_driver);
>> +}
>> +
>> +static void __exit adc_jack_exit(void)
>> +{
>> +     platform_driver_unregister(&adc_jack_driver);
>> +}
>
> module_platform_driver().

Oh.. this is good. :)

>
>> +     unsigned long handling_delay; /* in jiffies */
>
> I'd suggest calling this "debounce" instead, it seems more idiomatic.

Yes, it seems so. I'll fix it.


Thank you.




Cheers!
MyungJoo.

-- 
MyungJoo Ham, Ph.D.
System S/W Lab, S/W Center, Samsung Electronics
