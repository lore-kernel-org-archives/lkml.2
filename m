Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342Ab2EMNrf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 09:47:35 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50594 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab2EMNrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 09:47:33 -0400
Message-ID: <4FAFBB70.6070704@gmail.com>
Date: Sun, 13 May 2012 15:47:28 +0200
From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?= 
	<phcoder@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
CC: Al Viro <viro@zeniv.linux.org.uk>, Josef Bacik <josef@redhat.com>,
        Jan Kara <jack@suse.cz>, Miklos Szeredi <mszeredi@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Sage Weil <sage@newdream.net>
Subject: [PATCH] Add AFFS NLS support
X-Enigmail-Version: 1.4.1
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig34880E3A31017BB8B066C660"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig34880E3A31017BB8B066C660
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

AFFS almost always uses latin1. However usual iocharset by now is UTF-8. =
So
NLS support is required.

Signed-off-by: Vladimir Serbinenko <phcoder@gmail.com>

diff --git a/fs/affs/Kconfig b/fs/affs/Kconfig
index cfad9af..93ab9d4b 100644
--- a/fs/affs/Kconfig
+++ b/fs/affs/Kconfig
@@ -19,3 +19,11 @@ config AFFS_FS
=20
 	  To compile this file system support as a module, choose M here: the
 	  module will be called affs.  If unsure, say N.
+
+config AFFS_DEFAULT_CODEPAGE
+	string "Default codepage for AFFS"
+	depends on AFFS_FS
+	default "iso8859-1"
+	help
+	  This option should be set to the codepage of your AFFS filesystems.
+	  It can be overridden with the "codepage" mount option.
diff --git a/fs/affs/affs.h b/fs/affs/affs.h
index fc1d4ca..7bf696d 100644
--- a/fs/affs/affs.h
+++ b/fs/affs/affs.h
@@ -12,6 +12,8 @@
  */
 /*#define AFFS_NO_TRUNCATE */
=20
+#define AFFS_MAXNAME 30
+
 /* Ugly macros make the code more pretty. */
=20
 #define GET_END_PTR(st,p,sz)		 ((st *)((char *)(p)+((sz)-sizeof(st))))
