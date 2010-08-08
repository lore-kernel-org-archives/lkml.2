Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312Ab0HHO61 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 10:58:27 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:54362 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273Ab0HHO60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 10:58:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Subject: Re: [2.6.35 patch] add missing unlock_kernel calls...
Date: Sun, 8 Aug 2010 16:58:19 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Roger Lucas <vt8231@hiddenengine.co.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>
References: <AANLkTi=G9+wqWhJmX7QarQXeSw-8qASXMrz6mKvbBNw2@mail.gmail.com>
In-Reply-To: <AANLkTi=G9+wqWhJmX7QarQXeSw-8qASXMrz6mKvbBNw2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008081658.19790.arnd@arndb.de>
X-Provags-ID: V02:K0:TVVDp8ixmBIoNPuvaKs1kdgl3e5xBgGEHVcU7FGW5Le
 ab5oCGTAtB7UTZqHveC3Y124VKdHXwu0GLfm6hJZTdH3LAaaCn
 Pfr8pfDiFufCS7Stj+0CqKT2fiGxpsc1HG2O/sbK+zu1Pt6fGw
 KErzoISVUinV5KSmGPSyAW7556eEMyTDsdF4Mr8UkiXk+uEI1U
 aSdsuzivPWeg0TcKmwnbA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 08 August 2010, Daniel J Blueman wrote:
> Hi Roger,
> 
> Here is a fix for 2.6.36-rc1:
> 
> Ensure the BKL is dropped along all paths.
> 
> Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
> 
> diff --git a/drivers/hid/usbhid/hiddev.c b/drivers/hid/usbhid/hiddev.c
> index c24d2fa..53263e7 100644
> --- a/drivers/hid/usbhid/hiddev.c
> +++ b/drivers/hid/usbhid/hiddev.c
> @@ -271,16 +271,18 @@ static int hiddev_open(struct inode *inode,
> struct file *file)
>  	lock_kernel();
>  	i = iminor(inode) - HIDDEV_MINOR_BASE;
> 
> -	if (i >= HIDDEV_MINORS || i < 0 || !hiddev_table[i])
> +	if (i >= HIDDEV_MINORS || i < 0 || !hiddev_table[i]) {
> +		unlock_kernel();
>  		return -ENODEV;
> +	}
> 
> -	if (!(list = kzalloc(sizeof(struct hiddev_list), GFP_KERNEL)))
> +	if (!(list = kzalloc(sizeof(struct hiddev_list), GFP_KERNEL))) {
> +		unlock_kernel();
>  		return -ENOMEM;
> -	mutex_init(&list->thread_lock);
> +	}
> 
> +	mutex_init(&list->thread_lock);
>  	list->hiddev = hiddev_table[i];
> -
> -
>  	file->private_data = list;
> 
>  	/*

This should no longer be needed, since the BKL is not taken
in this code any more.

	Arnd
