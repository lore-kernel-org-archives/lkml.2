Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab1IFIHz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 04:07:55 -0400
Received: from mail-qw0-f42.google.com ([209.85.216.42]:37907 "EHLO
	mail-qw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369Ab1IFIHu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 04:07:50 -0400
MIME-Version: 1.0
In-Reply-To: <20110905223102.GA26980@sucs.org>
References: <20110829204846.GA14699@sucs.org>
	<201109051159.08268.laurent.pinchart@ideasonboard.com>
	<201109051213.26482.hverkuil@xs4all.nl>
	<201109051216.42579.hverkuil@xs4all.nl>
	<20110905223102.GA26980@sucs.org>
Date: Tue, 6 Sep 2011 16:07:48 +0800
Message-ID: <CABqxG0dwKgCVNDJhitn3M5t099-eAV1MPVRRji+U_u6ooABY9A@mail.gmail.com>
Subject: Re: BUG: unable to handle kernel paging request at 6b6b6bcb (v4l2_device_disconnect+0x11/0x30)
From: Dave Young <hidave.darkstar@gmail.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 6, 2011 at 6:31 AM, Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
> On Mon, Sep 05, 2011 at 12:16:42PM +0200, Hans Verkuil wrote:
>> On Monday, September 05, 2011 12:13:26 Hans Verkuil wrote:
>> >
>> > The original order is correct, but what I missed is that for drivers
>> > that release (free) everything in the videodev release callback the
>> > v4l2_device struct is also freed and v4l2_device_put will fail.
>> >
>> > To fix this, add this code just before the vdev->release call:
>> >
>> >     /* Do not call v4l2_device_put if there is no release callback set. */
>> >     if (v4l2_dev->release == NULL)
>> >             v4l2_dev = NULL;
>> >
>> > If there is no release callback, then the refcounting is pointless
>> > anyway.
>> >
>> > This should work.
>>
>> Note that in the long run using the v4l2_device release callback
>> instead of the videodev release is better. But it's a lot of work to
>> convert everything so that's long term. I'm quite surprised BTW that
>> this bug wasn't found much earlier.
>
> This inline patch fixes the second "poison overwritten" problem so:
> Tested-by: Sitsofe Wheeler <sitsofe@yahoo.com>

Confirmed

>
> However, it does not prevent the original oops that was reported in the
> original message. Yang Ruirui's patch in
> https://lkml.org/lkml/2011/9/1/74 seems to be required to resolve
> that initial problem - can it be ACK'd? Yang's patch is reproduced
> inline below:

Thanks, If it's ok, I can resend it as inline.

>
> For uvc device, dev->vdev.dev is the &intf->dev,
> uvc_delete code is as below:
>        usb_put_intf(dev->intf);
>        usb_put_dev(dev->udev);
>
>        uvc_status_cleanup(dev);
>        uvc_ctrl_cleanup_device(dev);
>
> ## the intf dev is released above, so below code will oops.
>
>        if (dev->vdev.dev)
>                v4l2_device_unregister(&dev->vdev);
> Fix it by get_device in v4l2_device_register and put_device in v4l2_device_disconnect
> ---
>  drivers/media/video/v4l2-device.c |    2 ++
>  1 file changed, 2 insertions(+)
> diff --git a/drivers/media/video/v4l2-device.c b/drivers/media/video/v4l2-device.c
> index c72856c..e6a2c3b 100644
> --- a/drivers/media/video/v4l2-device.c
> +++ b/drivers/media/video/v4l2-device.c
> @@ -38,6 +38,7 @@ int v4l2_device_register(struct device *dev, struct v4l2_device *v4l2_dev)
>        mutex_init(&v4l2_dev->ioctl_lock);
>        v4l2_prio_init(&v4l2_dev->prio);
>        kref_init(&v4l2_dev->ref);
> +       get_device(dev);
>        v4l2_dev->dev = dev;
>        if (dev == NULL) {
>                /* If dev == NULL, then name must be filled in by the caller */
> @@ -93,6 +94,7 @@ void v4l2_device_disconnect(struct v4l2_device *v4l2_dev)
>
>        if (dev_get_drvdata(v4l2_dev->dev) == v4l2_dev)
>                dev_set_drvdata(v4l2_dev->dev, NULL);
> +       put_device(v4l2_dev->dev);
>        v4l2_dev->dev = NULL;
>  }
>  EXPORT_SYMBOL_GPL(v4l2_device_disconnect);
>
> --
> Sitsofe | http://sucs.org/~sits/
>



-- 
Regards
Yang RuiRui
