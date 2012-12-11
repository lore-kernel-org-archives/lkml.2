Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991Ab2LKHXK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 02:23:10 -0500
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1374 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108Ab2LKHXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 02:23:09 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Cyril Roelandt <tipecaml@gmail.com>
Subject: Re: [PATCH 1/1] media: saa7146: don't use mutex_lock_interruptible() in device_release().
Date: Tue, 11 Dec 2012 08:22:19 +0100
User-Agent: KMail/1.13.7 (Linux/3.7.0-rc1-tschai; KDE/4.8.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        michael@mihu.de, mchehab@redhat.com, linux-media@vger.kernel.org
References: <1355195128-10209-1-git-send-email-tipecaml@gmail.com> <1355195128-10209-2-git-send-email-tipecaml@gmail.com>
In-Reply-To: <1355195128-10209-2-git-send-email-tipecaml@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201212110822.19555.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue December 11 2012 04:05:28 Cyril Roelandt wrote:
> Use uninterruptible mutex_lock in the release() file op to make sure all
> resources are properly freed when a process is being terminated. Returning
> -ERESTARTSYS has no effect for a terminating process and this may cause driver
> resources not to be released.

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

	Hans

> This was found using the following semantic patch (http://coccinelle.lip6.fr/):
> 
> <spml>
> @r@
> identifier fops;
> identifier release_func;
> @@
> static const struct v4l2_file_operations fops = {
> .release = release_func
> };
> 
> @depends on r@
> identifier r.release_func;
> expression E;
> @@
> static int release_func(...)
> {
> ...
> - if (mutex_lock_interruptible(E)) return -ERESTARTSYS;
> + mutex_lock(E);
> ...
> }
> </spml>
> 
> Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>
> ---
>  drivers/media/common/saa7146/saa7146_fops.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/media/common/saa7146/saa7146_fops.c b/drivers/media/common/saa7146/saa7146_fops.c
> index b3890bd..0afe98d 100644
> --- a/drivers/media/common/saa7146/saa7146_fops.c
> +++ b/drivers/media/common/saa7146/saa7146_fops.c
> @@ -265,8 +265,7 @@ static int fops_release(struct file *file)
>  
>  	DEB_EE("file:%p\n", file);
>  
> -	if (mutex_lock_interruptible(vdev->lock))
> -		return -ERESTARTSYS;
> +	mutex_lock(vdev->lock);
>  
>  	if (vdev->vfl_type == VFL_TYPE_VBI) {
>  		if (dev->ext_vv_data->capabilities & V4L2_CAP_VBI_CAPTURE)
> 
