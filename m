Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932361Ab3AIRtf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 12:49:35 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:48279 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932297Ab3AIRtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 12:49:33 -0500
MIME-Version: 1.0
In-Reply-To: <201301091642.38184.hverkuil@xs4all.nl>
References: <1357738887-8701-1-git-send-email-prabhakar.lad@ti.com>
 <1357738887-8701-2-git-send-email-prabhakar.lad@ti.com> <201301091642.38184.hverkuil@xs4all.nl>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Wed, 9 Jan 2013 23:19:10 +0530
Message-ID: <CA+V-a8v=FkKmkJ0mcs_0x1o3o86vqqS16hLMr5xOnMAhRUJTqg@mail.gmail.com>
Subject: Re: [PATCH RFC 1/3] davinci: vpif: capture: add V4L2-async support
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>, Sekhar Nori <nsekhar@ti.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

Thanks for the review!

On Wed, Jan 9, 2013 at 9:12 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Wed 9 January 2013 14:41:25 Lad, Prabhakar wrote:
>> Add support for asynchronous subdevice probing, using the v4l2-async API.
>> The legacy synchronous mode is still supported too, which allows to
>> gradually update drivers and platforms. The selected approach adds a
>> notifier for each struct soc_camera_device instance, i.e. for each video
>> device node, even when there are multiple such instances registered with a
>> single soc-camera host simultaneously.
>
> This comment was obviously copy-and-pasted from somewhere else :-)
>
ah my bad :-)

>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
>> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>> Cc: Hans Verkuil <hans.verkuil@cisco.com>
>> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> Cc: Sakari Ailus <sakari.ailus@iki.fi>
>> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
>> ---
>>  drivers/media/platform/davinci/vpif_capture.c |  171 ++++++++++++++++++-------
>>  drivers/media/platform/davinci/vpif_capture.h |    2 +
>>  include/media/davinci/vpif_types.h            |    2 +
>>  3 files changed, 128 insertions(+), 47 deletions(-)
>>
>> diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
>> index 5892d2b..a8b6588 100644
>> --- a/drivers/media/platform/davinci/vpif_capture.c
>> +++ b/drivers/media/platform/davinci/vpif_capture.c
>> @@ -34,6 +34,8 @@
>>  #include <linux/platform_device.h>
>>  #include <linux/io.h>
>>  #include <linux/slab.h>
>> +
>> +#include <media/v4l2-async.h>
>>  #include <media/v4l2-device.h>
>>  #include <media/v4l2-ioctl.h>
>>  #include <media/v4l2-chip-ident.h>
>> @@ -2054,6 +2056,96 @@ vpif_init_free_channel_objects:
>>       return err;
>>  }
>>
>> +int vpif_async_bound(struct v4l2_async_notifier *notifier,
>> +                 struct v4l2_async_subdev_list *asdl)
>> +{
>> +     int i = 0;
>> +
>> +     if (!asdl->subdev) {
>> +             v4l2_err(vpif_dev->driver,
>> +                      "%s(): Subdevice driver hasn't set subdev pointer!\n",
>> +                     __func__);
>> +             return -EINVAL;
>> +     }
>> +     v4l2_info(&vpif_obj.v4l2_dev, "registered sub device %s\n",
>> +                      asdl->subdev->name);
>
> This v4l2_info shouldn't be necessary: when the subdev is loaded it will already
> report that it is registered, so this would just duplicate things.
>
Ok

>> +
>> +     for (i = 0; i < vpif_obj.config->subdev_count; i++)
>> +             if (!strcmp(vpif_obj.config->subdev_info[i].name,
>> +                     asdl->subdev->name)) {
>> +                     vpif_obj.sd[i] = asdl->subdev;
>> +                     break;
>> +             }
>> +
>> +     if (i >= vpif_obj.config->subdev_count)
>> +             return -EINVAL;
>> +
>> +     return 0;
>
> This function feels unnecessary. What you basically do here is to fill in
> the vpif_obj.sd[i] pointer. Wouldn't it be easier if we added a function to
> v4l2-device.c that will return a v4l2_subdev pointer based on the subdev name
> or possibly that of a struct v4l2_async_hw_device by walking the subdevice
> list that is stored in v4l2_device?
>
> Then you could do something like this in vpif_probe_complete:
>
>         for (i = 0; i < vpif_obj.config->subdev_count; i++)
>                 vpif_obj.sd[i] = v4l2_device_get_subdev_by_name(v4l2_dev,
>                                         vpif_obj.config->subdev_info[i].name);
>
> and there would be no need for a bound callback.
>
> Passing a struct v4l2_async_hw_device can be useful too: then you can
> walk the list of subdevs passed in struct v4l2_async_notifier and you
> don't need to fiddle with subdev names.
>
> It's just a suggestion, but I think it will improve the code as the control
> flow is more logical that way (async callbacks are always harder to understand).
>
the bound callback, is being called on the subdev registration, the driver
is designed in such a way that there is subdev list and input list, and
each input may or may not have a subdev associated with it, when a input is
selected looping through the subdev list the appropriate is choose,
this was done by you :), the above code adds the subdev pointer in appropriate
index.  To do this the bound callback would be required.

