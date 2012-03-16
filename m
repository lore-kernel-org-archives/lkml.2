Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759095Ab2CPDvc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 23:51:32 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:8889 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756577Ab2CPDvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 23:51:15 -0400
X-AuditID: cbfee60d-b7cbaae00000452e-64-4f62b8b2ef35
Date: Fri, 16 Mar 2012 03:51:14 +0000 (GMT)
From: Yong-Sul Oh <yongsul96.oh@samsung.com>
Subject: Fwd: Re: [PATCH] USB: Gadget: Composite: Added error handling codes to
 prevent a memory leak case when the configuration's bind function failed
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Yong-Sul Oh <yongsul96.oh@samsung.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: yongsul96.oh@samsung.com
MIME-version: 1.0
X-MTR: 20120316034841659@yongsul96.oh
Msgkey: 20120316034841659@yongsul96.oh
X-EPLocale: ko_KR.utf-8
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120316013931122@yongsul96.oh
X-ParentMTR: 20120316013931122@yongsul96.oh
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <15586286.198201331869871111.JavaMail.weblogic@epml26>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q2G3po9r008516

Dear Michal Nazarewicz

I'm very thank you for your comments about this patch.
And I think you might mis-understand my mention about this patch.
(Becasue i'm not native english speaker)

My point is that,
 if the next function(second or third) binding is failed,
  all already added functions that successfully added by making instance are useless functions
  and these "useless function instances" are make "memory leak situation" because the following codes
 (by following codes, composite-FW or gadget-FW cannot handle it anymore)

    694) list_del(&config->list);
    695) config->cdev = NULL;
   (original codes of composite.c)

>Also, should this be handled in usb_gadget_probe_driver() instead?  Ie. on error
>recovery path, should usb_gadget_probe_driver() call usb_gadget_remove_driver()?
 
 => the usb_gadget_remove_driver() cannot handle it because the configuration (that has next function binding failure)
    was already separated from "cdev" by the 694 & 695 line of composite.c

>In particular, if I'm not mistaken, for (some?) gadgets with two configurations
>(like g_multi), if the second configuration fails, the first one will not get
>removed, so the memory will still leak, no?

 => you're right , but this your mention case is different with the "memory leak situation" as already mentioned for my patch
 Because your mention case can be freed later(because first one doesn't separated from "cdev") but my case cannot free it


Best regards,  
Yongsul Oh
------- Original Message -------
Sender : Michal Nazarewicz<mina86@mina86.com>
Date : 2012-03-15 17:19 (GMT+09:00)
Title : Re: [PATCH] USB: Gadget: Composite: Added error handling codes to prevent a memory leak case when the configuration's bind function failed

On Thu, 15 Mar 2012 02:23:55 +0100, wrote:
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

> Signed-off-by: yongsul96.oh@samsung.com 
> ---
>  drivers/usb/gadget/composite.c |   13 +++++++++++++
>  1 files changed, 13 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
> index baaebf2..4cb1801 100644
> --- a/drivers/usb/gadget/composite.c
> +++ b/drivers/usb/gadget/composite.c
> @@ -737,6 +737,19 @@ int usb_add_config(struct usb_composite_dev *cdev,
> status = bind(config);
>   if (status < 0) {
> + while (!list_empty(&config->functions)) {
> + struct usb_function *f;
> +
> + f = list_first_entry(&config->functions,
> + struct usb_function, list);
> + list_del(&f->list);
> + if (f->unbind) {
> + DBG(cdev, "unbind function '%s'/%p\n",
> + f->name, f);
> + f->unbind(config, f);
> + /* may free memory for "f" */
> + }
> + }
>   list_del(&config->list);
>   config->cdev = NULL;
>   } else {


-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  MichaÅ‚ â€œmina86â€ Nazarewicz    (o o)
ooo +------------------ooO--(_)--Ooo--






 Oh, Yong-Sul
Engineer

Mobile S/W Platform Lab.
Telecommunication R&D Center
Telecommunication Network Business

SAMSUNG ELECTRONICS CO.,LTD

Tel : +82-31-279-0284
Mobile : +82-10-9530-0284
Fax : +82-31-279-5521
E-mail : yongsul96.oh@samsung.com




Copyrightâ“’ 2005 Samsung Electronics Co., Ltd. All rights reserved | Confidential

The information contained in this message is confidential and may be legally privileged. The message is intended solely for the addressee(s). If you are not the intended recipient, you are hereby notified that any use, dissemination, or reproduction is strictly prohibited and may be unlawful. If you are not the intended recipient, please contact the sender by return e-mail and destroy all copies of the original message.  






 Oh, Yong-Sul
Engineer

Mobile S/W Platform Lab.
Telecommunication R&D Center
Telecommunication Network Business

SAMSUNG ELECTRONICS CO.,LTD

Tel : +82-31-279-0284
Mobile : +82-10-9530-0284
Fax : +82-31-279-5521
E-mail : yongsul96.oh@samsung.com




Copyrightâ“’ 2005 Samsung Electronics Co., Ltd. All rights reserved | Confidential

The information contained in this message is confidential and may be legally privileged. The message is intended solely for the addressee(s). If you are not the intended recipient, you are hereby notified that any use, dissemination, or reproduction is strictly prohibited and may be unlawful. If you are not the intended recipient, please contact the sender by return e-mail and destroy all copies of the original message. ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
