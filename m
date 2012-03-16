Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422708Ab2CPLOo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 07:14:44 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:56819 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965483Ab2CPLOn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 07:14:43 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Felipe Balbi" <balbi@ti.com>, "Yongsul Oh" <yongsul96.oh@samsung.com>
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Michal Nazarewicz" <mnazarewicz@gmail.com>,
        "Sergei Shtylyov" <sshtylyov@mvista.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: Gadget: Composite: Added error handling codes to
 prevent a memory leak case when the configuration's bind function failed
References: <1331879235-2910-1-git-send-email-yongsul96.oh@samsung.com>
Date: Fri, 16 Mar 2012 12:14:37 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.wa9f6nz03l0zgt@mpn-glaptop>
In-Reply-To: <1331879235-2910-1-git-send-email-yongsul96.oh@samsung.com>
User-Agent: Opera Mail/11.61 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Mar 2012 07:27:15 +0100, Yongsul Oh <yongsul96.oh@samsung.com> wrote:

>  In some usb gadget driver, (for example usb gadget serial driver(serial.c),

s/usb/USB/g
s/gadget driver/composite gadget drivers/

I also don't think the list of examples is necessary here.  Maybe just a list file
names? My personal opinion, others may disagree though.

Also, comma should go after the closing paren.

> multifunction composite driver(multi,c), nokia composite gadget driver(nokia.c),
> HID composite driver(hid.c), CDC composite driver(cdc2.c)..) the configuration's
> bind function by called the 'usb_add_config()' has multiple bind config functions

s/by called the/called by the/
s/has/calls/

> for each functionality. (for example cdc2 configuration bind function -'cdc_do_config()'

s/functions for each functionality/functions, one for each USB functionality/

> has two functionality bind config functions -'ecm_bind_config()' & 'acm_bind_config()'
> in CDC composite driver.)
>
>  In each functionality bind config function, new instance for each functionality is

s/for each functionality//

> allocated & initialized by 'kzalloc()' and finally the new instance is added by

s/& initialized by 'kzalloc()' and finally the new instance/and/

> 'usb_add_function()'. After 'usb_add_function' state, already created the instance
> is only handled by it's configuration & freed from functionality unbind function.

I'm not sure what you meant by this last sentence.

>  So, If an error occurred during the second functionality bind config state,

s/If/if/
s/state//

> (for example an error occurred at 'acm_bind_config()' after succeeding of
> 'ecm_bind_function()') the created instance by 'acm_bind_config()'

s/the created instance by 'acm_bind_config()'/the instance created by acm_bind_config()/

> cannot be freed. And it makes memory leak situation.

s/freed. And it makes memory leak situation./freed creating a memory leak./

> This patch fixes this issue

s/issue/issue./

Also, drop apostrophes around function names.  It looks weird.

> Signed-off-by: Yongsul Oh <yongsul96.oh@samsung.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

Also, like written previously, I think there might be memory leak in other error
recovery paths as well.  If you could take a look whether I'm right, that would be
awesome.

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
