Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757119Ab2AFCyu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 21:54:50 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:52906 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab2AFCys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 21:54:48 -0500
Date: Fri, 6 Jan 2012 13:54:42 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Djalal Harouni <tixxdz@opendz.org>, "Theodore Ts'o" <tytso@mit.edu>
Subject: linux-next: manual merge of the vfs tree with the ext4 tree
Message-Id: <20120106135442.1720766a6c1510abf51b2aff@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__6_Jan_2012_13_54_42_+1100_zWGzpS/bwJ2SNGD/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__6_Jan_2012_13_54_42_+1100_zWGzpS/bwJ2SNGD/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the vfs tree got a conflict in
fs/ext4/ioctl.c between commits 2a415f129806 ("ext4: add missing
ext4_resize_end on error paths") and 22cdfca56418 ("ext4: remove unneeded
file_remove_suid() from ext4_ioctl()") from the ext4 tree and commit
a561be7100cd ("switch a bunch of places to mnt_want_write_file()") from
the vfs tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/ext4/ioctl.c
index f2c335b,d37b3bb..0000000
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@@ -173,11 -170,8 +173,11 @@@ flags_out
  			err =3D ext4_mark_iloc_dirty(handle, inode, &iloc);
  		}
  		ext4_journal_stop(handle);
 +
 +unlock_out:
 +		mutex_unlock(&inode->i_mutex);
  setversion_out:
- 		mnt_drop_write(filp->f_path.mnt);
+ 		mnt_drop_write_file(filp);
  		return err;
  	}
  	case EXT4_IOC_GROUP_EXTEND: {
@@@ -197,13 -189,12 +197,13 @@@
  			       EXT4_FEATURE_RO_COMPAT_BIGALLOC)) {
  			ext4_msg(sb, KERN_ERR,
  				 "Online resizing not supported with bigalloc");
 -			return -EOPNOTSUPP;
 +			err =3D -EOPNOTSUPP;
 +			goto group_extend_out;
  		}
 =20
- 		err =3D mnt_want_write(filp->f_path.mnt);
+ 		err =3D mnt_want_write_file(filp);
  		if (err)
 -			return err;
 +			goto group_extend_out;
 =20
  		err =3D ext4_group_extend(sb, EXT4_SB(sb)->s_es, n_blocks_count);
  		if (EXT4_SB(sb)->s_journal) {
@@@ -213,10 -204,9 +213,10 @@@
  		}
  		if (err =3D=3D 0)
  			err =3D err2;
 +
- 		mnt_drop_write(filp->f_path.mnt);
+ 		mnt_drop_write_file(filp);
 +group_extend_out:
  		ext4_resize_end(sb);
 -
  		return err;
  	}
 =20
@@@ -256,7 -246,9 +256,7 @@@
 =20
  		err =3D ext4_move_extents(filp, donor_filp, me.orig_start,
  					me.donor_start, me.len, &me.moved_len);
- 		mnt_drop_write(filp->f_path.mnt);
+ 		mnt_drop_write_file(filp);
 -		if (me.moved_len > 0)
 -			file_remove_suid(donor_filp);
 =20
  		if (copy_to_user((struct move_extent __user *)arg,
  				 &me, sizeof(me)))
@@@ -284,13 -274,12 +284,13 @@@ mext_out
  			       EXT4_FEATURE_RO_COMPAT_BIGALLOC)) {
  			ext4_msg(sb, KERN_ERR,
  				 "Online resizing not supported with bigalloc");
 -			return -EOPNOTSUPP;
 +			err =3D -EOPNOTSUPP;
 +			goto group_add_out;
  		}
 =20
- 		err =3D mnt_want_write(filp->f_path.mnt);
+ 		err =3D mnt_want_write_file(filp);
  		if (err)
 -			return err;
 +			goto group_add_out;
 =20
  		err =3D ext4_group_add(sb, &input);
  		if (EXT4_SB(sb)->s_journal) {
@@@ -300,10 -289,9 +300,10 @@@
  		}
  		if (err =3D=3D 0)
  			err =3D err2;
 +
- 		mnt_drop_write(filp->f_path.mnt);
+ 		mnt_drop_write_file(filp);
 +group_add_out:
  		ext4_resize_end(sb);
 -
  		return err;
  	}
 =20

--Signature=_Fri__6_Jan_2012_13_54_42_+1100_zWGzpS/bwJ2SNGD/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPBmJyAAoJEECxmPOUX5FE0GcP+QET3Ivib5oISz1iGWVv8b6C
na+cGNFKPIQ2g1RKhcfX+LZ+971We8x9hk7UEw0pVM9QkNZ62S4o1ZlXCuIx3jM0
aEJ/CObD8kC86i5r7id6NgCpx8J1wC0tQjga4WhfaN8y6XRBcWu4vr3KrXGIti7y
LFoVgh+sm1ATcpgmFXksqNYUuIdGxvgU6S0c1gi+fNPjm5YYyjYcIPbyGWwhOM8S
b7C6V4VL76Rzv7pL+CkEbyGUoGY56GxQ9kU9mhACdKkm9ARGQeQCMOzKACOYO1Rm
cghpYl63C7VA7oyh+TSty1OcldJzSqLOAZdXIIvdzckonm8XboEfELWd0RbvfO1J
csza7cT8buAqDBzmbxTiZtFE50YXQWJ1DHx9enYbPyZ32isN0k2iWQwHjthn157q
LsyxPT6XWpHE5Av69F1tjQsYz03Mb9OdJzWD4V5loSDK8D7MrWXIEHpJESAhGzIJ
Nv5GUijpfYd8xOLCV++lA95Pm86H+wrIMa3MhqTB/Zpq4RcHyp0WNxuKQV+ExAXK
Qwgvk3XgbGGW/Ds9RW/zJpe3FFL6yHjfo4c4pnF/vnYd4yQ9/hWV+CmohNOJ7eeo
ybV86CAGAkP9WydwMfz8OiaiucjMm8mORDeA2zjOHiTAWyUA+aWPiMZh3s772Gvn
biL+fPd8nGfoTSlAx3YB
=6/KE
-----END PGP SIGNATURE-----

--Signature=_Fri__6_Jan_2012_13_54_42_+1100_zWGzpS/bwJ2SNGD/--
