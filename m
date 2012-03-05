Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166Ab2CEWMI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 17:12:08 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:42353 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754711Ab2CEWMF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 17:12:05 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of grundler@google.com designates 10.182.37.99 as permitted sender) smtp.mail=grundler@google.com; dkim=pass header.i=grundler@google.com
MIME-Version: 1.0
In-Reply-To: <CAEYUcX0ofOgv+G2aUaqcpEZhJU7UmBpxTZ0ye1FkcWdkHLR0MA@mail.gmail.com>
References: <1330967759-18660-1-git-send-email-grundler@chromium.org>
	<CAEYUcX0ofOgv+G2aUaqcpEZhJU7UmBpxTZ0ye1FkcWdkHLR0MA@mail.gmail.com>
Date: Mon, 5 Mar 2012 14:12:04 -0800
X-Google-Sender-Auth: xCRvAD4Z4xkDR0jaciFIIBWoFRo
Message-ID: <CANEJEGs-BG4Dv6m0f0r+bue=hg+JWJSw4fxQKFYivkxf6qOA2Q@mail.gmail.com>
Subject: Re: [PATCH] staging:iio:tsl2563 rewrite probe error handling
From: Grant Grundler <grundler@chromium.org>
To: Bryan Freed <bfreed@chromium.org>
Cc: Jonathan Cameron <jic23@cam.ac.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Benson Leung <bleung@chromium.org>, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 5, 2012 at 1:53 PM, Bryan Freed <bfreed@chromium.org> wrote:
> Looks good to me, too,

Thanks for reviewing!

> but couldn't we get rid of one fail state (fail3) by
> reversing the order of schedule_delayed_work() and iio_device_register()?

My focus on this patch was to get a driver to load/unload properly and
avoid restructuring bits that can be deferred to later patches.

I had the same thought and considered this. The problem is I don't
understand or have time to investigate the locking that is hinted at
in the comment preceding the call to schedule_delayed_work(). I don't
understand what locking they are referring to since interrupts are in
fact enabled by the time the delayed work function is invoked.

I have to wonder if the comment is left over from when the function
was directly called instead of "delayed work".  ie race condition
exists regardless of when we call schedule_delayed_work().

> Reviewed-by: Bryan Freed <bfreed@chromium.org>

Thanks! :)

cheers,
grant

>
> bryan.
>
> On Mon, Mar 5, 2012 at 9:15 AM, Grant Grundler <grundler@chromium.org>
> wrote:
>>
>> tsl2563 probe function has two minor issues with it's error handling
>> paths:
>> 1) it is silent (did not report errors to dmesg)
>> 2) did not return failure code (mixed up use of ret and err)
>>
>> and two major issues:
>> 3) goto fail2 would corrupt a free memory pool ("double free")
>> 4) device registration failure did NOT cancel/flush delayed work.
>>   (and thus dereference a freed data structure later)
>>
>> The "double free" is subtle and was introduced with this change:
>>    Author: Jonathan Cameron <jic23@cam.ac.uk>
>>    Date:   Mon Apr 18 12:58:55 2011 +0100
>>    staging:iio:tsl2563 take advantage of new iio_device_allocate private
>> data.
>>
>> Originally, chip was allocated seperately. Now it's appended to the
>> indio_dev by iio_allocate_device(sizeof(*chip)). So we only need one
>> kfree call as well (in iio_free_device()).
>>
>> Signed-off-by: Grant Grundler <grundler@chromium.org>
>> ---
>>  Gory details of tracking this down are here:
>>    http://crosbug.com/26819
>>
>>  Despite iio_device_registration failing, system can at least now boot.
>>  Will follow up with a fix to "double register : in_intensity_both_raw"
>>  error that is included in the bug report.
>>
>>  drivers/staging/iio/light/tsl2563.c |   39
>> +++++++++++++++++++++++-----------
>>  1 files changed, 26 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/staging/iio/light/tsl2563.c
>> b/drivers/staging/iio/light/tsl2563.c
>> index 7e984bc..bf6498b 100644
>> --- a/drivers/staging/iio/light/tsl2563.c
>> +++ b/drivers/staging/iio/light/tsl2563.c
>> @@ -705,7 +705,6 @@ static int __devinit tsl2563_probe(struct i2c_client
>> *client,
>>        struct tsl2563_chip *chip;
>>        struct tsl2563_platform_data *pdata = client->dev.platform_data;
>>        int err = 0;
>> -       int ret;
>>        u8 id = 0;
>>
>>        indio_dev = iio_allocate_device(sizeof(*chip));
>> @@ -719,13 +718,15 @@ static int __devinit tsl2563_probe(struct i2c_client
>> *client,
>>
>>        err = tsl2563_detect(chip);
>>        if (err) {
>> -               dev_err(&client->dev, "device not found, error %d\n",
>> -err);
>> +               dev_err(&client->dev, "detect error %d\n", -err);
>>                goto fail1;
>>        }
>>
>>        err = tsl2563_read_id(chip, &id);
>> -       if (err)
>> +       if (err) {
>> +               dev_err(&client->dev, "read id error %d\n", -err);
>>                goto fail1;
>> +       }
>>
>>        mutex_init(&chip->lock);
>>
>> @@ -748,40 +749,52 @@ static int __devinit tsl2563_probe(struct i2c_client
>> *client,
>>        indio_dev->num_channels = ARRAY_SIZE(tsl2563_channels);
>>        indio_dev->dev.parent = &client->dev;
>>        indio_dev->modes = INDIO_DIRECT_MODE;
>> +
>>        if (client->irq)
>>                indio_dev->info = &tsl2563_info;
>>        else
>>                indio_dev->info = &tsl2563_info_no_irq;
>> +
>>        if (client->irq) {
>> -               ret = request_threaded_irq(client->irq,
>> +               err = request_threaded_irq(client->irq,
>>                                           NULL,
>>                                           &tsl2563_event_handler,
>>                                           IRQF_TRIGGER_RISING |
>> IRQF_ONESHOT,
>>                                           "tsl2563_event",
>>                                           indio_dev);
>> -               if (ret)
>> -                       goto fail2;
>> +               if (err) {
>> +                       dev_err(&client->dev, "irq request error %d\n",
>> -err);
>> +                       goto fail1;
>> +               }
>>        }
>> +
>>        err = tsl2563_configure(chip);
>> -       if (err)
>> -               goto fail3;
>> +       if (err) {
>> +               dev_err(&client->dev, "configure error %d\n", -err);
>> +               goto fail2;
>> +       }
>>
>>        INIT_DELAYED_WORK(&chip->poweroff_work, tsl2563_poweroff_work);
>> +
>>        /* The interrupt cannot yet be enabled so this is fine without lock
>> */
>>        schedule_delayed_work(&chip->poweroff_work, 5 * HZ);
>>
>> -       ret = iio_device_register(indio_dev);
>> -       if (ret)
>> +       err = iio_device_register(indio_dev);
>> +       if (err) {
>> +               dev_err(&client->dev, "iio registration error %d\n",
>> -err);
>>                goto fail3;
>> +       }
>>
>>        return 0;
>> +
>>  fail3:
>> +       cancel_delayed_work(&chip->poweroff_work);
>> +       flush_scheduled_work();
>> +fail2:
>>        if (client->irq)
>>                free_irq(client->irq, indio_dev);
>> -fail2:
>> -       iio_free_device(indio_dev);
>>  fail1:
>> -       kfree(chip);
>> +       iio_free_device(indio_dev);
>>        return err;
>>  }
>>
>> --
>> 1.7.3.4
>>
>
