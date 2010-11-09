Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615Ab0KINCo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 08:02:44 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:30293 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750910Ab0KINCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 08:02:41 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAHDU2Ex5LcZK/2dsb2JhbACiH3K/QYVKBIUQilQ
Date: Wed, 10 Nov 2010 00:02:35 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 5/6] fs: d_compare change for rcu-walk
Message-ID: <20101109130235.GF11477@amd>
References: <20101109124610.GB11477@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101109124610.GB11477@amd>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change d_compare so it may be called from lock-free RCU lookups. This
does put significant restrictions on what may be done from the callback,
however there don't seem to have been any problems with in-tree fses.
If some strange use case pops up that _really_ cannot cope with the
rcu-walk rules, we can just add new rcu-unaware callbacks, which would
cause name lookup to drop out of rcu-walk mode.

cifs and jfs contain the non-trivial changes, where they no longer
overwrite dentry name in their d_compare(), but rather use the
d_revalidate() method for ensuring case preservation in the presence
of negative dentries, taken from fatfs.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 Documentation/filesystems/Locking |    4 +
 Documentation/filesystems/porting |    7 +++
 Documentation/filesystems/vfs.txt |   25 +++++++++-
 fs/adfs/dir.c                     |    8 ++-
 fs/affs/namei.c                   |   44 +++++++++++--------
 fs/cifs/dir.c                     |   52 ++++++++++++----------
 fs/dcache.c                       |    4 +
 fs/fat/namei_msdos.c              |   15 +++---
 fs/fat/namei_vfat.c               |   39 +++++++++++-----
 fs/hfs/hfs_fs.h                   |    4 +
 fs/hfs/string.c                   |   14 +++---
 fs/hfsplus/hfsplus_fs.h           |    4 +
 fs/hfsplus/unicode.c              |   14 +++---
 fs/hpfs/dentry.c                  |   21 +++++----
 fs/isofs/inode.c                  |   88 ++++++++++++++++++--------------------
 fs/isofs/namei.c                  |    3 -
 fs/jfs/namei.c                    |   53 +++++++++++++++++-----
 fs/ncpfs/dir.c                    |   29 ++++++++----
 fs/ncpfs/ncplib_kernel.h          |    8 +--
 fs/proc/proc_sysctl.c             |   12 ++---
 include/linux/dcache.h            |   12 ++---
 include/linux/ncp_fs.h            |    4 -
 22 files changed, 286 insertions(+), 178 deletions(-)

