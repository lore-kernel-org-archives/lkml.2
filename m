Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717Ab0KIND0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 08:03:26 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:54835 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751436Ab0KINDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 08:03:22 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAHDU2Ex5LcZK/2dsb2JhbACiH3K/QYVKBIUQilQ
Date: Wed, 10 Nov 2010 00:03:16 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 6/6] fs: d_hash change for rcu-walk
Message-ID: <20101109130316.GG11477@amd>
References: <20101109124610.GB11477@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101109124610.GB11477@amd>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change d_hash so it may be called from lock-free RCU lookups.

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

Index: linux-2.6/fs/adfs/dir.c
===================================================================
--- linux-2.6.orig/fs/adfs/dir.c	2010-11-09 23:22:35.000000000 +1100
+++ linux-2.6/fs/adfs/dir.c	2010-11-09 23:22:37.000000000 +1100
@@ -201,7 +201,8 @@ const struct file_operations adfs_dir_op
 };
 
 static int
-adfs_hash(struct dentry *parent, struct qstr *qstr)
+adfs_hash(const struct dentry *parent, const struct inode *inode,
+		struct qstr *qstr)
 {
 	const unsigned int name_len = ADFS_SB(parent->d_sb)->s_namelen;
 	const unsigned char *name;
Index: linux-2.6/fs/affs/namei.c
===================================================================
--- linux-2.6.orig/fs/affs/namei.c	2010-11-09 23:22:35.000000000 +1100
+++ linux-2.6/fs/affs/namei.c	2010-11-09 23:22:37.000000000 +1100
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
 
@@ -82,14 +84,16 @@ __affs_hash_dentry(struct dentry *dentry
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
Index: linux-2.6/fs/cifs/dir.c
===================================================================
--- linux-2.6.orig/fs/cifs/dir.c	2010-11-09 23:22:35.000000000 +1100
+++ linux-2.6/fs/cifs/dir.c	2010-11-09 23:22:37.000000000 +1100
@@ -700,9 +700,10 @@ const struct dentry_operations cifs_dent
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
 
Index: linux-2.6/fs/fat/namei_msdos.c
===================================================================
--- linux-2.6.orig/fs/fat/namei_msdos.c	2010-11-09 23:22:35.000000000 +1100
+++ linux-2.6/fs/fat/namei_msdos.c	2010-11-09 23:22:37.000000000 +1100
@@ -148,7 +148,8 @@ static int msdos_find(struct inode *dir,
  * that the existing dentry can be used. The msdos fs routines will
  * return ENOENT or EINVAL as appropriate.
  */
-static int msdos_hash(struct dentry *dentry, struct qstr *qstr)
+static int msdos_hash(const struct dentry *dentry, const struct inode *inode,
+	       struct qstr *qstr)
 {
 	struct fat_mount_options *options = &MSDOS_SB(dentry->d_sb)->options;
 	unsigned char msdos_name[MSDOS_NAME];
Index: linux-2.6/fs/fat/namei_vfat.c
===================================================================
--- linux-2.6.orig/fs/fat/namei_vfat.c	2010-11-09 23:22:35.000000000 +1100
+++ linux-2.6/fs/fat/namei_vfat.c	2010-11-09 23:22:37.000000000 +1100
@@ -103,7 +103,8 @@ static unsigned int vfat_striptail_len(c
  * that the existing dentry can be used. The vfat fs routines will
  * return ENOENT or EINVAL as appropriate.
  */
-static int vfat_hash(struct dentry *dentry, struct qstr *qstr)
+static int vfat_hash(const struct dentry *dentry, const struct inode *inode,
+		struct qstr *qstr)
 {
 	qstr->hash = full_name_hash(qstr->name, vfat_striptail_len(qstr));
 	return 0;
@@ -115,9 +116,10 @@ static int vfat_hash(struct dentry *dent
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
Index: linux-2.6/fs/gfs2/dentry.c
===================================================================
--- linux-2.6.orig/fs/gfs2/dentry.c	2010-11-09 23:22:35.000000000 +1100
+++ linux-2.6/fs/gfs2/dentry.c	2010-11-09 23:22:37.000000000 +1100
@@ -100,7 +100,8 @@ static int gfs2_drevalidate(struct dentr
 	return 0;
 }
 
-static int gfs2_dhash(struct dentry *dentry, struct qstr *str)
+static int gfs2_dhash(const struct dentry *dentry, const struct inode *inode,
+		struct qstr *str)
 {
 	str->hash = gfs2_disk_hash(str->name, str->len);
 	return 0;
Index: linux-2.6/fs/hfs/hfs_fs.h
===================================================================
--- linux-2.6.orig/fs/hfs/hfs_fs.h	2010-11-09 23:22:35.000000000 +1100
+++ linux-2.6/fs/hfs/hfs_fs.h	2010-11-09 23:22:37.000000000 +1100
@@ -213,7 +213,8 @@ extern int hfs_part_find(struct super_bl
 /* string.c */
 extern const struct dentry_operations hfs_dentry_operations;
 
-extern int hfs_hash_dentry(struct dentry *, struct qstr *);
+extern int hfs_hash_dentry(const struct dentry *, const struct inode *,
+		struct qstr *);
 extern int hfs_strcmp(const unsigned char *, unsigned int,
 		      const unsigned char *, unsigned int);
 extern int hfs_compare_dentry(const struct dentry *parent,
Index: linux-2.6/fs/hfs/string.c
===================================================================
--- linux-2.6.orig/fs/hfs/string.c	2010-11-09 23:22:35.000000000 +1100
+++ linux-2.6/fs/hfs/string.c	2010-11-09 23:22:37.000000000 +1100
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
Index: linux-2.6/fs/hfsplus/hfsplus_fs.h
===================================================================
--- linux-2.6.orig/fs/hfsplus/hfsplus_fs.h	2010-11-09 23:22:35.000000000 +1100
+++ linux-2.6/fs/hfsplus/hfsplus_fs.h	2010-11-09 23:22:37.000000000 +1100
@@ -379,7 +379,8 @@ int hfsplus_strcasecmp(const struct hfsp
 int hfsplus_strcmp(const struct hfsplus_unistr *, const struct hfsplus_unistr *);
 int hfsplus_uni2asc(struct super_block *, const struct hfsplus_unistr *, char *, int *);
 int hfsplus_asc2uni(struct super_block *, struct hfsplus_unistr *, const char *, int);
-int hfsplus_hash_dentry(struct dentry *dentry, struct qstr *str);
+int hfsplus_hash_dentry(const struct dentry *dentry, const struct inode *inode,
+		struct qstr *str);
 int hfsplus_compare_dentry(const struct dentry *parent,
 		const struct dentry *dentry, const struct inode *inode,
 		unsigned int len, const char *str, const struct qstr *name);
Index: linux-2.6/fs/hfsplus/unicode.c
===================================================================
--- linux-2.6.orig/fs/hfsplus/unicode.c	2010-11-09 23:22:35.000000000 +1100
+++ linux-2.6/fs/hfsplus/unicode.c	2010-11-09 23:22:37.000000000 +1100
@@ -320,7 +320,8 @@ int hfsplus_asc2uni(struct super_block *
  * Composed unicode characters are decomposed and case-folding is performed
  * if the appropriate bits are (un)set on the superblock.
  */
-int hfsplus_hash_dentry(struct dentry *dentry, struct qstr *str)
+int hfsplus_hash_dentry(const struct dentry *dentry, const struct inode *inode,
+		struct qstr *str)
 {
 	struct super_block *sb = dentry->d_sb;
 	const char *astr;
Index: linux-2.6/fs/hpfs/dentry.c
===================================================================
--- linux-2.6.orig/fs/hpfs/dentry.c	2010-11-09 23:22:35.000000000 +1100
+++ linux-2.6/fs/hpfs/dentry.c	2010-11-09 23:22:37.000000000 +1100
@@ -12,7 +12,8 @@
  * Note: the dentry argument is the parent dentry.
  */
 
-static int hpfs_hash_dentry(struct dentry *dentry, struct qstr *qstr)
+static int hpfs_hash_dentry(const struct dentry *dentry, const struct inode *inode,
+		struct qstr *qstr)
 {
 	unsigned long	 hash;
 	int		 i;
Index: linux-2.6/fs/isofs/inode.c
===================================================================
--- linux-2.6.orig/fs/isofs/inode.c	2010-11-09 23:22:35.000000000 +1100
+++ linux-2.6/fs/isofs/inode.c	2010-11-09 23:22:37.000000000 +1100
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
@@ -36,8 +38,10 @@ static int isofs_dentry_cmp(const struct
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
@@ -175,7 +179,7 @@ struct iso9660_options{
  * Compute the hash for the isofs name corresponding to the dentry.
  */
 static int
-isofs_hash_common(struct dentry *dentry, struct qstr *qstr, int ms)
+isofs_hash_common(const struct dentry *dentry, struct qstr *qstr, int ms)
 {
 	const char *name;
 	int len;
@@ -196,7 +200,7 @@ isofs_hash_common(struct dentry *dentry,
  * Compute the hash for the isofs name corresponding to the dentry.
  */
 static int
-isofs_hashi_common(struct dentry *dentry, struct qstr *qstr, int ms)
+isofs_hashi_common(const struct dentry *dentry, struct qstr *qstr, int ms)
 {
 	const char *name;
 	int len;
@@ -251,13 +255,15 @@ static int isofs_dentry_cmp_common(
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
@@ -280,13 +286,15 @@ isofs_dentry_cmpi(const struct dentry *p
 
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
Index: linux-2.6/fs/jfs/namei.c
===================================================================
--- linux-2.6.orig/fs/jfs/namei.c	2010-11-09 23:22:35.000000000 +1100
+++ linux-2.6/fs/jfs/namei.c	2010-11-09 23:22:37.000000000 +1100
@@ -1574,7 +1574,8 @@ const struct file_operations jfs_dir_ope
 	.llseek		= generic_file_llseek,
 };
 
-static int jfs_ci_hash(struct dentry *dir, struct qstr *this)
+static int jfs_ci_hash(const struct dentry *dir, const struct inode *inode,
+		struct qstr *this)
 {
 	unsigned long hash;
 	int i;
Index: linux-2.6/fs/ncpfs/dir.c
===================================================================
--- linux-2.6.orig/fs/ncpfs/dir.c	2010-11-09 23:22:35.000000000 +1100
+++ linux-2.6/fs/ncpfs/dir.c	2010-11-09 23:22:37.000000000 +1100
@@ -75,7 +75,8 @@ const struct inode_operations ncp_dir_in
  * Dentry operations routines
  */
 static int ncp_lookup_validate(struct dentry *, struct nameidata *);
-static int ncp_hash_dentry(struct dentry *, struct qstr *);
+static int ncp_hash_dentry(const struct dentry *, const struct inode *,
+		struct qstr *);
 static int ncp_compare_dentry(const struct dentry *,
 		const struct dentry *, const struct inode *,
 		unsigned int, const char *, const struct qstr *);
@@ -130,10 +131,9 @@ static inline int ncp_case_sensitive(con
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
@@ -602,7 +602,7 @@ ncp_fill_cache(struct file *filp, void *
 	qname.hash = full_name_hash(qname.name, qname.len);
 
 	if (dentry->d_op && dentry->d_op->d_hash)
-		if (dentry->d_op->d_hash(dentry, &qname) != 0)
+		if (dentry->d_op->d_hash(dentry, dentry->d_inode, &qname) != 0)
 			goto end_advance;
 
 	newdent = d_lookup(dentry, &qname);
Index: linux-2.6/fs/sysv/namei.c
===================================================================
--- linux-2.6.orig/fs/sysv/namei.c	2010-11-09 23:22:35.000000000 +1100
+++ linux-2.6/fs/sysv/namei.c	2010-11-09 23:22:37.000000000 +1100
@@ -27,7 +27,8 @@ static int add_nondir(struct dentry *den
 	return err;
 }
 
-static int sysv_hash(struct dentry *dentry, struct qstr *qstr)
+static int sysv_hash(const struct dentry *dentry, const struct inode *inode,
+		struct qstr *qstr)
 {
 	/* Truncate the name in place, avoids having to define a compare
 	   function. */
Index: linux-2.6/include/linux/dcache.h
===================================================================
--- linux-2.6.orig/include/linux/dcache.h	2010-11-09 23:22:35.000000000 +1100
+++ linux-2.6/include/linux/dcache.h	2010-11-09 23:22:37.000000000 +1100
@@ -133,7 +133,8 @@ enum dentry_d_lock_class
 
 struct dentry_operations {
 	int (*d_revalidate)(struct dentry *, struct nameidata *);
-	int (*d_hash)(struct dentry *, struct qstr *);
+	int (*d_hash)(const struct dentry *, const struct inode *,
+			struct qstr *);
 	int (*d_compare)(const struct dentry *,
 			const struct dentry *, const struct inode *,
 			unsigned int, const char *, const struct qstr *);
Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2010-11-09 23:22:35.000000000 +1100
+++ linux-2.6/fs/namei.c	2010-11-09 23:22:37.000000000 +1100
@@ -731,7 +731,8 @@ static int do_lookup(struct nameidata *n
 	 * to use its own hash..
 	 */
 	if (nd->path.dentry->d_op && nd->path.dentry->d_op->d_hash) {
-		int err = nd->path.dentry->d_op->d_hash(nd->path.dentry, name);
+		int err = nd->path.dentry->d_op->d_hash(nd->path.dentry,
+				nd->path.dentry->d_inode, name);
 		if (err < 0)
 			return err;
 	}
@@ -1134,7 +1135,7 @@ static struct dentry *__lookup_hash(stru
 	 * to use its own hash..
 	 */
 	if (base->d_op && base->d_op->d_hash) {
-		err = base->d_op->d_hash(base, name);
+		err = base->d_op->d_hash(base, inode, name);
 		dentry = ERR_PTR(err);
 		if (err < 0)
 			goto out;
Index: linux-2.6/fs/cifs/readdir.c
===================================================================
--- linux-2.6.orig/fs/cifs/readdir.c	2010-11-09 23:22:35.000000000 +1100
+++ linux-2.6/fs/cifs/readdir.c	2010-11-09 23:22:37.000000000 +1100
@@ -79,7 +79,7 @@ cifs_readdir_lookup(struct dentry *paren
 	cFYI(1, "For %s", name->name);
 
 	if (parent->d_op && parent->d_op->d_hash)
-		parent->d_op->d_hash(parent, name);
+		parent->d_op->d_hash(parent, parent->d_inode, name);
 	else
 		name->hash = full_name_hash(name->name, name->len);
 
Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c	2010-11-09 23:22:35.000000000 +1100
+++ linux-2.6/fs/dcache.c	2010-11-09 23:22:37.000000000 +1100
@@ -1474,7 +1474,7 @@ struct dentry *d_hash_and_lookup(struct
 	 */
 	name->hash = full_name_hash(name->name, name->len);
 	if (dir->d_op && dir->d_op->d_hash) {
-		if (dir->d_op->d_hash(dir, name) < 0)
+		if (dir->d_op->d_hash(dir, dir->d_inode, name) < 0)
 			goto out;
 	}
 	dentry = d_lookup(dir, name);
Index: linux-2.6/fs/ecryptfs/inode.c
===================================================================
--- linux-2.6.orig/fs/ecryptfs/inode.c	2010-11-09 23:22:35.000000000 +1100
+++ linux-2.6/fs/ecryptfs/inode.c	2010-11-09 23:22:37.000000000 +1100
@@ -454,7 +454,7 @@ static struct dentry *ecryptfs_lookup(st
 	lower_name.hash = ecryptfs_dentry->d_name.hash;
 	if (lower_dir_dentry->d_op && lower_dir_dentry->d_op->d_hash) {
 		rc = lower_dir_dentry->d_op->d_hash(lower_dir_dentry,
-						    &lower_name);
+				lower_dir_dentry->d_inode, &lower_name);
 		if (rc < 0)
 			goto out_d_drop;
 	}
@@ -489,7 +489,7 @@ static struct dentry *ecryptfs_lookup(st
 	lower_name.hash = full_name_hash(lower_name.name, lower_name.len);
 	if (lower_dir_dentry->d_op && lower_dir_dentry->d_op->d_hash) {
 		rc = lower_dir_dentry->d_op->d_hash(lower_dir_dentry,
-						    &lower_name);
+				lower_dir_dentry->d_inode, &lower_name);
 		if (rc < 0)
 			goto out_d_drop;
 	}
Index: linux-2.6/Documentation/filesystems/Locking
===================================================================
--- linux-2.6.orig/Documentation/filesystems/Locking	2010-11-09 23:22:35.000000000 +1100
+++ linux-2.6/Documentation/filesystems/Locking	2010-11-09 23:22:37.000000000 +1100
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
@@ -23,7 +24,7 @@ be able to use diff(1).
 	none have BKL
 		dcache_lock	rename_lock	->d_lock	may block
 d_revalidate:	no		no		no		yes
-d_hash		no		no		no		yes
+d_hash		no		no		no		no
 d_compare:	no		yes		no		no 
 d_delete:	yes		no		yes		no
 d_release:	no		no		no		yes
Index: linux-2.6/Documentation/filesystems/vfs.txt
===================================================================
--- linux-2.6.orig/Documentation/filesystems/vfs.txt	2010-11-09 23:22:35.000000000 +1100
+++ linux-2.6/Documentation/filesystems/vfs.txt	2010-11-09 23:22:37.000000000 +1100
@@ -841,7 +841,8 @@ the VFS uses a default. As of kernel 2.6
 
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
Index: linux-2.6/Documentation/filesystems/porting
===================================================================
--- linux-2.6.orig/Documentation/filesystems/porting	2010-11-09 23:22:35.000000000 +1100
+++ linux-2.6/Documentation/filesystems/porting	2010-11-09 23:22:37.000000000 +1100
@@ -344,3 +344,10 @@ or more times (eg. constant, idempotent)
 	.d_compare() calling convention and locking rules are significantly
 changed. Read updated documentation in Documentation/filesystems/vfs.txt (and
 look at examples of other filesystems) for guidance.
+
+---
+[mandatory]
+
+	.d_hash() calling convention and locking rules are significantly
+changed. Read updated documentation in Documentation/filesystems/vfs.txt (and
+look at examples of other filesystems) for guidance.
