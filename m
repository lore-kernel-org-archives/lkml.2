Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933207Ab0FRN60 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 09:58:26 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:45522 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932422Ab0FRN6Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 09:58:24 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Fri, 18 Jun 2010 15:59:17 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH 5/6] usb/gadget: Do not take BKL for gadget->ops->ioctl
In-reply-to: <1275426285-9088-6-git-send-email-arnd@arndb.de>
To: Greg KH <gregkh@suse.de>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       John Kacur <jkacur@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       David Brownell <dbrownell@users.sourceforge.net>
Message-id: <op.veh043ad7p4s8u@pikus>
Organization: Samsung Electronics
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.60 (Linux)
References: <1275426285-9088-1-git-send-email-arnd@arndb.de>
 <1275426285-9088-6-git-send-email-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 01 Jun 2010 23:04:44 +0200, Arnd Bergmann <arnd@arndb.de> wrote:
> There is no gadget driver in the tree that
> actually implements the ioctl operation, so
> obviously it is not necessary to hold the
> BKL around the call.

Should the callback in ops be renamed to unlocked_ioctl then as to not
create confusion? Just a thought.

> --- a/drivers/usb/gadget/f_fs.c
> +++ b/drivers/usb/gadget/f_fs.c
> @@ -714,9 +714,7 @@ static long ffs_ep0_ioctl(struct file *file, unsigned code, unsigned long value)
>  		struct ffs_function *func = ffs->func;
>  		ret = func ? ffs_func_revmap_intf(func, value) : -ENODEV;
>  	} else if (gadget->ops->ioctl) {
> -		lock_kernel();
>  		ret = gadget->ops->ioctl(gadget, code, value);
> -		unlock_kernel();
>  	} else {
>  		ret = -ENOTTY;
>  	}

> --- a/drivers/usb/gadget/inode.c
> +++ b/drivers/usb/gadget/inode.c
> @@ -1299,11 +1299,9 @@ static long dev_ioctl (struct file *fd, unsigned code, unsigned long value)
>  	struct usb_gadget	*gadget = dev->gadget;
>  	long ret = -ENOTTY;
>-	if (gadget->ops->ioctl) {
> -		lock_kernel();
> +	if (gadget->ops->ioctl)
>  		ret = gadget->ops->ioctl (gadget, code, value);
> -		unlock_kernel();
> -	}
> +
>  	return ret;
>  }

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
