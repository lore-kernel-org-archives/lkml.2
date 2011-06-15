Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab1FOHMw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 03:12:52 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49232 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851Ab1FOHMr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 03:12:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vaxY/8Kqauo/n/pi8xb6A1PNPzlTMj99llzmBtsxOgwDl4ZDOOI4l3Dn6uDl0BI8dn
         UxPpyTPlwcB8OQKrPyqzR9Evh26koIYbralZOJhK91MHxvPQpqXziXAXcL6mK4guHpu/
         bVagqIJxM4nwfwIfX2N8uX54aQB42eiHWAXmM=
MIME-Version: 1.0
In-Reply-To: <20110615075803.3348b4ec@pluto.restena.lu>
References: <1308100165.2113.4.camel@Tux>
	<20110615075803.3348b4ec@pluto.restena.lu>
Date: Wed, 15 Jun 2011 09:12:46 +0200
Message-ID: <BANLkTinE+EZ9nr1qGKC0VY0bVHuF8U-R0w@mail.gmail.com>
Subject: Re: Possible deadlock when suspending framebuffer
From: Francis Moreau <francis.moro@gmail.com>
To: =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Wanlong Gao <wanlong.gao@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
        linux-fbdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 7:58 AM, Bruno Prémont
<bonbons@linux-vserver.org> wrote:
> Hi,
>
> On Wed, 15 Jun 2011 09:09:24 Wanlong Gao <wanlong.gao@gmail.com> wrote:
>> <snip>
>> Hi Francis:
>> can you test this patch?
>
> Do you have a deadlock trace which you are trying to fix?
>
> It's either the caller of unregister_framebuffer() which must be
> changed to not call unregister_framebuffer with info's lock held or
> the code reacting on the notification that must not try to acquire the
> lock again.
>
> The interesting par is if console semaphore has some relation to this
> deadlock as the order for taking both varies... It could be
> lock_fb_info(); console_lock()  versus console_lock(); lock_fb_info()
>
> Bruno
>
>
>> Thanks
>>
>> From fe026c42af4cbdce053460a428a445e99071586a Mon Sep 17 00:00:00 2001
>> From: Wanlong Gao <wanlong.gao@gmail.com>
>> Date: Wed, 15 Jun 2011 09:03:41 +0800
>> Subject: [PATCH] test
>>
>>
>>
>> Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
>> ---
>>  drivers/video/fbmem.c |    3 ---
>>  1 files changed, 0 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
>> index 5aac00e..6e6cef3 100644
>> --- a/drivers/video/fbmem.c
>> +++ b/drivers/video/fbmem.c
>> @@ -1642,11 +1642,8 @@ static int do_unregister_framebuffer(struct
>> fb_info *fb_info)
>>       if (i < 0 || i >= FB_MAX || registered_fb[i] != fb_info)
>>               return -EINVAL;
>>
>> -     if (!lock_fb_info(fb_info))
>> -             return -ENODEV;
>>       event.info = fb_info;
>>       ret = fb_notifier_call_chain(FB_EVENT_FB_UNBIND, &event);
>> -     unlock_fb_info(fb_info);
>
> Not a good idea to stop taking fb_lock here.
> Pretty all calls of fb_notifier_call_chain are protected by info's
> lock, except the one for FB_EVENT_FB_UNREGISTERED a few lines further.
>
> IMHO it wou make sense to add the lock around that last one so all
> notifier chain calls are handled the same.
>
>>       if (ret)
>>               return -EINVAL;
>
>

Well, sorry for the dumb question but the fb/fbcon code is pretty hard
to follow for me.

Why does store_fbstate() and any fb driver's suspsend methods acquire
the console lock at all ?

Thanks
-- 
Francis
