Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397Ab2HNDgP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 23:36:15 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45533 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753366Ab2HNDgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 23:36:14 -0400
Message-ID: <1344915367.824.187.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH v3 5/6] floppy: use disk_registered for checking if a
 drive is present
From: Ben Hutchings <ben@decadent.org.uk>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>
Date: Tue, 14 Aug 2012 04:36:07 +0100
In-Reply-To: <1344881787-6422-6-git-send-email-herton.krzesinski@canonical.com>
References: <1344881787-6422-1-git-send-email-herton.krzesinski@canonical.com>
	 <1344881787-6422-6-git-send-email-herton.krzesinski@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-jVUBBunp/e+ARYbDYT88"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-jVUBBunp/e+ARYbDYT88
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-08-13 at 15:16 -0300, Herton Ronaldo Krzesinski wrote:
> Simplify/cleanup code, replacing remaining checks for drives present
> using disk_registered array.
>=20
> Acked-by: Vivek Goyal <vgoyal@redhat.com>
> Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com=
>
> ---
>  drivers/block/floppy.c |   10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
> index 3eafe93..381b9c1 100644
> --- a/drivers/block/floppy.c
> +++ b/drivers/block/floppy.c
> @@ -4114,9 +4114,7 @@ static struct platform_device floppy_device[N_DRIVE=
];
>  static struct kobject *floppy_find(dev_t dev, int *part, void *data)
>  {
>  	int drive =3D (*part & 3) | ((*part & 0x80) >> 5);
> -	if (drive >=3D N_DRIVE ||
> -	    !(allowed_drive_mask & (1 << drive)) ||
> -	    fdc_state[FDC(drive)].version =3D=3D FDC_NONE)
> +	if (drive >=3D N_DRIVE || !disk_registered[drive])
>  		return NULL;
>  	if (((*part >> 2) & 0x1f) >=3D ARRAY_SIZE(floppy_type))
>  		return NULL;
> @@ -4561,8 +4559,7 @@ static void __exit floppy_module_exit(void)
>  	for (drive =3D 0; drive < N_DRIVE; drive++) {
>  		del_timer_sync(&motor_off_timer[drive]);
> =20
> -		if ((allowed_drive_mask & (1 << drive)) &&
> -		    fdc_state[FDC(drive)].version !=3D FDC_NONE) {
> +		if (disk_registered[drive]) {
>  			del_gendisk(disks[drive]);
>  			device_remove_file(&floppy_device[drive].dev, &dev_attr_cmos);
>  			platform_device_unregister(&floppy_device[drive]);

The same function I suggested for 4/6 would also be used here.  A little
neater than yet another static array, I think.  But I have nothing to do
with this code so you could just ignore my preferences. :-)

Ben.

> @@ -4573,8 +4570,7 @@ static void __exit floppy_module_exit(void)
>  		 * These disks have not called add_disk().  Don't put down
>  		 * queue reference in put_disk().
>  		 */
> -		if (!(allowed_drive_mask & (1 << drive)) ||
> -		    fdc_state[FDC(drive)].version =3D=3D FDC_NONE)
> +		if (!disk_registered[drive])
>  			disks[drive]->queue =3D NULL;
> =20
>  		put_disk(disks[drive]);

--=20
Ben Hutchings
I say we take off; nuke the site from orbit.  It's the only way to be sure.

--=-jVUBBunp/e+ARYbDYT88
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUCnHp+e/yOyVhhEJAQrNhQ/9Htj2X6Q0fGHkfdLhmFg91TvvqXWZ+Lrj
rv1llu58ImklCFASR3K9Mr92tFBILxRs/K3neYMisKq5lN+IQ3VobYXyc61cYzp2
mcKaPFsBxt1QFl0HAAw6jhUTmsSIqyitudIyOvK+MMn0mDqLijkuQsm86cY6aKyR
uhsK9jAn4fhGB20TDxGpRhlNwJXd9+yn736H/koH7CPkXomMOX+Rtk1K+vZWuGnc
nquXqMGzqxhrxnLPzM45gljYoTkGb+19wWR5HZ/qRo8jKR6FJ0XTSEP48tu56d1f
W7VCEUosMfFiUhP1/WgJjcUeeGr7OI5sk2/dPVLjRIMRZ+/VFCoC4JrJiqUTUvvf
MvIUhmpy5wqohJfZXyGEYugDzolj342CWB0cUzleMvsU7vzAckW+xdZ5aZqIu2Ig
ywHQ/mIFsNCUtP+f1a/t/6W9JZUskmy+EShlV7hQAYHi3VPcJjNzGRKVM2F9Lcpj
SvUxrds7NmABmvPwq/1SODqh8YYtonxW3O1VtPIr9yKk41eFGGdBuEPzbsm+rReG
ItjcclnGukvIsKXzVMfw3VR/+hFr9tVCqbm0KLg+RAN3c+ouYxnFqcojh+LB3jrE
m70Iue1cyXw1UdfdgdpZtRQQ+KdL17mi3QOVtEPQ1mAskiwsewRI+hdr+nvFwyuD
RRXuic9UhVU=
=8TUf
-----END PGP SIGNATURE-----

--=-jVUBBunp/e+ARYbDYT88--
