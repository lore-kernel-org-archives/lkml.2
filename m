Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361Ab2HNDbi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 23:31:38 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45499 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751275Ab2HNDbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 23:31:37 -0400
Message-ID: <1344915083.824.182.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH v3 4/6] floppy: properly handle failure on add_disk loop
From: Ben Hutchings <ben@decadent.org.uk>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>
Date: Tue, 14 Aug 2012 04:31:23 +0100
In-Reply-To: <1344881787-6422-5-git-send-email-herton.krzesinski@canonical.com>
References: <1344881787-6422-1-git-send-email-herton.krzesinski@canonical.com>
	 <1344881787-6422-5-git-send-email-herton.krzesinski@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-eo/YQuN9y/6EbFhO+gtn"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-eo/YQuN9y/6EbFhO+gtn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-08-13 at 15:16 -0300, Herton Ronaldo Krzesinski wrote:
> On do_floppy_init, if something failed inside the loop we call add_disk,
> there was no cleanup of previous iterations in the error handling.
>=20
> Cc: stable@vger.kernel.org
> Acked-by: Vivek Goyal <vgoyal@redhat.com>
> Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com=
>

This depends on 3/6.  If that's replaced by my proposed fix, then:

> ---
>  drivers/block/floppy.c |   10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
> index 9272203..3eafe93 100644
> --- a/drivers/block/floppy.c
> +++ b/drivers/block/floppy.c
> @@ -4294,7 +4294,7 @@ static int __init do_floppy_init(void)
> =20
>  		err =3D platform_device_register(&floppy_device[drive]);
>  		if (err)
> -			goto out_release_dma;
> +			goto out_remove_drives;
> =20
>  		err =3D device_create_file(&floppy_device[drive].dev,
>  					 &dev_attr_cmos);
> @@ -4313,6 +4313,14 @@ static int __init do_floppy_init(void)
> =20
>  out_unreg_platform_dev:
>  	platform_device_unregister(&floppy_device[drive]);
> +out_remove_drives:
> +	while (drive--) {
> +		if (disk_registered[drive]) {

I think the test of allowed_drive_mask and FDC version before
registering each driver should be factored out into a function that you
can use here.  There would then no need for the disk_registered array.

Ben.

> +			del_gendisk(disks[drive]);
> +			device_remove_file(&floppy_device[drive].dev, &dev_attr_cmos);
> +			platform_device_unregister(&floppy_device[drive]);
> +		}
> +	}
>  out_release_dma:
>  	if (atomic_read(&usage_count))
>  		floppy_release_irq_and_dma();

--=20
Ben Hutchings
I say we take off; nuke the site from orbit.  It's the only way to be sure.

--=-eo/YQuN9y/6EbFhO+gtn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUCnGi+e/yOyVhhEJAQrXLxAAlX1OZbFeSRCz2YYnDm6vvCPq5fypoSEV
a3fnKswnI5z9GZnk8Kcb/yiLdl3pyDkQbFIU3KAl55n/vy9oaDaDSjccTKXncO9D
75JHRVX8ZHQXUGrJ23wL3jC+0q6jAR8WFthHgQELGHIFXaJfi7NdrF7rccznzxgB
/if0KHpOQoTMEx/bw/iBZ43j+21tYX5CMBMsmOWOvhryzAs2jtmTHKGHtw6QNa/c
LA937xo29+jiRvzzDnvloVpr7uyEp+0L/6rnMbf40CxH6sX8XIUewynb4qoWHlF6
rru6iuhnuhZeS/pi2eAYkhA5HTvNXGLRKzN25PDjwS/odWBv5aBp5ovVDGxYZ806
Nu7i/fQSR18b6HSViByRRAxa0UEnammZe6AvvqAJ/6V1neiJHZ5gksjNRmgJc9Z6
XtPnsAWbNaJuRZnQVNeZ23VOkPK0k44/+j3Nxpd3zDcO/mzPykprIbHg/86TwgW4
k15N+rA/d1zOkk7FYJpLCZC1+eXvZMhCw97nntoZM2YIBA9AW+zgNWjxI+Mx47vc
G1TPcgIpQx0pds9Ud5OIMRlSFpYnu/zGYNMVBFdG8RrRrBAy6BKEVgFL5ru1rPm7
e+535ru5Swz+4Q0aCc1u86WtaLG1zHC7ufrclkj/miVuD5smFxR0VkqQwKLjGeuS
aNZnFLQWwFA=
=H8RA
-----END PGP SIGNATURE-----

--=-eo/YQuN9y/6EbFhO+gtn--
