Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758584Ab2AFCrK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 21:47:10 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:47373 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758436Ab2AFCrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 21:47:08 -0500
Date: Fri, 6 Jan 2012 13:46:58 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>, Eric Van Hensbergen <ericvh@gmail.com>
Subject: linux-next: manual merge of the vfs tree with the v9fs tree
Message-Id: <20120106134658.7589dec177541808dad20eb9@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__6_Jan_2012_13_46_58_+1100_/B5a9ZdHuiPALX.m"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__6_Jan_2012_13_46_58_+1100_/B5a9ZdHuiPALX.m
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the vfs tree got conflicts in
fs/9p/vfs_inode.c and fs/9p/vfs_inode_dotl.c between commit 5d3851530d6d
("9p: Reduce object size with CONFIG_NET_9P_DEBUG") from the v9fs tree
and commits c2837de73e80 ("9p: don't bother with unixmode2p9mode() for
link() and symlink()") and 3eda0de677b5 ("9p: propagate umode_t") from
the vfs tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/9p/vfs_inode.c
index c8fe480,e0f20de..0000000
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@@ -127,14 -94,14 +122,14 @@@ static int p9mode2perm(struct v9fs_sess
   * @rdev: major number, minor number in case of device files.
   *
   */
- static int p9mode2unixmode(struct v9fs_session_info *v9ses,
- 			   struct p9_wstat *stat, dev_t *rdev)
+ static umode_t p9mode2unixmode(struct v9fs_session_info *v9ses,
+ 			       struct p9_wstat *stat, dev_t *rdev)
  {
  	int res;
- 	int mode =3D stat->mode;
+ 	u32 mode =3D stat->mode;
 =20
 -	res =3D mode & S_IALLUGO;
  	*rdev =3D 0;
 +	res =3D p9mode2perm(v9ses, stat);
 =20
  	if ((mode & P9_DMDIR) =3D=3D P9_DMDIR)
  		res |=3D S_IFDIR;
@@@ -352,8 -329,8 +346,8 @@@ int v9fs_init_inode(struct v9fs_session
 =20
  		break;
  	default:
- 		p9_debug(P9_DEBUG_ERROR, "BAD mode 0x%x S_IFMT 0x%x\n",
 -		P9_DPRINTK(P9_DEBUG_ERROR, "BAD mode 0x%hx S_IFMT 0x%x\n",
 -			   mode, mode & S_IFMT);
++		p9_debug(P9_DEBUG_ERROR, "BAD mode 0x%hx S_IFMT 0x%x\n",
 +			 mode, mode & S_IFMT);
  		err =3D -EINVAL;
  		goto error;
  	}
@@@ -375,7 -352,7 +369,7 @@@ struct inode *v9fs_get_inode(struct sup
  	struct inode *inode;
  	struct v9fs_session_info *v9ses =3D sb->s_fs_info;
 =20
- 	p9_debug(P9_DEBUG_VFS, "super block: %p mode: %o\n", sb, mode);
 -	P9_DPRINTK(P9_DEBUG_VFS, "super block: %p mode: %ho\n", sb, mode);
++	p9_debug(P9_DEBUG_VFS, "super block: %p mode: %ho\n", sb, mode);
 =20
  	inode =3D new_inode(sb);
  	if (!inode) {
@@@ -1362,10 -1333,10 +1355,10 @@@ static int v9fs_vfs_mkspecial(struct in
  static int
  v9fs_vfs_symlink(struct inode *dir, struct dentry *dentry, const char *sy=
mname)
  {
 -	P9_DPRINTK(P9_DEBUG_VFS, " %lu,%s,%s\n", dir->i_ino,
 -					dentry->d_name.name, symname);
 +	p9_debug(P9_DEBUG_VFS, " %lu,%s,%s\n",
 +		 dir->i_ino, dentry->d_name.name, symname);
 =20
- 	return v9fs_vfs_mkspecial(dir, dentry, S_IFLNK, symname);
+ 	return v9fs_vfs_mkspecial(dir, dentry, P9_DMSYMLINK, symname);
  }
 =20
  /**
@@@ -1419,14 -1391,16 +1412,16 @@@ clunk_fid
   */
 =20
  static int
- v9fs_vfs_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t =
rdev)
+ v9fs_vfs_mknod(struct inode *dir, struct dentry *dentry, umode_t mode, de=
v_t rdev)
  {
+ 	struct v9fs_session_info *v9ses =3D v9fs_inode2v9ses(dir);
  	int retval;
  	char *name;
+ 	u32 perm;
 =20
- 	p9_debug(P9_DEBUG_VFS, " %lu,%s mode: %x MAJOR: %u MINOR: %u\n",
 -	P9_DPRINTK(P9_DEBUG_VFS,
 -		" %lu,%s mode: %hx MAJOR: %u MINOR: %u\n", dir->i_ino,
 -		dentry->d_name.name, mode, MAJOR(rdev), MINOR(rdev));
++	p9_debug(P9_DEBUG_VFS, " %lu,%s mode: %hx MAJOR: %u MINOR: %u\n",
 +		 dir->i_ino, dentry->d_name.name, mode,
 +		 MAJOR(rdev), MINOR(rdev));
 =20
  	if (!new_valid_dev(rdev))
  		return -EINVAL;
diff --cc fs/9p/vfs_inode_dotl.c
index 73488fb,8ef152a..0000000
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@@ -283,8 -283,8 +283,8 @@@ v9fs_vfs_create_dotl(struct inode *dir
  	}
 =20
  	name =3D (char *) dentry->d_name.name;
- 	p9_debug(P9_DEBUG_VFS, "name:%s flags:0x%x mode:0x%x\n",
- 		 name, flags, omode);
 -	P9_DPRINTK(P9_DEBUG_VFS, "v9fs_vfs_create_dotl: name:%s flags:0x%x "
++	p9_debug(P9_DEBUG_VFS, "v9fs_vfs_create_dotl: name:%s flags:0x%x "
+ 			"mode:0x%hx\n", name, flags, omode);
 =20
  	dfid =3D v9fs_fid_lookup(dentry->d_parent);
  	if (IS_ERR(dfid)) {
@@@ -810,9 -813,9 +810,9 @@@ v9fs_vfs_mknod_dotl(struct inode *dir,=20
  	struct dentry *dir_dentry;
  	struct posix_acl *dacl =3D NULL, *pacl =3D NULL;
 =20
- 	p9_debug(P9_DEBUG_VFS, " %lu,%s mode: %x MAJOR: %u MINOR: %u\n",
 -	P9_DPRINTK(P9_DEBUG_VFS,
 -		" %lu,%s mode: %hx MAJOR: %u MINOR: %u\n", dir->i_ino,
 -		dentry->d_name.name, omode, MAJOR(rdev), MINOR(rdev));
++	p9_debug(P9_DEBUG_VFS, " %lu,%s mode: %hx MAJOR: %u MINOR: %u\n",
 +		 dir->i_ino, dentry->d_name.name, omode,
 +		 MAJOR(rdev), MINOR(rdev));
 =20
  	if (!new_valid_dev(rdev))
  		return -EINVAL;

--Signature=_Fri__6_Jan_2012_13_46_58_+1100_/B5a9ZdHuiPALX.m
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPBmCiAAoJEECxmPOUX5FEPqkP/iZRoQ/zcbzqz4hfeKyQ5QwD
4tZSAzEbJGXvHJgF+gPQhOtGVcrKbDCwa9SEVUIx+zm+OWW6SZCtAjC1r0i0e/yK
PuddiTcfRc1su4bIOpZKdCrXIcWx3+nPRI1qX/v6JbKSWAmdoO4yJFw1xURyrADF
ifJWjCN9QU6gC1o8fnjxPt9h5lGmcBOwSbVwtsAt8+awDhW0c/BFfYvlxKEgYRln
vASW+ZNZuGoGPhOwbr0Ys63oxr8SnIW87tPIGLwAbHTkQInAbJQ1CgAFESZQF1hK
qMXFBatqtwu388id6qKviS68ZoTfABdLDSmqK+Hv1R97jHeTIf6lR7ABeP+Gfpfs
ZRcE5xHAaI73k/6z5safnHG4rhxjtAEBhJDmoJjSJgj4OPG7z/LlKAmLHJbeqp71
YyJvGzmXzIguQwr/wEURQmhTcW2fA07D2uvL7mIbGZ8qlxfMOTeBHJOxCqawEqTb
BQy1NvKxzzK0LcxQERGdBTjanYmDGQle0yyTjNgnFg2KRt+r7idJMiA98vXvggTi
fqeEIsQxRowfCe3KCXkclrXhGDpWJKdx2MRlXAfvb5fKJowD5+PH769lV3q61RlP
l3BrmWZnwrl4KlpcOPled5cU4unIqypcnf1EWpTCT1bQj4rFKxj8woxz/w4tIrOF
esGDP/yd40IV163Yj+Ag
=ZByF
-----END PGP SIGNATURE-----

--Signature=_Fri__6_Jan_2012_13_46_58_+1100_/B5a9ZdHuiPALX.m--
