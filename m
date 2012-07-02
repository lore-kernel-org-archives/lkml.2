Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481Ab2GBBgY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 21:36:24 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:38449 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375Ab2GBBgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 21:36:22 -0400
Date: Mon, 2 Jul 2012 11:36:09 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Miklos Szeredi <mszeredi@suse.cz>, Andy Adamson <andros@netapp.com>,
        Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: linux-next: manual merge of the vfs tree with the nfs tree
Message-Id: <20120702113609.f466f618f983d93de5e167ce@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__2_Jul_2012_11_36_09_+1000_tZqe=qPOdUBISiku"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__2_Jul_2012_11_36_09_+1000_tZqe=qPOdUBISiku
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the vfs tree got a conflict in
fs/nfs/nfs4proc.c between commit 6e5b587d2f42 ("NFSv4.1 handle OPEN
O_CREATE mdsthreshold") from the nfs tree and commit 2cca3fbfc12b ("nfs:
clean up ->create in nfs_rpc_ops") from the vfs tree.

I fixed it up (I think - see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/nfs/nfs4proc.c
index 7d387cb,267be3c..0000000
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@@ -2804,39 -2779,22 +2804,25 @@@ static int nfs4_proc_readlink(struct in
  }
 =20
  /*
-  * Got race?
-  * We will need to arrange for the VFS layer to provide an atomic open.
-  * Until then, this create/open method is prone to inefficiency and race
-  * conditions due to the lookup, create, and open VFS calls from sys_open=
()
-  * placed on the wire.
-  *
-  * Given the above sorry state of affairs, I'm simply sending an OPEN.
-  * The file will be opened again in the subsequent VFS open call
-  * (nfs4_proc_file_open).
-  *
-  * The open for read will just hang around to be used by any process that
-  * opens the file O_RDONLY. This will all be resolved with the VFS change=
s.
+  * This is just for mknod.  open(O_CREAT) will always do ->open_context().
   */
-=20
  static int
  nfs4_proc_create(struct inode *dir, struct dentry *dentry, struct iattr *=
sattr,
-                  int flags, struct nfs_open_context *ctx)
+ 		 int flags)
  {
- 	struct dentry *de =3D dentry;
+ 	struct nfs_open_context *ctx;
  	struct nfs4_state *state;
- 	struct rpc_cred *cred =3D NULL;
 +	struct nfs4_threshold **thp =3D NULL;
- 	fmode_t fmode =3D 0;
  	int status =3D 0;
 =20
- 	if (ctx !=3D NULL) {
- 		cred =3D ctx->cred;
- 		de =3D ctx->dentry;
- 		fmode =3D ctx->mode;
+ 	ctx =3D alloc_nfs_open_context(dentry, FMODE_READ);
+ 	if (IS_ERR(ctx))
+ 		return PTR_ERR(ctx);
+=20
++	if (ctx !=3D NULL)
 +		thp =3D &ctx->mdsthreshold;
- 	}
  	sattr->ia_mode &=3D ~current_umask();
- 	state =3D nfs4_do_open(dir, de, fmode, flags, sattr, cred, thp);
 -	state =3D nfs4_do_open(dir, dentry, ctx->mode, flags, sattr, ctx->cred, =
NULL);
++	state =3D nfs4_do_open(dir, dentry, ctx->mode, flags, sattr, ctx->cred, =
thp);
  	d_drop(dentry);
  	if (IS_ERR(state)) {
  		status =3D PTR_ERR(state);

--Signature=_Mon__2_Jul_2012_11_36_09_+1000_tZqe=qPOdUBISiku
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP8PsJAAoJEECxmPOUX5FE4bQP/jUHgQyx7I1fiVi6J0ptxvXI
nViJ9E/fkTDv9rXNWMUJf8d/xTxoFc3QGbd9nvzmuCf1hbFwfgiRU01HNRFUQAiH
oBBxHR8q4zp+QmdpZYfLkNbWHWxIbvrwx906TjPrgmGFRgx+5+QuepbJyMAJ7uW0
f7lPVrfdgonq02/A0cNOZZFbcihdtgR/tyP+EjuU0muGsE/u+chBwvdRGMzmc7Qi
McpGSe/VY4w/Ct3yBRihJM8pKl6qiypMQ9ywk+AV1U4bXqd8jngHdBi1l+q0eK9h
7/GNKjNze/W0vXBdTxW9MZKaaNYcKeo5e6yAt8yw5HYrnNIHExBuRYW8J4oypKp4
ce3oDZku1s/Ro2PHnVNsQFZWv7Sr/5QwaNrgjwgkJnE8XdmYzDq8pLK2/tsfn00K
Ti84dAMTvRuLSP587DzF4Iigpv54XeR/N48YSLvLqRFiWDOIhhM5T8bwPw9yuzgU
Pk9sxn4Mzoahxk3djHDgndYuymA7CHVLpBZkJyjqwtEUaMrD4Xezxgx1YXgf18Qq
lPZ/FxW4VGZC+gOsIMOp0dEjED/9g48JvI/tfp2ZbaRMbJj9dQqiLODamENpnd6V
g5mA6nDlhhCZQMLQViYqjPfx5uTddXamAP9lKRELjanEaRor9Rr46JvQn5RoYnwr
hGGQQVD5EMKJlw5Ih7KU
=ABuB
-----END PGP SIGNATURE-----

--Signature=_Mon__2_Jul_2012_11_36_09_+1000_tZqe=qPOdUBISiku--
