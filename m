Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758931Ab1IIOO3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 10:14:29 -0400
Received: from smtp-out.google.com ([216.239.44.51]:21728 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758337Ab1IIOO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 10:14:27 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:content-type:to:cc:subject:references:date:
	mime-version:content-transfer-encoding:from:organization:message-id:
	in-reply-to:user-agent:x-system-of-record;
	b=X2IAyjj7ABhyBULkvIXDE4PT2N5eMzVtQfGiPtmQ3uKqnGnIgmehScz80yzmUB1Pu
	kQX4O9sHTJ+u9YIbgTzQQ==
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Alan Stern" <stern@rowland.harvard.edu>, "Felipe Balbi" <balbi@ti.com>,
        "Michal Nazarewicz" <mnazarewicz@google.com>
Cc: "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
        "Yang Rui Rui" <ruirui.r.yang@tieto.com>,
        "Dave Young" <hidave.darkstar@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv5 2/4] usb: gadget: replace "is_dualspeed" with
 "max_speed"
References: <cover.1314364322.git.mina86@mina86.com>
 <befb5cae917585ee1caee515426cb11045ce1d6b.1314364323.git.mina86@mina86.com>
Date: Fri, 09 Sep 2011 16:14:21 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mnazarewicz@google.com>
Organization: Google
Message-ID: <op.v1joh7yevgw7ix@mnazarewicz-glaptop>
In-Reply-To: <befb5cae917585ee1caee515426cb11045ce1d6b.1314364323.git.mina86@mina86.com>
User-Agent: Opera Mail/11.51 (Linux)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Aug 2011 15:18:35 +0200, Michal Nazarewicz  
<mnazarewicz@google.com> wrote:
> This commit replaces usb_gadget's is_dualspeed field with
> a max_speed field.
> ---
>
> I was unable to figure out how to create a symlink in
> non-race-condition way so for now I've created both speed and
> current_speed attributes.  This needs to get fixed before getting
> merged.
>
> I would even consider just removing speed since udc-core got merged
> only in 3.1, so maybe it won't be such a big issue?

I've dug a bit deeper and could not find *any* way of creating the
speed -> current_speed symlink.  sysfs_create_link() requires target
to be an kobject and as far as I can see attributes don't have one.

So I see the following possibilities:

1. Leave speed only (as Felipe noticed, this may be confusing for
    users since there will be "speed" and "maximum_speed").
2. Rename it to current_speed without transition period (udc-core is
    young so maybe no one will notice, but that won't be very nice).
3. Add current_speed and mark speed deprecated (this may be confusing
    because there will be two attributes with the same value).

>  static DEVICE_ATTR(soft_connect, S_IWUSR, NULL, usb_udc_softconn_store);
> -static ssize_t usb_udc_speed_show(struct device *dev,
> +#define USB_UDC_SPEED_ATTR(name, param)					\
> +ssize_t usb_udc_##param##_show(struct device *dev,			\
> +		struct device_attribute *attr, char *buf)		\
> +{									\
> +	struct usb_udc *udc = container_of(dev, struct usb_udc, dev);	\
> +	return snprintf(buf, PAGE_SIZE, "%s\n",				\
> +			usb_speed_string(udc->gadget->param));		\
> +}									\
> +static DEVICE_ATTR(name, S_IRUSR, usb_udc_##param##_show, NULL)
> +
> +static USB_UDC_SPEED_ATTR(current_speed, speed);
> +static USB_UDC_SPEED_ATTR(maximum_speed, max_speed);
> +/* XXX Change to symlink? */
> +/* TODO: Scheduled for removal in 3.8. */
> +static DEVICE_ATTR(speed, S_IRUSR, usb_udc_speed_show, NULL);

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
