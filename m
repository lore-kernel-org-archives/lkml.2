Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab0K0KeO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 05:34:14 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:34802 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752570Ab0K0K0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 05:26:06 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAO1p8Ex5Lcx2/2dsb2JhbACjC3K9doVHBIUUhU2FFA
Message-Id: <8a895bdf47e6e5962a9fe1c4d220f166cba0e688.1290852959.git.npiggin@kernel.dk>
In-Reply-To: <cover.1290852958.git.npiggin@kernel.dk>
References: <cover.1290852958.git.npiggin@kernel.dk>
From: Nick Piggin <npiggin@kernel.dk>
Date: Sat, 27 Nov 2010 20:44:39 +1100
Subject: [PATCH 09/46] fs: change d_hash for rcu-walk
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change d_hash so it may be called from lock-free RCU lookups. See similar
patch for d_compare for details.

For in-tree filesystems, this is just a mechanical change.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>
---
 Documentation/filesystems/Locking |    5 +++--
 Documentation/filesystems/porting |    7 +++++++
 Documentation/filesystems/vfs.txt |    8 ++++++--
 fs/adfs/dir.c                     |    3 ++-
 fs/affs/namei.c                   |   20 ++++++++++++--------
 fs/cifs/dir.c                     |    5 +++--
 fs/cifs/readdir.c                 |    2 +-
 fs/dcache.c                       |    2 +-
 fs/ecryptfs/inode.c               |    4 ++--
 fs/fat/namei_msdos.c              |    3 ++-
 fs/fat/namei_vfat.c               |    8 +++++---
 fs/gfs2/dentry.c                  |    3 ++-
 fs/hfs/hfs_fs.h                   |    3 ++-
 fs/hfs/string.c                   |    3 ++-
 fs/hfsplus/hfsplus_fs.h           |    3 ++-
 fs/hfsplus/unicode.c              |    3 ++-
 fs/hpfs/dentry.c                  |    3 ++-
 fs/isofs/inode.c                  |   28 ++++++++++++++++++----------
 fs/jfs/namei.c                    |    3 ++-
 fs/namei.c                        |    5 +++--
 fs/ncpfs/dir.c                    |   10 +++++-----
 fs/sysv/namei.c                   |    3 ++-
 include/linux/dcache.h            |    3 ++-
 23 files changed, 88 insertions(+), 49 deletions(-)

diff --git a/Documentation/filesystems/Locking b/Documentation/filesystems/Locking
index fc5e1b7..5bceb19 100644
--- a/Documentation/filesystems/Locking
+++ b/Documentation/filesystems/Locking
@@ -10,7 +10,8 @@ be able to use diff(1).
 --------------------------- dentry_operations --------------------------
 prototypes:
 	int (*d_revalidate)(struct dentry *, int);
-	int (*d_hash) (struct dentry *, struct qstr *);
+	int (*d_hash)(const struct dentry *, const struct inode *,
+			struct qstr *);
 	int (*d_compare)(const struct dentry *,
 			const struct dentry *, const struct inode *,
 			unsigned int, const char *, const struct qstr *);
@@ -23,7 +24,7 @@ locking rules:
 	none have BKL
 		dcache_lock	rename_lock	->d_lock	may block
 d_revalidate:	no		no		no		yes
-d_hash		no		no		no		yes
+d_hash		no		no		no		no
 d_compare:	no		yes		no		no 
 d_delete:	yes		no		yes		no
 d_release:	no		no		no		yes
diff --git a/Documentation/filesystems/porting b/Documentation/filesystems/porting
index 2999495..0c6fc97 100644
--- a/Documentation/filesystems/porting
+++ b/Documentation/filesystems/porting
@@ -334,3 +334,10 @@ unreferenced dentries, and is now only called when the dentry refcount goes to
 changed. Read updated documentation in Documentation/filesystems/vfs.txt (and
 look at examples of other filesystems) for guidance.
 
