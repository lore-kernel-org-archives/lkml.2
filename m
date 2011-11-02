Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab1KBHjO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 03:39:14 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:40786 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab1KBHjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 03:39:12 -0400
Date: Wed, 2 Nov 2011 10:39:28 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Julia Lawall <julia@diku.dk>, Mark Fasheh <mfasheh@suse.com>,
        ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Sunil Mushran <sunil.mushran@oracle.com>
Subject: Re: [PATCH 1/2] fs/ocfs2/dlm: Eliminate update of
 list_for_each_entry loop cursor
Message-ID: <20111102073928.GA23750@mwanda>
References: <Pine.LNX.4.64.1008071108540.5821@ask.diku.dk>
 <20100812000355.GA7195@mail.oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="envbJBWh7q8WU6mo"
Content-Disposition: inline
In-Reply-To: <20100812000355.GA7195@mail.oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090209.4EB0F39D.0031,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

What ever happened with this?  The bug is still there in the latest
kernel.

I think from previous discussion about this that we only ever have
one lock so lock->ml.cookie is always equal to ml->cookie and we
never set lock to NULL.  So we never actually hit the NULL deref.
But it should probably still be cleaned up.

regards,
dan carpenter

On Wed, Aug 11, 2010 at 05:03:56PM -0700, Joel Becker wrote:
> On Sat, Aug 07, 2010 at 11:09:13AM +0200, Julia Lawall wrote:
> > From: Julia Lawall <julia@diku.dk>
> >=20
> > list_for_each_entry uses its first argument to move from one element to=
 the
> > next, so modifying it can break the iteration.
>=20
> 	Thanks for catching the bug.  It was introduced by 800deef3
> [ocfs2: use list_for_each_entry where benefical].  I blame Christoph.
>=20
> > diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
> > index 9dfaac7..7084a11 100644
> > --- a/fs/ocfs2/dlm/dlmrecovery.c
> > +++ b/fs/ocfs2/dlm/dlmrecovery.c
> > @@ -1792,10 +1792,10 @@ static int dlm_process_recovery_data(struct dlm=
_ctxt *dlm,
> >  			for (j =3D DLM_GRANTED_LIST; j <=3D DLM_BLOCKED_LIST; j++) {
> >  				tmpq =3D dlm_list_idx_to_ptr(res, j);
> >  				list_for_each_entry(lock, tmpq, list) {
> > -					if (lock->ml.cookie !=3D ml->cookie)
> > +					if (lock->ml.cookie !=3D ml->cookie) {
> >  						lock =3D NULL;
> > -					else
> >  						break;
> > +					}
> >  				}
> >  				if (lock)
> >  					break;
>=20
> 	However, this is not the correct solution.  The goal of the
> original code, which used to use list_for_each(), was to leave lock
> non-NULL if the cookie was found.  Your version merely exits the loop on
> the first non-matching entry, always leaving lock=3D=3DNULL if there is a
> non-matching entry.
> 	One possible solution is to return the original code:
>=20
> --8<-----------------------------------------------------------------
> @@ -1747,7 +1747,7 @@ static int dlm_process_recovery_data(struct dlm_ctx=
t *dlm,
>  				     struct dlm_migratable_lockres *mres)
>  {
>  	struct dlm_migratable_lock *ml;
> -	struct list_head *queue;
> +	struct list_head *queue, *iter;
>  	struct list_head *tmpq =3D NULL;
>  	struct dlm_lock *newlock =3D NULL;
>  	struct dlm_lockstatus *lksb =3D NULL;
> @@ -1791,11 +1791,12 @@ static int dlm_process_recovery_data(struct dlm_c=
txt *dlm,
>  			spin_lock(&res->spinlock);
>  			for (j =3D DLM_GRANTED_LIST; j <=3D DLM_BLOCKED_LIST; j++) {
>  				tmpq =3D dlm_list_idx_to_ptr(res, j);
> -				list_for_each_entry(lock, tmpq, list) {
> -					if (lock->ml.cookie !=3D ml->cookie)
> -						lock =3D NULL;
> -					else
> +				list_for_each(iter, tmpq) {
> +					lock =3D list_entry(iter, struct dlm_lock, list);
> +
> +					if (lock->ml.cookie =3D=3D ml->cookie)
>  						break;
> +					lock =3D NULL;
>  				}
>  				if (lock)
>  					break;
> -->8-----------------------------------------------------------------
>=20
> 	Another approach would be to keep list_for_each_entry() around,
> but use a better check for entry existence:
>=20
> --8<-----------------------------------------------------------------
> @@ -1792,13 +1792,12 @@ static int dlm_process_recovery_data(struct dlm_c=
txt *dlm,
>  			for (j =3D DLM_GRANTED_LIST; j <=3D DLM_BLOCKED_LIST; j++) {
>  				tmpq =3D dlm_list_idx_to_ptr(res, j);
>  				list_for_each_entry(lock, tmpq, list) {
> -					if (lock->ml.cookie !=3D ml->cookie)
> -						lock =3D NULL;
> -					else
> +					if (lock->ml.cookie =3D=3D ml->cookie)
>  						break;
>  				}
> -				if (lock)
> +				if (&lock->list !=3D tmpq)
>  					break;
> +				lock =3D NULL;
>  			}
> =20
>  			/* lock is always created locally first, and
> -->8-----------------------------------------------------------------
>=20
> 	I think I like the second one better.  Sunil, what do you think?
>=20
> Joel
>=20
> --=20
>=20
> Life's Little Instruction Book #335
>=20
> 	"Every so often, push your luck."
>=20
> Joel Becker
> Consulting Software Developer
> Oracle
> E-mail: joel.becker@oracle.com
> Phone: (650) 506-8127
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--envbJBWh7q8WU6mo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOsPOwAAoJEOnZkXI/YHqR3mcP/iyo70GqwhFTANuyRciVJyKp
k/X49XbNDvpjDtJSMlnUs/jeSHr0Czb7Wh3PKBeamqiPW54ApT0YHwArrKuimjtl
dAyXOnCuslTpMyXnuWmdnXE+HOioyVdMMIxz3c0qHhjBQ35dS47cb6t7c8kW65Mj
5dYAYuPQNVxJypKNCZ9TTnU1ndoV8QnxUIxNqT1bS9LHpbJ3KsXMCL8dPH4OeJ+8
OC+IKhHGSpPHtICcj6Ev6LqVs2+Tai/hI6dMXnwq83cBT0TOGjZB4NcCFqmUy/sl
IdR1XFREQFMO8o+LqTiMeq6FcXg9B++xj0X0EMOgbU/Djv15lu9xjM4d8UQ2gm69
OIeTtsn4e+K319RCnSXR6IRefEdkqy/T4C5pnUWsNKeQb7QEVkwwSBL/UMVScjn2
y6FWsTdpsatRkhWWE3HlUGeHQ+KGOFFTxLoWaVLkOMMhCIrpWEiL5DqRLYxf9wi1
Zzh2Awq47rM239QbHW3Tm5KEmubwr0uUP74OzdIAZo3kPgh1/FITq1bNMbu+UImw
+kU+hzP9QQT7kPm2nzQo9LOgWiRWWVR/zw2jGdI12+1OunPesBQrzNJfa0UWyI7Z
iDVR8tJF9O5xwS49avx2wZTjvhqKmIwbWOA1IrY6C4QmwYIZgVRDwrgj2jeV1vxu
CXiA0LuTA9d1ongJfO9G
=HP1/
-----END PGP SIGNATURE-----

--envbJBWh7q8WU6mo--
