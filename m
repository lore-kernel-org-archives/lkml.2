Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668Ab2CQChv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 22:37:51 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47659 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752070Ab2CQCht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 22:37:49 -0400
Date: Sat, 17 Mar 2012 02:37:41 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jeff Layton <jlayton@redhat.com>,
        Pavel Shilovsky <piastry@etersoft.ru>,
        Steve French <sfrench@us.ibm.com>
Message-ID: <20120317023740.GH12704@decadent.org.uk>
References: <20120316233829.GA14022@kroah.com>
 <20120316233811.484341257@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="BwCQnh7xodEAoBMC"
Content-Disposition: inline
In-Reply-To: <20120316233811.484341257@linuxfoundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [ 10/41] CIFS: Do not kmalloc under the flocks spinlock
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BwCQnh7xodEAoBMC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 16, 2012 at 04:38:20PM -0700, Greg KH wrote:
> 3.2-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Pavel Shilovsky <piastry@etersoft.ru>
>=20
> commit d5751469f210d2149cc2159ffff66cbeef6da3f2 upstream.
>=20
> Reorganize the code to make the memory already allocated before
> spinlock'ed loop.
>=20
> Reviewed-by: Jeff Layton <jlayton@redhat.com>
> Signed-off-by: Pavel Shilovsky <piastry@etersoft.ru>
> Signed-off-by: Steve French <sfrench@us.ibm.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>=20
> ---
>  fs/cifs/file.c |   69 ++++++++++++++++++++++++++++++++++++++++++++++----=
-------
>  1 file changed, 56 insertions(+), 13 deletions(-)
>=20
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
[....]
> @@ -940,29 +950,55 @@ cifs_push_posix_locks(struct cifsFileInf
>  		return rc;
>  	}
> =20
> +	lock_flocks();
> +	cifs_for_each_lock(cfile->dentry->d_inode, before) {
> +		if ((*before)->fl_flags & FL_POSIX)
> +			count++;
> +	}
> +	unlock_flocks();
> +
>  	INIT_LIST_HEAD(&locks_to_send);
> =20
> +	/*
> +	 * Allocating count locks is enough because no locks can be added to
> +	 * the list while we are holding cinode->lock_mutex that protects
> +	 * locking operations of this inode.
> +	 */
> +	for (; i < count; i++) {
> +		lck =3D kmalloc(sizeof(struct lock_to_push), GFP_KERNEL);
> +		if (!lck) {
> +			rc =3D -ENOMEM;
> +			goto err_out;
> +		}
> +		list_add_tail(&lck->llist, &locks_to_send);
> +	}
> +
> +	i =3D 0;
> +	el =3D locks_to_send.next;
>  	lock_flocks();
>  	cifs_for_each_lock(cfile->dentry->d_inode, before) {
> +		if (el =3D=3D &locks_to_send) {
> +			/* something is really wrong */
> +			cERROR(1, "Can't push all brlocks!");
> +			break;
> +		}
>  		flock =3D *before;
> +		if ((flock->fl_flags & FL_POSIX) =3D=3D 0)
> +			continue;
[...]

If I understand the logic correctly, el =3D=3D &locks_to_send means we
already used all the lock_to_push structures.  (It should also be
equivalent to testing i =3D=3D count.  Why is i incremented but not
otherwise used in the loop?)

But we test this before flock->fl_flags & FL_POSIX, which means we
don't know whether this lock actually needs to be assigned one of
those structures.  So it appears that we might report a spurious error
if the lock list ends with a mandatory lock.  If so, this is
relatively harmless but does need to be fixed.

Ben.

--=20
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus

--BwCQnh7xodEAoBMC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUBT2P48+e/yOyVhhEJAQrGdA/9FnQ/kScrQU2uuFfgrkPZT1BprVWUJfI9
y/BEv2ogLZPfWiTRRbgyI5/Zrurb+329wITxBDyACUc2X2gZFxENgEmvb1ugjkO6
Q7cpKnfr29achwr1vVMsi9XSOsQohQoC7m7ZIYeF4IWJvlEwPtqsRAV0oQQt/0cN
0nZtRuLQpxc5x9q67iBCdAYnxQRwh9J95mFRQJ3H4LASoO8gNu6AWrtdZS/vnYxz
k6dc7GoQS9/KqC/mq62kOs56IfaxTxqcCjw7UMjbbz5/0ugxvQhGv3FIfQ0yKHEi
1d/f+aCbb1OSD/f3+nCiXCdc4cTEkgl2BmJSyRjes2xaTgI0M1UoqxCv7wAH/xv8
jYBjjCqdCWF83fU6mMBBKxfbVIuUj64OBSOpMLMRld68TA3Bmqr55lbta4VG/j1Z
tWYns7ddBl5Nkc/Sf0IoInxaklo4TWFW4DYuJcL/msKEf368gAuTPsAO1XWd1Pxk
i/Oj3dDX4N6MaATjDeLcTAbUPeGmFCEpe3szgJxr9A7w8NkJRZ/CoNuaZBNdHr5J
J6JeaOmErQwAhlxtGFUxktEbPxM9fmqkjXqyIhFfQQc66kt41wVF/KZEm7zR8dgx
gM7fjlsJm0hkAqVx5pzCtqMra8R9i6wyv8pFi3NfH0G8VhQl2Mv2MYPc+xcRVnvQ
yhsT/hO1YNs=
=bhZ0
-----END PGP SIGNATURE-----

--BwCQnh7xodEAoBMC--
