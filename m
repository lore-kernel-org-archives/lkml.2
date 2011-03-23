Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933513Ab1CWUrn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 16:47:43 -0400
Received: from ja.ssi.bg ([178.16.129.10]:46354 "EHLO ja.ssi.bg"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S933268Ab1CWUrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 16:47:42 -0400
Date: Wed, 23 Mar 2011 22:53:00 +0200 (EET)
From: Julian Anastasov <ja@ssi.bg>
To: Jiri Slaby <jslaby@suse.cz>
cc: gregkh@suse.de, jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/6] TTY: unify tty_init_dev fail path handling
In-Reply-To: <1300873717-27941-1-git-send-email-jslaby@suse.cz>
Message-ID: <alpine.LFD.2.00.1103232250160.1634@ja.ssi.bg>
References: <1300873717-27941-1-git-send-email-jslaby@suse.cz>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 	Hello,

On Wed, 23 Mar 2011, Jiri Slaby wrote:

> Change it so that we call the deinit functions at one place at the end
> of the function (by gotos). And while at it use some sane label names.
>
> This is a preparation for the deinitialization of tty in the next
> patch.
>
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Cc: Julian Anastasov <ja@ssi.bg>
> ---
>
> This is not tested yet, I'm building a kernel to test it a bit, but it
> will take some time. If you could too to check if your problem
> dissapears, it would be great.

 	Thanks! Patches 1-5 work for me, I backported them
to 2.6.33.8 for the test.

>
> P.S. the drivers/char/tty_<TAB><TAB> habit sucks :).
>                 ^^^^
>
> drivers/tty/tty_io.c |   23 ++++++++++++-----------
> 1 files changed, 12 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
> index 936a4ea..6312cc3 100644
> --- a/drivers/tty/tty_io.c
> +++ b/drivers/tty/tty_io.c
> @@ -1391,16 +1391,15 @@ struct tty_struct *tty_init_dev(struct tty_driver *driver, int idx,
> 		return ERR_PTR(-ENODEV);
>
> 	tty = alloc_tty_struct();
> -	if (!tty)
> -		goto fail_no_mem;
> +	if (!tty) {
> +		retval = -ENOMEM;
> +		goto err_module_put;
> +	}
> 	initialize_tty_struct(tty, driver, idx);
>
> 	retval = tty_driver_install_tty(driver, tty);
> -	if (retval < 0) {
> -		free_tty_struct(tty);
> -		module_put(driver->owner);
> -		return ERR_PTR(retval);
> -	}
> +	if (retval < 0)
> +		goto err_free_tty;
>
> 	/*
> 	 * Structures all installed ... call the ldisc open routines.
> @@ -1409,15 +1408,17 @@ struct tty_struct *tty_init_dev(struct tty_driver *driver, int idx,
> 	 */
> 	retval = tty_ldisc_setup(tty, tty->link);
> 	if (retval)
> -		goto release_mem_out;
> +		goto err_release_tty;
> 	return tty;
>
> -fail_no_mem:
> +err_free_tty:
> +	free_tty_struct(tty);
> +err_module_put:
> 	module_put(driver->owner);
> -	return ERR_PTR(-ENOMEM);
> +	return ERR_PTR(retval);
>
> 	/* call the tty release_tty routine to clean out this slot */
> -release_mem_out:
> +err_release_tty:
> 	if (printk_ratelimit())
> 		printk(KERN_INFO "tty_init_dev: ldisc open failed, "
> 				 "clearing slot %d\n", idx);
> -- 
> 1.7.4.1

Regards

--
Julian Anastasov <ja@ssi.bg>
