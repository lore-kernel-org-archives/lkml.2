Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601Ab2FRSuQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 14:50:16 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:35713 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861Ab2FRSuN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 14:50:13 -0400
MIME-Version: 1.0
In-Reply-To: <20120617003334.765f6226@neptune.home>
References: <1339884266-9201-1-git-send-email-dh.herrmann@googlemail.com>
	<1339884266-9201-6-git-send-email-dh.herrmann@googlemail.com>
	<20120617003334.765f6226@neptune.home>
Date: Mon, 18 Jun 2012 20:50:12 +0200
Message-ID: <CANq1E4RZoxUFJ+Ofx_MVu8xBvRdsS2kmBusKWEitEjPBwukpkA@mail.gmail.com>
Subject: Re: [PATCH 05/10] fblog: add framebuffer helpers
From: David Herrmann <dh.herrmann@googlemail.com>
To: =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: linux-serial@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bruno

On Sun, Jun 17, 2012 at 12:33 AM, Bruno Prémont
<bonbons@linux-vserver.org> wrote:
> On Sun, 17 June 2012 David Herrmann <dh.herrmann@googlemail.com> wrote:
>> These helpers scan the system for all available framebuffers and register
>> or unregister them. This is needed during startup and stopping fblog so we
>> are aware of all connected displays.
>>
>> The third helper handles mode changes by rescanning the mode and adjusting
>> the buffer size.
>>
>> Signed-off-by: David Herrmann <dh.herrmann@googlemail.com>
>> ---
>>  drivers/video/console/fblog.c |   29 +++++++++++++++++++++++++++++
>>  1 file changed, 29 insertions(+)
>>
>> diff --git a/drivers/video/console/fblog.c b/drivers/video/console/fblog.c
>> index e790971..7d4032e 100644
>> --- a/drivers/video/console/fblog.c
>> +++ b/drivers/video/console/fblog.c
>> @@ -399,6 +399,35 @@ static void fblog_unregister(struct fblog_fb *fb)
>>       kfree(fb);
>>  }
>>
>> +static void fblog_register_all(void)
>> +{
>> +     int i;
>> +
>> +     for (i = 0; i < FB_MAX; ++i)
>> +             fblog_register(registered_fb[i]);
>
> You should take registration_lock mutex for accessing registered_fb[],
> even better would be to make use of get_fb_info() and put_fb_info()

Indeed, I will change it to use get_fb_info()/put_fb_info().

Btw., is it safe to call console_lock() during
FB_EVENT_FB_(UN)REGISTERED? I definitely need the console lock when
calling fblog_register() but I am not sure whether all fb-drivers lock
the console during "(un)register_framebuffer()". Otherwise, I would
have to avoid redrawing the console inside of fblog_register().

>> +}
>> +
>> +static void fblog_unregister_all(void)
>> +{
>> +     int i;
>> +
>> +     for (i = 0; i < FB_MAX; ++i)
>> +             fblog_unregister(fblog_info2fb(registered_fb[i]));
>
> Same here.
>
> Though for unregistering I'm wondering why you still scan through
> registered_fb[], you should just scan your fblog_fbs[] array!

Oops, you're right. I will change it.

> But here again, make sure to have proper locking to not get races with
> registration of new framebuffers or removal of existing ones via
> notifications.
>
>> +}
>> +
>> +static void fblog_refresh(struct fblog_fb *fb)
>> +{
>> +     unsigned int width, height;
>> +
>> +     if (!fb || !fb->font)
>> +             return;
>> +
>> +     width = fb->info->var.xres / fb->font->width;
>> +     height = fb->info->var.yres / fb->font->height;
>> +     fblog_buf_resize(&fb->buf, width, height);
>> +     fblog_redraw(fb);
>> +}
>> +
>
> All these new functions are still unused, for easier following of your
> patch series it would be nice to have them connected when they are
> introduced as otherwise on has to search all following patches for
> finding possible users.

I have to admit the split was crap. I am sorry. I will recreate the
patchset with a proper split. Thanks!

>>  static int __init fblog_init(void)
>>  {
>>       return 0;
>
> Bruno

Thanks for reviewing, regards
David