Index: linux-2.6/fs/adfs/dir.c
===================================================================
--- linux-2.6.orig/fs/adfs/dir.c	2010-11-09 22:10:59.000000000 +1100
+++ linux-2.6/fs/adfs/dir.c	2010-11-09 23:22:50.000000000 +1100
@@ -237,17 +237,19 @@ adfs_hash(struct dentry *parent, struct
  * requirements of the underlying filesystem.
  */
 static int
-adfs_compare(struct dentry *parent, struct qstr *entry, struct qstr *name)
+adfs_compare(const struct dentry *parent,
+		const struct dentry *dentry, const struct inode *inode,
+		unsigned int len, const char *str, const struct qstr *name)
 {
 	int i;
 
-	if (entry->len != name->len)
+	if (len != name->len)
 		return 1;
 
 	for (i = 0; i < name->len; i++) {
 		char a, b;
 
-		a = entry->name[i];
+		a = str[i];
 		b = name->name[i];
 
 		if (a >= 'A' && a <= 'Z')
Index: linux-2.6/fs/cifs/dir.c
===================================================================
--- linux-2.6.orig/fs/cifs/dir.c	2010-11-09 22:10:58.000000000 +1100
+++ linux-2.6/fs/cifs/dir.c	2010-11-09 23:22:49.000000000 +1100
@@ -656,22 +656,34 @@ cifs_lookup(struct inode *parent_dir_ino
 static int
 cifs_d_revalidate(struct dentry *direntry, struct nameidata *nd)
 {
-	int isValid = 1;
-
 	if (direntry->d_inode) {
 		if (cifs_revalidate_dentry(direntry))
 			return 0;
-	} else {
-		cFYI(1, "neg dentry 0x%p name = %s",
-			 direntry, direntry->d_name.name);
-		if (time_after(jiffies, direntry->d_time + HZ) ||
-			!lookupCacheEnabled) {
-			d_drop(direntry);
-			isValid = 0;
-		}
+		else
+			return 1;
+	}
+
+	/*
+	 * This may be nfsd (or something), anyway, we can't see the
+	 * intent of this. So, since this can be for creation, drop it.
+	 */
+	if (!nd)
+		return 0;
+
+	/*
+	 * Drop the negative dentry, in order to make sure to use the
+	 * case sensitive name which is specified by user if this is
+	 * for creation.
+	 */
+	if (!(nd->flags & (LOOKUP_CONTINUE | LOOKUP_PARENT))) {
+		if (nd->flags & (LOOKUP_CREATE | LOOKUP_RENAME_TARGET))
+			return 0;
 	}
 
-	return isValid;
+	if (time_after(jiffies, direntry->d_time + HZ) || !lookupCacheEnabled)
+		return 0;
+
+	return 1;
 }
 
 /* static int cifs_d_delete(struct dentry *direntry)
@@ -703,21 +715,15 @@ static int cifs_ci_hash(struct dentry *d
 	return 0;
 }
 
-static int cifs_ci_compare(struct dentry *dentry, struct qstr *a,
-			   struct qstr *b)
+static int cifs_ci_compare(const struct dentry *parent,
+		const struct dentry *dentry, const struct inode *inode,
+		unsigned int len, const char *str, const struct qstr *name)
 {
-	struct nls_table *codepage = CIFS_SB(dentry->d_inode->i_sb)->local_nls;
+	struct nls_table *codepage = CIFS_SB(inode->i_sb)->local_nls;
 
-	if ((a->len == b->len) &&
-	    (nls_strnicmp(codepage, a->name, b->name, a->len) == 0)) {
-		/*
-		 * To preserve case, don't let an existing negative dentry's
-		 * case take precedence.  If a is not a negative dentry, this
-		 * should have no side effects
-		 */
-		memcpy((void *)a->name, b->name, a->len);
+	if ((name->len == len) &&
+	    (nls_strnicmp(codepage, name->name, str, len) == 0))
 		return 0;
-	}
 	return 1;
 }
 
Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c	2010-11-09 22:11:10.000000000 +1100
+++ linux-2.6/fs/dcache.c	2010-11-09 23:22:49.000000000 +1100
@@ -1433,7 +1433,9 @@ struct dentry * __d_lookup(struct dentry
 		 */
 		qstr = &dentry->d_name;
 		if (parent->d_op && parent->d_op->d_compare) {
-			if (parent->d_op->d_compare(parent, qstr, name))
+			if (parent->d_op->d_compare(parent,
+						dentry, dentry->d_inode,
+						qstr->len, qstr->name, name))
 				goto next;
 		} else {
 			if (qstr->len != len)
Index: linux-2.6/fs/fat/namei_msdos.c
===================================================================
--- linux-2.6.orig/fs/fat/namei_msdos.c	2010-11-09 22:10:58.000000000 +1100
+++ linux-2.6/fs/fat/namei_msdos.c	2010-11-09 23:22:49.000000000 +1100
@@ -164,16 +164,19 @@ static int msdos_hash(struct dentry *den
  * Compare two msdos names. If either of the names are invalid,
  * we fall back to doing the standard name comparison.
  */
-static int msdos_cmp(struct dentry *dentry, struct qstr *a, struct qstr *b)
+static int msdos_cmp(const struct dentry *parent,
+		const struct dentry *dentry, const struct inode *inode,
+		unsigned int len, const char *str,
+		const struct qstr *name)
 {
-	struct fat_mount_options *options = &MSDOS_SB(dentry->d_sb)->options;
+	struct fat_mount_options *options = &MSDOS_SB(parent->d_sb)->options;
 	unsigned char a_msdos_name[MSDOS_NAME], b_msdos_name[MSDOS_NAME];
 	int error;
 
-	error = msdos_format_name(a->name, a->len, a_msdos_name, options);
+	error = msdos_format_name(name->name, name->len, a_msdos_name, options);
 	if (error)
 		goto old_compare;
-	error = msdos_format_name(b->name, b->len, b_msdos_name, options);
+	error = msdos_format_name(str, len, b_msdos_name, options);
 	if (error)
 		goto old_compare;
 	error = memcmp(a_msdos_name, b_msdos_name, MSDOS_NAME);
@@ -182,8 +185,8 @@ static int msdos_cmp(struct dentry *dent
 
 old_compare:
 	error = 1;
-	if (a->len == b->len)
-		error = memcmp(a->name, b->name, a->len);
+	if (name->len == len)
+		error = memcmp(name->name, str, len);
 	goto out;
 }
 
Index: linux-2.6/fs/fat/namei_vfat.c
===================================================================
--- linux-2.6.orig/fs/fat/namei_vfat.c	2010-11-09 22:10:58.000000000 +1100
+++ linux-2.6/fs/fat/namei_vfat.c	2010-11-09 23:22:49.000000000 +1100
@@ -85,15 +85,18 @@ static int vfat_revalidate_ci(struct den
 }
 
 /* returns the length of a struct qstr, ignoring trailing dots */
-static unsigned int vfat_striptail_len(struct qstr *qstr)
+static unsigned int __vfat_striptail_len(unsigned int len, const char *name)
 {
-	unsigned int len = qstr->len;
-
-	while (len && qstr->name[len - 1] == '.')
+	while (len && name[len - 1] == '.')
 		len--;
 	return len;
 }
 
+static unsigned int vfat_striptail_len(const struct qstr *qstr)
+{
+	return __vfat_striptail_len(qstr->len, qstr->name);
+}
+
 /*
  * Compute the hash for the vfat name corresponding to the dentry.
  * Note: if the name is invalid, we leave the hash code unchanged so
@@ -133,16 +136,18 @@ static int vfat_hashi(struct dentry *den
 /*
  * Case insensitive compare of two vfat names.
  */
-static int vfat_cmpi(struct dentry *dentry, struct qstr *a, struct qstr *b)
+static int vfat_cmpi(const struct dentry *parent,
+		const struct dentry *dentry, const struct inode *inode,
+		unsigned int len, const char *str, const struct qstr *name)
 {
-	struct nls_table *t = MSDOS_SB(dentry->d_inode->i_sb)->nls_io;
+	struct nls_table *t = MSDOS_SB(inode->i_sb)->nls_io;
 	unsigned int alen, blen;
 
 	/* A filename cannot end in '.' or we treat it like it has none */
-	alen = vfat_striptail_len(a);
-	blen = vfat_striptail_len(b);
+	alen = vfat_striptail_len(name);
+	blen = __vfat_striptail_len(len, str);
 	if (alen == blen) {
-		if (nls_strnicmp(t, a->name, b->name, alen) == 0)
+		if (nls_strnicmp(t, name->name, str, alen) == 0)
 			return 0;
 	}
 	return 1;
@@ -151,15 +156,17 @@ static int vfat_cmpi(struct dentry *dent
 /*
  * Case sensitive compare of two vfat names.
  */
-static int vfat_cmp(struct dentry *dentry, struct qstr *a, struct qstr *b)
+static int vfat_cmp(const struct dentry *parent,
+		const struct dentry *dentry, const struct inode *inode,
+		unsigned int len, const char *str, const struct qstr *name)
 {
 	unsigned int alen, blen;
 
 	/* A filename cannot end in '.' or we treat it like it has none */
-	alen = vfat_striptail_len(a);
-	blen = vfat_striptail_len(b);
+	alen = vfat_striptail_len(name);
+	blen = __vfat_striptail_len(len, str);
 	if (alen == blen) {
-		if (strncmp(a->name, b->name, alen) == 0)
+		if (strncmp(name->name, str, alen) == 0)
 			return 0;
 	}
 	return 1;
@@ -780,6 +787,12 @@ static int vfat_create(struct inode *dir
 	struct timespec ts;
 	int err;
 
+	/*
+	 * To preserve case, don't let an existing negative dentry's case
+	 * take precedence.
+	 */
+	memcpy((void *)dentry->d_name.name, nd->last.name, dentry->d_name.len);
+
 	lock_super(sb);
 
 	ts = CURRENT_TIME_SEC;
Index: linux-2.6/fs/isofs/inode.c
===================================================================
--- linux-2.6.orig/fs/isofs/inode.c	2010-11-09 22:11:10.000000000 +1100
+++ linux-2.6/fs/isofs/inode.c	2010-11-09 23:22:50.000000000 +1100
@@ -28,14 +28,22 @@
 
 static int isofs_hashi(struct dentry *parent, struct qstr *qstr);
 static int isofs_hash(struct dentry *parent, struct qstr *qstr);
-static int isofs_dentry_cmpi(struct dentry *dentry, struct qstr *a, struct qstr *b);
-static int isofs_dentry_cmp(struct dentry *dentry, struct qstr *a, struct qstr *b);
+static int isofs_dentry_cmpi(const struct dentry *parent,
+		const struct dentry *dentry, const struct inode *inode,
+		unsigned int len, const char *str, const struct qstr *name);
+static int isofs_dentry_cmp(const struct dentry *parent,
+		const struct dentry *dentry, const struct inode *inode,
+		unsigned int len, const char *str, const struct qstr *name);
 
 #ifdef CONFIG_JOLIET
 static int isofs_hashi_ms(struct dentry *parent, struct qstr *qstr);
 static int isofs_hash_ms(struct dentry *parent, struct qstr *qstr);
-static int isofs_dentry_cmpi_ms(struct dentry *dentry, struct qstr *a, struct qstr *b);
-static int isofs_dentry_cmp_ms(struct dentry *dentry, struct qstr *a, struct qstr *b);
+static int isofs_dentry_cmpi_ms(const struct dentry *parent,
+		const struct dentry *dentry, const struct inode *inode,
+		unsigned int len, const char *str, const struct qstr *name);
+static int isofs_dentry_cmp_ms(const struct dentry *parent,
+		const struct dentry *dentry, const struct inode *inode,
+		unsigned int len, const char *str, const struct qstr *name);
 #endif
 
 static void isofs_put_super(struct super_block *sb)
@@ -213,49 +221,31 @@ isofs_hashi_common(struct dentry *dentry
 }
 
 /*
- * Case insensitive compare of two isofs names.
+ * Compare of two isofs names.
  */
-static int isofs_dentry_cmpi_common(struct dentry *dentry, struct qstr *a,
-				struct qstr *b, int ms)
+static int isofs_dentry_cmp_common(
+		unsigned int len, const char *str,
+		const struct qstr *name, int ms, int ci)
 {
 	int alen, blen;
 
 	/* A filename cannot end in '.' or we treat it like it has none */
-	alen = a->len;
-	blen = b->len;
+	alen = name->len;
+	blen = len;
 	if (ms) {
-		while (alen && a->name[alen-1] == '.')
+		while (alen && name->name[alen-1] == '.')
 			alen--;
-		while (blen && b->name[blen-1] == '.')
+		while (blen && str[blen-1] == '.')
 			blen--;
 	}
 	if (alen == blen) {
-		if (strnicmp(a->name, b->name, alen) == 0)
-			return 0;
-	}
-	return 1;
-}
-
-/*
- * Case sensitive compare of two isofs names.
- */
-static int isofs_dentry_cmp_common(struct dentry *dentry, struct qstr *a,
-					struct qstr *b, int ms)
-{
-	int alen, blen;
-
-	/* A filename cannot end in '.' or we treat it like it has none */
-	alen = a->len;
-	blen = b->len;
-	if (ms) {
-		while (alen && a->name[alen-1] == '.')
-			alen--;
-		while (blen && b->name[blen-1] == '.')
-			blen--;
-	}
-	if (alen == blen) {
-		if (strncmp(a->name, b->name, alen) == 0)
-			return 0;
+		if (ci) {
+			if (strnicmp(name->name, str, alen) == 0)
+				return 0;
+		} else {
+			if (strncmp(name->name, str, alen) == 0)
+				return 0;
+		}
 	}
 	return 1;
 }
@@ -273,15 +263,19 @@ isofs_hashi(struct dentry *dentry, struc
 }
 
 static int
-isofs_dentry_cmp(struct dentry *dentry,struct qstr *a,struct qstr *b)
+isofs_dentry_cmp(const struct dentry *parent,
+		const struct dentry *dentry, const struct inode *inode,
+		unsigned int len, const char *str, const struct qstr *name)
 {
-	return isofs_dentry_cmp_common(dentry, a, b, 0);
+	return isofs_dentry_cmp_common(len, str, name, 0, 0);
 }
 
 static int
-isofs_dentry_cmpi(struct dentry *dentry,struct qstr *a,struct qstr *b)
+isofs_dentry_cmpi(const struct dentry *parent,
+		const struct dentry *dentry, const struct inode *inode,
+		unsigned int len, const char *str, const struct qstr *name)
 {
-	return isofs_dentry_cmpi_common(dentry, a, b, 0);
+	return isofs_dentry_cmp_common(len, str, name, 0, 1);
 }
 
 #ifdef CONFIG_JOLIET
@@ -298,15 +292,19 @@ isofs_hashi_ms(struct dentry *dentry, st
 }
 
 static int
-isofs_dentry_cmp_ms(struct dentry *dentry,struct qstr *a,struct qstr *b)
+isofs_dentry_cmp_ms(const struct dentry *parent,
+		const struct dentry *dentry, const struct inode *inode,
+		unsigned int len, const char *str, const struct qstr *name)
 {
-	return isofs_dentry_cmp_common(dentry, a, b, 1);
+	return isofs_dentry_cmp_common(len, str, name, 1, 0);
 }
 
 static int
-isofs_dentry_cmpi_ms(struct dentry *dentry,struct qstr *a,struct qstr *b)
+isofs_dentry_cmpi_ms(const struct dentry *parent,
+		const struct dentry *dentry, const struct inode *inode,
+		unsigned int len, const char *str, const struct qstr *name)
 {
-	return isofs_dentry_cmpi_common(dentry, a, b, 1);
+	return isofs_dentry_cmp_common(len, str, name, 1, 1);
 }
 #endif
 
Index: linux-2.6/fs/proc/proc_sysctl.c
===================================================================
--- linux-2.6.orig/fs/proc/proc_sysctl.c	2010-11-09 22:11:10.000000000 +1100
+++ linux-2.6/fs/proc/proc_sysctl.c	2010-11-09 22:11:10.000000000 +1100
@@ -397,15 +397,15 @@ static int proc_sys_delete(const struct
 	return !!PROC_I(dentry->d_inode)->sysctl->unregistering;
 }
 
-static int proc_sys_compare(struct dentry *dir, struct qstr *qstr,
-			    struct qstr *name)
+static int proc_sys_compare(const struct dentry *parent,
+		const struct dentry *dentry, const struct inode *inode,
+		unsigned int len, const char *str, const struct qstr *name)
 {
-	struct dentry *dentry = container_of(qstr, struct dentry, d_name);
-	if (qstr->len != name->len)
+	if (name->len != len)
 		return 1;
-	if (memcmp(qstr->name, name->name, name->len))
+	if (memcmp(name->name, str, len))
 		return 1;
-	return !sysctl_is_seen(PROC_I(dentry->d_inode)->sysctl);
+	return !sysctl_is_seen(PROC_I(inode)->sysctl);
 }
 
 static const struct dentry_operations proc_sys_dentry_operations = {
Index: linux-2.6/include/linux/dcache.h
===================================================================
--- linux-2.6.orig/include/linux/dcache.h	2010-11-09 22:11:10.000000000 +1100
+++ linux-2.6/include/linux/dcache.h	2010-11-09 23:22:49.000000000 +1100
@@ -134,7 +134,9 @@ enum dentry_d_lock_class
 struct dentry_operations {
 	int (*d_revalidate)(struct dentry *, struct nameidata *);
 	int (*d_hash)(struct dentry *, struct qstr *);
-	int (*d_compare)(struct dentry *, struct qstr *, struct qstr *);
+	int (*d_compare)(const struct dentry *,
+			const struct dentry *, const struct inode *,
+			unsigned int, const char *, const struct qstr *);
 	int (*d_delete)(const struct dentry *);
 	void (*d_release)(struct dentry *);
 	void (*d_iput)(struct dentry *, struct inode *);
@@ -145,12 +147,8 @@ struct dentry_operations {
  * Locking rules for dentry_operations callbacks are to be found in
  * Documentation/filesystems/Locking. Keep it updated!
  *
- * the dentry parameter passed to d_hash and d_compare is the parent
- * directory of the entries to be compared. It is used in case these
- * functions need any directory specific information for determining
- * equivalency classes.  Using the dentry itself might not work, as it
- * might be a negative dentry which has no information associated with
- * it.
+ * FUrther descriptions are found in Documentation/filesystems/vfs.txt.
+ * Keep it updated too!
  */
 
 /* d_flags entries */
Index: linux-2.6/fs/affs/namei.c
===================================================================
--- linux-2.6.orig/fs/affs/namei.c	2010-11-09 22:10:58.000000000 +1100
+++ linux-2.6/fs/affs/namei.c	2010-11-09 23:22:49.000000000 +1100
@@ -14,10 +14,14 @@ typedef int (*toupper_t)(int);
 
 static int	 affs_toupper(int ch);
 static int	 affs_hash_dentry(struct dentry *, struct qstr *);
-static int       affs_compare_dentry(struct dentry *, struct qstr *, struct qstr *);
+static int       affs_compare_dentry(const struct dentry *parent,
+		const struct dentry *dentry, const struct inode *inode,
+		unsigned int len, const char *str, const struct qstr *name);
 static int	 affs_intl_toupper(int ch);
 static int	 affs_intl_hash_dentry(struct dentry *, struct qstr *);
-static int       affs_intl_compare_dentry(struct dentry *, struct qstr *, struct qstr *);
+static int       affs_intl_compare_dentry(const struct dentry *parent,
+		const struct dentry *dentry, const struct inode *inode,
+		unsigned int len, const char *str, const struct qstr *name);
 
 const struct dentry_operations affs_dentry_operations = {
 	.d_hash		= affs_hash_dentry,
@@ -88,29 +92,29 @@ affs_intl_hash_dentry(struct dentry *den
 	return __affs_hash_dentry(dentry, qstr, affs_intl_toupper);
 }
 
-static inline int
-__affs_compare_dentry(struct dentry *dentry, struct qstr *a, struct qstr *b, toupper_t toupper)
+static inline int __affs_compare_dentry(unsigned int len,
+		const char *str, const struct qstr *name, toupper_t toupper)
 {
-	const u8 *aname = a->name;
-	const u8 *bname = b->name;
-	int len;
+	const u8 *aname = str;
+	const u8 *bname = name->name;
 
-	/* 'a' is the qstr of an already existing dentry, so the name
-	 * must be valid. 'b' must be validated first.
+	/*
+	 * 'str' is the name of an already existing dentry, so the name
+	 * must be valid. 'name' must be validated first.
 	 */
 
-	if (affs_check_name(b->name,b->len))
+	if (affs_check_name(name->name, name->len))
 		return 1;
 
-	/* If the names are longer than the allowed 30 chars,
+	/*
+	 * If the names are longer than the allowed 30 chars,
 	 * the excess is ignored, so their length may differ.
 	 */
-	len = a->len;
 	if (len >= 30) {
-		if (b->len < 30)
+		if (name->len < 30)
 			return 1;
 		len = 30;
-	} else if (len != b->len)
+	} else if (len != name->len)
 		return 1;
 
 	for (; len > 0; len--)
@@ -121,14 +125,18 @@ __affs_compare_dentry(struct dentry *den
 }
 
 static int
-affs_compare_dentry(struct dentry *dentry, struct qstr *a, struct qstr *b)
+affs_compare_dentry(const struct dentry *parent,
+		const struct dentry *dentry, const struct inode *inode,
+		unsigned int len, const char *str, const struct qstr *name)
 {
-	return __affs_compare_dentry(dentry, a, b, affs_toupper);
+	return __affs_compare_dentry(len, str, name, affs_toupper);
 }
 static int
-affs_intl_compare_dentry(struct dentry *dentry, struct qstr *a, struct qstr *b)
+affs_intl_compare_dentry(const struct dentry *parent,
+		const struct dentry *dentry, const struct inode *inode,
+		unsigned int len, const char *str, const struct qstr *name)
 {
-	return __affs_compare_dentry(dentry, a, b, affs_intl_toupper);
+	return __affs_compare_dentry(len, str, name, affs_intl_toupper);
 }
 
 /*
Index: linux-2.6/fs/hfs/hfs_fs.h
===================================================================
--- linux-2.6.orig/fs/hfs/hfs_fs.h	2010-11-09 22:10:58.000000000 +1100
+++ linux-2.6/fs/hfs/hfs_fs.h	2010-11-09 23:22:49.000000000 +1100
@@ -216,7 +216,9 @@ extern const struct dentry_operations hf
 extern int hfs_hash_dentry(struct dentry *, struct qstr *);
 extern int hfs_strcmp(const unsigned char *, unsigned int,
 		      const unsigned char *, unsigned int);
-extern int hfs_compare_dentry(struct dentry *, struct qstr *, struct qstr *);
+extern int hfs_compare_dentry(const struct dentry *parent,
+		const struct dentry *dentry, const struct inode *inode,
+		unsigned int len, const char *str, const struct qstr *name);
 
 /* trans.c */
 extern void hfs_asc2mac(struct super_block *, struct hfs_name *, struct qstr *);
Index: linux-2.6/fs/hfs/string.c
===================================================================
--- linux-2.6.orig/fs/hfs/string.c	2010-11-09 22:10:58.000000000 +1100
+++ linux-2.6/fs/hfs/string.c	2010-11-09 23:22:49.000000000 +1100
@@ -92,21 +92,21 @@ int hfs_strcmp(const unsigned char *s1,
  * Test for equality of two strings in the HFS filename character ordering.
  * return 1 on failure and 0 on success
  */
-int hfs_compare_dentry(struct dentry *dentry, struct qstr *s1, struct qstr *s2)
+int hfs_compare_dentry(const struct dentry *parent,
+		const struct dentry *dentry, const struct inode *inode,
+		unsigned int len, const char *str, const struct qstr *name)
 {
 	const unsigned char *n1, *n2;
-	int len;
 
-	len = s1->len;
 	if (len >= HFS_NAMELEN) {
-		if (s2->len < HFS_NAMELEN)
+		if (name->len < HFS_NAMELEN)
 			return 1;
 		len = HFS_NAMELEN;
-	} else if (len != s2->len)
+	} else if (len != name->len)
 		return 1;
 
-	n1 = s1->name;
-	n2 = s2->name;
+	n1 = str;
+	n2 = name->name;
 	while (len--) {
 		if (caseorder[*n1++] != caseorder[*n2++])
 			return 1;
Index: linux-2.6/fs/hfsplus/hfsplus_fs.h
===================================================================
--- linux-2.6.orig/fs/hfsplus/hfsplus_fs.h	2010-11-09 22:10:59.000000000 +1100
+++ linux-2.6/fs/hfsplus/hfsplus_fs.h	2010-11-09 23:22:50.000000000 +1100
@@ -380,7 +380,9 @@ int hfsplus_strcmp(const struct hfsplus_
 int hfsplus_uni2asc(struct super_block *, const struct hfsplus_unistr *, char *, int *);
 int hfsplus_asc2uni(struct super_block *, struct hfsplus_unistr *, const char *, int);
 int hfsplus_hash_dentry(struct dentry *dentry, struct qstr *str);
-int hfsplus_compare_dentry(struct dentry *dentry, struct qstr *s1, struct qstr *s2);
+int hfsplus_compare_dentry(const struct dentry *parent,
+		const struct dentry *dentry, const struct inode *inode,
+		unsigned int len, const char *str, const struct qstr *name);
 
 /* wrapper.c */
 int hfsplus_read_wrapper(struct super_block *);
Index: linux-2.6/fs/hfsplus/unicode.c
===================================================================
--- linux-2.6.orig/fs/hfsplus/unicode.c	2010-11-09 22:10:59.000000000 +1100
+++ linux-2.6/fs/hfsplus/unicode.c	2010-11-09 23:22:50.000000000 +1100
@@ -363,9 +363,11 @@ int hfsplus_hash_dentry(struct dentry *d
  * Composed unicode characters are decomposed and case-folding is performed
  * if the appropriate bits are (un)set on the superblock.
  */
-int hfsplus_compare_dentry(struct dentry *dentry, struct qstr *s1, struct qstr *s2)
+int hfsplus_compare_dentry(const struct dentry *parent,
+		const struct dentry *dentry, const struct inode *inode,
+		unsigned int len, const char *str, const struct qstr *name)
 {
-	struct super_block *sb = dentry->d_sb;
+	struct super_block *sb = parent->d_sb;
 	int casefold, decompose, size;
 	int dsize1, dsize2, len1, len2;
 	const u16 *dstr1, *dstr2;
@@ -375,10 +377,10 @@ int hfsplus_compare_dentry(struct dentry
 
 	casefold = test_bit(HFSPLUS_SB_CASEFOLD, &HFSPLUS_SB(sb)->flags);
 	decompose = !test_bit(HFSPLUS_SB_NODECOMPOSE, &HFSPLUS_SB(sb)->flags);
-	astr1 = s1->name;
-	len1 = s1->len;
-	astr2 = s2->name;
-	len2 = s2->len;
+	astr1 = str;
+	len1 = len;
+	astr2 = name->name;
+	len2 = name->len;
 	dsize1 = dsize2 = 0;
 	dstr1 = dstr2 = NULL;
 
Index: linux-2.6/fs/hpfs/dentry.c
===================================================================
--- linux-2.6.orig/fs/hpfs/dentry.c	2010-11-09 22:10:58.000000000 +1100
+++ linux-2.6/fs/hpfs/dentry.c	2010-11-09 23:22:49.000000000 +1100
@@ -34,19 +34,24 @@ static int hpfs_hash_dentry(struct dentr
 	return 0;
 }
 
-static int hpfs_compare_dentry(struct dentry *dentry, struct qstr *a, struct qstr *b)
+static int hpfs_compare_dentry(const struct dentry *parent,
+		const struct dentry *dentry, const struct inode *inode,
+		unsigned int len, const char *str, const struct qstr *name)
 {
-	unsigned al=a->len;
-	unsigned bl=b->len;
-	hpfs_adjust_length(a->name, &al);
+	unsigned al = len;
+	unsigned bl = name->len;
+
+	hpfs_adjust_length(str, &al);
 	/*hpfs_adjust_length(b->name, &bl);*/
-	/* 'a' is the qstr of an already existing dentry, so the name
-	 * must be valid. 'b' must be validated first.
+
+	/*
+	 * 'str' is the nane of an already existing dentry, so the name
+	 * must be valid. 'name' must be validated first.
 	 */
 
-	if (hpfs_chk_name(b->name, &bl))
+	if (hpfs_chk_name(name->name, &bl))
 		return 1;
-	if (hpfs_compare_names(dentry->d_sb, a->name, al, b->name, bl, 0))
+	if (hpfs_compare_names(parent->d_sb, str, al, name->name, bl, 0))
 		return 1;
 	return 0;
 }
Index: linux-2.6/fs/jfs/namei.c
===================================================================
--- linux-2.6.orig/fs/jfs/namei.c	2010-11-09 22:10:59.000000000 +1100
+++ linux-2.6/fs/jfs/namei.c	2010-11-09 23:22:50.000000000 +1100
@@ -18,6 +18,7 @@
  */
 
 #include <linux/fs.h>
+#include <linux/namei.h>
 #include <linux/ctype.h>
 #include <linux/quotaops.h>
 #include <linux/exportfs.h>
@@ -1586,32 +1587,60 @@ static int jfs_ci_hash(struct dentry *di
 	return 0;
 }
 
-static int jfs_ci_compare(struct dentry *dir, struct qstr *a, struct qstr *b)
+static int jfs_ci_compare(const struct dentry *parent,
+		const struct dentry *dentry, const struct inode *inode,
+		unsigned int len, const char *str, const struct qstr *name)
 {
 	int i, result = 1;
 
-	if (a->len != b->len)
+	if (len != name->len)
 		goto out;
-	for (i=0; i < a->len; i++) {
-		if (tolower(a->name[i]) != tolower(b->name[i]))
+	for (i=0; i < len; i++) {
+		if (tolower(str[i]) != tolower(name->name[i]))
 			goto out;
 	}
 	result = 0;
+out:
+	return result;
+}
 
+static int jfs_ci_revalidate(struct dentry *dentry, struct nameidata *nd)
+{
 	/*
-	 * We want creates to preserve case.  A negative dentry, a, that
-	 * has a different case than b may cause a new entry to be created
-	 * with the wrong case.  Since we can't tell if a comes from a negative
-	 * dentry, we blindly replace it with b.  This should be harmless if
-	 * a is not a negative dentry.
+	 * This is not negative dentry. Always valid.
+	 *
+	 * Note, rename() to existing directory entry will have ->d_inode,
+	 * and will use existing name which isn't specified name by user.
+	 *
+	 * We may be able to drop this positive dentry here. But dropping
+	 * positive dentry isn't good idea. So it's unsupported like
+	 * rename("filename", "FILENAME") for now.
 	 */
-	memcpy((unsigned char *)a->name, b->name, a->len);
-out:
-	return result;
+	if (dentry->d_inode)
+		return 1;
+
+	/*
+	 * This may be nfsd (or something), anyway, we can't see the
+	 * intent of this. So, since this can be for creation, drop it.
+	 */
+	if (!nd)
+		return 0;
+
+	/*
+	 * Drop the negative dentry, in order to make sure to use the
+	 * case sensitive name which is specified by user if this is
+	 * for creation.
+	 */
+	if (!(nd->flags & (LOOKUP_CONTINUE | LOOKUP_PARENT))) {
+		if (nd->flags & (LOOKUP_CREATE | LOOKUP_RENAME_TARGET))
+			return 0;
+	}
+	return 1;
 }
 
 const struct dentry_operations jfs_ci_dentry_operations =
 {
 	.d_hash = jfs_ci_hash,
 	.d_compare = jfs_ci_compare,
+	.d_revalidate = jfs_ci_revalidate,
 };
Index: linux-2.6/fs/ncpfs/dir.c
===================================================================
--- linux-2.6.orig/fs/ncpfs/dir.c	2010-11-09 22:11:10.000000000 +1100
+++ linux-2.6/fs/ncpfs/dir.c	2010-11-09 23:22:49.000000000 +1100
@@ -76,7 +76,9 @@ const struct inode_operations ncp_dir_in
  */
 static int ncp_lookup_validate(struct dentry *, struct nameidata *);
 static int ncp_hash_dentry(struct dentry *, struct qstr *);
-static int ncp_compare_dentry (struct dentry *, struct qstr *, struct qstr *);
+static int ncp_compare_dentry(const struct dentry *,
+		const struct dentry *, const struct inode *,
+		unsigned int, const char *, const struct qstr *);
 static int ncp_delete_dentry(const struct dentry *);
 
 static const struct dentry_operations ncp_dentry_operations =
@@ -114,10 +116,10 @@ static inline int ncp_preserve_entry_cas
 
 #define ncp_preserve_case(i)	(ncp_namespace(i) != NW_NS_DOS)
 
-static inline int ncp_case_sensitive(struct dentry *dentry)
+static inline int ncp_case_sensitive(const struct inode *inode)
 {
 #ifdef CONFIG_NCPFS_NFS_NS
-	return ncp_namespace(dentry->d_inode) == NW_NS_NFS;
+	return ncp_namespace(inode) == NW_NS_NFS;
 #else
 	return 0;
 #endif /* CONFIG_NCPFS_NFS_NS */
@@ -130,12 +132,15 @@ static inline int ncp_case_sensitive(str
 static int 
 ncp_hash_dentry(struct dentry *dentry, struct qstr *this)
 {
-	if (!ncp_case_sensitive(dentry)) {
+	struct inode *inode = dentry->d_inode;
+
+	if (!ncp_case_sensitive(inode)) {
+		struct super_block *sb = dentry->d_sb;
 		struct nls_table *t;
 		unsigned long hash;
 		int i;
 
-		t = NCP_IO_TABLE(dentry);
+		t = NCP_IO_TABLE(sb);
 		hash = init_name_hash();
 		for (i=0; i<this->len ; i++)
 			hash = partial_name_hash(ncp_tolower(t, this->name[i]),
@@ -146,15 +151,19 @@ ncp_hash_dentry(struct dentry *dentry, s
 }
 
 static int
-ncp_compare_dentry(struct dentry *dentry, struct qstr *a, struct qstr *b)
+ncp_compare_dentry(const struct dentry *parent,
+		const struct dentry *dentry, const struct inode *inode,
+		unsigned int len, const char *str, const struct qstr *name)
 {
-	if (a->len != b->len)
+	struct super_block *sb = dentry->d_sb;
+
+	if (len != name->len)
 		return 1;
 
-	if (ncp_case_sensitive(dentry))
-		return strncmp(a->name, b->name, a->len);
+	if (ncp_case_sensitive(inode))
+		return strncmp(str, name->name, len);
 
-	return ncp_strnicmp(NCP_IO_TABLE(dentry), a->name, b->name, a->len);
+	return ncp_strnicmp(NCP_IO_TABLE(sb), str, name->name, len);
 }
 
 /*
Index: linux-2.6/fs/ncpfs/ncplib_kernel.h
===================================================================
--- linux-2.6.orig/fs/ncpfs/ncplib_kernel.h	2010-11-09 22:10:58.000000000 +1100
+++ linux-2.6/fs/ncpfs/ncplib_kernel.h	2010-11-09 22:11:10.000000000 +1100
@@ -135,7 +135,7 @@ int ncp__vol2io(struct ncp_server *, uns
 				const unsigned char *, unsigned int, int);
 
 #define NCP_ESC			':'
-#define NCP_IO_TABLE(dentry)	(NCP_SERVER((dentry)->d_inode)->nls_io)
+#define NCP_IO_TABLE(sb)	(NCP_SBP(sb)->nls_io)
 #define ncp_tolower(t, c)	nls_tolower(t, c)
 #define ncp_toupper(t, c)	nls_toupper(t, c)
 #define ncp_strnicmp(t, s1, s2, len) \
@@ -150,15 +150,15 @@ int ncp__io2vol(unsigned char *, unsigne
 int ncp__vol2io(unsigned char *, unsigned int *,
 				const unsigned char *, unsigned int, int);
 
-#define NCP_IO_TABLE(dentry)	NULL
+#define NCP_IO_TABLE(sb)	NULL
 #define ncp_tolower(t, c)	tolower(c)
 #define ncp_toupper(t, c)	toupper(c)
 #define ncp_io2vol(S,m,i,n,k,U)	ncp__io2vol(m,i,n,k,U)
 #define ncp_vol2io(S,m,i,n,k,U)	ncp__vol2io(m,i,n,k,U)
 
 
-static inline int ncp_strnicmp(struct nls_table *t, const unsigned char *s1,
-		const unsigned char *s2, int len)
+static inline int ncp_strnicmp(const struct nls_table *t,
+		const unsigned char *s1, const unsigned char *s2, int len)
 {
 	while (len--) {
 		if (tolower(*s1++) != tolower(*s2++))
Index: linux-2.6/Documentation/filesystems/vfs.txt
===================================================================
--- linux-2.6.orig/Documentation/filesystems/vfs.txt	2010-11-09 22:11:10.000000000 +1100
+++ linux-2.6/Documentation/filesystems/vfs.txt	2010-11-09 23:22:49.000000000 +1100
@@ -842,7 +842,9 @@ the VFS uses a default. As of kernel 2.6
 struct dentry_operations {
 	int (*d_revalidate)(struct dentry *, struct nameidata *);
 	int (*d_hash)(struct dentry *, struct qstr *);
-	int (*d_compare)(struct dentry *, struct qstr *, struct qstr *);
+	int (*d_compare)(const struct dentry *,
+			const struct dentry *, const struct inode *,
+			unsigned int, const char *, const struct qstr *);
 	int (*d_delete)(const struct dentry *);
 	void (*d_release)(struct dentry *);
 	void (*d_iput)(struct dentry *, struct inode *);
@@ -854,9 +856,26 @@ struct dentry_operations {
 	dcache. Most filesystems leave this as NULL, because all their
 	dentries in the dcache are valid
 
-  d_hash: called when the VFS adds a dentry to the hash table
+  d_hash: called when the VFS adds a dentry to the hash table. The first
+	dentry passed to d_hash is the parent directory that the name is
+ 	to be hashed into.
 
-  d_compare: called when a dentry should be compared with another
+  d_compare: called to compare a dentry name with a given name. The first
+	dentry is the parent of the dentry to be compared, the second is
+	the dentry itself. inode, len, and name string are properties of
+	the dentry to be compared. qstr is the name to compare it with.
+
+	Must be constant and idempotent, and should not take locks if
+	possible, and should not or store into the dentry or inodes.
+	Should not dereference pointers outside the dentry or inodes without
+	lots of care (eg.  d_parent, d_inode shouldn't be used).
+
+	However, our vfsmount is pinned, and RCU held, so the dentries and
+	inodes won't disappear, neither will our sb or filesystem module.
+	->i_sb and ->d_sb may be used.
+
+	It is a tricky calling convention because it needs to be called under
+	"rcu-walk", ie. without any locks or references on things.
 
   d_delete: called when the last reference to a dentry is dropped and the
 	dcache is deciding whether or not to cache it. Return 1 to delete
Index: linux-2.6/fs/isofs/namei.c
===================================================================
--- linux-2.6.orig/fs/isofs/namei.c	2010-11-09 22:10:59.000000000 +1100
+++ linux-2.6/fs/isofs/namei.c	2010-11-09 22:11:10.000000000 +1100
@@ -37,7 +37,8 @@ isofs_cmp(struct dentry *dentry, const c
 
 	qstr.name = compare;
 	qstr.len = dlen;
-	return dentry->d_op->d_compare(dentry, &dentry->d_name, &qstr);
+	return dentry->d_op->d_compare(NULL, NULL, NULL,
+			dentry->d_name.len, dentry->d_name.name, &qstr);
 }
 
 /*
Index: linux-2.6/include/linux/ncp_fs.h
===================================================================
--- linux-2.6.orig/include/linux/ncp_fs.h	2010-11-09 22:10:58.000000000 +1100
+++ linux-2.6/include/linux/ncp_fs.h	2010-11-09 22:11:10.000000000 +1100
@@ -184,13 +184,13 @@ struct ncp_entry_info {
 	__u8			file_handle[6];
 };
 
-static inline struct ncp_server *NCP_SBP(struct super_block *sb)
+static inline struct ncp_server *NCP_SBP(const struct super_block *sb)
 {
 	return sb->s_fs_info;
 }
 
 #define NCP_SERVER(inode)	NCP_SBP((inode)->i_sb)
-static inline struct ncp_inode_info *NCP_FINFO(struct inode *inode)
+static inline struct ncp_inode_info *NCP_FINFO(const struct inode *inode)
 {
 	return container_of(inode, struct ncp_inode_info, vfs_inode);
 }
Index: linux-2.6/Documentation/filesystems/Locking
===================================================================
--- linux-2.6.orig/Documentation/filesystems/Locking	2010-11-09 22:10:59.000000000 +1100
+++ linux-2.6/Documentation/filesystems/Locking	2010-11-09 23:22:49.000000000 +1100
@@ -11,7 +11,9 @@ be able to use diff(1).
 prototypes:
 	int (*d_revalidate)(struct dentry *, int);
 	int (*d_hash) (struct dentry *, struct qstr *);
-	int (*d_compare) (struct dentry *, struct qstr *, struct qstr *);
+	int (*d_compare)(const struct dentry *,
+			const struct dentry *, const struct inode *,
+			unsigned int, const char *, const struct qstr *);
 	int (*d_delete)(struct dentry *);
 	void (*d_release)(struct dentry *);
 	void (*d_iput)(struct dentry *, struct inode *);
Index: linux-2.6/Documentation/filesystems/porting
===================================================================
--- linux-2.6.orig/Documentation/filesystems/porting	2010-11-09 22:11:10.000000000 +1100
+++ linux-2.6/Documentation/filesystems/porting	2010-11-09 23:22:49.000000000 +1100
@@ -337,3 +337,10 @@ must be done in the RCU callback.
 unreferenced dentries, and is now only called when the dentry refcount goes to
 0. Even on 0 refcount transition, it must be able to tolerate being called 0, 1,
 or more times (eg. constant, idempotent).
+
+---
+[mandatory]
+
+	.d_compare() calling convention and locking rules are significantly
+changed. Read updated documentation in Documentation/filesystems/vfs.txt (and
+look at examples of other filesystems) for guidance.
