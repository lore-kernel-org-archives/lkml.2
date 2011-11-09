Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab1KIHYQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 02:24:16 -0500
Received: from ozlabs.org ([203.10.76.45]:37042 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752176Ab1KIHYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 02:24:16 -0500
Subject: Re: [PATCH v3 2/3] hvc_init():  Enforce one-time initialization.
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Miche Baker-Harvey <miche@google.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Anton Blanchard <anton@samba.org>, Amit Shah <amit.shah@redhat.com>,
        Mike Waychison <mikew@google.com>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Eric Northrup <digitaleric@google.com>
In-Reply-To: <20111108214504.28884.61814.stgit@miche.sea.corp.google.com>
References: <20111108214452.28884.14840.stgit@miche.sea.corp.google.com>
	 <20111108214504.28884.61814.stgit@miche.sea.corp.google.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-3wlTs2+aNijJKtMncx1A"
Date: Wed, 09 Nov 2011 18:24:12 +1100
Message-ID: <1320823452.9376.31.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-3wlTs2+aNijJKtMncx1A
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2011-11-08 at 13:45 -0800, Miche Baker-Harvey wrote:
> hvc_init() must only be called once, and no thread should continue with h=
vc_alloc()
> until after initialization is complete.  The original code does not enfor=
ce either
> of these requirements.  A new mutex limits entry to hvc_init() to a singl=
e thread,
> and blocks all later comers until it has completed.
>=20
> This patch fixes multiple crash symptoms.

Hi Miche,

A few nit-picky comments below ..

> @@ -84,6 +85,10 @@ static LIST_HEAD(hvc_structs);
>   * list traversal.
>   */
>  static DEFINE_SPINLOCK(hvc_structs_lock);
> +/*
> + * only one task does allocation at a time.
> + */
> +static DEFINE_MUTEX(hvc_ports_mutex);

The comment is wrong, isn't it? Only one task does _init_ at a time.
Once the driver is initialised allocs can run concurrently.

So shouldn't it be called hvc_init_mutex ?

> @@ -825,11 +830,15 @@ struct hvc_struct *hvc_alloc(uint32_t vtermno, int =
data,
>  	int i;
> =20
>  	/* We wait until a driver actually comes along */
> +	mutex_lock(&hvc_ports_mutex);
>  	if (!hvc_driver) {
>  		int err =3D hvc_init();
> -		if (err)
> +		if (err) {
> +			mutex_unlock(&hvc_ports_mutex);
>  			return ERR_PTR(err);
> +		}
>  	}
> +	mutex_unlock(&hvc_ports_mutex);
> =20
>  	hp =3D kzalloc(ALIGN(sizeof(*hp), sizeof(long)) + outbuf_size,
>  			GFP_KERNEL);

It'd be cleaner I think to do all the locking in hvc_init(). That's safe
as long as you recheck !hvc_driver in hvc_init() with the lock held.

cheers


--=-3wlTs2+aNijJKtMncx1A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAk66KpwACgkQdSjSd0sB4dKSVgCeMFezuF3zVrIQ9OJdHh8MukP2
KtcAnRLc243qSYELFwz+KCQLEI9qqD9Y
=l0OT
-----END PGP SIGNATURE-----

--=-3wlTs2+aNijJKtMncx1A--

