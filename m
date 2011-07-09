Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab1GIVBf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 17:01:35 -0400
Received: from home.keithp.com ([63.227.221.253]:48997 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754459Ab1GIVBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 17:01:34 -0400
From: "Keith Packard" <keithp@keithp.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: fault_in_pages_writeable/fault_in_pages_readable don't fault in everything
User-Agent: Notmuch/0.5-202-g6ae4e7d (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Sat, 09 Jul 2011 14:01:24 -0700
Message-ID: <yunr55zf9sr.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable


fault_in_pages_writeable and fault_in_pages_readable are only willing to
fault two pages at the most. I can't find any place where this is a good
idea, and in fact ntfs has replaced fault_in_pages_readable with a
private version which does the right thing.

Here's an (untested) patch which makes fault_in_pages_writeable hit
every page instead of just the first and last. It seems like this might
improve performance of larger read operations which may now end up
taking the slow path when an intermediate page is faulted in
__copy_to_user_inatomic.

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 716875e..f355f29 100644
=2D-- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -418,7 +418,13 @@ static inline int fault_in_pages_writeable(char __user=
 *uaddr, int size)
 	 * Writing zeroes into userspace here is OK, because we know that if
 	 * the zero gets there, we'll be overwriting it.
 	 */
=2D	ret =3D __put_user(0, uaddr);
+	for (;;) {
+		ret =3D __put_user(0, uaddr);
+		if (size < PAGE_SIZE)
+			break;
+		size -=3D PAGE_SIZE;
+		uaddr +=3D PAGE_SIZE;
+	}
 	if (ret =3D=3D 0) {
 		char __user *end =3D uaddr + size - 1;
=20

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOGMGkQp8BWwlsTdMRApNJAKDS7UPxXoMUEQMIeEofcOjIBmNAoACgyWZp
poJ0rkxjQjFzeNoi4xfPZZw=
=g66T
-----END PGP SIGNATURE-----
--=-=-=--
