Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932748Ab1LEV4Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 16:56:16 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50623 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932588Ab1LEV4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 16:56:13 -0500
Message-ID: <4EDD3DEE.6060506@gmail.com>
Date: Mon, 05 Dec 2011 22:55:58 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>
CC: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [RFC PATCH v1 6/7] media: video: introduce face detection driver
 module
References: <1322838172-11149-1-git-send-email-ming.lei@canonical.com> <1322838172-11149-7-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1322838172-11149-7-git-send-email-ming.lei@canonical.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ming,

(I've pruned the Cc list, leaving just the mailing lists)

On 12/02/2011 04:02 PM, Ming Lei wrote:
> This patch introduces one driver for face detection purpose.
> 
> The driver is responsible for all v4l2 stuff, buffer management
> and other general things, and doesn't touch face detection hardware
> directly. Several interfaces are exported to low level drivers
> (such as the coming omap4 FD driver)which will communicate with
> face detection hw module.
> 
> So the driver will make driving face detection hw modules more
> easy.


I would hold on for a moment on implementing generic face detection
module which is based on the V4L2 video device interface. We need to
first define an API that would be also usable at sub-device interface
level (http://linuxtv.org/downloads/v4l-dvb-apis/subdev.html).
AFAICS OMAP4 FDIF processes only data stored in memory, thus it seems
reasonable to use the videodev interface for passing data to the kernel
from user space.

But there might be face detection devices that accept data from other
H/W modules, e.g. transferred through SoC internal data buses between
image processing pipeline blocks. Thus any new interfaces need to be
designed with such devices in mind.

Also the face detection hardware block might now have an input DMA
engine in it, the data could be fed from memory through some other
subsystem (e.g. resize/colour converter). Then the driver for that
subsystem would implement a video node.

I'm for leaving the buffer handling details for individual drivers
and focusing on a standard interface for applications, i.e. new
ioctl(s) and controls.

> 
> TODO:
> 	- implement FD setting interfaces with v4l2 controls or
> 	ext controls
> 
> Signed-off-by: Ming Lei <ming.lei@canonical.com>
> ---
>  drivers/media/video/Kconfig       |    2 +
>  drivers/media/video/Makefile      |    1 +
>  drivers/media/video/fdif/Kconfig  |    7 +
>  drivers/media/video/fdif/Makefile |    1 +
>  drivers/media/video/fdif/fdif.c   |  645 +++++++++++++++++++++++++++++++++++++
>  drivers/media/video/fdif/fdif.h   |  114 +++++++
>  6 files changed, 770 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/fdif/Kconfig
>  create mode 100644 drivers/media/video/fdif/Makefile
>  create mode 100644 drivers/media/video/fdif/fdif.c
>  create mode 100644 drivers/media/video/fdif/fdif.h

[...]

> diff --git a/drivers/media/video/fdif/fdif.h b/drivers/media/video/fdif/fdif.h
> new file mode 100644
> index 0000000..ae37ab8
> --- /dev/null
> +++ b/drivers/media/video/fdif/fdif.h
> @@ -0,0 +1,114 @@
> +#ifndef _LINUX_FDIF_H
> +#define _LINUX_FDIF_H
> +
> +#include <linux/types.h>
> +#include <linux/magic.h>
> +#include <linux/errno.h>
> +#include <linux/kref.h>
> +#include <linux/kernel.h>
> +#include <linux/videodev2.h>
> +#include <media/videobuf2-page.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-fh.h>
> +#include <media/v4l2-event.h>
> +#include <media/v4l2-common.h>
> +
> +#define MAX_FACE_COUNT		40
> +
> +#define	FACE_SIZE_20_PIXELS	0
> +#define	FACE_SIZE_25_PIXELS	1
> +#define	FACE_SIZE_32_PIXELS	2
> +#define	FACE_SIZE_40_PIXELS	3

This is still OMAP4 FDIF specific, we need to think about v4l2 controls
for this. An ideal would be a menu control type that supports pixel size
(width/height), but unfortunately something like this isn't available
in v4l2 yet.

> +
> +#define FACE_DIR_UP		0
> +#define FACE_DIR_RIGHT		1
> +#define FACE_DIR_LIFT		2
> +
> +struct fdif_fmt {
> +	char  *name;
> +	u32   fourcc;          /* v4l2 format id */
> +	int   depth;
> +	int   width, height;

Could width/height be negative ? I don't think it's the case for pixel
resolution. The more proper data type would be u32.

Please refer to struct v4l2_pix_format or struct v4l2_rect.

> +};
> +
> +struct fdif_setting {
> +	struct fdif_fmt            *fmt;
> +	enum v4l2_field            field;
> +
> +	int 			min_face_size;
> +	int			face_dir;
> +
> +	int			startx, starty;

s32

> +	int			sizex, sizey;

u32

> +	int			lhit;
> +
> +	int			width, height;

u32

> +};
> +
> +/* buffer for one video frame */
> +struct fdif_buffer {
> +	/* common v4l buffer stuff -- must be first */
> +	struct vb2_buffer	vb;
> +	struct list_head	list;
> +};
> +
> +
> +struct v4l2_fdif_result {
> +	struct list_head		list;
> +	unsigned int			face_cnt;
> +	struct v4l2_fd_detection	*faces;
> +
> +	/*v4l2 buffer index*/
> +	__u32				index;
> +};
> +
> +struct fdif_dmaqueue {
> +	struct list_head	complete;
> +	struct list_head	active;
> +	wait_queue_head_t	wq;
> +};
> +
> +
> +struct fdif_dev {
> +	struct kref		ref;
> +	struct device		*dev;
> +
> +	struct list_head        fdif_devlist;
> +	struct v4l2_device	v4l2_dev;
> +	struct vb2_queue        vbq;
> +	struct mutex            mutex;
> +	spinlock_t		lock;
> +
> +	struct video_device        *vfd;
> +	struct fdif_dmaqueue	fdif_dq;
> +
> +	/*setting*/
> +	struct fdif_setting	s;

yy, please make it more descriptive. e.g.

	struct fdif_config	config;

> +
> +	struct fdif_ops	*ops;
> +
> +	unsigned long	priv[0];
> +};
> +
[...]

--

Regards,
Sylwester
