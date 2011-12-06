Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933371Ab1LFOH3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 09:07:29 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:56037 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933233Ab1LFOH1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 09:07:27 -0500
MIME-Version: 1.0
In-Reply-To: <4EDD3DEE.6060506@gmail.com>
References: <1322838172-11149-1-git-send-email-ming.lei@canonical.com>
	<1322838172-11149-7-git-send-email-ming.lei@canonical.com>
	<4EDD3DEE.6060506@gmail.com>
Date: Tue, 6 Dec 2011 22:07:24 +0800
Message-ID: <CACVXFVPrAro=3t-wpbR_cVahzcx7SCa2J=s2nyyKfQ6SG-i0VQ@mail.gmail.com>
Subject: Re: [RFC PATCH v1 6/7] media: video: introduce face detection driver module
From: Ming Lei <ming.lei@canonical.com>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks for your review.

On Tue, Dec 6, 2011 at 5:55 AM, Sylwester Nawrocki <snjw23@gmail.com> wrote:
> Hi Ming,
>
> (I've pruned the Cc list, leaving just the mailing lists)
>
> On 12/02/2011 04:02 PM, Ming Lei wrote:
>> This patch introduces one driver for face detection purpose.
>>
>> The driver is responsible for all v4l2 stuff, buffer management
>> and other general things, and doesn't touch face detection hardware
>> directly. Several interfaces are exported to low level drivers
>> (such as the coming omap4 FD driver)which will communicate with
>> face detection hw module.
>>
>> So the driver will make driving face detection hw modules more
>> easy.
>
>
> I would hold on for a moment on implementing generic face detection
> module which is based on the V4L2 video device interface. We need to
> first define an API that would be also usable at sub-device interface
> level (http://linuxtv.org/downloads/v4l-dvb-apis/subdev.html).

If we can define a good/stable enough APIs between kernel and user space,
I think the patches can be merged first. For internal kernel APIs, we should
allow it to evolve as new hardware comes or new features are to be introduced.

I understand the API you mentioned here should belong to kernel internal
API, correct me if it is wrong.

> AFAICS OMAP4 FDIF processes only data stored in memory, thus it seems
> reasonable to use the videodev interface for passing data to the kernel
> from user space.
>
> But there might be face detection devices that accept data from other
> H/W modules, e.g. transferred through SoC internal data buses between
> image processing pipeline blocks. Thus any new interfaces need to be
> designed with such devices in mind.
>
> Also the face detection hardware block might now have an input DMA
> engine in it, the data could be fed from memory through some other
> subsystem (e.g. resize/colour converter). Then the driver for that
> subsystem would implement a video node.

I think the direct input image or frame data to FD should be from memory
no matter the actual data is from external H/W modules or input DMA because
FD will take lot of time to detect faces in one image or frame and FD can't
have so much memory to cache several images or frames data.

If you have seen this kind of FD hardware design, please let me know.

> I'm for leaving the buffer handling details for individual drivers
> and focusing on a standard interface for applications, i.e. new

I think leaving buffer handling details in generic FD driver or
individual drivers
doesn't matter now, since it don't have effect on interfaces between kernel
and user space.

> ioctl(s) and controls.
>
>>
>> TODO:
>>       - implement FD setting interfaces with v4l2 controls or
>>       ext controls
>>
>> Signed-off-by: Ming Lei <ming.lei@canonical.com>
>> ---
>>  drivers/media/video/Kconfig       |    2 +
>>  drivers/media/video/Makefile      |    1 +
>>  drivers/media/video/fdif/Kconfig  |    7 +
>>  drivers/media/video/fdif/Makefile |    1 +
>>  drivers/media/video/fdif/fdif.c   |  645 +++++++++++++++++++++++++++++++++++++
>>  drivers/media/video/fdif/fdif.h   |  114 +++++++
>>  6 files changed, 770 insertions(+), 0 deletions(-)
>>  create mode 100644 drivers/media/video/fdif/Kconfig
>>  create mode 100644 drivers/media/video/fdif/Makefile
>>  create mode 100644 drivers/media/video/fdif/fdif.c
>>  create mode 100644 drivers/media/video/fdif/fdif.h
>
> [...]
>
>> diff --git a/drivers/media/video/fdif/fdif.h b/drivers/media/video/fdif/fdif.h
>> new file mode 100644
>> index 0000000..ae37ab8
>> --- /dev/null
>> +++ b/drivers/media/video/fdif/fdif.h
>> @@ -0,0 +1,114 @@
>> +#ifndef _LINUX_FDIF_H
>> +#define _LINUX_FDIF_H
>> +
>> +#include <linux/types.h>
>> +#include <linux/magic.h>
>> +#include <linux/errno.h>
>> +#include <linux/kref.h>
>> +#include <linux/kernel.h>
>> +#include <linux/videodev2.h>
>> +#include <media/videobuf2-page.h>
>> +#include <media/v4l2-device.h>
>> +#include <media/v4l2-ioctl.h>
>> +#include <media/v4l2-ctrls.h>
>> +#include <media/v4l2-fh.h>
>> +#include <media/v4l2-event.h>
>> +#include <media/v4l2-common.h>
>> +
>> +#define MAX_FACE_COUNT               40
>> +
>> +#define      FACE_SIZE_20_PIXELS     0
>> +#define      FACE_SIZE_25_PIXELS     1
>> +#define      FACE_SIZE_32_PIXELS     2
>> +#define      FACE_SIZE_40_PIXELS     3
>
> This is still OMAP4 FDIF specific, we need to think about v4l2 controls
> for this. An ideal would be a menu control type that supports pixel size
> (width/height), but unfortunately something like this isn't available
> in v4l2 yet.

Yes, it is on TODO list, :-)

>> +
>> +#define FACE_DIR_UP          0
>> +#define FACE_DIR_RIGHT               1
>> +#define FACE_DIR_LIFT                2
>> +
>> +struct fdif_fmt {
>> +     char  *name;
>> +     u32   fourcc;          /* v4l2 format id */
>> +     int   depth;
>> +     int   width, height;
>
> Could width/height be negative ? I don't think it's the case for pixel
> resolution. The more proper data type would be u32.

Yes, they should be, will fix it in next version.

> Please refer to struct v4l2_pix_format or struct v4l2_rect.
>
>> +};
>> +
>> +struct fdif_setting {
>> +     struct fdif_fmt            *fmt;
>> +     enum v4l2_field            field;
>> +
>> +     int                     min_face_size;
>> +     int                     face_dir;
>> +
>> +     int                     startx, starty;
>
> s32
>
>> +     int                     sizex, sizey;
>
> u32
>
>> +     int                     lhit;
>> +
>> +     int                     width, height;
>
> u32
>
>> +};
>> +
>> +/* buffer for one video frame */
>> +struct fdif_buffer {
>> +     /* common v4l buffer stuff -- must be first */
>> +     struct vb2_buffer       vb;
>> +     struct list_head        list;
>> +};
>> +
>> +
>> +struct v4l2_fdif_result {
>> +     struct list_head                list;
>> +     unsigned int                    face_cnt;
>> +     struct v4l2_fd_detection        *faces;
>> +
>> +     /*v4l2 buffer index*/
>> +     __u32                           index;
>> +};
>> +
>> +struct fdif_dmaqueue {
>> +     struct list_head        complete;
>> +     struct list_head        active;
>> +     wait_queue_head_t       wq;
>> +};
>> +
>> +
>> +struct fdif_dev {
>> +     struct kref             ref;
>> +     struct device           *dev;
>> +
>> +     struct list_head        fdif_devlist;
>> +     struct v4l2_device      v4l2_dev;
>> +     struct vb2_queue        vbq;
>> +     struct mutex            mutex;
>> +     spinlock_t              lock;
>> +
>> +     struct video_device        *vfd;
>> +     struct fdif_dmaqueue    fdif_dq;
>> +
>> +     /*setting*/
>> +     struct fdif_setting     s;
>
> yy, please make it more descriptive. e.g.

Sounds reasonable, :-)

>
>        struct fdif_config      config;
>
>> +
>> +     struct fdif_ops *ops;
>> +
>> +     unsigned long   priv[0];
>> +};
>> +
> [...]
>
> --
>
> Regards,
> Sylwester
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

thanks,
--
Ming Lei
