Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940Ab1AKLVN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 06:21:13 -0500
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:59856 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755836Ab1AKLVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 06:21:12 -0500
Date: Tue, 11 Jan 2011 13:21:06 +0200
From: Felipe Balbi <balbi@ti.com>
To: manjunatha_halli@ti.com
Cc: mchehab@infradead.org, hverkuil@xs4all.nl, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [RFC V10 2/7] drivers:media:radio: wl128x: FM Driver V4L2
 sources
Message-ID: <20110111112106.GD2385@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1294745487-29138-1-git-send-email-manjunatha_halli@ti.com>
 <1294745487-29138-2-git-send-email-manjunatha_halli@ti.com>
 <1294745487-29138-3-git-send-email-manjunatha_halli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294745487-29138-3-git-send-email-manjunatha_halli@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 06:31:22AM -0500, manjunatha_halli@ti.com wrote:
> From: Manjunatha Halli <manjunatha_halli@ti.com>
> 
> This module interfaces V4L2 subsystem and FM common module.
> It registers itself with V4L2 as Radio module.
> 
> Signed-off-by: Manjunatha Halli <manjunatha_halli@ti.com>
> Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>
> ---
>  drivers/media/radio/wl128x/fmdrv_v4l2.c |  580 +++++++++++++++++++++++++++++++
>  drivers/media/radio/wl128x/fmdrv_v4l2.h |   33 ++
>  2 files changed, 613 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/radio/wl128x/fmdrv_v4l2.c
>  create mode 100644 drivers/media/radio/wl128x/fmdrv_v4l2.h
> 
> diff --git a/drivers/media/radio/wl128x/fmdrv_v4l2.c b/drivers/media/radio/wl128x/fmdrv_v4l2.c
> new file mode 100644
> index 0000000..d50e5ac
> --- /dev/null
> +++ b/drivers/media/radio/wl128x/fmdrv_v4l2.c
> @@ -0,0 +1,580 @@
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
> + *  Copyright (C) 2011 Texas Instruments
> + *  Author: Raja Mani <raja_mani@ti.com>
> + *  Author: Manjunatha Halli <manjunatha_halli@ti.com>
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

Ideally you would not depend on other headers including the stuff you
need.

> +static struct video_device *gradio_dev;
> +static u8 radio_disconnected;

What happens with these if someone puts two wl128x devices on the same
board ? Will this still work ??

> +static const struct v4l2_ctrl_ops fm_ctrl_ops = {
> +	.s_ctrl = fm_v4l2_s_ctrl,
> +	.g_volatile_ctrl = fm_g_volatile_ctrl,
> +};

missing a blank line here.

> +static const struct v4l2_ioctl_ops fm_drv_ioctl_ops = {
> +	.vidioc_querycap = fm_v4l2_vidioc_querycap,
> +	.vidioc_g_audio = fm_v4l2_vidioc_g_audio,
> +	.vidioc_s_audio = fm_v4l2_vidioc_s_audio,
> +	.vidioc_g_tuner = fm_v4l2_vidioc_g_tuner,
> +	.vidioc_s_tuner = fm_v4l2_vidioc_s_tuner,
> +	.vidioc_g_frequency = fm_v4l2_vidioc_g_freq,
> +	.vidioc_s_frequency = fm_v4l2_vidioc_s_freq,
> +	.vidioc_s_hw_freq_seek = fm_v4l2_vidioc_s_hw_freq_seek,
> +	.vidioc_g_modulator = fm_v4l2_vidioc_g_modulator,
> +	.vidioc_s_modulator = fm_v4l2_vidioc_s_modulator
> +};

-- 
balbi