+---
+[mandatory]
+
+	.d_hash() calling convention and locking rules are significantly
+changed. Read updated documentation in Documentation/filesystems/vfs.txt (and
+look at examples of other filesystems) for guidance.
+
diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index 0f66e6a..47c29ca 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -841,7 +841,8 @@ defined:
 
 struct dentry_operations {
 	int (*d_revalidate)(struct dentry *, struct nameidata *);
-	int (*d_hash)(struct dentry *, struct qstr *);
+	int (*d_hash)(const struct dentry *, const struct inode *,
+			struct qstr *);
 	int (*d_compare)(const struct dentry *,
 			const struct dentry *, const struct inode *,
 			unsigned int, const char *, const struct qstr *);
@@ -858,7 +859,10 @@ struct dentry_operations {
 
   d_hash: called when the VFS adds a dentry to the hash table. The first
 	dentry passed to d_hash is the parent directory that the name is
- 	to be hashed into.
+ 	to be hashed into. The inode is the dentry's inode.
+
+	Same locking and synchronisation rules as d_compare regarding
+	what is safe to dereference etc.
 
   d_compare: called to compare a dentry name with a given name. The first
 	dentry is the parent of the dentry to be compared, the second is
diff --git a/fs/adfs/dir.c b/fs/adfs/dir.c
index 4ed74ef..a098bba 100644
--- a/fs/adfs/dir.c
+++ b/fs/adfs/dir.c
@@ -201,7 +201,8 @@ const struct file_operations adfs_dir_operations = {
 };
 
 static int
-adfs_hash(struct dentry *parent, struct qstr *qstr)
+adfs_hash(const struct dentry *parent, const struct inode *inode,
+		struct qstr *qstr)
 {
 	const unsigned int name_len = ADFS_SB(parent->d_sb)->s_namelen;
 	const unsigned char *name;
diff --git a/fs/affs/namei.c b/fs/affs/namei.c
index a86e877..91d5dcd 100644
--- a/fs/affs/namei.c
+++ b/fs/affs/namei.c
@@ -13,12 +13,14 @@
 typedef int (*toupper_t)(int);
 
 static int	 affs_toupper(int ch);
-static int	 affs_hash_dentry(struct dentry *, struct qstr *);
+static int	 affs_hash_dentry(const struct dentry *,
+		const struct inode *, struct qstr *);
 static int       affs_compare_dentry(const struct dentry *parent,
 		const struct dentry *dentry, const struct inode *inode,
 		unsigned int len, const char *str, const struct qstr *name);
 static int	 affs_intl_toupper(int ch);
-static int	 affs_intl_hash_dentry(struct dentry *, struct qstr *);
+static int	 affs_intl_hash_dentry(const struct dentry *,
+		const struct inode *, struct qstr *);
 static int       affs_intl_compare_dentry(const struct dentry *parent,
 		const struct dentry *dentry, const struct inode *inode,
 		unsigned int len, const char *str, const struct qstr *name);
@@ -62,13 +64,13 @@ affs_get_toupper(struct super_block *sb)
  * Note: the dentry argument is the parent dentry.
  */
 static inline int
-__affs_hash_dentry(struct dentry *dentry, struct qstr *qstr, toupper_t toupper)
+__affs_hash_dentry(struct qstr *qstr, toupper_t toupper)
 {
 	const u8 *name = qstr->name;
 	unsigned long hash;
 	int i;
 
-	i = affs_check_name(qstr->name,qstr->len);
+	i = affs_check_name(qstr->name, qstr->len);
 	if (i)
 		return i;
 
@@ -82,14 +84,16 @@ __affs_hash_dentry(struct dentry *dentry, struct qstr *qstr, toupper_t toupper)
 }
 
 static int
-affs_hash_dentry(struct dentry *dentry, struct qstr *qstr)
+affs_hash_dentry(const struct dentry *dentry, const struct inode *inode,
+		struct qstr *qstr)
 {
-	return __affs_hash_dentry(dentry, qstr, affs_toupper);
+	return __affs_hash_dentry(qstr, affs_toupper);
 }
 static int
-affs_intl_hash_dentry(struct dentry *dentry, struct qstr *qstr)
+affs_intl_hash_dentry(const struct dentry *dentry, const struct inode *inode,
+		struct qstr *qstr)
 {
-	return __affs_hash_dentry(dentry, qstr, affs_intl_toupper);
+	return __affs_hash_dentry(qstr, affs_intl_toupper);
 }
 
 static inline int __affs_compare_dentry(unsigned int len,
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index f3351f1..5227626 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -700,9 +700,10 @@ const struct dentry_operations cifs_dentry_ops = {
 /* d_delete:       cifs_d_delete,      */ /* not needed except for debugging */
 };
 
-static int cifs_ci_hash(struct dentry *dentry, struct qstr *q)
+static int cifs_ci_hash(const struct dentry *dentry, const struct inode *inode,
+		struct qstr *q)
 {
-	struct nls_table *codepage = CIFS_SB(dentry->d_inode->i_sb)->local_nls;
+	struct nls_table *codepage = CIFS_SB(dentry->d_sb)->local_nls;
 	unsigned long hash;
 	int i;
 
diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index ef7bb7b..ec5b2af 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -79,7 +79,7 @@ cifs_readdir_lookup(struct dentry *parent, struct qstr *name,
 	cFYI(1, "For %s", name->name);
 
 	if (parent->d_op && parent->d_op->d_hash)
-		parent->d_op->d_hash(parent, name);
+		parent->d_op->d_hash(parent, parent->d_inode, name);
 	else
 		name->hash = full_name_hash(name->name, name->len);
 
diff --git a/fs/dcache.c b/fs/dcache.c
index a7362de..9fd5180 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1474,7 +1474,7 @@ struct dentry *d_hash_and_lookup(struct dentry *dir, struct qstr *name)
 	 */
 	name->hash = full_name_hash(name->name, name->len);
 	if (dir->d_op && dir->d_op->d_hash) {
-		if (dir->d_op->d_hash(dir, name) < 0)
+		if (dir->d_op->d_hash(dir, dir->d_inode, name) < 0)
 			goto out;
 	}
 	dentry = d_lookup(dir, name);
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 9d1a22d..a1ed7a7 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -454,7 +454,7 @@ static struct dentry *ecryptfs_lookup(struct inode *ecryptfs_dir_inode,
 	lower_name.hash = ecryptfs_dentry->d_name.hash;
 	if (lower_dir_dentry->d_op && lower_dir_dentry->d_op->d_hash) {
 		rc = lower_dir_dentry->d_op->d_hash(lower_dir_dentry,
-						    &lower_name);
+				lower_dir_dentry->d_inode, &lower_name);
 		if (rc < 0)
 			goto out_d_drop;
 	}
@@ -489,7 +489,7 @@ static struct dentry *ecryptfs_lookup(struct inode *ecryptfs_dir_inode,
 	lower_name.hash = full_name_hash(lower_name.name, lower_name.len);
 	if (lower_dir_dentry->d_op && lower_dir_dentry->d_op->d_hash) {
 		rc = lower_dir_dentry->d_op->d_hash(lower_dir_dentry,
-						    &lower_name);
+				lower_dir_dentry->d_inode, &lower_name);
 		if (rc < 0)
 			goto out_d_drop;
 	}
diff --git a/fs/fat/namei_msdos.c b/fs/fat/namei_msdos.c
index 37e915c..c5f32db 100644
--- a/fs/fat/namei_msdos.c
+++ b/fs/fat/namei_msdos.c
@@ -148,7 +148,8 @@ static int msdos_find(struct inode *dir, const unsigned char *name, int len,
  * that the existing dentry can be used. The msdos fs routines will
  * return ENOENT or EINVAL as appropriate.
  */
-static int msdos_hash(struct dentry *dentry, struct qstr *qstr)
+static int msdos_hash(const struct dentry *dentry, const struct inode *inode,
+	       struct qstr *qstr)
 {
 	struct fat_mount_options *options = &MSDOS_SB(dentry->d_sb)->options;
 	unsigned char msdos_name[MSDOS_NAME];
diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index 4540e76..6e4d02d 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -103,7 +103,8 @@ static unsigned int vfat_striptail_len(const struct qstr *qstr)
  * that the existing dentry can be used. The vfat fs routines will
  * return ENOENT or EINVAL as appropriate.
  */
-static int vfat_hash(struct dentry *dentry, struct qstr *qstr)
+static int vfat_hash(const struct dentry *dentry, const struct inode *inode,
+		struct qstr *qstr)
 {
 	qstr->hash = full_name_hash(qstr->name, vfat_striptail_len(qstr));
 	return 0;
@@ -115,9 +116,10 @@ static int vfat_hash(struct dentry *dentry, struct qstr *qstr)
  * that the existing dentry can be used. The vfat fs routines will
  * return ENOENT or EINVAL as appropriate.
  */
-static int vfat_hashi(struct dentry *dentry, struct qstr *qstr)
+static int vfat_hashi(const struct dentry *dentry, const struct inode *inode,
+		struct qstr *qstr)
 {
-	struct nls_table *t = MSDOS_SB(dentry->d_inode->i_sb)->nls_io;
+	struct nls_table *t = MSDOS_SB(dentry->d_sb)->nls_io;
 	const unsigned char *name;
 	unsigned int len;
 	unsigned long hash;
diff --git a/fs/gfs2/dentry.c b/fs/gfs2/dentry.c
index e80fea2..50497f6 100644
--- a/fs/gfs2/dentry.c
+++ b/fs/gfs2/dentry.c
@@ -100,7 +100,8 @@ fail:
 	return 0;
 }
 
-static int gfs2_dhash(struct dentry *dentry, struct qstr *str)
+static int gfs2_dhash(const struct dentry *dentry, const struct inode *inode,
+		struct qstr *str)
 {
 	str->hash = gfs2_disk_hash(str->name, str->len);
 	return 0;
diff --git a/fs/hfs/hfs_fs.h b/fs/hfs/hfs_fs.h
index 3a815fd..345717a 100644
--- a/fs/hfs/hfs_fs.h
+++ b/fs/hfs/hfs_fs.h
@@ -213,7 +213,8 @@ extern int hfs_part_find(struct super_block *, sector_t *, sector_t *);
 /* string.c */
 extern const struct dentry_operations hfs_dentry_operations;
 
-extern int hfs_hash_dentry(struct dentry *, struct qstr *);
+extern int hfs_hash_dentry(const struct dentry *, const struct inode *,
+		struct qstr *);
 extern int hfs_strcmp(const unsigned char *, unsigned int,
 		      const unsigned char *, unsigned int);
 extern int hfs_compare_dentry(const struct dentry *parent,
diff --git a/fs/hfs/string.c b/fs/hfs/string.c
index 712aa53..d270f56 100644
--- a/fs/hfs/string.c
+++ b/fs/hfs/string.c
@@ -51,7 +51,8 @@ static unsigned char caseorder[256] = {
 /*
  * Hash a string to an integer in a case-independent way
  */
-int hfs_hash_dentry(struct dentry *dentry, struct qstr *this)
+int hfs_hash_dentry(const struct dentry *dentry, const struct inode *inode,
+		struct qstr *this)
 {
 	const unsigned char *name = this->name;
 	unsigned int hash, len = this->len;
diff --git a/fs/hfsplus/hfsplus_fs.h b/fs/hfsplus/hfsplus_fs.h
index 7a98f24..b9100a6 100644
--- a/fs/hfsplus/hfsplus_fs.h
+++ b/fs/hfsplus/hfsplus_fs.h
@@ -379,7 +379,8 @@ int hfsplus_strcasecmp(const struct hfsplus_unistr *, const struct hfsplus_unist
 int hfsplus_strcmp(const struct hfsplus_unistr *, const struct hfsplus_unistr *);
 int hfsplus_uni2asc(struct super_block *, const struct hfsplus_unistr *, char *, int *);
 int hfsplus_asc2uni(struct super_block *, struct hfsplus_unistr *, const char *, int);
-int hfsplus_hash_dentry(struct dentry *dentry, struct qstr *str);
+int hfsplus_hash_dentry(const struct dentry *dentry, const struct inode *inode,
+		struct qstr *str);
 int hfsplus_compare_dentry(const struct dentry *parent,
 		const struct dentry *dentry, const struct inode *inode,
 		unsigned int len, const char *str, const struct qstr *name);
diff --git a/fs/hfsplus/unicode.c b/fs/hfsplus/unicode.c
index 6e3be8f..9baf6be 100644
--- a/fs/hfsplus/unicode.c
+++ b/fs/hfsplus/unicode.c
@@ -320,7 +320,8 @@ int hfsplus_asc2uni(struct super_block *sb, struct hfsplus_unistr *ustr,
  * Composed unicode characters are decomposed and case-folding is performed
  * if the appropriate bits are (un)set on the superblock.
  */
-int hfsplus_hash_dentry(struct dentry *dentry, struct qstr *str)
+int hfsplus_hash_dentry(const struct dentry *dentry, const struct inode *inode,
+		struct qstr *str)
 {
 	struct super_block *sb = dentry->d_sb;
 	const char *astr;
diff --git a/fs/hpfs/dentry.c b/fs/hpfs/dentry.c
index 3175ccc..d7f1cbb 100644
--- a/fs/hpfs/dentry.c
+++ b/fs/hpfs/dentry.c
@@ -12,7 +12,8 @@
  * Note: the dentry argument is the parent dentry.
  */
 
-static int hpfs_hash_dentry(struct dentry *dentry, struct qstr *qstr)
+static int hpfs_hash_dentry(const struct dentry *dentry, const struct inode *inode,
+		struct qstr *qstr)
 {
 	unsigned long	 hash;
 	int		 i;
diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
index 9a7a6df..bc77744 100644
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -26,8 +26,10 @@
 
 #define BEQUIET
 
-static int isofs_hashi(struct dentry *parent, struct qstr *qstr);
-static int isofs_hash(struct dentry *parent, struct qstr *qstr);
+static int isofs_hashi(const struct dentry *parent, const struct inode *inode,
+		struct qstr *qstr);
+static int isofs_hash(const struct dentry *parent, const struct inode *inode,
+		struct qstr *qstr);
 static int isofs_dentry_cmpi(const struct dentry *parent,
 		const struct dentry *dentry, const struct inode *inode,
 		unsigned int len, const char *str, const struct qstr *name);
@@ -36,8 +38,10 @@ static int isofs_dentry_cmp(const struct dentry *parent,
 		unsigned int len, const char *str, const struct qstr *name);
 
 #ifdef CONFIG_JOLIET
-static int isofs_hashi_ms(struct dentry *parent, struct qstr *qstr);
-static int isofs_hash_ms(struct dentry *parent, struct qstr *qstr);
+static int isofs_hashi_ms(const struct dentry *parent, const struct inode *inode,
+		struct qstr *qstr);
+static int isofs_hash_ms(const struct dentry *parent, const struct inode *inode,
+		struct qstr *qstr);
 static int isofs_dentry_cmpi_ms(const struct dentry *parent,
 		const struct dentry *dentry, const struct inode *inode,
 		unsigned int len, const char *str, const struct qstr *name);
@@ -168,7 +172,7 @@ struct iso9660_options{
  * Compute the hash for the isofs name corresponding to the dentry.
  */
 static int
-isofs_hash_common(struct dentry *dentry, struct qstr *qstr, int ms)
+isofs_hash_common(const struct dentry *dentry, struct qstr *qstr, int ms)
 {
 	const char *name;
 	int len;
@@ -189,7 +193,7 @@ isofs_hash_common(struct dentry *dentry, struct qstr *qstr, int ms)
  * Compute the hash for the isofs name corresponding to the dentry.
  */
 static int
-isofs_hashi_common(struct dentry *dentry, struct qstr *qstr, int ms)
+isofs_hashi_common(const struct dentry *dentry, struct qstr *qstr, int ms)
 {
 	const char *name;
 	int len;
@@ -244,13 +248,15 @@ static int isofs_dentry_cmp_common(
 }
 
 static int
-isofs_hash(struct dentry *dentry, struct qstr *qstr)
+isofs_hash(const struct dentry *dentry, const struct inode *inode,
+		struct qstr *qstr)
 {
 	return isofs_hash_common(dentry, qstr, 0);
 }
 
 static int
-isofs_hashi(struct dentry *dentry, struct qstr *qstr)
+isofs_hashi(const struct dentry *dentry, const struct inode *inode,
+		struct qstr *qstr)
 {
 	return isofs_hashi_common(dentry, qstr, 0);
 }
@@ -273,13 +279,15 @@ isofs_dentry_cmpi(const struct dentry *parent,
 
 #ifdef CONFIG_JOLIET
 static int
-isofs_hash_ms(struct dentry *dentry, struct qstr *qstr)
+isofs_hash_ms(const struct dentry *dentry, const struct inode *inode,
+		struct qstr *qstr)
 {
 	return isofs_hash_common(dentry, qstr, 1);
 }
 
 static int
-isofs_hashi_ms(struct dentry *dentry, struct qstr *qstr)
+isofs_hashi_ms(const struct dentry *dentry, const struct inode *inode,
+		struct qstr *qstr)
 {
 	return isofs_hashi_common(dentry, qstr, 1);
 }
diff --git a/fs/jfs/namei.c b/fs/jfs/namei.c
index 5571d0b..7166a1b 100644
--- a/fs/jfs/namei.c
+++ b/fs/jfs/namei.c
@@ -1574,7 +1574,8 @@ const struct file_operations jfs_dir_operations = {
 	.llseek		= generic_file_llseek,
 };
 
-static int jfs_ci_hash(struct dentry *dir, struct qstr *this)
+static int jfs_ci_hash(const struct dentry *dir, const struct inode *inode,
+		struct qstr *this)
 {
 	unsigned long hash;
 	int i;
diff --git a/fs/namei.c b/fs/namei.c
index 5362af9..bf6821a 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -731,7 +731,8 @@ static int do_lookup(struct nameidata *nd, struct qstr *name,
 	 * to use its own hash..
 	 */
 	if (nd->path.dentry->d_op && nd->path.dentry->d_op->d_hash) {
-		int err = nd->path.dentry->d_op->d_hash(nd->path.dentry, name);
+		int err = nd->path.dentry->d_op->d_hash(nd->path.dentry,
+				nd->path.dentry->d_inode, name);
 		if (err < 0)
 			return err;
 	}
@@ -1134,7 +1135,7 @@ static struct dentry *__lookup_hash(struct qstr *name,
 	 * to use its own hash..
 	 */
 	if (base->d_op && base->d_op->d_hash) {
-		err = base->d_op->d_hash(base, name);
+		err = base->d_op->d_hash(base, inode, name);
 		dentry = ERR_PTR(err);
 		if (err < 0)
 			goto out;
diff --git a/fs/ncpfs/dir.c b/fs/ncpfs/dir.c
index c99a5dd..ecb25c6 100644
--- a/fs/ncpfs/dir.c
+++ b/fs/ncpfs/dir.c
@@ -74,7 +74,8 @@ const struct inode_operations ncp_dir_inode_operations =
  * Dentry operations routines
  */
 static int ncp_lookup_validate(struct dentry *, struct nameidata *);
-static int ncp_hash_dentry(struct dentry *, struct qstr *);
+static int ncp_hash_dentry(const struct dentry *, const struct inode *,
+		struct qstr *);
 static int ncp_compare_dentry(const struct dentry *,
 		const struct dentry *, const struct inode *,
 		unsigned int, const char *, const struct qstr *);
@@ -129,10 +130,9 @@ static inline int ncp_case_sensitive(const struct inode *inode)
  * is case-sensitive.
  */
 static int 
-ncp_hash_dentry(struct dentry *dentry, struct qstr *this)
+ncp_hash_dentry(const struct dentry *dentry, const struct inode *inode,
+		struct qstr *this)
 {
-	struct inode *inode = dentry->d_inode;
-
 	if (!ncp_case_sensitive(inode)) {
 		struct super_block *sb = dentry->d_sb;
 		struct nls_table *t;
@@ -601,7 +601,7 @@ ncp_fill_cache(struct file *filp, void *dirent, filldir_t filldir,
 	qname.hash = full_name_hash(qname.name, qname.len);
 
 	if (dentry->d_op && dentry->d_op->d_hash)
-		if (dentry->d_op->d_hash(dentry, &qname) != 0)
+		if (dentry->d_op->d_hash(dentry, dentry->d_inode, &qname) != 0)
 			goto end_advance;
 
 	newdent = d_lookup(dentry, &qname);
diff --git a/fs/sysv/namei.c b/fs/sysv/namei.c
index 11e7f7d..7507aeb 100644
--- a/fs/sysv/namei.c
+++ b/fs/sysv/namei.c
@@ -27,7 +27,8 @@ static int add_nondir(struct dentry *dentry, struct inode *inode)
 	return err;
 }
 
-static int sysv_hash(struct dentry *dentry, struct qstr *qstr)
+static int sysv_hash(const struct dentry *dentry, const struct inode *inode,
+		struct qstr *qstr)
 {
 	/* Truncate the name in place, avoids having to define a compare
 	   function. */
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index ba1b9bd..4ef2af7 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -133,7 +133,8 @@ enum dentry_d_lock_class
 
 struct dentry_operations {
 	int (*d_revalidate)(struct dentry *, struct nameidata *);
-	int (*d_hash)(struct dentry *, struct qstr *);
+	int (*d_hash)(const struct dentry *, const struct inode *,
+			struct qstr *);
 	int (*d_compare)(const struct dentry *,
 			const struct dentry *, const struct inode *,
 			unsigned int, const char *, const struct qstr *);
-- 
1.7.1

