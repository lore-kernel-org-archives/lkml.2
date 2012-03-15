Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760246Ab2COITZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 04:19:25 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33370 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756256Ab2COITF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 04:19:05 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Felipe Balbi" <balbi@ti.com>, Yongsul@vger.kernel.org, Oh@vger.kernel.org
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        "yongsul96.oh@samsung.com" <yongsul96.oh@samsung.com>
Subject: Re: [PATCH] USB: Gadget: Composite: Added error handling codes to
 prevent a memory leak case when the configuration's bind function failed
References: <1331774635-21217-1-git-send-email-yongsul96.oh@samsung.com>
Date: Thu, 15 Mar 2012 09:19:01 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.wa7ddzix3l0zgt@mpn-glaptop>
In-Reply-To: <1331774635-21217-1-git-send-email-yongsul96.oh@samsung.com>
User-Agent: Opera Mail/11.61 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2012 02:23:55 +0100, <Yongsul@vger.kernel.org> wrote:
>  In some usb gadget driver, for example usb gadget serial driver(serial.c),
> multifunction composite driver(multi,c), nokia composite gadget driver(nokia.c),
> HID composite driver(hid.c), CDC composite driver(cdc2.c).., the configuration's
> bind function by called the 'usb_add_config()' has multiple bind config functions
> for each functionality, for example cdc2 configuration bind function -'cdc_do_config()'
> has two functionality bind config functions -'ecm_bind_config()' & 'acm_bind_config()'
> in CDC composite driver.
>  In each functionality bind config function, new instance for each functionality is
> allocated & initialized by 'kzalloc()' ,and finally the new instance is added by
> 'usb_add_function()'. After 'usb_add_function' state, already created the instance
> is only handled by its configuration & freed from functionality unbind function.
>  So, If an error occurred during the second functionality bind config state, for example
> an error occurred at 'acm_bind_config()' after succeeding 'ecm_bind_function()',
> The created instance by 'acm_bind_config()' cannot be freed.
> And it makes memory leak situation.

It may be my poor English skills, but this is very hard to read.

Also, should this be handled in usb_gadget_probe_driver() instead?  Ie. on error
recovery path, should usb_gadget_probe_driver() call usb_gadget_remove_driver()?

In particular, if I'm not mistaken, for (some?) gadgets with two configurations
(like g_multi), if the second configuration fails, the first one will not get
removed, so the memory will still leak, no?

> Signed-off-by: yongsul96.oh@samsung.com <yongsul96.oh@samsung.com>
> ---
>  drivers/usb/gadget/composite.c |   13 +++++++++++++
>  1 files changed, 13 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
> index baaebf2..4cb1801 100644
> --- a/drivers/usb/gadget/composite.c
> +++ b/drivers/usb/gadget/composite.c
> @@ -737,6 +737,19 @@ int usb_add_config(struct usb_composite_dev *cdev,
> 	status = bind(config);
>  	if (status < 0) {
> +		while (!list_empty(&config->functions)) {
> +			struct usb_function		*f;
> +
> +			f = list_first_entry(&config->functions,
> +					struct usb_function, list);
> +			list_del(&f->list);
> +			if (f->unbind) {
> +				DBG(cdev, "unbind function '%s'/%p\n",
> +					f->name, f);
> +				f->unbind(config, f);
> +				/* may free memory for "f" */
> +			}
> +		}
>  		list_del(&config->list);
>  		config->cdev = NULL;
>  	} else {


-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
