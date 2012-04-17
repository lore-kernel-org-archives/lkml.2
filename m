Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab2DQJP1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 05:15:27 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59514 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755484Ab2DQJPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 05:15:25 -0400
MIME-Version: 1.0
In-Reply-To: <CANJuy2KgOX=2Oc9Uaf1TGRAeyXt0UjdjU-o-yo+NVUYxKmk_4g@mail.gmail.com>
References: <20120403202432.GA18564@core.coreip.homeip.net> <CANJuy2KgOX=2Oc9Uaf1TGRAeyXt0UjdjU-o-yo+NVUYxKmk_4g@mail.gmail.com>
From: Che-liang Chiou <clchiou@chromium.org>
Date: Tue, 17 Apr 2012 17:14:44 +0800
X-Google-Sender-Auth: OViHPYHvGKN0IV9r98yAdUqxRp0
Message-ID: <CANJuy2KVxAKFETi4YGAcBFnoop-eBLK+VvUVonuy8ZCm+VeZcg@mail.gmail.com>
Subject: Re: [PATCH] Input: serio_raw - ensure we don't block in non-blocking read
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, Wanlong Gao <gaowanlong@cn.fujitsu.com>,
        David Herrmann <dh.herrmann@googlemail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q3H9FaSB008946

Reviewed-by: Che-Liang Chiou <clchiou@chromium.org>

On Tue, Apr 17, 2012 at 4:56 PM, Che-liang Chiou <clchiou@chromium.org> wrote:
> I didn't test the patch, but the logic looks fine to me.
>
> On Wed, Apr 4, 2012 at 4:24 AM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
>> Avoid calling wait_event_interruptible() if client requested non-blocking
>> read, since it is not guaranteed that another thread will not consume
>> event after we checked if serio_raw->head != serio_raw->tail.
>>
>> Also ensure we do not return 0 but keep waiting instead in blocking case,
>> when another thread steals "our" byte.
>>
>> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
>> ---
>>  drivers/input/serio/serio_raw.c |   43 ++++++++++++++++++++++----------------
>>  1 files changed, 25 insertions(+), 18 deletions(-)
>>
>> diff --git a/drivers/input/serio/serio_raw.c b/drivers/input/serio/serio_raw.c
>> index 4494233..094d6fb 100644
>> --- a/drivers/input/serio/serio_raw.c
>> +++ b/drivers/input/serio/serio_raw.c
>> @@ -165,31 +165,38 @@ static ssize_t serio_raw_read(struct file *file, char __user *buffer,
>>        struct serio_raw *serio_raw = client->serio_raw;
>>        char uninitialized_var(c);
>>        ssize_t read = 0;
>> -       int retval;
>> +       int error = 0;
>>
>> -       if (serio_raw->dead)
>> -               return -ENODEV;
>> +       do {
>> +               if (serio_raw->dead)
>> +                       return -ENODEV;
>>
>> -       if (serio_raw->head == serio_raw->tail && (file->f_flags & O_NONBLOCK))
>> -               return -EAGAIN;
>> +               if (serio_raw->head == serio_raw->tail &&
>> +                   (file->f_flags & O_NONBLOCK))
>> +                       return -EAGAIN;
>>
>> -       retval = wait_event_interruptible(serio_raw->wait,
>> -                       serio_raw->head != serio_raw->tail || serio_raw->dead);
>> -       if (retval)
>> -               return retval;
>> +               if (count == 0)
>> +                       break;
>>
>> -       if (serio_raw->dead)
>> -               return -ENODEV;
>> +               while (read < count && serio_raw_fetch_byte(serio_raw, &c)) {
>> +                       if (put_user(c, buffer++)) {
>> +                               error = -EFAULT;
>> +                               goto out;
>> +                       }
>> +                       read++;
>> +               }
>>
>> -       while (read < count && serio_raw_fetch_byte(serio_raw, &c)) {
>> -               if (put_user(c, buffer++)) {
>> -                       retval = -EFAULT;
>> +               if (read)
>>                        break;
>> -               }
>> -               read++;
>> -       }
>>
>> -       return read ?: retval;
>> +               if (!(file->f_flags & O_NONBLOCK))
>> +                       error = wait_event_interruptible(serio_raw->wait,
>> +                                       serio_raw->head != serio_raw->tail ||
>> +                                       serio_raw->dead);
>> +       } while (!error);
>> +
>> +out:
>> +       return read ?: error;
>>  }
>>
>>  static ssize_t serio_raw_write(struct file *file, const char __user *buffer,
>> --
>> 1.7.7.6
>>
>>
>> --
>> Dmitry
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
