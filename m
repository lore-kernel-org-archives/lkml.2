Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757321Ab2CIDvL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 22:51:11 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:60051 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756080Ab2CIDvJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 22:51:09 -0500
MIME-Version: 1.0
In-Reply-To: <4F57465D.1000402@kernel.org>
References: <1330967759-18660-1-git-send-email-grundler@chromium.org>
	<4F57465D.1000402@kernel.org>
Date: Thu, 8 Mar 2012 19:51:07 -0800
X-Google-Sender-Auth: EEsY_C15P2MhUl35S6PBXvRs_fc
Message-ID: <CANEJEGvWm83ucH8RH5HK_otTae2AxpUsvLV1XDA9=-JOL1kMGQ@mail.gmail.com>
Subject: Re: [PATCH] staging:iio:tsl2563 rewrite probe error handling
From: Grant Grundler <grundler@chromium.org>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Jonathan Cameron <jic23@cam.ac.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Benson Leung <bleung@chromium.org>, Bryan Freed <bfreed@chromium.org>,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonathan!

On Wed, Mar 7, 2012 at 3:28 AM, Jonathan Cameron <jic23@kernel.org> wrote:
> Fundamentally an excellent patch fixing some real issues,

Thank you! :)

> but just
> because I'm in that sort of mood I'll be fussy about the fact it is
> one patch.
>
> To nitpick, I'd have prefered this to be two patches. First that fixes
> the issues and the second that adds the additional output.  Actually
> should probably have even had a third making the white space changes.

Yup - I see/understand why. I need to improve my git foo and work
habits so it's not hard to play with a series of smaller patches
rather than one patch that does everything to one function.

> In particular 'device not found' and 'device detect error' are both
> valid explanations.  Perhaps it's nice to have everything more
> consistent but that shouldn't have been in the same patch as some out
> and out fixes.  Fixes will probably get back ported to stable trees,
> error messages won't.
>
> Still,getting the fix in place is the most important thing so if Greg
> is willing to pick this up then it has my Ack.

Thanks!

BTW, the bug(s) I fixed with this patch showed up because 3.2.7 (and
predecessors) didn't have this patch:
    Author: Jonathan Cameron <jic23@cam.ac.uk>
    Date:   Wed Oct 26 17:27:36 2011 +0100

    staging:iio:light:tsl2563 both intensity channels have same chan_spec.

    Bug has been fixed for some time in the outofstaging tree, but
    didn't propogate back to here.

please consider adding this to linux-stable series.

cheers,
grant

