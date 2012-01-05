Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798Ab2AEJMm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 04:12:42 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50055 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247Ab2AEJMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 04:12:40 -0500
Message-ID: <1325754886.6755.20.camel@sauron.fi.intel.com>
Subject: Re: possible use-after-free in drivers/mtd/ubi/wl.c: erase_worker
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Emese Revfy <re.emese@gmail.com>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Thu, 05 Jan 2012 11:14:46 +0200
In-Reply-To: <20120104003446.695fd426@gmail.com>
References: <20120104003446.695fd426@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-sLu2pGJCzv6xDNEsX724"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-sLu2pGJCzv6xDNEsX724
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Well-spotted, thanks. I've just pushed this patch to the UBIFS git tree:


From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: [PATCH] UBI: fix use-after-free on error path

When we fail to erase a PEB, we free the corresponding erase entry object,
but then re-schedule this object if the error code was something like -EAGA=
IN.
Obviously, it is a bug to use the object after we have freed it.

Reported-by: Emese Revfy <re.emese@gmail.com>
Cc: stable@kernel.org [v2.6.23+]
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 drivers/mtd/ubi/wl.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 42c684c..036d213 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -1049,7 +1049,6 @@ static int erase_worker(struct ubi_device *ubi, struc=
t ubi_work *wl_wrk,
=20
 	ubi_err("failed to erase PEB %d, error %d", pnum, err);
 	kfree(wl_wrk);
-	kmem_cache_free(ubi_wl_entry_slab, e);
=20
 	if (err =3D=3D -EINTR || err =3D=3D -ENOMEM || err =3D=3D -EAGAIN ||
 	    err =3D=3D -EBUSY) {
@@ -1062,14 +1061,16 @@ static int erase_worker(struct ubi_device *ubi, str=
uct ubi_work *wl_wrk,
 			goto out_ro;
 		}
 		return err;
-	} else if (err !=3D -EIO) {
+	}
+
+	kmem_cache_free(ubi_wl_entry_slab, e);
+	if (err !=3D -EIO)
 		/*
 		 * If this is not %-EIO, we have no idea what to do. Scheduling
 		 * this physical eraseblock for erasure again would cause
 		 * errors again and again. Well, lets switch to R/O mode.
 		 */
 		goto out_ro;
-	}
=20
 	/* It is %-EIO, the PEB went bad */
=20
--=20
1.7.7.3

--=20
Best Regards,
Artem Bityutskiy

--=-sLu2pGJCzv6xDNEsX724
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPBWoGAAoJECmIfjd9wqK0K+UP/0L4s+nrNLQmWPHgUXUHyiJe
+tnpeeX+6CM2RnnhiFIrh3q8cHNBUnwgdVlFKsDiCMFIWen62+ZG7O+yZVZC6fdo
CTlYxtzxLThFWnNx2qWgiFT5IaITSIZiyczFEDzK3xPYLao5FzKyoPsX7aJfCaAO
asIXkH8k7xyNbGXmwLgBkUM2FndcPZsoeXipwKMFI+xeSuod3Laik/Vo7qS9L0ud
ZIdjuWD3AJVvkunAhl8Skj9u8dY5fzYFRqsfblJuRQ7DJYEKjCo3ika2faVSeJ+f
C/5uqdoV3W7DGavoQFUV6ugkyhWuHiv/60VlsFvqg5fZl8h8Jo20NN8aQDxfP+BK
BUvdFhD/xjZein1Q8MdrjLGzZp8Rnu6iLZkPK7i0cOQy/VcjQZ7+FvW0ikJznPmv
dxuWrWT+H5F/bQWKPY8IcrH6Q8x6735t5cwF29MT9mcIy7bTR6a5yfFPxvDTJV2/
P2xF4vj6U7Qn3hGbnMOwOjQJhd+lm2AFioHPW3sGRJPHt6sPYsxEGgwUTnsyids9
G9v2YHNzUia44cUhovJLHgJQjuf1e0SGdCFL27iqrzTUgP3WnfbH9ScL/9eM+6L7
KatC2LEhyCGcQcFjWqHf+WoQerM91lwE3tHDChOFsuPMVCQubq24c/88b9A/Foy1
Q3T0mWkkJoGGUIw1+Le8
=Ax3H
-----END PGP SIGNATURE-----

--=-sLu2pGJCzv6xDNEsX724--

