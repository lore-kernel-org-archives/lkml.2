Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034Ab2HNLFO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 07:05:14 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:58619 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708Ab2HNLFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 07:05:12 -0400
MIME-Version: 1.0
In-Reply-To: <50284383.7020100@gmail.com>
References: <1344783205-2384-1-git-send-email-dh.herrmann@googlemail.com>
	<1344783205-2384-7-git-send-email-dh.herrmann@googlemail.com>
	<50284383.7020100@gmail.com>
Date: Tue, 14 Aug 2012 13:05:10 +0200
Message-ID: <CANq1E4Q+UvZ_koC0BbHrTrqaut96KV244JdHvHKxVWB6-9VFEw@mail.gmail.com>
Subject: Re: [PATCH 06/11] fblog: open fb on registration
From: David Herrmann <dh.herrmann@googlemail.com>
To: Ryan Mallon <rmallon@gmail.com>
Cc: linux-fbdev@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ryan

On Mon, Aug 13, 2012 at 2:00 AM, Ryan Mallon <rmallon@gmail.com> wrote:
> On 13/08/12 00:53, David Herrmann wrote:
>>  /*
>> + * fblog_open/close()
>> + * These functions manage access to the underlying framebuffer. While opened, we
>> + * have a valid reference to the fb and can use it for drawing operations. When
>> + * the fb is unregistered, we drop our reference and close the fb so it can get
>> + * deleted properly. We also mark it as dead so no further fblog_open() call
>> + * will succeed.
>> + * Both functions must be called with the fb->info->lock mutex held! But make
>> + * sure to lock it _before_ locking the fblog-registration-lock. Otherwise, we
>> + * will dead-lock with fb-registration.
>> + */
>> +
>> +static int fblog_open(struct fblog_fb *fb)
>> +{
>> +     int ret;
>> +
>> +     mutex_lock(&fb->lock);
>> +
>> +     if (test_bit(FBLOG_KILLED, &fb->flags)) {
>> +             ret = -ENODEV;
>> +             goto unlock;
>> +     }
>> +
>> +     if (test_bit(FBLOG_OPEN, &fb->flags)) {
>> +             ret = 0;
>> +             goto unlock;
>> +     }
>> +
>> +     if (!try_module_get(fb->info->fbops->owner)) {
>> +             ret = -ENODEV;
>> +             goto out_killed;
>> +     }
>> +
>> +     if (fb->info->fbops->fb_open && fb->info->fbops->fb_open(fb->info, 0)) {
>
> Should propagate the error here:
>
>         if (fb->info->fbops->fb_open) {
>                 ret = fb->info->fbops->fb_open(fb->info, 0);
>                 if (ret)
>                         gotou out_unref;
>         }

Nice catch, thanks.

>> +/*
>>   * fblog framebuffer list
>>   * The fblog_fbs[] array contains all currently registered framebuffers. If a
>>   * framebuffer is in that list, we always must make sure that we own a reference
>> @@ -77,6 +147,7 @@ static void fblog_do_unregister(struct fb_info *info)
>>
>>       fblog_fbs[info->node] = NULL;
>>
>> +     fblog_close(fb, true);
>>       device_del(&fb->dev);
>>       put_device(&fb->dev);
>
> device_unregister?

Heh, you already mentioned this in the previous patch. I definitely
need to fix that.

>>  }
>> @@ -99,6 +170,7 @@ static void fblog_do_register(struct fb_info *info, bool force)
>>               return;
>>
>>       fb->info = info;
>> +     mutex_init(&fb->lock);
>>       __module_get(THIS_MODULE);
>>       device_initialize(&fb->dev);
>>       fb->dev.class = fb_class;
>> @@ -113,6 +185,8 @@ static void fblog_do_register(struct fb_info *info, bool force)
>>               put_device(&fb->dev);
>>               return;
>>       }
>> +
>> +     fblog_open(fb);
>>  }
>
> This function should really return an errno value.

I never used the return value in my code but as mentioned in the
previous patches, fblog_scan() should check them. So yes, I will add
this.

Thanks!
David
