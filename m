Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab2BLNMW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 08:12:22 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753647Ab2BLNMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 08:12:21 -0500
Message-ID: <4F37BAAA.8080207@nod.at>
Date: Sun, 12 Feb 2012 14:12:10 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
        viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, gregkh@linuxfoundation.org,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH] um: Use tty_port
References: <1329006070-4275-1-git-send-email-richard@nod.at> <4F3706C4.2070102@nod.at> <4F37B815.8060701@suse.cz>
In-Reply-To: <4F37B815.8060701@suse.cz>
X-Enigmail-Version: 1.3.4
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigCCFA582285830E4546E15885"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigCCFA582285830E4546E15885
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Am 12.02.2012 14:01, schrieb Jiri Slaby:
> This and the ioctl change above fullfils the subject of the patch in no=

> way. Do this fix and the cleanup above separately, please.

Fair point.

>=20
>>> @@ -404,27 +334,27 @@ int line_setup_irq(int fd, int input, int outpu=
t, struct line *line, void *data)
>>>   * first open or last close.  Otherwise, open and close just return.=

>>>   */
>>> =20
>>> -int line_open(struct line *lines, struct tty_struct *tty)
>>> +int line_open(struct tty_struct *tty, struct file *filp)
>>>  {
>>> -	struct line *line =3D &lines[tty->index];
>>> -	int err =3D -ENODEV;
>>> +	struct line *line =3D tty->driver_data;
>>> +	return tty_port_open(&line->port, tty, filp);
>>> +}
>>> =20
>>> -	spin_lock(&line->count_lock);
>>> -	if (!line->valid)
>>> -		goto out_unlock;
>>> +int line_install(struct tty_driver *driver, struct tty_struct *tty, =
struct line *line)
>=20
> As it stands, it should be tty_port->ops->activate, not
> tty->ops->install. Yes, you can still set driver_data and check for
> multiple opens in install. Then use also tty_standard_install.

Okay.

>>> +{
>>> +	int ret =3D tty_init_termios(tty);
>>> =20
>>> -	err =3D 0;
>>> -	if (line->count++)
>>> -		goto out_unlock;
>>> +	if (ret)
>>> +		return ret;
>>> =20
>>> -	BUG_ON(tty->driver_data);
>>> +	tty_driver_kref_get(driver);
>>> +	tty->count++;
>>>  	tty->driver_data =3D line;
>>> -	line->tty =3D tty;
>>> +	driver->ttys[tty->index] =3D tty;
>>> =20
>>> -	spin_unlock(&line->count_lock);
>>> -	err =3D enable_chan(line);
>>> -	if (err) /* line_close() will be called by our caller */
>>> -		return err;
>>> +	ret =3D enable_chan(line);
>>> +	if (ret)
>>> +		return ret;
>>> =20
>>>  	INIT_DELAYED_WORK(&line->task, line_timer_cb);
>>> =20
>>> @@ -437,48 +367,36 @@ int line_open(struct line *lines, struct tty_st=
ruct *tty)
>>>  			 &tty->winsize.ws_col);
>>> =20
>>>  	return 0;
>>> -
>>> -out_unlock:
>>> -	spin_unlock(&line->count_lock);
>>> -	return err;
>>>  }
> ...
>>> +void line_close(struct tty_struct *tty, struct file * filp)
>>> +{
>>> +	struct line *line =3D tty->driver_data;
>>> +
>>> +	if (!line)
>>> +		return;
>=20
> Unless you set tty->driver_data to NULL somewhere, this can never
> happen. If you do, why -- this tends to be racy?

The old driver set tty->driver_data to NULL.
I guess we can remove it.

>>> +	tty_port_close(&line->port, tty, filp);
>>> +}
> ...
>>> --- a/arch/um/drivers/ssl.c
>>> +++ b/arch/um/drivers/ssl.c
>>> @@ -92,6 +92,7 @@ static int ssl_remove(int n, char **error_out)
>>>  			   error_out);
>>>  }
>>> =20
>>> +#if 0
>=20
> Hmm, remove unused code instead.

Will do.

>>>  static int ssl_open(struct tty_struct *tty, struct file *filp)
>>>  {
>>>  	int err =3D line_open(serial_lines, tty);
> ...
>>> @@ -124,8 +124,16 @@ void ssl_hangup(struct tty_struct *tty)
>>>  }
>>>  #endif
>>> =20
>>> +static int ssl_install(struct tty_driver *driver, struct tty_struct =
*tty)
>>> +{
>>> +	if (tty->index < NR_PORTS)
>=20
> Do you register more than NR_PORTS when allocating tty_driver? If not,
> this test is always true. But presumably you won't need this hook anywa=
y.

Okay.

>>> +		return line_install(driver, tty, &serial_lines[tty->index]);
>>> +	else
>>> +		return -ENODEV;
>>> +}
>=20
> thanks,

Thanks,
//richard


--------------enigCCFA582285830E4546E15885
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJPN7quAAoJEN9758yqZn9ef1IH/3HR5gsbPL4nX6/C2ItSzllc
uvSi46EuPcOIB+3WQt4PqUB3ld0GfBd3ZSozelKonCyGYrqgmDsMD9DdGntQ+iKY
aFjvTQmmjs+6SBclMz5zf02gkIO1j09GI1NLjvz+grvjTPMJV5iKM+AzxuWaZDPM
IVZKi++Sx/RiaWGe4CJCxCs9+OASKKapHmqO8KVaXaqbFhvtCGOL3WNa6brPRkUj
MrotB3g2/fq2/TdePtWoRLXG99HEW1QbBnBGT1NYM2eX02wdwUk1kentAidCqPhV
GHM7HnanvJcT7ZaK59+75kYYYdFQPeff7dkR+iWnnA3vpwvcZstT34wIUTiZD4Q=
=6h+9
-----END PGP SIGNATURE-----

--------------enigCCFA582285830E4546E15885--
