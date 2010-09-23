Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab0IWIWn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 04:22:43 -0400
Received: from ozlabs.org ([203.10.76.45]:44499 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139Ab0IWIWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 04:22:41 -0400
Subject: Re: [PATCH] irqbalance, powerpc: add IRQs without settable SMP
 affinity to banned list
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Michael Neuling <mikey@neuling.org>
Cc: Arjen Van De Ven <arjanvandeven@gmail.com>,
        Neil Horman <nhorman@gmail.com>, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <12972.1285135457@neuling.org>
References: <12972.1285135457@neuling.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-YLKN/vRQ4t4qCkN4f5zj"
Date: Thu, 23 Sep 2010 18:22:39 +1000
Message-ID: <1285230159.30617.2.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-YLKN/vRQ4t4qCkN4f5zj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2010-09-22 at 16:04 +1000, Michael Neuling wrote:
> When irqblance attempts writes to the IPI smp_affinity (ie.
> /proc/irq/16/smp_affinity in the above example) it fails but irqbalance
> ignores currently ignores this.
>=20
> This patch catches these write fails and in this case adds that IRQ
> number to the banned IRQ list.  This will catch the above IPI case and
> any other IRQ where the SMP affinity can't be set.

Cool!

> Index: irqbalance/irqlist.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- irqbalance.orig/irqlist.c
> +++ irqbalance/irqlist.c
> @@ -67,7 +67,7 @@
>  	DIR *dir;
>  	struct dirent *entry;
>  	char *c, *c2;
> -	int nr , count =3D 0;
> +	int nr , count =3D 0, can_set =3D 1;
>  	char buf[PATH_MAX];
>  	sprintf(buf, "/proc/irq/%i", number);
>  	dir =3D opendir(buf);
> @@ -80,7 +80,7 @@
>  			size_t size =3D 0;
>  			FILE *file;
>  			sprintf(buf, "/proc/irq/%i/smp_affinity", number);
> -			file =3D fopen(buf, "r");
> +			file =3D fopen(buf, "r+");
>  			if (!file)
>  				continue;
>  			if (getline(&line, &size, file)=3D=3D0) {
> @@ -89,7 +89,14 @@
>  				continue;
>  			}
>  			cpumask_parse_user(line, strlen(line), irq->mask);
> -			fclose(file);
> +			/*
> +			 * Check that we can write the affinity, if
> +			 * not take it out of the list.
> +			 */
> +			if (fwrite(line, strlen(line) - 1, 1, file) =3D=3D 0)

if (fputs(line, file) =3D=3D EOF)

?

cheers


--=-YLKN/vRQ4t4qCkN4f5zj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkybDkwACgkQdSjSd0sB4dI0LACfcrcA9fp8EDT4ett9KZnXN8lT
msgAoLSEF/EQ9cTulZlhFoyI3oNaG53K
=FD+G
-----END PGP SIGNATURE-----

--=-YLKN/vRQ4t4qCkN4f5zj--

