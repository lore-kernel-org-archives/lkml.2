Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729Ab2CERF5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 12:05:57 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:41897 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756141Ab2CERFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 12:05:55 -0500
X-Sasl-enc: TAn0Z2G3uBP2lqJiN/tA6IyUs84G7z/a6WLYRmxdVla+ 1330967155
Message-ID: <4F54F270.8030108@imap.cc>
Date: Mon, 05 Mar 2012 18:05:52 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.2.27) Gecko/20120215 SUSE/3.1.19 Thunderbird/3.1.19
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: gregkh@linuxfoundation.org, alan@linux.intel.com,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, Hansjoerg Lipp <hjlipp@web.de>,
        gigaset307x-common@lists.sourceforge.net
Subject: Re: [PATCH 67/68] TTY: isdn/gigaset, do not set tty->driver_data
 to NULL
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz> <1330955575-26641-68-git-send-email-jslaby@suse.cz>
In-Reply-To: <1330955575-26641-68-git-send-email-jslaby@suse.cz>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Am 05.03.2012 14:52, schrieb Jiri Slaby:
> Close the window in open where driver_data is reset to NULL on each
> open. It could cause other processes to get invalid retval from the
> tty->ops operations because of the checks all over the code.
> 
> With this change we may do other cleanups. Now, the only valid check
> for tty->driver_data != NULL is in close. This can happen only if open
> fails at gigaset_get_cs_by_tty or try_module_get. The rest of checks
> in various tty->ops->* are invalid as driver_data cannot be NULL
> there. The same holds for cs->open_count. So remove them.

Thanks for that nice cleanup. It's most welcome.
Just one question and a small nit:

> --- a/drivers/isdn/gigaset/interface.c
> +++ b/drivers/isdn/gigaset/interface.c
[...]
> @@ -178,12 +176,11 @@ static int if_open(struct tty_struct *tty, struct file *filp)
>  
>  static void if_close(struct tty_struct *tty, struct file *filp)
>  {
> -	struct cardstate *cs;
> +	struct cardstate *cs = tty->driver_data;
>  	unsigned long flags;
>  
> -	cs = (struct cardstate *) tty->driver_data;
> -	if (!cs) {
> -		pr_err("%s: no cardstate\n", __func__);
> +	if (!cs) { /* happens if we didn't find cs in open */
> +		printk(KERN_DEBUG "%s: no cardstate\n", __func__);
>  		return;
>  	}
>  

Why are you downgrading the error message from KERN_ERR to KERN_DEBUG
here? I would think that condition would warrant a message with
KERN_ERR severity.
Also, the driver does KERN_DEBUG output uniformly through the gig_dbg
macro, so if you are sure it should be turned into a debug message
then please write it as

	gig_dbg(DEBUG_IF, "%s: no cardstate", __func__);

like four lines later.

Thanks,
Tilman

- -- 
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Ungeöffnet mindestens haltbar bis: (siehe Rückseite)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAk9U8nAACgkQQ3+did9BuFsaiwCeKiL8hghkVcjstG5azxYoIXOK
Yl0Anj2FWsaiE4zx3ioVvCo6xgFVKBTk
=i3+X
-----END PGP SIGNATURE-----
