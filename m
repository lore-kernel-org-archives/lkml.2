Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758551Ab2EOLgp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 07:36:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:47851 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757814Ab2EOLgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 07:36:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="asc'?scan'208";a="144185707"
Message-ID: <1337082012.2528.181.camel@sauron.fi.intel.com>
Subject: Re: [PATCH V2] UBI: add ubi_lnum_purge function to clear work queue
 for a lnum
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Joel Reardon <joel@clambassador.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Tue, 15 May 2012 14:40:12 +0300
In-Reply-To: <alpine.DEB.2.00.1205150943470.17750@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1205150943470.17750@eristoteles.iwoars.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-5QkPN3sT2GSnyzhI5eAb"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-5QkPN3sT2GSnyzhI5eAb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-05-15 at 09:44 +0200, Joel Reardon wrote:
> This is the second part of a patch to allow UBI to force the erasure of
> particular logical eraseblock numbers. In this patch, a new function,
> ubi_lnum_purge, is added that allows the caller to synchronously erase al=
l
> unmapped erase blocks whose LEB number corresponds to the parameter. This
> requires a previous patch that stores the LEB number in struct ubi_work.
>=20
> This was tested by disabling the call to do_work in ubi thread, which res=
ults
> in the work queue remaining unless explicitly called to remove. UBIFS was
> changed to call ubifs_leb_change 50 times for three different LEBs. Then =
the
> new function was called to clear the queue for the three differnt LEB num=
bers
> one at a time. The work queue was dumped each time and the selective remo=
val
> of the particular LEB numbers was observed.
>=20
> Signed-off-by: Joel Reardon <reardonj@inf.ethz.ch>

No objections in general, and I can merge this as soon as you send the
final version. However, for this version I have several notes.

> +/**
> + * ubi_lnum_purge - synchronously erase unmapped PEBs by LEB number.
> + * @ubi_num: UBI device to erase PEBs
> + * @lnum: the LEB number to erase old unmapped PEBs.
> + *
> + * This function is designed to offer a means to ensure that the content=
s of
> + * old, unmapped LEBs are securely erased without having to flush the en=
tire
> + * work queue of all erase blocks that need erasure.  Simply erasing the=
 block
> + * at the time of unmapped is insufficient, as the wear-levelling subsys=
tem
> + * may have already moved the contents. This function navigates the list=
 of
> + * erase blocks that need erasures, and performs an immediate and synchr=
onous
> + * erasure of any erase block that has held data for this particular @ln=
um.
> + * This may include eraseblocks that held older versions of the same @ln=
um.
> + * Returns zero in case of success and a negative error code in case of
> + * failure.
> + */
> +int ubi_lnum_purge(int ubi_num, int lnum)
> +{
> +	int err;
> +	struct ubi_device *ubi;
> +
> +	ubi =3D ubi_get_device(ubi_num);
> +	if (!ubi)
> +		return -ENODEV;
> +
> +	err =3D ubi_wl_flush_lnum(ubi, lnum);
> +	ubi_put_device(ubi);
> +	return err;
> +}
> +EXPORT_SYMBOL_GPL(ubi_lnum_purge);

Please, do not introduce a separate exported function for this. Instead,
add "lnum" argument to "ubi_wl_flush". Preserve the old behavior if lnum
is -1. Document this at the header comment. In your case you also need
to call mtd->sync() I think.

> +	dbg_wl("flush lnum %d", lnum);
> +	list_for_each_entry_safe(wrk, tmp, &ubi->works, list) {
> +		if (wrk->lnum =3D=3D lnum) {
> +			down_read(&ubi->work_sem);
> +			spin_lock(&ubi->wl_lock);

But you cannot walk the ubi->works list without holding the spinlock.
Any one may add/remove elements to/from this list concurrently.

Take the work_sem at the beginning. Release at the very end.

Then you can do something like this:

int found =3D 1;

while (found) {
	found =3D 0;

	spin_lock(&ubi->wl_lock);
	list_for_each_entry(wrk, tmp, &ubi->works, list) {
		if (wrk->lnum =3D=3D lnum) {
			list_del(&wrk->list);
			ubi->works_count -=3D 1;
			ubi_assert(ubi->works_count >=3D 0);
			spin_unlock(&ubi->wl_lock);

			err =3D wrk->func(ubi, wrk, 0);
			if (err)
				return err;

			spin_lock(&ubi->wl_lock);
			found =3D 1;
			break;
	}
	spin_unlock(&ubi->wl_lock);
}

--=20
Best Regards,
Artem Bityutskiy

--=-5QkPN3sT2GSnyzhI5eAb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPskCcAAoJECmIfjd9wqK0q30P/3AbwSQR8T409yRS9h6I/rGz
2dIrP4cQLgphYS/g6f1oLni/qtuywlhG0wwhPPf3f0hHWT6Bn4H0pg67vdMKiKhU
Lv1XaSYRmnRz3x4Wxh1vC8+qDoLMMMUAoZDULPFWmbDGa63RVy18ETwM4Qj3Ba7m
+fNrCzeAQ6rP1fkkRjFpnDLt+DtC9yx4oc4qNV1sohLKM/ZEYrlwCbIOOV9TXoHo
+taqMzqNn4NLUvqb34VNv1ZJVjTeFW3nMGKdQVDhirUFWOqIygk+9+rqr35pNtdi
nTJxt5aoCZgB+xuHwtYz7l7PIN1hNXO5es6LBbJdEyh8UZ4vyNmmkJ1rUnF2H/RX
fgi4AfYbkGWH3rrpyH/V4cyJs76xuFlNKXq/rYOzXXW7IOGXOLs1r5og0NmnKHXA
/wtPympPmN5VF5KGsBMUo2AExhmhWfn82ogVf8utA9do5Gt6UZ202SEnZjkiiKfQ
6MmOpVXSoYCHgHCnfSCjzk5z7Y9or6GFVBp1RyNeXfU7hyxGasS2f0KzNln8u7ya
9Dr7bswHu2vVHStNOSPmQDy0fu4nropLgguNNUvyex1L2lKx4d6bTOKkmsRjSufV
J/a+cZTYJmONBaHtIEu9f+bMJUCtY1Kg1U81TM8VCojGQlN+VtW8Zb95ytJ2vUCj
za54gy9nY/dW2DsgU+An
=K6GV
-----END PGP SIGNATURE-----

--=-5QkPN3sT2GSnyzhI5eAb--

