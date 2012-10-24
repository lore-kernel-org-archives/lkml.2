Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422829Ab2JXWen (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 18:34:43 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:38202 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422652Ab2JXWel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 18:34:41 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Julia.Lawall@lip6.fr, kernel-janitors@vger.kernel.org,
        Peter Senna Tschudin <peter.senna@gmail.com>
Subject: Re: [PATCH 01/23] uvc: Replace memcpy with struct assignment
Date: Thu, 25 Oct 2012 00:35:30 +0200
Message-ID: <2776796.95QghSKdPW@avalon>
User-Agent: KMail/4.9.2 (Linux/3.5.7-gentoo; KDE/4.9.2; x86_64; ; )
In-Reply-To: <1351022246-8201-1-git-send-email-elezegarcia@gmail.com>
References: <1351022246-8201-1-git-send-email-elezegarcia@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ezequiel,

Thanks for the patch.

On Tuesday 23 October 2012 16:57:04 Ezequiel Garcia wrote:
> This kind of memcpy() is error-prone. Its replacement with a struct
> assignment is prefered because it's type-safe and much easier to read.
> 
> Found by coccinelle. Hand patched and reviewed.
> Tested by compilation only.

This looks good, but there's one more memcpy that can be replaced by a direct 
structure assignment in uvc_ctrl_add_info() 
(drivers/media/usb/uvc/uvc_ctrl.c). You might want to check why it hasn't been 
caught by the semantic patch.

> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> identifier struct_name;
> struct struct_name to;
> struct struct_name from;
> expression E;
> @@
> -memcpy(&(to), &(from), E);
> +to = from;
> // </smpl>
> 
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
> Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
> ---
>  drivers/media/usb/uvc/uvc_v4l2.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_v4l2.c
> b/drivers/media/usb/uvc/uvc_v4l2.c index f00db30..4fc8737 100644
> --- a/drivers/media/usb/uvc/uvc_v4l2.c
> +++ b/drivers/media/usb/uvc/uvc_v4l2.c
> @@ -314,7 +314,7 @@ static int uvc_v4l2_set_format(struct uvc_streaming
> *stream, goto done;
>  	}
> 
> -	memcpy(&stream->ctrl, &probe, sizeof probe);
> +	stream->ctrl = probe;
>  	stream->cur_format = format;
>  	stream->cur_frame = frame;
> 
> @@ -386,7 +386,7 @@ static int uvc_v4l2_set_streamparm(struct uvc_streaming
> *stream, return -EBUSY;
>  	}
> 
> -	memcpy(&probe, &stream->ctrl, sizeof probe);
> +	probe = stream->ctrl;
>  	probe.dwFrameInterval =
>  		uvc_try_frame_interval(stream->cur_frame, interval);
> 
> @@ -397,7 +397,7 @@ static int uvc_v4l2_set_streamparm(struct uvc_streaming
> *stream, return ret;
>  	}
> 
> -	memcpy(&stream->ctrl, &probe, sizeof probe);
> +	stream->ctrl = probe;
>  	mutex_unlock(&stream->mutex);
> 
>  	/* Return the actual frame period. */

-- 
Regards,

Laurent Pinchart

