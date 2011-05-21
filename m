Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214Ab1EUMsU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 08:48:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:60559 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755432Ab1EUMsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 08:48:18 -0400
Message-ID: <4DD7B48B.3080507@infradead.org>
Date: Sat, 21 May 2011 09:48:11 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Jim Cromie <jim.cromie@gmail.com>
CC: linux-kernel@vger.kernel.org, gregkh@suse.de, linux-media@vger.kernel.org
Subject: Re: [PATCH 06/23] use register_chrdev_ids in drivers/media/
References: <1305840792-25877-1-git-send-email-jim.cromie@gmail.com> <1305840792-25877-7-git-send-email-jim.cromie@gmail.com>
In-Reply-To: <1305840792-25877-7-git-send-email-jim.cromie@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 19-05-2011 18:33, Jim Cromie escreveu:
> Since new api passes dev_t*, hoist inline MKDEV out to local var
> assignment, and replace other inline MKDEVs with new var.

While I don't see the need for this change, I'm ok with that.

Please notice that it is not clear if you expect me to apply the patch or not,
as you simply c/c me and Greg on it.

So I'm assuming that somebody else will be applying it. In this case:

Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>

> 
> This and 2 subsequent patches brought to you by coccinelle/spatch
> 
> cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> cc: linux-media@vger.kernel.org
> 
> @ rcr_md @
> identifier f;
> expression major, minor;
> expression ct, name;
> @@
> 
> 	f(...) {
> // ++ gives multiple inserts, needed for tty_io.c, fix up manually
> // fresh identifier apparently also helps here
> ++	dev_t devt;
> ++	devt = MKDEV(major,minor);
> 
> <+...
> -	register_chrdev_region
> +	register_chrdev_ids
> 	(
> -	MKDEV(major,minor),
> +	&devt,
> 	ct, name)
> ...+>
> 
> }
> 
> @ all_md depends on rcr_md @	// where above changes made, also do
> identifier f;
> expression major, minor;
> @@
> 
> 	f(...) {
> 	dev_t devt;
> 	devt = MKDEV(major,minor);
> 
> <+...
> -	MKDEV(major,minor)
> +	devt
> ...+>
> 	}
> 
> Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
> ---
>  drivers/media/dvb/dvb-core/dvbdev.c |    6 ++++--
>  drivers/media/media-devnode.c       |    3 +--
>  drivers/media/rc/lirc_dev.c         |    4 ++--
>  drivers/media/video/v4l2-dev.c      |    2 +-
>  4 files changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/media/dvb/dvb-core/dvbdev.c b/drivers/media/dvb/dvb-core/dvbdev.c
> index f732877..225b9d5 100644
> --- a/drivers/media/dvb/dvb-core/dvbdev.c
> +++ b/drivers/media/dvb/dvb-core/dvbdev.c
> @@ -464,8 +464,10 @@ static int __init init_dvbdev(void)
>  	int retval;
>  	dev_t dev = MKDEV(DVB_MAJOR, 0);
>  
> -	if ((retval = register_chrdev_region(dev, MAX_DVB_MINORS, "DVB")) != 0) {
> -		printk(KERN_ERR "dvb-core: unable to get major %d\n", DVB_MAJOR);
> +	retval = register_chrdev_ids(&dev, MAX_DVB_MINORS, "DVB");
> +	if (retval != 0) {
> +		printk(KERN_ERR "dvb-core: unable to get major %d\n",
> +		       DVB_MAJOR);
>  		return retval;
>  	}
>  
> diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
> index af5263c..e45f322 100644
> --- a/drivers/media/media-devnode.c
> +++ b/drivers/media/media-devnode.c
> @@ -289,8 +289,7 @@ static int __init media_devnode_init(void)
>  	int ret;
>  
>  	printk(KERN_INFO "Linux media interface: v0.10\n");
> -	ret = alloc_chrdev_region(&media_dev_t, 0, MEDIA_NUM_DEVICES,
> -				  MEDIA_NAME);
> +	ret = register_chrdev_ids(&media_dev_t, MEDIA_NUM_DEVICES, MEDIA_NAME);
>  	if (ret < 0) {
>  		printk(KERN_WARNING "media: unable to allocate major\n");
>  		return ret;
> diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
> index fd237ab..28f2968 100644
> --- a/drivers/media/rc/lirc_dev.c
> +++ b/drivers/media/rc/lirc_dev.c
> @@ -780,11 +780,11 @@ static int __init lirc_dev_init(void)
>  		goto error;
>  	}
>  
> -	retval = alloc_chrdev_region(&lirc_base_dev, 0, MAX_IRCTL_DEVICES,
> +	retval = register_chrdev_ids(&lirc_base_dev, MAX_IRCTL_DEVICES,
>  				     IRCTL_DEV_NAME);
>  	if (retval) {
>  		class_destroy(lirc_class);
> -		printk(KERN_ERR "lirc_dev: alloc_chrdev_region failed\n");
> +		printk(KERN_ERR "lirc_dev: register_chrdev_ids() failed\n");
>  		goto error;
>  	}
>  
> diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
> index 6dc7196..9ae24e2 100644
> --- a/drivers/media/video/v4l2-dev.c
> +++ b/drivers/media/video/v4l2-dev.c
> @@ -761,7 +761,7 @@ static int __init videodev_init(void)
>  	int ret;
>  
>  	printk(KERN_INFO "Linux video capture interface: v2.00\n");
> -	ret = register_chrdev_region(dev, VIDEO_NUM_DEVICES, VIDEO_NAME);
> +	ret = register_chrdev_ids(&dev, VIDEO_NUM_DEVICES, VIDEO_NAME);
>  	if (ret < 0) {
>  		printk(KERN_WARNING "videodev: unable to get major %d\n",
>  				VIDEO_MAJOR);

