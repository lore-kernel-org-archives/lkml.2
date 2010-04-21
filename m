Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446Ab0DUJKU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 05:10:20 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:32943 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686Ab0DUJKS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 05:10:18 -0400
Date: Wed, 21 Apr 2010 11:10:28 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH] Mass Storage Gadget: Handle eject request
In-reply-to: <1271752450-13964-1-git-send-email-fabien.chouteau@gmail.com>
To: fabien.chouteau@gmail.com, linux-usb@vger.kernel.org
Cc: Fabien Chouteau <fabien.chouteau@barco.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Peter Korsgaard <jacmet@sunsite.dk>, linux-kernel@vger.kernel.org
Message-id: <op.vbh83qxw7p4s8u@pikus>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.10 (Linux)
References: <1271752450-13964-1-git-send-email-fabien.chouteau@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Apr 2010 10:34:09 +0200, <fabien.chouteau@gmail.com> wrote:
> Handle eject request + sysfs entries to detect ejected LUN and suspended gadget.

> diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
> index f4911c0..af13a2f 100644
> --- a/drivers/usb/gadget/f_mass_storage.c
> +++ b/drivers/usb/gadget/f_mass_storage.c
> @@ -2412,6 +2449,26 @@ static void fsg_disable(struct usb_function *f)
>  	raise_exception(fsg->common, FSG_STATE_CONFIG_CHANGE);
>  }
>+static void fsg_suspend(struct usb_function *f)
> +{
> +	struct fsg_dev	*fsg = fsg_from_func(f);
> +	struct fsg_lun	*curlun = fsg->common->luns;
> +	int		i;
> +
> +	for (i = 0; i < fsg->common->nluns; i++, curlun++)
> +		curlun->suspended = 1;
> +}
> +
> +static void fsg_resume(struct usb_function *f)
> +{
> +	struct fsg_dev	*fsg = fsg_from_func(f);
> +	struct fsg_lun	*curlun = fsg->common->luns;
> +	int		i;
> +
> +	for (i = 0; i < fsg->common->nluns; i++, curlun++)
> +		curlun->suspended = 0;
> +}
> +

Clearly, suspend seems like a state of the mass storage function
as a whole rather then attribute of each logical unit so I think
it'll be better to make it global for the mass storage function
rather then per-LUN.

Even more so, it's a state of the whole gadget so in my opinion the
whole code should be moved the the gadget rather then kept in
a function!

Going even further, I would propose an sysfs entry to be added to
the composite framework as a single generic interface rather then
hacking it in each gadget/function that might need to export this
information to user space.

This provided that there is no easy way of gaining that information
in user space through same other sysfs entry.

Other then that, the patch seems fine.

-- 
Best regards,                                           _     _
  .o. | Liege of Serenely Enlightened Majesty of       o' \,=./ `o
  ..o | Computer Science,  Michał "mina86" Nazarewicz     (o o)
  ooo +---[mina86@mina86.com]---[mina86@jabber.org]---ooO--(_)--Ooo--
