Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758335Ab1DMKsQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 06:48:16 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45200 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757885Ab1DMKsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 06:48:14 -0400
Message-ID: <4DA57F0F.1090609@ru.mvista.com>
Date: Wed, 13 Apr 2011 14:46:39 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: Tatyana Brokhman <tlinder@codeaurora.org>, gregkh@suse.de,
        linux-arm-msm@vger.kernel.org, balbi@ti.com, ablay@codeaurora.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] usb/gadget: don't deploy SS descriptors if SS is
 not enabled.
References: <20110411175917.GE4018@linutronix.de> <1302636896-12717-1-git-send-email-bigeasy@linutronix.de> <1302636896-12717-5-git-send-email-bigeasy@linutronix.de>
In-Reply-To: <1302636896-12717-5-git-send-email-bigeasy@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 12-04-2011 23:34, Sebastian Andrzej Siewior wrote:

> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>   drivers/usb/gadget/composite.c |    4 ++++
>   1 files changed, 4 insertions(+), 0 deletions(-)

> diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
> index 92cc238..ac30e2f 100644
> --- a/drivers/usb/gadget/composite.c
> +++ b/drivers/usb/gadget/composite.c
> @@ -74,10 +74,12 @@ MODULE_PARM_DESC(iSerialNumber, "SerialNumber string");
>   static char composite_manufacturer[50];
>
>   /* Default endpoint companion descriptor */
> +#ifdef CONFIG_USB_GADGET_SUPERSPEED
>   static struct usb_ss_ep_comp_descriptor default_ep_comp_desc = {
>   		.bDescriptorType = USB_DT_SS_ENDPOINT_COMP,
>   		.bLength = sizeof(struct usb_ss_ep_comp_descriptor),
>   };
> +#endif
>
>   /**
>    * usb_create_ss_descriptors() - Generate SuperSpeed descriptors
> @@ -93,6 +95,7 @@ static struct usb_ss_ep_comp_descriptor default_ep_comp_desc = {
>    */
>   void usb_create_ss_descriptors(struct usb_function *f)
>   {
> +#ifdef CONFIG_USB_GADGET_SUPERSPEED
>   	struct usb_ss_ep_comp_descriptor	*ep_comp_desc;
>   	struct usb_endpoint_descriptor		*ep_desc;
>   	struct usb_descriptor_header		**src = f->hs_descriptors;
> @@ -185,6 +188,7 @@ void usb_create_ss_descriptors(struct usb_function *f)
>   	 */
>   	*tmp = NULL;
>   	f->ss_desc_allocated = true;
> +#endif

    Documentation/SubmittingPatches says this:

2) #ifdefs are ugly

Code cluttered with ifdefs is difficult to read and maintain.  Don't do
it.  Instead, put your ifdefs in a header, and conditionally define
'static inline' functions, or macros, which are used in the code.
Let the compiler optimize away the "no-op" case.

Simple example, of poor code:

	dev = alloc_etherdev (sizeof(struct funky_private));
	if (!dev)
		return -ENODEV;
	#ifdef CONFIG_NET_FUNKINESS
	init_funky_net(dev);
	#endif

Cleaned-up example:

(in header)
	#ifndef CONFIG_NET_FUNKINESS
	static inline void init_funky_net (struct net_device *d) {}
	#endif

(in the code itself)
	dev = alloc_etherdev (sizeof(struct funky_private));
	if (!dev)
		return -ENODEV;
	init_funky_net(dev);

WBR, Sergei
