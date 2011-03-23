Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab1CWIM7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 04:12:59 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40219 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab1CWIM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 04:12:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=mO1wGlb1/GzFiTtRVBLhC8mmqsnRTo6TxkJSF4JFPBkgrDjiEu0DaPwIwS39Ad/YX0
         lvOSqFArRRcWofjsQ0+GiPirb7FcIjaHFXKEkOvV4MoMkDz3bVskzVa+faTWb4EMouB2
         i5sPQgQ5H4mHwdkhr6PF/oeLhaAsJr9jGd594=
Message-ID: <4D89AB83.3000103@suse.cz>
Date: Wed, 23 Mar 2011 09:12:51 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Julian Anastasov <ja@ssi.bg>
CC: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH] tty: fix tty->ldisc leak on ENODEV from driver install
References: <201103230045.p2N0jQjL011728@ja.ssi.bg>
In-Reply-To: <201103230045.p2N0jQjL011728@ja.ssi.bg>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ccing Alan.

On 03/23/2011 01:45 AM, Julian Anastasov wrote:
> 	When a USB serial device is not attached I see
> open() to leak 8-byte structures:
> 
> modprobe usbserial
> [ -e /dev/ttyUSB0 ] && cat /dev/ttyUSB0
> cat: /dev/ttyUSB0: No such device
> 
> 	Note that error must be ENODEV with usbserial
> loaded and when name exists, not ENXIO.
> 
> 	kmemleak shows such output:
> 
> unreferenced object 0xc0e19860 (size 8):
>   comm cat, pid 1226, jiffies 4294919464 (age 287.476s)
>   hex dump (first 8 bytes):
>     44 de 2d c1 01 00 00 00                          D.-.....
>   backtrace:
>     [<c1065a74>] create_object+0x109/0x1ad
>     [<c1063d2b>] kmem_cache_alloc+0x60/0x68
>     [<c113505c>] tty_ldisc_get+0x54/0x76
>     [<c11358c9>] tty_ldisc_init+0xa/0x20
>     [<c1130ab4>] initialize_tty_struct+0x2d/0x1ac
>     [<c1130c8c>] tty_init_dev+0x59/0x10d
>     [<c113136d>] tty_open+0x24a/0x3a2
>     [<c1069516>] chrdev_open+0xd1/0xef
>     [<c106d2d5>] nameidata_drop_rcu_last+0x3b/0x49
>     [<c1069445>] chrdev_open+0x0/0xef
>     [<c1065d42>] __dentry_open.clone.15+0xec/0x1c3
>     [<c10669a5>] nameidata_to_filp+0x2a/0x33
>     [<c106f7c7>] finish_open+0x6e/0xfc
>     [<c106fbda>] do_filp_open+0x144/0x4af
>     [<c1076f55>] alloc_fd+0x41/0xa5
>     [<c10669ef>] do_sys_open+0x41/0xc3
> 
> 	Looking at tty_init_dev() it seems initialize_tty_struct()
> attaches tty->ldisc via tty_ldisc_init() but on
> tty_driver_install_tty() failure (-ENODEV) we call free_tty_struct()
> which does nothing with tty->ldisc.
> 
> 	The appended patch fixes the leak but I'm not
> sure what tty->ldisc value we can see in release_one_tty(),
> I assume if ldisc is freed tty->ldisc should be NULL, so
> free_tty_struct() will not try to double-free the ldisc.
> 
> Signed-off-by: Julian Anastasov <ja@ssi.bg>
> ---
>  drivers/tty/tty_io.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- linux-2.6.38/drivers/tty/tty_io.c
> +++ linux-2.6.38/drivers/tty/tty_io.c
> @@ -188,6 +188,7 @@ void free_tty_struct(struct tty_struct *
>  		put_device(tty->dev);
>  	kfree(tty->write_buf);
>  	tty_buffer_free_all(tty);
> +	kfree(tty->ldisc);

We should not mess up with ldisc here. We should call something like
tty_ldisc_deinit from tty_init_dev on fail path. The deinit should drop
the reference (call put_ldisc). Or maybe even deinitialize_tty_struct ->
tty_ldisc_deinit -> put_ldisc).

Note that your way you do not drop the module refcount of ld ops.

>  	kfree(tty);
>  }

regards,
-- 
js
suse labs
