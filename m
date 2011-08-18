Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937Ab1HRM2z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 08:28:55 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50416 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755555Ab1HRM2w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 08:28:52 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, "Per Forlin" <per.forlin@linaro.org>
References: <1313659726-9406-1-git-send-email-per.forlin@stericsson.com>
Subject: Re: [PATCH v4] usb: gadget: storage_common: make FSG_NUM_BUFFERS
 variable size
To: "Felipe Balbi" <balbi@ti.com>, "Greg Kroah-Hartman" <gregkh@suse.de>,
        "Per Forlin" <per.forlin@stericsson.com>
Date: Thu, 18 Aug 2011 14:28:47 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.v0esx9lx3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <1313659726-9406-1-git-send-email-per.forlin@stericsson.com>
User-Agent: Opera Mail/11.50 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Aug 2011 11:28:46 +0200, Per Forlin wrote:
> diff --git a/drivers/usb/gadget/f_mass_storage.c  
> b/drivers/usb/gadget/f_mass_storage.c
> index 5b93395..3e546d9 100644
> --- a/drivers/usb/gadget/f_mass_storage.c
> +++ b/drivers/usb/gadget/f_mass_storage.c
> @@ -363,7 +363,6 @@ struct fsg_common {
> 	struct fsg_buffhd	*next_buffhd_to_fill;
>  	struct fsg_buffhd	*next_buffhd_to_drain;
> -	struct fsg_buffhd	buffhds[FSG_NUM_BUFFERS];
> 	int			cmnd_size;
>  	u8			cmnd[MAX_COMMAND_SIZE];
> @@ -407,6 +406,8 @@ struct fsg_common {
>  	char inquiry_string[8 + 16 + 4 + 1];
> 	struct kref		ref;
> +	/* Must be the last entry */
> +	struct fsg_buffhd	buffhds[0];

I would rather see it as “struct fsg_buffhd *buffhds;” since this change
requires both mass_storage.c and multi.c to be changed.

Alternatively, revert the possibility for fsg_common_init() to take struct
fsg_common as an argument, but that would be more intrusive I think and
I would prefer the former.

>  };
> struct fsg_config {
> @@ -2728,12 +2729,15 @@ static struct fsg_common *fsg_common_init(struct  
> fsg_common *common,
> 	/* Allocate? */
>  	if (!common) {
> -		common = kzalloc(sizeof *common, GFP_KERNEL);
> +		common = kzalloc(sizeof(struct fsg_common) +
> +				 sizeof(struct fsg_buffhd) * FSG_NUM_BUFFERS,
> +				 GFP_KERNEL);

Better yet:

kzalloc(sizeof *common + FSG_NUM_BUFFERS * sizeof *(common->buffhds),
GFP_KERNEL);

but like I've said, I would prefer that buffhds is a separate array.

> diff --git a/drivers/usb/gadget/file_storage.c  
> b/drivers/usb/gadget/file_storage.c
> index 639e14a..21d366d 100644
> --- a/drivers/usb/gadget/file_storage.c
> +++ b/drivers/usb/gadget/file_storage.c
> @@ -461,7 +461,6 @@ struct fsg_dev {
> 	struct fsg_buffhd	*next_buffhd_to_fill;
>  	struct fsg_buffhd	*next_buffhd_to_drain;
> -	struct fsg_buffhd	buffhds[FSG_NUM_BUFFERS];
> 	int			thread_wakeup_needed;
>  	struct completion	thread_notifier;
> @@ -488,6 +487,8 @@ struct fsg_dev {
>  	unsigned int		nluns;
>  	struct fsg_lun		*luns;
>  	struct fsg_lun		*curlun;
> +	/* Must be the last entry */
> +	struct fsg_buffhd	buffhds[0];

IIRC, C99's way of doing it is:  “struct fsg_buffhd buffhds[];”.

>  };
> typedef void (*fsg_routine_t)(struct fsg_dev *);
> @@ -3587,7 +3588,9 @@ static int __init fsg_alloc(void)
>  {
>  	struct fsg_dev		*fsg;
> -	fsg = kzalloc(sizeof *fsg, GFP_KERNEL);
> +	fsg = kzalloc(sizeof(struct fsg_dev) +
> +		      sizeof(struct fsg_buffhd) * FSG_NUM_BUFFERS, GFP_KERNEL);
> +

Better yet:

kzalloc(sizeof *fsg + FSG_NUM_BUFFERS * sizeof *(fsg->buffhds),
GFP_KERNEL);

>  	if (!fsg)
>  		return -ENOMEM;
>  	spin_lock_init(&fsg->lock);

> diff --git a/drivers/usb/gadget/mass_storage.c  
> b/drivers/usb/gadget/mass_storage.c
> index d3eb274..67c58d0 100644
> --- a/drivers/usb/gadget/mass_storage.c
> +++ b/drivers/usb/gadget/mass_storage.c
> @@ -116,9 +116,8 @@ static int __init msg_do_config(struct  
> usb_configuration *c)
>  	static const struct fsg_operations ops = {
>  		.thread_exits = msg_thread_exits,
>  	};
> -	static struct fsg_common common;
> +	struct fsg_common *common = NULL;
> -	struct fsg_common *retp;
>  	struct fsg_config config;
>  	int ret;
> @@ -130,12 +129,12 @@ static int __init msg_do_config(struct  
> usb_configuration *c)
>  	fsg_config_from_params(&config, &mod_data);
>  	config.ops = &ops;
> -	retp = fsg_common_init(&common, c->cdev, &config);
> -	if (IS_ERR(retp))
> -		return PTR_ERR(retp);
> +	common = fsg_common_init(common, c->cdev, &config);

The first argument should be NULL.

> +	if (IS_ERR(common))
> +		return PTR_ERR(common);
> -	ret = fsg_bind_config(c->cdev, c, &common);
> -	fsg_common_put(&common);
> +	ret = fsg_bind_config(c->cdev, c, common);
> +	fsg_common_put(common);
>  	return ret;
>  }


> diff --git a/drivers/usb/gadget/storage_common.c  
> b/drivers/usb/gadget/storage_common.c
> index d3dd227..197eace 100644
> --- a/drivers/usb/gadget/storage_common.c
> +++ b/drivers/usb/gadget/storage_common.c
> @@ -262,8 +262,24 @@ static struct fsg_lun *fsg_lun_from_dev(struct  
> device *dev)
>  #define EP0_BUFSIZE	256
>  #define DELAYED_STATUS	(EP0_BUFSIZE + 999)	/* An impossibly large value  
> */
> -/* Number of buffers we will use.  2 is enough for double-buffering */
> -#define FSG_NUM_BUFFERS	2
> +#ifdef CONFIG_USB_DEBUG
> +
> +static unsigned int fsg_num_buffers =  
> CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS;
> +module_param(fsg_num_buffers, uint, S_IRUGO);
> +MODULE_PARM_DESC(fsg_num_buffers, "Number of pipeline buffers");
> +#define FSG_NUM_BUFFERS	fsg_num_buffers

Could we get rid of the macro all together, and just stick to
“fsg_num_buffers” variable?  Upper case name suggest that it's
a compile time constant which is not true.

> +#else
> +
> +/*
> + * Number of buffers we will use.
> + * 2 is usually enough for good buffering pipeline
> + */
> +#define FSG_NUM_BUFFERS	CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS

Similarly, I'd change the name to lowercase as to reflect that sometimes
it may be not a compile-time constant.

> +#endif /* CONFIG_USB_DEBUG */
>
> +#define FSG_NUM_BUFFERS_IS_VALID(num) (num >= 2 && num <= 4 ? true :  
> false)

The “?:” is not needed.

#define FSG_NUM_BUFFERS_IS_VALID(num) ((num) >= 2 && (num) <= 4)

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
