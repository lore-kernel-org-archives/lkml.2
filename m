Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880Ab2EVNjw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 09:39:52 -0400
Received: from mga14.intel.com ([143.182.124.37]:45706 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752184Ab2EVNj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 09:39:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="146252115"
Message-ID: <1337694184.2483.186.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] [RFC] UBI: Implement Fastmap support
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, Heinz.Egger@linutronix.de,
        tim.bird@am.sony.com
Date: Tue, 22 May 2012 16:43:04 +0300
In-Reply-To: <1337608916-49771-2-git-send-email-richard@nod.at>
References: <1337608916-49771-1-git-send-email-richard@nod.at>
	 <1337608916-49771-2-git-send-email-richard@nod.at>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-eLu41EiJTtaQGCNcicfb"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-eLu41EiJTtaQGCNcicfb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Uhh, too many helpers.

On Mon, 2012-05-21 at 16:01 +0200, Richard Weinberger wrote:
>  /**
> - * ubi_attach - attach an MTD device.
> - * @ubi: UBI device descriptor
> + * scan_fastmap - attach MTD device using fastmap.
> + * @ubi: UBI device description object
>   *
> - * This function returns zero in case of success and a negative error co=
de in
> - * case of failure.
> + * This function attaches a MTD device using a fastmap and returns compl=
ete
> + * information about it in form of a "struct ubi_attach_info" object. In=
 case
> + * of failure, an error code is returned.
>   */
> -int ubi_attach(struct ubi_device *ubi)
> +static struct ubi_attach_info *scan_fastmap(struct ubi_device *ubi)
> +{
> +       int fm_start;
> +
> +       fm_start =3D ubi_find_fastmap(ubi);
> +       if (fm_start < 0)
> +               return ERR_PTR(-ENOENT);
> +
> +       return ubi_read_fastmap(ubi, fm_start);
> +}

This helper which does not do anything useful should not exist - just
teach 'ubi_read_fastmap()' to return 1 if the fastmap is not found, and
< 0 on error, and 0 on success. No one in attach.c should be interested
in fm_start. So this helper should die. See below as well.

> +
> +static int do_attach(struct ubi_device *ubi, bool fullscan)
>  {
>         int err;
>         struct ubi_attach_info *ai;
> =20
> -       ai =3D scan_all(ubi);
> +       if (fullscan)
> +               ai =3D scan_all(ubi);
> +       else
> +               ai =3D scan_fastmap(ubi);
> +
>         if (IS_ERR(ai))
>                 return PTR_ERR(ai);
> =20
> @@ -1256,6 +1277,31 @@ out_ai:
>  }

Another useless helper function, should die, see below.

> =20
>  /**
> + * ubi_attach - attach an MTD device.
> + * @ubi: UBI device descriptor
> + *
> + * This function returns zero in case of success and a negative error co=
de in
> + * case of failure.
> + */
> +int ubi_attach(struct ubi_device *ubi)
> +{
> +       int err;
> +
> +       err =3D do_attach(ubi, false);
> +       if (err) {
> +               if (err !=3D -ENOENT)
> +                       ubi_err("Attach by fastmap failed! " \
> +                               "Falling back to attach by scanning. " \
> +                               "error =3D %i\n", err);
> +
> +               ubi->attached_by_scanning =3D true;
> +               err =3D do_attach(ubi, true);
> +       }
> +
> +       return err;
> +}=20

Just add this code to this function:

       err =3D ubi_read_fastmap();
       if (err < 0)
               return err;
       if (err =3D=3D 2)
               return scan_all();

       ... rest of the common nitializations (EBA, WL)...

       return err;

--=20
Best Regards,
Artem Bityutskiy

--=-eLu41EiJTtaQGCNcicfb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPu5foAAoJECmIfjd9wqK0iJgQALhq040tOkT51EkC7WtkxFgj
oEhemceyAhhbdHslOJEgx001heXJij5D7gj6pWnDIFk8qd1PlR5rzBwKaKU5oDgV
ochODPns/7MLobb8MRIoAb9L5CDDpnKzMS+2jfQFqAxi4vY3vCnRZsxanrD8kZo2
QEQvfwP/H4gqmRQ+Dn6JTqvkXtII2IS/SEEEbgNZn3KsMrr+G11XKT/z+8Z+BwVf
Tp1kSDlk4yLcRpDC8LJHynWAP+g638TRFlEfW0kHyfL/a+Dhjfamg57YDa6aiubG
VtAekLNN36JgL/Gqh3uOnvRORK8ZPNcTAZFJ10b2YDwZ20dMOsyvrGsJknKrCJ/z
To9Y7Ymmi9WY8cpyauUnlftkGw+07En1T3JoYpYtJt9NeQX0v/UeJMdWZkQly6am
v0jrkK4q20pnhcNanf6EykinwR8WrRvRGzxM0D++JHlOUiXRcrQevRQvHJIHB289
z46zoZvN9eebGZTfXjB+x7B/0VA1tnT2huCh410VYKAiYH9dDvv+cfaMt+4luC2m
4z5+X7QEQwz1Y4yUhgqwZdxjioTKmWu4tIINO/QCP1PHjPD5G6WxkX7YDqL1dDqD
g9e4EY9vkqyNsDmHD+hEPkZ9c79M2W4ytzUr2VPUZarXKBSFWHjW2l7Iy63W3VxM
+rSuAVxYcqgNQfOGDltg
=ZYLk
-----END PGP SIGNATURE-----

--=-eLu41EiJTtaQGCNcicfb--

