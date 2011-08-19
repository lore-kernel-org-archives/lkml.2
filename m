Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143Ab1HSPZO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 11:25:14 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56992 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754543Ab1HSPZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 11:25:12 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Felipe Balbi" <balbi@ti.com>, "Alan Stern" <stern@rowland.harvard.edu>,
        "Per Forlin" <per.forlin@stericsson.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, "Greg Kroah-Hartman" <gregkh@suse.de>,
        "Per Forlin" <per.forlin@linaro.org>
Subject: Re: [PATCH v5] usb: gadget: storage: make FSG_NUM_BUFFERS variable
 size
References: <1313764105-28437-1-git-send-email-per.forlin@stericsson.com>
Date: Fri, 19 Aug 2011 17:25:08 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.v0gvr6sv3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <1313764105-28437-1-git-send-email-per.forlin@stericsson.com>
User-Agent: Opera Mail/11.50 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Aug 2011 16:28:25 +0200, Per Forlin <per.forlin@stericsson.com>  
wrote:
> @@ -3605,6 +3608,9 @@ static int __init fsg_init(void)
>  	int		rc;
>  	struct fsg_dev	*fsg;
> +	if (!FSG_NUM_BUFFERS_IS_VALID(fsg_num_buffers))

Care to add pr_err() here?  Or better yet, change  
fsg_num_buffers_is_valid()
to a function, eg.:

static inline int fsg_num_buffers_validate()
{
	if (fsg_num_buffers && fsg_num_buffers <= 4)
		return 0;
	pr_err("fsg_num_buffers too high: %u\n", fsg_num_buffers);
	return -EINVAL;
}

> +		return -EINVAL;
> +
>  	if ((rc = fsg_alloc()) != 0)
>  		return rc;
>  	fsg = the_fsg;


> diff --git a/drivers/usb/gadget/mass_storage.c  
> b/drivers/usb/gadget/mass_storage.c
> index d3eb274..fa6dedf 100644
> --- a/drivers/usb/gadget/mass_storage.c
> +++ b/drivers/usb/gadget/mass_storage.c
> @@ -179,6 +179,9 @@ MODULE_LICENSE("GPL");
> static int __init msg_init(void)
>  {
> +	if (!FSG_NUM_BUFFERS_IS_VALID(fsg_num_buffers))
> +		return -EINVAL;
> +
>  	return usb_composite_probe(&msg_driver, msg_bind);
>  }
>  module_init(msg_init);
> diff --git a/drivers/usb/gadget/multi.c b/drivers/usb/gadget/multi.c
> index 8c7b747..5f146da 100644
> --- a/drivers/usb/gadget/multi.c
> +++ b/drivers/usb/gadget/multi.c
> @@ -360,6 +360,9 @@ static struct usb_composite_driver multi_driver = {
> static int __init multi_init(void)
>  {
> +	if (!FSG_NUM_BUFFERS_IS_VALID(fsg_num_buffers))
> +		return -EINVAL;
> +
>  	return usb_composite_probe(&multi_driver, multi_bind);
>  }
>  module_init(multi_init);

I'd move the check from those two places to fsg_common_init().


Other then the above minor comments and buffers never being freed in
f_mass_storage.c, the code looks good to me.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
