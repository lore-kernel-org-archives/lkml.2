Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961Ab0JKSyL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 14:54:11 -0400
Received: from relay02.digicable.hu ([92.249.128.188]:57929 "EHLO
	relay02.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab0JKSyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 14:54:10 -0400
Message-ID: <4CB35D4C.9000406@freemail.hu>
Date: Mon, 11 Oct 2010 20:54:04 +0200
From: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Kees Cook <kees.cook@canonical.com>
CC: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Oliver Neukum <oliver@neukum.org>, Joe Perches <joe@perches.com>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] usb: don't trust report_size for buffer size
References: <20101011182816.GA15451@outflux.net>
In-Reply-To: <20101011182816.GA15451@outflux.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Original: 77.234.64.233
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook wrote:
> If the iowarrior devices in this case statement support more than 8 bytes
> per report, it is possible to write past the end of a kernel heap allocation.
> This will probably never be possible, but change the allocation to be more
> defensive anyway.

I think this might be triggered from user space, indeed. The iowarrior_class.fops->write
points directly to the function iowarrior_write(). The iowarrior_class itself
is passed to the function usb_register_dev(), which means that the write() system
call to the character device will result in calling the iowarrior_write() function.

> Signed-off-by: Kees Cook <kees.cook@canonical.com>
Acked-by: Márton Németh <nm127@freemail.hu>

There might be similar problem also in the case USB_DEVICE_ID_CODEMERCS_IOW56. There
is buf is allocated with usb_alloc_coherent() to the size dev->report_size. However,
some lines later the copy_from_user() function tries to copy "count" number of
bytes to the dev->report_size allocated buffer. Unfortunately I don't have such
devices to try the driver so these are just coming from "static analysis".

> ---
>  drivers/usb/misc/iowarrior.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/usb/misc/iowarrior.c b/drivers/usb/misc/iowarrior.c
> index bc88c79..8ed8d05 100644
> --- a/drivers/usb/misc/iowarrior.c
> +++ b/drivers/usb/misc/iowarrior.c
> @@ -374,7 +374,7 @@ static ssize_t iowarrior_write(struct file *file,
>  	case USB_DEVICE_ID_CODEMERCS_IOWPV2:
>  	case USB_DEVICE_ID_CODEMERCS_IOW40:
>  		/* IOW24 and IOW40 use a synchronous call */
> -		buf = kmalloc(8, GFP_KERNEL);	/* 8 bytes are enough for both products */
> +		buf = kmalloc(count, GFP_KERNEL);
>  		if (!buf) {
>  			retval = -ENOMEM;
>  			goto exit;

