Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab0JPLA6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 07:00:58 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:55195 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473Ab0JPLA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 07:00:57 -0400
Message-ID: <4CB985E5.8010506@web.de>
Date: Sat, 16 Oct 2010 13:00:53 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Karsten Keil <isdn@linux-pingi.de>, Armin Schindler <mac@melware.de>,
        lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2.6.36-rc7 2/2] isdn/capi: make kcapi use a separate
 workqueue
References: <4CB84C4C.6040204@kernel.org> <4CB84C6E.5010401@kernel.org>
In-Reply-To: <4CB84C6E.5010401@kernel.org>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig97F083CC3F80A55B9592BFA4"
X-Provags-ID: V01U2FsdGVkX1+R61TuW+lI+p5T2aJ2KY1zhY8yOF74SpNgf5MW
	EWuuAnjXTcfFQKUAbBbD7SMNmKH+VQKJmLZX8Z+LFJAolVCH9s
	7966CE4IM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig97F083CC3F80A55B9592BFA4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 15.10.2010 14:43, Tejun Heo wrote:
> flush_scheduled_work() is deprecated and will be removed.  Because
> kcapi uses fire-and-forget type works, it's impossible to flush each
> work explicitly.  Create and use a dedicated workqueue instead.
>=20
> Please note that with recent workqueue changes, each workqueue doesn't
> reserve a lot of resources and using it as a flush domain is fine.
>=20
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  drivers/isdn/capi/kcapi.c |   26 ++++++++++++++++++--------
>  1 file changed, 18 insertions(+), 8 deletions(-)
>=20
> Index: work/drivers/isdn/capi/kcapi.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- work.orig/drivers/isdn/capi/kcapi.c
> +++ work/drivers/isdn/capi/kcapi.c
> @@ -38,6 +38,7 @@
>  #include <linux/rcupdate.h>
>=20
>  static int showcapimsgs =3D 0;
> +static struct workqueue_struct *kcapi_wq;
>=20
>  MODULE_DESCRIPTION("CAPI4Linux: kernel CAPI layer");
>  MODULE_AUTHOR("Carsten Paeth");
> @@ -282,7 +283,7 @@ static int notify_push(unsigned int even
>  	event->type =3D event_type;
>  	event->controller =3D controller;
>=20
> -	schedule_work(&event->work);
> +	queue_work(kcapi_wq, &event->work);
>  	return 0;
>  }
>=20
> @@ -399,7 +400,7 @@ void capi_ctr_handle_message(struct capi
>  		goto error;
>  	}
>  	skb_queue_tail(&ap->recv_queue, skb);
> -	schedule_work(&ap->recv_work);
> +	queue_work(kcapi_wq, &ap->recv_work);
>  	rcu_read_unlock();
>=20
>  	return;
> @@ -734,7 +735,7 @@ u16 capi20_release(struct capi20_appl *a
>=20
>  	mutex_unlock(&capi_controller_lock);
>=20
> -	flush_scheduled_work();
> +	flush_workqueue(kcapi_wq);
>  	skb_queue_purge(&ap->recv_queue);
>=20
>  	if (showcapimsgs & 1) {
> @@ -1276,21 +1277,30 @@ static int __init kcapi_init(void)
>  {
>  	int err;
>=20
> +	kcapi_wq =3D alloc_workqueue("kcapi", 0, 0);
> +	if (!kcapi_wq)
> +		return -ENOMEM;
> +
>  	register_capictr_notifier(&capictr_nb);
>=20
>  	err =3D cdebug_init();
> -	if (!err)
> -		kcapi_proc_init();
> -	return err;
> +	if (err) {
> +		unregister_capictr_notifier(&capictr_nb);

Actually, this and the one on exit are unneeded as the notifier is
driven by this module itself. Anyway, they are also harmless. So let's
leave them in to avoid future confusions.

> +		destroy_workqueue(kcapi_wq);
> +		return err;
> +	}
> +
> +	kcapi_proc_init();
> +	return 0;
>  }
>=20
>  static void __exit kcapi_exit(void)
>  {
>          kcapi_proc_exit();
>=20
> -	/* make sure all notifiers are finished */
> -	flush_scheduled_work();
> +	unregister_capictr_notifier(&capictr_nb);
>  	cdebug_exit();
> +	destroy_workqueue(kcapi_wq);
>  }
>=20
>  module_init(kcapi_init);

Looks and works fine.

Acked-by: Jan Kiszka <jan.kiszka@web.de>


--------------enig97F083CC3F80A55B9592BFA4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAky5heUACgkQitSsb3rl5xR3lQCg0IP4Tv1R1ubE+LdRs7uynE9X
kn8AnRIsmRCvoQ08svpcVnWHbt2ktQBm
=nL/A
-----END PGP SIGNATURE-----

--------------enig97F083CC3F80A55B9592BFA4--
