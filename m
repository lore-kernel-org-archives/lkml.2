Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757758Ab1DAPF5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 11:05:57 -0400
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2691 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757424Ab1DAPFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 11:05:54 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: Re: [PATCH] v4l: subdev: initialize sd->internal_ops in v4l2_subdev_init
Date: Fri, 1 Apr 2011 17:05:27 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.38-tschai; KDE/4.6.1; x86_64; ; )
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1301667857-5145-1-git-send-email-herton.krzesinski@canonical.com> <1301667857-5145-2-git-send-email-herton.krzesinski@canonical.com>
In-Reply-To: <1301667857-5145-2-git-send-email-herton.krzesinski@canonical.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201104011705.27742.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, April 01, 2011 16:24:17 Herton Ronaldo Krzesinski wrote:
> Many v4l drivers currently don't initialize their struct v4l2_subdev
> with zeros, so since the addition of internal_ops in commit 45f6f84, we
> are at risk of random oopses when code in v4l2_device_register_subdev
> tries to dereference sd->internal_ops->*, as can be shown by the report
> at http://bugs.launchpad.net/bugs/745213
> 
> So make sure internal_ops is cleared in v4l2_subdev_init.

NACK: we need to replace those kmalloc's with kzalloc. This patch will just
fix the internal_ops problem, but sd->entity isn't zeroed. It's going to be
a neverending problem unless we fix those kmalloc's. It is my fault, I guess:
I should always have required the use of kzalloc.

I grepped for this and the number of kmalloc's is quite small:

drivers/media/video/tda9840.c
drivers/media/video/upd64031a.c
drivers/media/video/m52790.c
drivers/media/video/tea6415c.c
drivers/media/video/tea6420.c
drivers/media/video/upd64083.c
drivers/media/radio/saa7706h.c
drivers/media/radio/tef6862.c

If you fix those kmalloc's, then I'll ack those changes. There is just one
relevant kmalloc in each file.

The reason this wasn't noticed before is that all these devices are all
pretty rare. All the more common device drivers use kzalloc. I am really
surprised to hear of mxb boards still in use! Just for the record: I have
one myself for testing, although I clearly never realized that I should
test that particular change with that board...

Thanks for doing such a great job of tracking this down!

Regards,

	Hans

> 
> BugLink: http://bugs.launchpad.net/bugs/745213
> Cc: <stable@kernel.org> # .38.x
> Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
> ---
>  drivers/media/video/v4l2-subdev.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-subdev.c b/drivers/media/video/v4l2-subdev.c
> index 0b80644..0f70c74 100644
> --- a/drivers/media/video/v4l2-subdev.c
> +++ b/drivers/media/video/v4l2-subdev.c
> @@ -324,6 +324,7 @@ void v4l2_subdev_init(struct v4l2_subdev *sd, const struct v4l2_subdev_ops *ops)
>  	sd->grp_id = 0;
>  	sd->dev_priv = NULL;
>  	sd->host_priv = NULL;
> +	sd->internal_ops = NULL;
>  #if defined(CONFIG_MEDIA_CONTROLLER)
>  	sd->entity.name = sd->name;
>  	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV;
> 
