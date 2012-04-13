Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365Ab2DMQu1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 12:50:27 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:51420 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754795Ab2DMQuY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 12:50:24 -0400
MIME-Version: 1.0
In-Reply-To: <20120411072300.GA15759@core.coreip.homeip.net>
References: <20120403202432.GA18564@core.coreip.homeip.net>
	<20120411072300.GA15759@core.coreip.homeip.net>
Date: Fri, 13 Apr 2012 18:50:22 +0200
Message-ID: <CANq1E4TOG0wgzJ43px74204k9KgRWpDxRPJhC45BiAERTcwsxg@mail.gmail.com>
Subject: Re: [PATCH] Input: serio_raw - ensure we don't block in non-blocking read
From: David Herrmann <dh.herrmann@googlemail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, Wanlong Gao <gaowanlong@cn.fujitsu.com>,
        Che-Liang Chiou <clchiou@chromium.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry

On Wed, Apr 11, 2012 at 9:23 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Tue, Apr 03, 2012 at 01:24:33PM -0700, Dmitry Torokhov wrote:
>> Avoid calling wait_event_interruptible() if client requested non-blocking
>> read, since it is not guaranteed that another thread will not consume
>> event after we checked if serio_raw->head != serio_raw->tail.
>>
>> Also ensure we do not return 0 but keep waiting instead in blocking case,
>> when another thread steals "our" byte.
>>
>> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
>
> Anyone? It would be nice if someone could review my patches as well,
> otherwise we may end up with breakages...

I cannot test the driver as I don't have the devices, but I reviewed
it and it looks fine.

> Thanks.

Regards
David

>> ---
>>  drivers/input/serio/serio_raw.c |   43 ++++++++++++++++++++++----------------
>>  1 files changed, 25 insertions(+), 18 deletions(-)
>>
>> diff --git a/drivers/input/serio/serio_raw.c b/drivers/input/serio/serio_raw.c
>> index 4494233..094d6fb 100644
>> --- a/drivers/input/serio/serio_raw.c
>> +++ b/drivers/input/serio/serio_raw.c
>> @@ -165,31 +165,38 @@ static ssize_t serio_raw_read(struct file *file, char __user *buffer,
>>       struct serio_raw *serio_raw = client->serio_raw;
>>       char uninitialized_var(c);
>>       ssize_t read = 0;
>> -     int retval;
>> +     int error = 0;
>>
>> -     if (serio_raw->dead)
>> -             return -ENODEV;
>> +     do {
>> +             if (serio_raw->dead)
>> +                     return -ENODEV;
>>
>> -     if (serio_raw->head == serio_raw->tail && (file->f_flags & O_NONBLOCK))
>> -             return -EAGAIN;
>> +             if (serio_raw->head == serio_raw->tail &&
>> +                 (file->f_flags & O_NONBLOCK))
>> +                     return -EAGAIN;
>>
>> -     retval = wait_event_interruptible(serio_raw->wait,
>> -                     serio_raw->head != serio_raw->tail || serio_raw->dead);
>> -     if (retval)
>> -             return retval;
>> +             if (count == 0)
>> +                     break;
>>
>> -     if (serio_raw->dead)
>> -             return -ENODEV;
>> +             while (read < count && serio_raw_fetch_byte(serio_raw, &c)) {
>> +                     if (put_user(c, buffer++)) {
>> +                             error = -EFAULT;
>> +                             goto out;
>> +                     }
>> +                     read++;
>> +             }
>>
>> -     while (read < count && serio_raw_fetch_byte(serio_raw, &c)) {
>> -             if (put_user(c, buffer++)) {
>> -                     retval = -EFAULT;
>> +             if (read)
>>                       break;
>> -             }
>> -             read++;
>> -     }
>>
>> -     return read ?: retval;
>> +             if (!(file->f_flags & O_NONBLOCK))
>> +                     error = wait_event_interruptible(serio_raw->wait,
>> +                                     serio_raw->head != serio_raw->tail ||
>> +                                     serio_raw->dead);
>> +     } while (!error);
>> +
>> +out:
>> +     return read ?: error;
>>  }
>>
>>  static ssize_t serio_raw_write(struct file *file, const char __user *buffer,
>> --
>> 1.7.7.6
>>
>
> --
> Dmitry
