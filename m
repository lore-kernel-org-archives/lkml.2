Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932388Ab2AJBW2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 20:22:28 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:40791 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932225Ab2AJBW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 20:22:26 -0500
Date: Tue, 10 Jan 2012 12:22:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jan Kara <jack@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: linux-next: manual merge of the ext3 tree with Linus' tree
Message-Id: <20120110122215.a63256b9b640b8ef458e58f8@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__10_Jan_2012_12_22_15_+1100_xOtWOo1eawteT7B/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__10_Jan_2012_12_22_15_+1100_xOtWOo1eawteT7B/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jan,

Today's linux-next merge of the ext3 tree got a conflict in
fs/ext2/ioctl.c between commit 2a79f17e4a64 ("vfs: mnt_drop_write_file
()") from Linus' tree and commit 6e85201ff4f4 ("ext2: protect inode
changes in the SETVERSION and SETFLAGS ioctls") from the ext3 tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/ext2/ioctl.c
index 1089f76,b7f931f..0000000
--- a/fs/ext2/ioctl.c
+++ b/fs/ext2/ioctl.c
@@@ -80,28 -80,38 +80,38 @@@ long ext2_ioctl(struct file *filp, unsi
 =20
  		ext2_set_inode_flags(inode);
  		inode->i_ctime =3D CURRENT_TIME_SEC;
+ 		mutex_unlock(&inode->i_mutex);
+=20
  		mark_inode_dirty(inode);
  setflags_out:
 -		mnt_drop_write(filp->f_path.mnt);
 +		mnt_drop_write_file(filp);
  		return ret;
  	}
  	case EXT2_IOC_GETVERSION:
  		return put_user(inode->i_generation, (int __user *) arg);
- 	case EXT2_IOC_SETVERSION:
+ 	case EXT2_IOC_SETVERSION: {
+ 		__u32 generation;
+=20
  		if (!inode_owner_or_capable(inode))
  			return -EPERM;
 -		ret =3D mnt_want_write(filp->f_path.mnt);
 +		ret =3D mnt_want_write_file(filp);
  		if (ret)
  			return ret;
- 		if (get_user(inode->i_generation, (int __user *) arg)) {
+ 		if (get_user(generation, (int __user *) arg)) {
  			ret =3D -EFAULT;
- 		} else {
- 			inode->i_ctime =3D CURRENT_TIME_SEC;
- 			mark_inode_dirty(inode);
+ 			goto setversion_out;
  		}
+=20
+ 		mutex_lock(&inode->i_mutex);
+ 		inode->i_ctime =3D CURRENT_TIME_SEC;
+ 		inode->i_generation =3D generation;
+ 		mutex_unlock(&inode->i_mutex);
+=20
+ 		mark_inode_dirty(inode);
+ setversion_out:
 -		mnt_drop_write(filp->f_path.mnt);
 +		mnt_drop_write_file(filp);
  		return ret;
+ 	}
  	case EXT2_IOC_GETRSVSZ:
  		if (test_opt(inode->i_sb, RESERVATION)
  			&& S_ISREG(inode->i_mode)

--Signature=_Tue__10_Jan_2012_12_22_15_+1100_xOtWOo1eawteT7B/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPC5LHAAoJEECxmPOUX5FEPnYP/RucJ8W4zfibfMGd87KvRw1c
Pq7wluT8aYuZPWIOGjb9etq22CQaFXrd1Kihv9wA/3AY8dQZQzp7ubnhy+fHJ3Cs
u+dqCZeJSMfgJuXtLWmIZ76lrEZLeq64sQfyCjcclWxKG1dEmuySe/I8xeOuBP1G
uvX4iXcVvnginJn8hD2PKtYZH0n1bWlfU7ssMNc7VL37ZHOiZCSwBRrHeX//oGDB
IsMtRZ7Qdk8l2oMeHPv+/2qdSkHQ3Kl/oNDonslQdX6u0af5aDON8F+U+VEx9Ej6
rBg+0ADwtrb1TBak5V92z8gzkKqGQSpUCXo2wS2W7z0qFh8oHEbTJiH5bk3IViK3
JkT80mv41ZVHdjXRr5jCnN0BsMX0I/8T524foLT9/+c20T0B2ysI7JTNLaz69YEH
PHI4H3Z8tACHTjxMhzpzrlK+SZz+bNLPlpRta4/Mbib1D7FPt6oixH9j1X/Bw4HE
+mpeb7Yv+nyJFMm4K0abeI0kKhFBssGu3W53G0T6E4SwMlXmuli6Jx0QumEzVDpy
B/teAoS1S2aXCbsaPP9UJvd1VGGI1/h0HPiAZl01Mh+H/AOC6ZsskM1PVO2uTtcq
GCqEPZUuZzLJ14UvlCF5tCGPUTj/XLW1jnjXapTcaHrUqOVgA6pkrnEKFmp4tC3s
VOJyL+9LsuXvSV2LAVmW
=0UxI
-----END PGP SIGNATURE-----

--Signature=_Tue__10_Jan_2012_12_22_15_+1100_xOtWOo1eawteT7B/--
