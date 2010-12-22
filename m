Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230Ab0LVGUS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 01:20:18 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:39627 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372Ab0LVGUQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 01:20:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=jPkgZxNlAxEgnhoIuqkSz5ZAwYe9I1FR0Nk8VVHH5NjOF6yCALem3eYdwVemWoN10M
         INSk0yjyXD/Gw8wAC1CfDuthNlKC4P5GoTjjsBBy8urzcLDPGTJVRAiYi3r0+LySx61S
         97YjHl0gfsJDyaM6pEl8dAzpsH930c0NS8MZ8=
MIME-Version: 1.0
In-Reply-To: <201012181238.56021.hverkuil@xs4all.nl>
References: <1292583996-4440-1-git-send-email-manjunatha_halli@ti.com>
 <1292583996-4440-2-git-send-email-manjunatha_halli@ti.com>
 <1292583996-4440-3-git-send-email-manjunatha_halli@ti.com> <201012181238.56021.hverkuil@xs4all.nl>
From: halli manjunatha <manjunatha_halli@ti.com>
Date: Wed, 22 Dec 2010 11:49:54 +0530
X-Google-Sender-Auth: BDCNfZ2lp3HfdMtAuTy1mobtKWo
Message-ID: <AANLkTinLy_NBFDLyR9yKP72GFR0M2sCV42FnQemJ2D84@mail.gmail.com>
Subject: Re: [PATCH v7 2/7] drivers:media:radio: wl128x: fmdrv_v4l2 sources
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: mchehab@infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

10 at 5:08 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Friday, December 17, 2010 12:06:31 manjunatha_halli@ti.com wrote:
>> From: Manjunatha Halli <manjunatha_halli@ti.com>
>>
>> This module interfaces V4L2 subsystem and FM common module.
>> It registers itself with V4L2 as Radio module.
>>
>> Signed-off-by: Manjunatha Halli <manjunatha_halli@ti.com>
>> ---
>>  drivers/media/radio/wl128x/fmdrv_v4l2.c |  588 +++++++++++++++++++++++++++++++
>>  drivers/media/radio/wl128x/fmdrv_v4l2.h |   33 ++
>>  2 files changed, 621 insertions(+), 0 deletions(-)
>>  create mode 100644 drivers/media/radio/wl128x/fmdrv_v4l2.c
>>  create mode 100644 drivers/media/radio/wl128x/fmdrv_v4l2.h
>>
>> diff --git a/drivers/media/radio/wl128x/fmdrv_v4l2.c b/drivers/media/radio/wl128x/fmdrv_v4l2.c
>> new file mode 100644
>> index 0000000..623102f
>> --- /dev/null
>> +++ b/drivers/media/radio/wl128x/fmdrv_v4l2.c
>
> <snip>
>
>> +static const struct v4l2_file_operations fm_drv_fops = {
>> +     .owner = THIS_MODULE,
>> +     .read = fm_v4l2_fops_read,
>> +     .write = fm_v4l2_fops_write,
>> +     .poll = fm_v4l2_fops_poll,
>> +     .ioctl = video_ioctl2,
>
> Please use unlocked_ioctl. The .ioctl call is deprecated since it relied on the
> Big Kernel Lock which is in the process of being removed from the kernel. The
> BKL serialized all ioctl calls, unlocked_ioctl relies on the driver to serialize
> where necessary.
>
> There are two ways of doing the conversion: one is to do all the locking within
> the driver, the other is to use core-assisted locking. How to do the core-assisted
> locking is described in Documentation/video4linux/v4l2-framework.txt, but I'll
> repeat the relevant part here:
>
> v4l2_file_operations and locking
> --------------------------------
>
> You can set a pointer to a mutex_lock in struct video_device. Usually this
> will be either a top-level mutex or a mutex per device node. If you want
> finer-grained locking then you have to set it to NULL and do you own locking.
>
> If a lock is specified then all file operations will be serialized on that
> lock. If you use videobuf then you must pass the same lock to the videobuf
> queue initialize function: if videobuf has to wait for a frame to arrive, then
> it will temporarily unlock the lock and relock it afterwards. If your driver
> also waits in the code, then you should do the same to allow other processes
> to access the device node while the first process is waiting for something.
>
> The implementation of a hotplug disconnect should also take the lock before
> calling v4l2_device_disconnect.
>
>> +     .open = fm_v4l2_fops_open,
>> +     .release = fm_v4l2_fops_release,
>> +};

Hans,

I did this in my driver,
--- a/drivers/media/radio/wl128x/fmdrv_v4l2.c
+++ b/drivers/media/radio/wl128x/fmdrv_v4l2.c
@@ -477,7 +477,7 @@ static const struct v4l2_file_operations fm_drv_fops = {
        .read = fm_v4l2_fops_read,
        .write = fm_v4l2_fops_write,
        .poll = fm_v4l2_fops_poll,
-       .ioctl = video_ioctl2,
+       .unlocked_ioctl = video_ioctl2,
        .open = fm_v4l2_fops_open,
        .release = fm_v4l2_fops_release,

and apparently didn't face any issues during regression.. (related to
concurrency...)
and more-over all of my ioctls from the application being called in
process context are all synchronous, i.e
application calls and waits for it to finish before calling another ioctl.

So is this approach alright?
Is there a reason to opt for the .ioctl ? The locked approach?
Or have mutex locks inside the unlocked handlers?

If not I will go ahead and submit v8 using the unlocked_ioctl....


> Regards,
>
>        Hans
>
> --
> Hans Verkuil - video4linux developer - sponsored by Cisco
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Regards
Halli
