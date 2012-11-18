Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988Ab2KRNjv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 08:39:51 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:45377 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751900Ab2KRNju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 08:39:50 -0500
X-Sasl-enc: 62mzY5rpjmjfu2rrgTUPV5j7MRjkI7Ey7dW5XrWHi6+q 1353245989
Message-ID: <50A8E521.10509@imap.cc>
Date: Sun, 18 Nov 2012 14:39:45 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121025 Thunderbird/16.0.2
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: gregkh@linuxfoundation.org, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: [PATCH 9/9] TTY: call tty_port_destroy in the rest of drivers
References: <1352969396-23760-1-git-send-email-jslaby@suse.cz> <1352969396-23760-10-git-send-email-jslaby@suse.cz>
In-Reply-To: <1352969396-23760-10-git-send-email-jslaby@suse.cz>
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig5FC300D5944C0CB2D9E5E09D"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig5FC300D5944C0CB2D9E5E09D
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Two remarks wrt the Gigaset driver.

Am 15.11.2012 09:49, schrieb Jiri Slaby:
> diff --git a/drivers/isdn/gigaset/common.c b/drivers/isdn/gigaset/commo=
n.c
> index 30a6b17..bc9d89a 100644
> --- a/drivers/isdn/gigaset/common.c
> +++ b/drivers/isdn/gigaset/common.c
> @@ -518,6 +518,7 @@ f_bcs:	gig_dbg(DEBUG_INIT, "freeing bcs[]");
>  	kfree(cs->bcs);
>  f_cs:	gig_dbg(DEBUG_INIT, "freeing cs");
>  	mutex_unlock(&cs->mutex);
> +	tty_port_destroy(&cs->port);
>  	free_cs(cs);
>  }
>  EXPORT_SYMBOL_GPL(gigaset_freecs);

It is not ok to call tty_port_destroy() unconditionally here.
gigaset_freecs() may be called from gigaset_initcs() before
the tty_port_init(&cs->port) call if a memory allocation fails.
This is best fixed by moving that call to case 1 of the preceding
switch statement because cs_init >=3D 1 covers exactly the cases
where the tty_port_init(&cs->port) call has already been passed.

> @@ -751,14 +752,14 @@ struct cardstate *gigaset_initcs(struct gigaset_d=
river *drv, int channels,
>  	gig_dbg(DEBUG_INIT, "setting up iif");
>  	if (gigaset_isdn_regdev(cs, modulename) < 0) {
>  		pr_err("error registering ISDN device\n");
> -		goto error;
> +		goto error_port;
>  	}
> =20
>  	make_valid(cs, VALID_ID);
>  	++cs->cs_init;
>  	gig_dbg(DEBUG_INIT, "setting up hw");
>  	if (cs->ops->initcshw(cs) < 0)
> -		goto error;
> +		goto error_port;
> =20
>  	++cs->cs_init;
> =20
> @@ -773,7 +774,7 @@ struct cardstate *gigaset_initcs(struct gigaset_dri=
ver *drv, int channels,
>  		gig_dbg(DEBUG_INIT, "setting up bcs[%d]", i);
>  		if (gigaset_initbcs(cs->bcs + i, cs, i) < 0) {
>  			pr_err("could not allocate channel %d data\n", i);
> -			goto error;
> +			goto error_port;
>  		}
>  	}
> =20
> @@ -786,7 +787,8 @@ struct cardstate *gigaset_initcs(struct gigaset_dri=
ver *drv, int channels,
> =20
>  	gig_dbg(DEBUG_INIT, "cs initialized");
>  	return cs;
> -
> +error_port:
> +	tty_port_destroy(&cs->port);
>  error:
>  	gig_dbg(DEBUG_INIT, "failed");
>  	gigaset_freecs(cs);

You have already added a tty_port_destroy() call to gigaset_freecs(cs)
above. Adding another one here will lead to the port being destroyed
twice in this code path.

Thanks,
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig5FC300D5944C0CB2D9E5E09D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iEYEARECAAYFAlCo5SMACgkQQ3+did9BuFvTmQCfUrq6LNK94DUTHiiTjhIb+vLx
R90AmwV4CzPtRXtx1Oe5RbSXV4q5kQeN
=pmtg
-----END PGP SIGNATURE-----

--------------enig5FC300D5944C0CB2D9E5E09D--
