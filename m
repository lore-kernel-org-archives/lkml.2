Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933039Ab2AKB17 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 20:27:59 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:37315 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757027Ab2AKB15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 20:27:57 -0500
Date: Wed, 11 Jan 2012 12:27:44 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sage Weil <sage@newdream.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Elder <elder@dreamhost.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: linux-next: manual merge of the ceph tree with Linus' tree
Message-Id: <20120111122744.7db3bfb91d79b1307db02228@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__11_Jan_2012_12_27_44_+1100_wW3BOkroEFX20_+q"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__11_Jan_2012_12_27_44_+1100_wW3BOkroEFX20_+q
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sage,

Today's linux-next merge of the ceph tree got a conflict in
fs/ceph/super.c between commit 3c5184ef1216 ("ceph: d_alloc_root() may
fail") from Linus' tree and commit 26d913cdd955 ("ceph: always initialize
the dentry in open_root_dentry()") from the ceph tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/ceph/super.c
index 48f61a1,ec74313..0000000
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@@ -636,21 -636,14 +636,21 @@@ static struct dentry *open_root_dentry(
  	req->r_num_caps =3D 2;
  	err =3D ceph_mdsc_do_request(mdsc, NULL, req);
  	if (err =3D=3D 0) {
 +		struct inode *inode =3D req->r_target_inode;
 +		req->r_target_inode =3D NULL;
  		dout("open_root_inode success\n");
 -		if (ceph_ino(req->r_target_inode) =3D=3D CEPH_INO_ROOT &&
 -		    fsc->sb->s_root =3D=3D NULL)
 -			root =3D d_alloc_root(req->r_target_inode);
 -		else
 -			root =3D d_obtain_alias(req->r_target_inode);
 +		if (ceph_ino(inode) =3D=3D CEPH_INO_ROOT &&
 +		    fsc->sb->s_root =3D=3D NULL) {
 +			root =3D d_alloc_root(inode);
 +			if (!root) {
 +				iput(inode);
 +				root =3D ERR_PTR(-ENOMEM);
 +				goto out;
 +			}
- 			ceph_init_dentry(root);
 +		} else {
 +			root =3D d_obtain_alias(inode);
 +		}
+ 		ceph_init_dentry(root);
 -		req->r_target_inode =3D NULL;
  		dout("open_root_inode success, root dentry is %p\n", root);
  	} else {
  		root =3D ERR_PTR(err);

--Signature=_Wed__11_Jan_2012_12_27_44_+1100_wW3BOkroEFX20_+q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPDOWQAAoJEECxmPOUX5FERZ0P/RT8gd7tAEGOJuCIa6sUvKVC
SDCQdgLuxjIhnX/smaOXf1sPxaNPijzClM/eZOCHhPCrBkmol5TaIJx27/OZK/OL
p/ZGCGyT84zgoz1aeqhYSDF89vM/64PlSIzxLCTe08pwuzOA1mS0J1iTeqkzaNxW
u9yIexAHdiZ2ICGPi5+L+ZTJTNCXdvHLmV+ne01bkoYJC8Swc1fOlOLFsYC6R01P
wAy/V7yeqUZWXs5Q68K1aCBfOVWkwDtbVhzKsX/ID2ypt19ODCm0dhDgme3/7hcr
MFMSjLv0y7Qi94J7R2Uf00xRAXv1noByPecGm3lrlzNVoSHkIVGp/V/Q1Mzhs0H8
tSiDjEIr1vRzYwZdCGn5YJRlfaFPMePhLm5jH39ZyO0Ga2w2WvfKQaGShZ1wlTrr
D5mQDZUEqzpPSgtFKsic1+7ZNYMXYYWarsQN8h7J3V0ii1IWbVx0SZSbtxzU+J9j
e+ByB4jTi1EkgsEW7xzmTyxFrxNqjJ686iFwboDVcxJUTKhVVFOPSWEqOlfEWq3v
Z6uK+c5cymSdpPwec31Xxwvk4XbaGny6sfX0hB5iZMyUlDtIUFC6MgCgiPCZMCV3
sWcjYBwgUCG32agNHB0Kqn/94+baC4ilZoCKIyGJ0FLImA6iuLThnODzH/R424Ub
hant7qrbw/zVC8fxK7HA
=mF7f
-----END PGP SIGNATURE-----

--Signature=_Wed__11_Jan_2012_12_27_44_+1100_wW3BOkroEFX20_+q--