>
> On 03/05/2012 05:15 PM, Grant Grundler wrote:
>> tsl2563 probe function has two minor issues with it's error handling paths:
>> 1) it is silent (did not report errors to dmesg)
>> 2) did not return failure code (mixed up use of ret and err)
>>
>> and two major issues:
>> 3) goto fail2 would corrupt a free memory pool ("double free")
>> 4) device registration failure did NOT cancel/flush delayed work.
>>    (and thus dereference a freed data structure later)
>>
>> The "double free" is subtle and was introduced with this change:
>>     Author: Jonathan Cameron <jic23@cam.ac.uk>
>>     Date:   Mon Apr 18 12:58:55 2011 +0100
>>     staging:iio:tsl2563 take advantage of new iio_device_allocate private data.
> oops.  Thanks for picking up on this one.
>>
>> Originally, chip was allocated seperately. Now it's appended to the
>> indio_dev by iio_allocate_device(sizeof(*chip)). So we only need one
>> kfree call as well (in iio_free_device()).
>>
>> Signed-off-by: Grant Grundler <grundler@chromium.org>
> Acked-by: Jonathan Cameron <jic23@kernel.org>
>> ---
>>  Gory details of tracking this down are here:
>>     http://crosbug.com/26819
>>
>>  Despite iio_device_registration failing, system can at least now boot.
>>  Will follow up with a fix to "double register : in_intensity_both_raw"
>>  error that is included in the bug report.
>>
>>  drivers/staging/iio/light/tsl2563.c |   39 +++++++++++++++++++++++-----------
>>  1 files changed, 26 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/staging/iio/light/tsl2563.c b/drivers/staging/iio/light/tsl2563.c
>> index 7e984bc..bf6498b 100644
>> --- a/drivers/staging/iio/light/tsl2563.c
>> +++ b/drivers/staging/iio/light/tsl2563.c
>> @@ -705,7 +705,6 @@ static int __devinit tsl2563_probe(struct i2c_client *client,
>>       struct tsl2563_chip *chip;
>>       struct tsl2563_platform_data *pdata = client->dev.platform_data;
>>       int err = 0;
>> -     int ret;
>>       u8 id = 0;
>>
>>       indio_dev = iio_allocate_device(sizeof(*chip));
>> @@ -719,13 +718,15 @@ static int __devinit tsl2563_probe(struct i2c_client *client,
>>
>>       err = tsl2563_detect(chip);
>>       if (err) {
>> -             dev_err(&client->dev, "device not found, error %d\n", -err);
>> +             dev_err(&client->dev, "detect error %d\n", -err);
>>               goto fail1;
>>       }
>>
>>       err = tsl2563_read_id(chip, &id);
>> -     if (err)
>> +     if (err) {
>> +             dev_err(&client->dev, "read id error %d\n", -err);
>>               goto fail1;
>> +     }
>>
>>       mutex_init(&chip->lock);
>>
>> @@ -748,40 +749,52 @@ static int __devinit tsl2563_probe(struct i2c_client *client,
>>       indio_dev->num_channels = ARRAY_SIZE(tsl2563_channels);
>>       indio_dev->dev.parent = &client->dev;
>>       indio_dev->modes = INDIO_DIRECT_MODE;
> Certainly no problem with white space here to make the sections of
> code more obvious, but it doesn't belong in a patch with bug fixes.
>> +
>>       if (client->irq)
>>               indio_dev->info = &tsl2563_info;
>>       else
>>               indio_dev->info = &tsl2563_info_no_irq;
>> +
>>       if (client->irq) {
>> -             ret = request_threaded_irq(client->irq,
>> +             err = request_threaded_irq(client->irq,
>>                                          NULL,
>>                                          &tsl2563_event_handler,
>>                                          IRQF_TRIGGER_RISING | IRQF_ONESHOT,
>>                                          "tsl2563_event",
>>                                          indio_dev);
>> -             if (ret)
>> -                     goto fail2;
>> +             if (err) {
>> +                     dev_err(&client->dev, "irq request error %d\n", -err);
>> +                     goto fail1;
>> +             }
>>       }
>> +
>>       err = tsl2563_configure(chip);
>> -     if (err)
>> -             goto fail3;
>> +     if (err) {
>> +             dev_err(&client->dev, "configure error %d\n", -err);
>> +             goto fail2;
>> +     }
>>
>>       INIT_DELAYED_WORK(&chip->poweroff_work, tsl2563_poweroff_work);
>> +
>>       /* The interrupt cannot yet be enabled so this is fine without lock */
>>       schedule_delayed_work(&chip->poweroff_work, 5 * HZ);
>>
>> -     ret = iio_device_register(indio_dev);
>> -     if (ret)
>> +     err = iio_device_register(indio_dev);
>> +     if (err) {
>> +             dev_err(&client->dev, "iio registration error %d\n", -err);
>>               goto fail3;
>> +     }
>>
>>       return 0;
>> +
>>  fail3:
>> +     cancel_delayed_work(&chip->poweroff_work);
>> +     flush_scheduled_work();
>> +fail2:
>>       if (client->irq)
>>               free_irq(client->irq, indio_dev);
>> -fail2:
>> -     iio_free_device(indio_dev);
>>  fail1:
>> -     kfree(chip);
>> +     iio_free_device(indio_dev);
>>       return err;
>>  }
>>
>