The second member of bound ie, asdl itself has pointer to subdev, so there isnt
a necessity to have a function returning a subdev by matching a name.

>> +}
>> +
>> +static int vpif_probe_complete(void)
>> +{
>> +     struct common_obj *common;
>> +     struct channel_obj *ch;
>> +     int i, j, err, k;
>> +
>> +     for (j = 0; j < VPIF_CAPTURE_MAX_DEVICES; j++) {
>> +             ch = vpif_obj.dev[j];
>> +             ch->channel_id = j;
>> +             common = &(ch->common[VPIF_VIDEO_INDEX]);
>> +             spin_lock_init(&common->irqlock);
>> +             mutex_init(&common->lock);
>> +             ch->video_dev->lock = &common->lock;
>> +             /* Initialize prio member of channel object */
>> +             v4l2_prio_init(&ch->prio);
>> +             video_set_drvdata(ch->video_dev, ch);
>> +
>> +             /* select input 0 */
>> +             err = vpif_set_input(vpif_obj.config, ch, 0);
>> +             if (err)
>> +                     goto probe_out;
>> +
>> +             err = video_register_device(ch->video_dev,
>> +                                         VFL_TYPE_GRABBER, (j ? 1 : 0));
>> +             if (err)
>> +                     goto probe_out;
>> +     }
>> +
>> +     v4l2_info(&vpif_obj.v4l2_dev, "VPIF capture driver initialized\n");
>> +     return 0;
>> +
>> +probe_out:
>> +     for (k = 0; k < j; k++) {
>> +             /* Get the pointer to the channel object */
>> +             ch = vpif_obj.dev[k];
>> +             /* Unregister video device */
>> +             video_unregister_device(ch->video_dev);
>> +     }
>> +     kfree(vpif_obj.sd);
>> +     for (i = 0; i < VPIF_CAPTURE_MAX_DEVICES; i++) {
>> +             ch = vpif_obj.dev[i];
>> +             /* Note: does nothing if ch->video_dev == NULL */
>> +             video_device_release(ch->video_dev);
>> +     }
>> +     v4l2_device_unregister(&vpif_obj.v4l2_dev);
>> +
>> +     return err;
>> +}
>> +
>> +int vpif_async_complete(struct v4l2_async_notifier *notifier)
>> +{
>> +     return vpif_probe_complete();
>
> Why this extra indirection? I'd remove it.
>
The complete notifier is called when all the subdevices have been registered
this is only when the video_register_device() is called this piece of code which
is common for asynchronous and synchronous probing so included in a function
so that its used by both.

>> +}
>> +
>> +void vpif_async_unbind(struct v4l2_async_notifier *notifier,
>> +                 struct v4l2_async_subdev_list *asdl)
>> +{
>> +     /*FIXME: Do we need this callback ? */
>
> I think this callback can be removed.
>
Yes

Regards,
--Prabhakar


>> +     v4l2_info(&vpif_obj.v4l2_dev, "unregistered sub device %s\n",
>> +                      asdl->subdev->name);
>> +     return;
>> +}
>> +
>>  /**
>>   * vpif_probe : This function probes the vpif capture driver
>>   * @pdev: platform device pointer
>> @@ -2064,12 +2156,10 @@ vpif_init_free_channel_objects:
>>  static __init int vpif_probe(struct platform_device *pdev)
>>  {
>>       struct vpif_subdev_info *subdevdata;
>> -     struct vpif_capture_config *config;
>> -     int i, j, k, err;
>> +     int i, j, err;
>>       int res_idx = 0;
>>       struct i2c_adapter *i2c_adap;
>>       struct channel_obj *ch;
>> -     struct common_obj *common;
>>       struct video_device *vfd;
>>       struct resource *res;
>>       int subdev_count;
>> @@ -2146,10 +2236,9 @@ static __init int vpif_probe(struct platform_device *pdev)
>>               }
>>       }
>>
>> -     i2c_adap = i2c_get_adapter(1);
>> -     config = pdev->dev.platform_data;
>> +     vpif_obj.config = pdev->dev.platform_data;
>>
>> -     subdev_count = config->subdev_count;
>> +     subdev_count = vpif_obj.config->subdev_count;
>>       vpif_obj.sd = kzalloc(sizeof(struct v4l2_subdev *) * subdev_count,
>>                               GFP_KERNEL);
>>       if (vpif_obj.sd == NULL) {
>> @@ -2158,53 +2247,41 @@ static __init int vpif_probe(struct platform_device *pdev)
>>               goto vpif_sd_error;
>>       }
>>
>> -     for (i = 0; i < subdev_count; i++) {
>> -             subdevdata = &config->subdev_info[i];
>> -             vpif_obj.sd[i] =
>> -                     v4l2_i2c_new_subdev_board(&vpif_obj.v4l2_dev,
>> -                                               i2c_adap,
>> -                                               &subdevdata->board_info,
>> -                                               NULL);
>> +     if (!vpif_obj.config->asd_sizes) {
>> +             i2c_adap = i2c_get_adapter(1);
>> +             for (i = 0; i < subdev_count; i++) {
>> +                     subdevdata = &vpif_obj.config->subdev_info[i];
>> +                     vpif_obj.sd[i] =
>> +                             v4l2_i2c_new_subdev_board(&vpif_obj.v4l2_dev,
>> +                                                     i2c_adap,
>> +                                                     &subdevdata->board_info,
>> +                                                     NULL);
>>
>> -             if (!vpif_obj.sd[i]) {
>> -                     vpif_err("Error registering v4l2 subdevice\n");
>> -                     goto probe_subdev_out;
>> +                     if (!vpif_obj.sd[i]) {
>> +                             vpif_err("Error registering v4l2 subdevice\n");
>> +                             goto probe_subdev_out;
>> +                     }
>> +                     v4l2_info(&vpif_obj.v4l2_dev, "registered sub device %s\n",
>> +                             subdevdata->name);
>> +             }
>> +             vpif_probe_complete();
>> +     } else {
>> +             vpif_obj.notifier.subdev = vpif_obj.config->asd;
>> +             vpif_obj.notifier.subdev_num = vpif_obj.config->asd_sizes[0];
>> +             vpif_obj.notifier.bound = vpif_async_bound;
>> +             vpif_obj.notifier.complete = vpif_async_complete;
>> +             vpif_obj.notifier.unbind = vpif_async_unbind;
>> +             err = v4l2_async_notifier_register(&vpif_obj.v4l2_dev,
>> +                                                &vpif_obj.notifier);
>> +             if (err) {
>> +                     vpif_err("Error registering async notifier\n");
>> +                     err = -EINVAL;
>> +                     goto vpif_sd_error;
>>               }
>> -             v4l2_info(&vpif_obj.v4l2_dev, "registered sub device %s\n",
>> -                       subdevdata->name);
>>       }
>>
>> -     for (j = 0; j < VPIF_CAPTURE_MAX_DEVICES; j++) {
>> -             ch = vpif_obj.dev[j];
>> -             ch->channel_id = j;
>> -             common = &(ch->common[VPIF_VIDEO_INDEX]);
>> -             spin_lock_init(&common->irqlock);
>> -             mutex_init(&common->lock);
>> -             ch->video_dev->lock = &common->lock;
>> -             /* Initialize prio member of channel object */
>> -             v4l2_prio_init(&ch->prio);
>> -             video_set_drvdata(ch->video_dev, ch);
>> -
>> -             /* select input 0 */
>> -             err = vpif_set_input(config, ch, 0);
>> -             if (err)
>> -                     goto probe_out;
>> -
>> -             err = video_register_device(ch->video_dev,
>> -                                         VFL_TYPE_GRABBER, (j ? 1 : 0));
>> -             if (err)
>> -                     goto probe_out;
>> -     }
>> -     v4l2_info(&vpif_obj.v4l2_dev, "VPIF capture driver initialized\n");
>>       return 0;
>>
>> -probe_out:
>> -     for (k = 0; k < j; k++) {
>> -             /* Get the pointer to the channel object */
>> -             ch = vpif_obj.dev[k];
>> -             /* Unregister video device */
>> -             video_unregister_device(ch->video_dev);
>> -     }
>>  probe_subdev_out:
>>       /* free sub devices memory */
>>       kfree(vpif_obj.sd);
>> diff --git a/drivers/media/platform/davinci/vpif_capture.h b/drivers/media/platform/davinci/vpif_capture.h
>> index 3d3c1e5..1be47ab 100644
>> --- a/drivers/media/platform/davinci/vpif_capture.h
>> +++ b/drivers/media/platform/davinci/vpif_capture.h
>> @@ -145,6 +145,8 @@ struct vpif_device {
>>       struct v4l2_device v4l2_dev;
>>       struct channel_obj *dev[VPIF_CAPTURE_NUM_CHANNELS];
>>       struct v4l2_subdev **sd;
>> +     struct v4l2_async_notifier notifier;
>> +     struct vpif_capture_config *config;
>>  };
>>
>>  struct vpif_config_params {
>> diff --git a/include/media/davinci/vpif_types.h b/include/media/davinci/vpif_types.h
>> index 3882e06..e08bcde 100644
>> --- a/include/media/davinci/vpif_types.h
>> +++ b/include/media/davinci/vpif_types.h
>> @@ -81,5 +81,7 @@ struct vpif_capture_config {
>>       struct vpif_subdev_info *subdev_info;
>>       int subdev_count;
>>       const char *card_name;
>> +     struct v4l2_async_subdev **asd; /* Flat array, arranged in groups */
>> +     int *asd_sizes;         /* 0-terminated array of asd group sizes */
>>  };
>>  #endif /* _VPIF_TYPES_H */
>>
>
> Regards,
>
>         Hans
