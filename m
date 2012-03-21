Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758866Ab2CUBXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 21:23:39 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:60892 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756380Ab2CUBXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 21:23:38 -0400
Date: Wed, 21 Mar 2012 12:23:27 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sage Weil <sage@newdream.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Elder <elder@dreamhost.com>
Subject: linux-next: manual merge of the ceph tree with Linus' tree
Message-Id: <20120321122327.48a3169d4eba689987470942@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__21_Mar_2012_12_23_27_+1100_Ur+2WIQy+5B/dc49"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__21_Mar_2012_12_23_27_+1100_Ur+2WIQy+5B/dc49
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sage,

Today's linux-next merge of the ceph tree got a conflict in
fs/ceph/xattr.c between commit 83eb26af0db7 ("ceph: ensure prealloc_blob
is in place when removing xattr") from Linus' tree and commit
15226d16c19c ("ceph: make ceph_setxattr() and ceph_removexattr() more
alike") from the ceph tree.

I used the resolution provided by Alex (thanks) (see below) and I can
carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/ceph/xattr.c
index a76f697,a3c1f9b..0000000
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@@ -816,11 -883,10 +883,11 @@@ static int ceph_send_removexattr(struc
  int ceph_removexattr(struct dentry *dentry, const char *name)
  {
  	struct inode *inode =3D dentry->d_inode;
+ 	struct ceph_vxattr *vxattr;
  	struct ceph_inode_info *ci =3D ceph_inode(inode);
- 	struct ceph_vxattr_cb *vxattrs =3D ceph_inode_vxattrs(inode);
  	int issued;
  	int err;
 +	int required_blob_size;
  	int dirty;
 =20
  	if (ceph_snap(inode) !=3D CEPH_NOSNAP)
@@@ -829,42 -895,19 +896,39 @@@
  	if (!ceph_is_valid_xattr(name))
  		return -EOPNOTSUPP;
 =20
- 	if (vxattrs) {
- 		struct ceph_vxattr_cb *vxattr =3D
- 			ceph_match_vxattr(vxattrs, name);
- 		if (vxattr && vxattr->readonly)
- 			return -EOPNOTSUPP;
- 	}
+ 	vxattr =3D ceph_match_vxattr(inode, name);
+ 	if (vxattr && vxattr->readonly)
+ 		return -EOPNOTSUPP;
 =20
 +	err =3D -ENOMEM;
  	spin_lock(&ci->i_ceph_lock);
- 	__build_xattrs(inode);
 +retry:
  	issued =3D __ceph_caps_issued(ci, NULL);
  	dout("removexattr %p issued %s\n", inode, ceph_cap_string(issued));
-=20
  	if (!(issued & CEPH_CAP_XATTR_EXCL))
  		goto do_sync;
+ 	__build_xattrs(inode);
 =20
 +	required_blob_size =3D __get_required_blob_size(ci, 0, 0);
 +
 +	if (!ci->i_xattrs.prealloc_blob ||
 +	    required_blob_size > ci->i_xattrs.prealloc_blob->alloc_len) {
 +		struct ceph_buffer *blob;
 +
 +		spin_unlock(&ci->i_ceph_lock);
 +		dout(" preaallocating new blob size=3D%d\n", required_blob_size);
 +		blob =3D ceph_buffer_new(required_blob_size, GFP_NOFS);
 +		if (!blob)
 +			goto out;
 +		spin_lock(&ci->i_ceph_lock);
 +		if (ci->i_xattrs.prealloc_blob)
 +			ceph_buffer_put(ci->i_xattrs.prealloc_blob);
 +		ci->i_xattrs.prealloc_blob =3D blob;
 +		goto retry;
 +	}
 +
  	err =3D __remove_xattr_by_name(ceph_inode(inode), name);
+=20
  	dirty =3D __ceph_mark_dirty_caps(ci, CEPH_CAP_XATTR_EXCL);
  	ci->i_xattrs.dirty =3D true;
  	inode->i_ctime =3D CURRENT_TIME;

--Signature=_Wed__21_Mar_2012_12_23_27_+1100_Ur+2WIQy+5B/dc49
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPaS2PAAoJEECxmPOUX5FEOxQQAJZxfNNxm5in7jGcN9xfKvEq
pBZiyLkldbNC3wQ+LTUrYVNa5xD/Mm7qo5yh5+EEEFHrXkw8Dbc52uQj+IOB/Kax
9/60EErESIKiuuZ/xghytsHJlZNYM4ZOrRAq3Nws6ilVMzuoB4mgPr3MlcS/h+CD
YEAlF79J5SgWEvztNZIAB9VUQMU4vYLzfg9knMJN3WP0xuxBOM8jds5ai8ncO/da
fqmMqdyBnRSiK+QY72/5WZDxGYZNowgGeQEoqfzq9CMBgdFwiiArrknZnDP6Zb6W
Ewq0lSQH1vQp+RW/vTj8sq+8XeidDRzulAmolLebop9jL5+a1ZVX/V/Vz6YoHZ2N
gCMsIC3O6qyoCTHCZmJLoNlEkTxeK+wj4EnaXAepwiwoYihPEyJ8LP6lY2o28oO6
+dY7YNMgtecTOoEUSxHSErkadqqY5t7USOmGkVn1iX7/DF39bgCEHero0ozixDlb
Axex5GbQv/rWPyfiKDNY6XVLJLIxdO0h6+Dj/XWS0kOmDeM8x8hxebdyXbVU6fsd
6ddZ1EXux2clcgazfiBlvHZOUZwqFjQ4dTUaViIw2e5dkG55QcG/7FCSz0ZsTsso
xEv2xnLD5+hTMt61FTvjUhIQwFBrLKo3H/3hwsok95pd9RBRArNyYXvBhSDwbgty
FjuMNrcVO7wE40xAilwD
=p4BH
-----END PGP SIGNATURE-----

--Signature=_Wed__21_Mar_2012_12_23_27_+1100_Ur+2WIQy+5B/dc49--