@@ -107,6 +109,10 @@ struct affs_sb_info {
 	u32 s_bmap_bits;		/* # of bits in one bitmap blocks */
 	u32 s_last_bmap;
 	struct buffer_head *s_bmap_bh;
+	char *iocharset;
+	char *codepage;
+	struct nls_table *nls_io;
+	struct nls_table *nls_disk;
 	char *s_prefix;			/* Prefix for volumes and assigns. */
 	char s_volume[32];		/* Volume prefix for absolute symlinks. */
 	spinlock_t symlink_lock;	/* protects the previous two */
@@ -142,8 +148,9 @@ extern umode_t	prot_to_mode(u32 prot);
 extern void	mode_to_prot(struct inode *inode);
 extern void	affs_error(struct super_block *sb, const char *function, con=
st char *fmt, ...);
 extern void	affs_warning(struct super_block *sb, const char *function, c=
onst char *fmt, ...);
-extern int	affs_check_name(const unsigned char *name, int len);
-extern int	affs_copy_name(unsigned char *bstr, struct dentry *dentry);
+extern int	affs_check_name(const unsigned char *name, unsigned int len);=

+extern int	affs_copy_name(struct super_block *sb, unsigned char *bstr,
+			       struct dentry *dentry);
=20
 /* bitmap. c */
=20
@@ -165,8 +172,13 @@ extern int	affs_link(struct dentry *olddentry, struc=
t inode *dir,
 			  struct dentry *dentry);
 extern int	affs_symlink(struct inode *dir, struct dentry *dentry,
 			     const char *symname);
+extern int      affs_read_symlink(struct inode *inode,
+				  char *link);
 extern int	affs_rename(struct inode *old_dir, struct dentry *old_dentry,=

 			    struct inode *new_dir, struct dentry *new_dentry);
+extern size_t   affs_translate(u8 *to, const u8 *from, struct nls_table =
*nls_to,
+			       struct nls_table *nls_from, size_t limit,
+			       size_t from_len);
=20
 /* inode.c */
=20
diff --git a/fs/affs/amigaffs.c b/fs/affs/amigaffs.c
index 52a6407..08f39ee 100644
--- a/fs/affs/amigaffs.c
+++ b/fs/affs/amigaffs.c
@@ -477,15 +477,15 @@ affs_warning(struct super_block *sb, const char *fu=
nction, const char *fmt, ...)
 /* Check if the name is valid for a affs object. */
=20
 int
-affs_check_name(const unsigned char *name, int len)
+affs_check_name(const unsigned char *name, unsigned int len)
 {
 	int	 i;
=20
-	if (len > 30)
+	if (len > AFFS_MAXNAME)
 #ifdef AFFS_NO_TRUNCATE
 		return -ENAMETOOLONG;
 #else
-		len =3D 30;
+		len =3D AFFS_MAXNAME;
 #endif
=20
 	for (i =3D 0; i < len; i++) {
@@ -497,19 +497,3 @@ affs_check_name(const unsigned char *name, int len)
 	return 0;
 }
=20
-/* This function copies name to bstr, with at most 30
- * characters length. The bstr will be prepended by
- * a length byte.
- * NOTE: The name will must be already checked by
- *       affs_check_name()!
- */
-
-int
-affs_copy_name(unsigned char *bstr, struct dentry *dentry)
-{
-	int len =3D min(dentry->d_name.len, 30u);
-
-	*bstr++ =3D len;
-	memcpy(bstr, dentry->d_name.name, len);
-	return len;
-}
diff --git a/fs/affs/dir.c b/fs/affs/dir.c
index 8ca8f3a..81da2ec 100644
--- a/fs/affs/dir.c
+++ b/fs/affs/dir.c
@@ -55,6 +55,8 @@ affs_readdir(struct file *filp, void *dirent, filldir_t=
 filldir)
 	u32			 ino;
 	int			 stored;
 	int			 res;
+	struct nls_table *nls_io =3D AFFS_SB(sb)->nls_io;
+	struct nls_table *nls_disk =3D AFFS_SB(sb)->nls_disk;
=20
 	pr_debug("AFFS: readdir(ino=3D%lu,f_pos=3D%lx)\n",inode->i_ino,(unsigne=
d long)filp->f_pos);
=20
@@ -122,17 +124,31 @@ affs_readdir(struct file *filp, void *dirent, filld=
ir_t filldir)
 		f_pos =3D (hash_pos << 16) + 2;
 inside:
 		do {
+			/* AFFS names are at most 30 characters and are all in
+			   BMP. So at most 90 characters resulting translation
+			   assuming UTF-8 as iocharset. Then comes paranoia.
+			   In worst-case scenario filenames get truncated but
+			   no overflow occurs.
+			*/
+			char buf[200];
+			size_t translatedlen;
 			fh_bh =3D affs_bread(sb, ino);
 			if (!fh_bh) {
 				affs_error(sb, "readdir","Cannot read block %d", ino);
 				goto readdir_done;
 			}
=20
-			namelen =3D min(AFFS_TAIL(sb, fh_bh)->name[0], (u8)30);
+			namelen =3D min(((u8 *)AFFS_TAIL(sb, fh_bh)->name)[0],
+				      (u8)AFFS_MAXNAME);
 			name =3D AFFS_TAIL(sb, fh_bh)->name + 1;
+			translatedlen =3D affs_translate(buf, name,
+						       nls_io, nls_disk,
+						       sizeof(buf),
+						       namelen);
 			pr_debug("AFFS: readdir(): filldir(\"%.*s\", ino=3D%u), hash=3D%d, f_=
pos=3D%x\n",
 				 namelen, name, ino, hash_pos, f_pos);
-			if (filldir(dirent, name, namelen, f_pos, ino, DT_UNKNOWN) < 0)
+			if (filldir(dirent, buf, translatedlen, f_pos, ino,
+				    DT_UNKNOWN) < 0)
 				goto readdir_done;
 			stored++;
 			f_pos++;
diff --git a/fs/affs/inode.c b/fs/affs/inode.c
index 88a4b0b..2a88f7a 100644
--- a/fs/affs/inode.c
+++ b/fs/affs/inode.c
@@ -143,11 +143,17 @@ struct inode *affs_iget(struct super_block *sb, uns=
igned long ino)
 		inode->i_fop =3D &affs_file_operations;
 		break;
 	case ST_SOFTLINK:
+	{
+		int s;
 		inode->i_mode |=3D S_IFLNK;
 		inode->i_op =3D &affs_symlink_inode_operations;
 		inode->i_data.a_ops =3D &affs_symlink_aops;
+		s =3D affs_read_symlink(inode, 0);
+
+		inode->i_size =3D s >=3D 0 ? s : 0;
 		break;
 	}
+	}
=20
 	inode->i_mtime.tv_sec =3D inode->i_atime.tv_sec =3D inode->i_ctime.tv_s=
ec
 		       =3D (be32_to_cpu(tail->change.days) * (24 * 60 * 60) +
@@ -375,7 +381,7 @@ affs_add_entry(struct inode *dir, struct inode *inode=
, struct dentry *dentry, s3
=20
 	AFFS_HEAD(bh)->ptype =3D cpu_to_be32(T_SHORT);
 	AFFS_HEAD(bh)->key =3D cpu_to_be32(bh->b_blocknr);
-	affs_copy_name(AFFS_TAIL(sb, bh)->name, dentry);
+	affs_copy_name(sb, AFFS_TAIL(sb, bh)->name, dentry);
 	AFFS_TAIL(sb, bh)->stype =3D cpu_to_be32(type);
 	AFFS_TAIL(sb, bh)->parent =3D cpu_to_be32(dir->i_ino);
=20
diff --git a/fs/affs/namei.c b/fs/affs/namei.c
index 4780694..600fa3e 100644
--- a/fs/affs/namei.c
+++ b/fs/affs/namei.c
@@ -9,6 +9,7 @@
  */
=20
 #include "affs.h"
+#include <linux/nls.h>
=20
 typedef int (*toupper_t)(int);
=20
@@ -66,18 +67,24 @@ affs_get_toupper(struct super_block *sb)
  * Note: the dentry argument is the parent dentry.
  */
 static inline int
-__affs_hash_dentry(struct qstr *qstr, toupper_t toupper)
+__affs_hash_dentry(struct super_block *sb, struct qstr *qstr, toupper_t =
toupper)
 {
-	const u8 *name =3D qstr->name;
+	const u8 *name;
 	unsigned long hash;
 	int i;
+	u8 tmp[AFFS_MAXNAME + 1];
+	size_t len;
=20
-	i =3D affs_check_name(qstr->name, qstr->len);
+	len =3D affs_translate(tmp, qstr->name, AFFS_SB(sb)->nls_disk,
+			     AFFS_SB(sb)->nls_io, sizeof(tmp), qstr->len);
+
+	i =3D affs_check_name(tmp, len);
 	if (i)
 		return i;
=20
 	hash =3D init_name_hash();
-	i =3D min(qstr->len, 30u);
+	i =3D len;
+	name =3D tmp;
 	for (; i > 0; name++, i--)
 		hash =3D partial_name_hash(toupper(*name), hash);
 	qstr->hash =3D end_name_hash(hash);
@@ -89,41 +96,49 @@ static int
 affs_hash_dentry(const struct dentry *dentry, const struct inode *inode,=

 		struct qstr *qstr)
 {
-	return __affs_hash_dentry(qstr, affs_toupper);
+	struct super_block *sb =3D inode->i_sb;
+	return __affs_hash_dentry(sb, qstr, affs_toupper);
 }
 static int
 affs_intl_hash_dentry(const struct dentry *dentry, const struct inode *i=
node,
 		struct qstr *qstr)
 {
-	return __affs_hash_dentry(qstr, affs_intl_toupper);
+	struct super_block *sb =3D inode->i_sb;
+	return __affs_hash_dentry(sb, qstr, affs_intl_toupper);
 }
=20
-static inline int __affs_compare_dentry(unsigned int len,
-		const char *str, const struct qstr *name, toupper_t toupper)
+static inline int __affs_compare_dentry(struct super_block *sb,
+					unsigned int len,
+					const char *str,
+					const struct qstr *name,
+					toupper_t toupper)
 {
-	const u8 *aname =3D str;
-	const u8 *bname =3D name->name;
+	u8 atmp[AFFS_MAXNAME + 1], btmp[AFFS_MAXNAME + 1];
+	size_t alen, blen;
+	const u8 *aname =3D atmp;
+	const u8 *bname =3D btmp;
+
+	alen =3D affs_translate(atmp, str, AFFS_SB(sb)->nls_disk,
+			      AFFS_SB(sb)->nls_io, sizeof(atmp), len);
+	blen =3D affs_translate(btmp, name->name, AFFS_SB(sb)->nls_disk,
+			      AFFS_SB(sb)->nls_io, sizeof(btmp), name->len);
=20
 	/*
 	 * 'str' is the name of an already existing dentry, so the name
 	 * must be valid. 'name' must be validated first.
 	 */
=20
-	if (affs_check_name(name->name, name->len))
+	if (affs_check_name(bname, blen))
 		return 1;
=20
 	/*
 	 * If the names are longer than the allowed 30 chars,
 	 * the excess is ignored, so their length may differ.
 	 */
-	if (len >=3D 30) {
-		if (name->len < 30)
-			return 1;
-		len =3D 30;
-	} else if (len !=3D name->len)
+	if (alen !=3D blen)
 		return 1;
=20
-	for (; len > 0; len--)
+	for (; alen > 0; alen--)
 		if (toupper(*aname++) !=3D toupper(*bname++))
 			return 1;
=20
@@ -135,14 +150,16 @@ affs_compare_dentry(const struct dentry *parent, co=
nst struct inode *pinode,
 		const struct dentry *dentry, const struct inode *inode,
 		unsigned int len, const char *str, const struct qstr *name)
 {
-	return __affs_compare_dentry(len, str, name, affs_toupper);
+	struct super_block *sb =3D pinode->i_sb;
+	return __affs_compare_dentry(sb, len, str, name, affs_toupper);
 }
 static int
 affs_intl_compare_dentry(const struct dentry *parent,const struct inode =
*pinode,
 		const struct dentry *dentry, const struct inode *inode,
 		unsigned int len, const char *str, const struct qstr *name)
 {
-	return __affs_compare_dentry(len, str, name, affs_intl_toupper);
+	struct super_block *sb =3D pinode->i_sb;
+	return __affs_compare_dentry(sb, len, str, name, affs_intl_toupper);
 }
=20
 /*
@@ -150,15 +167,12 @@ affs_intl_compare_dentry(const struct dentry *paren=
t,const struct inode *pinode,
  */
=20
 static inline int
-affs_match(struct dentry *dentry, const u8 *name2, toupper_t toupper)
+affs_match(const u8 *name, size_t len, const u8 *name2, toupper_t touppe=
r)
 {
-	const u8 *name =3D dentry->d_name.name;
-	int len =3D dentry->d_name.len;
-
-	if (len >=3D 30) {
-		if (*name2 < 30)
+	if (len >=3D AFFS_MAXNAME) {
+		if (*name2 < AFFS_MAXNAME)
 			return 0;
-		len =3D 30;
+		len =3D AFFS_MAXNAME;
 	} else if (len !=3D *name2)
 		return 0;
=20
@@ -172,9 +186,12 @@ int
 affs_hash_name(struct super_block *sb, const u8 *name, unsigned int len)=

 {
 	toupper_t toupper =3D affs_get_toupper(sb);
-	int hash;
+	uint32_t hash;
+
+	if (len > AFFS_MAXNAME)
+		len =3D AFFS_MAXNAME;
=20
-	hash =3D len =3D min(len, 30u);
+	hash =3D len;
 	for (; len > 0; len--)
 		hash =3D (hash * 13 + toupper(*name++)) & 0x7ff;
=20
@@ -188,6 +205,12 @@ affs_find_entry(struct inode *dir, struct dentry *de=
ntry)
 	struct buffer_head *bh;
 	toupper_t toupper =3D affs_get_toupper(sb);
 	u32 key;
+	u8 name[AFFS_MAXNAME + 1];
+	size_t namelen;
+
+	namelen =3D affs_translate(name, dentry->d_name.name,
+				 AFFS_SB(sb)->nls_disk, AFFS_SB(sb)->nls_io,
+				 sizeof(name), dentry->d_name.len);
=20
 	pr_debug("AFFS: find_entry(\"%.*s\")\n", (int)dentry->d_name.len, dentr=
y->d_name.name);
=20
@@ -195,7 +218,8 @@ affs_find_entry(struct inode *dir, struct dentry *den=
try)
 	if (!bh)
 		return ERR_PTR(-EIO);
=20
-	key =3D be32_to_cpu(AFFS_HEAD(bh)->table[affs_hash_name(sb, dentry->d_n=
ame.name, dentry->d_name.len)]);
+	key =3D be32_to_cpu(AFFS_HEAD(bh)->table[affs_hash_name(sb,
+							      name, namelen)]);
=20
 	for (;;) {
 		affs_brelse(bh);
@@ -204,7 +228,7 @@ affs_find_entry(struct inode *dir, struct dentry *den=
try)
 		bh =3D affs_bread(sb, key);
 		if (!bh)
 			return ERR_PTR(-EIO);
-		if (affs_match(dentry, AFFS_TAIL(sb, bh)->name, toupper))
+		if (affs_match(name, namelen, AFFS_TAIL(sb, bh)->name, toupper))
 			return bh;
 		key =3D be32_to_cpu(AFFS_TAIL(sb, bh)->hash_chain);
 	}
@@ -332,9 +356,14 @@ affs_symlink(struct inode *dir, struct dentry *dentr=
y, const char *symname)
 	char			*p;
 	int			 i, maxlen, error;
 	char			 c, lc;
+	char                     convbuf[10];
+	size_t                   convbufpos =3D 0, convbuflen =3D 0;
+	struct nls_table        *nls_io =3D AFFS_SB(sb)->nls_io;
+	struct nls_table        *nls_disk =3D AFFS_SB(sb)->nls_disk;
+	const char              *symnameend =3D symname + strlen(symname);
=20
-	pr_debug("AFFS: symlink(%lu,\"%.*s\" -> \"%s\")\n",dir->i_ino,
-		 (int)dentry->d_name.len,dentry->d_name.name,symname);
+	pr_debug("AFFS: symlink(%lu,\"%.*s\" -> \"%s\")\n", dir->i_ino,
+		 (int)dentry->d_name.len, dentry->d_name.name, symname);
=20
 	maxlen =3D AFFS_SB(sb)->s_hashsize * sizeof(u32) - 1;
 	inode  =3D affs_new_inode(dir);
@@ -362,7 +391,44 @@ affs_symlink(struct inode *dir, struct dentry *dentr=
y, const char *symname)
 			*p++ =3D sbi->s_volume[i++];
 		spin_unlock(&sbi->symlink_lock);
 	}
-	while (i < maxlen && (c =3D *symname++)) {
+
+	while (i < maxlen) {
+		if (convbuflen =3D=3D convbufpos) {
+			convbufpos =3D convbuflen =3D 0;
+			if (*symname =3D=3D 0)
+				break;
+			if (nls_disk && nls_io) {
+				ssize_t len;
+				wchar_t uni;
+				len =3D nls_io->char2uni(symname,
+						       symnameend - symname,
+						       &uni);
+				if (len <=3D 0) {
+					convbufpos =3D 0;
+					convbuflen =3D 1;
+					convbuf[0] =3D '?';
+					symname++;
+				} else {
+					symname +=3D len;
+					len =3D nls_disk->uni2char(uni, convbuf,
+								 sizeof(convbuf)
+								 );
+					if (len > 0) {
+						convbuflen =3D len;
+					} else {
+						convbufpos =3D 0;
+						convbuflen =3D 1;
+						convbuf[0] =3D '?';
+					}
+				}
+			} else {
+				convbufpos =3D 0;
+				convbuflen =3D 1;
+				convbuf[0] =3D *symname++;
+			}
+		}
+		c =3D convbuf[convbufpos++];
+
 		if (c =3D=3D '.' && lc =3D=3D '/' && *symname =3D=3D '.' && symname[1]=
 =3D=3D '/') {
 			*p++ =3D '/';
 			i++;
@@ -381,6 +447,9 @@ affs_symlink(struct inode *dir, struct dentry *dentry=
, const char *symname)
 				symname++;
 	}
 	*p =3D 0;
+
+	inode->i_size =3D affs_read_symlink(inode, 0);
+
 	mark_buffer_dirty_inode(bh, inode);
 	affs_brelse(bh);
 	mark_inode_dirty(inode);
@@ -444,7 +513,7 @@ affs_rename(struct inode *old_dir, struct dentry *old=
_dentry,
 		goto done;
=20
 	/* And insert it into the new directory with the new name. */
-	affs_copy_name(AFFS_TAIL(sb, bh)->name, new_dentry);
+	affs_copy_name(sb, AFFS_TAIL(sb, bh)->name, new_dentry);
 	affs_fix_checksum(sb, bh);
 	affs_lock_dir(new_dir);
 	retval =3D affs_insert_hash(new_dir, bh);
@@ -456,3 +525,71 @@ done:
 	affs_brelse(bh);
 	return retval;
 }
+
+static size_t affs_translate_real(u8 *to, const u8 *from,
+				  struct nls_table *nls_to,
+				  struct nls_table *nls_from,
+				  size_t limit, size_t from_len)
+{
+	wchar_t uni;
+	size_t i;
+	ssize_t len;
+	size_t to_len =3D limit;
+	u8 *to0 =3D to;
+
+	if (nls_to) {
+		for (i =3D 0; i < from_len && to_len > 0 && from[i]; ) {
+			len =3D nls_from->char2uni(&from[i], from_len-i, &uni);
+			if (len > 0) {
+				i +=3D len;
+				len =3D nls_to->uni2char(uni, to, to_len);
+				if (len > 0) {
+					to +=3D len;
+					to_len -=3D len;
+				}
+			} else
+				i++;
+			if (len <=3D 0) {
+				*to++ =3D '?';
+				to_len--;
+			}
+		}
+		return to - to0;
+	} else {
+		size_t len;
+		len =3D from_len;
+		if (len > limit)
+			len =3D limit;
+		memcpy(to, from, len);
+		return len;
+	}
+}
+
+size_t affs_translate(u8 *to, const u8 *from, struct nls_table *nls_to,
+		      struct nls_table *nls_from, size_t limit, size_t from_len)
+{
+	size_t r;
+	r =3D affs_translate_real(to, from, nls_to, nls_from,
+				limit - 1, from_len);
+	to[r] =3D 0;
+	return r;
+}
+/* This function copies name to bstr, with at most AFFS_MAXNAME
+ * characters length. The bstr will be prepended by
+ * a length byte.
+ * NOTE: The name will must be already checked by
+ *       affs_check_name()!
+ */
+
+int
+affs_copy_name(struct super_block *sb, unsigned char *bstr,
+	       struct dentry *dentry)
+{
+	size_t len;
+	len =3D affs_translate_real(bstr + 1, dentry->d_name.name,
+				  AFFS_SB(sb)->nls_disk,
+				  AFFS_SB(sb)->nls_io, AFFS_MAXNAME,
+				  dentry->d_name.len);
+	*bstr =3D len;
+	return len;
+}
diff --git a/fs/affs/super.c b/fs/affs/super.c
index 1df3c95..27f9e98 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -17,10 +17,18 @@
 #include <linux/magic.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
+#include <linux/nls.h>
 #include "affs.h"
=20
 extern struct timezone sys_tz;
=20
+#ifdef CONFIG_AFFS_DEFAULT_CODEPAGE
+static char affs_default_codepage[] =3D CONFIG_AFFS_DEFAULT_CODEPAGE;
+#else
+static char affs_default_codepage[] =3D "iso8859-1";
+#endif
+static char affs_default_iocharset[] =3D CONFIG_NLS_DEFAULT;
+
 static int affs_statfs(struct dentry *dentry, struct kstatfs *buf);
 static int affs_remount (struct super_block *sb, int *flags, char *data)=
;
=20
@@ -48,6 +56,15 @@ affs_put_super(struct super_block *sb)
 	if (!(sb->s_flags & MS_RDONLY) && sb->s_dirt)
 		affs_commit_super(sb, 1, 1);
=20
+	if (sbi->nls_disk)
+		unload_nls(sbi->nls_disk);
+	if (sbi->nls_io)
+		unload_nls(sbi->nls_io);
+	if (sbi->iocharset !=3D affs_default_iocharset)
+		kfree(sbi->iocharset);
+	if (sbi->codepage !=3D affs_default_codepage)
+		kfree(sbi->codepage);
+
 	kfree(sbi->s_prefix);
 	affs_free_bitmap(sb);
 	affs_brelse(sbi->s_root_bh);
@@ -149,7 +166,8 @@ static const struct super_operations affs_sops =3D {
 enum {
 	Opt_bs, Opt_mode, Opt_mufs, Opt_prefix, Opt_protect,
 	Opt_reserved, Opt_root, Opt_setgid, Opt_setuid,
-	Opt_verbose, Opt_volume, Opt_ignore, Opt_err,
+	Opt_verbose, Opt_volume, Opt_iocharset, Opt_codepage,
+	Opt_ignore, Opt_err,
 };
=20
 static const match_table_t tokens =3D {
@@ -168,12 +186,16 @@ static const match_table_t tokens =3D {
 	{Opt_ignore, "noquota"},
 	{Opt_ignore, "quota"},
 	{Opt_ignore, "usrquota"},
+	{Opt_iocharset, "iocharset=3D%s"},
+	{Opt_codepage, "codepage=3D%s"},
 	{Opt_err, NULL},
 };
=20
 static int
 parse_options(char *options, uid_t *uid, gid_t *gid, int *mode, int *res=
erved, s32 *root,
-		int *blocksize, char **prefix, char *volume, unsigned long *mount_opts=
)
+	      int *blocksize, char **prefix, char *volume,
+	      unsigned long *mount_opts,
+	      char **iocharset, char **codepage)
 {
 	char *p;
 	substring_t args[MAX_OPT_ARGS];
@@ -246,6 +268,24 @@ parse_options(char *options, uid_t *uid, gid_t *gid,=
 int *mode, int *reserved, s
 			*uid =3D option;
 			*mount_opts |=3D SF_SETUID;
 			break;
+		case Opt_iocharset:
+			if (*iocharset !=3D affs_default_iocharset) {
+				kfree(*iocharset);
+				*iocharset =3D NULL;
+			}
+			*iocharset =3D match_strdup(&args[0]);
+			if (!*iocharset)
+				return 0;
+			break;
+		case Opt_codepage:
+			if (*codepage !=3D affs_default_codepage) {
+				kfree(*codepage);
+				*codepage =3D NULL;
+			}
+			*codepage =3D match_strdup(&args[0]);
+			if (!*codepage)
+				return 0;
+			break;
 		case Opt_verbose:
 			*mount_opts |=3D SF_VERBOSE;
 			break;
@@ -309,14 +349,53 @@ static int affs_fill_super(struct super_block *sb, =
void *data, int silent)
 	mutex_init(&sbi->s_bmlock);
 	spin_lock_init(&sbi->symlink_lock);
=20
+	sbi->iocharset =3D affs_default_iocharset;
+	sbi->codepage =3D affs_default_codepage;
+
 	if (!parse_options(data,&uid,&gid,&i,&reserved,&root_block,
-				&blocksize,&sbi->s_prefix,
-				sbi->s_volume, &mount_flags)) {
+			   &blocksize, &sbi->s_prefix,
+			   sbi->s_volume, &mount_flags,
+			   &sbi->iocharset, &sbi->codepage
+		    )) {
 		printk(KERN_ERR "AFFS: Error parsing options\n");
 		kfree(sbi->s_prefix);
+		if (sbi->iocharset !=3D affs_default_iocharset)
+			kfree(sbi->iocharset);
+		if (sbi->codepage !=3D affs_default_codepage)
+			kfree(sbi->codepage);
 		kfree(sbi);
 		return -EINVAL;
 	}
+
+	if (sbi->codepage[0] !=3D '\0' && strcmp(sbi->codepage, "none") !=3D 0)=
 {
+		sbi->nls_disk =3D load_nls(sbi->codepage);
+		if (!sbi->nls_disk) {
+			printk(KERN_ERR "AFFS: codepage %s not found\n",
+			       sbi->codepage);
+			if (sbi->iocharset !=3D affs_default_iocharset)
+				kfree(sbi->iocharset);
+			if (sbi->codepage !=3D affs_default_codepage)
+				kfree(sbi->codepage);
+			kfree(sbi);
+			return -EINVAL;
+		}
+		sbi->nls_io =3D load_nls(sbi->iocharset);
+		if (!sbi->nls_io) {
+			printk(KERN_ERR "AFFS: IO charset %s not found\n",
+			       sbi->iocharset);
+			unload_nls(sbi->nls_disk);
+			if (sbi->iocharset !=3D affs_default_iocharset)
+				kfree(sbi->iocharset);
+			if (sbi->codepage !=3D affs_default_codepage)
+				kfree(sbi->codepage);
+			kfree(sbi);
+			return -EINVAL;
+		}
+	} else {
+		sbi->nls_io =3D NULL;
+		sbi->nls_disk =3D NULL;
+	}
+
 	/* N.B. after this point s_prefix must be released */
=20
 	sbi->s_flags   =3D mount_flags;
@@ -449,7 +528,7 @@ got_root:
 	if (mount_flags & SF_VERBOSE) {
 		u8 len =3D AFFS_ROOT_TAIL(sb, root_bh)->disk_name[0];
 		printk(KERN_NOTICE "AFFS: Mounting volume \"%.*s\": Type=3D%.3s\\%c, B=
locksize=3D%d\n",
-			len > 31 ? 31 : len,
+			len > (AFFS_MAXNAME + 1) ? (AFFS_MAXNAME + 1) : len,
 			AFFS_ROOT_TAIL(sb, root_bh)->disk_name + 1,
 			sig, sig[3] + '0', blocksize);
 	}
@@ -474,7 +553,7 @@ got_root:
 	root_inode =3D affs_iget(sb, root_block);
 	if (IS_ERR(root_inode)) {
 		ret =3D PTR_ERR(root_inode);
-		goto out_error;
+		goto out_error_noinode;
 	}
=20
 	if (AFFS_SB(sb)->s_flags & SF_INTL)
@@ -495,6 +574,18 @@ got_root:
 	 * Begin the cascaded cleanup ...
 	 */
 out_error:
+	if (root_inode)
+		iput(root_inode);
+out_error_noinode:
+	if (sbi->nls_disk)
+		unload_nls(sbi->nls_disk);
+	if (sbi->nls_io)
+		unload_nls(sbi->nls_io);
+	if (sbi->iocharset !=3D affs_default_iocharset)
+		kfree(sbi->iocharset);
+	if (sbi->codepage !=3D affs_default_codepage)
+		kfree(sbi->codepage);
+
 	kfree(sbi->s_bitmap);
 	affs_brelse(root_bh);
 	kfree(sbi->s_prefix);
@@ -526,7 +617,8 @@ affs_remount(struct super_block *sb, int *flags, char=
 *data)
 	memcpy(volume, sbi->s_volume, 32);
 	if (!parse_options(data, &uid, &gid, &mode, &reserved, &root_block,
 			   &blocksize, &prefix, volume,
-			   &mount_flags)) {
+			   &mount_flags,
+			   &sbi->iocharset, &sbi->codepage)) {
 		kfree(prefix);
 		kfree(new_opts);
 		return -EINVAL;
@@ -577,7 +669,7 @@ affs_statfs(struct dentry *dentry, struct kstatfs *bu=
f)
 	buf->f_bavail  =3D free;
 	buf->f_fsid.val[0] =3D (u32)id;
 	buf->f_fsid.val[1] =3D (u32)(id >> 32);
-	buf->f_namelen =3D 30;
+	buf->f_namelen =3D AFFS_MAXNAME;
 	return 0;
 }
=20
diff --git a/fs/affs/symlink.c b/fs/affs/symlink.c
index ee00f08..be94d01 100644
--- a/fs/affs/symlink.c
+++ b/fs/affs/symlink.c
@@ -9,17 +9,21 @@
  */
=20
 #include "affs.h"
+#include <linux/nls.h>
=20
-static int affs_symlink_readpage(struct file *file, struct page *page)
+int affs_read_symlink(struct inode *inode, char *link)
 {
 	struct buffer_head *bh;
-	struct inode *inode =3D page->mapping->host;
-	char *link =3D kmap(page);
 	struct slink_front *lf;
 	int err;
 	int			 i, j;
 	char			 c;
 	char			 lc;
+	const char              *symname, *symnameend;
+	char                     convbuf[10];
+	size_t                   convbufpos =3D 0, convbuflen =3D 0;
+	struct nls_table        *nls_io =3D AFFS_SB(inode->i_sb)->nls_io;
+	struct nls_table        *nls_disk =3D AFFS_SB(inode->i_sb)->nls_disk;
=20
 	pr_debug("AFFS: follow_link(ino=3D%lu)\n",inode->i_ino);
=20
@@ -37,36 +41,97 @@ static int affs_symlink_readpage(struct file *file, s=
truct page *page)
 		char *pf;
 		spin_lock(&sbi->symlink_lock);
 		pf =3D sbi->s_prefix ? sbi->s_prefix : "/";
-		while (i < 1023 && (c =3D pf[i]))
-			link[i++] =3D c;
+		while (i < 1023 && (c =3D pf[i])) {
+			if (link)
+				link[i] =3D c;
+			i++;
+		}
 		spin_unlock(&sbi->symlink_lock);
 		while (i < 1023 && lf->symname[j] !=3D ':')
 			link[i++] =3D lf->symname[j++];
+		if (i < 1023 && link)
+			link[i] =3D '/';
 		if (i < 1023)
-			link[i++] =3D '/';
+			i++;
 		j++;
 		lc =3D '/';
 	}
-	while (i < 1023 && (c =3D lf->symname[j])) {
+	symname =3D lf->symname + j;
+	symnameend =3D symname + strlen(symname);
+	while (i < 1023) {
+		pr_debug("Remaining <%s>\n", symname);
+		if (convbuflen =3D=3D convbufpos) {
+			convbufpos =3D convbuflen =3D 0;
+			if (*symname =3D=3D 0)
+				break;
+			if (nls_disk && nls_io) {
+				ssize_t len;
+				wchar_t uni;
+				len =3D nls_disk->char2uni(symname,
+							 symnameend - symname,
+							 &uni);
+				if (len <=3D 0) {
+					convbufpos =3D 0;
+					convbuflen =3D 1;
+					convbuf[0] =3D '?';
+					symname++;
+				} else {
+					symname +=3D len;
+					len =3D nls_io->uni2char(uni, convbuf,
+							       sizeof(convbuf));
+					if (len > 0) {
+						convbuflen =3D len;
+					} else {
+						convbufpos =3D 0;
+						convbuflen =3D 1;
+						convbuf[0] =3D '?';
+					}
+				}
+			} else {
+				convbufpos =3D 0;
+				convbuflen =3D 1;
+				convbuf[0] =3D *symname++;
+			}
+		}
+		c =3D convbuf[convbufpos++];
+		pr_debug("Fetching char <%c>\n", c);
+
 		if (c =3D=3D '/' && lc =3D=3D '/' && i < 1020) {	/* parent dir */
-			link[i++] =3D '.';
-			link[i++] =3D '.';
+			if (link) {
+				link[i] =3D '.';
+				link[i + 1] =3D '.';
+			}
+			i +=3D 2;
 		}
-		link[i++] =3D c;
+		if (link)
+			link[i] =3D c;
+		i++;
 		lc =3D c;
-		j++;
 	}
-	link[i] =3D '\0';
+	if (link)
+		link[i] =3D '\0';
 	affs_brelse(bh);
+	return i;
+fail:
+	return err;
+}
+
+static int affs_symlink_readpage(struct file *file, struct page *page)
+{
+	struct inode *inode =3D page->mapping->host;
+	char *link =3D kmap(page);
+	int ret;
+	ret =3D affs_read_symlink(inode, link);
+	if (ret < 0) {
+		SetPageError(page);
+		kunmap(page);
+		unlock_page(page);
+		return ret;
+	}
 	SetPageUptodate(page);
 	kunmap(page);
 	unlock_page(page);
 	return 0;
-fail:
-	SetPageError(page);
-	kunmap(page);
-	unlock_page(page);
-	return err;
 }
=20
 const struct address_space_operations affs_symlink_aops =3D {



--------------enig34880E3A31017BB8B066C660
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iF4EAREKAAYFAk+vu3AACgkQNak7dOguQglTLAEAtqDqmVdz4302phBifxvuwmqt
ytefQg5V3m7MKqmIYMkA/iwOc499z9hnePOplvNayg3zZDyN6A7+JxvDS3mVGfVV
=Y9JD
-----END PGP SIGNATURE-----

--------------enig34880E3A31017BB8B066C660--
