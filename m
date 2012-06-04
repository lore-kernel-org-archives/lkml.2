Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793Ab2FDMB4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 08:01:56 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563Ab2FDMBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 08:01:55 -0400
Message-ID: <4FCCA3A6.8080608@nod.at>
Date: Mon, 04 Jun 2012 14:01:42 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120427 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: gregkh@linuxfoundation.org, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Jeff Dike <jdike@addtoit.com>,
        user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH 13/24] TTY: um/line, use tty from tty_port
References: <1338809738-18967-1-git-send-email-jslaby@suse.cz> <1338809738-18967-14-git-send-email-jslaby@suse.cz>
In-Reply-To: <1338809738-18967-14-git-send-email-jslaby@suse.cz>
X-Enigmail-Version: 1.4.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigCEB5950F7F73ADB15D203F72"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigCEB5950F7F73ADB15D203F72
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Jiri,

Thanks a lot for fixing this!

I have two questions:
1. Are these patches also usable on 3.4 and 3.3 or do they depend on 3.5'=
s TTY changes?
2. Why didn't you use tty_port_open()/close()/etc. as Alan suggested my i=
n [1]?

Thanks,
//richard

[1] http://lkml.indiana.edu/hypermail/linux/kernel/1201.3/01705.html

Am 04.06.2012 13:35, schrieb Jiri Slaby:
> This means switching to the tty refcounted model so that we will not
> race with interrupts.
>=20
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Jeff Dike <jdike@addtoit.com>
> Cc: Richard Weinberger <richard@nod.at>
> Cc: user-mode-linux-devel@lists.sourceforge.net
> ---
>  arch/um/drivers/chan_kern.c |    4 +++-
>  arch/um/drivers/line.c      |   25 ++++++++++++++++++-------
>  arch/um/drivers/line.h      |    1 -
>  3 files changed, 21 insertions(+), 9 deletions(-)
>=20
> diff --git a/arch/um/drivers/chan_kern.c b/arch/um/drivers/chan_kern.c
> index 45e248c..87eebfe 100644
> --- a/arch/um/drivers/chan_kern.c
> +++ b/arch/um/drivers/chan_kern.c
> @@ -150,9 +150,11 @@ void chan_enable_winch(struct chan *chan, struct t=
ty_struct *tty)
>  static void line_timer_cb(struct work_struct *work)
>  {
>  	struct line *line =3D container_of(work, struct line, task.work);
> +	struct tty_struct *tty =3D tty_port_tty_get(&line->port);
> =20
>  	if (!line->throttled)
> -		chan_interrupt(line, line->tty, line->driver->read_irq);
> +		chan_interrupt(line, tty, line->driver->read_irq);
> +	tty_kref_put(tty);
>  }
> =20
>  int enable_chan(struct line *line)
> diff --git a/arch/um/drivers/line.c b/arch/um/drivers/line.c
> index 482a7bd..fb6e4ea 100644
> --- a/arch/um/drivers/line.c
> +++ b/arch/um/drivers/line.c
> @@ -19,9 +19,11 @@ static irqreturn_t line_interrupt(int irq, void *dat=
a)
>  {
>  	struct chan *chan =3D data;
>  	struct line *line =3D chan->line;
> +	struct tty_struct *tty =3D tty_port_tty_get(&line->port);
> =20
>  	if (line)
> -		chan_interrupt(line, line->tty, irq);
> +		chan_interrupt(line, tty, irq);
> +	tty_kref_put(tty);
>  	return IRQ_HANDLED;
>  }
> =20
> @@ -333,7 +335,7 @@ static irqreturn_t line_write_interrupt(int irq, vo=
id *data)
>  {
>  	struct chan *chan =3D data;
>  	struct line *line =3D chan->line;
> -	struct tty_struct *tty =3D line->tty;
> +	struct tty_struct *tty;
>  	int err;
> =20
>  	/*
> @@ -352,10 +354,13 @@ static irqreturn_t line_write_interrupt(int irq, =
void *data)
>  	}
>  	spin_unlock(&line->lock);
> =20
> +	tty =3D tty_port_tty_get(&line->port);
>  	if (tty =3D=3D NULL)
>  		return IRQ_NONE;
> =20
>  	tty_wakeup(tty);
> +	tty_kref_put(tty);
> +
>  	return IRQ_HANDLED;
>  }
> =20
> @@ -409,7 +414,7 @@ int line_open(struct line *lines, struct tty_struct=
 *tty)
> =20
>  	BUG_ON(tty->driver_data);
>  	tty->driver_data =3D line;
> -	line->tty =3D tty;
> +	tty_port_tty_set(&line->port, tty);
> =20
>  	err =3D enable_chan(line);
>  	if (err) /* line_close() will be called by our caller */
> @@ -449,7 +454,7 @@ void line_close(struct tty_struct *tty, struct file=
 * filp)
>  	if (--line->port.count)
>  		goto out_unlock;
> =20
> -	line->tty =3D NULL;
> +	tty_port_tty_set(&line->port, NULL);
>  	tty->driver_data =3D NULL;
> =20
>  	if (line->sigio) {
> @@ -610,9 +615,15 @@ int line_get_config(char *name, struct line *lines=
, unsigned int num, char *str,
>  	mutex_lock(&line->count_lock);
>  	if (!line->valid)
>  		CONFIG_CHUNK(str, size, n, "none", 1);
> -	else if (line->tty =3D=3D NULL)
> -		CONFIG_CHUNK(str, size, n, line->init_str, 1);
> -	else n =3D chan_config_string(line, str, size, error_out);
> +	else {
> +		struct tty_struct *tty =3D tty_port_tty_get(&line->port);
> +		if (tty =3D=3D NULL) {
> +			CONFIG_CHUNK(str, size, n, line->init_str, 1);
> +		} else {
> +			n =3D chan_config_string(line, str, size, error_out);
> +			tty_kref_put(tty);
> +		}
> +	}
>  	mutex_unlock(&line->count_lock);
> =20
>  	return n;
> diff --git a/arch/um/drivers/line.h b/arch/um/drivers/line.h
> index 0e06a1f..5b3d4fb 100644
> --- a/arch/um/drivers/line.h
> +++ b/arch/um/drivers/line.h
> @@ -33,7 +33,6 @@ struct line_driver {
> =20
>  struct line {
>  	struct tty_port port;
> -	struct tty_struct *tty;
>  	struct mutex count_lock;
>  	int valid;
> =20



--------------enigCEB5950F7F73ADB15D203F72
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJPzKOqAAoJEN9758yqZn9evZsH/3dtoB43UlsCtn1YgTCRZZ8i
dO/z2sHEr13KTRI6dze7mRxqdRF01vj9F5KmlgFz6kmqgvzX+iOfylrhyKh0d0mD
MTUtYxegSfVZV4Jrm+lPiaZgLLerUoi1pbd8tJvSdKi2pbDV8vpm1BLxbPSyteoh
fgMvLZuXUDD9Nvw1l+YgX0muNjhKJZjEzdzjs2DeyOtZAwNGfMFVTHHCiDwBCuiI
j/dlwfln4oLQEJyU0HmR9axT+k5nrLS3gf8Kq9tdWmK1Z0umiHTR6wHWN5M5rDIc
241QQHvRjousIwCucibFm6w5TmyFcEAVQCYPI71IyufgBOCeGAAi0dhiSSL5GWU=
=L8Jj
-----END PGP SIGNATURE-----

--------------enigCEB5950F7F73ADB15D203F72--
