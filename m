Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395Ab0KRHtP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 02:49:15 -0500
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3059 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755280Ab0KRHtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 02:49:13 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: manjunatha_halli@ti.com
Subject: Re: [PATCH v4 2/6] drivers:staging: ti-st: fmdrv_v4l2 sources
Date: Thu, 18 Nov 2010 08:49:07 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc2-tschai; KDE/4.4.5; x86_64; ; )
Cc: mchehab@infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
References: <1289913494-21590-1-git-send-email-manjunatha_halli@ti.com> <1289913494-21590-2-git-send-email-manjunatha_halli@ti.com> <1289913494-21590-3-git-send-email-manjunatha_halli@ti.com>
In-Reply-To: <1289913494-21590-3-git-send-email-manjunatha_halli@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201011180849.07405.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 16, 2010 14:18:10 manjunatha_halli@ti.com wrote:
> From: Manjunatha Halli <manjunatha_halli@ti.com>
> 
> This module interfaces V4L2 subsystem and FM common
> module. It registers itself with V4L2 as Radio module.
> 
> Signed-off-by: Manjunatha Halli <manjunatha_halli@ti.com>
> ---
>  drivers/staging/ti-st/fmdrv_v4l2.c |  757 ++++++++++++++++++++++++++++++++++++
>  drivers/staging/ti-st/fmdrv_v4l2.h |   32 ++
>  2 files changed, 789 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/staging/ti-st/fmdrv_v4l2.c
>  create mode 100644 drivers/staging/ti-st/fmdrv_v4l2.h
> 
> diff --git a/drivers/staging/ti-st/fmdrv_v4l2.c b/drivers/staging/ti-st/fmdrv_v4l2.c
> new file mode 100644
> index 0000000..687d10f
> --- /dev/null
> +++ b/drivers/staging/ti-st/fmdrv_v4l2.c
> @@ -0,0 +1,757 @@
> +/*
> + *  FM Driver for Connectivity chip of Texas Instruments.
> + *  This file provides interfaces to V4L2 subsystem.
> + *
> + *  This module registers with V4L2 subsystem as Radio
> + *  data system interface (/dev/radio). During the registration,
> + *  it will expose two set of function pointers.
> + *
> + *    1) File operation related API (open, close, read, write, poll...etc).
> + *    2) Set of V4L2 IOCTL complaint API.
> + *
> + *  Copyright (C) 2010 Texas Instruments
> + *  Author: Raja Mani <raja_mani@ti.com>
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License version 2 as
> + *  published by the Free Software Foundation.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License
> + *  along with this program; if not, write to the Free Software
> + *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> + *
> + */
> +
> +#include "fmdrv.h"
> +#include "fmdrv_v4l2.h"
> +#include "fmdrv_common.h"
> +#include "fmdrv_rx.h"
> +#include "fmdrv_tx.h"
> +
> +static struct video_device *gradio_dev;
> +static unsigned char radio_disconnected;
> +
> +/* Query control */
> +static struct v4l2_queryctrl fmdrv_v4l2_queryctrl[] = {
> +	{
> +	 .id = V4L2_CID_AUDIO_VOLUME,
> +	 .type = V4L2_CTRL_TYPE_INTEGER,
> +	 .name = "Volume",
> +	 .minimum = FM_RX_VOLUME_MIN,
> +	 .maximum = FM_RX_VOLUME_MAX,
> +	 .step = 1,
> +	 .default_value = FM_DEFAULT_RX_VOLUME,
> +	 },
> +	{
> +	 .id = V4L2_CID_AUDIO_BALANCE,
> +	 .flags = V4L2_CTRL_FLAG_DISABLED,
> +	 },
> +	{
> +	 .id = V4L2_CID_AUDIO_BASS,
> +	 .flags = V4L2_CTRL_FLAG_DISABLED,
> +	 },
> +	{
> +	 .id = V4L2_CID_AUDIO_TREBLE,
> +	 .flags = V4L2_CTRL_FLAG_DISABLED,
> +	 },
> +	{
> +	 .id = V4L2_CID_AUDIO_MUTE,
> +	 .type = V4L2_CTRL_TYPE_BOOLEAN,
> +	 .name = "Mute",
> +	 .minimum = 0,
> +	 .maximum = 2,
> +	 .step = 1,
> +	 .default_value = FM_MUTE_OFF,
> +	 },
> +	{
> +	 .id = V4L2_CID_AUDIO_LOUDNESS,
> +	 .flags = V4L2_CTRL_FLAG_DISABLED,
> +	 },
> +};

Please use the control framework. See Documentation/video4linux/v4l2-controls.txt.
It's much easier to use and should be used for new drivers.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
