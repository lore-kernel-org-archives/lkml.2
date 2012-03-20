Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759962Ab2CTNlf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 09:41:35 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35168 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759466Ab2CTNld convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 09:41:33 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Felipe Balbi" <balbi@ti.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Yongsul Oh" <yongsul96.oh@samsung.com>
Cc: "Michal Nazarewicz" <mnazarewicz@gmail.com>,
        "Sergei Shtylyov" <sshtylyov@mvista.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: Gadget: Composite: Added error handling codes to
 prevent a memory leak case when the configuration's bind function failed
References: <1332207518-24868-1-git-send-email-yongsul96.oh@samsung.com>
Date: Tue, 20 Mar 2012 14:41:30 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.wbg1ngqj3l0zgt@mpn-glaptop>
In-Reply-To: <1332207518-24868-1-git-send-email-yongsul96.oh@samsung.com>
User-Agent: Opera Mail/11.61 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Mar 2012 02:38:38 +0100, Yongsul Oh <yongsul96.oh@samsung.com> wrote:

>  In some USB composite gadget drivers, the configuration's bind function
>   called by the usb_add_config() calls multiple bind config functions.
>   (for example cdc2 configuration bind function in the cdc_do_config()
>   of the cdc2.c has two functionality bind config functions.
>   - the ecm_bind_config() & the acm_bind_config())
>
>  In each functionality bind config function, new instance is allocated and
>   finally added by the usb_add_function().
>
>  So if an error occurred during the second functionality bind config
>   (for example an error occurred at the acm_bind_config() after succeeding of
>   the ecm_bind_function()), the instance created by the acm_bind_config()
>   cannot be freed creating a memory leak.
>
>  This patch fixes this issue.
>
> Signed-off-by: Yongsul Oh <yongsul96.oh@samsung.com>

Like before:

Acked-by: Michal Nazarewicz <mina86@mina86.com>

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
